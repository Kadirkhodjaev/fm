<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Питание → Заявка: пациенты по столам и меню стола на дату и приём пищи --%>
<%@include file="/WEB-INF/pages/med/head_nurse/hn_style.jsp"%>
<c:set var="noMenu" value="0"/>
<c:set var="patCnt" value="0"/>
<c:forEach items="${list}" var="t">
  <c:set var="patCnt" value="${patCnt + fn:length(t.patients)}"/>
  <c:if test="${fn:length(t.eats) == 0 && fn:length(t.patients) > 0}"><c:set var="noMenu" value="${noMenu + 1}"/></c:if>
</c:forEach>
<c:set var="readOnly" value="${claim.state == 'CON'}"/>
<style>
  .ec-grid { display:grid; grid-template-columns:repeat(auto-fill, minmax(520px, 1fr)); gap:12px; padding:12px; align-items:start; }
  .ec-card .hn-card-h { cursor:pointer; user-select:none; }
  .ec-card .cnt { min-width:26px; height:22px; padding:0 8px; border-radius:11px; display:inline-flex; align-items:center; justify-content:center; font-size:12px; font-weight:700; background:#E9F7EF; color:#1E7B43; }
  .ec-card .cnt.bad { background:#FDECEE; color:#A50F22; }
  .ec-card .cnt.zero { background:#F1F2F4; color:#9AA1AC; }
  .ec-card .chev { color:#9AA1AC; transition:transform .12s; }
  .ec-card.closed .chev { transform:rotate(-90deg); }
  .ec-card.closed .ec-body { display:none; }
  .ec-sec { padding:8px 16px 4px; font-size:11px; font-weight:600; color:#9AA1AC; text-transform:uppercase; letter-spacing:.4px; }
  .ec-eats { display:flex; flex-wrap:wrap; gap:6px; padding:4px 16px 14px; }
  .ec-eat { display:inline-flex; gap:6px; align-items:center; padding:4px 10px; border:1px solid #E6E8EC; border-radius:8px; background:#FAFBFC; font-size:12.5px; }
  .ec-eat i { color:#9AA1AC; font-style:normal; font-size:11.5px; }
  .ec-warn { display:flex; gap:8px; align-items:center; margin:12px 12px 0; padding:10px 14px; border-radius:12px; background:#FDECEE; color:#A50F22; font-weight:600; }
</style>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-cutlery"></i></span>
        <div>
          <h2>Заявка на <fmt:formatDate pattern="dd.MM.yyyy" value="${menu.menuDate}"/> · ${menuType.name}</h2>
          <span class="fm-count">столов <b>${fn:length(list)}</b> · пациентов <b>${patCnt}</b><c:if test="${claim.id == null}"> · новая заявка</c:if></span>
        </div>
      </div>
      <c:if test="${claim.id != null}"><span class="hn-st ${readOnly ? 'con' : 'ent'}">${readOnly ? 'Подтверждена' : 'Черновик'}</span></c:if>
      <span class="fm-spacer"></span>
      <button type="button" class="fm-btn" onclick="ecToggle()" title="Свернуть / развернуть все"><i class="fa fa-compress"></i></button>
      <c:if test="${claim.id != null}">
        <button type="button" class="fm-btn" onclick="setPage('/eats/claim/patients.s?id=${claim.id}')"><i class="fa fa-users"></i>Пациенты</button>
        <button type="button" class="fm-btn" onclick="setPage('/eats/menu/rasxod.s?id=${claim.id}')"><i class="fa fa-calculator"></i>Расходы</button>
      </c:if>
      <c:if test="${!readOnly}">
        <c:if test="${claim.id != null}">
          <button type="button" class="fm-btn" onclick="ecRefresh()" title="Заново взять пациентов и меню"><i class="fa fa-refresh"></i>Обновить</button>
        </c:if>
        <button type="button" class="fm-btn${claim.id == null ? ' primary' : ''}" id="ecSaveBtn" onclick="saveEatClaim()" <c:if test="${noMenu > 0}">disabled title="Не у всех столов настроено меню"</c:if>><i class="fa fa-check"></i>Сохранить</button>
      </c:if>
      <c:if test="${claim.state == 'ENT'}">
        <button type="button" class="fm-btn primary" id="ecConfBtn" onclick="confirmEatClaim()"><i class="fa fa-paper-plane"></i>Подтвердить</button>
      </c:if>
      <button type="button" class="fm-btn" onclick="setPage('/eats/claims.s')"><i class="fa fa-arrow-left"></i>Назад</button>
    </div>
    <div class="fm-table-wrap" style="background:#F5F6F8; padding:0">
      <c:if test="${noMenu > 0}">
        <div class="ec-warn"><i class="fa fa-exclamation-triangle"></i>Меню не настроено для столов: ${noMenu}. Настройте меню на эту дату, затем нажмите «Обновить».</div>
      </c:if>
      <div class="ec-grid">
        <c:forEach items="${list}" var="table">
          <c:set var="pc" value="${fn:length(table.patients)}"/>
          <c:set var="bad" value="${fn:length(table.eats) == 0 && pc > 0}"/>
          <div class="hn-card ec-card${pc == 0 ? ' closed' : ''}">
            <div class="hn-card-h" onclick="$(this).parent().toggleClass('closed')">
              <i class="fa fa-chevron-down chev"></i>
              <h3 style="flex:1">${table.name}</h3>
              <c:if test="${bad}"><span class="hn-st err">меню не настроено</span></c:if>
              <span class="cnt ${bad ? 'bad' : (pc == 0 ? 'zero' : '')}" title="Пациентов">${pc}</span>
            </div>
            <div class="ec-body">
              <c:if test="${pc > 0}">
                <table class="fm-grid">
                  <thead><tr><th style="width:70px">ИБ №</th><th>ФИО</th><th style="width:200px">Отд. / палата</th></tr></thead>
                  <tbody>
                  <c:forEach items="${table.patients}" var="patient">
                    <tr>
                      <td class="mut">${patient.ibNum}</td>
                      <td>${fn:escapeXml(patient.fio)}</td>
                      <td class="mut">${patient.otdPal}</td>
                    </tr>
                  </c:forEach>
                  </tbody>
                </table>
              </c:if>
              <c:if test="${pc == 0}"><div class="ec-sec" style="padding-bottom:10px">Пациентов нет</div></c:if>
              <c:if test="${fn:length(table.eats) > 0}">
                <div class="ec-sec">Меню</div>
                <div class="ec-eats">
                  <c:forEach items="${table.eats}" var="eat">
                    <span class="ec-eat"><i>${eat.typeName}</i>${eat.name}</span>
                  </c:forEach>
                </div>
              </c:if>
            </div>
          </div>
        </c:forEach>
      </div>
      <c:if test="${empty list}"><div class="fm-empty" style="display:block"><i class="fa fa-cutlery"></i>Нет данных по столам</div></c:if>
    </div>
  </div>
</div>
<%-- данные заявки для сохранения (значения экранированы: в ФИО бывают апострофы) --%>
<form id="ecForm" style="display:none">
  <input type="hidden" name="id" value="${claim.id}"/>
  <input type="hidden" name="menu" value="${menu.id}"/>
  <input type="hidden" name="menu_type" value="${menuType.id}"/>
  <c:forEach items="${list}" var="table">
    <input type="hidden" name="table" value="${table.id}"/>
    <c:forEach items="${table.patients}" var="patient">
      <input type="hidden" name="p${table.id}" value="${empty patient.id ? 0 : patient.id}"/>
      <input type="hidden" name="info${table.id}" value="${fn:escapeXml(patient.fio)}"/>
    </c:forEach>
    <c:forEach items="${table.eats}" var="eat">
      <input type="hidden" name="e${table.id}" value="${eat.id}"/>
    </c:forEach>
  </c:forEach>
</form>
<script>
  var EC_NO_MENU = ${noMenu};
  function ecToggle() {
    var open = $('.ec-card:not(.closed)').length > 0;
    $('.ec-card').toggleClass('closed', open);
  }
  function saveEatClaim() {
    if (EC_NO_MENU > 0) { FmsToast.show('Меню не настроено для некоторых столов. Настройте меню и обновите заявку', 'err'); return; }
    $('#ecSaveBtn').prop('disabled', true);
    $.ajax({
      url: '/eats/claim/save.s', method: 'post', data: $('#ecForm').serialize(), dataType: 'json',
      success: function (res) {
        if (res.success) { openMsg(res); setPage('/eats/claims.s'); }
        else { FmsToast.show(res.msg, 'err'); $('#ecSaveBtn').prop('disabled', false); }
      },
      error: function () { $('#ecSaveBtn').prop('disabled', false); }
    });
  }
  function ecRefresh() { setPage('/eats/claim/refresh.s?id=${claim.id}'); }
  function confirmEatClaim() {
    FmsConfirm('Подтвердить заявку? После подтверждения изменить её нельзя.', function () {
      $('#ecConfBtn').prop('disabled', true);
      $.ajax({
        url: '/eats/claim/confirm.s', data: 'id=${claim.id}', method: 'post', dataType: 'json',
        success: function (res) {
          if (res.success) { FmsToast.show('Заявка подтверждена', 'ok'); setPage('/eats/claims.s'); }
          else { FmsToast.show(res.msg, 'err'); $('#ecConfBtn').prop('disabled', false); }
        },
        error: function () { $('#ecConfBtn').prop('disabled', false); }
      });
    }, {ok: 'Подтвердить'});
  }
</script>
