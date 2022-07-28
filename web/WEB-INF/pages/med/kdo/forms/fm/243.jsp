<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../header.jsp"%>
<tr>
  <td style="background-color:#e8e8e8; text-align: center;border:1px solid #ababab">Номи</td>
  <td style="background-color:#e8e8e8; text-align: center;border:1px solid #ababab">Натижа</td>
  <td style="background-color:#e8e8e8; text-align: center;border:1px solid #ababab">Норма</td>
  <td style="background-color:#e8e8e8; text-align: center;border:1px solid #ababab">Ул.бир.</td>
</tr>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c1name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c1html}</td>
  <td style="border:1px solid #e8e8e8; padding:5px;text-align: center">${c1norma}</td>
  <td style="border:1px solid #e8e8e8; padding:5px;text-align: center">${c1ei}</td>
</tr>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c2name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c2html}</td>
  <td style="border:1px solid #e8e8e8; padding:5px;text-align: center">${c2norma}</td>
  <td style="border:1px solid #e8e8e8; padding:5px;text-align: center">${c2ei}</td>
</tr>
<%@include file="../../footer.jsp"%>
