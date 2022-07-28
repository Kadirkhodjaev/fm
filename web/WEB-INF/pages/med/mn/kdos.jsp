<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<style>
  .miniGrid tr th {text-align: center; background: #e8e8e8}
  .miniGrid tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
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
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Рейтинг услуг стационару
  </div>
  <div class="panel-body">
    <table class="table table-bordered miniGrid">
      <c:forEach items="${rows}" var="rw">
        <tr>
          <td colspan="3" class="bold center">${rw.fio}</td>
        </tr>
        <tr>
          <th>Наименование</th>
          <th style="width:130px">Кол-во операций</th>
          <th style="width:130px">Сумма</th>
        </tr>
        <c:forEach items="${rw.list}" var="ll">
          <tr>
            <td>${ll.c2}</td>
            <td class="center">${ll.c3}</td>
            <td class="right"><fmt:formatNumber value = "${ll.c4}" type = "number"/></td>
          </tr>
        </c:forEach>
        <tr>
          <td class="bold" colspan="2">Итого</td>
          <td class="right bold"><fmt:formatNumber value = "${rw.price}" type = "number"/></td>
        </tr>
      </c:forEach>
    </table>
  </div>
</div>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Рейтинг услуг амбулаторий
  </div>
  <div class="panel-body">
    <table class="table table-bordered miniGrid">
      <c:forEach items="${amb}" var="rw">
        <tr>
          <td colspan="3" class="bold center">${rw.fio}</td>
        </tr>
        <tr>
          <th>Наименование</th>
          <th style="width:130px">Кол-во операций</th>
          <th style="width:130px">Сумма</th>
        </tr>
        <c:forEach items="${rw.list}" var="ll">
          <tr>
            <td>${ll.c2}</td>
            <td class="center">${ll.c3}</td>
            <td class="right"><fmt:formatNumber value = "${ll.c4}" type = "number"/></td>
          </tr>
        </c:forEach>
        <tr>
          <td class="bold" colspan="2">Итого</td>
          <td class="right bold"><fmt:formatNumber value = "${rw.price}" type = "number"/></td>
        </tr>
      </c:forEach>
    </table>
  </div>
</div>
<script>
  function setOrd(code) {
    setPage('/mn/drugs.s?ord='+code)
  }
  function setCashStat(){
    var start = document.getElementById("period_start");
    var end = document.getElementById("period_end");
    setPage('/mn/services.s?period_start=' + start.value + '&period_end=' + end.value);
  }
</script>