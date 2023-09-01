<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script>
  function openProcTab(id) {
    $('#home').load('/proc/patient/drugs.s?id='+ id + '&oper_day=${oper_day}');
  }
  function setOperDay(val) {
    $('#home').load('/proc/patient/drugs.s?id=${first_one}&oper_day=' + val);
  }
  $(function() {
    $('#home').load('/proc/patient/drugs.s?id=${first_one}&oper_day=${oper_day}');
  })
</script>
<style>
  .dateImg {margin-top:1px}
</style>
<div class="col-lg-12">
  <div class="panel panel-default">
    <div class="panel-heading" style="height:40px">
      <table style="width:100%">
        <tr>
          <td style="width: 300px" class="text-danger">Палата ${room.name} отделений "${dep_name}"</td>
          <td><input name="oper_day" id="oper_day" onchange="setOperDay(this.value)" type="text" class="form-control datepicker" value="${oper_day}" style="margin-top:-5px"/></td>
          <td style="text-align: right; width:70px">
            <button onclick="setPage('/proc/palatas.s')" class="btn btn-default btn-sm" style="margin-top:-5px"><b class="fa fa-backward"></b> Назад</button>
          </td>
        </tr>
      </table>
    </div>
    <div class="panel-body">
      <ul class="nav nav-tabs">
        <c:forEach items="${patients}" var="p" varStatus="loop">
          <li class="<c:if test="${loop.index == 0}">active</c:if>"><a  onclick="openProcTab(${p.id})" href="#home" data-toggle="tab">№${p.yearNum} ${p.fio}</a></li>
        </c:forEach>
      </ul>
      <div class="tab-content">
        <div class="tab-pane fade active in" id="home"></div>
      </div>
    </div>
  </div>
</div>
