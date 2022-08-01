<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<html>
<style>
  * {font-size: 12px}
</style>
<body>
<div>
  <table style="width:100%">
    <tr>
      <td style="padding-left:75px">
        <img src="${path}fm.png" style="width:180px">
      </td>
      <td rowspan="2" style="font-weight:bold; text-align:right;padding-top:20px">
        ЦП "Farxod Mada Shifo"<br/>
        Республика Узбекистан<br/>
        Ташкантская область<br/>
        Кибрайский район<br/>
        ул. Зебинисо, 8А<br/>
        Наш сайт: www.forux.uz<br/>
        email: forux@mail.ru<br/>
        Тел/Факс: (71) 289-24-66
      </td>
    </tr>
    <tr>
      <td style="text-align:left;font-weight:bold">
        <div style="padding-left:90px">Свидетельство №1878</div>
        <div style="padding-left:100px">Лицензия №01727</div>
      </td>
    </tr>
  </table>
  <table style="margin:auto; width:100%;" cellspacing="0" cellpadding="0">
    <tr>
      <td style="padding:2px; width:200px; border:1px solid black; text-align:center; font-weight:bold;">Ф.И.О.</td>
      <td style="padding:2px; text-align:center; border:1px solid black; font-weight:bold;">${patient.surname} ${patient.name} ${patient.middlename}</td>
    </tr>
    <tr>
      <td style="padding:2px; text-align:center; border:1px solid black; font-weight:bold;">Год рождения</td>
      <td style="padding:2px; text-align:center; border:1px solid black; font-weight:bold;">${patient.birthyear}</td>
    </tr>
    <tr>
      <td style="padding:2px; text-align:center; border:1px solid black; font-weight:bold;">Регистрация</td>
      <td style="padding:2px; text-align:center; border:1px solid black; font-weight:bold;"><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${patient.crOn}"/></td>
    </tr>
  </table>
  <div style="height:20px;"></div>
  <table style="margin:auto; width:100%;" cellspacing="0" cellpadding="0">
    <tr>
      <td colspan="4" style="text-align: center; font-weight: bold;">
        Список обследований по состояниям
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-weight: bold; border:1px solid black">№</td>
      <td style="text-align:center; font-weight: bold; border:1px solid black">Наименование</td>
      <td style="text-align:center; font-weight: bold; border:1px solid black; width:80px">Состояние</td>
      <td style="text-align:center; font-weight: bold; border:1px solid black; width:100px">Готовность</td>
    </tr>
    <c:forEach items="${services}" var="ser" varStatus="loop">
      <tr>
        <td style="padding:2px; text-align:center; border:1px solid black;">${loop.index + 1}</td>
        <td style="padding:2px; text-align:left; border:1px solid black;">${ser.service.name}</td>
        <td style="padding:2px; text-align:center; border:1px solid black; font-weight:bold">
          <c:if test="${ser.state == 'DONE'}"><span style="color:green">Готов</span></c:if>
          <c:if test="${ser.state != 'DONE'}"><span style="color:red">Не говот</span></c:if>
        </td>
        <td style="text-align:center; padding:2px; border:1px solid black;"><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${ser.confDate}"/></td>
      </tr>
    </c:forEach>
  </table>
</div>

<c:forEach items="${objs777}" var="ser">
  <table style="width:100%;">
    <tr>
      <td style="text-align: center; padding:10px; font-weight:bold">Анализы</td>
    </tr>
  </table>
  <table width="100%" cellpadding="0" cellspacing="0" style="border-spacing:0;border-collapse:collapse;">
    <tr>
      <td style="padding:5px;font-weight:bold;text-align:center;border:1px solid black;background:#e8e8e8">Показатели</td>
      <td style="padding:5px;font-weight:bold;text-align:center;border:1px solid black;background:#e8e8e8">Результат</td>
      <td style="padding:5px;font-weight:bold;text-align:center;border:1px solid black;background:#e8e8e8">Норма</td>
    </tr>
    <c:forEach items="${ser.results}" var="item">
      <tr>
        <td style="padding:5px;font-weight:bold;border:1px solid black;">${item.serviceName}</td>
        <td style="padding:5px;text-align:center;border:1px solid black;">${item.value}</td>
        <td style="padding:5px;text-align:center;border:1px solid black;">${item.norma} ${item.EI}</td>
      </tr>
    </c:forEach>
  </table>
  <table style="width:100%;">
    <tr>
      <td style="text-align: left;font-weight:bold;padding:20px">Врач</td>
      <td style="text-align: right;font-weight:bold;padding:20px">${ser.fio}</td>
    </tr>
  </table>
  <hr/>
</c:forEach>
<c:forEach items="${objs}" var="ser">
  <c:forEach items="${ser.results}" var="item">
    <c:if test="${item.form == 999}">
      <div style="font-weight: bold; text-align: center; padding:20px">${item.serviceName}</div>
      <div>${item.value}</div>
    </c:if>
    <c:if test="${item.form == 0}">
      <c:forEach items="${item.colName}" var="col" varStatus="loop">
        <div style="font-weight: bold; text-align: center; padding:20px">${col}</div>
        <div>${item.vals[loop.index]}</div>
      </c:forEach>
    </c:if>
    <c:if test="${item.form == 1005 || item.form == 1009}">
      <div style="font-weight: bold; text-align: center; padding:20px">${item.serviceName}</div>
      <table style="width:100%; border-collapse: collapse">
        <tr>
          <td style="font-weight: bold; text-align: center; border:1px solid black">Показатели</td>
          <td style="font-weight: bold; text-align: center; border:1px solid black">Результат</td>
        </tr>
        <c:forEach items="${item.rows}" var="field">
          <tr>
            <td style="border:1px solid black">${field.name}</td>
            <td style="text-align: center; border:1px solid black">${field.value}</td>
          </tr>
        </c:forEach>
      </table>
    </c:if>
    <c:if test="${item.form == 1000}">
      <div style="font-weight: bold; text-align: center; padding:20px">${item.serviceName}</div>
      <table style="width:100%; border-collapse: collapse">
        <tr>
          <td style="font-weight: bold; text-align: center; border:1px solid black">Показатели</td>
          <td style="font-weight: bold; text-align: center; border:1px solid black">Результат</td>
          <td style="font-weight: bold; text-align: center; border:1px solid black">Норма</td>
          <td style="font-weight: bold; text-align: center; border:1px solid black">Ед. изм</td>
        </tr>
        <c:forEach items="${item.rows}" var="field">
          <tr>
            <td style="border:1px solid black">${field.name}</td>
            <td style="text-align: center; border:1px solid black">${field.value}</td>
            <td style="text-align: center; border:1px solid black">${field.norma}</td>
            <td style="text-align: center; border:1px solid black">${field.EI}</td>
          </tr>
        </c:forEach>
      </table>
    </c:if>
    <c:if test="${item.form == 1001}">
      <div style="font-weight: bold; text-align: center; padding:20px">${item.serviceName}</div>
      <table style="width:100%; border-collapse: collapse">
        <tr>
          <td style="font-weight: bold; text-align: center; border:1px solid black">Показатели</td>
          <td style="font-weight: bold; text-align: center; border:1px solid black">Результат</td>
          <td style="font-weight: bold; text-align: center; border:1px solid black">Ед. изм</td>
        </tr>
        <c:forEach items="${item.rows}" var="field">
          <tr>
            <td style="border:1px solid black">${field.name}</td>
            <td style="text-align: center; border:1px solid black">${field.value}</td>
            <td style="text-align: center; border:1px solid black">${field.EI}</td>
          </tr>
        </c:forEach>
      </table>
    </c:if>
    <c:if test="${item.form == 1002 || item.form == 1003 || item.form == 1006 || item.form == 1007 || item.form == 1008}">
      <div style="font-weight: bold; text-align: center; padding:20px">${item.serviceName}</div>
      <table style="width:100%; border-collapse: collapse">
        <tr>
          <td style="font-weight: bold; text-align: center; border:1px solid black">Показатели</td>
          <td style="font-weight: bold; text-align: center; border:1px solid black">Результат</td>
          <td style="font-weight: bold; text-align: center; border:1px solid black">Норма</td>
        </tr>
        <c:forEach items="${item.rows}" var="field">
          <tr>
            <td style="border:1px solid black">${field.name}</td>
            <td style="text-align: center; border:1px solid black">${field.value}</td>
            <td style="text-align: center; border:1px solid black">${field.norma}</td>
          </tr>
        </c:forEach>
      </table>
    </c:if>
  </c:forEach>
  <table style="width:100%;">
    <tr>
      <td style="text-align: left;font-weight:bold;padding:20px">${ser.profil}</td>
      <td style="text-align: right;font-weight:bold;padding:20px">${ser.fio}</td>
    </tr>
  </table>
  <hr/>
</c:forEach>
</body>
</html>
