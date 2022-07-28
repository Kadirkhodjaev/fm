<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<style>
  .miniGrid tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<table class="table table-bordered">
  <tr>
    <td style="width:260px; vertical-align: middle; font-weight:bold;" class="text-primary">
      Статистика по расходам за период
    </td>
    <td style="width:140px;padding:5px">
      <input name="period_start" id="period_start" type="text" class="form-control datepicker" value="${period_start}"/>
    </td>
    <td style="width:20px;padding:10px">
      -
    </td>
    <td style="width:140px;padding:5px">
      <input name="period_end" id="period_end" type="text" class="form-control datepicker" value="${period_end}"/>
    </td>
    <td style="">
      <button onclick="setExpStat()" class="btn btn-primary">Поиск</button>
    </td>
  </tr>
</table>

<div class="row" style="margin:0">
  <div class="col-md-6">
    <div class="panel panel-primary">
      <div class="panel-heading">
        Стационарные услуги
      </div>
      <div class="panel-body">
        <table class="table table-bordered miniGrid">
          <tr>
            <th>Наименование</th>
            <th>Расход</th>
            <th>Ед. изм.</th>
          </tr>
          <tbody>
            <c:forEach items="${stats}" var="obj">
              <tr>
                <td>${obj.c2}</td>
                <td class="right"><fmt:formatNumber value="${obj.c4}" type = "number"/></td>
                <td class="left">${obj.c3}</td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>
  <div class="col-md-6">
    <div class="panel panel-primary">
      <div class="panel-heading">
        Амбулаторные услуги
      </div>
      <div class="panel-body">
        <table class="table table-bordered miniGrid">
          <tr>
            <th>Наименование</th>
            <th>Расход</th>
            <th>Ед. изм.</th>
          </tr>
          <tbody>
          <c:forEach items="${ambs}" var="obj">
            <tr>
              <td>${obj.c2}</td>
              <td class="right"><fmt:formatNumber value="${obj.c4}" type = "number"/></td>
              <td class="left">${obj.c3}</td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
<div class="row" style="margin:0">
  <div class="col-md-6">
    <div class="panel panel-primary">
      <div class="panel-heading">
        Детализация стационарных услуг
      </div>
      <div class="panel-body">
        <table class="table table-bordered miniGrid">
          <tr>
            <th>Наименование</th>
            <th>Расход</th>
            <th>Ед. изм.</th>
          </tr>
          <tbody>
          <c:forEach items="${details}" var="obj">
            <tr>
              <td>${obj.c2}</td>
              <td class="right"><fmt:formatNumber value="${obj.c4}" type = "number"/></td>
              <td class="left">${obj.c3}</td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>
  <div class="col-md-6">
    <div class="panel panel-primary">
      <div class="panel-heading">
        ИТОГО
      </div>
      <div class="panel-body">
        <table class="table table-bordered miniGrid">
          <tr>
            <th>Наименование</th>
            <th>Расход</th>
            <th>Ед. изм.</th>
          </tr>
          <tbody>
          <c:forEach items="${totals}" var="obj">
            <tr>
              <td>${obj.c2}</td>
              <td class="right"><fmt:formatNumber value="${obj.c4}" type = "number"/></td>
              <td class="left">${obj.c3}</td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
<script>
  function setExpStat(){
    var start = document.getElementById("period_start");
    var end = document.getElementById("period_end");
    setPage('/exp/stat.s?period_start=' + start.value + '&period_end=' + end.value);
  }
</script>