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
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Оксил</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Холестерин</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Глюкоза</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Мочевина</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Креатинин</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Бил ум</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Бил бог</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">АЛТ</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">АСТ</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Альфа амилаза</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Са</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">C киск</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">К</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Na</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Fe</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Mg</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">ALP</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">ГГТ</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Глико-г</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">RF</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">АСЛО</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">СРБ</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">RW</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">HBS Ag</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">NCV</td>
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
      <td align="center" style="padding:5px;">${service.c23}</td>
      <td align="center" style="padding:5px;">${service.c24}</td>
      <td align="center" style="padding:5px;">${service.c25}</td>
    </tr>
  </c:forEach>
</table>
</body>
</html>