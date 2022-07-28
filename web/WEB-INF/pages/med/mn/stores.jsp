<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
  .miniGrid tr th {text-align: center; background: #e8e8e8}
  .miniGrid tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    ИТОГИ ПО СКЛАДАМ
  </div>
  <div class="panel-body">
    <table class="table table-bordered miniGrid">
      <tr>
        <th>Наименование</th>
        <th style="width:130px">Приход</th>
        <th style="width:130px">Расход</th>
        <th style="width:130px">Разница</th>
      </tr>
      <c:forEach items="${rows}" var="rw">
        <c:if test="${fn:length(rw.list) > 0}">
          <tr>
            <td>${rw.fio}</td>
            <td class=" right"><fmt:formatNumber value = "${rw.price}" minFractionDigits="2" maxFractionDigits="2" type="number"/></td>
            <td class="right"><fmt:formatNumber value = "${rw.claimCount}" minFractionDigits="2" maxFractionDigits="2" type="number"/></td>
            <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${rw.price - rw.claimCount}"/></td>
          </tr>
        </c:if>
      </c:forEach>
      <tr>
        <td class="bold">ИТОГО</td>
        <td class="bold right"><fmt:formatNumber value = "${prixod}" minFractionDigits="2" maxFractionDigits="2" type="number"/></td>
        <td class="bold right"><fmt:formatNumber value = "${rasxod}" minFractionDigits="2" maxFractionDigits="2" type="number"/></td>
        <td class="bold right"><fmt:formatNumber value = "${prixod - rasxod}" minFractionDigits="2" maxFractionDigits="2" type="number"/></td>
      </tr>
    </table>
  </div>
</div>
<c:forEach items="${rows}" var="rw">
  <c:if test="${fn:length(rw.list) > 0}">
    <div class="panel panel-info" style="width: 100%; margin: auto">
      <div class="panel-heading">
          ${rw.fio}
      </div>
      <div class="panel-body">
        <table class="table table-bordered miniGrid">
          <tr>
            <th>Наименование</th>
            <th style="width:130px">Приход (Кол-во)</th>
            <th style="width:130px">Расход (Кол-во)</th>
            <th style="width:130px">Разница (Кол-во)</th>
            <th style="width:130px">Приход (Сумма)</th>
            <th style="width:130px">Расход (Сумма)</th>
          </tr>
          <c:forEach items="${rw.list}" var="ll">
            <tr>
              <td>${ll.c1}</td>
              <td class="center">${ll.c2}</td>
              <td class="center">${ll.c3}</td>
              <td class="center">${ll.c4}</td>
              <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${ll.c5}"/></td>
              <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${ll.c6}"/></td>
            </tr>
          </c:forEach>
          <tr>
            <td class="bold" colspan="4">ИТОГО</td>
            <td class="bold right"><fmt:formatNumber value = "${rw.price}" minFractionDigits="2" maxFractionDigits="2" type="number"/></td>
            <td class="bold right"><fmt:formatNumber value = "${rw.claimCount}" minFractionDigits="2" maxFractionDigits="2" type="number"/></td>
          </tr>
        </table>
      </div>
    </div>
  </c:if>
</c:forEach>
<script>
  function setCashStat(){
    var start = document.getElementById("period_start");
    var end = document.getElementById("period_end");
    setPage('/mn/stores.s?period_start=' + start.value + '&period_end=' + end.value);
  }
</script>