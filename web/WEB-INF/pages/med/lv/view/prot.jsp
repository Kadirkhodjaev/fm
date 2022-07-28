<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">
<div class="panel panel-info" style="width: 800px !important; margin: auto">
  <div class="panel-heading">Протокол операции</div>
  <div class="panel-body">
    <table class="formTable" style="width:100%">
      <tr>
        <td><b>Пациент(ка):</b> ${form.patient.surname}&nbsp;${form.patient.name}&nbsp;${form.patient.middlename}</td>
        <td><b>Год рождения:</b> ${form.patient.birthyear}</td>
      </tr>
      <tr>
        <td nowrap class="bold" colspan="2">Протокол операции:</td>
      </tr>
      <tr>
        <td colspan="2">${form.c1}</td>
      </tr>
      <tr>
        <td nowrap class="bold" colspan="2">Наименование операции:</td>
      </tr>
      <tr>
        <td colspan="2">${form.c2}</td>
      </tr>
      <tr>
        <td nowrap class="bold" colspan="2">
          <div style="float:left">Дата операции:&nbsp;&nbsp;</div>${operDate}
        </td>
      </tr>
      <tr>
        <td nowrap class="bold" colspan="2">Операция:</td>
      </tr>
      <tr>
        <td colspan="2">${form.c3}</td>
      </tr>
      <tr>
        <td nowrap class="bold" colspan="2">Ход операции:</td>
      </tr>
      <tr>
        <td colspan="2">${form.c4}</td>
      </tr>
    </table>
  </div>
</div>