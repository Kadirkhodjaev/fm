<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Питание → Меню на дату: блюда по приёмам пищи и столам, шаблоны, копирование между столами --%>
<%@include file="/WEB-INF/pages/med/head_nurse/hn_style.jsp"%>
<c:set var="isEnt" value="${menu.state == 'ENT'}"/>
<style>
  .md-grid { display:grid; grid-template-columns:repeat(auto-fill, minmax(330px, 1fr)); gap:12px; padding:12px; align-items:start; }
  .md-card .hn-card-h { padding:10px 12px 10px 16px; }
  .md-card .hn-card-h h3 { flex:1; }
  .md-card .cnt { color:#9AA1AC; font-size:12px; font-weight:600; }
  .md-list { list-style:none; margin:0; padding:4px 0; min-height:38px; }
  .md-list li { display:flex; align-items:center; gap:8px; padding:5px 12px 5px 16px; font-size:13px; }
  .md-list li:hover { background:#F7F8FA; }
  .md-list li span { flex:1; }
  .md-list .none { color:#C0C5CE; font-style:italic; }
  .md-pane { display:none; }
  .md-pane.on { display:block; }
  .md-pick { display:grid; grid-template-columns:5fr 7fr; gap:14px; min-height:0; }
  .md-box { border:1px solid #E6E8EC; border-radius:12px; display:flex; flex-direction:column; min-height:0; max-height:calc(100vh - 260px); }
  .md-box-h { display:flex; align-items:center; gap:8px; padding:10px 12px; border-bottom:1px solid #F0F1F4; font-weight:700; }
  .md-box-b { overflow:auto; flex:1; }
  .md-type { padding:8px 12px 4px; font-size:11px; font-weight:600; color:#9AA1AC; text-transform:uppercase; letter-spacing:.4px; position:sticky; top:0; background:#fff; }
  .md-dish { display:flex; align-items:center; gap:8px; padding:5px 12px; font-size:13px; cursor:pointer; }
  .md-dish:hover { background:#EEF4FF; }
  .md-dish .fa { color:#3B6FE0; }
  .md-dish.in span { color:#9AA1AC; }
  .md-tpl { border:1px solid #E6E8EC; border-radius:12px; margin-bottom:10px; }
  .md-tpl-h { display:flex; align-items:center; gap:8px; padding:8px 12px; font-weight:700; }
  .md-tpl-b { padding:0 12px 10px; display:flex; flex-wrap:wrap; gap:6px; }
  .md-tpl-b span { padding:3px 9px; border:1px solid #E6E8EC; border-radius:7px; background:#FAFBFC; font-size:12.5px; }
</style>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-calendar"></i></span>
        <div>
          <h2>Меню на <fmt:formatDate pattern="dd.MM.yyyy" value="${menu.menuDate}"/></h2>
          <span class="fm-count">блюда по приёмам пищи и столам</span>
        </div>
      </div>
      <span class="hn-st ${isEnt ? 'ent' : 'con'}">${isEnt ? 'Черновик' : 'Подтверждено'}</span>
      <div class="fm-seg" id="mdSeg">
        <c:forEach items="${menuTypes}" var="mt" varStatus="l">
          <button type="button" data-mt="${mt.id}" class="${l.index == 0 ? 'on' : ''}" onclick="mdType(this)">${mt.name}</button>
        </c:forEach>
      </div>
      <span class="fm-spacer"></span>
      <c:if test="${isEnt}">
        <button type="button" class="fm-btn primary" id="mdConfBtn" onclick="confirmEatMenu()"><i class="fa fa-check"></i>Подтвердить</button>
      </c:if>
      <button type="button" class="fm-btn" onclick="setPage('/eats/menu.s')"><i class="fa fa-arrow-left"></i>Назад</button>
    </div>
    <div class="fm-table-wrap" style="background:#F5F6F8; padding:0">
      <c:forEach items="${menuTypes}" var="menuType" varStatus="ml">
        <div class="md-pane${ml.index == 0 ? ' on' : ''}" id="mdPane_${menuType.id}">
          <div class="md-grid">
            <c:forEach items="${menuType.tables}" var="table">
              <div class="hn-card md-card" data-mt="${menuType.id}" data-tb="${table.id}" data-tn="${fn:escapeXml(table.name)}" data-mn="${fn:escapeXml(menuType.name)}">
                <div class="hn-card-h">
                  <h3>${table.name}</h3>
                  <span class="cnt" id="mdCnt_${menuType.id}_${table.id}">${fn:length(table.eats)}</span>
                  <button type="button" class="fm-act" title="Сформировать меню стола" onclick="mdCompose(this)"><i class="fa fa-pencil"></i></button>
                  <button type="button" class="fm-act" title="Копировать на другие столы" onclick="mdCopy(this)"><i class="fa fa-copy"></i></button>
                  <c:if test="${isEnt}">
                    <button type="button" class="fm-act" title="Взять из шаблона" onclick="mdTemplates(this)"><i class="fa fa-download"></i></button>
                  </c:if>
                  <button type="button" class="fm-act md-tplsave" title="Сохранить как шаблон" onclick="mdTplSave(this)"><i class="fa fa-bookmark-o"></i></button>
                </div>
                <ul class="md-list" id="mdList_${menuType.id}_${table.id}"></ul>
              </div>
            </c:forEach>
          </div>
        </div>
      </c:forEach>
    </div>
  </div>
</div>

<%-- формирование меню стола --%>
<div class="fm-overlay" id="mdMdCompose" onclick="if (event.target === this) mdClose('mdMdCompose')">
  <div class="fm-modal" style="width:1100px">
    <div class="fm-modal-head"><h3>Меню стола<span class="sub" id="mdComposeSub"></span></h3><button type="button" class="fm-x" onclick="mdClose('mdMdCompose')"><i class="fa fa-times"></i></button></div>
    <div class="fm-modal-body">
      <div class="md-pick">
        <div class="md-box">
          <div class="md-box-h">Выбрано <span class="fm-count" id="mdSelCnt">0</span></div>
          <div class="md-box-b"><ul class="md-list" id="menu-eat-list"></ul></div>
        </div>
        <div class="md-box">
          <div class="md-box-h">
            <div class="fm-search-wrap" style="flex:1">
              <i class="fa fa-search"></i>
              <input type="text" class="fm-search" style="width:100%" id="mdDishSearch" placeholder="Поиск блюда" oninput="mdDishFilter()" autocomplete="off"/>
            </div>
          </div>
          <div class="md-box-b" id="mdDishes">
            <c:forEach items="${eats}" var="eat">
              <div class="md-dish-grp">
                <div class="md-type">${eat.c1} · ${fn:length(eat.list)}</div>
                <c:forEach items="${eat.list}" var="ee">
                  <div class="md-dish" data-id="${ee.c1}" data-n="${fn:escapeXml(ee.c2)}" data-s="${fn:toLowerCase(fn:escapeXml(ee.c2))}"><i class="fa fa-plus"></i><span>${ee.c2}</span></div>
                </c:forEach>
              </div>
            </c:forEach>
          </div>
        </div>
      </div>
    </div>
    <div class="fm-modal-foot">
      <span style="color:#9AA1AC; font-size:12px">Нажмите на блюдо справа, чтобы добавить; блюда без норм не показываются</span>
      <span class="fm-spacer"></span>
      <button type="button" class="fm-btn" onclick="mdClose('mdMdCompose')">Отмена</button>
      <button type="button" class="fm-btn primary" id="mdComposeBtn" onclick="saveTableEats()"><i class="fa fa-floppy-o"></i>Сохранить</button>
    </div>
  </div>
</div>

<%-- копирование меню стола --%>
<div class="fm-overlay" id="mdMdCopy" onclick="if (event.target === this) mdClose('mdMdCopy')">
  <div class="fm-modal" style="width:560px">
    <div class="fm-modal-head"><h3>Копировать меню<span class="sub" id="mdCopySub"></span></h3><button type="button" class="fm-x" onclick="mdClose('mdMdCopy')"><i class="fa fa-times"></i></button></div>
    <div class="fm-modal-body">
      <div style="color:#6B7280">Меню выбранных столов будет заменено:</div>
      <div class="fm-tgls" id="mdCopyTables">
        <c:forEach items="${tables}" var="tb">
          <label class="fm-tgl" data-tb="${tb.id}"><input type="checkbox" value="${tb.id}"/><span>${tb.name}</span></label>
        </c:forEach>
      </div>
    </div>
    <div class="fm-modal-foot">
      <span class="fm-spacer"></span>
      <button type="button" class="fm-btn" onclick="mdClose('mdMdCopy')">Отмена</button>
      <button type="button" class="fm-btn primary" id="mdCopyBtn" onclick="copyEatSave()"><i class="fa fa-copy"></i>Копировать</button>
    </div>
  </div>
</div>

<%-- сохранение шаблона --%>
<div class="fm-overlay" id="mdMdTplSave" onclick="if (event.target === this) mdClose('mdMdTplSave')">
  <div class="fm-modal" style="width:460px">
    <div class="fm-modal-head"><h3>Сохранить как шаблон<span class="sub" id="mdTplSub"></span></h3><button type="button" class="fm-x" onclick="mdClose('mdMdTplSave')"><i class="fa fa-times"></i></button></div>
    <form onsubmit="sendTableTemplate(); return false">
      <div class="fm-modal-body">
        <div class="fm-err" id="mdTplErr"></div>
        <div><label class="fm-l">Название шаблона *</label><input type="text" class="fm-in" id="template-name-input" maxlength="128" autocomplete="off"/></div>
      </div>
      <div class="fm-modal-foot">
        <span class="fm-spacer"></span>
        <button type="button" class="fm-btn" onclick="mdClose('mdMdTplSave')">Отмена</button>
        <button type="submit" class="fm-btn primary" id="mdTplBtn"><i class="fa fa-floppy-o"></i>Сохранить</button>
      </div>
    </form>
  </div>
</div>

<%-- шаблоны стола --%>
<div class="fm-overlay" id="mdMdTpls" onclick="if (event.target === this) mdClose('mdMdTpls')">
  <div class="fm-modal" style="width:900px">
    <div class="fm-modal-head"><h3>Шаблоны<span class="sub" id="mdTplsSub"></span></h3><button type="button" class="fm-x" onclick="mdClose('mdMdTpls')"><i class="fa fa-times"></i></button></div>
    <div class="fm-modal-body" id="templates-content"></div>
  </div>
</div>
<script>
  var MENU = ${menu.id}, IS_ENT = ${isEnt}, eatRows = {}, tableEats = [], menuTypeId = 0, tableId = 0;
  <c:forEach items="${menuTypes}" var="menuType"><c:forEach items="${menuType.tables}" var="table">eatRows['${menuType.id}_${table.id}'] = ${table.eatJson};
  </c:forEach></c:forEach>
  function mdEsc(t) { return String(t == null ? '' : t).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;'); }
  function mdOpen(id) { $('#' + id).addClass('open'); }
  function mdClose(id) { $('#' + id).removeClass('open'); }
  function mdErr(m) { FmsToast.show(m, 'err'); }
  function mdCard(btn) { var c = $(btn).closest('.md-card'); menuTypeId = +c.attr('data-mt'); tableId = +c.attr('data-tb'); return c; }
  function mdType(b) {
    $(b).addClass('on').siblings().removeClass('on');
    $('.md-pane').removeClass('on');
    $('#mdPane_' + $(b).attr('data-mt')).addClass('on');
    try { sessionStorage.setItem('mdType', $(b).attr('data-mt')); } catch (e) {}
  }
  // блюда стола на карточке
  function mdRender(mt, tb) {
    var rows = eatRows[mt + '_' + tb] || [], h = [];
    for (var i = 0; i < rows.length; i++) {
      h.push('<li><span>' + mdEsc(rows[i].name) + '</span>' + (IS_ENT ? '<button type="button" class="fm-act danger" title="Убрать" onclick="removeEatRow(' + rows[i].row_id + ', ' + mt + ', ' + tb + ')"><i class="fa fa-times"></i></button>' : '') + '</li>');
    }
    $('#mdList_' + mt + '_' + tb).html(h.length ? h.join('') : '<li class="none">Блюда не выбраны</li>');
    $('#mdCnt_' + mt + '_' + tb).text(rows.length);
    $('.md-card[data-mt=' + mt + '][data-tb=' + tb + '] .md-tplsave').toggle(rows.length > 0);
  }
  function updateTypeTableRow(mt, tb) {
    $.ajax({
      url: '/eats/menu/table/eats/get.s', method: 'post', dataType: 'json', data: 'menu=' + MENU + '&table=' + tb + '&menuType=' + mt,
      success: function (res) { if (res.success) { eatRows[mt + '_' + tb] = res.list; mdRender(mt, tb); } else mdErr(res.msg); }
    });
  }
  function removeEatRow(id, mt, tb) {
    FmsConfirm('Убрать блюдо из меню стола?', function () {
      $.ajax({
        url: '/eats/menu/table/row/del.s', method: 'post', data: 'id=' + id, dataType: 'json',
        success: function (res) { if (res.success) updateTypeTableRow(mt, tb); else mdErr(res.msg); }
      });
    }, {danger: true, ok: 'Убрать'});
  }
  // формирование меню стола
  function mdCompose(btn) {
    var c = mdCard(btn);
    tableEats = (eatRows[menuTypeId + '_' + tableId] || []).map(function (r) { return {id: +r.id, name: r.name}; });
    $('#mdComposeSub').text(c.attr('data-mn') + ' · ' + c.attr('data-tn'));
    $('#mdDishSearch').val('');
    mdDishFilter();
    buildMenuRows();
    mdOpen('mdMdCompose');
    $('#mdDishSearch').focus();
  }
  function buildMenuRows() {
    var h = [], ids = {};
    for (var i = 0; i < tableEats.length; i++) {
      ids[tableEats[i].id] = 1;
      h.push('<li><span>' + mdEsc(tableEats[i].name) + '</span><button type="button" class="fm-act danger" title="Убрать" onclick="removeTableEat(' + i + ')"><i class="fa fa-times"></i></button></li>');
    }
    $('#menu-eat-list').html(h.length ? h.join('') : '<li class="none">Выберите блюда справа</li>');
    $('#mdSelCnt').text(tableEats.length);
    $('#mdDishes .md-dish').each(function () { $(this).toggleClass('in', !!ids[$(this).attr('data-id')]); });
  }
  function removeTableEat(i) { tableEats.splice(i, 1); buildMenuRows(); }
  function mdDishFilter() {
    var q = $.trim($('#mdDishSearch').val()).toLowerCase();
    $('#mdDishes .md-dish').each(function () { $(this).toggle(!q || String($(this).attr('data-s')).indexOf(q) >= 0); });
    $('#mdDishes .md-dish-grp').each(function () { $(this).toggle($(this).find('.md-dish:visible').length > 0); });
  }
  $('#mdDishes').on('click', '.md-dish', function () {
    var id = +$(this).attr('data-id'), name = $(this).attr('data-n');
    function add() { tableEats.push({id: id, name: name}); buildMenuRows(); }
    if ($(this).hasClass('in')) FmsConfirm('Это блюдо уже есть в меню стола. Добавить ещё раз?', add, {ok: 'Добавить'});
    else add();
  });
  function saveTableEats() {
    var data = 'menu=' + MENU + '&menu_type=' + menuTypeId + '&table=' + tableId;
    for (var i = 0; i < tableEats.length; i++) data += '&id=' + tableEats[i].id;
    $('#mdComposeBtn').prop('disabled', true);
    $.ajax({
      url: '/eats/menu/table/save.s', method: 'post', data: data, dataType: 'json',
      success: function (res) { if (res.success) { openMsg(res); mdClose('mdMdCompose'); updateTypeTableRow(menuTypeId, tableId); } else mdErr(res.msg); },
      complete: function () { $('#mdComposeBtn').prop('disabled', false); }
    });
  }
  // копирование на другие столы
  function mdCopy(btn) {
    var c = mdCard(btn);
    $('#mdCopySub').text(c.attr('data-mn') + ' · с ' + c.attr('data-tn'));
    $('#mdCopyTables input').prop('checked', false);
    $('#mdCopyTables .fm-tgl').show().filter('[data-tb=' + tableId + ']').hide();
    mdOpen('mdMdCopy');
  }
  function copyEatSave() {
    var ids = $('#mdCopyTables input:checked').map(function () { return 'id=' + this.value; }).get();
    if (!ids.length) { mdErr('Выберите столы'); return; }
    $('#mdCopyBtn').prop('disabled', true);
    $.ajax({
      url: '/eats/menu/copy/eat.s', method: 'post', dataType: 'json',
      data: 'menu=' + MENU + '&menu_type=' + menuTypeId + '&table=' + tableId + '&' + ids.join('&'),
      success: function (res) {
        if (res.success) {
          FmsToast.show('Меню скопировано: ' + res.ids.length, 'ok');
          mdClose('mdMdCopy');
          for (var i = 0; i < res.ids.length; i++) updateTypeTableRow(menuTypeId, res.ids[i]);
        } else mdErr(res.msg);
      },
      complete: function () { $('#mdCopyBtn').prop('disabled', false); }
    });
  }
  // шаблоны
  function mdTplSave(btn) {
    var c = mdCard(btn);
    $('#mdTplSub').text(c.attr('data-mn') + ' · ' + c.attr('data-tn'));
    $('#template-name-input').val('');
    $('#mdTplErr').hide();
    mdOpen('mdMdTplSave');
    $('#template-name-input').focus();
  }
  function sendTableTemplate() {
    var name = $.trim($('#template-name-input').val());
    if (!name) { $('#mdTplErr').text('Укажите название шаблона').show(); return; }
    var rows = eatRows[menuTypeId + '_' + tableId] || [], data = 'menu_type=' + menuTypeId + '&table=' + tableId + '&name=' + encodeURIComponent(name);
    for (var i = 0; i < rows.length; i++) data += '&id=' + rows[i].id;
    $('#mdTplBtn').prop('disabled', true);
    $.ajax({
      url: '/eats/template/save.s', method: 'post', data: data, dataType: 'json',
      success: function (res) { if (res.success) { FmsToast.show('Шаблон сохранён', 'ok'); mdClose('mdMdTplSave'); } else $('#mdTplErr').text(res.msg).show(); },
      complete: function () { $('#mdTplBtn').prop('disabled', false); }
    });
  }
  function mdTemplates(btn) {
    var c = mdCard(btn);
    $('#mdTplsSub').text(c.attr('data-mn') + ' · ' + c.attr('data-tn'));
    $('#templates-content').load('/eats/templates.s', {type: menuTypeId, table: tableId}, function () { mdOpen('mdMdTpls'); });
  }
  function copyTemplate(tempId) {
    FmsConfirm('Заменить меню стола блюдами из шаблона?', function () {
      $.ajax({
        url: '/eats/template/set.s', data: 'menu=' + MENU + '&id=' + tempId, method: 'post', dataType: 'json',
        success: function (res) { if (res.success) { FmsToast.show('Меню взято из шаблона', 'ok'); mdClose('mdMdTpls'); updateTypeTableRow(res.mtId, res.tbId); } else mdErr(res.msg); }
      });
    }, {ok: 'Заменить'});
  }
  function confirmEatMenu() {
    FmsConfirm('Подтвердить меню? После подтверждения убрать блюда нельзя.', function () {
      $('#mdConfBtn').prop('disabled', true);
      $.ajax({
        url: '/eats/menu/confirm.s', data: 'id=' + MENU, method: 'post', dataType: 'json',
        success: function (res) { if (res.success) { FmsToast.show('Меню подтверждено', 'ok'); setPage('/eats/menu.s'); } else { mdErr(res.msg); $('#mdConfBtn').prop('disabled', false); } },
        error: function () { $('#mdConfBtn').prop('disabled', false); }
      });
    }, {ok: 'Подтвердить'});
  }
  (function () {
    $('.md-card').each(function () { mdRender(+$(this).attr('data-mt'), +$(this).attr('data-tb')); });
    var t = null;
    try { t = sessionStorage.getItem('mdType'); } catch (e) {}
    var b = t ? $('#mdSeg button[data-mt=' + Number(t) + ']') : $();
    if (b.length) mdType(b[0]);
  })();
</script>
