<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Мониторинг → Склад: простой — медикаменты, которые лежат на складах, со сроком годности --%>
<%@include file="/WEB-INF/pages/med/mn/mn_style.jsp"%>
<jsp:useBean id="now" class="java.util.Date"/>
<c:set var="cntExp" value="0"/>
<c:forEach items="${rows}" var="p"><c:if test="${p.dd < now}"><c:set var="cntExp" value="${cntExp + 1}"/></c:if></c:forEach>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-clock-o"></i></span>
        <div>
          <h2>Простой медикаментов</h2>
          <span class="fm-count"><b id="dtShown">${fn:length(rows)}</b> из <b>${fn:length(rows)}</b> · просрочено <b style="color:#A50F22">${cntExp}</b></span>
        </div>
      </div>
      <select class="fm-in fms-select" style="width:220px" onchange="setOrder(null, this.value)">
        <option value="0">Все склады</option>
        <c:forEach items="${directions}" var="d">
          <option <c:if test="${direction == d.id}">selected</c:if> value="${d.id}">${d.name}</option>
        </c:forEach>
      </select>
      <div class="fm-seg">
        <button type="button" class="${order == 'end' ? 'on' : ''}" onclick="setOrder('end', null)">По сроку годности</button>
        <button type="button" class="${order == 'income' ? 'on' : ''}" onclick="setOrder('income', null)">По дате прихода</button>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="dtSearch" placeholder="Препарат или склад" oninput="mnFilter('dt')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn" onclick="mnExcel('dtTable', 'prostoy')"><i class="fa fa-file-excel-o"></i>Excel</button>
    </div>
    <div class="fm-table-wrap">
      <table class="mn" id="dtTable">
        <thead>
        <tr>
          <th class="l" style="width:180px">Склад</th>
          <th class="l">Медикамент</th>
          <th style="width:120px">Приход</th>
          <th style="width:140px">Срок годности</th>
          <th style="width:110px">Кол-во</th>
          <th style="width:110px">Расход</th>
          <th style="width:110px">Остаток</th>
        </tr>
        </thead>
        <tbody id="dtRows">
        <c:forEach items="${rows}" var="p">
          <tr class="${p.dd < now ? 'neg' : ''}" data-s="${fn:escapeXml(p.c1)} ${fn:escapeXml(p.c2)}">
            <td class="m">${p.c1}</td>
            <td><span class="nm">${p.c2}</span></td>
            <td class="c">${p.c3}</td>
            <td class="c">
              <c:choose>
                <c:when test="${sessionScope.ENV.userId == 1}">
                  <input type="text" class="fm-in datepicker" style="height:28px; width:120px" value="${p.c7}" onchange="changeDowntime(${p.id}, this.value)"/>
                </c:when>
                <c:otherwise>${p.c7}</c:otherwise>
              </c:choose>
            </td>
            <td class="n"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${p.c4}"/></td>
            <td class="n m"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${p.c5}"/></td>
            <td class="n"><b><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${p.c6}"/></b></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="dtEmpty" style="display:none"><i class="fa fa-clock-o"></i>Ничего не найдено</div>
    </div>
  </div>
</div>
<script>
  var order = '${order}', direction = '${direction}';
  function setOrder(code, dir) {
    order = code == null ? order : code;
    direction = dir == null ? direction : dir;
    setPage('/mn/drug_downtime.s?order=' + order + '&direction=' + direction);
  }
  function changeDowntime(id, date) {
    $.ajax({
      url: '/mn/downtime.s', method: 'post', data: 'id=' + id + '&date=' + encodeURIComponent(date), dataType: 'json',
      success: function (res) { openMsg(res); }
    });
  }
</script>
