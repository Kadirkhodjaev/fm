<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<style>
  * {font-size:${sessionScope.fontSize}px !important;}
</style>
<table class="formTable" style="width:95%; margin:auto">
  <tr>
    <td colspan="2" align="center"><b>ОСМОТР ЛЕЧАЩЕГО ВРАЧА</b></td>
  </tr>
  <tr>
    <td colspan="2"><br/></td>
  </tr>
  <tr>
    <td><b>Пациент(ка):</b> ${form.patient.surname}&nbsp;${form.patient.name}&nbsp;${form.patient.middlename}</td>
    <td><b>Год рождения:</b> ${form.patient.birthyear}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Жалобы при поступлении:</b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c1}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Из анамнеза:</b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c2}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Состояние при поступлении:</b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c3}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Обследование до стационарного лечения:</b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c4}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Предворительный диагноз:</b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c5}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Обоснование препаратов:</b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c6}</td>
  </tr>
  <tr><td colspan="2"><br/><br/><br/></td></tr>
  <tr>
    <td><b>Врач</b></td>
    <td align="right">${lvFio}</td>
  </tr>
</table>