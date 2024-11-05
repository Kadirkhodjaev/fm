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
<table class="formTable" style="width:95%; margin:auto">
  <tr>
    <td colspan="2" align=center><b>КЛИНИК ТАШХИСНИ АСОСЛАШ</b></td>
  </tr>
  <tr><td colspan="2">&nbsp;</td></tr>
  <tr><td colspan="2"><b>Сана:</b> ${form.c8}</td></tr>
  <tr>
    <td><b>Бемор:</b> ${form.patient.surname}&nbsp;${form.patient.name}&nbsp;${form.patient.middlename}</td>
    <td><b>Тугилган йили:</b> ${form.patient.birthyear}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Шикоятлари:</b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c1}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Anamnez</b>:</td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c2}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Status praesens</b>:</td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c3}</td>
  </tr>
  <tr>
    <td colspan="2">Текширув ва тахлиллар</b>:</td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c4}</td>
  </tr>
  <tr><td colspan="2"><b>Ташхис</b></td></tr>
  <tr><td colspan="2"><b>Асосий</b>:</td></tr>
  <tr><td colspan="2" align="justify">${form.c5}</td></tr>
  <tr><td colspan="2"><b>Хамрох</b>:</td></tr>
  <tr><td colspan="2" align="justify">${form.c6}</td></tr>
  <c:if test="${form.c7 != '' && form.c7 != null && form.c7 != '<br>'}">
    <tr><td colspan="2"><b>Асорати</b>:</td></tr>
    <tr><td colspan="2" align="justify">${form.c7}</td></tr>
  </c:if>
  <tr><td colspan="2"><br/><br/><br/></td></tr>
  <tr>
    <td style="padding-top:20px"><b>Даволовчи шифокор</b></td>
    <td align="right">${lvFio}</td>
  </tr>
  <tr>
    <td style="padding-top:20px"><b>Булим бошлиги</b></td>
    <td align="right">${form.patient.zavlv.fio}</td>
  </tr>
</table>
