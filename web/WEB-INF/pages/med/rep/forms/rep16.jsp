<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Сана</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">№</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Ф.И.О</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Год р.</td>

    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Оксил</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Холес</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Глю</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Моч</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Креа</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Бил ум</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Бил бог</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">АЛТ</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">АСТ</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Альфа а</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Ca</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">С кисл</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">K</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Na</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Fe</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Mg</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Иш фасф</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">ГГТ</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Глик гем</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">РФ</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">АСЛО</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">СРБ</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">RW</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Hbs Ag</td>
    <td nowrap style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">NCV</td>
  </tr>
  <c:forEach items="${rows}" var="row">
    <c:forEach items="${row.services}" var="service" varStatus="loop">
      <tr>
        <td align="center" style="padding:5px;">${service.c30}</td>
        <td align="center" style="padding:5px;">${loop.index + 1}</td>
        <td align="left" style="padding:5px;">${service.c28}</td>
        <td align="center" style="padding:5px;">${service.c29}</td>

        <td align="center" style="padding:5px;">${service.c1}</td>
        <td align="center" style="padding:5px;">${service.c2}</td>
        <td align="center" style="padding:5px;">${service.c3}</td>
        <td align="center" style="padding:5px;">${service.c4}</td>
        <td align="center" style="padding:5px;">${service.c5}</td>
        <td align="center" style="padding:5px;">${service.c6}</td>
        <td align="center" style="padding:5px;">${service.c7}</td>
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
        <td align="center" style="padding:5px;">${service.c26}</td>
      </tr>
    </c:forEach>
  </c:forEach>
</table>
</body>
</html>