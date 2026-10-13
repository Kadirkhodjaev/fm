<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Амбулаторная регистрация → пакеты услуг: список пакетов, состав выбранного пакета, добавление пациенту --%>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<style>
  .pk-wrap { display:grid; grid-template-columns:1fr 380px; gap:12px; padding:12px; background:#F7F8FA; align-items:start; min-height:100%; }
  .pk-card { background:#fff; border:1px solid #E6E8EC; border-radius:14px; overflow:hidden; }
  .pk-card h4 { margin:0; padding:12px 14px; border-bottom:1px solid #F0F1F4; font-size:14px; font-weight:700; }
  #pkRows tr { cursor:pointer; }
  #pkRows tr.sel td { background:#EEF4FF; }
  .pk-num { text-align:right; white-space:nowrap; font-variant-numeric:tabular-nums; }
  .pk-old { color:#9AA1AC; text-decoration:line-through; }
</style>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-medkit"></i></span>
        <div>
          <h2>Пакеты услуг</h2>
          <span class="fm-count">пакетов <b>${fn:length(packs)}</b> · нажмите на пакет, чтобы увидеть состав</span>
        </div>
      </div>
      <button type="button" class="fm-btn" onclick="openMainPage('/amb/reg.s?id=${id}')"><i class="fa fa-arrow-left"></i>Назад</button>
    </div>
    <div class="fm-table-wrap" style="padding:0">
      <div class="pk-wrap">
        <div class="pk-card">
          <table class="fm-grid">
            <thead>
            <tr>
              <th>Пакет</th>
              <th class="r" style="width:140px">Без скидки</th>
              <th class="r" style="width:140px">Стоимость</th>
              <th class="r" style="width:140px">С НДС</th>
              <th style="width:120px"></th>
            </tr>
            </thead>
            <tbody id="pkRows">
            <c:forEach items="${packs}" var="ser">
              <tr data-id="${ser.id}" data-n="${fn:escapeXml(ser.name)}" onclick="pkShow(this)">
                <td><span class="nm">${ser.name}</span></td>
                <td class="pk-num pk-old"><fmt:formatNumber value="${ser.outCount}" pattern="#,##0.##"/></td>
                <td class="pk-num"><b><fmt:formatNumber value="${ser.price}" pattern="#,##0.##"/></b></td>
                <td class="pk-num"><fmt:formatNumber value="${ser.claimCount}" pattern="#,##0.##"/></td>
                <td class="r" onclick="event.stopPropagation()"><button type="button" class="fm-btn primary" onclick="savePack(${ser.id}, this)"><i class="fa fa-plus"></i>Добавить</button></td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
          <c:if test="${empty packs}"><div class="fm-empty" style="display:block"><i class="fa fa-medkit"></i>Пакетов нет</div></c:if>
        </div>
        <div class="pk-card">
          <h4 id="pack_name">Состав пакета</h4>
          <table class="fm-grid">
            <thead><tr><th>Услуга</th><th class="r" style="width:120px">Стоимость</th></tr></thead>
            <tbody id="tservices"><tr><td colspan="2" class="mut">Выберите пакет слева</td></tr></tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>
<script>
  var pkServices = [];
  <c:forEach items="${packs}" var="pack"><c:forEach items="${pack.list}" var="ser">pkServices.push({id: ${ser.c1}, name: '${fn:escapeXml(ser.c2)}', price: '<fmt:formatNumber value="${ser.price}" pattern="#,##0.##"/>', pack: ${pack.id}});
  </c:forEach></c:forEach>
  function pkShow(tr) {
    var id = +$(tr).attr('data-id'), h = [];
    $(tr).addClass('sel').siblings().removeClass('sel');
    $('#pack_name').text($(tr).attr('data-n'));
    for (var i = 0; i < pkServices.length; i++) if (pkServices[i].pack === id) h.push('<tr><td>' + pkServices[i].name + '</td><td class="pk-num">' + pkServices[i].price + '</td></tr>');
    $('#tservices').html(h.length ? h.join('') : '<tr><td colspan="2" class="mut">В пакете нет услуг</td></tr>');
  }
  function savePack(id, btn) {
    $(btn).prop('disabled', true);
    $.ajax({
      url: '/amb/pack.s', method: 'post', data: 'id=' + id, dataType: 'json',
      success: function (res) {
        if (res.success === false) { FmsToast.show(res.msg || 'Не удалось добавить пакет', 'err'); $(btn).prop('disabled', false); return; }
        openMainPage('/amb/reg.s?id=${id}');
      },
      error: function () { $(btn).prop('disabled', false); }
    });
  }
  if ($('#pkRows tr').length) pkShow($('#pkRows tr')[0]);
</script>
