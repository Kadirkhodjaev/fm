<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
</table>
<table border="1" width="100%">
  <tr>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Период</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Наименование пакета</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">ФИО сотрудника</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Кол-во</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Сумма</td>
  </tr>
  <c:set var="summ" value="0" scope="page" />
  <c:forEach items="${rows}" var="service" varStatus="loop">
    <tr>
      <td align="center" style="padding:5px;">${service.c1}</td>
      <td style="padding:5px;">${service.c2}</td>
      <td style="padding:5px;">${service.c3}</td>
      <td align="center" style="padding:5px;text-align:center">${service.c4}</td>
      <td align="right" style="padding:5px;"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${service.c5}"/></td>
    </tr>
    <c:set var="summ" value="${summ + service.c5}" scope="page" />
  </c:forEach>
  <tr>
    <td colspan="4" class="bold right" style="padding:5px">ИТОГО</td>
    <td class="right bold" style="padding:5px"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${summ}"/></td>
  </tr>
</table>
</body>
</html>
