<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<c:if test="${excel == 'Y'}">
  <%
    response.setContentType("application/vnd.ms-excel;charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=act.xls;");
  %>
</c:if>
<html>
<head>
  <title>Отчет: ${rep.name}</title>
</head>
<body>
<c:if test="${excel != 'Y'}">
  <%@include file="../report.jsp"%>
</c:if>
<table width="100%" id="repContent">
  <tr>
    <td align="center" colspan="5"><h4 style="font-weight: bold;">${rep.name}</h4></td>
  </tr>
  <tr>
    <td align="center" colspan="5"><h4 style="font-weight: bold;">${params}</h4></td>
  </tr>
</table>
<table border="1" width="100%">
  <c:forEach items="${rows}" var="row">
    <tr>
      <td colspan="5" class="bold" style="padding:10px">${row.fio}</td>
    </tr>
    <c:forEach items="${row.list}" var="ls">
      <tr>
        <td>${ls.c1}</td>
        <td>${ls.c2}</td>
        <td style="text-align: center">${ls.c6}</td>
        <td style="text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" groupingUsed="false" type="number" value="${ls.c3}"/></td>
        <td style="text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" groupingUsed="false" type="number" value="${ls.c4}"/></td>
        <td style="text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" groupingUsed="false" type="number" value="${ls.c5}"/></td>
      </tr>
    </c:forEach>
    <tr>
      <td style="font-weight: bold; text-align: right" colspan="3">ИТОГО</td>
      <td style="font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" groupingUsed="false" type="number" value="${row.price}"/></td>
      <td>&nbsp;</td>
      <td style="font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" groupingUsed="false" type="number" value="${row.claimCount}"/></td>
    </tr>
  </c:forEach>
  <tr>
    <td style="font-weight: bold; text-align: right" colspan="3">ВСЕГО</td>
    <td style="font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" groupingUsed="false" type="number" value="${totalSum}"/></td>
    <td>&nbsp;</td>
    <td style="font-weight: bold; text-align: right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" groupingUsed="false" type="number" value="${procSum}"/></td>
  </tr>
</table>
</body>
</html>
