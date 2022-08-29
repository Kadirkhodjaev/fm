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
        <img src="C:\fm.png" style="width:180px">
      </td>
      <td rowspan="2" style="font-weight:bold; text-align:right;padding-top:20px">
        ЧП "Farhod Madad Shifo"<br/>
        Республика Узбекистан<br/>
        Ташкантская область<br/>
        Кибрайский район<br/>
        ул. Зебунисо, 8А<br/>
        Наш сайт: www.forux.uz<br/>
        email: forux@mail.ru<br/>
        Тел/Факс: (55) 500-28-88
      </td>
    </tr>
    <tr>
      <td style="text-align:left;font-weight:bold">
        <div style="padding-left:90px">Свидетельство №1878</div>
        <div style="padding-left:100px">Лицензия №27544351</div>
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
          <c:if test="${ser.state != 'DONE'}"><span style="color:red">Не готов</span></c:if>
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
        <div style="font-weight: bold; text-align: center; padding:20px">${item.serviceName}</div>
        <c:if test="${col == null}">
          <div style="font-weight: bold; text-align: center; padding:20px">${col}</div>
        </c:if>
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
    <c:if test="${item.form == 1004}">
      <table style="width:100%;border-spacing: 0; border-collapse: collapse">
        <tr>
          <td colspan="4" style="font-weight:bold; text-align:center; padding:10px; font-size:${sessionScope.fontSize + 4}px !important;">${item.serviceName}</td>
        </tr>
        <tr>
          <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Время</td>
          <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Удельный вес</td>
          <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Количество мочи (мл)</td>
          <td style="font-weight:bold;padding:5px;text-align:center;border:1px solid black;">Диурез</td>
        </tr>
        <tr>
          <td style="padding:5px;border:1px solid black;text-align:center">${item.rows[0].name}</td>
          <td style="padding:5px;border:1px solid black;text-align:center;">${item.rows[0].value}</td>
          <td style="padding:5px;border:1px solid black;text-align:center;">${item.rows[1].value}</td>
          <td rowspan="2" class="center" style="padding:5px;border:1px solid black;">
            Дневной диурез<br/>
            ДД = ${item.rows[2].value} мл
          </td>
        </tr>
        <tr>
          <td style="padding:5px;border:1px solid black;text-align:center">${item.rows[3].name}</td>
          <td style="padding:5px;border:1px solid black;text-align:center;">${item.rows[3].value}</td>
          <td style="padding:5px;border:1px solid black;text-align:center;">${item.rows[4].value}</td>
        </tr>
        <tr>
          <td style="padding:5px;border:1px solid black;text-align:center">${item.rows[5].name}</td>
          <td style="padding:5px;border:1px solid black;text-align:center;">${item.rows[5].value}</td>
          <td style="padding:5px;border:1px solid black;text-align:center;">${item.rows[6].value}</td>
          <td rowspan="3" class="center" style="padding:5px;border:1px solid black;">
            Ночной диурез<br/>
            ДД = ${item.rows[7].value} мл
          </td>
        </tr>
        <tr>
          <td style="padding:5px;border:1px solid black;text-align:center">${item.rows[8].name}</td>
          <td style="padding:5px;border:1px solid black;text-align:center;">${item.rows[8].value}</td>
          <td style="padding:5px;border:1px solid black;text-align:center;">${item.rows[9].value}</td>
        </tr>
        <tr>
          <td style="padding:5px;border:1px solid black;text-align:center">${item.rows[10].name}</td>
          <td style="padding:5px;border:1px solid black;text-align:center;">${item.rows[10].value}</td>
          <td style="padding:5px;border:1px solid black;text-align:center;">${item.rows[11].value}</td>
        </tr>
        <tr>
          <td style="padding:5px;border:1px solid black;text-align:center">${item.rows[12].name}</td>
          <td style="padding:5px;border:1px solid black;text-align:center;">${item.rows[12].value}</td>
          <td style="padding:5px;border:1px solid black;text-align:center;">${item.rows[13].value}</td>
          <td rowspan="3" class="center" style="padding:5px;border:1px solid black;">
            Суточный диурез<br/>
            ДД = ${item.rows[14].value} мл
          </td>
        </tr>
        <tr>
          <td style="padding:5px;border:1px solid black;text-align:center">${item.rows[15].name}</td>
          <td style="padding:5px;border:1px solid black;text-align:center;">${item.rows[15].value}</td>
          <td style="padding:5px;border:1px solid black;text-align:center;">${item.rows[16].value}</td>
        </tr>
        <tr>
          <td style="padding:5px;border:1px solid black;text-align:center">${item.rows[17].name}</td>
          <td style="padding:5px;border:1px solid black;text-align:center;">${item.rows[17].value}</td>
          <td style="padding:5px;border:1px solid black;text-align:center;">${item.rows[18].value}</td>
        </tr>
      </table>
    </c:if>
    <c:if test="${item.form == 81}">
      <table style="width:100%;border-spacing: 0; border-collapse: collapse">
        <tr>
          <td colspan="4" style="font-weight:bold; text-align:center; padding:10px; font-size:${sessionScope.fontSize + 4}px !important;">${item.serviceName}</td>
        </tr>
        <tr>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">Определяемые параметры</td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px" colspan="2"></td>
        </tr>
        <tr>
          <td style="border:1px solid #e8e8e8"></td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ВЫЯВЛЕНО</td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">НЕ ВЫЯВЛЕНО</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[0].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[0].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[1].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[2].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[2].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[3].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[4].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[4].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[5].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[6].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[6].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[7].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[8].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[8].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[9].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[10].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[10].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[11].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[12].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[12].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[13].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[14].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[14].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[15].value}</td>
        </tr>
        <tr>
          <td colspan="3" style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">АНТИБИОГРАММА</td>
        </tr>
        <tr>
          <td style="border:1px solid #e8e8e8;"></td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">РЕЗИСТЕНТНЫЙ</td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ЧУВСТВИТЕЛЬНЫЙ</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[16].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[16].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[17].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[18].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[18].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[19].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[20].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[20].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[21].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[22].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[22].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[23].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[24].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[24].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[25].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[26].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[26].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[27].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[28].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[28].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[29].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[30].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[30].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[31].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[32].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[32].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[33].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[34].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[34].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[35].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[36].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[36].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[37].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[38].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[38].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[39].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[40].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[40].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[41].value}</td>
        </tr>
      </table>
    </c:if>
    <c:if test="${item.form == 82}">
      <table style="width:100%;border-spacing: 0; border-collapse: collapse">
        <tr>
          <td colspan="4" style="font-weight:bold; text-align:center; padding:10px; font-size:${sessionScope.fontSize + 4}px !important;">${item.serviceName}</td>
        </tr>
        <tr>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ОПРЕДЕЛЯЕМЫЕ МИКРООРГАНИЗМИ</td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px" colspan="2">КОЛОРОМИТРИЧЕСКАЯ РЕАКЦИЯ</td>
        </tr>
        <tr>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px"></td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ПОЛОЖИТЕЛЬНЫЙ</td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ОТРИЦАТЕЛЬНЫЙ</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[0].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[0].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[1].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[2].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[2].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[3].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[4].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[4].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[5].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[6].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[6].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[7].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[8].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[8].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[9].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[10].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[10].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[11].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[12].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[12].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[13].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[14].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[14].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[15].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[16].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[16].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[17].value}</td>
        </tr>
        <tr>
          <td colspan="3" style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">АНТИБИОГРАММА</td>
        </tr>
        <tr>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px"></td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">РЕЗИСТЕНТНЫЙ</td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ЧУВСТВИТЕЛЬНЫЙ</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[18].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[18].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[19].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[20].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[20].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[21].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[22].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[22].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[23].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[24].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[24].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[25].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[26].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[26].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[27].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[28].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[28].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[29].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[30].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[30].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[31].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[32].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[32].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[33].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[34].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[34].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[35].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[36].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[36].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[37].value}</td>
        </tr>

        <tr>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">Противогрибковая чувствительность</td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px" colspan="2">КОЛОРОМИТРИЧЕСКАЯ РЕАКСИЯ</td>
        </tr>
        <tr>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px"></td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">РЕЗИСТЕНТНЫЙ</td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ЧУВСТВИТЕЛЬНЫЙ</td>
        </tr>

        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[38].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[38].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[39].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[40].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[40].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[41].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[42].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[42].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[43].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[44].name}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[44].value}</td>
          <td style="text-align:center;border:1px solid #e8e8e8; padding:5px">${item.rows[45].value}</td>
        </tr>
      </table>
    </c:if>
    <c:if test="${item.form == 83}">
      <table style="width:100%;border-spacing: 0; border-collapse: collapse">
        <tr>
          <td colspan="4" style="font-weight:bold; text-align:center; padding:10px; font-size:${sessionScope.fontSize + 4}px !important;">${item.serviceName}</td>
        </tr>
        <tr>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ОПРЕДЕЛЯЕМЫЕ МИКРООРГАНИЗМИ</td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px" colspan="2">КОЛОРОМИТРИЧЕСКАЯ РЕАКЦИЯ</td>
        </tr>
        <tr>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px"></td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ПОЛОЖИТЕЛЬНЫЙ</td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ОТРИЦАТЕЛЬНЫЙ</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[0].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[0].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[1].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[2].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[2].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[3].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[4].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[4].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[5].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[6].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[6].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[7].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[8].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[8].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[9].value}</td>
        </tr>
        <tr>
          <td colspan="3" style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ТЕСТ НА АНТИБАКТЕРИАЛЬНУЮ ЧУВСТВИТЕЛЬНОСТ</td>
        </tr>
        <tr>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px"></td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">РЕЗИСТЕНТНЫЙ</td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ЧУВСТВИТЕЛЬНЫЙ</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[10].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[10].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[11].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[12].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[12].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[13].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[14].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[14].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[15].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[16].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[16].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[17].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[18].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[18].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[19].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[20].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[20].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[21].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[22].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[22].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[23].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[24].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[24].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[25].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[26].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[26].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[27].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[28].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[28].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[29].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[30].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[30].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[31].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[32].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[32].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[33].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[34].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[34].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[35].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[36].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[36].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[37].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[38].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[38].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[39].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[40].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[40].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[41].value}</td>
        </tr>
        <tr>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px"></td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ПОЛОЖИТЕЛЬНЫЙ</td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ОТРИЦАТЕЛЬНЫЙ</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[42].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[42].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[43].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[44].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[44].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[45].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[46].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[46].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[47].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[48].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[48].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[49].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[50].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[50].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[51].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[52].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[52].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[53].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[54].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[54].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[55].value}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${item.rows[56].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[56].value}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${item.rows[57].value}</td>
        </tr>
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

