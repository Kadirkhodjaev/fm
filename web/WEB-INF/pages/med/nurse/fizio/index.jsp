<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<style>
  .fz-filters { display:flex; align-items:center; flex-wrap:wrap; gap:8px; }
  .fz-filters .fm-in { width:auto; height:30px; }
  table.fm-grid td.pt { vertical-align:top; padding-top:10px; border-right:1px solid #F0F1F4; }
  table.fm-grid tr.gr-first td { border-top:2px solid #E6E8EC; }
  .fz-pal { display:inline-block; margin-top:3px; padding:0 7px; border-radius:6px; background:#EEF1F6; color:#3C4A63; font-size:11.5px; font-weight:600; line-height:18px; }
  .fz-st { display:inline-flex; padding:2px; background:#F1F2F4; border-radius:9px; }
  .fz-st button { height:26px; padding:0 9px; border:0; border-radius:7px; background:none; color:#6B7280; font-size:12px; font-weight:600; font-family:inherit; cursor:pointer; white-space:nowrap; }
  .fz-st button:hover { color:#1F2430; }
  .fz-st button.on { color:#fff; box-shadow:0 1px 2px rgba(20,25,40,.12); }
  .fz-st button.on[data-v=Y] { background:#2E9E62; }
  .fz-st button.on[data-v=N] { background:#fff; color:#1F2430; }
  .fz-st button.on[data-v=P] { background:#D97706; }
  .fz-st button.on[data-v=V] { background:#6B7280; }
  .fz-st.saving { opacity:.6; pointer-events:none; }
  .fz-cmt { color:#6B7280; font-size:12.5px; }
</style>

<c:set var="cnt" value="0"/><c:set var="cntY" value="0"/>
<c:forEach items="${rows}" var="rw"><c:forEach items="${rw.list}" var="rs">
  <c:set var="cnt" value="${cnt + 1}"/><c:if test="${rs.c3 == 'Y'}"><c:set var="cntY" value="${cntY + 1}"/></c:if>
</c:forEach></c:forEach>

<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-medkit"></i></span>
        <div>
          <h2>Физиотерапия</h2>
          <span class="fm-count">процедур <b>${cnt}</b> · пришли <b>${cntY}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fz-filters">
        <input name="dated" id="dated" type="text" onchange="fzGo()" class="fm-in datepicker" value="${dated}" title="Дата"/>
        <select id="fzRoom" class="fm-in" title="Комната" onchange="fzGo()">
          <option value="0">Все комнаты</option>
          <c:forEach items="${rooms}" var="rm">
            <option <c:if test="${room == rm.name}">selected</c:if> value="${rm.name}">Комната ${rm.name}</option>
          </c:forEach>
        </select>
        <select id="fzKdo" class="fm-in" title="Процедура" onchange="fzGo()" style="max-width:220px">
          <option <c:if test="${kdoId == '0'}">selected</c:if> value="0">Все процедуры</option>
          <c:forEach items="${kdos}" var="kdo">
            <option <c:if test="${kdoId == kdo.value.id}">selected</c:if> value="${kdo.value.id}">${kdo.value.name}</option>
          </c:forEach>
        </select>
        <select id="fzPat" class="fm-in" title="Пациент" onchange="fzGo()" style="max-width:240px">
          <option <c:if test="${patId == '0'}">selected</c:if> value="0">Все пациенты</option>
          <c:forEach items="${patients}" var="pat">
            <option <c:if test="${patId == pat.id}">selected</c:if> value="${pat.id}">${pat.fio}</option>
          </c:forEach>
        </select>
        <select id="patient_status" title="Статус" class="fm-in" onchange="fzGo()">
          <option <c:if test="${status == '0'}">selected</c:if> value="0">Все статусы</option>
          <option <c:if test="${status == 'Y'}">selected</c:if> value="Y">Пришел</option>
          <option <c:if test="${status == 'N'}">selected</c:if> value="N">Не пришел</option>
          <option <c:if test="${status == 'V'}">selected</c:if> value="V">Отмена врача</option>
          <option <c:if test="${status == 'P'}">selected</c:if> value="P">Отказ</option>
        </select>
      </div>
    </div>

    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:40px" class="c">№</th>
          <th style="width:260px">Пациент</th>
          <th style="width:90px" class="c">Комната</th>
          <th>Процедура</th>
          <th>Комментарий врача</th>
          <th style="width:330px">Статус</th>
          <th style="width:130px">Отмечено</th>
        </tr>
        </thead>
        <tbody>
        <c:set var="oper" value="${0}"/>
        <c:forEach items="${rows}" var="rw">
          <c:if test="${fn:length(rw.list) > 0}">
            <c:set var="oper" value="${oper + 1}"/>
            <c:forEach items="${rw.list}" var="rs" varStatus="ls">
              <tr class="${ls.first && oper > 1 ? 'gr-first' : ''}">
                <c:if test="${ls.first}">
                  <td class="c mut pt" rowspan="${fn:length(rw.list)}">${oper}</td>
                  <td class="pt" rowspan="${fn:length(rw.list)}">
                    <span class="nm">${rw.fio}</span><br/>
                    <span class="fz-pal">Палата ${rw.name}</span>
                  </td>
                </c:if>
                <td class="c">${rs.c7}</td>
                <td>${rs.c1}</td>
                <td class="fz-cmt">${rs.c2}</td>
                <td>
                  <span class="fz-st" data-id="${rs.id}">
                    <button type="button" data-v="Y" class="${rs.c3 == 'Y' ? 'on' : ''}">Пришел</button>
                    <button type="button" data-v="N" class="${rs.c3 == 'N' || empty rs.c3 ? 'on' : ''}">Не пришел</button>
                    <button type="button" data-v="P" class="${rs.c3 == 'P' ? 'on' : ''}">Отказ</button>
                    <button type="button" data-v="V" class="${rs.c3 == 'V' ? 'on' : ''}">Отмена врача</button>
                  </span>
                </td>
                <td class="mut">${rs.c4}</td>
              </tr>
            </c:forEach>
          </c:if>
        </c:forEach>
        </tbody>
      </table>
      <c:if test="${oper == 0}">
        <div class="fm-empty"><i class="fa fa-medkit"></i>На эту дату процедур нет</div>
      </c:if>
    </div>
  </div>
</div>
<script>
  function fzGo() {
    setPage('/nurses/fizio.s?dated=' + encodeURIComponent($('#dated').val()) +
      '&room=' + encodeURIComponent($('#fzRoom').val()) + '&kdo=' + $('#fzKdo').val() +
      '&patient=' + $('#fzPat').val() + '&status=' + $('#patient_status').val());
  }
  $('.fz-st button').on('click', function () {
    var b = $(this), box = b.parent();
    if (b.hasClass('on')) return;
    box.addClass('saving');
    $.ajax({
      url: '/nurses/fizio.s', method: 'post', dataType: 'json',
      data: {id: box.data('id'), type: b.data('v')},
      success: function (res) {
        if (res.success) {
          box.find('button').removeClass('on');
          b.addClass('on');
        } else errMsg(res.msg);
      },
      complete: function () { box.removeClass('saving'); }
    });
  });
</script>
