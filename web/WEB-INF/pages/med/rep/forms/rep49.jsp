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
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">№</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">ФИО</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Год рождения</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">№ ИБ</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Дата рег</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Дата выписки</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Отделение</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Палата</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Оплачена</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Возврат</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Скидка</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Сумма услуг</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Медикаменты</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">К оплате</td>
  </tr>
  <c:forEach items="${rows}" var="service" varStatus="loop">
    <c:if test="${service.c30 == '0'}">
      <tr>
        <td align="center" style="padding:5px;">${loop.index + 1}</td>
        <td style="padding:5px;">${service.fio}</td>
        <td align="center" style="padding:5px;">${service.birthyear}</td>
        <td align="center" style="padding:5px;">${service.ib}</td>
        <td align="center" style="padding:5px;">${service.date}</td>
        <td align="center" style="padding:5px;">${service.c2}</td>
        <td align="center" style="padding:5px;">${service.c1}</td>
        <td align="center" style="padding:5px;">${service.c3}</td>
        <td align="right" style="padding:5px;"><fmt:formatNumber value="${service.c4}" type = "number"/></td>
        <td align="right" style="padding:5px;"><fmt:formatNumber value="${service.c5}" type = "number"/></td>
        <td align="right" style="padding:5px;"><fmt:formatNumber value="${service.c6}" type = "number"/></td>
        <td align="right" style="padding:5px;"><fmt:formatNumber value="${service.c7}" type = "number"/></td>
        <td align="right" style="padding:5px;"><fmt:formatNumber value="${service.c10}" type = "number"/></td>
        <td align="right" style="padding:5px;"><fmt:formatNumber value="${service.c10 + service.c7 - service.c4 + service.c5 - service.c6}" type = "number"/></td>
      </tr>
    </c:if>
    <c:if test="${service.c30 == '1'}">
      <tr style="font-weight: bold">
        <td align="center" style="padding:5px;">&nbsp;</td>
        <td style="padding:5px;text-align: right;" colspan="7">${service.fio}</td>
        <td align="right" style="padding:5px;"><fmt:formatNumber value="${service.c4}" type = "number"/></td>
        <td align="right" style="padding:5px;"><fmt:formatNumber value="${service.c5}" type = "number"/></td>
        <td align="right" style="padding:5px;"><fmt:formatNumber value="${service.c6}" type = "number"/></td>
        <td align="right" style="padding:5px;"><fmt:formatNumber value="${service.c7}" type = "number"/></td>
        <td align="right" style="padding:5px;"><fmt:formatNumber value="${service.c10}" type = "number"/></td>
        <td align="right" style="padding:5px;"><fmt:formatNumber value="${service.c8}" type = "number"/></td>
      </tr>
    </c:if>
  </c:forEach>
</table>
</body>
</html>
