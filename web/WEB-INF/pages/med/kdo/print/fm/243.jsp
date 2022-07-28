<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../header.jsp"%>
<tr>
  <td style="text-align: center;border:1px solid black; padding:5px">Номи</td>
  <td style="text-align: center;border:1px solid black; padding:5px">Натижа</td>
  <td style="text-align: center;border:1px solid black; padding:5px">Норма</td>
  <td style="text-align: center;border:1px solid black; padding:5px">Ул.бир</td>
</tr>
<tr>
  <td style="border:1px solid #787878; padding:5px">${c1name}</td>
  <td style="border:1px solid #787878; padding:5px; text-align: center">${f.c1}</td>
  <td style="border:1px solid #787878; padding:5px; text-align: center">${c1norma}</td>
  <td style="border:1px solid #787878; padding:5px; text-align: center">${c1ei}</td>
</tr>
<tr>
  <td style="border:1px solid #787878; padding:5px">${c2name}</td>
  <td style="border:1px solid #787878; padding:5px; text-align: center">${f.c2}</td>
  <td style="border:1px solid #787878; padding:5px; text-align: center">${c2norma}</td>
  <td style="border:1px solid #787878; padding:5px; text-align: center">${c2ei}</td>
</tr>
<%@include file="../../footer.jsp"%>
