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
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">WBC</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Lymph#</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Mid#</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Gran#</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Lymph%</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Mid%</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Gran%</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">RBC</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">HGB</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">HCT</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">MCV</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">MCH</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">MCHC</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">RDW-CV</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">RDW-SD</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">PLT</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">MPV</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">PDW</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">PCT</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">Скорость оседания эритроцитов</td>
    <td style="font-weight:bold;padding:5px;background:#e8e8e8;" align="center">ВСК</td>
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
      <td align="center" style="padding:5px;" nowrap>${service.c21}</td>
    </tr>
  </c:forEach>
</table>
</body>
</html>