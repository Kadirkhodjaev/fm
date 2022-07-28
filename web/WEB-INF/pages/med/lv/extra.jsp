<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<script src="/res/js/common.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<f:form commandName="edt" method="post">
<f:hidden path="id"/>
<f:hidden path="patient.id"/>
<div class="panel panel-info" style="width: 550px !important; margin: auto">
  <div class="panel-heading">ДОПОЛНИТЕЛЬНЫЕ ДАННЫЕ</div>
  <%@include file="/incs/msgs/successError.jsp"%>
  <table class="formTable" width="100%">
    <tr>
      <td class="bold">Пациент(ка):</td>
      <td>${edt.patient.surname}&nbsp;${edt.patient.name}&nbsp;${edt.patient.middlename}</td>
    </tr>
    <tr>
      <td class="bold">Год рождения:</td>
      <td>${edt.patient.birthyear}</td>
    </tr>
    <tr>
      <td class="bold">Лист нетрудоспобности №:</td>
      <td><f:input path="c1" type="text" class="form-control"/></td>
    </tr>
    <tr>
      <td class="bold">Продлен:</td>
      <td>
        <table>
          <tr>
            <td><b>с</b>&nbsp;&nbsp;</td>
            <td><input name="C2_Date" value="${C2_Date}" class="form-control datepicker" style="display: inline" placeholder="dd.mm.yyyy" type="text" onblur="checkDate(this, '<ui:message code='dateError'/> ', false)" id="c2_date" onclick="getCalendar(this, 'ddMMyyyy', 'arrow')" maxlength="10"/></td>
            <td>&nbsp;&nbsp;<b>по</b>&nbsp;&nbsp;</td>
            <td><input name="C3_Date" value="${C3_Date}" class="form-control datepicker" style="display: inline" placeholder="dd.mm.yyyy" type="text" onblur="checkDate(this, '<ui:message code='dateError'/> ', false)" id="c3_d" onclick="getCalendar(this, 'ddMMyyyy', 'arrow')" maxlength="10"/></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class="bold">Умер:</td>
      <td>
        <input name="C4_Date" value="${C4_Date}" class="form-control datepicker" style="display: inline" placeholder="dd.mm.yyyy" type="text" onblur="checkDate(this, '<ui:message code='dateError'/> ', false)" id="c4_date" onclick="getCalendar(this, 'ddMMyyyy', 'arrow')" maxlength="10"/>
      </td>
    <tr>
      <td class="bold">Исход болезни:</td>
      <td><f:select path="c5.id" class="form-control" items="${c5}" itemValue="id" itemLabel="name"/></td>
    <tr>
      <td class="bold">Трудоспособность:</td>
      <td><f:select path="c6.id" class="form-control" items="${c6}" itemValue="id" itemLabel="name"/></td>
    <tr>
      <td class="bold">Утр. трудоспособности:</td>
      <td><f:select path="c7.id" class="form-control" items="${c7}" itemValue="id" itemLabel="name"/></td>
    <tr>
      <td class="bold">Метка:</td>
      <td><f:select path="c8.id" class="form-control" items="${c8}" itemValue="id" itemLabel="name"/></td>
    <tr>
      <td class="bold">Описание метки:</td>
      <td><f:textarea path="c9" type="text" class="form-control" maxlength="250"/></td>
    <tr>
      <td colspan="2" class="right"><button class="hidden" id="saveBtn" type="submit">Сохранить</button></td>
  </table>
</div>
</f:form>