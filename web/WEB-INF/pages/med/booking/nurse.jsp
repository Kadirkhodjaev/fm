<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<div class="panel panel-primary" style="width: 100%; margin: auto">
  <div class="panel-heading">
    <table style="margin:0;width:100%">
      <tr>
        <td style="font-weight:bold; vertical-align: middle">Бронирование койки</td>
        <td style="width:220px; padding-right:5px">
          <input type="text" style="height:30px" class="form-control" placeholder="Поиск..." id="filter_box" value="${filter}">
        </td>
        <td style="width:56px">
          <button class="btn btn-success btn-sm" onclick="setBookingFilter()">Поиск</button>
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
          <th>&nbsp;</th>
          <th>№</th>
          <th>ФИО</th>
          <th>Год рождения</th>
          <th>Дата рег</th>
          <th>Отд./Пал.</th>
          <th>ФИО ЛВ</th>
          <th>Состояние</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${list}" var="obj" varStatus="loop">
          <tr>
            <td>&nbsp;</td>
            <td align="center">${loop.index + 1}</td>
            <td>
              <a href="#" onclick="regBooking(${obj.id})">${obj.surname} ${obj.name} ${obj.middlename}</a>
            </td>
            <td align="center">${obj.birthyear}</td>
            <td align="center"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.dateBegin}" /></td>
            <td align="center">${obj.dept.name} /  ${obj.room.name} - ${obj.room.roomType.name}</td>
            <td align="center">${obj.lv.fio}</td>
            <td align="center">
              <c:if test="${obj.state == 'ENT'}">Введен</c:if>
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
  function regBooking(id) {
    setPage('/reg/nurse/index.s?booking=' + id);
  }
  function setBookingFilter() {
    alert(11)
    var word = document.getElementById("filter_box");
    setPage('/booking/nurse.s?word=' + word.value);
  }
</script>
