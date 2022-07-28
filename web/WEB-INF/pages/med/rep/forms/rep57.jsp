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
    <td class="bold center">ФИО</td>
    <td class="bold center">Год рождения</td>
    <td class="bold center">Дата рег</td>
    <c:forEach items="${types}" var="type">
      <td class="bold center">${type.name}</td>
    </c:forEach>
  </tr>
  <c:forEach items="${rows}" var="row">
    <tr>
      <td class="">${row.c1}</td>
      <td class="center">${row.c2}</td>
      <td class="center">${row.c3}</td>
      <td class="center">${row.c10}</td>
      <td class="center">${row.c11}</td>
      <td class="center">${row.c12}</td>
      <td class="center">${row.c13}</td>
      <td class="center">${row.c14}</td>
      <td class="center">${row.c15}</td>
      <td class="center">${row.c16}</td>
      <td class="center">${row.c17}</td>
      <td class="center">${row.c18}</td>
      <td class="center">${row.c19}</td>
      <td class="center">${row.c20}</td>
      <td class="center">${row.c21}</td>
    </tr>
  </c:forEach>
</table>

</body>
</html>
