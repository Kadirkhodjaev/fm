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
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Дата обследования</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Кол-во</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Цвет</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Прозр</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Отн. плот.</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Реак.</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Белок</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Глюк</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Кет. тела</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Реак. на кр.</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Бил</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Уробил</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Нитр</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Аск. кис</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Инд</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Эпит</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Лей</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Эрит</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Цил</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Слизь</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Соли</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Бак</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Дрож гриб</td>
  </tr>
  <c:forEach items="${rows}" var="service" varStatus="loop">
    <tr>
      <td align="center" style="padding:5px;">${loop.index + 1}</td>
      <td style="padding:5px;">${service.fio}</td>
      <td align="center" style="padding:5px;">${service.birthyear}</td>
      <td align="center" style="padding:5px;">${service.date}</td>
      <td align="center" style="padding:5px;">${service.c1}</td>
      <td align="center" style="padding:5px;">${service.c2}</td>
      <td align="center" style="padding:5px;">${service.c3}</td>
      <td align="center" style="padding:5px;">${service.c4}</td>
      <td align="center" style="padding:5px;">${service.c5}</td>
      <td align="center" style="padding:5px;">${service.c6}</td>
      <td align="center" style="padding:5px;">${service.c7}</td>
      <td align="center" style="padding:5px;">${service.c8}</td>
      <td align="center" style="padding:5px;">${service.c9}</td>
      <td align="center" style="padding:5px;">${service.c10}</td>
      <td align="center" style="padding:5px;">${service.c11}</td>
      <td align="center" style="padding:5px;">${service.c12}</td>
      <td align="center" style="padding:5px;">${service.c13}</td>
      <td align="center" style="padding:5px;">${service.c14}</td>
      <td align="center" style="padding:5px;">${service.c15}</td>
      <td align="center" style="padding:5px;">${service.c16}</td>
      <td align="center" style="padding:5px;">${service.c17}</td>
      <td align="center" style="padding:5px;">${service.c18}</td>
      <td align="center" style="padding:5px;">${service.c19}</td>
      <td align="center" style="padding:5px;">${service.c20}</td>
      <td align="center" style="padding:5px;">${service.c21}</td>
      <td align="center" style="padding:5px;">${service.c22}</td>
    </tr>
  </c:forEach>
</table>
</body>
</html>