<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">
<div class="panel panel-info" style="width: 530px !important; margin: auto">
  <div class="panel-heading">ДОПОЛНИТЕЛЬНЫЕ ДАННЫЕ</div>
  <table class="formTable" width="100%">
    <tr>
      <td class="bold">Пациент(ка):</td>
      <td>${form.patient.surname}&nbsp;${form.patient.name}&nbsp;${form.patient.middlename}</td>
    </tr>
    <tr>
      <td class="bold">Год рождения:</td>
      <td>${form.patient.birthyear}</td>
    </tr>
    <tr>
      <td class="bold">Лист нетрудоспобности №:</td>
      <td>${form.c1}</td>
    </tr>
    <tr>
      <td class="bold">Продлен:</td>
      <td>
        <div style="float:left">&nbsp;&nbsp;с&nbsp;&nbsp;${dateBegin}</div>
        <div style="float:left">&nbsp;&nbsp;по&nbsp;&nbsp;${dateEnd}</div>
      </td>
    </tr>
    <tr>
      <td class="bold">Умер:</td>
      <td>
        ${dateStart}
      </td>
    </tr>
    <tr>
      <td class="bold">Исход болезни:</td>
      <td>${form.c5.name}</td>
    <tr>
      <td class="bold">Трудоспособность:</td>
      <td>${form.c6.name}</td>
    <tr>
      <td class="bold">Утр. трудоспособности:</td>
      <td>${form.c7.name}</td>
    </tr>
  </table>
</div>