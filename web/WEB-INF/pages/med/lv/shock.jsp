<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Карточка пациента → Экстренный: списание препаратов пациенту с остатков склада (/lv/shock/row/save.s, delete.s) --%>
<%@include file="/WEB-INF/pages/med/lv/frame_style.jsp"%>
<script src="/res/js/fms-select.js?v=2026101305"></script>
<div class="ld-sheet" style="max-width:1000px">
  <div class="ld-title"><i class="fa fa-ambulance" style="color:#D7182E"></i> Экстренный <span class="sub">списание препаратов пациенту</span></div>
  <div class="ld-body">
    <form id="addEditFormRow" onsubmit="saveDrugRow(); return false" style="margin:14px 0 6px">
      <input type="hidden" name="parent" value="${obj.id}"/>
      <div class="fm-row" style="grid-template-columns:minmax(0, 1fr) 130px 130px auto; align-items:end">
        <div>
          <label class="fm-l">Препарат</label>
          <select class="fm-in fms-select" name="drug" id="saldo_id" onchange="setOutDrug(this)">
            <option value="">Выберите препарат</option>
            <c:forEach items="${drugs}" var="cc">
              <option drug-measure="${fn:escapeXml(cc.measure.name)}" drug-saldo="${cc.drugCount - cc.rasxod}" value="${cc.id}">${cc.drug.name} (остаток: ${cc.drugCount - cc.rasxod} ${cc.measure.name})</option>
            </c:forEach>
          </select>
        </div>
        <div>
          <label class="fm-l">Остаток</label>
          <input class="fm-in" type="text" readonly id="drug_saldo" style="text-align:center; background:#F5F6F8">
        </div>
        <div>
          <label class="fm-l">Списать <span id="drug_measure" style="font-weight:400"></span></label>
          <input type="number" step="any" min="0" id="drug_count" name="drug_count" class="fm-in" style="text-align:center">
        </div>
        <button type="submit" class="fm-btn primary" style="height:32px"><i class="fa fa-plus"></i>Списать</button>
      </div>
    </form>
    <c:if test="${empty rows}"><div class="ld-empty">Списаний ещё не было</div></c:if>
    <c:if test="${not empty rows}">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:44px">№</th>
          <th>Склад</th>
          <th>Препарат</th>
          <th style="width:100px" class="r">Расход</th>
          <th style="width:90px">Ед. изм.</th>
          <th>Врач</th>
          <th style="width:130px">Дата и время</th>
          <th style="width:50px"></th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${rows}" var="d" varStatus="lp">
          <tr>
            <td class="mut">${lp.index + 1}</td>
            <td class="mut">${d.hndrug.direction.name}</td>
            <td id="edit_drug_name_${d.id}"><span class="nm">${d.drug.name}</span></td>
            <td class="r"><b>${d.rasxod}</b></td>
            <td id="edit_drug_measure_${d.id}" class="mut">${d.hndrug.measure.name}</td>
            <td>${d.crBy.fio}</td>
            <td class="mut"><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${d.crOn}"/></td>
            <td class="r"><button type="button" class="fm-act danger" title="Удалить" onclick="delOutPatientRow(${d.id})"><i class="fa fa-trash-o"></i></button></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </c:if>
  </div>
</div>
<script>
  function setOutDrug(dom) {
    var o = dom.options[dom.selectedIndex];
    $('#drug_saldo').val(o && dom.value ? o.getAttribute('drug-saldo') : '');
    $('#drug_measure').text(o && dom.value ? '(' + (o.getAttribute('drug-measure') || '') + ')' : '');
    if (dom.value) setTimeout(function () { $('#drug_count').focus(); }, 0);
  }
  function saveDrugRow() {
    var id = $('#saldo_id').val(), count = $('#drug_count').val(), saldo = parseFloat($('#drug_saldo').val());
    if (!id) { FmsToast.show('Выберите препарат', 'info'); return; }
    if (count === '' || parseFloat(count) <= 0) { FmsToast.show('Укажите количество больше нуля', 'info'); $('#drug_count').focus(); return; }
    if (parseFloat(count) > saldo) { FmsToast.show('Нельзя списать больше остатка (' + saldo + ')', 'err'); $('#drug_count').focus(); return; }
    $.ajax({
      url: '/lv/shock/row/save.s', data: 'id=' + id + '&rasxod=' + count, method: 'post', dataType: 'json',
      success: function (res) {
        if (!res.success) { FmsToast.show(res.msg || 'Не удалось сохранить', 'err'); return; }
        FmsToast.show('Списано', 'ok');
        document.location = '/lv/shock.s';
      }
    });
  }
  function delOutPatientRow(id) {
    FmsConfirm('Удалить запись о списании?', function () {
      $.ajax({
        url: '/lv/shock/row/delete.s', data: 'id=' + id, method: 'post', dataType: 'json',
        success: function (res) {
          if (!res.success) { FmsToast.show(res.msg || 'Не удалось удалить', 'err'); return; }
          document.location = '/lv/shock.s';
        }
      });
    }, null, {ok: 'Удалить', danger: true});
  }
</script>
