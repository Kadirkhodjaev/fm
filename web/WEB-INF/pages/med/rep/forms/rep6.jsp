<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Ички №</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Сана</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Хизмат тури</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Ф.И.Ш.</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Тугилган йили</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Муолажа тури</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Ташхис</td>
  </tr>
  <c:forEach items="${rows}" var="service" varStatus="loop">
    <tr>
      <td align="center" style="padding:5px;">${loop.index + 1}</td>
      <td align="center" style="padding:5px;">${service.c4}</td>
      <td align="center" style="padding:5px;">${service.date}</td>
      <td align="center" style="padding:5px;">${service.c3}</td>
      <td style="padding:5px;">${service.fio}</td>
      <td align="center" style="padding:5px;">${service.birthyear}</td>
      <td style="padding:5px;">${service.c2}</td>
      <td style="padding:5px;">${service.c1}</td>
    </tr>
  </c:forEach>
</table>
</body>
</html>
