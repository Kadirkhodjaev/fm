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
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">№</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">ИБ №</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">ФИО</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Год рождения</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Отделение</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Дата рег</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Дата выписки</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">ФИО ЛВ</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Страна</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Регион</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Адрес</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Паспортные данные</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Диагноз</td>
  </tr>
  <c:forEach items="${rows}" var="service" varStatus="loop">
    <tr>
      <td align="center" style="padding:5px;">${loop.index + 1}</td>
      <td align="center" style="padding:5px;">${service.c5}</td>
      <td style="padding:5px;">${service.fio}</td>
      <td align="center" style="padding:5px;">${service.birthyear}</td>
      <td align="center">${service.c8}</td>
      <td align="center" style="padding:5px;">${service.date}</td>
      <td align="center" style="padding:5px;">${service.c9}</td>
      <td nowrap align="center" style="padding:5px;">${service.c10}</td>
      <td style="padding:5px;">${service.c1}</td>
      <td style="padding:5px;">${service.c2}</td>
      <td style="padding:5px;">${service.c6}</td>
      <td style="padding:5px;">${service.c7}</td>
      <td style="padding:5px;">${service.c4}</td>
    </tr>
  </c:forEach>
</table>
</body>
</html>
