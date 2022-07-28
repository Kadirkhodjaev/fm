<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
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
      <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:40px"><fmt:formatDate pattern="dd.MM" value="${date.date}"/></td>
    </c:forEach>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">Бемор имзоси</td>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">Хамшира</td>
  </tr>
  <c:forEach items="${pfizios}" var="fizio">
    <tr>
      <td style="border:1px solid #ababab;padding:5px">
        <b>${fizio.c1}</b><br/>
        <c:if test="${fizio.c2 != ''}">${fizio.c2}; </c:if>
        <c:if test="${fizio.c3 != ''}">${fizio.c3}</c:if>
      </td>
      <td style="border:1px solid #ababab;text-align:center">${fizio.counter}</td>
      <c:forEach items="${ds[fizio.id]}" var="date">
        <td style="border:1px solid #ababab;font-weight:bold;text-align:center">
          <c:if test="${date.state == 'Y'}"><b class="fa fa-plus"></b></c:if>
        </td>
      </c:forEach>
      <td style="border:1px solid #ababab;padding:10px">&nbsp;</td>
      <td style="border:1px solid #ababab;padding:10px">&nbsp;</td>
    </tr>
  </c:forEach>
</table>
