<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<div class="panel panel-info" style="width: 800px !important; margin: auto">
  <div class="panel-heading">Совместный осмотр с главным врачом</div>
  <div class="panel-body">
    <table class="formTable" style="width:100%">
      <tr>
        <td><b>Пациент(ка):</b> ${form.patient.surname}&nbsp;${form.patient.name}&nbsp;${form.patient.middlename}</td>
        <td><b>Год рождения:</b> ${form.patient.birthyear}</td>
      </tr>
      <tr>
        <td nowrap class="bold" colspan="2">Жалобы при поступлении:</td>
      </tr>
      <tr>
        <td colspan="2">${form.c1}</td>
      </tr>
      <tr>
        <td nowrap class="bold" colspan="2">Из анамнеза:</td>
      </tr>
      <tr>
        <td colspan="2">${form.c2}</td>
      </tr>
      <tr>
        <td nowrap class="bold" colspan="2">Состояние при поступлении:</td>
      </tr>
      <tr>
        <td colspan="2">${form.c3}</td>
      </tr>
      <tr>
        <td nowrap class="bold" colspan="2">Обследование:</td>
      </tr>
      <tr>
        <td colspan="2">${form.c4}</td>
      </tr>
      <tr>
        <td nowrap class="bold" colspan="2">Диагноз:</td>
      </tr>
      <tr>
        <td colspan="2">${form.c5}</td>
      </tr>
      <tr>
        <td nowrap class="bold" colspan="2">Рекомендовано:</td>
      </tr>
      <tr>
        <td colspan="2">${form.c6}</td>
      </tr>
    </table>
  </div>
</div>