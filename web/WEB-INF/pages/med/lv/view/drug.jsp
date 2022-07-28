<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<script src="/res/js/common.js" type="text/javascript"></script>

<div class="panel panel-info" style="width: 100% !important; margin: auto">
  <div class="panel-heading">
    Назначение
  </div>
  <table class="formTable" style="width:100%">
    <tr>
      <td colspan="4"><b>Пациент(ка):</b> ${fio}</td>
      <td nowrap colspan="4"><b>Год рождения:</b>${birthyear}</td>
    </tr>
    <tr>
      <td rowspan="2" align="center"><b>Наименоваdние</b></td>
      <td rowspan="2" align="center"><b>Категория</b></td>
      <td rowspan="2" align="center"><b>Цель</b></td>
      <td rowspan="2" align="center" width="20"><b>Тип</b></td>
      <td colspan="3" align="center" width="140"><b>Время</b></td>
      <td rowspan="2" align="center"><b>Дата нач.</b></td>
      <td rowspan="2" align="center"><b>Дата окон.</b></td>
      <td rowspan="2" align="center"><b>Доза</b></td>
    </tr>
    <tr>
      <td align=center style="padding:1px;width:50px;"><b>Утр</b></td>
      <td align=center style="padding:1px;width:50px;"><b>Обед</b></td>
      <td align=center style="padding:1px;width:50px;"><b>Веч</b></td>
    </tr>
    <c:forEach items="${tabs}" var="drug" varStatus="loop">
      <tr id="drugTr${loop.index}">
        <td>${drug.drugName}</td>
        <td width="100">
            ${drug.cat}
        </td>
        <td width="230">
            ${drug.goal.name}
        </td>
        <td width="75" align="center">
          <c:if test="${drug.type == 'own'}">Свой</c:if>
          <c:if test="${drug.type == 'clin'}">Клиники</c:if>
        </td>
        <td align="center"><c:if test="${drug.morningTime}">+</c:if></td>
        <td align="center"><c:if test="${drug.noonTime}">+</c:if></td>
        <td align="center"><c:if test="${drug.eveningTime}">+</c:if></td>
        <td align="center" style="width:140px;">${drug.dateStart}</td>
        <td align="center" style="width:140px;">${drug.dateEnd}</td>
        <td align="center" width="100">${drug.note}</td>
      </tr>
    </c:forEach>
    <c:forEach items="${ines}" var="drug" varStatus="loop">
      <tr id="drugTr${loop.index}">
        <td>${drug.drugName}</td>
        <td width="100">
            ${drug.cat}
        </td>
        <td width="230">
            ${drug.goal.name}
        </td>
        <td width="75" align="center">
          <c:if test="${drug.type == 'own'}">Свой</c:if>
          <c:if test="${drug.type == 'clin'}">Клиники</c:if>
        </td>
        <td align="center"><c:if test="${drug.morningTime}">+</c:if></td>
        <td align="center"><c:if test="${drug.noonTime}">+</c:if></td>
        <td align="center"><c:if test="${drug.eveningTime}">+</c:if></td>
        <td align="center" style="width:140px;">${drug.dateStart}</td>
        <td align="center" style="width:140px;">${drug.dateEnd}</td>
        <td align="center" width="100">${drug.note}</td>
      </tr>
    </c:forEach>
  </table>
</div>