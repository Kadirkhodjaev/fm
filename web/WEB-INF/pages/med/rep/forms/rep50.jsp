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
  <c:forEach items="${rows}" var="service" varStatus="loop">
    <c:if test="${service.c30 == 'N'}">
      <tr>
        <td style="border:1px solid black;padding:8px">${service.c10}</td>
        <td style="border:1px solid black;padding:8px">${service.c1}</td>
        <td style="border:1px solid black;padding:8px">${service.c3}</td>
        <td style="border:1px solid black;padding:8px;text-align:center">${service.c4}</td>
        <td style="border:1px solid black;padding:8px">${service.c5}</td>
      </tr>
    </c:if>
    <c:if test="${service.c30 == 'Y'}">
      <tr>
        <td align="center" style="border:1px solid black;padding:8px;font-weight: bold" colspan="5">${service.c1}</td>
      </tr>
    </c:if>
    <c:if test="${service.c30 == 'O'}">
      <tr>
        <td colspan="5" style="padding:2px"></td>
      </tr>
      <tr>
        <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">№</td>
        <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">ФИО</td>
        <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Наименование</td>
        <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Дата</td>
        <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Описание</td>
      </tr>
      <tr>
        <td align="center" style="border:1px solid black;padding:8px;font-weight: bold" colspan="5">${service.c1}</td>
      </tr>
    </c:if>
  </c:forEach>
</table>
</body>
</html>