<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="../../header.jsp"%>
<tr>
  <td style="text-align:center; padding:5px; border:1px solid #e8e8e8; font-weight: bold">Показатель</td>
  <td style="text-align:center; padding:5px; border:1px solid #e8e8e8; font-weight: bold">Результат</td>
  <c:if test="${form.normaFlag == null || form.normaFlag == 'Y'}">
    <td style="text-align:center; padding:5px; border:1px solid #e8e8e8; font-weight: bold">Норма</td>
  </c:if>
</tr>
<c:forEach items="${fields}" var="field">
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8; text-align: right">${field.name}</td>
    <td style="padding:5px;border:1px solid #e8e8e8;">${field.html}</td>
    <c:if test="${form.normaFlag == null || form.normaFlag == 'Y'}">
      <td class="center" style="padding:5px; border:1px solid #e8e8e8; text-align: center">${field.norma} ${field.ei}</td>
    </c:if>
  </tr>
</c:forEach>
<%@include file="../../footer.jsp"%>
