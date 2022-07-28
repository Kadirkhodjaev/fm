<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
      <td class="bold center" colspan="4" style="padding:10px">${row.name}</td>
    </tr>
    <tr>
      <td class="bold center">Медикамент</td>
      <td class="bold center">Количество за период</td>
      <td class="bold center">Максимальная стоимость</td>
      <td class="bold center">Общая сумма</td>
    </tr>
    <c:forEach items="${row.list}" var="ls" varStatus="loop">
      <tr>
        <td>${ls.c1}</td>
        <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${ls.c2}"/></td>
        <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${ls.c4}"/></td>
        <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${ls.c3}"/></td>
      </tr>
    </c:forEach>
    <tr>
      <td colspan="3" class="bold">ИТОГО</td>
      <td class="right bold"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${row.price}"/></td>
    </tr>
    <tr>
      <td colspan="4"></td>
    </tr>
  </c:forEach>
</table>

</body>
</html>
