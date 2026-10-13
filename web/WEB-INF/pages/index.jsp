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
  <script src="/res/js/common.js?v=2026101309"></script>
  <script src="/res/js/fms-select.js?v=2026101305"></script>
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
        if ($('#filterInput').val() != '')
          loadMain('${session.curUrl}?filter=Y&filterInput=' + val);
        else
          loadMain('${session.curUrl}?filter=Y');
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
