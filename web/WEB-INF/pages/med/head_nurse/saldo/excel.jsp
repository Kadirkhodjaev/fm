<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %><%
  response.setContentType("application/vnd.ms-excel;charset=UTF-8");
  response.setHeader("Content-Disposition", "attachment; filename=report.xls;");%>
<table>
  <tr>
    <td style="font-weight:bold; border:1px solid black; padding:10px; text-align: center" colspan="10">${header_title}</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <thead>
  <tr>
    <th style="border:1px solid black; text-align: center; font-weight: bold">#</th>
    <th style="border:1px solid black; text-align: center; font-weight: bold">ID</th>
    <th style="border:1px solid black; text-align: center; font-weight: bold">Склад</th>
    <th style="border:1px solid black; text-align: center; font-weight: bold">Наименование</th>
    <th style="border:1px solid black; text-align: center; font-weight: bold">Документ</th>
    <th style="border:1px solid black; text-align: center; font-weight: bold">Срок</th>
    <th style="border:1px solid black; text-align: center; font-weight: bold">Приход</th>
    <th style="border:1px solid black; text-align: center; font-weight: bold">Расход</th>
    <th style="border:1px solid black; text-align: center; font-weight: bold">Остаток</th>
    <th style="border:1px solid black; text-align: center; font-weight: bold">Ед.изм.</th>
  </tr>
  </thead>
  <tbody>
  <c:forEach items="${rows}" var="row" varStatus="loop">
    <tr>
      <td align="center" style="border:1px solid black;">${loop.index + 1}</td>
      <td align="center" style="border:1px solid black;">${row.drugId}</td>
      <td style="border:1px solid black;vertical-align: middle;">${row.direction}</td>
      <td style="border:1px solid black;vertical-align: middle;">${row.drug}</td>
      <td align="center" style="border:1px solid black;vertical-align: middle; width:200px">Акт №${row.regNum} от <fmt:formatDate pattern="dd.MM.yyyy" value="${row.regDate}"/></td>
      <td align="center" style="border:1px solid black;vertical-align: middle;"><fmt:formatDate pattern="dd.MM.yyyy" value="${row.endDate}"/></td>
      <td align="right" style="border:1px solid black;vertical-align: middle; width:100px">${row.drugCount}</td>
      <td align="right" style="border:1px solid black;vertical-align: middle; width:100px">${row.rasxod}</td>
      <td align="right" style="border:1px solid black;vertical-align: middle; width:100px">${row.saldo}</td>
      <td style="border:1px solid black;vertical-align: middle; width:100px">${row.measure}</td>
    </tr>
  </c:forEach>
  </tbody>
</table>

