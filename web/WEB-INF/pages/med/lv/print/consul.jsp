<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<style>
  * {font-size:${sessionScope.fontSize}px !important;}
</style>
<table style="width:95%; margin: auto; border-spacing:0; border-collapse:collapse;">
  <tr>
    <td colspan="4" align="center"><b>КОНСУЛЬТАЦИИ</b></td>
  </tr>
  <tr>
    <td colspan="4"><br/></td>
  </tr>
  <tr>
    <td colspan="4" style="border:1px solid #ababab">
      <b>Пациент(ка):</b> ${pat.surname} ${pat.name} ${pat.middlename}
      &nbsp;&nbsp;<b>Год рождения:</b> ${pat.birthyear}
    </td>
  </tr>
  <c:forEach items="${consuls}" var="c">
    <c:if test="${c.text != null}">
      <tr>
        <td colspan="2" style="border-bottom:2px solid #ababab"></td>
      </tr>
      <tr>
        <td nowrap style="border:1px solid #ababab; padding:4px"><b>Врач:</b> ${c.lvName}</td>
        <td nowrap style="border:1px solid #ababab; padding:4px"><b>Дата консультации: </b>${c.date}</td>
      </tr>
      <tr>
        <td align=justify style="border:1px solid #ababab; padding:4px" colspan="2">${c.text} ${c.req}</td>
      </tr>
    </c:if>
  </c:forEach>
</table>