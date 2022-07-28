<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../header.jsp"%>
<tr>
  <td style="background-color:#787878; text-align: center;border:1px solid white">Номи</td>
  <td width="100" style="background-color:#787878; text-align: center;border:1px solid white">Киймати</td>
  <td style="background-color:#787878; text-align: center;border:1px solid white">Ул.бир</td>
</tr>
<c:if test="${bio.c4}">
  <tr>
    <td style="padding:5px; border:1px solid #787878">${c1name}</td>
    <td style="border:1px solid #787878; padding:5px">${f.c1}</td>
    <td style="text-align:center; border:1px solid #787878; padding:5px">${c1norma} ${c1ei}</td>
  </tr>
</c:if>
<c:if test="${bio.c3}">
  <tr>
    <td style="padding:5px; border:1px solid #787878">${c2name}</td>
    <td style="border:1px solid #787878; padding:5px">${f.c2}</td>
    <td style="text-align:center; border:1px solid #787878; padding:5px">${c2norma} ${c2ei}</td>
  </tr>
</c:if>
<c:if test="${bio.c2}">
  <tr>
    <td style="padding:5px; border:1px solid #787878">${c3name}</td>
    <td style="border:1px solid #787878; padding:5px">${f.c3}</td>
    <td style="text-align:center; border:1px solid #787878; padding:5px">${c3norma} ${c3ei}</td>
  </tr>
</c:if>
<c:if test="${bio.c1}">
  <tr>
    <td style="padding:5px; border:1px solid #787878">${c4name}</td>
    <td style="border:1px solid #787878; padding:5px">${f.c4}</td>
    <td style="text-align:center; border:1px solid #787878; padding:5px">${c4norma} ${c4ei}</td>
  </tr>
</c:if>
<%@include file="../../footer.jsp"%>
