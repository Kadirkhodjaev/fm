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
<c:if test="${fn:length(rows) > 0}">
  <div style="text-align: center; font-size:16px; font-weight: bold; padding:10px; border:1px solid black">
    Стационар
  </div>
  <table border="1" width="100%" style="font-size: 13px">
    <tr>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">№</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Пациент</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Дата рег</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Дата вып</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Кол-во - люкс</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Сумма - люкс</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Кол-во - делюкс</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Сумма - делюкс</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Кол-во - простой</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Сумма - простой</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Кол-во коек</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Сумма</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Расчетная сумма</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Бонус</td>
    </tr>
    <c:forEach items="${rows}" var="a" varStatus="loop">
      <tr>
        <td align="center" style="padding:5px;">${loop.index + 1}</td>
        <td style="padding:5px;" nowrap>${a.c1}</td>
        <td style="padding:5px;text-align: center" nowrap>${a.c2}</td>
        <td style="padding:5px;text-align: center" nowrap>${a.c3}</td>
        <td style="padding:5px;text-align: right"><fmt:formatNumber value="${a.c4}" type="number"/></td>
        <td style="padding:5px;text-align: right"><fmt:formatNumber value="${a.c5}" type="number"/></td>
        <td style="padding:5px;text-align: right"><fmt:formatNumber value="${a.c6}" type="number"/></td>
        <td style="padding:5px;text-align: right"><fmt:formatNumber value="${a.c7}" type="number"/></td>
        <td style="padding:5px;text-align: right"><fmt:formatNumber value="${a.c8}" type="number"/></td>
        <td style="padding:5px;text-align: right"><fmt:formatNumber value="${a.c9}" type="number"/></td>
        <td style="padding:5px;text-align: right"><fmt:formatNumber value="${a.c10}" type="number"/></td>
        <td style="padding:5px;text-align: right"><fmt:formatNumber value="${a.c11}" type="number"/></td>
        <td style="padding:5px;text-align: right"><fmt:formatNumber value="${a.c12}" type="number"/></td>
        <td style="padding:5px;text-align: right"><fmt:formatNumber value="${a.c13}" type="number"/></td>
      </tr>
    </c:forEach>
  </table>
</c:if>
<c:if test="${fn:length(ambs) > 0}">
  <div style="text-align: center; font-size:16px; font-weight: bold; padding:10px; border:1px solid black">
    Амбулатория
  </div>
  <table border="1" width="100%" style="font-size: 13px">
    <tr>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">№</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Пациент</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Дата рег</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Дата подт</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Услуга</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Стоимость</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">% бонуса</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Бонус</td>
    </tr>
    <c:forEach items="${ambs}" var="a" varStatus="loop">
      <tr>
        <td align="center" style="padding:5px;">${loop.index + 1}</td>
        <td style="padding:5px;" nowrap>${a.c1}</td>
        <td style="padding:5px;" nowrap>${a.c2}</td>
        <td style="padding:5px;" nowrap>${a.c3}</td>
        <td style="padding:5px;" nowrap>${a.c4}</td>
        <td style="padding:5px;text-align: right"><fmt:formatNumber value="${a.c5}" type="number"/></td>
        <td style="padding:5px;text-align: right"><fmt:formatNumber value="${a.c6}" type="number"/></td>
        <td style="padding:5px;text-align: right"><fmt:formatNumber value="${a.c7}" type="number"/></td>
      </tr>
    </c:forEach>
  </table>
</c:if>
</body>
</html>
