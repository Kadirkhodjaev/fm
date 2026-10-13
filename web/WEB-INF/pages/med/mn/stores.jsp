<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Мониторинг → Склад: итоги прихода и расхода по складам отделений и детализация по препаратам --%>
<%@include file="/WEB-INF/pages/med/mn/mn_style.jsp"%>
<div class="fm-page" style="height:auto; min-height:100%">
  <div class="fm-box" style="flex:none">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-cubes"></i></span>
        <div>
          <h2>Итоги по складам</h2>
          <span class="mn-sum">Приход <b><fmt:formatNumber value="${prixod}" minFractionDigits="2" maxFractionDigits="2" type="number"/></b> · Расход <b><fmt:formatNumber value="${rasxod}" minFractionDigits="2" maxFractionDigits="2" type="number"/></b> · Разница <b><fmt:formatNumber value="${prixod - rasxod}" minFractionDigits="2" maxFractionDigits="2" type="number"/></b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="stSearch" placeholder="Склад или препарат" oninput="stFilter()" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn" onclick="mnExcel('stTotal', 'itogi-po-skladam')"><i class="fa fa-file-excel-o"></i>Excel</button>
    </div>
    <div style="border-top:1px solid #E6E8EC">
      <table class="mn" id="stTotal">
        <thead>
        <tr><th class="l">Склад</th><th style="width:160px">Приход</th><th style="width:160px">Расход</th><th style="width:160px">Разница</th></tr>
        </thead>
        <tbody>
        <c:forEach items="${rows}" var="rw" varStatus="lp">
          <c:if test="${fn:length(rw.list) > 0}">
            <tr style="cursor:pointer" onclick="document.getElementById('st_${lp.index}').scrollIntoView({behavior:'smooth'})" title="К детализации">
              <td><span class="nm">${rw.fio}</span></td>
              <td class="n"><fmt:formatNumber value="${rw.price}" minFractionDigits="2" maxFractionDigits="2" type="number"/></td>
              <td class="n"><fmt:formatNumber value="${rw.claimCount}" minFractionDigits="2" maxFractionDigits="2" type="number"/></td>
              <td class="n"><b><fmt:formatNumber value="${rw.price - rw.claimCount}" minFractionDigits="2" maxFractionDigits="2" type="number"/></b></td>
            </tr>
          </c:if>
        </c:forEach>
        <tr class="tot">
          <td>Итого</td>
          <td class="n"><fmt:formatNumber value="${prixod}" minFractionDigits="2" maxFractionDigits="2" type="number"/></td>
          <td class="n"><fmt:formatNumber value="${rasxod}" minFractionDigits="2" maxFractionDigits="2" type="number"/></td>
          <td class="n"><fmt:formatNumber value="${prixod - rasxod}" minFractionDigits="2" maxFractionDigits="2" type="number"/></td>
        </tr>
        </tbody>
      </table>
    </div>
  </div>
  <c:forEach items="${rows}" var="rw" varStatus="lp">
    <c:if test="${fn:length(rw.list) > 0}">
      <div class="mn-card st-card" id="st_${lp.index}" data-s="${fn:escapeXml(rw.fio)}">
        <div class="mn-card-h"><i class="fa fa-cube" style="color:#9AA1AC"></i>${rw.fio}<span class="fm-count">· ${fn:length(rw.list)}</span></div>
        <table class="mn">
          <thead>
          <tr>
            <th class="l">Препарат</th>
            <th colspan="3" class="g">Количество: приход / расход / разница</th>
            <th colspan="2" class="g">Сумма: приход / расход</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach items="${rw.list}" var="ll">
            <tr data-s="${fn:escapeXml(ll.c1)}">
              <td>${ll.c1}</td>
              <td class="n g">${ll.c2}</td>
              <td class="n">${ll.c3}</td>
              <td class="n"><b>${ll.c4}</b></td>
              <td class="n g"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${ll.c5}"/></td>
              <td class="n"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${ll.c6}"/></td>
            </tr>
          </c:forEach>
          <tr class="tot">
            <td colspan="4">Итого</td>
            <td class="n g"><fmt:formatNumber value="${rw.price}" minFractionDigits="2" maxFractionDigits="2" type="number"/></td>
            <td class="n"><fmt:formatNumber value="${rw.claimCount}" minFractionDigits="2" maxFractionDigits="2" type="number"/></td>
          </tr>
          </tbody>
        </table>
      </div>
    </c:if>
  </c:forEach>
</div>
<script>
  function stFilter() {
    var q = $.trim($('#stSearch').val()).toLowerCase();
    $('.st-card').each(function () {
      var c = $(this), byStore = !q || String(c.attr('data-s')).toLowerCase().indexOf(q) >= 0, n = 0;
      c.find('tr[data-s]').each(function () {
        var ok = byStore || String($(this).attr('data-s')).toLowerCase().indexOf(q) >= 0;
        $(this).toggle(ok);
        if (ok) n++;
      });
      c.toggle(n > 0);
    });
  }
</script>
