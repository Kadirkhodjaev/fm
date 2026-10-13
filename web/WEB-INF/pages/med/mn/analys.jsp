<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Мониторинг → Анализ склада: расход с прихода, остаток и на сколько недель хватит --%>
<%@include file="/WEB-INF/pages/med/mn/mn_style.jsp"%>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-line-chart"></i></span>
        <div>
          <h2>Анализ склада</h2>
          <span class="fm-count"><b id="anShown">${fn:length(rows)}</b> из <b>${fn:length(rows)}</b> · двойной клик — расчёт по препарату</span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="anSearch" placeholder="Препарат" oninput="mnFilter('an')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn" onclick="mnExcel('anTable', 'analiz-sklada')"><i class="fa fa-file-excel-o"></i>Excel</button>
    </div>
    <div class="fm-table-wrap">
      <table class="mn" id="anTable">
        <thead>
        <tr>
          <th rowspan="2" style="width:50px">№</th>
          <th rowspan="2" class="l">Наименование</th>
          <th rowspan="2">Дата прихода</th>
          <th rowspan="2">Недель</th>
          <th colspan="2" class="g">Общий расход</th>
          <th colspan="2" class="g">Остаток</th>
          <th colspan="2" class="g">Расход за неделю</th>
          <th class="g">Запас</th>
        </tr>
        <tr>
          <th class="g">Кол-во</th><th>Сумма</th>
          <th class="g">Кол-во</th><th>Сумма</th>
          <th class="g">Кол-во</th><th>Сумма</th>
          <th class="g">Недель</th>
        </tr>
        </thead>
        <tbody id="anRows">
        <c:forEach items="${rows}" var="rw" varStatus="loop">
          <fmt:parseNumber var="c3" type="number" value="${rw.c3}"/>
          <fmt:parseNumber var="c5" type="number" value="${rw.c5}"/>
          <fmt:parseNumber var="c7" type="number" value="${rw.c7}"/>
          <fmt:parseNumber var="c9" type="number" value="${rw.c9}"/>
          <tr class="${c3 < 0 || c5 < 0 || c7 < 0 || c9 < 0 ? 'neg' : ''}" data-s="${fn:escapeXml(rw.c10)}" data-id="${rw.ib}" data-name="${fn:escapeXml(rw.c10)}"
              onclick="mnSel(this)" ondblclick="drugAnalys(this)" style="cursor:pointer">
            <td class="m">${loop.index + 1}</td>
            <td><span class="nm">${rw.c10}</span></td>
            <td class="c">${rw.c2}</td>
            <td class="c">${rw.c1}</td>
            <td class="n g">${rw.c3}</td>
            <td class="n m"><fmt:formatNumber value="${rw.c4}" type="number"/></td>
            <td class="n g"><b><fmt:formatNumber value="${rw.c5}" type="number"/></b></td>
            <td class="n m"><fmt:formatNumber value="${rw.c6}" type="number"/></td>
            <td class="n g"><fmt:formatNumber value="${rw.c7}" type="number"/></td>
            <td class="n m"><fmt:formatNumber value="${rw.c8}" type="number"/></td>
            <td class="n g"><b><fmt:formatNumber value="${rw.c9}" type="number"/></b></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="anEmpty" style="display:none"><i class="fa fa-line-chart"></i>Ничего не найдено</div>
    </div>
  </div>
</div>
<%@include file="/WEB-INF/pages/med/mn/drug_modal.jsp"%>
