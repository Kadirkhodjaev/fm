<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Дата прыбития</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Ф.И.О пациента</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Услуга</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Сумма</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Категория</td>
  </tr>
  <c:forEach items="${rows}" var="row">
    <c:if test="${fn:length(row.services) != 0}">
      <tr>
        <td style="font-weight:bold;padding:5px; text-align: center" colspan="6">${row.groupName}</td>
      </tr>
      <c:forEach items="${row.services}" var="service" varStatus="loop">
        <c:if test="${service.c6 == 'TOTAL' || service.c6 == 'ITOGO'}">
          <tr>
            <td align="center" style="padding:5px;">&nbsp;</td>
            <td align="left" style="font-weight:bold;padding:5px;" colspan="2">${service.c1}</td>
            <td align="left" style="padding:5px;">&nbsp;</td>
            <td align="right" style="font-weight:bold;padding:5px;"><fmt:formatNumber value = "${service.c2}" type = "number"/></td>
            <td align="center" style="padding:5px;">&nbsp;</td>
          </tr>
        </c:if>
        <c:if test="${service.c6 != 'TOTAL' && service.c6 != 'ITOGO'}">
          <tr>
            <td align="center" style="padding:5px;">${loop.index + 1}</td>
            <td align="center" style="padding:5px;">${service.c1}</td>
            <td align="left" style="padding:5px;">${service.c2}</td>
            <td align="left" style="padding:5px;">${service.c3}</td>
            <td align="right" style="padding:5px;"><fmt:formatNumber value = "${service.c4}" type = "number"/></td>
            <td align="left" style="padding:5px;">${service.c5}</td>
          </tr>
        </c:if>
      </c:forEach>
    </c:if>
  </c:forEach>
</table>
</body>
</html>