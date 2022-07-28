<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<style>
  table tr.selected {background: #eee}
</style>
<div class="panel panel-info">
  <div class="panel-heading">
    <table style="margin:0;width:100%">
      <tr>
        <td style="width:70px; font-weight:bold; vertical-align: middle">Протокол</td>
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
        <td style="width:200px; vertical-align: middle; padding-right:10px">
          <input type="text" class="form-control" value="${filterWord}" onkeyup="setIPFilter(this)" placeholder="Поиск по IP">
        </td>
        <td style="width:200px">
          <select class="form-control" id="user_filter" onchange="setUserFilter()">
            <option value="0">Все</option>
            <c:forEach items="${users}" var="u">
              <option <c:if test="${u.id == user_id}">selected</c:if> value="${u.id}">${u.fio}</option>
            </c:forEach>
          </select>
        </td>
      </tr>
    </table>
  </div>
  <form id="room-form">
    <div class="panel-body">
      <div class="table-responsive">
        <table class="miniGrid table table-striped table-bordered">
          <thead>
          <tr>
            <th style="width:40px">#</th>
            <th>Пользователь</th>
            <th style="width:200px">IP</th>
            <th style="width:200px">Дата и время</th>
          </thead>
          <tbody>
          <c:forEach items="${rows}" var="s" varStatus="loop">
            <tr>
              <td class="center">${loop.index + 1}</td>
              <td>${s.user.fio}</td>
              <td class="center">${s.ip}</td>
              <td class="center"><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${s.dateTime}"/></td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
      <!-- /.table-responsive -->
    </div>
  </form>
  <!-- /.panel-body -->
</div>
<script>
  function setCashStat(){
    var start = document.getElementById("period_start");
    var end = document.getElementById("period_end");
    setPage('/admin/log.s?period_start=' + start.value + '&period_end='  + end.value);
  }
  function setUserFilter() {
    let start = document.getElementById("period_start");
    let end = document.getElementById("period_end");
    let user = document.getElementById("user_filter");
    setPage('/admin/log.s?period_start=' + start.value + '&period_end=' + end.value + '&user=' + user.value);
  }
  function setIPFilter(dom) {
    if(event.keyCode == 13) {
      let start = document.getElementById("period_start");
      let end = document.getElementById("period_end");
      let user = document.getElementById("user_filter");
      setPage('/admin/log.s?period_start=' + start.value + '&period_end=' + end.value + '&user=' + user.value + '&ip=' + dom.value);
    }
  }
</script>