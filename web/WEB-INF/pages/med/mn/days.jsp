<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Мониторинг → Анализ медикаментов для заказа: расход за N дней, средний расход, остаток и запас в днях --%>
<%@include file="/WEB-INF/pages/med/mn/mn_style.jsp"%>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-shopping-cart"></i></span>
        <div>
          <h2>Анализ медикаментов для заказа</h2>
          <span class="fm-count"><b id="dyShown">${fn:length(rows)}</b> из <b>${fn:length(rows)}</b> · расход за последние ${days} дн.</span>
        </div>
      </div>
      <div class="mn-flt">
        <label class="fm-l" style="margin:0">За дней</label>
        <input type="number" min="1" id="dyDays" class="fm-in" value="${days}" style="width:80px" onkeydown="if (event.keyCode == 13) dyLoad()"/>
        <button type="button" class="fm-btn" onclick="dyLoad()"><i class="fa fa-search"></i>Показать</button>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="dySearch" placeholder="Препарат" oninput="mnFilter('dy')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn" onclick="mnExcel('dyTable', 'analiz-dlya-zakaza')"><i class="fa fa-file-excel-o"></i>Excel</button>
    </div>
    <div class="fm-table-wrap">
      <table class="mn" id="dyTable">
        <thead>
        <tr>
          <th rowspan="2" style="width:50px">№</th>
          <th rowspan="2" class="l">Наименование</th>
          <th colspan="2" class="g">Расход</th>
          <th colspan="2" class="g">Среднее в день</th>
          <th colspan="2" class="g">Остаток</th>
          <th class="g">Запас</th>
        </tr>
        <tr>
          <th class="g">Кол-во</th><th>Сумма</th>
          <th class="g">Кол-во</th><th>Сумма</th>
          <th class="g">Кол-во</th><th>Сумма</th>
          <th class="g">Дней</th>
        </tr>
        </thead>
        <tbody id="dyRows">
        <c:forEach items="${rows}" var="rw" varStatus="loop">
          <tr data-s="${fn:escapeXml(rw.c2)}" onclick="mnSel(this)">
            <td class="m">${loop.index + 1}</td>
            <td><span class="nm">${rw.c2}</span></td>
            <td class="n g"><fmt:formatNumber value="${rw.c3}" type="number"/></td>
            <td class="n m"><fmt:formatNumber value="${rw.c4}" type="number"/></td>
            <td class="n g"><fmt:formatNumber value="${rw.c5}" type="number"/></td>
            <td class="n m"><fmt:formatNumber value="${rw.c6}" type="number"/></td>
            <td class="n g"><b><fmt:formatNumber value="${rw.c7}" type="number"/></b></td>
            <td class="n m"><fmt:formatNumber value="${rw.c8}" type="number"/></td>
            <td class="n g"><b><fmt:formatNumber value="${rw.c9}" type="number"/></b></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="dyEmpty" style="display:none"><i class="fa fa-shopping-cart"></i>Ничего не найдено</div>
    </div>
  </div>
</div>
<script>
  function dyLoad() {
    var d = parseInt($('#dyDays').val(), 10);
    if (!(d > 0)) { errMsg('Укажите количество дней больше нуля'); return; }
    setPage('/mn/drugs/days.s?days=' + d);
  }
</script>
