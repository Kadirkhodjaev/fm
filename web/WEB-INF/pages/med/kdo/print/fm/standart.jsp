<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../header.jsp"%>
<tr>
  <td style="text-align: center;border:1px solid black; padding:5px">Номи</td>
  <td style="text-align: center;border:1px solid black; padding:5px">Натижа</td>
  <c:if test="${form.normaFlag == null || form.normaFlag == 'Y'}">
    <td style="text-align: center;border:1px solid black; padding:5px">Норма</td>
  </c:if>
</tr>
<c:forEach items="${fields}" var="a">
  <tr>
    <td style="text-align: center;border:1px solid black; padding:5px">${a.name}</td>
    <td style="text-align: center;border:1px solid black; padding:5px">${f[a.fieldCode]}</td>
    <c:if test="${form.normaFlag == null || form.normaFlag == 'Y'}">
      <td style="text-align:center; padding:5px; border:1px solid black;">${a.norma} ${a.ei}</td>
    </c:if>
  </tr>
</c:forEach>
<%@include file="../../footer.jsp"%>
