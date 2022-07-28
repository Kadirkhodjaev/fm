<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<style>
  * {font-size:${sessionScope.fontSize}px !important;color:#000000;}
</style>
<p style="width:95%;margin:auto;font-weight:bold;text-align:center">
  ФИЗИОТЕРАПИЯ
</p>
<p style="width:95%; margin: auto; text-align: center;padding: 5px">
  <b>Бемор:</b> ${pat.surname} ${pat.name} ${pat.middlename}
  &nbsp;&nbsp;<b>Тугилган йили:</b> ${pat.birthyear}
  &nbsp;&nbsp;<b>Булим:</b> ${pat.dept.name}
  &nbsp;&nbsp;<b>Хона:</b> ${pat.room.name} - ${pat.room.roomType.name}
</p>
<table style="width:95%; margin: auto; border-spacing:0; border-collapse:collapse;">
  <tr>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;">Муолажа</td>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">Сони</td>
    <c:forEach items="${dates}" var="date">
      <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">${date}</td>
    </c:forEach>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">Бемор имзоси</td>
  </tr>
  <c:forEach items="${fizios}" var="fizio">
    <tr>
      <td style="border:1px solid #ababab;padding:5px">
        <b>${fizio.kdo.name}</b><br/>
        <c:if test="${fizio.oblast != ''}">${fizio.oblast}; </c:if>
        <c:if test="${fizio.comment != ''}">${fizio.comment}</c:if>
      </td>
      <td style="border:1px solid #ababab;text-align:center">${fizio.count}</td>
      <c:forEach items="${dates}" var="date">
        <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">&nbsp;</td>
      </c:forEach>
      <td style="border:1px solid #ababab;padding:10px">&nbsp;</td>
    </tr>
  </c:forEach>
</table>