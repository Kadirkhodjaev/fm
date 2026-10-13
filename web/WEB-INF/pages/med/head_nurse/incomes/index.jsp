<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Склады → Приход: заявки на получение медикаментов из аптеки --%>
<%@include file="/WEB-INF/pages/med/head_nurse/hn_style.jsp"%>
<c:set var="sum" value="0"/><c:set var="cntEnt" value="0"/><c:set var="cntSnd" value="0"/><c:set var="cntCon" value="0"/>
<c:forEach items="${rows}" var="o">
  <c:set var="sum" value="${sum + o.c3}"/>
  <c:if test="${o.c5 == 'ENT'}"><c:set var="cntEnt" value="${cntEnt + 1}"/></c:if>
  <c:if test="${o.c5 == 'SND'}"><c:set var="cntSnd" value="${cntSnd + 1}"/></c:if>
  <c:if test="${o.c5 == 'CON' || empty o.c5}"><c:set var="cntCon" value="${cntCon + 1}"/></c:if>
</c:forEach>

<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-download"></i></span>
        <div>
          <h2>Приход</h2>
          <span class="fm-count"><b id="inShown">${fn:length(rows)}</b> из <b>${fn:length(rows)}</b> заявок</span>
        </div>
      </div>
      <div class="hn-flt">
        <input id="period_start" type="text" class="fm-in datepicker" value="${period_start}" title="С" autocomplete="off"/>
        <span class="dash">—</span>
        <input id="period_end" type="text" class="fm-in datepicker" value="${period_end}" title="По" autocomplete="off"/>
        <select class="fm-in fms-select" id="dr" style="width:220px" onchange="inLoad()">
          <option value="0">Все получатели</option>
          <c:forEach items="${directions}" var="cc">
            <option <c:if test="${filter_direction == cc.direction.id}">selected</c:if> value="${cc.direction.id}">${cc.direction.name}</option>
          </c:forEach>
        </select>
        <button type="button" class="fm-btn" onclick="inLoad()"><i class="fa fa-search"></i>Показать</button>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg">
        <button type="button" class="${ins_flag == '0' ? 'on' : ''}" onclick="inLoad('0')">Все</button>
        <button type="button" class="${ins_flag == 'N' ? 'on' : ''}" onclick="inLoad('N')">Не приняты на склад</button>
        <button type="button" class="${ins_flag == 'Y' ? 'on' : ''}" onclick="inLoad('Y')">Приняты</button>
      </div>
      <button type="button" class="fm-btn primary" onclick="setPage('/head_nurse/incomes/save.s?id=0')"><i class="fa fa-plus"></i>Новая заявка</button>
    </div>
    <div class="fm-toolbar" style="padding-top:0">
      <div class="fm-seg" id="inSeg">
        <button type="button" data-f="" class="on" onclick="hnSeg('in', this)">Все состояния</button>
        <button type="button" data-f="ENT" onclick="hnSeg('in', this)">Черновик · ${cntEnt}</button>
        <button type="button" data-f="SND" onclick="hnSeg('in', this)">Отправлено · ${cntSnd}</button>
        <button type="button" data-f="CON" onclick="hnSeg('in', this)">Подтверждено · ${cntCon}</button>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="inSearch" placeholder="Номер, получатель" oninput="hnFilter('in')" autocomplete="off"/>
      </div>
    </div>

    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:70px">№</th>
          <th>Получатель</th>
          <th>Документ</th>
          <th style="width:80px" class="r">Позиций</th>
          <th style="width:130px" class="r">Сумма</th>
          <th style="width:140px" class="nw">Создана</th>
          <th style="width:140px" class="nw">Отправлена</th>
          <th style="width:140px" class="nw">Подтверждена</th>
          <th style="width:130px">Состояние</th>
          <th style="width:110px">Склад</th>
          <th style="width:50px"></th>
        </tr>
        </thead>
        <tbody id="inRows">
        <c:forEach items="${rows}" var="obj">
          <c:set var="st" value="${obj.c5 == 'ENT' ? 'ENT' : obj.c5 == 'SND' ? 'SND' : 'CON'}"/>
          <tr class="go" data-f="${st}" data-s="${obj.ib} ${fn:escapeXml(obj.c6)} ${fn:escapeXml(obj.c1)}" onclick="setPage('/head_nurse/incomes/save.s?id=${obj.ib}')">
            <td class="mut"><b>${obj.ib}</b></td>
            <td><c:if test="${obj.c11 == 'Y'}"><span class="hn-auto">Авто</span></c:if><span class="nm">${obj.c6}</span></td>
            <td class="mut nw">${obj.c1}</td>
            <td class="r">${obj.c2}</td>
            <td class="r"><fmt:formatNumber value="${obj.c3}" type="number" maxFractionDigits="2"/></td>
            <td class="mut nw">${obj.c7}</td>
            <td class="mut nw">${obj.c8}</td>
            <td class="mut nw">${obj.c9}</td>
            <td>
              <c:choose>
                <c:when test="${st == 'ENT'}"><span class="hn-st ent">Черновик</span></c:when>
                <c:when test="${st == 'SND'}"><span class="hn-st snd">Отправлено</span></c:when>
                <c:otherwise><span class="hn-st con">Подтверждено</span></c:otherwise>
              </c:choose>
            </td>
            <td><span class="hn-st ${obj.c10 == 'Y' ? 'con' : 'off'}">${obj.c10 == 'Y' ? 'Принято' : 'Не принято'}</span></td>
            <td class="r" onclick="event.stopPropagation()">
              <c:if test="${obj.c5 == 'ENT'}">
                <button type="button" class="fm-act danger" title="Удалить заявку" onclick="delDrugRow(${obj.ib})"><i class="fa fa-trash-o"></i></button>
              </c:if>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="inEmpty" style="display:none"><i class="fa fa-download"></i>Заявок за период нет</div>
    </div>
    <div class="hn-foot">
      <span>Заявок: <b>${fn:length(rows)}</b></span>
      <span>Сумма: <b><fmt:formatNumber value="${sum}" type="number" maxFractionDigits="2"/></b></span>
    </div>
  </div>
</div>
<script>
  hnFilter('in');
  function inLoad(ins) {
    setPage('/head_nurse/incomes.s?period_start=' + encodeURIComponent($('#period_start').val()) + '&period_end=' + encodeURIComponent($('#period_end').val()) +
      '&dr=' + $('#dr').val() + '&ins_flag=' + (ins == null ? '${ins_flag}' : ins));
  }
  function delDrugRow(id) {
    FmsConfirm('Удалить заявку №' + id + '?', function () {
    $.ajax({
      url: '/head_nurse/incomes/del.s', method: 'post', data: 'id=' + id, dataType: 'json',
      success: function (res) {
        if (res.success) { openMedMsg('Заявка удалена', true); setPage('/head_nurse/incomes.s'); }
        else errMsg(res.msg);
      }
    });
  });
  }
</script>
