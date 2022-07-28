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
  <div class="panel-heading">
    <table style="margin:0;width:100%">
      <tr>
        <td style="width:70px; font-weight:bold; vertical-align: middle">Пациенты</td>
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
          <button onclick="setCashStat()" class="btn btn-success btn-sm" style="width:60px">ОК</button>
        </td>
        <td style="width:220px; padding-right:5px">
          <input type="text" style="height:30px" class="form-control" placeholder="Поиск..." id="filter_box" value="${filter}">
        </td>
        <td style="width:56px">
          <button class="btn btn-success btn-sm" onclick="setFilter()">Поиск</button>
        </td>
      </tr>
    </table>
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th style="width:30px">№</th>
          <th style="width:30px">#</th>
          <th>ФИО</th>
          <th style="width:150px">ИБ №</th>
          <th style="width:150px">Дата поступления</th>
          <th style="width:150px">Дата выписки</th>
          <th style="width:150px">Год рождения</th>
          <th style="width:250px">Отд / Пал</th>
          <th style="width:150px">Статус</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${rows}" var="obj" varStatus="loop">
          <tr ondblclick="setPage('/act/info.s?id=${obj.id}')">
            <td class="center">${loop.index + 1}</td>
            <td align="center">
              <c:if test="${obj.state == 'C'}">
                <img src="/res/imgs/red.gif">
              </c:if>
              <c:if test="${obj.state == 'D'}">
                <img src="/res/imgs/green.gif">
              </c:if>
            </td>
            <td>
                ${obj.patient.surname} ${obj.patient.name} ${obj.patient.middlename}
            </td>
            <td align="center">
                ${obj.patient.yearNum}
            </td>
            <td align="center"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.patient.dateBegin}" /></td>
            <td align="center"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.patient.dateEnd}" /></td>
            <td align="center">${obj.patient.birthyear}</td>
            <td align="center">${obj.patient.dept.name} / ${obj.patient.room.name}</td>
            <td class="center">
              <c:if test="${obj.closed != 'Y'}">Открыт</c:if>
              <c:if test="${obj.closed == 'Y'}">Закрыт</c:if>
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
  function setCashStat(){
    var start = document.getElementById("period_start");
    var end = document.getElementById("period_end");
    setPage('/act/index.s?period_start=' + start.value + '&period_end=' + end.value);
  }
  function setFilter() {
    var start = document.getElementById("period_start");
    var end = document.getElementById("period_end");
    var word = document.getElementById("filter_box");
    setPage('/act/index.s?period_start=' + start.value + '&period_end=' + end.value + '&word=' + decodeURIComponent(word.value));
  }
</script>