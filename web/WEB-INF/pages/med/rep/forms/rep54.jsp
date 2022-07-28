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
  <tr>
    <td colspan="4" style="text-align: center; font-weight: bold; padding:10px">Амбулатория</td>
  </tr>
  <tr>
    <td class="bold center">ФИО</td>
    <td class="bold center">Услуга</td>
    <td class="bold center">Стоимость услуги</td>
    <td class="bold center">Сумма скидки</td>
  </tr>
  <c:forEach items="${rows}" var="row">
    <tr>
      <td rowspan="${fn:length(row.list) + 1}" class="bold" style="padding:10px">${row.name}</td>
    </tr>
    <c:forEach items="${row.list}" var="ls" varStatus="loop">
      <tr>
        <td>${ls.c1}</td>
        <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${ls.c2}"/></td>
        <c:if test="${loop.first}">
          <td rowspan="${fn:length(row.list)}" class="bold right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${row.price}"/></td>
        </c:if>
      </tr>
    </c:forEach>
  </c:forEach>
</table>

<table border="1" width="100%">
  <tr>
    <td colspan="4" style="text-align: center; font-weight: bold; padding:10px; margin-top:30px">Стационар</td>
  </tr>
  <tr>
    <td class="bold center">ФИО</td>
    <td class="bold center">Общая сумма</td>
    <td class="bold center">Сумма скидки</td>
  </tr>
  <c:forEach items="${rows2}" var="row">
    <tr>
      <td class="bold" style="padding:10px">${row.name}</td>
      <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${row.claimCount}"/></td>
      <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${row.price}"/></td>
    </tr>
  </c:forEach>
</table>
</body>
</html>
