<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading" style="padding:0 20px;">
    <table style="margin:0;width:100%">
      <tr>
        <td style="width:70px; font-weight:bold; vertical-align: middle">Приход</td>
        <td style="width:140px;padding:5px">
          <input name="period_start" id="period_start" type="text" class="form-control datepicker" value="${period_start}"/>
        </td>
        <td style="width:10px;vertical-align: middle">
          -
        </td>
        <td style="width:140px;padding:5px">
          <input name="period_end" id="period_end" type="text" class="form-control datepicker" value="${period_end}"/>
        </td>
        <td style="vertical-align: middle">
          <button onclick="setCashStat()" class="btn btn-success btn-sm">Поиск</button>
        </td>
        <td align="right" style="vertical-align: middle;">
          <button  class="btn btn-sm btn-success" onclick="addEditDrugAct(0)" style="float:right;"><i class="fa fa-plus"></i> Добавить</button>
        </td>
      </tr>
    </table>
  </div>
  <div class="panel-body">
    <%@include file="/incs/msgs/successError.jsp"%>
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
          <tr>
            <th>#</th>
            <th>Поставщик</th>
            <th>Акт</th>
            <th>Кол-во</th>
            <th>Сумма</th>
            <th>Состояние</th>
            <th>Дата и время ввода</th>
          </tr>
        </thead>
        <tbody>
        <c:forEach items="${acts}" var="obj">
          <tr ondblclick="addEditDrugAct(${obj.ib})">
            <td align="center">${obj.ib}</td>
            <td>${obj.c1}</td>
            <td class="center">${obj.c2}</td>
            <td align="center">${obj.c3}</td>
            <td align="right"><fmt:formatNumber value = "${obj.c4}" type = "number"/></td>
            <td align="center">
              <c:if test="${obj.c5 == 'E'}">Введен</c:if>
              <c:if test="${obj.c5 == 'O'}">Подтвержден</c:if>
              <c:if test="${obj.c5 == 'C'}">Закрыт</c:if>
            </td>
            <td class="center">
              ${obj.c6}
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
    <!-- /.table-responsive -->
  </div>
  <!-- /.panel-body -->
</div>
<script>
  function addEditDrugAct(id){
    setPage('/drugs/act/addEdit.s?id=' + id);
  }
  function setCashStat(){
    var start = document.getElementById("period_start");
    var end = document.getElementById("period_end");
    setPage('/drugs/acts.s?period_start=' + start.value + '&period_end=' + end.value);
  }
</script>