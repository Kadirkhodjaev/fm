<%@ page contentType="text/html;charset=windows-1251" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=windows-1251");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<style>
  * {font-size:${sessionScope.fontSize}px !important;}
</style>
<p style="width:95%;margin:auto;font-weight:bold;text-align:center">
  ������������
</p>
<p style="width:95%; margin: auto; text-align: center;padding: 5px">
  <b>�����:</b> ${pat.surname} ${pat.name} ${pat.middlename}
  &nbsp;&nbsp;<b>�������� ����:</b> ${pat.birthyear}
</p>
<table style="width:95%; margin: auto; border-spacing:0; border-collapse:collapse;">
  <tr>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;">�������</td>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">����</td>
    <c:forEach items="${dates}" var="date">
      <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">${date}</td>
    </c:forEach>
    <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">����� ������</td>
  </tr>
  <c:forEach items="${fizios}" var="fizio">
    <tr>
      <td style="border:1px solid #ababab;padding:5px">
        <b>${fizio.service.name}</b>
      </td>
      <td style="border:1px solid #ababab;text-align:center">&nbsp;</td>
      <c:forEach items="${dates}" var="date">
        <td style="border:1px solid #ababab;font-weight:bold;text-align:center;width:80px">&nbsp;</td>
      </c:forEach>
      <td style="border:1px solid #ababab;padding:10px">&nbsp;</td>
    </tr>
  </c:forEach>
</table>
