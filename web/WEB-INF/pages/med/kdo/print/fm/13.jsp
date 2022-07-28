<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../header.jsp"%>
<tr>
  <td style="background-color:#787878; text-align: center;border:1px solid white">Номи</td>
  <td width="100" style="background-color:#787878; text-align: center;border:1px solid white">Киймати</td>
  <td style="background-color:#787878; text-align: center;border:1px solid white">Эркак</td>
  <td style="background-color:#787878; text-align: center;border:1px solid white">Аёл</td>
  <td style="background-color:#787878; text-align: center;border:1px solid white">Ул.бир</td>
</tr>
<c:if test="${bio.c1 > 0}">
  <tr>
    <td style="padding:5px; border:1px solid #787878">${c1name}</td>
    <td style="border:1px solid #787878; padding:5px">${f.c1}</td>
    <td style="text-align:center; border:1px solid #787878; padding:5px">4.1- 6.05</td>
    <td style="text-align:center; border:1px solid #787878; padding:5px">4.1- 6.05</td>
    <td style="text-align:center; border:1px solid #787878; padding:5px">ммоль/л</td>
  </tr>
</c:if>
<c:if test="${bio.c2 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #787878">${c2name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c2}</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">до 5.5</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">до 5.5</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">ммоль/л</td>
</tr>
</c:if>
<c:if test="${bio.c3 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #787878">${c3name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c3}</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">до 55</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">до 55</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">ед/л</td>
</tr>
</c:if>
<c:if test="${bio.c4 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #787878">${c4name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c4}</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">66 - 87</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">66 - 87</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">г/л</td>
</tr>
</c:if>
<c:if test="${bio.c5 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #787878">${c5name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c5}</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">2.8 - 8.21</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">2.8 - 8.21</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">ммоль/л</td>
</tr>
</c:if>
<c:if test="${bio.c6 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #787878">${c6name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c6}</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">0.200-0.400</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">0.200-0.400</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">ммоль/л</td>
</tr>
</c:if>
<c:if test="${bio.c7 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #787878">${c7name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c7}</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">62 - 106</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">40 - 80</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">мкм/л</td>
</tr>
</c:if>
<c:if test="${bio.c8 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #787878">${c8name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c8}</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">до 17.1</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">до 17.1</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">&nbsp;</td>
</tr>
</c:if>
<c:if test="${bio.c8 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #787878">${c9name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c9}</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">до 5.1</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">до 5.1</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">мкм/л</td>
</tr>
</c:if>
<c:if test="${bio.c8 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #787878">${c10name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c10}</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">-</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">-</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">-</td>
</tr>
</c:if>
<c:if test="${bio.c11 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #787878">${c11name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c11}</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">до 41</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">до 41</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">U/l</td>
</tr>
</c:if>
<c:if test="${bio.c12 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #787878">${c12name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c12}</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">до 41</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">до 41</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">U/l</td>
</tr>
</c:if>
<c:if test="${bio.c13 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #787878">${c13name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c13}</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">32/53</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">32/53</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">&nbsp;</td>
</tr>
</c:if>
<c:if test="${bio.c14 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #787878">${c14name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c14}</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">200 - 415</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">140 - 340</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">мкм/л</td>
</tr>
</c:if>
<c:if test="${bio.c15 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #787878">${c15name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c15}</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">8.1 – 28.6</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">5.4 - 28.6</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">мкм/л</td>
</tr>
</c:if>
<c:if test="${bio.c16 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #787878">${c16name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c16}</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">3.5 - 5.16</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">3.5 - 5.16</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">ммоль/л</td>
</tr>
</c:if>
<c:if test="${bio.c17 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #787878">${c17name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c17}</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">135 - 156</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">135 - 156</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">ммоль/л</td>
</tr>
</c:if>
<c:if test="${bio.c18 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #787878">${c18name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c18}</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">2.15 - 2.55</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">2.15 - 2.55</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">ммоль/л</td>
</tr>
</c:if>
<c:if test="${bio.c19 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #787878">${c19name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c19}</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">98 - 107</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">98 - 107</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">ммоль/л</td>
</tr>
</c:if>
<c:if test="${bio.c20 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #787878">${c20name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c20}</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">0.87 - 1.45</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">0.87 - 1.45</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">ммоль/л</td>
</tr>
</c:if>
<c:if test="${bio.c21 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #787878">${c21name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c21}</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">0.87 - 1.45</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">0.65 - 1.05</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">ммоль/л</td>
</tr>
</c:if>
<c:if test="${bio.c22 > 0}">
<tr>
  <td style="padding:5px; border:1px solid #787878">${c22name}</td>
  <td style="border:1px solid #787878; padding:5px">${f.c22}</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">36 - 160</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">36 - 160</td>
  <td style="text-align:center; border:1px solid #787878; padding:5px">г/л</td>
</tr>
</c:if>

<c:if test="${bio.c23 > 0}">
  <tr>
    <td style="padding:5px; border:1px solid #787878">${c23name}</td>
    <td style="border:1px solid #787878; padding:5px">${f.c23}</td>
    <td style="text-align:center; border:1px solid #787878; padding:5px"></td>
    <td style="text-align:center; border:1px solid #787878; padding:5px"></td>
    <td style="text-align:center; border:1px solid #787878; padding:5px"></td>
  </tr>
</c:if>
<c:if test="${bio.c24 > 0}">
  <tr>
    <td style="padding:5px; border:1px solid #787878">${c24name}</td>
    <td style="border:1px solid #787878; padding:5px">${f.c24}</td>
    <td style="text-align:center; border:1px solid #787878; padding:5px"></td>
    <td style="text-align:center; border:1px solid #787878; padding:5px"></td>
    <td style="text-align:center; border:1px solid #787878; padding:5px"></td>
  </tr>
</c:if>
<c:if test="${bio.c25 > 0}">
  <tr>
    <td style="padding:5px; border:1px solid #787878">${c25name}</td>
    <td style="border:1px solid #787878; padding:5px">${f.c25}</td>
    <td style="text-align:center; border:1px solid #787878; padding:5px"></td>
    <td style="text-align:center; border:1px solid #787878; padding:5px"></td>
    <td style="text-align:center; border:1px solid #787878; padding:5px"></td>
  </tr>
</c:if>
<c:if test="${bio.c26 > 0}">
  <tr>
    <td style="padding:5px; border:1px solid #787878">${c26name}</td>
    <td style="border:1px solid #787878; padding:5px">${f.c26}</td>
    <td style="text-align:center; border:1px solid #787878; padding:5px"></td>
    <td style="text-align:center; border:1px solid #787878; padding:5px"></td>
    <td style="text-align:center; border:1px solid #787878; padding:5px"></td>
  </tr>
</c:if>
<c:if test="${bio.c27 > 0}">
  <tr>
    <td style="padding:5px; border:1px solid #787878">${c27name}</td>
    <td style="border:1px solid #787878; padding:5px">${f.c27}</td>
    <td style="text-align:center; border:1px solid #787878; padding:5px"></td>
    <td style="text-align:center; border:1px solid #787878; padding:5px"></td>
    <td style="text-align:center; border:1px solid #787878; padding:5px"></td>
  </tr>
</c:if>
<c:if test="${bio.c28 > 0}">
  <tr>
    <td style="padding:5px; border:1px solid #787878">${c28name}</td>
    <td style="border:1px solid #787878; padding:5px">${f.c28}</td>
    <td style="text-align:center; border:1px solid #787878; padding:5px"></td>
    <td style="text-align:center; border:1px solid #787878; padding:5px"></td>
    <td style="text-align:center; border:1px solid #787878; padding:5px"></td>
  </tr>
</c:if>
<c:if test="${bio.c29 > 0}">
  <tr>
    <td style="padding:5px; border:1px solid #787878">${c29name}</td>
    <td style="border:1px solid #787878; padding:5px">${f.c29}</td>
    <td style="text-align:center; border:1px solid #787878; padding:5px"></td>
    <td style="text-align:center; border:1px solid #787878; padding:5px"></td>
    <td style="text-align:center; border:1px solid #787878; padding:5px"></td>
  </tr>
</c:if>
<%@include file="../../footer.jsp"%>

