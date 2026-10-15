<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <title><ui:message code="med"/></title>
  <link rel="icon" type="image/png" href="/res/imgs/logo_fms_mini.png">

  <%-- Библиотеки оставлены: на них завязаны страницы, которые грузятся в #mainWindow --%>
  <link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="/res/bs/metisMenu/metisMenu.min.css" rel="stylesheet">
  <link href="/res/bs/sb_admin/css/timeline.css" rel="stylesheet">
  <link href="/res/bs/sb_admin/css/sb-admin-2.css" rel="stylesheet">
  <link href="/res/bs/morrisjs/morris.css" rel="stylesheet">
  <link href="/res/css/styles.css" rel="stylesheet">
  <link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
  <link href="/res/tinymce/jquery-te-1.4.0.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

  <script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
  <script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
  <script src="/res/bs/metisMenu/metisMenu.min.js"></script>
  <script src="/res/bs/morrisjs/morris.min.js"></script>
  <script src="/res/bs/sb_admin/js/sb-admin-2.js"></script>
  <script src="/res/js/common.js?v=2026101501"></script>
  <script src="/res/js/fms-select.js?v=2026101410"></script>
  <script src="/res/editor/nicEdit.js" type="text/javascript"></script>
  <script src="/res/tinymce/jquery-te-1.4.0.js" type="text/javascript"></script>

  <script>
    function exit(){
      FmsConfirm('<ui:message code="confirmExit" />', function () { document.location = 'out.s'; });
    }
    function openPage(dom){
      $('.leftMenu li').removeClass('active');
      $(dom).addClass('active');
      loadMain(dom.id);
    }
    // page area dims while the page is loading (common.js FmsLoad)
    var mainLoading = null;
    function loadMain(url) {
      if (mainLoading === url) return;
      mainLoading = url;
      if (window.FmsLoad) FmsLoad.page(true);
      // индикатор загрузки снимается всегда, даже если скрипт на открытой странице упал с ошибкой
      $.ajax({url: url, dataType: 'html',
        success: function (html) {
          // ответ на устаревший запрос (пользователь уже открыл другую страницу) не показываем
          if (mainLoading !== url) return;
          mainLoading = null;
          try { $('#mainWindow').html(html); } finally { if (window.FmsLoad) FmsLoad.page(false); }
        },
        error: function () { if (mainLoading !== url) return; mainLoading = null; if (window.FmsLoad) FmsLoad.page(false); }
      });
    }
    function setPage(url){
      loadMain(url);
    }
    function openMainPage(url, isFull) {
      loadMain(url);
      // пустое меню (роли без пунктов) не показываем, даже если страница просит полный вид
      // #tdLeftMenu есть и в карточке пациента: берём меню главной страницы (первое по документу)
      var sb = $(document.getElementById('tdLeftMenu'));
      sb.toggle(!!isFull && sb.find('.leftMenu li').length > 0);
    }
    $(document).ready(function(){
      openMainPage('${openPage}', ${showMenu});
      // автовыход: 15 минут без действий в любой вкладке системы, за минуту предупреждение
      if (window.FmsIdle) FmsIdle.start({limit: 15 * 60 * 1000, warn: 60 * 1000, logout: '/out.s'});
      <c:if test="${session.roleId == 5}">fmsLeaveCheck(); setInterval(fmsLeaveCheck, 5 * 60 * 1000);</c:if>
    });
    // Лечащий врач: с 12:00 дня перед выпиской нужно выбрать, после какого питания уходит пациент.
    // Пока не выбрано, окно закрывает всю систему (выбор прямо в окне или в карточке → Регистрация).
    function fmsLeaveCheck() {
      if (${session.roleId != 5}) return;
      $.ajax({url: '/reg/days/pending.s', dataType: 'json', cache: false, success: function (res) {
        var box = $('#fmsLeave');
        if (!res.success || !res.items || !res.items.length) { box.remove(); return; }
        var esc = function (s) { return $('<div>').text(s == null ? '' : s).html(); };
        var h = '<div class="lv-dlg"><div class="lv-h"><i class="fa fa-sign-out"></i> Укажите время ухода пациентов</div>' +
          '<div class="lv-t">У этих пациентов завтра (или уже) плановая выписка. Выберите, после какого питания пациент уходит в день выписки: ' +
          'от этого зависит питание. Пока время ухода не указано, работа в системе недоступна.</div>';
        $.each(res.items, function (i, p) {
          h += '<div class="lv-row" data-id="' + esc(p.id) + '"><div class="lv-p"><b>' + esc(p.fio) + '</b><span>' + (p.ib ? 'ИБ ' + esc(p.ib) + ' · ' : '') +
            (p.room ? 'палата ' + esc(p.room) + ' · ' : '') + 'выписка ' + esc(p.end) + '</span></div><select class="form-control"><option value="">— после какого питания уходит —</option>';
          $.each(p.options || [], function (j, o) { h += '<option value="' + o.id + '">' + esc(o.name) + '</option>'; });
          h += '</select><button type="button" class="lv-b">Сохранить</button></div>';
        });
        h += '</div>';
        if (!box.length) box = $('<div id="fmsLeave"></div>').appendTo('body');
        box.html(h);
      }});
    }
    $(document).on('click', '#fmsLeave .lv-b', function () {
      var row = $(this).closest('.lv-row'), v = row.find('select').val(), b = $(this);
      if (!v) { errMsg('Выберите, после какого питания уходит пациент.'); return; }
      b.prop('disabled', true);
      $.ajax({url: '/reg/days/leave.s', method: 'post', data: {id: row.attr('data-id'), meal: v}, dataType: 'json',
        success: function (res) { if (res.success) { openMedMsg('Время ухода сохранено', true); fmsLeaveCheck(); } else errMsg(res.msg); },
        complete: function () { b.prop('disabled', false); }});
    });
    function callKeyDown(evt){
      try {
        keyDown(evt);
      }catch (e){}
    }
    function setFilter(evt, isInput){
      let val = encodeURIComponent($('#filterInput').val());
      <c:if test="${isEnterFilter}">
      if((isInput && evt.keyCode == 13) || !isInput) {
        <c:if test="${fn:indexOf(session.curUrl, 'amb') == -1}">
        if ($('#filterInput').val() != '')
          loadMain('patients/index.s?filter=Y&filterInput=' + val);
        else
          loadMain('patients/index.s?filter=Y');
        </c:if>
        <c:if test="${fn:indexOf(session.curUrl, 'amb') != -1}">
        // поиск ищет в списке амбулатории: из карточки пациента (reg.s?id=...) раньше уходил запрос «id=153103?filter=Y» с ошибкой
        var ambUrl = '${session.curUrl}', ambList = (ambUrl.indexOf('/amb/home.s') != -1 || ambUrl.indexOf('/amb/archive.s') != -1) ? ambUrl.split('?')[0] : '/amb/home.s';
        if ($('#filterInput').val() != '')
          loadMain(ambList + '?filter=Y&filterInput=' + val);
        else
          loadMain(ambList + '?filter=Y');
        </c:if>
      }
      </c:if>
      <c:if test="${!isEnterFilter}">
      if ($('#filterInput').val() != '')
        loadMain('patients/index.s?filter=Y&filterInput=' + val);
      else
        loadMain('patients/index.s?filter=Y');
      </c:if>
    }
    function setChangePass(){
      setPage('/admin/changePass.s');
    }
    function setFilterType(){
      document.location = '/main.s?clear=Y';
    }
    $('d').html('*').css('font-weight', 'bold').css('color', 'red');

    // Расширенный поиск: панель уже лежит под строкой поиска, просто показываем/прячем
    function showFilter(e) {
      if (e) e.stopPropagation();
      $('#detailedFilter').toggleClass('open');
    }
    $(document).on('click', function(e){
      if (!$(e.target).closest('.search-box').length) $('#detailedFilter').removeClass('open');
    });
    $(document).on('keydown', function(e){
      if (e.keyCode == 27) $('#detailedFilter').removeClass('open');
    });

    $(document).ready(function(){
      resizeMainWindow();
      $(window).resize(function(){
        resizeMainWindow();
      });
    });
    function resizeMainWindow(){
      var bh = $(window).height() - 60;
      $('#mainWindow').css('height', bh);
      $('#tdLeftMenu').css('height', bh);
    }
    function search() {
      $.ajax({
        url:'/patients/setFilter.s',
        method:'post',
        data:$('#filterForm').serialize(),
        success: function () {
          document.location = '/main.s';
        }
      });
    }
    function searchRefresh(){
      $('input[name=birthBegin]').val('');
      $('input[name=birthEnd]').val('');
      $('input[name=regDateBegin]').val('');
      $('input[name=regDateEnd]').val('');
      $('input[name=vypDateBegin]').val('');
      $('input[name=vypDateEnd]').val('');
      $('select[name=lv_id]').val('');
      $('select[name=dept_id]').val('');
      search();
    }
    function searchAmb() {
      $.ajax({
        url:'/amb/setFilter.s',
        method:'post',
        data:$('#ambFilterForm').serialize(),
        success: function () {
          document.location = '/main.s';
        }
      });
    }
    function searchRefreshAmb(){
      $('input[name=birthBegin]').val('');
      $('input[name=birthEnd]').val('');
      $('input[name=regDateBegin]').val('');
      $('input[name=regDateEnd]').val('');
      $('select[name=group_id]').val('');
      $('select[name=state]').val('');
      $('#filterInput').val('');
      searchAmb(); // было search() — сбрасывался не тот фильтр
    }
    function openReport(id) {
      openMainPage('/rep/home.s?id=' + id, false);
      return false;
    }

    // Свернуть / развернуть боковое меню (запоминается в браузере)
    function toggleSidebar(){
      $('body').toggleClass('sb-collapsed');
      try { localStorage.setItem('fms.sb', $('body').hasClass('sb-collapsed') ? '1' : '0'); } catch (e) {}
    }
    $(function(){
      try { if (localStorage.getItem('fms.sb') == '1') $('body').addClass('sb-collapsed'); } catch (e) {}
    });
  </script>

  <style>
    :root {
      --brand:      #D7182E;
      --brand-dark: #A50F22;
      --brand-soft: #FDECEE;
      --text:       #1F2430;
      --muted:      #6B7280;
      --border:     #E6E8EC;
      --bg:         #F5F6F8;
      --header-h:   60px;
      --sb-w:       240px;
      --sb-w-min:   68px;
    }
    html, body { height: 100%; }
    body {
      margin: 0;
      min-width: 1024px;
      font-family: 'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif;
      color: var(--text);
      background: var(--bg);
      overflow: hidden;
    }
    #wrapper { width: 100%; background: var(--bg); }

    /* ================= Шапка ================= */
    .app-header {
      position: relative;
      z-index: 100;
      display: flex;
      align-items: center;
      height: var(--header-h);
      padding: 0 16px 0 0;
      background: #fff;
      border-bottom: 1px solid var(--border);
    }
    .app-brand {
      display: flex; align-items: center; gap: 10px;
      width: var(--sb-w); height: 100%;
      padding: 0 12px 0 16px;
      transition: width .2s;
    }
    .app-brand .sb-toggle {
      flex: none; width: 36px; height: 36px; border: 0; border-radius: 8px;
      background: transparent; color: var(--muted); font-size: 16px; cursor: pointer;
    }
    .app-brand .sb-toggle:hover { background: #F0F1F4; color: var(--text); }
    .app-brand a { display: flex; align-items: center; text-decoration: none; overflow: hidden; }
    .app-brand .logo-big  { height: 26px; }
    .app-brand .logo-mini { height: 28px; display: none; }

    /* Окно «Укажите время ухода» для лечащего врача: закрывает систему, пока не выбрано */
    #fmsLeave { position: fixed; inset: 0; z-index: 25000; background: rgba(20, 25, 40, .5); display: flex; align-items: center; justify-content: center; }
    #fmsLeave .lv-dlg { width: 760px; max-width: calc(100% - 32px); max-height: 86vh; overflow-y: auto; background: #fff; border-radius: 16px;
      box-shadow: 0 24px 60px rgba(20, 25, 40, .3); padding: 20px 22px; font-family: 'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color: var(--text); }
    #fmsLeave .lv-h { font-size: 17px; font-weight: 700; margin-bottom: 6px; }
    #fmsLeave .lv-h .fa { color: var(--brand); margin-right: 6px; }
    #fmsLeave .lv-t { font-size: 13.5px; color: var(--muted); margin-bottom: 14px; line-height: 1.5; }
    #fmsLeave .lv-row { display: flex; align-items: center; gap: 10px; padding: 10px 0; border-top: 1px solid var(--border); }
    #fmsLeave .lv-p { flex: 1; min-width: 0; }
    #fmsLeave .lv-p b { display: block; font-size: 14px; }
    #fmsLeave .lv-p span { font-size: 12.5px; color: var(--muted); }
    #fmsLeave select { width: 290px; height: 36px; }
    #fmsLeave .lv-b { height: 36px; padding: 0 14px; border: 0; border-radius: 9px; background: #1F2430; color: #fff; font-weight: 600; cursor: pointer; }

    /* Роль рядом с логотипом и переключение ролей (как в nano) */
    .app-role { position: relative; flex: none; min-width: 0; }
    .app-role-btn { display: inline-flex; align-items: center; gap: 8px; max-width: 280px; height: 38px; padding: 0 10px 0 5px;
      border: 1px solid var(--border); border-radius: 10px; background: #fff; color: var(--text) !important; text-decoration: none !important; font-size: 14px; font-weight: 600; }
    a.app-role-btn:hover, .open > .app-role-btn { border-color: var(--brand); background: var(--brand-soft); }
    .app-role-btn.static { cursor: default; }
    .app-role-btn .ri, .app-role-menu .ri { flex: none; width: 28px; height: 28px; border-radius: 8px; display: grid; place-items: center; background: var(--brand-soft); color: var(--brand); font-size: 14px; }
    .app-role-btn .rn { min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
    .app-role-btn .rc { color: var(--muted); }
    .app-role-menu { left: 0; right: auto; min-width: 280px; max-height: 72vh; overflow-y: auto; margin-top: 6px; padding: 6px;
      border: 1px solid var(--border); border-radius: 12px; box-shadow: 0 12px 32px rgba(20, 25, 40, .14); }
    .app-role-menu .rh { padding: 6px 10px 8px; font-size: 12px; font-weight: 600; color: var(--muted); text-transform: uppercase; letter-spacing: .04em; }
    .app-role-menu a { display: flex; align-items: center; gap: 10px; padding: 7px 10px; border-radius: 8px; color: var(--text); font-size: 14px; text-decoration: none; }
    .app-role-menu a:hover, .app-role-menu a:focus { background: var(--brand-soft); color: var(--brand-dark); text-decoration: none; }
    .app-role-menu a .rn { flex: 1; min-width: 0; }
    .app-role-menu a.on { font-weight: 600; }
    .app-role-menu a.on .ri, .app-role-menu a:hover .ri { background: var(--brand); color: #fff; }
    .app-role-menu a .fa-check { color: var(--brand); }
    .app-role-menu a.all { margin-top: 4px; border-top: 1px solid var(--border); border-radius: 0 0 8px 8px; padding-top: 10px; color: var(--muted); }
    @media (max-width: 1300px) { .app-role-btn { max-width: 190px; } }
    @media (max-width: 1100px) { .app-role-btn .rn { display: none; } }

    .app-search { flex: 1; display: flex; justify-content: center; padding: 0 24px; }
    .search-box { position: relative; width: 100%; max-width: 560px; }
    .search-box .s-field {
      display: flex; align-items: center;
      height: 40px;
      background: var(--bg);
      border: 1.5px solid transparent;
      border-radius: 10px;
      transition: border-color .15s, background .15s, box-shadow .15s;
    }
    .search-box .s-field:focus-within {
      background: #fff; border-color: var(--brand); box-shadow: 0 0 0 4px rgba(215,24,46,.10);
    }
    .search-box .s-field > .fa-search { color: #9AA1AC; margin: 0 10px 0 14px; }
    .search-box #filterInput {
      flex: 1; height: 100%; border: 0; background: transparent; box-shadow: none;
      padding: 0; font-size: 14px; font-family: inherit; color: var(--text); outline: none;
    }
    .search-box .s-btn {
      height: 32px; min-width: 32px; margin-right: 4px; padding: 0 10px;
      border: 0; border-radius: 8px; background: transparent; color: var(--muted);
      cursor: pointer; font-size: 13px; white-space: nowrap;
    }
    .search-box .s-btn:hover { background: #E9EBEF; color: var(--text); }
    .search-box .s-btn.go { background: var(--brand); color: #fff; }
    .search-box .s-btn.go:hover { background: var(--brand-dark); }
    .search-box .s-btn.filtered { color: var(--brand); background: var(--brand-soft); }

    /* Панель расширенного поиска */
    #detailedFilter {
      display: none;
      position: absolute; top: calc(100% + 8px); left: 0; right: 0;
      padding: 20px 22px 16px;
      background: #fff;
      border: 1px solid var(--border);
      border-radius: 14px;
      box-shadow: 0 16px 40px rgba(20,25,40,.14);
    }
    #detailedFilter.open { display: block; }
    #detailedFilter h4 { margin: 0 0 16px; font-size: 16px; font-weight: 700; }
    .f-row { display: flex; align-items: center; gap: 12px; margin-bottom: 12px; }
    .f-row > label { flex: 0 0 150px; margin: 0; font-size: 13px; font-weight: 500; color: var(--muted); }
    .f-row .f-ctrl { flex: 1; display: flex; align-items: center; gap: 8px; }
    .f-row .f-ctrl span { color: #B0B5BD; }
    #detailedFilter .form-control {
      height: 36px; border-radius: 8px; border: 1.5px solid var(--border); box-shadow: none; font-size: 14px;
    }
    #detailedFilter .form-control:focus { border-color: var(--brand); box-shadow: 0 0 0 3px rgba(215,24,46,.10); }
    .f-actions { display: flex; justify-content: flex-end; gap: 8px; margin-top: 18px; padding-top: 14px; border-top: 1px solid var(--border); }

    .btn-brand, .btn-ghost {
      height: 36px; padding: 0 18px; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer;
    }
    .btn-brand { border: 0; background: var(--brand); color: #fff; }
    .btn-brand:hover { background: var(--brand-dark); }
    .btn-ghost { border: 1.5px solid var(--border); background: #fff; color: var(--text); }
    .btn-ghost:hover { background: var(--bg); }

    /* Правая часть шапки */
    .app-actions { display: flex; align-items: center; gap: 6px; margin-left: auto; }
    .app-actions .hdr-btn {
      display: flex; align-items: center; gap: 8px;
      height: 40px; padding: 0 12px;
      border: 0; border-radius: 10px; background: transparent;
      color: var(--text); font-size: 14px; font-weight: 500; text-decoration: none; cursor: pointer;
    }
    .app-actions .hdr-btn:hover, .app-actions .open > .hdr-btn { background: #F0F1F4; }
    .app-actions .hdr-btn .fa { color: var(--muted); }
    .app-actions .dropdown-menu {
      margin-top: 8px; padding: 6px; border: 1px solid var(--border); border-radius: 12px;
      box-shadow: 0 16px 40px rgba(20,25,40,.14); max-height: 70vh; overflow-y: auto;
    }
    .app-actions .dropdown-menu > li > a { padding: 9px 12px; border-radius: 8px; white-space: normal; }
    .app-actions .dropdown-menu > li > a:hover { background: var(--brand-soft); color: var(--brand-dark); }
    .app-actions .dropdown-menu .rep-id { display: inline-block; min-width: 34px; color: var(--muted); font-variant-numeric: tabular-nums; }
    .app-actions .sep { width: 1px; height: 28px; background: var(--border); margin: 0 6px; }
    .user-chip .avatar {
      width: 30px; height: 30px; border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      background: var(--brand-soft); color: var(--brand); font-weight: 700; font-size: 13px;
    }
    .hdr-btn.exit:hover { background: var(--brand-soft) !important; color: var(--brand); }
    .hdr-btn.exit:hover .fa { color: var(--brand); }

    /* ================= Тело ================= */
    #content { display: flex; height: calc(100vh - var(--header-h)); }

    #tdLeftMenu {
      flex: none;
      width: var(--sb-w);
      overflow-y: auto; overflow-x: hidden;
      background: #fff;
      border-right: 1px solid var(--border);
      transition: width .2s;
    }
    #tdLeftMenu .leftMenu { list-style: none; margin: 0; padding: 12px 10px; }
    #tdLeftMenu .leftMenu li {
      position: relative;
      display: flex; align-items: center; gap: 12px;
      height: 42px; margin: 2px 0; padding: 0 12px;
      border: 0; border-radius: 10px;
      background: transparent;
      color: #3C4250; font-size: 14px; font-weight: 500;
      white-space: nowrap; overflow: hidden;
      cursor: pointer; user-select: none;
      transition: background .12s, color .12s;
    }
    #tdLeftMenu .leftMenu li > i { flex: none; width: 20px; text-align: center; font-size: 16px; color: #8B92A0; }
    #tdLeftMenu .leftMenu li:hover { background: var(--bg); color: var(--text); }
    #tdLeftMenu .leftMenu li.active { background: var(--brand-soft); color: var(--brand-dark); font-weight: 600; }
    #tdLeftMenu .leftMenu li.active > i { color: var(--brand); }
    #tdLeftMenu .leftMenu li.active::before {
      content: ''; position: absolute; left: -10px; top: 9px; bottom: 9px; width: 4px;
      border-radius: 0 4px 4px 0; background: var(--brand);
    }

    #mainWindow {
      flex: 1; min-width: 0;
      overflow: auto;
      background: #fff;
      padding: 1px;
    }

    /* ================= Свёрнутое меню ================= */
    body.sb-collapsed .app-brand { width: var(--sb-w-min); padding: 0 16px; }
    body.sb-collapsed .app-brand a { display: none; }
    body.sb-collapsed #tdLeftMenu { width: var(--sb-w-min); }
    body.sb-collapsed #tdLeftMenu .leftMenu li { justify-content: center; padding: 0; }
    body.sb-collapsed #tdLeftMenu .leftMenu li .m-name { display: none; }

    @media (max-width: 1300px) {
      .app-brand .logo-big  { display: none; }
      .app-brand .logo-mini { display: block; }
      .app-actions .hdr-btn .lbl { display: none; }
    }

    .app-brand a { flex: 0 0 auto; display: flex; align-items: center; text-decoration: none; }
    .app-brand .logo-big { height: 20px; width: auto; max-width: none; }

    /* ================= Всплывающее сообщение ================= */
    .med-msg {
      position: fixed; top: auto; bottom: 24px; right: 24px; z-index: 2000;
      min-width: 320px; max-width: 520px;
      background: #fff; border: 1px solid var(--border); border-left: 4px solid var(--brand);
      border-radius: 12px; box-shadow: 0 16px 40px rgba(20,25,40,.16);
    }
    .med-msg .mm { display: flex; align-items: flex-start; }
    .med-msg #med-msg-text { flex: 1; padding: 14px 16px; overflow: hidden; font-size: 14px; }
    .med-msg .close-msg {
      flex: none; width: 40px; height: 40px; margin: 4px;
      display: flex; align-items: center; justify-content: center;
      border-radius: 8px; color: var(--muted); cursor: pointer;
    }
    .med-msg .close-msg:hover { background: var(--bg); color: var(--text); }
    /* styles.css красит сообщение в белый текст на цветном фоне; здесь карточка белая, поэтому задаём цвета явно */
    .med-msg, .med-msg.error { background: #fff; color: var(--text); font-weight: 600; text-align: left; border-left-color: #2E9E5B; }
    .med-msg.error { border-left-color: var(--brand); }
    .med-msg #med-msg-text { color: var(--text); }
    .med-msg.error #med-msg-text { color: var(--brand-dark); }
    /* окна bootstrap на старых страницах в общем стиле: скругления, кнопки как в новых формах */
    .modal-content { border:0; border-radius:16px; box-shadow:0 24px 60px rgba(20,25,40,.25); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
    .modal-header { padding:14px 18px; border-bottom:1px solid #E6E8EC; }
    .modal-title { font-size:15px; font-weight:700; color:#1F2430; }
    .modal-footer { display:flex; justify-content:flex-end; gap:8px; padding:12px 18px; border-top:1px solid #E6E8EC; background:#FAFBFC; border-radius:0 0 16px 16px; }
    .modal-footer .btn { height:34px; margin:0 !important; padding:0 16px; border-radius:9px; font-size:13px; font-weight:600; box-shadow:none; }
    .modal-footer .btn-default { background:#fff; border:1px solid #E6E8EC; color:#3C4250; }
    .modal-footer .btn-default:hover { background:#F5F6F8; }
    .modal-footer .btn-primary, .modal-footer .btn-success { background:#1F2430; border:1px solid #1F2430; color:#fff; }
    .modal-footer .btn-primary:hover, .modal-footer .btn-success:hover { background:#353B4A; border-color:#353B4A; }
    .modal .table-bordered > tbody > tr > td { border-color:#EEF0F3; vertical-align:middle; }
    .modal .form-control { border-radius:8px; box-shadow:none; }
    /* выбранная кнопка переключателя не нажимается повторно: страница не перезагружается зря */
    .fm-seg button.on, .pl-seg button.on, .al-seg button.on, .np-seg button.on, .tg-seg button.on { pointer-events:none; cursor:default; }
  </style>
</head>

<body onkeydown="callKeyDown(event)">

<div class="med-msg" style="display: none">
  <div class="mm">
    <div id="med-msg-text"></div>
    <div class="close-msg" title="Закрыть" onclick="closeMedMsg()"><i class="fa fa-times"></i></div>
  </div>
</div>

<div id="wrapper">

  <!-- ================= Шапка ================= -->
  <header class="app-header">
    <div class="app-brand">
      <button type="button" class="sb-toggle" onclick="toggleSidebar()" title="Свернуть меню"><i class="fa fa-bars"></i></button>
      <a href="/setRole.s?id=0" title="Farhod Madad Shifo">
        <img class="logo-big"  src="/res/imgs/logo_fms_h.png"    alt="Farhod Madad Shifo">
        <img class="logo-mini" src="/res/imgs/logo_fms_mini.png" alt="Farhod Madad Shifo">
      </a>
    </div>

    <%-- текущая роль; если ролей несколько — переключение между ними без возврата на страницу выбора (как в nano) --%>
    <c:if test="${curRole != null}">
      <c:choose>
        <c:when test="${fn:length(userRoles) > 1}">
          <div class="dropdown app-role">
            <a class="app-role-btn dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" title="Сменить роль">
              <span class="ri"><i class="${empty curRole.icon ? 'fa fa-user' : curRole.icon}" aria-hidden="true"></i></span>
              <span class="rn"><c:out value="${curRole.name}"/></span>
              <i class="fa fa-angle-down rc" aria-hidden="true"></i>
            </a>
            <div class="dropdown-menu app-role-menu">
              <div class="rh">Сменить роль</div>
              <c:forEach items="${userRoles}" var="r">
                <a href="/setRole.s?id=${r.id}" class="${r.id == curRole.id ? 'on' : ''}">
                  <span class="ri"><i class="${empty r.icon ? 'fa fa-user' : r.icon}" aria-hidden="true"></i></span>
                  <span class="rn"><c:out value="${r.name}"/></span>
                  <c:if test="${r.id == curRole.id}"><i class="fa fa-check" aria-hidden="true"></i></c:if>
                </a>
              </c:forEach>
              <a href="/setRole.s?id=0" class="all"><span class="ri"><i class="fa fa-th-large" aria-hidden="true"></i></span><span class="rn">Все роли</span></a>
            </div>
          </div>
        </c:when>
        <c:otherwise>
          <div class="app-role"><span class="app-role-btn static"><span class="ri"><i class="${empty curRole.icon ? 'fa fa-user' : curRole.icon}" aria-hidden="true"></i></span><span class="rn"><c:out value="${curRole.name}"/></span></span></div>
        </c:otherwise>
      </c:choose>
    </c:if>

    <div class="app-search">
      <c:if test="${showSearch}">
        <div class="search-box">
          <div class="s-field">
            <i class="fa fa-search"></i>
            <input type="text" id="filterInput" onkeyup="setFilter(event, true)" value="${session.filterFio}"
                   placeholder="Поиск пациента по ФИО…" autocomplete="off">
            <button type="button" class="s-btn<c:if test="${session.filtered}"> filtered</c:if>" onclick="showFilter(event)" title="Расширенный поиск">
              <i class="fa fa-sliders"></i>&nbsp;Фильтр
            </button>
            <button type="button" class="s-btn go" onclick="setFilter(event, false)" title="Найти">
              <i class="fa fa-arrow-right"></i>
            </button>
          </div>

          <!-- Расширенный поиск -->
          <div id="detailedFilter">
            <c:if test="${session.roleId != 13 && session.roleId != 14 && session.roleId != 15}">
              <form id="filterForm" onsubmit="search(); return false;">
                <h4>Расширенный поиск</h4>
                <div class="f-row">
                  <label>Год рождения</label>
                  <div class="f-ctrl">
                    <input type="number" name="birthBegin" class="form-control text-center" value="${sessionScope.ENV.filters['birthBegin']}" placeholder="с">
                    <span>—</span>
                    <input type="number" name="birthEnd" class="form-control text-center" value="${sessionScope.ENV.filters['birthEnd']}" placeholder="по">
                  </div>
                </div>
                <div class="f-row">
                  <label>Дата регистрации</label>
                  <div class="f-ctrl">
                    <input type="date" name="regDateBegin" class="form-control" value="${sessionScope.ENV.filters['regDateBegin']}">
                    <span>—</span>
                    <input type="date" name="regDateEnd" class="form-control" value="${sessionScope.ENV.filters['regDateEnd']}">
                  </div>
                </div>
                <div class="f-row">
                  <label>Дата выписки</label>
                  <div class="f-ctrl">
                    <input type="date" name="vypDateBegin" class="form-control" value="${sessionScope.ENV.filters['vypDateBegin']}">
                    <span>—</span>
                    <input type="date" name="vypDateEnd" class="form-control" value="${sessionScope.ENV.filters['vypDateEnd']}">
                  </div>
                </div>
                <div class="f-row">
                  <label>Лечащий врач</label>
                  <div class="f-ctrl">
                    <select class="form-control" name="lv_id">
                      <option value="">Все</option>
                      <c:forEach items="${lvs}" var="lv">
                        <option <c:if test="${sessionScope.ENV.filters['lv_id'] == lv.id}">selected</c:if> value="${lv.id}">${lv.fio}</option>
                      </c:forEach>
                    </select>
                  </div>
                </div>
                <div class="f-row">
                  <label>Отделение</label>
                  <div class="f-ctrl">
                    <select class="form-control" name="dept_id">
                      <option value="">Все</option>
                      <c:forEach items="${depts}" var="dept">
                        <option <c:if test="${sessionScope.ENV.filters['dept_id'] == dept.id}">selected</c:if> value="${dept.id}">${dept.name}</option>
                      </c:forEach>
                    </select>
                  </div>
                </div>
                <div class="f-actions">
                  <button type="button" class="btn-ghost" onclick="searchRefresh()">Очистить</button>
                  <button type="button" class="btn-brand" onclick="search()"><i class="fa fa-search"></i>&nbsp; Найти</button>
                </div>
              </form>
            </c:if>

            <c:if test="${session.roleId == 13 || session.roleId == 14 || session.roleId == 15}">
              <form id="ambFilterForm" onsubmit="searchAmb(); return false;">
                <h4>Расширенный поиск</h4>
                <div class="f-row">
                  <label>Год рождения</label>
                  <div class="f-ctrl">
                    <input type="number" name="birthBegin" class="form-control text-center" value="${sessionScope.ENV.ambFilters['birthBegin']}" placeholder="с">
                    <span>—</span>
                    <input type="number" name="birthEnd" class="form-control text-center" value="${sessionScope.ENV.ambFilters['birthEnd']}" placeholder="по">
                  </div>
                </div>
                <div class="f-row">
                  <label>Дата регистрации</label>
                  <div class="f-ctrl">
                    <input type="date" name="regDateBegin" class="form-control" value="${sessionScope.ENV.ambFilters['regDateBegin']}">
                    <span>—</span>
                    <input type="date" name="regDateEnd" class="form-control" value="${sessionScope.ENV.ambFilters['regDateEnd']}">
                  </div>
                </div>
                <div class="f-row">
                  <label>Группа</label>
                  <div class="f-ctrl">
                    <select class="form-control" name="group_id">
                      <option value="">Все</option>
                      <c:forEach items="${groups}" var="group">
                        <option <c:if test="${sessionScope.ENV.ambFilters['group_id'] == group.id}">selected</c:if> value="${group.id}">${group.name}</option>
                      </c:forEach>
                    </select>
                  </div>
                </div>
                <div class="f-row">
                  <label>Состояние</label>
                  <div class="f-ctrl">
                    <select class="form-control" name="state">
                      <option value="">Все</option>
                      <option <c:if test="${sessionScope.ENV.ambFilters['state'] == 'PRN'}">selected</c:if> value="PRN">Регистрация</option>
                      <option <c:if test="${sessionScope.ENV.ambFilters['state'] == 'CASH'}">selected</c:if> value="CASH">Ожидание оплаты</option>
                      <option <c:if test="${sessionScope.ENV.ambFilters['state'] == 'WORK'}">selected</c:if> value="WORK">Оказание услуг</option>
                      <option <c:if test="${sessionScope.ENV.ambFilters['state'] == 'DONE'}">selected</c:if> value="DONE">Услуги оказаны</option>
                      <option <c:if test="${sessionScope.ENV.ambFilters['state'] == 'ARCH'}">selected</c:if> value="ARCH">Закрыта</option>
                    </select>
                  </div>
                </div>
                <div class="f-actions">
                  <button type="button" class="btn-ghost" onclick="searchRefreshAmb()">Очистить</button>
                  <button type="button" class="btn-brand" onclick="searchAmb()"><i class="fa fa-search"></i>&nbsp; Найти</button>
                </div>
              </form>
            </c:if>
          </div>
        </div>
      </c:if>
    </div>

    <div class="app-actions">
      <c:if test="${fn:length(repList) > 0}">
        <div class="dropdown">
          <a class="hdr-btn dropdown-toggle" data-toggle="dropdown" href="#">
            <i class="fa fa-bar-chart"></i><span class="lbl">Отчёты</span><i class="fa fa-angle-down"></i>
          </a>
          <ul class="dropdown-menu dropdown-menu-right" style="width:460px;">
            <c:forEach items="${repList}" var="r">
              <li><a href="#" onclick="openReport(${r.id});return false;"><span class="rep-id">${r.id}</span> ${r.name}</a></li>
            </c:forEach>
          </ul>
        </div>
      </c:if>

      <span class="sep"></span>

      <a class="hdr-btn user-chip" href="#" onclick="setChangePass(); return false;" title="Сменить пароль">
        <span class="avatar">${fn:toUpperCase(fn:substring(sessionScope.ENV.userName, 0, 1))}</span>
        <span class="lbl">${sessionScope.ENV.userName}</span>
      </a>

      <a class="hdr-btn exit" href="#" onclick="exit(); return false;" title="<ui:message code="exit"/>">
        <i class="fa fa-sign-out"></i><span class="lbl"><ui:message code="exit"/></span>
      </a>
    </div>
  </header>

  <!-- ================= Меню + рабочая область ================= -->
  <div id="content">
    <aside id="tdLeftMenu">
      <ul class="leftMenu">
        <c:forEach items="${menuList}" var="m">
          <li class="${m.state}" onclick="openPage(this)" id="${m.url}" title="${m.name}">
            <i class="${m.icon}"></i><span class="m-name">${m.name}</span>
          </li>
        </c:forEach>
      </ul>
    </aside>
    <main id="mainWindow"></main>
  </div>
</div>

</body>
</html>
