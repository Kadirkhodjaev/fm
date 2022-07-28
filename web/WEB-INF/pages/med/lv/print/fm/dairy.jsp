<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<style>
  * {font-size:${sessionScope.fontSize}px !important;color:black}
</style>
<table style="width:95%; border-spacing:0; border-collapse:collapse;">
  <tr>
    <td colspan="4" align="center"><b>КУНДАЛИКЛАР</b></td>
  </tr>
  <tr>
    <td colspan="4"><br/></td>
  </tr>
  <tr>
    <td colspan="8" style="border:1px solid #ababab"><b>Бемор:</b> ${pat.surname}&nbsp;${pat.name}&nbsp;${pat.middlename}<div style="float:right"><b>Тугилган йили:</b> ${pat.birthyear}</div></td>
  </tr>
  <c:forEach items="${dairies}" var="d">
    <tr>
      <td style="font-weight:bold; border:1px solid #ababab;">Сана</td>
      <td align="left"  style="border:1px solid #ababab; font-weight:bold">${d.c2}</td>
      <td align="right" style="border:1px solid #ababab; font-weight: bold;">Пульс (уп/мин):</td>
      <td align="left"  style="border:1px solid #ababab; font-weight: bold">${d.c3}</td>
      <td align="right" style="border:1px solid #ababab; font-weight: bold">К/Б:</td>
      <td align="left"  style="border:1px solid #ababab; font-weight: bold">${d.c6} / ${d.c7}</td>
    </tr>
    <tr>
      <td colspan="8" style="border:1px solid #ababab;">${d.c5}</td>
    </tr>
    <tr>
      <td colspan="8" style="font-weight:bold; border:1px solid #ababab;text-align:center;border-bottom:3px solid #ababab;padding:7px">
        Шифокор: ${d.c8} ______________
      </td>
    </tr>
  </c:forEach>
</table>