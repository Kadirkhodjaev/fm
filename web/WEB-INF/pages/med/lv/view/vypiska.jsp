<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">
<div class="panel panel-info" style="width: 800px !important; margin: auto">
  <div class="panel-heading">Выписка</div>
  <div class="panel-body">
    <table class="formTable" style="width:100%">
      <tr>
        <td style="font-weight: bold; text-align: center" colspan="2">
          <c:if test="${!dieFlag}">
            ВЫПИСКА
          </c:if>
          <c:if test="${dieFlag}">
            ПОСМЕРТНЫЙ ЭПИКРИЗ
          </c:if>
        </td>
      </tr>
      <tr>
        <td><b>Пациент(ка):</b> ${form.patient.surname}&nbsp;${form.patient.name}&nbsp;${form.patient.middlename}</td>
        <td><b>Год рождения:</b> ${form.patient.birthyear}</td>
      </tr>
      <tr>
        <td nowrap class="bold" colspan="2">находился на стац. лечении в ЦКБ №1 ГМУ при АП РУз с ${dateBegin} по ${dateEnd}
      </tr>
      <tr>
        <td nowrap class="bold" colspan="2">Клинический диагноз:</td>
      </tr>
      <tr>
        <td colspan="2">${form.c1}</td>
      </tr>
      <tr>
        <td nowrap class="bold" colspan="2">Жалобы при поступлении:</td>
      </tr>
      <tr>
        <td colspan="2">${form.c2}</td>
      </tr>
      <tr>
        <td nowrap class="bold" colspan="2">Из анамнеза:</td>
      </tr>
      <tr>
        <td colspan="2">${form.c3}</td>
      </tr>
      <tr>
        <td nowrap class="bold" colspan="2">Состояние при поступлении:</td>
      </tr>
      <tr>
        <td colspan="2">${form.c4}</td>
      </tr>
      <tr>
        <td nowrap class="bold" colspan="2">Проведённые обследования:</td>
      </tr>
      <tr>
        <td colspan="2">${form.c5}</td>
      </tr>
      <tr>
        <td nowrap class="bold" colspan="2">Проведено лечение:</td>
      </tr>
      <tr>
        <td colspan="2">${form.c6}</td>
      </tr>
      <tr>
        <td nowrap class="bold" colspan="2">
          <c:if test="${!dieFlag}">
            Рекомендовано:
          </c:if>
          <c:if test="${dieFlag}">
            Посмертный диагноз:
          </c:if>
        </td>
      </tr>
      <tr>
        <td colspan="2">${form.c7}</td>
      </tr>
    </table>
  </div>
</div>