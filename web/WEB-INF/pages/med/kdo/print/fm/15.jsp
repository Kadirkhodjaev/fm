<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../header.jsp"%>
<tr>
  <td align=center style="padding:5px; border:1px solid #787878">Номи</td>
  <td align=center style="padding:5px; border:1px solid #787878">Киймати</td>
  <td align=center style="padding:5px; border:1px solid #787878">Норма</td>
  <td align=center style="padding:5px; border:1px solid #787878">Ул.бир</td>
</tr>
<tr>
  <td style="padding:5px; border:1px solid #787878">${c1name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c1}</td>
  <td style="border:1px solid #787878; padding:5px" align=center>0 - 1,4</td>
  <td style="border:1px solid #787878; padding:5px" align=center>Ед/л</td>
</tr>
<tr>
  <td style="padding:5px; border:1px solid #787878">${c2name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c2}</td>
  <td style="border:1px solid #787878; padding:5px" align=center>1,0 - 3,0</td>
  <td style="border:1px solid #787878; padding:5px" align=center>мг/л</td>
</tr>
<tr>
  <td style="padding:5px; border:1px solid #787878">${c3name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c3}</td>
  <td style="border:1px solid #787878; padding:5px" align=center>30- 200</td>
  <td style="border:1px solid #787878; padding:5px" align=center>Ед/л</td>
</tr>
<%@include file="../../footer.jsp"%>

