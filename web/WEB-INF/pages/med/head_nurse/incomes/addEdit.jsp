<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Склады → Приход → заявка: реквизиты, добавление препаратов, подтверждение и приём на склад --%>
<%@include file="/WEB-INF/pages/med/head_nurse/hn_style.jsp"%>
<c:set var="isNew" value="${obj.id == null || obj.id == 0}"/>
<c:set var="isDraft" value="${isNew || obj.state == 'ENT'}"/>

<div class="hn-page">
  <div class="hn-doc">
    <div class="hn-card">
      <div class="hn-card-h">
        <div>
          <h3>${isNew ? 'Новая заявка на приход' : 'Заявка на приход №'}${isNew ? '' : obj.id}</h3>
          <c:if test="${!isNew}">
            <c:choose>
              <c:when test="${obj.state == 'ENT'}"><span class="hn-st ent">Черновик</span></c:when>
              <c:when test="${obj.state == 'SND'}"><span class="hn-st snd">Отправлено</span></c:when>
              <c:otherwise><span class="hn-st con">Подтверждено</span></c:otherwise>
            </c:choose>
            <c:if test="${obj.insFlag == 'Y'}"><span class="hn-st con">Принято на склад</span></c:if>
          </c:if>
        </div>
        <span class="fm-spacer"></span>
        <c:if test="${isDraft && fn:length(rows) == 0}">
          <button type="button" class="fm-btn primary" onclick="saveAct()"><i class="fa fa-floppy-o"></i>Сохранить</button>
        </c:if>
        <c:if test="${!isNew && obj.state == 'ENT' && fn:length(rows) > 0}">
          <button type="button" class="fm-btn primary" onclick="confirmIncome()"><i class="fa fa-paper-plane"></i>Подтвердить заявку</button>
        </c:if>
        <c:if test="${obj.state == 'CON' && fn:length(rows) > 0 && obj.insFlag != 'Y'}">
          <button type="button" class="fm-btn primary" onclick="updateDrop()"><i class="fa fa-check"></i>Принять на склад</button>
        </c:if>
        <button type="button" class="fm-btn" onclick="setPage('/head_nurse/incomes.s')"><i class="fa fa-arrow-left"></i>Назад</button>
      </div>
      <form id="addEditForm" class="hn-card-b" onsubmit="return false">
        <input type="hidden" name="id" value="${obj.id}">
        <div class="fm-row" style="grid-template-columns:1fr 160px 2fr">
          <div>
            <label class="fm-l">Рег. № <span class="hn-req">*</span></label>
            <input type="text" class="fm-in" id="out_reg_num" name="reg_num" value="${fn:escapeXml(obj.regNum)}" <c:if test="${!isDraft || fn:length(rows) > 0}">readonly</c:if>/>
          </div>
          <div>
            <label class="fm-l">Дата</label>
            <input type="text" readonly class="fm-in" style="text-align:center; background:#F5F6F8" name="reg_date" value="<fmt:formatDate pattern="dd.MM.yyyy" value="${obj.regDate}"/>"/>
          </div>
          <div>
            <label class="fm-l">Получатель <span class="hn-req">*</span></label>
            <select class="fm-in" name="direction" id="out_direction" <c:if test="${!isDraft || fn:length(rows) > 0}">disabled</c:if>>
              <c:forEach items="${directions}" var="cc">
                <option <c:if test="${obj.direction.id == cc.direction.id}">selected</c:if> value="${cc.direction.id}">${cc.direction.name}</option>
              </c:forEach>
            </select>
          </div>
        </div>
        <div>
          <label class="fm-l">Дополнительная информация</label>
          <textarea name="info" class="fm-in" rows="2" <c:if test="${!isDraft || fn:length(rows) > 0}">readonly</c:if>>${fn:escapeXml(obj.info)}</textarea>
        </div>
      </form>
    </div>

    <c:if test="${!isNew && obj.state == 'ENT'}">
      <div class="hn-card">
        <div class="hn-card-h"><h3>Добавить препарат</h3></div>
        <form id="addEditFormRow" class="hn-card-b" onsubmit="saveActRow(); return false">
          <input type="hidden" name="doc" value="${obj.id}"/>
          <div class="fm-row" style="grid-template-columns:1fr 130px 110px auto; align-items:end">
            <div>
              <label class="fm-l">Препарат</label>
              <select class="fm-in fms-select" name="drug_id" id="drug_id" onchange="setDrugCount(this)">
                <option value="">Выберите препарат</option>
                <c:forEach items="${drugs}" var="cc">
                  <option value="${cc.id}" measure="${fn:escapeXml(cc.measure.name)}">${cc.name}</option>
                </c:forEach>
              </select>
            </div>
            <div>
              <label class="fm-l">Количество</label>
              <input type="number" step="any" min="0" id="drug_count" disabled name="drug_count" class="fm-in" style="text-align:center">
            </div>
            <div>
              <label class="fm-l">Ед. изм.</label>
              <input class="fm-in" readonly id="measure" style="background:#F5F6F8"/>
            </div>
            <button type="submit" class="fm-btn primary" style="height:32px"><i class="fa fa-plus"></i>Добавить</button>
          </div>
        </form>
      </div>
    </c:if>

    <c:if test="${fn:length(rows) > 0}">
      <div class="hn-card">
        <div class="hn-card-h"><h3>Препараты</h3><span class="fm-count">· ${fn:length(rows)}</span></div>
        <table class="fm-grid flat">
          <thead>
          <tr>
            <th style="width:40px"></th>
            <th>Наименование</th>
            <th style="width:140px" class="r">В заявке</th>
            <th style="width:110px">Ед. изм.</th>
            <th style="width:140px" class="r">Получено</th>
            <c:if test="${obj.state == 'ENT'}"><th style="width:50px"></th></c:if>
          </tr>
          </thead>
          <tbody>
          <c:forEach items="${rows}" var="row">
            <c:set var="got" value="${row.hndrug != null && row.hndrug > 0}"/>
            <tr>
              <td class="c"><i class="fa ${got ? 'fa-check-circle hn-ok' : 'fa-circle-o hn-no'}" title="${got ? 'На складе' : 'Ещё не на складе'}"></i></td>
              <td><span class="nm">${row.drug.name}</span></td>
              <td class="r"><fmt:formatNumber value="${row.claimCount}" type="number" maxFractionDigits="2"/></td>
              <td class="mut">${row.measure.name}</td>
              <td class="r"><fmt:formatNumber value="${row.drugCount == null ? 0 : row.drugCount}" type="number" maxFractionDigits="2"/></td>
              <c:if test="${obj.state == 'ENT'}">
                <td class="r"><button type="button" class="fm-act danger" title="Удалить" onclick="delActRow(${row.id})"><i class="fa fa-trash-o"></i></button></td>
              </c:if>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </c:if>
  </div>
</div>
<script>
  function hnReload() { setPage('/head_nurse/incomes/save.s?id=${obj.id}'); }
  function hnPost(url, data, okText, after) {
    $.ajax({
      url: url, method: 'post', data: data, dataType: 'json',
      success: function (res) {
        if (res.success) { openMedMsg(okText || 'Данные успешно сохранены', true); (after || hnReload)(res); }
        else errMsg(res.msg);
      }
    });
  }
  function saveAct() {
    if ($.trim($('#out_reg_num').val()) == '' || !($('#out_direction').val() > 0)) { errMsg('Заполните рег. № и получателя'); return; }
    hnPost('/head_nurse/incomes/save.s', $('#addEditForm').serialize(), null, function (res) { setPage('/head_nurse/incomes/save.s?id=' + res.id); });
  }
  function saveActRow() {
    if (!$('#drug_id').val()) { errMsg('Выберите препарат'); return; }
    if (!(parseFloat($('#drug_count').val()) > 0)) { errMsg('Укажите количество больше нуля'); return; }
    hnPost('/head_nurse/incomes/row/save.s', $('#addEditFormRow').serialize(), 'Препарат добавлен');
  }
  function delActRow(id) {
    FmsConfirm('Удалить препарат из заявки?', function () { hnPost('/head_nurse/incomes/row/del.s', 'id=' + id, 'Препарат удалён'); });
  }
  function setDrugCount(dom) {
    $('#drug_count').prop('disabled', !(dom.value > 0));
    var o = dom.options[dom.selectedIndex];
    $('#measure').val(o ? (o.getAttribute('measure') || '') : '');
    if (dom.value > 0) setTimeout(function () { $('#drug_count').focus(); }, 0);
  }
  function confirmIncome() {
    FmsConfirm('Подтвердить заявку? После этого её нельзя будет изменить.', function () { hnPost('/head_nurse/incomes/confirm.s', 'id=${obj.id}', 'Заявка подтверждена'); });
  }
  function updateDrop() {
    FmsConfirm('Принять этот приход на склад?', function () { hnPost('/head_nurse/incomes/drop.s', 'id=${obj.id}', 'Приход принят на склад'); });
  }
</script>
