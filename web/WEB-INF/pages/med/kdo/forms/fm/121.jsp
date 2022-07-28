<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../header.jsp"%>
<tr>
  <td style="background-color:#e8e8e8; text-align: center;border:1px solid white">Номи</td>
  <td width="100" style="background-color:#e8e8e8; text-align: center;border:1px solid white">Киймати</td>
  <td style="background-color:#e8e8e8; text-align: center;border:1px solid white">Ул.бир</td>
</tr>
<c:if test="${bio.c4}">
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${c1name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${c1html}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c1norma} ${c1ei}</td>
  </tr>
</c:if>
<c:if test="${bio.c3}">
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${c2name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${c2html}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c2norma} ${c2ei}</td>
  </tr>
</c:if>
<c:if test="${bio.c2}">
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${c3name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${c3html}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c3norma} ${c3ei}</td>
  </tr>
</c:if>
<c:if test="${bio.c1}">
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${c4name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${c4html}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c4norma} ${c4ei}</td>
  </tr>
</c:if>
<%@include file="../../footer.jsp"%>

