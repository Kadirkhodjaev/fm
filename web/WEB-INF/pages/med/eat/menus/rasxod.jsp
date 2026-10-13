<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Питание → заявка → расход продуктов по нормам блюд и количество порций --%>
<%@include file="/WEB-INF/pages/med/head_nurse/hn_style.jsp"%>
<script src="/res/js/tableToExcel.js" type="text/javascript"></script>
<c:set var="portions" value="0"/>
<c:forEach items="${eats}" var="d"><c:set var="portions" value="${portions + d.c3}"/></c:forEach>
<style>
  .er-wrap { display:grid; grid-template-columns:3fr 2fr; gap:12px; padding:12px; align-items:start; }
  .er-num { text-align:right; white-space:nowrap; font-variant-numeric:tabular-nums; }
  @media print { .fm-toolbar .fm-btn, .fm-search-wrap { display:none !important; } .er-wrap { display:block; } }
</style>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-calculator"></i></span>
        <div>
          <h2>Расходы · <fmt:formatDate pattern="dd.MM.yyyy" value="${claim.menu.menuDate}"/> · ${claim.menuType.name}</h2>
          <span class="fm-count">продуктов <b>${fn:length(products)}</b> · блюд <b>${fn:length(eats)}</b> · порций <b><fmt:formatNumber value="${portions}" pattern="#,##0"/></b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="erSearch" placeholder="Продукт или блюдо" oninput="erFilter()" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn" onclick="erExcel()"><i class="fa fa-file-excel-o"></i>Excel</button>
      <button type="button" class="fm-btn" onclick="setPage('/eats/claim.s?id=${claim.id}')"><i class="fa fa-arrow-left"></i>Назад</button>
    </div>
    <div class="fm-table-wrap" style="background:#F5F6F8; padding:0">
      <div class="er-wrap">
        <div class="hn-card">
          <div class="hn-card-h"><h3 style="flex:1">Расход продуктов</h3><span class="fm-count">по нормам блюд</span></div>
          <table class="fm-grid" id="erProducts">
            <thead><tr><th style="width:50px">№</th><th>Продукт</th><th class="r" style="width:140px">Количество</th><th style="width:110px">Ед. изм.</th></tr></thead>
            <tbody>
            <c:forEach items="${products}" var="r" varStatus="loop">
              <tr data-s="${fn:toLowerCase(fn:escapeXml(r.c2))}">
                <td class="mut">${loop.index + 1}</td>
                <td>${r.c2}</td>
                <td class="er-num"><b><fmt:formatNumber value="${r.c3}" pattern="#,##0.###"/></b></td>
                <td class="mut">${r.c4}</td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
          <c:if test="${empty products}"><div class="fm-empty" style="display:block"><i class="fa fa-cubes"></i>Расхода нет</div></c:if>
        </div>
        <div class="hn-card">
          <div class="hn-card-h"><h3 style="flex:1">Количество блюд</h3><span class="fm-count">порций <b><fmt:formatNumber value="${portions}" pattern="#,##0"/></b></span></div>
          <table class="fm-grid" id="erEats">
            <thead><tr><th style="width:50px">№</th><th>Блюдо</th><th class="r" style="width:110px">Порций</th></tr></thead>
            <tbody>
            <c:forEach items="${eats}" var="d" varStatus="loop">
              <tr data-s="${fn:toLowerCase(fn:escapeXml(d.c2))}">
                <td class="mut">${loop.index + 1}</td>
                <td>${d.c2}</td>
                <td class="er-num"><b><fmt:formatNumber value="${d.c3}" pattern="#,##0"/></b></td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
          <c:if test="${empty eats}"><div class="fm-empty" style="display:block"><i class="fa fa-cutlery"></i>Блюд нет</div></c:if>
        </div>
      </div>
    </div>
  </div>
</div>
<script>
  function erFilter() {
    var q = $.trim($('#erSearch').val()).toLowerCase();
    $('#erProducts tbody tr, #erEats tbody tr').each(function () { $(this).toggle(!q || String($(this).attr('data-s')).indexOf(q) >= 0); });
  }
  // Excel: обе таблицы на одном листе
  function erExcel() {
    var t = document.createElement('table');
    t.innerHTML = '<tr><td colspan="4"><b>Расход продуктов</b></td></tr>' + document.getElementById('erProducts').innerHTML +
      '<tr><td colspan="4"></td></tr><tr><td colspan="4"><b>Количество блюд</b></td></tr>' + document.getElementById('erEats').innerHTML;
    if (window.TableToExcel) TableToExcel.convert(t, {name: 'rasxod_<fmt:formatDate pattern="dd.MM.yyyy" value="${claim.menu.menuDate}"/>.xlsx'});
    else FmsToast.show('Выгрузка в Excel недоступна', 'err');
  }
</script>
