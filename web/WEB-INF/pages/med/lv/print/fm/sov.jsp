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
    <td colspan="2" align="center"><b>
      Совместный обход главного врача,<br/>
      зам.главного врача,<br/>
      зав. отделения и лечащего врача</b>
    </td>
  </tr>
  <tr>
    <td colspan="2"><br/></td>
  </tr>
  <tr>
    <td><b>Бемор:</b> ${form.patient.surname}&nbsp;${form.patient.name}&nbsp;${form.patient.middlename}</td>
    <td><b>Тугилган йили:</b> ${form.patient.birthyear}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Шикоятлар:</b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c1}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Анамнез:</b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c2}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Беморнинг холати:</b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c3}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Клиник ташхисни асослаш</b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c4}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Ташхис:</b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c5}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Тавсиялар:</b></td>
  </tr>
  <tr>
    <td colspan="2" align="justify">${form.c6}</td>
  </tr>
  <tr>
    <td colspan="2"><br/></td>
  </tr>
  <tr>
  <td><b>Шифокор</b></td>
  <td align="right">${lvFio}</td>
  </tr>
  <tr>
    <td><b>Булим мудири</b></td>
    <td align="right">${zavOtdel.fio}</td>
  </tr>
  <tr>
    <td><b>Бош шифокор уринбосари</b></td>
    <td align="right">${zamGlb}</td>
  </tr>
  <tr>
    <td><b>Бош шификор</b></td>
    <td align="right">${glb}</td>
  </tr>
</table>