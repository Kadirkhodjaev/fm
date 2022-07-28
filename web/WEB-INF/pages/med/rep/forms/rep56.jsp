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
    <td class="bold center" style="padding:5px">Отделение</td>
    <td class="bold center" style="padding:5px">Тип</td>
    <td class="bold center" style="padding:5px">Количество больных</td>
    <td class="bold center" style="padding:5px">1</td>
    <td class="bold center" style="padding:5px">5</td>
    <td class="bold center" style="padding:5px">7</td>
    <td class="bold center" style="padding:5px">9</td>
    <td class="bold center" style="padding:5px">10</td>
    <td class="bold center" style="padding:5px">15</td>
    <td class="bold center" style="padding:5px">ИТОГО</td>
  </tr>
  <c:forEach items="${rows}" var="row">
    <tr <c:if test="${row.c1 == 'B'}">style="font-weight:bold"</c:if>>
      <c:if test="${row.c1 != 'B'}">
        <td class="center" style="padding:5px"><c:if test="${row.c1 != 'B'}">${row.c1}</c:if></td>
        <td class="center" style="padding:5px">${row.c2}</td>
        <td class="center" style="padding:5px">${row.c3}</td>
      </c:if>
      <c:if test="${row.c1 == 'B'}">
        <td class="right" colspan="3" style="padding:5px">${row.c2}</td>
      </c:if>
      <td class="center" style="padding:5px">${row.c5}</td>
      <td class="center" style="padding:5px">${row.c6}</td>
      <td class="center" style="padding:5px">${row.c7}</td>
      <td class="center" style="padding:5px">${row.c8}</td>
      <td class="center" style="padding:5px">${row.c9}</td>
      <td class="center" style="padding:5px">${row.c10}</td>
      <td class="center" style="padding:5px">${row.c4}</td>
    </tr>
  </c:forEach>
</table>


<table border="1" width="100%" style="margin-top: 40px">
  <tr>
    <td class="bold center" style="padding:5px" rowspan="2">Булим</td>
    <td class="bold center" style="padding:5px" colspan="3">Оддий</td>
    <td class="bold center" style="padding:5px" colspan="3">Люкс</td>
    <td class="bold center" style="padding:5px" colspan="3">Жами</td>
  </tr>
  <tr>
    <td class="bold center" style="padding:5px">Келди</td>
    <td class="bold center" style="padding:5px">Кетти</td>
    <td class="bold center" style="padding:5px">Жами</td>
    <td class="bold center" style="padding:5px">Келди</td>
    <td class="bold center" style="padding:5px">Кетти</td>
    <td class="bold center" style="padding:5px">Жами</td>
    <td class="bold center" style="padding:5px">Келди</td>
    <td class="bold center" style="padding:5px">Кетти</td>
    <td class="bold center" style="padding:5px">Жами</td>
  </tr>
  <c:forEach items="${dds}" var="row">
    <tr>
      <td class="center" style="padding:5px">${row.c1}</td>
      <td class="center" style="padding:5px">${row.c2}</td>
      <td class="center" style="padding:5px">${row.c3}</td>
      <td class="center" style="padding:5px"><b>${row.c4}</b></td>
      <td class="center" style="padding:5px">${row.c5}</td>
      <td class="center" style="padding:5px">${row.c6}</td>
      <td class="center" style="padding:5px"><b>${row.c7}</b></td>
      <td class="center" style="padding:5px">${row.c8}</td>
      <td class="center" style="padding:5px">${row.c9}</td>
      <td class="center" style="padding:5px"><b>${row.c10}</b></td>
    </tr>
  </c:forEach>
</table>

</body>
</html>
