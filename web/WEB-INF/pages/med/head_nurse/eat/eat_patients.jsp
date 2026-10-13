<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Склады → Питание → заявка: пациенты по столам --%>
<%@include file="/WEB-INF/pages/med/head_nurse/hn_style.jsp"%>
<style>
  .ep-grid { display:grid; grid-template-columns:repeat(auto-fill, minmax(420px, 1fr)); gap:12px; align-items:start; }
  .ep-t { background:#fff; border:1px solid #E6E8EC; border-radius:14px; overflow:hidden; box-shadow:0 1px 2px rgba(20,25,40,.04); }
  .ep-t-h { display:flex; align-items:center; gap:8px; padding:10px 12px; border-bottom:1px solid #F0F1F4; }
  .ep-t-h h4 { margin:0; font-size:14px; font-weight:700; }
  .ep-cnt { min-width:22px; height:20px; padding:0 7px; border-radius:10px; background:#EEF1F6; color:#3C4A63; font-size:12px; font-weight:700; line-height:20px; text-align:center; }
  .ep-row { display:flex; align-items:center; gap:10px; padding:7px 12px; border-bottom:1px solid #F5F6F8; font-size:13px; }
  .ep-row:last-child { border-bottom:0; }
  .ep-row:hover { background:#FAFBFC; }
  .ep-dot { flex:none; width:8px; height:8px; border-radius:50%; background:#2E9E62; }
  .ep-dot.out { background:#D92D3C; }
  .ep-row .tx { flex:1; min-width:0; }
  .ep-row a { color:#1F2430; text-decoration:none; }
  .ep-row a:hover { text-decoration:underline; }
  .ep-row a.new { font-weight:700; }
  .ep-row .fm-act { flex:none; opacity:0; }
  .ep-row:hover .fm-act { opacity:1; }
  .ep-empty { padding:14px 12px; color:#9AA1AC; font-size:13px; }
  .ep-add { display:flex; justify-content:flex-end; padding:8px 12px; border-top:1px solid #F0F1F4; background:#FAFBFC; }
</style>
<c:set var="total" value="0"/>
<c:forEach items="${list}" var="t"><c:set var="total" value="${total + fn:length(t.patients)}"/></c:forEach>

<div class="hn-page">
  <div class="hn-card" style="margin-bottom:12px">
    <div class="hn-card-h">
      <div>
        <h3>Заявка на питание · <fmt:formatDate pattern="dd.MM.yyyy" value="${eat.actDate}"/> · ${eat.menuType.name}</h3>
        <span class="hn-st ${eat.state == 'ENT' ? 'ent' : 'con'}">${eat.state == 'ENT' ? 'Введена' : 'Подтверждена'}</span>
        <span class="fm-count" style="display:inline; margin-left:8px">порций <b>${total}</b> · новых пациентов <b>${newCount}</b></span>
      </div>
      <span class="fm-spacer"></span>
      <button type="button" class="fm-btn" onclick="printEat()"><i class="fa fa-print"></i>Печать</button>
      <button type="button" class="fm-btn" onclick="refreshPage()" title="Пересобрать заявку по текущим пациентам"><i class="fa fa-refresh"></i>Обновить</button>
      <c:if test="${eat.state == 'ENT'}">
        <button type="button" class="fm-btn primary" onclick="confirmEatClaim()"><i class="fa fa-check"></i>Подтвердить</button>
      </c:if>
      <button type="button" class="fm-btn" onclick="setPage('/head_nurse/eats.s')"><i class="fa fa-arrow-left"></i>Назад</button>
    </div>
  </div>

  <div class="ep-grid">
    <c:forEach items="${list}" var="table">
      <div class="ep-t">
        <div class="ep-t-h">
          <h4>${table.name}</h4>
          <span class="ep-cnt">${fn:length(table.patients)}</span>
          <span class="fm-spacer"></span>
          <button type="button" class="fm-act" title="Обновить стол по текущим пациентам" onclick="refreshTable(${table.id})"><i class="fa fa-refresh"></i></button>
        </div>
        <c:forEach items="${table.patients}" var="patient">
          <c:set var="out" value="${patient.dateEnd != null && patient.dateEnd != ''}"/>
          <div class="ep-row">
            <span class="ep-dot ${out ? 'out' : ''}" title="<c:if test="${out}">Выписан: ${patient.dateEnd}</c:if><c:if test="${!out}">В стационаре</c:if>"></span>
            <span class="tx">
              <c:choose>
                <c:when test="${patient.ibNum == null}">${patient.fio}</c:when>
                <c:otherwise><a href="#" class="${patient.dateBegin == 'true' ? 'new' : ''}" onclick="setPage('/head_nurse/eat/patient/edit.s?id=${patient.ibNum}&eat_id=${eat.id}'); return false;">${patient.fio}</a></c:otherwise>
              </c:choose>
            </span>
            <button type="button" class="fm-act danger" title="Убрать из заявки" onclick="delTableRow(${patient.id})"><i class="fa fa-times"></i></button>
          </div>
        </c:forEach>
        <c:if test="${empty table.patients}"><div class="ep-empty">Пока никого</div></c:if>
        <div class="ep-add">
          <button type="button" class="fm-btn" data-name="${fn:escapeXml(table.name)}" onclick="addTableRow(${table.id}, $(this).attr('data-name'))"><i class="fa fa-plus"></i>Добавить</button>
        </div>
      </div>
    </c:forEach>
  </div>
</div>

<div class="fm-overlay" id="epModal" onclick="if (event.target === this) $('#epModal').removeClass('open')">
  <div class="fm-modal" style="width:440px">
    <div class="fm-modal-head">
      <h3>Добавить в <span id="epTable"></span></h3>
      <button type="button" class="fm-x" onclick="$('#epModal').removeClass('open')"><i class="fa fa-times"></i></button>
    </div>
    <form id="addEditForm" name="addEditForm" onsubmit="saveEatForm(); return false">
      <div class="fm-modal-body">
        <input type="hidden" name="eat_id" value="${eat.id}"/>
        <input type="hidden" id="new-patient-table-id" name="table_id" value="0"/>
        <div class="fm-err" id="epErr"></div>
        <div>
          <label class="fm-l">Описание *</label>
          <input name="text" id="patient-desc" type="text" class="fm-in" placeholder="Например: кузатувчи" autocomplete="off"/>
        </div>
        <div style="max-width:140px">
          <label class="fm-l">Количество *</label>
          <input name="counter" id="pat-counter" type="number" min="1" class="fm-in" value="1" style="text-align:center"/>
        </div>
      </div>
      <div class="fm-modal-foot">
        <span class="fm-spacer"></span>
        <button type="button" class="fm-btn" onclick="$('#epModal').removeClass('open')">Отмена</button>
        <button type="submit" class="fm-btn primary"><i class="fa fa-plus"></i>Добавить</button>
      </div>
    </form>
  </div>
</div>

<script>
  function epPost(url, data, okText) {
    $.ajax({
      url: url, method: 'post', data: data, dataType: 'json',
      success: function (res) {
        if (res.success) { openMedMsg(okText, true); setPage('/head_nurse/eat.s?id=${eat.id}'); }
        else errMsg(res.msg);
      }
    });
  }
  function addTableRow(id, name) {
    document.addEditForm.reset();
    $('#new-patient-table-id').val(id);
    $('#epTable').text(name);
    $('#epErr').hide();
    $('#epModal').addClass('open');
    $('#patient-desc').focus();
  }
  function saveEatForm() {
    if (!$.trim($('#patient-desc').val()) || !(parseInt($('#pat-counter').val(), 10) > 0)) {
      $('#epErr').text('Заполните описание и количество больше нуля').show();
      return;
    }
    $('#epModal').removeClass('open');
    epPost('/head_nurse/eat/patient/save.s', $('#addEditForm').serialize(), 'Добавлено');
  }
  function refreshPage() {
    FmsConfirm('Пересобрать заявку по текущим пациентам? Ручные изменения будут потеряны.', function () { epPost('/head_nurse/eat/refresh.s', 'id=${eat.id}', 'Заявка обновлена'); });
  }
  function confirmEatClaim() {
    FmsConfirm('Подтвердить заявку на питание?', function () { epPost('/head_nurse/eat/confirm.s', 'id=${eat.id}', 'Заявка подтверждена'); });
  }
  function delTableRow(id) {
    FmsConfirm('Убрать запись из заявки?', function () { epPost('/head_nurse/eat/patient/del.s', 'id=' + id, 'Запись удалена'); });
  }
  function refreshTable(table) {
    FmsConfirm('Обновить стол по текущим пациентам? Ручные изменения по этому столу будут потеряны.', function () { epPost('/head_nurse/eat/table/refresh.s', 'id=' + table + '&eat=${eat.id}', 'Стол обновлён'); });
  }
  function printEat() { window.open('/head_nurse/eat/print.s?id=${eat.id}'); }
</script>
