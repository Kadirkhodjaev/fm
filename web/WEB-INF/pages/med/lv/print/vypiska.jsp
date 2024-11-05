<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<style>
  * {font-size:${sessionScope.fontSize}px !important;color:black}
</style>
<table style="width:95%; margin:auto; margin-top:110px">
  <tr>
    <td style="font-weight: bold; text-align: center;font-size:${sessionScope.fontSize + 2}px !important;" colspan="2">
      "Фарход Мадад Шифо" хусусий корхонаси" <br/>Касаллик тарихидан кучирма № ${form.patient.yearNum}
    </td>
  </tr>
  <tr>
    <td colspan="2" style="text-align:center;padding-top:10px">
      <b>Бемор:</b> ${form.patient.surname}&nbsp;${form.patient.name}&nbsp;${form.patient.middlename}
      <b>Тугилган йили:</b> ${form.patient.birthyear}
    </td>
  </tr>
  <tr>
    <td colspan="2" style="text-align:center;padding-top:10px">
      <b>Касалхонага келди:</b> ${dateBegin}
      <b>Касалхонадан кетди:</b> ${dateEnd}
    </td>
  </tr>
  <tr>
    <td colspan="2"><b>КЛИНИК ТАШХИС:</b></td>
  </tr>
  <tr>
    <td colspan="2"><b>Асосий:</b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c1}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Хамрох:</b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c8}</td>
  </tr>
  <c:if test="${form.c9 != '' && form.c9 != null && form.c9 != '<br>'}">
    <tr>
      <td colspan="2"><b>Асорати:</b></td>
    </tr>
    <tr>
      <td colspan="2" align="justify">${form.c9}</td>
    </tr>
  </c:if>
  <tr>
    <td colspan="2"><b>Шикоятлар:</b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c2}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Анамнез:</b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c3}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Объектив:</b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c4}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Утказилган текширувлар:</b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c5}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Утказилган даволашлар:</b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c6}</td>
  </tr>
  <c:if test="${form.c10 != '' && form.c10 != null && form.c10 != '<br>'}">
    <tr>
      <td colspan="2"><b>ЧИКАРУВ ВАКТИДАГИ ТАШХИС:</b></td>
    </tr>
    <tr>
      <td colspan="2"><b>Асосий:</b></td>
    </tr>
    <tr>
      <td colspan="2" align="justify">${form.c10}</td>
    </tr>
  </c:if>

  <c:if test="${form.c11 != '' && form.c11 != null && form.c11 != '<br>'}">
    <tr>
      <td colspan="2"><b>Хамрох:</b></td>
    </tr>
    <tr>
      <td colspan="2" align="justify">${form.c11}</td>
    </tr>
  </c:if>
  <c:if test="${form.c12 != '' && form.c12 != null && form.c12 != '<br>'}">
    <tr>
      <td colspan="2"><b>Асорати:</b></td>
    </tr>
    <tr>
      <td colspan="2" align="justify">${form.c12}</td>
    </tr>
  </c:if>

  <tr>
    <td colspan="2"><b>
      Тавсия:
    </b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c7}</td>
  </tr>
  <tr><td colspan="2"></td></tr>
  <tr>
    <td style="padding-top:10px"><b>Даволовчи шифокор</b></td>
    <td align="right" style="padding-top:10px">${lvFio}</td>
  </tr>
  <tr>
    <td style="padding-top:10px"><b>Булим мудири</b></td>
    <td align="right" style="padding-top:10px">${form.patient.zavlv.fio}</td>
  </tr>
  <tr>
    <td width="50%" style="padding-top:10px"><b>Бош шифокор</b></td>
    <td width="50%" align="right" style="padding-top:10px">${zamGlb}</td>
  </tr>
</table>
