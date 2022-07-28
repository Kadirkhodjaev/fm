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
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Наименование</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Лечащий врач</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Кол-во</td>
  </tr>
  <c:forEach items="${rows}" var="row">
    <tr>
      <td style="font-weight:bold;padding:5px;" colspan="2">${row.groupName}</td>
      <td align="center" style="font-weight:bold;padding:5px;"></td>
      <td align="center" style="font-weight:bold;padding:5px;">${row.counter}</td>
    </tr>
    <c:forEach items="${row.services}" var="service" varStatus="loop">
      <tr>
        <td align="center" style="padding:5px;">${loop.index + 1}</td>
        <td style="padding:5px;">${service.c1}</td>
        <td style="padding:5px;">${service.c3}</td>
        <td align="center" style="padding:5px;">${service.c2}</td>
      </tr>
    </c:forEach>
  </c:forEach>
</table>
</body>
</html>