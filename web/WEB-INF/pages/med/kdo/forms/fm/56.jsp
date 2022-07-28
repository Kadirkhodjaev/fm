<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../header.jsp"%>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">&nbsp;</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">Номи</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">Киймати</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">Норма</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">Ул.бир</td>
</tr>
<c:if test="${bio.c4}">
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">PT</td>
  <td style="padding:5px; border:1px solid #e8e8e8">${c1name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c1html}</td>
  <td style="border:1px solid #e8e8e8; padding:5px" align=center>${c1norma}</td>
  <td style="border:1px solid #e8e8e8; padding:5px" align=center>${c1ei}</td>
</tr>
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">PT</td>
  <td style="padding:5px; border:1px solid #e8e8e8">${c2name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c2html}</td>
  <td style="border:1px solid #e8e8e8; padding:5px" align=center>${c2norma}</td>
  <td style="border:1px solid #e8e8e8; padding:5px" align=center>${c2ei}</td>
</tr>
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">INR</td>
  <td style="padding:5px; border:1px solid #e8e8e8">${c3name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c3html}</td>
  <td style="border:1px solid #e8e8e8; padding:5px" align=center>${c3norma}</td>
  <td style="border:1px solid #e8e8e8; padding:5px" align=center>${c3ei}</td>
</tr>
</c:if>
<c:if test="${bio.c1}">
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">FIB</td>
  <td style="padding:5px; border:1px solid #e8e8e8">${c4name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c4html}</td>
  <td style="border:1px solid #e8e8e8; padding:5px" align=center>${c4norma}</td>
  <td style="border:1px solid #e8e8e8; padding:5px" align=center>${c4ei}</td>
</tr>
</c:if>
<c:if test="${bio.c2}">
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">TT</td>
  <td style="padding:5px; border:1px solid #e8e8e8">${c5name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c5html}</td>
  <td style="border:1px solid #e8e8e8; padding:5px" align=center>${c5norma}</td>
  <td style="border:1px solid #e8e8e8; padding:5px" align=center>${c5ei}</td>
</tr>
</c:if>
<c:if test="${bio.c3}">
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">PTT</td>
  <td style="padding:5px; border:1px solid #e8e8e8">${c6name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c6html}</td>
  <td style="border:1px solid #e8e8e8; padding:5px" align=center>${c6norma}</td>
  <td style="border:1px solid #e8e8e8; padding:5px" align=center>${c6ei}</td>
</tr>
</c:if>
<%@include file="../../footer.jsp"%>
