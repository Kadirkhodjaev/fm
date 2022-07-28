<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<html>
<body>
<div>
  <table style="width:100%;">
    <tr>
      <td>
        <%--<img src="${path}fm_logo.png" style="width:180px">--%>
      </td>
      <td rowspan="2" style="font-size:16px !important; font-weight:bold; text-align:right;padding-top:20px">
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
        <div style="padding-left:10px;">Свидетельство №1878</div>
        <div style="padding-left:20px;">Лицензия №01727</div>
      </td>
    </tr>
  </table>
  <div style="height:10px;"></div>
  <table style="margin:auto; width:100%;" cellspacing="0" cellpadding="0">
    <tr>
      <td style="padding:2px; width:200px; border:1px solid black; text-align:center; font-weight:bold;">Ф.И.О.</td>
      <td style="padding:2px; text-align:center; border:1px solid black; font-weight:bold;">${pat.surname} ${pat.name} ${pat.middlename}</td>
    </tr>
    <tr>
      <td style="padding:2px; text-align:center; border:1px solid black; font-weight:bold;">Год рождения</td>
      <td style="padding:2px; text-align:center; border:1px solid black; font-weight:bold;">${pat.birthyear}</td>
    </tr>
    <tr>
      <td style="padding:2px; text-align:center; border:1px solid black; font-weight:bold;">Дата и время</td>
      <td style="padding:2px; text-align:center; border:1px solid black; font-weight:bold;"><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${pat.crOn}"/></td>
    </tr>
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
    <c:forEach items="${ser.list}" var="item">
      <tr id="ser_${item.c1}"></tr>
    </c:forEach>
  </table>
  <table style="width:100%;">
    <tr>
      <td style="text-align: left;font-weight:bold;padding:20px">Врач</td>
      <td style="text-align: right;font-weight:bold;padding:20px">${ser.fio}</td>
    </tr>
  </table>
</c:forEach>
<c:forEach items="${objs}" var="ser">
  <c:forEach items="${ser.list}" var="item">
    <div id="ser_${item.c1}"></div>
  </c:forEach>
  <table style="width:100%;">
    <tr>
      <td style="text-align: left;font-weight:bold;padding:20px">${ser.name}</td>
      <td style="text-align: right;font-weight:bold;padding:20px">${ser.fio}</td>
    </tr>
  </table>
</c:forEach>
</body>
</html>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script>
  $(function () {
    <c:forEach items="${objs777}" var="ser">
    <c:forEach items="${ser.list}" var="item" varStatus="loop">
    $('#ser_${item.c1}').load('/amb/printForm.s?id=${item.c1}&idx=${loop.index}');
    </c:forEach>
    </c:forEach>
    <c:forEach items="${objs}" var="ser">
    <c:forEach items="${ser.list}" var="item" varStatus="loop">
    $('#ser_${item.c1}').load('/amb/printForm.s?id=${item.c1}&idx=${loop.index}');
    </c:forEach>
    </c:forEach>
  });
</script>
