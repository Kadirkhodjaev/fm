<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  /* ---------- Контейнер ---------- */
  .pl-page { --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8; --brand:#D7182E;
    height:100%; box-sizing:border-box; display:flex; flex-direction:column; gap:8px;
    padding:10px 14px; background:var(--bg); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:var(--text); }
  .pl-page * { box-sizing:border-box; }
  .pl-page .panel-body.pl-box { display:flex; flex-direction:column; padding:0; background:#fff; border:1px solid var(--border); border-radius:16px;
    overflow:hidden; box-shadow:0 1px 2px rgba(20,25,40,.04), 0 8px 24px rgba(20,25,40,.06); }

  /* ---------- Шапка ---------- */
  .pl-toolbar { flex:none; display:flex; align-items:center; gap:12px; padding:8px 14px; }
  .pl-title { display:flex; align-items:center; gap:12px; }
  .pl-title .ic { width:30px; height:30px; border-radius:9px; display:flex; align-items:center; justify-content:center;
    background:#EEF1F6; color:#3C4A63; font-size:14px; }
  .pl-title h2 { margin:0; font-size:16px; font-weight:700; line-height:1.2; }
  .pl-count { display:block; margin-top:0; font-size:12.5px; color:var(--muted); font-variant-numeric:tabular-nums; }
  .pl-count b { color:var(--text); font-weight:600; }
  .pl-spacer { flex:1; }

  .pl-select { height:30px; padding:0 30px 0 12px; border:1px solid var(--border); border-radius:9px; background-color:#fff;
    font-size:13px; font-family:inherit; color:var(--text); cursor:pointer; }
  .pl-select:focus { outline:none; border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }

  .pl-pager { display:flex; align-items:center; gap:4px; }
  .pl-pager button { width:30px; height:30px; display:flex; align-items:center; justify-content:center; border:1px solid var(--border); border-radius:9px;
    background:#fff; color:#3C4250; font-size:12px; cursor:pointer; transition:background .12s, border-color .12s; }
  .pl-pager button:hover:not(:disabled) { background:var(--bg); border-color:#D5D8DE; }
  .pl-pager button:disabled { opacity:.4; cursor:default; }
  .pl-pager .pl-page-sel { display:flex; align-items:center; gap:6px; margin:0 4px; font-size:13px; color:var(--muted); font-weight:500; }
  .pl-pager .pl-page-sel .pl-select { padding:0 8px; min-width:64px; text-align:center; }

  /* ---------- Таблица ---------- */
  .pl-table-wrap { flex:1; min-height:0; overflow:auto; border-top:1px solid var(--border); }
  .pl-table-wrap .alert { margin:12px 16px; border-radius:10px; }
  table.grid { width:100%; margin:0; border-collapse:separate; border-spacing:0; font-size:13px; }
  table.grid thead th { position:sticky; top:0; z-index:2; height:32px; padding:0 8px; background:#F8F9FA; border-bottom:1px solid var(--border);
    color:var(--muted); font-size:11px; font-weight:600; text-transform:uppercase; letter-spacing:.3px; text-align:left; white-space:nowrap; user-select:none; }
  table.grid thead th.c { text-align:center; }
  table.grid thead th[class*="sorting"] { cursor:pointer; }
  table.grid thead th[class*="sorting"]:hover { color:var(--text); background:#F0F1F4; }
  table.grid thead th[class*="sorting"]::after { font-family:FontAwesome; content:"\f0dc"; margin-left:6px; opacity:.35; font-size:11px; }
  table.grid thead th.sorting_asc, table.grid thead th.sorting_desc { color:var(--text); }
  table.grid thead th.sorting_asc::after  { content:"\f0de"; opacity:1; }
  table.grid thead th.sorting_desc::after { content:"\f0dd"; opacity:1; }

  table.grid tbody td { height:32px; padding:0 8px; border-bottom:1px solid #F0F1F4; vertical-align:middle; font-variant-numeric:tabular-nums; white-space:nowrap; }
  table.grid tbody td.c { text-align:center; }
  table.grid tbody td.num { color:#B0B5BD; font-size:12px; }
  table.grid tbody td.mut { color:var(--muted); }
  table.grid tbody td.mut b { color:var(--text); font-weight:600; }
  table.grid tbody tr { cursor:pointer; transition:background .08s; }
  table.grid tbody tr:hover td { background:#F8F9FB; }
  table.grid tbody tr.selected td { background:#F1F4F9; }
  table.grid tbody tr.selected td:first-child { box-shadow:inset 3px 0 0 #1F2430; }

  /* Пациент: всё в одну строку */
  table.grid td.fio-td { max-width:0; width:34%; overflow:hidden; text-overflow:ellipsis; }
  table.grid .fio { color:var(--text); font-weight:600; text-decoration:none; }
  table.grid .fio:hover { color:#000; text-decoration:underline; }
  table.grid .st-icon { width:14px; height:14px; vertical-align:middle; }
  table.grid .today { display:inline-block; margin-left:5px; padding:0 6px; border-radius:999px; background:#E8F7EE; color:#15803D; font-size:10.5px; font-weight:700; line-height:16px; vertical-align:1px; }
  table.grid td.none { color:#C3C7CE; }
  table.grid td.cut { max-width:0; overflow:hidden; text-overflow:ellipsis; }
  table.grid .pill { display:inline-block; max-width:100%; padding:1px 7px; border-radius:6px; background:#F1F2F4; color:#3C4250;
    font-size:12px; font-weight:600; line-height:18px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; vertical-align:middle; }
  table.grid td.doc { color:#3C4250; }
  table.grid td.doc .fa { color:#B0B5BD; margin-right:5px; }

  .pl-empty { padding:60px 20px; text-align:center; color:#9AA1AC; }
  .pl-empty .fa { display:block; font-size:36px; margin-bottom:10px; color:#D5D8DE; }

  .pl-hint { flex:none; padding:6px 14px; border-top:1px solid var(--border); background:#FAFBFC; font-size:12px; color:#9AA1AC; }
  .pl-hint kbd { display:inline-block; padding:1px 6px; margin:0 2px; background:#fff; border:1px solid #E0E3E8; border-bottom-width:2px; border-radius:5px;
    color:var(--muted); font-family:inherit; font-size:11px; box-shadow:none; }
  .pl-hint span { margin-right:14px; }

  table.grid th.chk, table.grid td.chk { width:34px; text-align:center; padding:0 4px; }
  table.grid input[type=checkbox] { width:14px; height:14px; margin:0; cursor:pointer; accent-color:#1F2430; vertical-align:middle; }
  .pl-confirm { display:inline-flex; align-items:center; gap:8px; height:30px; padding:0 12px; border:0; border-radius:9px;
    background:var(--brand); color:#fff; font-size:13px; font-weight:600; font-family:inherit; cursor:pointer; }
  .pl-confirm:hover { background:#A50F22; }
  .pl-confirm:disabled { background:#E9EBEF; color:#9AA1AC; cursor:default; }
  .pl-confirm .n { min-width:20px; height:20px; padding:0 6px; border-radius:10px; background:rgba(255,255,255,.25); font-size:12px;
    display:inline-flex; align-items:center; justify-content:center; }
  .pl-confirm:disabled .n { background:#fff; }

  /* ---------- Нижняя панель услуг (роль 7) ---------- */
  .pl-page.split .panel-body.pl-box { flex:1 1 auto; min-height:0; height:auto !important; }
  #kdoList { flex:0 0 38%; min-height:180px; background:#fff; border:1px solid var(--border); border-radius:16px; overflow:auto;
    box-shadow:0 1px 2px rgba(20,25,40,.04), 0 8px 24px rgba(20,25,40,.06); }
</style>
<script>
  $(document).ready(function(){
    <c:if test="${authErr}">
    alert('Время Вашей сессии истекло. Авторизуйтесь ещё раз!');
    parent.location = 'login.s';
    </c:if>
    var fieldId = '${newFieldId}';
    if(fieldId != '') {
      $('.grid thead th').has("id").attr("class", "sorting");
      $('.grid thead th[id=${newFieldId}]').attr("class", "${htmlClass}");
    }
    resizeList();
    $(window).bind("resize", resizeList);

    var selectedRow = getCookie("selectedRow");
    if(selectedRow){
      setRow(selectedRow);
    } else
      setRow(0);

    updateConfirmCount();
    $(document).off('change.pconf').on('change.pconf', '.patientCheckbox, #checkAllBox', updateConfirmCount);
  });

  function resizeList(){
    <c:if test="${roleId != 7 || curUrl == '/patients/archive.s'}">
    $('.panel-body').height($(window).height() - 100);
    </c:if>
    // для роли 7 высоту делит CSS (.pl-page.split): список — всё свободное место, #kdoList — 38%
  }

  function setRow(idx){
    $('.grid tbody tr[class=selected]').attr("class", "");
    var elem = $('.grid tbody tr[q=' + idx + ']');
    elem = elem.attr("id") ? elem : $('.grid tbody tr[q="0"]');
    if(elem.attr("id")){
      elem.attr("class", "selected");
      if (elem[0].scrollIntoView) elem[0].scrollIntoView({block: 'nearest'});
      setCookie("selectedRow", elem.attr("q"));
      if(${roleId == 7}) {
        $('#kdoList').load('/kdo/index.s?id=' + elem.attr("id"));
      }
    } else {
      deleteCookie("selectedRow");
    }
  }

  function addEditPatient(id) {
    if(${roleId != 5 && roleId != 9 && roleId != 8 && roleId != 6 && roleId != 16 && roleId != 7 && roleId != 11 && roleId != 25 && curUrl != '/patients/archive.s'})
      setPage('${addEditUrl}' + id);
    else {
      <c:if test="${sessionScope.ENV.roleId == 13}">
      setPage('${addEditUrl}' + id);
      </c:if>
      <c:if test="${sessionScope.ENV.roleId != 13}">
      openMainPage('${addEditUrl}' + id, false);
      </c:if>
    }
  }

  function checkAll(dom){
    var doms = document.getElementsByClassName("patientCheckbox");
    for(var i=0; i<doms.length; i++)
      doms[i].checked = dom.checked;
    updateConfirmCount();
  }

  function updateConfirmCount(){
    var n = $('.patientCheckbox:checked').length;
    $('#confirmCount').text(n);
    $('#confirmBtn').prop('disabled', n == 0);
  }

  function setSort(column, id){
    setPage('/patients/index.s?action=sort&column=' + column + (id != null ? "&colId=" + id : ""));
  }

  function printPage(){
    alert('Print Page');
  }

  function setPageNum(page){
    setPage('/patients/index.s?action=page&page=' + page);
  }

  function setNav(page){
    if(page == 'prev'){
      <c:if test="${sessionScope.patientGrid.page > 1}">
      setPage('/patients/index.s?action=' + page);
      </c:if>
    }
    if(page == 'begin'){
      <c:if test="${sessionScope.patientGrid.page > 1}">
      setPage('/patients/index.s?action=' + page);
      </c:if>
    }
    if(page == 'next'){
      <c:if test="${sessionScope.patientGrid.page != sessionScope.patientGrid.maxPage}">
      setPage('/patients/index.s?action=' + page);
      </c:if>
    }
    if(page == 'end'){
      <c:if test="${sessionScope.patientGrid.page != sessionScope.patientGrid.maxPage}">
      setPage('/patients/index.s?action=' + page);
      </c:if>
    }
  }

  function keyDown(e) {
    var tag = (document.activeElement && document.activeElement.tagName || '').toLowerCase();
    var typing = tag == 'input' && document.activeElement.type != 'checkbox' || tag == 'textarea' || tag == 'select';

    if(!typing && (e.keyCode == 40 || e.keyCode == 38)) {
      e.preventDefault();
      var idx = parseInt($('.grid tbody tr[class=selected]').attr('q'));
      var next = idx + (e.keyCode == 38 ? -1 : 1);
      if($('.grid tbody tr[q=' + next + ']').attr("q"))
        setRow(next);
    }
    // PgUp / PgDn — раньше вызывалось дважды и перелистывало через страницу
    if(!typing && (e.keyCode == 33 || e.keyCode == 34)) {
      e.preventDefault();
      setNav(e.keyCode == 33 ? 'prev' : 'next');
    }
    if(!typing && (e.keyCode == 35 || e.keyCode == 36)) {
      e.preventDefault();
      setNav(e.keyCode == 35 ? 'end' : 'begin');
    }
    if(e.keyCode == 13) {
      if(typing) return false;
      var id = $('.grid tbody tr[class=selected]').attr("id");
      if (id) addEditPatient(id);
    }
    if(!typing && e.keyCode == 32) {
      e.preventDefault();
      var pId = $('.grid tbody tr[class=selected]').attr("id");
      var doms = document.getElementsByClassName("patientCheckbox");
      for(var d=0;d<doms.length;d++) {
        if(doms[d].value == pId)
          doms[d].checked = !doms[d].checked;
      }
      updateConfirmCount();
    }
  }

  function setConfirmPatient(){
    var vals = '';
    $('.patientCheckbox').each(function(){
      if($(this).is(":checked"))
        vals += 'id=' + $(this).val() + '&';
    });
    if(vals != '')
      setPage('/patients/confirm.s?' + vals);
  }
  function setPatientFlag(flag) {
    setPage('/patients/archive.s?flag=' + flag)
  }
</script>

<c:set var="isArchive" value="${curUrl == '/patients/archive.s'}"/>
<c:set var="showChk" value="${roleId != 7}"/>
<c:set var="canConfirm" value="${((roleId == 3 || roleId == 4 || roleId == 5 || roleId == 6) && curUrl != '/patients/consul.s' && !isArchive) || (roleId == 6 && isArchive)}"/>

<jsp:useBean id="plNow" class="java.util.Date"/>
<fmt:formatDate var="plToday" value="${plNow}" pattern="dd.MM.yyyy"/>
<fmt:formatDate var="plYear" value="${plNow}" pattern="yyyy"/>

<div class="pl-page<c:if test="${roleId == 7 && !isArchive}"> split</c:if>">
  <div class="panel-body pl-box">

    <!-- Шапка -->
    <div class="pl-toolbar">
      <div class="pl-title">
        <span class="ic"><i class="fa <c:choose><c:when test="${isArchive}">fa-archive</c:when><c:when test="${curUrl == '/patients/consul.s'}">fa-stethoscope</c:when><c:otherwise>fa-hospital-o</c:otherwise></c:choose>"></i></span>
        <div>
          <h2><c:choose><c:when test="${isArchive}">Архив</c:when><c:when test="${curUrl == '/patients/consul.s'}">Консультации</c:when><c:otherwise>Стационар</c:otherwise></c:choose></h2>
          <span class="pl-count"><b>${sessionScope.patientGrid.startPos}–${sessionScope.patientGrid.endPos}</b> из <b>${sessionScope.patientGrid.rowCount}</b> пациентов</span>
        </div>
      </div>

      <c:if test="${canConfirm}">
        <button type="button" class="pl-confirm" id="confirmBtn" onclick="setConfirmPatient()" title="Подтвердить отмеченных пациентов" disabled>
          <i class="fa fa-check"></i> Подтвердить <span class="n" id="confirmCount">0</span>
        </button>
      </c:if>

      <span class="pl-spacer"></span>

      <c:if test="${isArchive}">
        <select class="pl-select" onchange="setPatientFlag(this.value)" title="Фильтр архива">
          <option value="0">Все</option>
          <option <c:if test="${flag == 'DONE'}">selected</c:if> value="DONE">С клиентом</option>
          <option <c:if test="${flag == 'UNDONE'}">selected</c:if> value="UNDONE">Без клиента</option>
        </select>
      </c:if>

      <c:if test="${sessionScope.patientGrid.maxPage > 1}">
        <c:set var="isFirst" value="${sessionScope.patientGrid.page == 1}"/>
        <c:set var="isLast"  value="${sessionScope.patientGrid.page == sessionScope.patientGrid.maxPage}"/>
        <div class="pl-pager">
          <button type="button" onclick="setNav('begin')" title="Первая страница (Home)" <c:if test="${isFirst}">disabled</c:if>><i class="fa fa-angle-double-left"></i></button>
          <button type="button" onclick="setNav('prev')"  title="Предыдущая (PgUp)"      <c:if test="${isFirst}">disabled</c:if>><i class="fa fa-angle-left"></i></button>
          <label class="pl-page-sel">
            <select class="pl-select" onchange="setPageNum(this.value)">
              <c:forEach begin="1" end="${sessionScope.patientGrid.maxPage}" var="elem">
                <option <c:if test="${sessionScope.patientGrid.page == elem}">selected</c:if> value="${elem}">${elem}</option>
              </c:forEach>
            </select>
            из ${sessionScope.patientGrid.maxPage}
          </label>
          <button type="button" onclick="setNav('next')" title="Следующая (PgDn)"         <c:if test="${isLast}">disabled</c:if>><i class="fa fa-angle-right"></i></button>
          <button type="button" onclick="setNav('end')"  title="Последняя страница (End)" <c:if test="${isLast}">disabled</c:if>><i class="fa fa-angle-double-right"></i></button>
        </div>
      </c:if>
    </div>

    <!-- Таблица -->
    <div class="pl-table-wrap">
      <%@include file="/incs/msgs/successError.jsp"%>
      <table class="grid">
        <thead>
        <tr>
          <c:if test="${showChk}">
            <th class="chk"><input type="checkbox" id="checkAllBox" onclick="checkAll(this)" title="Отметить всех"/></th>
          </c:if>
          <th class="c" style="width:40px">#</th>
          <th class="c" style="width:26px"></th>
          <th class="sorting" id="thsurname" onclick="setSort('surname', null)">ФИО</th>
          <th style="width:70px">И/Б</th>
          <th class="sorting" id="thbirthyear" onclick="setSort('birthyear', null)" style="width:110px">Г.р.</th>
          <th class="sorting" id="thregdate" onclick="setSort('Date_Begin', null)" style="width:150px">Поступил</th>
          <th style="width:100px">Выписка</th>
          <th style="width:20%">Отд. / палата</th>
          <th class="sorting" id="thlv" onclick="setSort('lv_id', 'lv')" style="width:17%">Лечащий врач</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${list}" var="p" varStatus="loop">
          <tr onclick="setRow(${loop.index})" ondblclick="addEditPatient(${p.id})" id="${p.id}" q="${loop.index}">
            <c:if test="${showChk}">
              <td class="chk" onclick="event.stopPropagation()"><c:if test="${p.showCheckbox}"><input type="checkbox" class="patientCheckbox" value="${p.id}"/></c:if></td>
            </c:if>
            <td class="c num">${sessionScope.patientGrid.startPos + loop.index}</td>
            <td class="c"><img class="st-icon" src="/res/imgs/${p.iconUrl}.gif" alt=""/></td>
            <td class="fio-td" title="${p.fio}"><a href="#" class="fio" onclick="addEditPatient(${p.id}); return false;">${p.fio}</a></td>
            <td class="mut"><b>${p.ibNum}</b></td>
            <td class="mut"><c:if test="${not empty p.birthYear}">${p.birthYear}<c:if test="${p.birthYear > 1900}"> · ${plYear - p.birthYear} л.</c:if></c:if></td>
            <td>${p.dateBegin}<c:if test="${fn:startsWith(p.dateBegin, plToday)}"><span class="today">сегодня</span></c:if></td>
            <c:choose>
              <c:when test="${not empty p.dateEnd}"><td>${p.dateEnd}</td></c:when>
              <c:otherwise><td class="none">—</td></c:otherwise>
            </c:choose>
            <td class="cut"><c:if test="${not empty p.otdPal}"><span class="pill" title="${p.otdPal}">${p.otdPal}</span></c:if></td>
            <td class="cut doc" title="${p.lv}"><c:if test="${not empty p.lv}"><i class="fa fa-user-md"></i>${p.lv}</c:if></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <c:if test="${empty list}">
        <div class="pl-empty"><i class="fa fa-user-o"></i>Пациенты не найдены</div>
      </c:if>
    </div>

    <div class="pl-hint">
      <span><kbd>↑</kbd><kbd>↓</kbd> выбор</span>
      <span><kbd>Enter</kbd> открыть</span>
      <c:if test="${showChk}"><span><kbd>Пробел</kbd> отметить</span></c:if>
      <span><kbd>PgUp</kbd><kbd>PgDn</kbd> страницы</span>
    </div>
  </div>

  <c:if test="${roleId == 7 && !isArchive}">
    <span id="formAction" class="hidden"></span>
    <div id="kdoList"></div>
  </c:if>
</div>
