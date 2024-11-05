<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<style>
  * {font-size:${sessionScope.fontSize}px !important;color:black;}
</style>
<table class="formTable" style="width:95%; margin:auto">
  <tr><td colspan="2" align="center"><b>БЎЛИМДАГИ КЎРИК</b></td></tr>
  <tr><td colspan="2"><br/></td></tr>
  <tr><td colspan="2"><b>Сана:</b> ${form.c7}</td></tr>
  <tr>
    <td><b>Бемор:</b> ${form.patient.surname}&nbsp;${form.patient.name}&nbsp;${form.patient.middlename}</td>
    <td><b>Тугилган йили:</b> ${form.patient.birthyear}</td>
  </tr>
  <tr><td colspan="2"><b>Шикоятлари:</b></td></tr>
  <tr><td colspan="2" align="justify">${form.c1}</td></tr>
  <tr><td colspan="2"><b>Anamnesis morbi:</b></td></tr>
  <tr><td colspan="2" align="justify">${form.c2}</td></tr>
  <tr><td colspan="2"><b>Anamnesis vitae:</b></td></tr>
  <tr><td colspan="2" align="justify">${form.c8}</td></tr>
  <tr><td colspan="2"><b>Status praesens:</b></td></tr>
  <tr><td colspan="2" align="justify">${form.c3}</td></tr>
  <tr><td colspan="2"><b>Нафас олиш системаси:</b></td></tr>
  <tr><td colspan="2" align="justify">${form.c9}</td></tr>
  <tr><td colspan="2"><b>Қон айланиш системаси:</b></td></tr>
  <tr><td colspan="2" align="justify">${form.c10}</td></tr>
  <tr><td colspan="2"><b>Хазм қилиш cистемаси:</b></td></tr>
  <tr><td colspan="2" align="justify">${form.c11}</td></tr>
  <tr><td colspan="2"><b>Сийдик-таносил системаси:</b></td></tr>
  <tr><td colspan="2" align="justify">${form.c12}</td></tr>
  <tr><td colspan="2"><b>Нерв системаси:</b></td></tr>
  <tr><td colspan="2" align="justify">${form.c13}</td></tr>
  <tr><td colspan="2"><b>Эндокрин системаси:</b></td></tr>
  <tr><td colspan="2" align="justify">${form.c14}</td></tr>
  <tr><td colspan="2"><b>Қалқонсимон без:</b></td></tr>
  <tr><td colspan="2" align="justify">${form.c15}</td></tr>
  <c:if test="${form.c16 != '' && form.c16 != null && form.c16 != '<br>'}">
    <tr><td colspan="2"><b>Меьда ости бези:</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c16}</td></tr>
  </c:if>
  <c:if test="${form.c4 != '' && form.c4 != null && form.c4 != '<br>'}">
    <tr><td colspan="2"><b>Стационар даволанишдан олдинги муолажалар</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c4}</td></tr>
  </c:if>
  <tr><td colspan="2"><b>Тахминий ташхис: Асосий</b></td></tr>
  <tr><td colspan="2" align="justify">${form.c5}</td></tr>
  <c:if test="${form.c18 != '' && form.c18 != null && form.c18 != '<br>'}">
    <tr><td colspan="2"><b>Тахминий ташхис: Хамрох</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c18}</td></tr>
  </c:if>
  <c:if test="${form.c19 != '' && form.c19 != null && form.c19 != '<br>'}">
    <tr><td colspan="2"><b>Тахминий ташхис: Асорати</b></td></tr>
    <tr><td colspan="2" align="justify">${form.c19}</td></tr>
  </c:if>
  <tr><td colspan="2"></td></tr>
  <tr>
    <td><b>Шифокор</b></td>
    <td align="right">${lvFio}</td>
  </tr>
</table>