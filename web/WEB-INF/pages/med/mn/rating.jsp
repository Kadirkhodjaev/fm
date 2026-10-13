<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Мониторинг → Медикаменты: сальдо на начало, приход, расход, сальдо на конец за период --%>
<%@include file="/WEB-INF/pages/med/mn/mn_style.jsp"%>
<c:set var="negCnt" value="0"/>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-medkit"></i></span>
        <div>
          <h2>Медикаменты</h2>
          <span class="fm-count"><b id="rtShown">${fn:length(rows)}</b> из <b>${fn:length(rows)}</b> · движение за период</span>
        </div>
      </div>
      <div class="mn-flt">
        <input id="period_start" type="text" class="fm-in datepicker" value="${period_start}" autocomplete="off"/>
        <span class="dash">—</span>
        <input id="period_end" type="text" class="fm-in datepicker" value="${period_end}" autocomplete="off"/>
        <button type="button" class="fm-btn" onclick="mnPeriod('/mn/drugs.s')"><i class="fa fa-search"></i>Показать</button>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="rtSearch" placeholder="Препарат" oninput="mnFilter('rt')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn" onclick="mnExcel('rtTable', 'medikamenty')"><i class="fa fa-file-excel-o"></i>Excel</button>
      <c:if test="${sessionScope.ENV.userId == 1}">
        <button type="button" class="fm-btn" onclick="window.open('dch/checker.s', '_blank')"><i class="fa fa-check-square-o"></i>Проверка расходов</button>
      </c:if>
    </div>
    <div class="fm-table-wrap">
      <table class="mn" id="rtTable">
        <thead>
        <tr>
          <th rowspan="2" class="l">Наименование</th>
          <th colspan="2" class="g">Сальдо на начало</th>
          <th colspan="2" class="g">Приход</th>
          <th colspan="2" class="g">Расход</th>
          <th colspan="2" class="g">Сальдо на конец</th>
        </tr>
        <tr>
          <th class="g">Кол-во</th><th>Сумма</th>
          <th class="g">Кол-во</th><th>Сумма</th>
          <th class="g">Кол-во</th><th>Сумма</th>
          <th class="g">Кол-во</th><th>Сумма</th>
        </tr>
        </thead>
        <tbody id="rtRows">
        <c:forEach items="${rows}" var="rw">
          <fmt:parseNumber var="c2" type="number" value="${rw.c2}"/>
          <fmt:parseNumber var="c4" type="number" value="${rw.c4}"/>
          <fmt:parseNumber var="c6" type="number" value="${rw.c6}"/>
          <fmt:parseNumber var="c8" type="number" value="${rw.c8}"/>
          <c:set var="neg" value="${c2 < 0 || c4 < 0 || c6 < 0 || c8 < 0}"/>
          <c:if test="${neg}"><c:set var="negCnt" value="${negCnt + 1}"/></c:if>
          <tr class="${neg ? 'neg' : ''}" title="${fn:escapeXml(rw.c10)}" data-s="${fn:escapeXml(rw.c1)}" onclick="mnSel(this)">
            <td><span class="nm">${rw.c1}</span></td>
            <td class="n g"><fmt:formatNumber value="${rw.c2}" type="number"/></td>
            <td class="n m"><fmt:formatNumber value="${rw.c3}" type="number"/></td>
            <td class="n g"><fmt:formatNumber value="${rw.c4}" type="number"/></td>
            <td class="n m"><fmt:formatNumber value="${rw.c5}" type="number"/></td>
            <td class="n g"><fmt:formatNumber value="${rw.c6}" type="number"/></td>
            <td class="n m"><fmt:formatNumber value="${rw.c7}" type="number"/></td>
            <td class="n g"><b><fmt:formatNumber value="${rw.c8}" type="number"/></b></td>
            <td class="n"><fmt:formatNumber value="${rw.c9}" type="number"/></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="rtEmpty" style="display:none"><i class="fa fa-medkit"></i>Ничего не найдено</div>
    </div>
    <c:if test="${negCnt > 0}">
      <div class="fm-toolbar" style="border-top:1px solid #E6E8EC"><span class="mn-sum">Строк с отрицательным остатком или движением: <b style="color:#A50F22">${negCnt}</b> (выделены красным)</span></div>
    </c:if>
  </div>
</div>
