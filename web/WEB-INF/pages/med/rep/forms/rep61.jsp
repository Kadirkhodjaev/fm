<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment; filename=report.xls;");
  }
%>
<html>
<head>
  <title>Отчет: ${rep.name}</title>
</head>
<body>
<% if(request.getParameter("word") == null) { %>
  <%@include file="../report.jsp"%>
<% } %>
<c:if test="${fn:length(rows) > 0}">
  <table border="1" width="100%">
    <tr>
      <td align="center" colspan="${3 + fn:length(services)}"><h4 style="font-weight: bold;">${rep.name} (Амбулатория)</h4></td>
    </tr>
    <tr>
      <td align="center" colspan="${3 + fn:length(services)}"><h4 style="font-weight: bold;">${params}</h4></td>
    </tr>
    <tr>
      <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">№</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">ФИО</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Дата рег</td>
      <c:forEach items="${services}" var="sr">
        <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">${sr.name}</td>
      </c:forEach>
    </tr>
    <c:forEach items="${rows}" var="service" varStatus="loop">
      <tr>
        <td align="center" style="padding:5px;">${loop.index + 1}</td>
        <td style="padding:5px;" nowrap>${service.fio}</td>
        <td style="padding:5px;">${service.name}</td>
        <c:forEach items="${services}" var="sr">
          <td style="text-align:center; padding:5px;">${service.rows[sr.id]}</td>
        </c:forEach>
      </tr>
    </c:forEach>
  </table>
</c:if>
<c:if test="${fn:length(krows) > 0}">
  <table border="1" width="100%">
    <tr>
      <td align="center" colspan="${3 + fn:length(kdos)}"><h4 style="font-weight: bold;">${rep.name} (Стационар)</h4></td>
    </tr>
    <tr>
      <td align="center" colspan="${3 + fn:length(kdos)}"><h4 style="font-weight: bold;">${params}</h4></td>
    </tr>
    <tr>
      <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">№</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">ФИО</td>
      <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Дата выписки</td>
      <c:forEach items="${kdos}" var="sr">
        <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">${sr.name}</td>
      </c:forEach>
    </tr>
    <c:forEach items="${krows}" var="service" varStatus="loop">
      <tr>
        <td align="center" style="padding:5px;">${loop.index + 1}</td>
        <td style="padding:5px;" nowrap>${service.fio}</td>
        <td style="padding:5px;">${service.name}</td>
        <c:forEach items="${kdos}" var="sr">
          <td style="text-align:center; padding:5px;">${service.rows[sr.id]}</td>
        </c:forEach>
      </tr>
    </c:forEach>
  </table>
</c:if>
</body>
</html>
