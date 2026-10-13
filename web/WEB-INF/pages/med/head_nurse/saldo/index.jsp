<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Склады → Сальдо: остатки по складам и партиям, срок годности --%>
<%@include file="/WEB-INF/pages/med/head_nurse/hn_style.jsp"%>
<jsp:useBean id="now" class="java.util.Date"/>
<style>
  tr.exp td .nm { color:#C0182B; }
  tr.soon td .nm { color:#1F5FBF; }
  .sl-exp { display:inline-block; padding:0 7px; border-radius:6px; font-size:11.5px; font-weight:600; line-height:18px; }
  .sl-exp.bad { background:#FDECEE; color:#A50F22; }
  .sl-exp.soon { background:#E8F1FD; color:#1F5FBF; }
</style>
<c:set var="cntExp" value="0"/><c:set var="cntSoon" value="0"/>
<c:forEach items="${rows}" var="r">
  <c:if test="${r.endDate != null && r.endDate < now}"><c:set var="cntExp" value="${cntExp + 1}"/></c:if>
  <c:if test="${r.endDate != null && r.endDate >= now && r.endDate < month3}"><c:set var="cntSoon" value="${cntSoon + 1}"/></c:if>
</c:forEach>

<iframe name="saldo_excel" style="display:none" src=""></iframe>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-cubes"></i></span>
        <div>
          <h2>Сальдо</h2>
          <span class="fm-count"><b id="sdShown">${fn:length(rows)}</b> из <b>${fn:length(rows)}</b> партий</span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg">
        <button type="button" class="${page_code == 'saldo' ? 'on' : ''}" onclick="sdLoad('saldo')">С остатком</button>
        <button type="button" class="${page_code == 'all' ? 'on' : ''}" onclick="sdLoad('all')">Все</button>
      </div>
      <select class="fm-in fms-select" id="saldo_direction" style="width:220px" onchange="sdLoad()">
        <option value="">Все склады</option>
        <c:forEach items="${receivers}" var="cc">
          <option <c:if test="${filter_direction == cc.direction.id}">selected</c:if> value="${cc.direction.id}">${cc.direction.name}</option>
        </c:forEach>
      </select>
      <button type="button" class="fm-btn" onclick="printSaldo()"><i class="fa fa-file-excel-o"></i>Excel</button>
    </div>
    <div class="fm-toolbar" style="padding-top:0">
      <div class="fm-seg" id="sdSeg">
        <button type="button" data-f="" class="on" onclick="hnSeg('sd', this)">Все сроки</button>
        <button type="button" data-f="exp" onclick="hnSeg('sd', this)">Просрочено · ${cntExp}</button>
        <button type="button" data-f="soon" onclick="hnSeg('sd', this)">Истекает за 3 месяца · ${cntSoon}</button>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="sdSearch" placeholder="Препарат или склад" value="${fn:escapeXml(filter_word)}" oninput="hnFilter('sd')" autocomplete="off"/>
      </div>
    </div>

    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:50px">№</th>
          <th style="width:170px">Склад</th>
          <th>Препарат</th>
          <th style="width:190px" class="nw">Документ</th>
          <th style="width:120px" class="nw">Срок годности</th>
          <th style="width:110px" class="r">Приход</th>
          <th style="width:110px" class="r">Расход</th>
          <th style="width:110px" class="r">Остаток</th>
          <th style="width:90px">Ед. изм.</th>
        </tr>
        </thead>
        <tbody id="sdRows">
        <c:forEach items="${rows}" var="row" varStatus="loop">
          <c:set var="ek" value="${row.endDate == null ? '' : row.endDate < now ? 'exp' : row.endDate < month3 ? 'soon' : ''}"/>
          <tr class="${ek}" data-f="${ek}" data-s="${fn:escapeXml(row.drug)} ${fn:escapeXml(row.direction)} ${row.regNum}" title="ID ${row.id}, препарат ${row.drugId}">
            <td class="mut">${loop.index + 1}</td>
            <td><span class="hn-tag">${row.direction}</span></td>
            <td><span class="nm">${row.drug}</span></td>
            <td class="mut nw">Акт №${row.regNum} от <fmt:formatDate pattern="dd.MM.yyyy" value="${row.regDate}"/></td>
            <td class="nw">
              <c:choose>
                <c:when test="${ek == 'exp'}"><span class="sl-exp bad"><fmt:formatDate pattern="dd.MM.yyyy" value="${row.endDate}"/></span></c:when>
                <c:when test="${ek == 'soon'}"><span class="sl-exp soon"><fmt:formatDate pattern="dd.MM.yyyy" value="${row.endDate}"/></span></c:when>
                <c:otherwise><fmt:formatDate pattern="dd.MM.yyyy" value="${row.endDate}"/></c:otherwise>
              </c:choose>
            </td>
            <td class="r"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${row.drugCount}"/></td>
            <td class="r mut"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${row.rasxod}"/></td>
            <td class="r"><b><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${row.saldo}"/></b></td>
            <td class="mut">${row.measure}</td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="sdEmpty" style="display:none"><i class="fa fa-cubes"></i>Ничего не найдено</div>
    </div>
  </div>
</div>
<script>
  hnFilter('sd');
  var sdCode = '${page_code}';
  function sdQuery() {
    return 'code=' + sdCode + '&direction=' + ($('#saldo_direction').val() || '');
  }
  function sdLoad(code) {
    if (code) sdCode = code;
    setPage('/head_nurse/saldo.s?' + sdQuery());
  }
  function printSaldo() {
    saldo_excel.location = '/head_nurse/saldo/excel.s?' + sdQuery() + '&filter=' + encodeURIComponent($.trim($('#sdSearch').val()));
  }
  $('#sdSearch').focus();
</script>
