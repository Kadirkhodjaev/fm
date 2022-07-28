<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../header.jsp"%>
<tr>
  <td style="background-color:#e8e8e8; text-align: center;border:1px solid white">Номи</td>
  <td width="100" style="background-color:#e8e8e8; text-align: center;border:1px solid white">Киймати</td>
  <td style="background-color:#e8e8e8; text-align: center;border:1px solid white">Меъёр</td>
  <td style="background-color:#e8e8e8; text-align: center;border:1px solid white">СИ бирлик</td>
</tr>
<c:if test="${bio.c1 > 0}">
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${c1name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${c1html}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c1norma}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c1ei}</td>
  </tr>
</c:if>
<c:if test="${bio.c2 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">${c2name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c2html}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c2norma}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c2ei}</td>
</tr>
</c:if>

<c:if test="${bio.c3 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">${c3name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c3html}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c3norma}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c3ei}</td>
</tr>
</c:if>
<c:if test="${bio.c4 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">${c4name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c4html}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c4norma}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c4ei}</td>
</tr>
</c:if>
<c:if test="${bio.c5 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">${c5name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c5html}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c5norma}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c5ei}</td>
</tr>
</c:if>
<c:if test="${bio.c6 > 0}">
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${c6name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${c6html}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c6norma}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c6ei}</td>
  </tr>
</c:if>
<c:if test="${bio.c6 > 0}">
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${c7name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${c7html}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c7norma}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c7ei}</td>
  </tr>
</c:if>
<c:if test="${bio.c6 > 0}">
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${c8name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${c8html}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c8norma}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c8ei}</td>
  </tr>
</c:if>
<c:if test="${bio.c7 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">${c9name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c9html}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c9norma}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c9ei}</td>
</tr>
</c:if>
<c:if test="${bio.c8 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">${c10name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c10html}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c10norma}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c10ei}</td>
</tr>
</c:if>
<c:if test="${bio.c9 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">${c11name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c11html}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c11norma}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c11ei}</td>
</tr>
</c:if>
<c:if test="${bio.c10 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">${c12name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c12html}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c12norma}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c12ei}</td>
</tr>
</c:if>
<c:if test="${bio.c11 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">${c13name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c13html}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c13norma}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c13ei}</td>
</tr>
</c:if>
<c:if test="${bio.c12 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">${c14name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c14html}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c14norma}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c14ei}</td>
</tr>
</c:if>
<c:if test="${bio.c13 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">${c15name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c15html}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c15norma}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c15ei}</td>
</tr>
</c:if>
<c:if test="${bio.c14 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">${c16name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c16html}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c16norma}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c16ei}</td>
</tr>
</c:if>
<c:if test="${bio.c15 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">${c17name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c17html}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c17norma}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c17ei}</td>
</tr>
</c:if>
<c:if test="${bio.c16 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">${c18name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c18html}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c18norma}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c18ei}</td>
</tr>
</c:if>
<c:if test="${bio.c17 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">${c19name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c19html}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c19norma}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c19ei}</td>
</tr>
</c:if>
<c:if test="${bio.c18 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">${c20name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c20html}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c20norma}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c20ei}</td>
</tr>
</c:if>
<c:if test="${bio.c19 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #e8e8e8">${c21name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c21html}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c21norma}</td>
  <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c21ei}</td>
</tr>
</c:if>
<c:if test="${bio.c20 > 0}">
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${c22name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${c22html}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c22norma}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c22ei}</td>
  </tr>
</c:if>
<c:if test="${bio.c21 > 0}">
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${c23name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${c23html}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c23norma}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c23ei}</td>
  </tr>
</c:if>
<c:if test="${bio.c22 > 0}">
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${c24name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${c24html}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c24norma}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c24ei}</td>
  </tr>
</c:if>
<c:if test="${bio.c23 > 0}">
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${c25name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${c25html}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c25norma}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c25ei}</td>
  </tr>
</c:if>
<c:if test="${bio.c24 > 0}">
  <tr>
    <td style="padding:5px; border:1px solid #e8e8e8">${c26name}</td>
    <td style="border:1px solid #e8e8e8; padding:5px">${c26html}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c26norma}</td>
    <td style="text-align:center; border:1px solid #e8e8e8; padding:5px">${c26ei}</td>
  </tr>
</c:if>
<%@include file="../../footer.jsp"%>

