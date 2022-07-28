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
  <c:forEach items="${rows}" var="row">
    <tr>
      <td colspan="3" class="bold" style="padding:10px">${row.fio}</td>
    </tr>
    <c:forEach items="${row.list}" var="ls">
      <tr>
        <td>${ls.c1}</td>
        <td>${ls.c2}</td>
        <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${ls.c3}"/></td>
      </tr>
    </c:forEach>
    <tr>
      <td class="bold" colspan="2">ИТОГО</td>
      <td class="bold right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${row.price}"/></td>
    </tr>
  </c:forEach>
</table>
</body>
</html>
