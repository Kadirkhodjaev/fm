<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/res/editor/nicEdit.js" type="text/javascript"></script>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script type="text/javascript">
  bkLib.onDomLoaded(nicEditors.allTextAreas);
</script>
<div class="panel panel-info" style="width: 800px !important; margin: auto">
  <div class="panel-heading">
    Совместный осмотр с главным врачом
  </div>
  <f:form commandName="sov" action='/lv/sov.s' method="post">
    <f:hidden path="id"/>
    <f:hidden path="patient.id"/>
    <div class="panel-body">
      <%@include file="/incs/msgs/successError.jsp"%>
      <table class="formTable" style="width:100%">
        <tr>
          <td><b>Пациент(ка):</b> ${sov.patient.surname}&nbsp;${sov.patient.name}&nbsp;${sov.patient.middlename}</td>
          <td><b>Год рождения:</b> ${sov.patient.birthyear}</td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">Жалобы при поступлении:</td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c1" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">Из анамнеза:</td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c2" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">Состояние при поступлении:</td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c3" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">Обследование: <a style="float: right; cursor:pointer" onclick="window.open('plan.s?new=Y'); return false;">Результаты</a></td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c4" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">Диагноз:</td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c5" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">Рекомендовано:</td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c6" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
      </table>
    </div>
    <div class="panel-footer" style="display: none">
      <button id="saveBtn" type="submit">Сохранить</button>
    </div>
  </f:form>
</div>