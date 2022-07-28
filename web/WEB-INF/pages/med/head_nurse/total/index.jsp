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
          <button onclick="setCashStat()" class="btn btn-success btn-sm">Поиск</button>
        </td>
        <td style="width:200px">
          <input style="height:30px; margin-top:-5px" class="form-control" type="text" id="filter_word" placeholder="Поиск..." value="${filter_word}" onkeydown="setPatientFilter()">
        </td>
      </tr>
    </table>
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>#</th>
          <th>ФИО</th>
          <th>ИБ №</th>
          <th>Дата поступления</th>
          <th>Дата выписки</th>
          <th>Год рождения</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${rows}" var="obj" varStatus="loop">
          <tr ondblclick="setPage('/head_nurse/total/patients/info.s?id=${obj.id}')">
            <td align="center">
              <c:if test="${!obj.fizio}">
                <img src="/res/imgs/red.gif">
              </c:if>
              <c:if test="${obj.fizio}">
                <img src="/res/imgs/green.gif">
              </c:if>
            </td>
            <td>${obj.surname} ${obj.name} ${obj.middlename}</td>
            <td align="center">${obj.yearNum}</td>
            <td align="center"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.dateBegin}" /></td>
            <td align="center"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.dateEnd}" /></td>
            <td align="center">${obj.birthyear}</td>
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
    setPage('/head_nurse/total/patients.s?period_start=' + start.value + '&period_end=' + end.value);
  }
  function setPatientFilter() {
    if(event.keyCode === 13) {
      let start = document.getElementById("period_start");
      let end = document.getElementById("period_end");
      let filter = document.getElementById("filter_word");
      setPage('/head_nurse/total/patients.s?period_start=' + start.value + '&period_end=' + end.value + "&set=1&filter=" + filter.value);
    }
  }
</script>