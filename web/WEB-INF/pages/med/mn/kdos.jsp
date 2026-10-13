<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Мониторинг → Рейтинг услуг: стационар и амбулатория по группам за период --%>
<%@include file="/WEB-INF/pages/med/mn/mn_style.jsp"%>
<c:set var="sumS" value="0"/><c:forEach items="${rows}" var="g"><c:set var="sumS" value="${sumS + g.price}"/></c:forEach>
<c:set var="sumA" value="0"/><c:forEach items="${amb}" var="g"><c:set var="sumA" value="${sumA + g.price}"/></c:forEach>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-trophy"></i></span>
        <div>
          <h2>Рейтинг услуг</h2>
          <span class="mn-sum">Стационар <b><fmt:formatNumber value="${sumS}" type="number" maxFractionDigits="0"/></b> · Амбулатория <b><fmt:formatNumber value="${sumA}" type="number" maxFractionDigits="0"/></b></span>
        </div>
      </div>
      <div class="mn-flt">
        <input id="period_start" type="text" class="fm-in datepicker" value="${period_start}" autocomplete="off"/>
        <span class="dash">—</span>
        <input id="period_end" type="text" class="fm-in datepicker" value="${period_end}" autocomplete="off"/>
        <button type="button" class="fm-btn" onclick="mnPeriod('/mn/services.s')"><i class="fa fa-search"></i>Показать</button>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="ksSeg">
        <button type="button" class="on" data-k="stat" onclick="ksSeg(this)">Стационар</button>
        <button type="button" data-k="amb" onclick="ksSeg(this)">Амбулатория</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="ksSearch" placeholder="Услуга" oninput="ksFilter()" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn" onclick="mnExcel($('#ksSeg .on').attr('data-k') == 'amb' ? 'ksAmb' : 'ksStat', 'reyting-uslug')"><i class="fa fa-file-excel-o"></i>Excel</button>
    </div>
    <div class="fm-table-wrap">
      <c:forTokens items="stat,amb" delims="," var="kind">
        <table class="mn ks-t" id="${kind == 'amb' ? 'ksAmb' : 'ksStat'}" data-k="${kind}" style="${kind == 'amb' ? 'display:none' : ''}">
          <thead>
          <tr>
            <th class="l">Услуга</th>
            <th style="width:150px">Кол-во</th>
            <th style="width:160px">Сумма</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach items="${kind == 'amb' ? amb : rows}" var="rw">
            <tr class="grp"><td colspan="3">${rw.fio}</td></tr>
            <c:forEach items="${rw.list}" var="ll">
              <tr data-s="${fn:escapeXml(ll.c2)} ${fn:escapeXml(rw.fio)}">
                <td>${ll.c2}</td>
                <td class="c">${ll.c3}</td>
                <td class="n"><fmt:formatNumber value="${ll.c4}" type="number"/></td>
              </tr>
            </c:forEach>
            <tr class="tot"><td colspan="2">Итого · ${rw.fio}</td><td class="n"><fmt:formatNumber value="${rw.price}" type="number"/></td></tr>
          </c:forEach>
          </tbody>
        </table>
      </c:forTokens>
    </div>
  </div>
</div>
<script>
  function ksSeg(btn) {
    $(btn).addClass('on').siblings().removeClass('on');
    $('.ks-t').hide().filter('[data-k=' + $(btn).attr('data-k') + ']').show();
  }
  function ksFilter() {
    var q = $.trim($('#ksSearch').val()).toLowerCase();
    $('.ks-t tbody tr[data-s]').each(function () { $(this).toggle(!q || String($(this).attr('data-s')).toLowerCase().indexOf(q) >= 0); });
  }
</script>
