<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<div class="panel panel-info" style="width: 490px !important; margin: auto">
  <div class="panel-heading">ПЕРВИЧНЫЙ ОСМОТР ВРАЧА</div>
  <table class="formTable" width="100%">
    <tr>
      <td><b>Пациент(ка):</b> ${p.surname}&nbsp;${p.name}&nbsp;${p.middlename}</td>
      <td><b>Год рождения:</b> ${p.birthyear}</td>
    </tr>
    <tr>
      <td colspan="2">
        <b>Жалобы при поступлении:</b>
        <p>${p.jaloby}</p>
      </td>
    </tr>
    <tr>
      <td colspan="2">
        <b>Анамнез:</b>
        <p>${p.anamnez}</p>
      </td>
    </tr>
    <tr>
      <td colspan="2">
        <b>Состояние при поступлении:</b>
        <p>${p.c1}</p>
      </td>
    </tr>
    <tr>
      <td colspan="2">
        <b>Предварительный диагноз:</b>
        <p>${p.diagnoz}</p>
      </td>
    </tr>
  </table>
</div>