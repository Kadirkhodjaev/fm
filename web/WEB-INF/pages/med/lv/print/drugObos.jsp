<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<style>
  * {font-size:${sessionScope.fontSize}px !important;}
</style>
<p style="width:95%;margin:auto;font-weight:bold;text-align:center">
  Обоснование препаратов
</p>
<table style="width:95%; margin: auto; border-spacing:0; border-collapse:collapse;">
  <tr>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:1px">№</td>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;">Наименование</td>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">Дата начала</td>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:180px">Цель</td>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:180px">Доза</td>
  </tr>
  <c:forEach items="${list}" var="drug" varStatus="loop">
    <tr>
      <td style="border:1px solid #ababab;text-align:center">${loop.index + 1}</td>
      <td style="border:1px solid #ababab">
        <c:forEach items="${drug.rows}" var="row" varStatus="loop">
          ${row.name}  <c:if test="${loop.index + 1 < fn:length(drug.rows)}"> + </c:if>
        </c:forEach>
      </td>
      <td style="border:1px solid #ababab;text-align:center"><fmt:formatDate pattern="dd.MM.yyyy" value="${drug.dateBegin}"/></td>
      <td style="border:1px solid #ababab;text-align:center">${drug.goal.name}</td>
      <td style="border:1px solid #ababab;text-align:center">${drug.note}</td>
    </tr>
  </c:forEach>
  <tr><td colspan="2"><br/><br/><br/></td></tr>
  <tr>
    <td colspan="2"><b>Лечащий врач</b></td>
    <td colspan="3" align="right">${lvFio}</td>
  </tr>
</table>
