<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %><%
  response.setContentType("application/vnd.ms-excel;charset=UTF-8");
  response.setHeader("Content-Disposition", "attachment; filename=report.xls;");%>
<table>
  <tr>
    <td style="font-weight:bold; border:1px solid black; padding:10px; text-align: center" colspan="9">${header_title}</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr style="font-weight:bold; background:#e8e8e8">
    <td style="border:1px solid black; text-align: center">№</td>
    <td style="border:1px solid black; text-align: center">Наименование</td>
    <td style="border:1px solid black; text-align: center">Ед. изм.</td>
    <td style="border:1px solid black; text-align: center">Остаток</td>
    <td style="border:1px solid black; text-align: center">Цена за единицу</td>
    <td style="border:1px solid black; text-align: center">Сумма</td>
    <td style="border:1px solid black; text-align: center">Срок годности</td>
    <td style="border:1px solid black; text-align: center">Производитель</td>
    <td style="border:1px solid black; text-align: center">Акт прихода</td>
  </tr>
  <c:forEach items="${rows}" var="row" varStatus="loop">
    <tr>
      <td style="border:1px solid black; text-align: center">${loop.index + 1}</td>
      <td style="border:1px solid black">${row.c1}</td>
      <td style="border:1px solid black; text-align: center">${row.c9}</td>
      <td style="border:1px solid black; text-align: center">${row.c2}</td>
      <td style="border:1px solid black">${row.c4}</td>
      <td style="border:1px solid black">${row.c3}</td>
      <td style="border:1px solid black; text-align: center">${row.c5}</td>
      <td style="border:1px solid black">${row.c6}</td>
      <td style="border:1px solid black">№${row.c7} от ${row.c8}</td>
    </tr>
  </c:forEach>
</table>
