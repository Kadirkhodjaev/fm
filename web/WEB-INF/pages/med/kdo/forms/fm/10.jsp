<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../header.jsp"%>
<tr>
  <td style="background-color:#e8e8e8; text-align: center;border:1px solid white">Код</td>
  <td style="background-color:#e8e8e8; text-align: center;border:1px solid white">Номи</td>
  <td width="100" style="background-color:#e8e8e8; text-align: center;border:1px solid white">Киймати</td>
  <td style="background-color:#e8e8e8; text-align: center;border:1px solid white">Норма</td>
  <td style="background-color:#e8e8e8; text-align: center;border:1px solid white">Ул. бир</td>
</tr>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">RBC</td>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c1name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c1html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c1norma}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c1ei}</td>
</tr>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">HGB</td>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c2name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c2html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c2norma}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c2ei}</td>
</tr>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">HCT</td>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c3name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c3html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c3norma}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c3ei}</td>
</tr>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">MCV</td>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c4name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c4html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c4norma}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c4ei}</td>
</tr>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">MCH</td>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c5name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c5html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c5norma}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c5ei}</td>
</tr>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">MCHC</td>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c6name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c6html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c6norma}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c6ei}</td>
</tr>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">RDW-CV</td>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c7name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c7html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c7norma}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c7ei}</td>
</tr>
<%--<tr>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c8name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c8html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">2-10</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">2-10</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">На 1000 эр</td>
</tr>--%>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">PLT</td>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c9name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c9html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c9norma}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c9ei}</td>
</tr>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">PDW</td>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c10name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c10html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c10norma}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c10ei}</td>
</tr>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">MPV</td>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c11name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c11html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c11norma}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c11ei}</td>
</tr>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">BCK</td>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c12name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c12html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c12norma}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c12ei}</td>
</tr>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">WBC</td>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c13name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c13html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c13norma}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c13ei}</td>
</tr>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">Lymph%</td>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c14name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c14html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c14norma}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c14ei}</td>
</tr>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">Mid%</td>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c15name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c15html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c15norma}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c15ei}</td>
</tr>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">Gran%</td>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c16name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c16html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c16norma}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c16ei}</td>
</tr>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">Lymph#</td>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c17name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c17html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c17norma}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c17ei}</td>
</tr>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">Mid#</td>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c18name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c18html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c18norma}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c18ei}</td>
</tr>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">Gran#</td>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c19name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c19html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c19norma}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c19ei}</td>
</tr>

<%--<tr>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c20name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c20html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">-</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">-</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">%</td>
</tr>
<tr>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c21name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c21html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">-</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">-</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">%</td>
</tr>
<tr>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c22name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c22html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">1 – 6</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">1 – 6</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">%</td>
</tr>
<tr>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c23name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c23html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">37 - 69</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">42 – 77</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">%</td>
</tr>--%>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">ЭОЗ</td>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c24name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c24html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c24norma}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c24ei}</td>
</tr>
<%--<tr>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c25name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c25html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">0 - 1</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">0 - 1</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">%</td>
</tr>
<tr>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c26name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c26html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">3 - 11</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">3 - 11</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">%</td>
</tr>
<tr>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c27name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c27html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">17 - 48</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">15 – 46</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">%</td>
</tr>
<tr>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c28name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c28html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">&nbsp;</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">&nbsp;</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">1000 лейк</td>
</tr>--%>
<tr>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">СОЭ</td>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c29name}</td>
  <td style="border:1px solid #e8e8e8; padding:5px">${c29html}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c29norma}</td>
  <td align=center style="padding:5px; border:1px solid #e8e8e8">${c29ei}</td>
</tr>
<%@include file="../../footer.jsp"%>
