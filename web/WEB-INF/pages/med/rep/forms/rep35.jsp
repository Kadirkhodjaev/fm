<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
  <title>Отчет: ${rep.name}</title>
</head>
<body>
<%@include file="../report.jsp"%>
<table width="100%" id="repContent">
  <tr>
    <td align="center"><h4 style="font-weight: bold;">${rep.name}</h4></td>
  </tr>
  <tr>
    <td align="center"><h4 style="font-weight: bold;">${params}</h4></td>
  </tr>
</table>
<table border="1" width="100%">
  <tr>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">№</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">ФИО</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Год рождения</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Дата оплаты</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Пластиковая карта</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Наличные</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Перечисление</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Итого</td>
  </tr>
  <c:forEach items="${rows}" var="service" varStatus="loop">
    <tr>
      <td align="center" style="padding:5px;">${service.c10}</td>
      <td style="padding:5px;">${service.fio}</td>
      <td align="center" style="padding:5px;">${service.birthyear}</td>
      <td align="center" style="padding:5px;">${service.date}</td>
      <td align="right" style="padding:5px;"><fmt:formatNumber value="${service.c1}" type = "number"/></td>
      <td align="right" style="padding:5px;"><fmt:formatNumber value="${service.c2}" type = "number"/></td>
      <td align="right" style="padding:5px;"><fmt:formatNumber value="${service.c3}" type = "number"/></td>
      <td align="right" style="padding:5px;font-weight:bold"><fmt:formatNumber value="${service.c4}" type = "number"/></td>
    </tr>
  </c:forEach>
</table>
</body>
</html>