<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../header.jsp"%>
<tr>
  <td align=center style="padding:5px; border:1px solid #787878">&nbsp;</td>
  <td align=center style="padding:5px; border:1px solid #787878">Номи</td>
  <td align=center style="padding:5px; border:1px solid #787878">Киймати</td>
  <td align=center style="padding:5px; border:1px solid #787878">Норма</td>
  <td align=center style="padding:5px; border:1px solid #787878">Ул.бир</td>
</tr>
<c:if test="${bio.c4}">
<tr>
  <td style="padding:5px; border:1px solid #787878">PT</td>
  <td style="padding:5px; border:1px solid #787878">${c1name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c1}</td>
  <td style="border:1px solid #787878; padding:5px" align=center>${c1norma}</td>
  <td style="border:1px solid #787878; padding:5px" align=center>${c1ei}</td>
</tr>
<tr>
  <td style="padding:5px; border:1px solid #787878">PT</td>
  <td style="padding:5px; border:1px solid #787878">${c2name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c2}</td>
  <td style="border:1px solid #787878; padding:5px" align=center>${c2norma}</td>
  <td style="border:1px solid #787878; padding:5px" align=center>${c2ei}</td>
</tr>
<tr>
  <td style="padding:5px; border:1px solid #787878">INR</td>
  <td style="padding:5px; border:1px solid #787878">${c3name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c3}</td>
  <td style="border:1px solid #787878; padding:5px" align=center>${c3norma}</td>
  <td style="border:1px solid #787878; padding:5px" align=center>${c3ei}</td>
</tr>
</c:if>
<c:if test="${bio.c1}">
<tr>
  <td style="padding:5px; border:1px solid #787878">FIB</td>
  <td style="padding:5px; border:1px solid #787878">${c4name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c4}</td>
  <td style="border:1px solid #787878; padding:5px" align=center>${c4norma}</td>
  <td style="border:1px solid #787878; padding:5px" align=center>${c4ei}</td>
</tr>
</c:if>
<c:if test="${bio.c2}">
<tr>
  <td style="padding:5px; border:1px solid #787878">TT</td>
  <td style="padding:5px; border:1px solid #787878">${c5name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c5}</td>
  <td style="border:1px solid #787878; padding:5px" align=center>${c5norma}</td>
  <td style="border:1px solid #787878; padding:5px" align=center>${c5ei}</td>
</tr>
</c:if>
<c:if test="${bio.c3}">
<tr>
  <td style="padding:5px; border:1px solid #787878">PTT</td>
  <td style="padding:5px; border:1px solid #787878">${c6name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c6}</td>
  <td style="border:1px solid #787878; padding:5px" align=center>${c6norma}</td>
  <td style="border:1px solid #787878; padding:5px" align=center>${c6ei}</td>
</tr>
</c:if>
<%@include file="../../footer.jsp"%>
