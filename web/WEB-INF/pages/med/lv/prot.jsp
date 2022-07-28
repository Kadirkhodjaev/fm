<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">

<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<script src="/res/js/common.js" type="text/javascript"></script>
<script src="/res/editor/nicEdit.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script type="text/javascript">
  bkLib.onDomLoaded(nicEditors.allTextAreas);
</script>
<div class="panel panel-info" style="width: 800px !important; margin: auto">
  <div class="panel-heading">
    Протокол операции
  </div>
  <f:form commandName="prot" action='/lv/prot.s' method="post">
    <f:hidden path="id"/>
    <f:hidden path="patient.id"/>
    <div class="panel-body">
      <%@include file="/incs/msgs/successError.jsp"%>
      <table class="formTable" style="width:100%">
        <tr>
          <td><b>Пациент(ка):</b> ${prot.patient.surname}&nbsp;${prot.patient.name}&nbsp;${prot.patient.middlename}</td>
          <td><b>Год рождения:</b> ${prot.patient.birthyear}</td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">Протокол операции:</td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c1" cssStyle="width: 100%" rows="8" maxlength="512"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">Наименование операции:</td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c2" cssStyle="width: 100%" rows="8" maxlength="512"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2"><div style="float:left">Дата операции:&nbsp;&nbsp;</div><input value="${oper_Date}" id="oper_Date" class="form-control datepicker" name="oper_Date"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">Операция:</td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c3" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">Ход операции:</td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c4" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
      </table>
    </div>
    <div class="panel-footer" style="display: none">
      <button type="submit" id="saveBtn">Сохранить</button>
    </div>
  </f:form>
</div>