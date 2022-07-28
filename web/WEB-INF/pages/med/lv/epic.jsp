<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<script src="/res/js/common.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<f:form commandName="epic" method="post">
  <div class="panel panel-info" style="width: 850px !important; margin: auto">
    <div class="panel-heading">Перевод</div>
    <%@include file="/incs/msgs/successError.jsp"%>
    <table class="formTable" width="100%">
      <tr>
        <td class="bold">Пациент(ка):</td>
        <td colspan="2">${patient.surname}&nbsp;${patient.name}&nbsp;${patient.middlename}</td>
        <td class="bold right">Год рождения:</td>
        <td>${patient.birthyear}</td>
      </tr>
      <c:forEach items="${epics}" var="e">
        <tr>
          <td colspan="2" style="text-align: center; font-weight: bold; background-color: #e8e8e8">Период</td>
          <td rowspan="2" width="80px" style="text-align: center; font-weight: bold; background-color: #e8e8e8">Отделение</td>
          <td rowspan="2" style="text-align: center; font-weight: bold; background-color: #e8e8e8">Палата</td>
          <td rowspan="2" style="text-align: center; font-weight: bold; background-color: #e8e8e8">Лечащий врач</td>
        </tr>
        <tr>
          <td style="text-align: center; font-weight: bold; background-color: #e8e8e8">с</td>
          <td style="text-align: center; font-weight: bold; background-color: #e8e8e8">по</td>
        </tr>
        <tr>
          <td width="100px" align="center">${e.c1}</td>
          <td width="140px" align="center">${e.c2}</td>
          <td>${e.c3}</td>
          <td style="text-align: center !important;">${e.c4}</td>
          <td>${e.c5}</td>
        </tr>
      </c:forEach>
      <tr>
        <td colspan="2" style="text-align: center; font-weight: bold; background-color: #e8e8e8">Период</td>
        <td rowspan="2" width="80px" style="text-align: center; font-weight: bold; background-color: #e8e8e8">Отделение</td>
        <td rowspan="2" style="text-align: center; font-weight: bold; background-color: #e8e8e8">Палата</td>
        <td rowspan="2" style="text-align: center; font-weight: bold; background-color: #e8e8e8">Лечащий врач</td>
      </tr>
      <tr>
        <td style="text-align: center; font-weight: bold; background-color: #e8e8e8">с</td>
        <td style="text-align: center; font-weight: bold; background-color: #e8e8e8">по</td>
      </tr>
      <tr>
        <td width="100px" style="text-align: center"><input type="hidden" name="Date_Begin" value="${startDate}"/>${startDate}</td>
        <td width="140px"><input type="text" id="Date_End" name="Date_End" class="form-control datepicker" value="${sysDate}"/></td>
        <td>
          <select name="deptId" class="form-control" id="epic_dept" onchange="setDept()">
            <c:forEach items="${deps}" var="d">
              <option value="${d.id}" <c:if test="${d.id == epic.deptId}">selected</c:if>>${d.name}</option>
            </c:forEach>
          </select>
        </td>
        <td style="text-align: center !important;">
          <select class="form-control" name="room_id" id="epic_room"></select>
        </td>
        <td>
          <select name="lvId" class="form-control">
            <c:forEach items="${lvs}" var="d">
              <option value="${d.id}" <c:if test="${d.id == epic.lvId}">selected</c:if>>${d.fio}</option>
            </c:forEach>
          </select>
        </td>
      </tr>
    </table>
    <div class="panel-footer" style="text-align: right">
      <button class="hidden" type="submit" id="saveBtn">Сохранить</button>
    </div>
  </div>
</f:form>
<script>
  let rooms = [];
  <c:forEach items="${rooms}" var="room">
  rooms.push({value: ${room.id}, name: '${room.name} ${room.floor.name} ${room.roomType.name}', dep: ${room.dept.id}});
  </c:forEach>
  function setDept() {
    let dept = $('#epic_dept').val();
    $('#epic_room').html('');
    rooms.forEach((dom) => {
      if(dept == dom.dep)
        $('#epic_room').append($('<option value="' + dom.value + '">' + dom.name + '</option>'));
    });
  }
  $(function() {
    setDept();
    $('#epic_room').val('${epic.room.id}');
  });
</script>
