<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<style>
  .miniGrid tr th {text-align: center; background: #e8e8e8}
  .miniGrid tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Рейтинг препаратов
    <c:if test="${sessionScope.ENV.userId == 1}">
      <button  class="btn btn-sm btn-success" onclick="window.open('dch/checker.s', '_blank')" style="float:right;margin-top:-5px">Проверка расходов</button>
    </c:if>
  </div>
  <table class="table table-bordered">
    <tr>
      <td style="width:100px; font-weight:bold; padding:10px; text-align:right">Период:</td>
      <td style="width:140px;padding:5px">
        <input name="period_start" id="period_start" type="text" class="form-control datepicker" value="${period_start}"/>
      </td>
      <td style="width:20px;padding:10px">
        -
      </td>
      <td style="width:140px;padding:5px">
        <input name="period_end" id="period_end" type="text" class="form-control datepicker" value="${period_end}"/>
      </td>
      <td style="vertical-align: middle">
        <button onclick="setCashStat()" class="btn btn-success btn-sm">Поиск</button>
      </td>
    </tr>
  </table>
  <div class="panel-body">
    <table class="table table-bordered miniGrid">
      <tr>
        <th rowspan="2" style="vertical-align: middle">Наименование</th>
        <th colspan="2">Сальдо на начала</th>
        <th colspan="2">Приход</th>
        <th colspan="2">Расход</th>
        <th colspan="2">Сальдо на конец</th>
      </tr>
      <tr>
        <th>Кол-во</th>
        <th>Сумма</th>
        <th>Кол-во</th>
        <th>Сумма</th>
        <th>Кол-во</th>
        <th>Сумма</th>
        <th>Кол-во</th>
        <th>Сумма</th>
      </tr>
      <c:forEach items="${rows}" var="rw">
        <fmt:parseNumber var = "c2" type = "number" value = "${rw.c2}" />
        <fmt:parseNumber var = "c3" type = "number" value = "${rw.c3}" />
        <fmt:parseNumber var = "c4" type = "number" value = "${rw.c4}" />
        <fmt:parseNumber var = "c5" type = "number" value = "${rw.c5}" />
        <fmt:parseNumber var = "c6" type = "number" value = "${rw.c6}" />
        <fmt:parseNumber var = "c7" type = "number" value = "${rw.c7}" />
        <fmt:parseNumber var = "c8" type = "number" value = "${rw.c8}" />
        <fmt:parseNumber var = "c9" type = "number" value = "${rw.c9}" />
        <tr title="${rw.c10}" <c:if test="${c2 < 0 || c4 < 0 || c6 < 0 || c8 < 0}">style="background:red;color:white; font-weight:bold"</c:if>>
          <td>${rw.c1}</td>
          <td class="right"><fmt:formatNumber value="${rw.c2}" type="number"/></td>
          <td class="right"><fmt:formatNumber value="${rw.c3}" type="number"/></td>
          <td class="right"><fmt:formatNumber value="${rw.c4}" type="number"/></td>
          <td class="right"><fmt:formatNumber value="${rw.c5}" type="number"/></td>
          <td class="right"><fmt:formatNumber value="${rw.c6}" type="number"/></td>
          <td class="right"><fmt:formatNumber value="${rw.c7}" type="number"/></td>
          <td class="right"><fmt:formatNumber value="${rw.c8}" type="number"/></td>
          <td class="right"><fmt:formatNumber value="${rw.c9}" type="number"/></td>
        </tr>
      </c:forEach>
    </table>
  </div>
</div>
<script>
  function setCashStat(){
    var start = document.getElementById("period_start");
    var end = document.getElementById("period_end");
    setPage('/mn/drugs.s?period_start=' + start.value + '&period_end=' + end.value);
  }
</script>
