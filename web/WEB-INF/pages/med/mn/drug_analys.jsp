<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Расчёт по препарату (окно в «Анализ склада» и «Анализ медикаментов»): приход, ручной ввод, расход, остатки по складам --%>
<c:set var="restCalc" value="${saldoCount + inCount + ssCount - outCount - poutCount}"/>
<style>
  .da-kpi { display:grid; grid-template-columns:repeat(5, 1fr); gap:10px; }
  .da-kpi > div { border:1px solid #E6E8EC; border-radius:12px; padding:10px 12px; background:#FAFBFC; }
  .da-kpi .k { font-size:12px; color:#6B7280; }
  .da-kpi .v { font-size:18px; font-weight:700; color:#1F2430; font-variant-numeric:tabular-nums; margin-top:2px; }
  .da-kpi .v.minus { color:#A50F22; }
  .da-kpi .eq { background:#EEF4FF; border-color:#D5E2FB; }
  .da-kpi .warn { background:#FDECEE; border-color:#F3C5CB; }
  .da-sec { border:1px solid #E6E8EC; border-radius:12px; overflow:hidden; }
  .da-sec > summary { display:flex; align-items:center; gap:8px; padding:10px 14px; cursor:pointer; font-weight:700; list-style:none; background:#fff; }
  .da-sec > summary::-webkit-details-marker { display:none; }
  .da-sec > summary .fa { color:#9AA1AC; transition:transform .12s; }
  .da-sec[open] > summary .fa { transform:rotate(90deg); }
  .da-sec > summary .t { flex:1; }
  .da-sec > summary .s { font-weight:600; font-variant-numeric:tabular-nums; }
  .da-sec > summary .n { color:#9AA1AC; font-size:12px; font-weight:500; }
  .da-sec .fm-grid td.r, .da-sec .fm-grid th.r { text-align:right; font-variant-numeric:tabular-nums; }
  .da-sec .fm-grid tfoot td { font-weight:700; background:#FAFBFC; }
  .da-two { display:grid; grid-template-columns:1fr 1fr; gap:12px; align-items:start; }
</style>
<div class="da-kpi">
  <div><div class="k">Приход</div><div class="v"><fmt:formatNumber value="${inCount}" pattern="#,##0.##"/></div></div>
  <div><div class="k">Ручной ввод</div><div class="v"><fmt:formatNumber value="${ssCount}" pattern="#,##0.##"/></div></div>
  <div><div class="k">Расход по пациентам</div><div class="v"><fmt:formatNumber value="${poutCount}" pattern="#,##0.##"/></div></div>
  <div><div class="k">Общий расход</div><div class="v"><fmt:formatNumber value="${outCount}" pattern="#,##0.##"/></div></div>
  <div class="${restCalc < 0 || (restCalc - ostCount > 0.001 || ostCount - restCalc > 0.001) ? 'warn' : 'eq'}">
    <div class="k">Остаток: расчёт / склады</div>
    <div class="v ${restCalc < 0 ? 'minus' : ''}"><fmt:formatNumber value="${restCalc}" pattern="#,##0.##"/> / <fmt:formatNumber value="${ostCount}" pattern="#,##0.##"/></div>
  </div>
</div>

<div class="da-two">
  <details class="da-sec" open>
    <summary><i class="fa fa-chevron-right"></i><span class="t">Остатки по складам</span><span class="s"><fmt:formatNumber value="${ostCount}" pattern="#,##0.##"/></span></summary>
    <table class="fm-grid">
      <thead><tr><th>Склад</th><th class="r" style="width:140px">Остаток</th></tr></thead>
      <tbody>
      <c:forEach items="${osts}" var="rw">
        <tr><td>${rw.c1}</td><td class="r"><fmt:formatNumber value="${rw.c2}" pattern="#,##0.##"/></td></tr>
      </c:forEach>
      <c:if test="${empty osts}"><tr><td colspan="2" class="mut">На складах нет</td></tr></c:if>
      </tbody>
    </table>
  </details>

  <details class="da-sec" open>
    <summary><i class="fa fa-chevron-right"></i><span class="t">Приход</span><span class="n">${fn:length(ins)}</span><span class="s"><fmt:formatNumber value="${inSum}" pattern="#,##0.##"/> сум</span></summary>
    <table class="fm-grid">
      <thead><tr><th>Поставщик</th><th style="width:100px">Дата</th><th class="r" style="width:90px">Кол-во</th><th class="r" style="width:110px">Цена</th><th class="r" style="width:130px">Сумма</th></tr></thead>
      <tbody>
      <c:forEach items="${ins}" var="rw">
        <tr>
          <td>${rw.c5}</td>
          <td>${rw.c4}</td>
          <td class="r"><fmt:formatNumber value="${rw.c1}" pattern="#,##0.##"/></td>
          <td class="r"><fmt:formatNumber value="${rw.c2}" pattern="#,##0.##"/></td>
          <td class="r"><fmt:formatNumber value="${rw.c3}" pattern="#,##0.##"/></td>
        </tr>
      </c:forEach>
      <c:if test="${empty ins}"><tr><td colspan="5" class="mut">Прихода нет</td></tr></c:if>
      </tbody>
      <c:if test="${not empty ins}">
        <tfoot><tr><td colspan="2">Итого</td><td class="r"><fmt:formatNumber value="${inCount}" pattern="#,##0.##"/></td><td></td><td class="r"><fmt:formatNumber value="${inSum}" pattern="#,##0.##"/></td></tr></tfoot>
      </c:if>
    </table>
  </details>
</div>

<c:if test="${not empty saldos}">
  <details class="da-sec">
    <summary><i class="fa fa-chevron-right"></i><span class="t">Сальдо на начало</span><span class="s"><fmt:formatNumber value="${saldoCount}" pattern="#,##0.##"/></span></summary>
    <table class="fm-grid">
      <thead><tr><th class="r">Кол-во</th><th class="r">Стоимость</th><th class="r">Сумма</th></tr></thead>
      <tbody>
      <c:forEach items="${saldos}" var="rw">
        <tr><td class="r"><fmt:formatNumber value="${rw.c1}" pattern="#,##0.##"/></td><td class="r"><fmt:formatNumber value="${rw.c2}" pattern="#,##0.##"/></td><td class="r"><fmt:formatNumber value="${rw.c3}" pattern="#,##0.##"/></td></tr>
      </c:forEach>
      </tbody>
    </table>
  </details>
</c:if>

<details class="da-sec">
  <summary><i class="fa fa-chevron-right"></i><span class="t">Ручной ввод сальдо</span><span class="n">${fn:length(sss)}</span><span class="s"><fmt:formatNumber value="${ssCount}" pattern="#,##0.##"/></span></summary>
  <table class="fm-grid">
    <thead><tr><th style="width:50px">№</th><th style="width:220px">Склад</th><th>Кто ввёл</th><th style="width:110px">Дата</th><th class="r" style="width:120px">Кол-во</th></tr></thead>
    <tbody>
    <c:forEach items="${sss}" var="rw" varStatus="loop">
      <tr><td class="mut">${loop.index + 1}</td><td>${rw.c5}</td><td>${rw.c1}</td><td>${rw.c2}</td><td class="r"><fmt:formatNumber value="${rw.c3}" pattern="#,##0.##"/></td></tr>
    </c:forEach>
    <c:if test="${empty sss}"><tr><td colspan="5" class="mut">Ручного ввода нет</td></tr></c:if>
    </tbody>
  </table>
</details>

<details class="da-sec">
  <summary><i class="fa fa-chevron-right"></i><span class="t">Расход по пациентам</span><span class="n">последние 14 дней подробно, раньше одной строкой</span><span class="s"><fmt:formatNumber value="${poutCount}" pattern="#,##0.##"/></span></summary>
  <table class="fm-grid">
    <thead><tr><th style="width:50px">№</th><th style="width:220px">Склад</th><th>Пациент</th><th style="width:110px">Дата</th><th class="r" style="width:120px">Кол-во</th></tr></thead>
    <tbody>
    <c:forEach items="${pouts}" var="rw" varStatus="loop">
      <tr><td class="mut">${loop.index + 1}</td><td>${rw.c5}</td><td>${rw.c1}</td><td>${rw.c2}</td><td class="r"><fmt:formatNumber value="${rw.c3}" pattern="#,##0.##"/></td></tr>
    </c:forEach>
    <c:if test="${empty pouts}"><tr><td colspan="5" class="mut">Расхода нет</td></tr></c:if>
    </tbody>
  </table>
</details>

<details class="da-sec">
  <summary><i class="fa fa-chevron-right"></i><span class="t">Общий расход</span><span class="n">${fn:length(outs)}</span><span class="s"><fmt:formatNumber value="${outCount}" pattern="#,##0.##"/></span></summary>
  <table class="fm-grid">
    <thead><tr><th style="width:50px">№</th><th style="width:220px">Склад</th><th>Получатель</th><th style="width:110px">Дата</th><th class="r" style="width:120px">Кол-во</th></tr></thead>
    <tbody>
    <c:forEach items="${outs}" var="rw" varStatus="loop">
      <tr><td class="mut">${loop.index + 1}</td><td>${rw.c5}</td><td>${rw.c4}</td><td>${rw.c1}</td><td class="r"><fmt:formatNumber value="${rw.c2}" pattern="#,##0.##"/></td></tr>
    </c:forEach>
    <c:if test="${empty outs}"><tr><td colspan="5" class="mut">Расхода нет</td></tr></c:if>
    </tbody>
  </table>
</details>
