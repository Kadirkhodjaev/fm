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
<table style="width:95%; margin:auto">
  <tr>
    <td colspan="2" align=center><b>ПРОТОКОЛ ОПЕРАЦИЙ</b></td>
  </tr>
  <tr><td colspan="2">&nbsp;</td></tr>
  <tr>
    <td><b>Пациент(ка):</b> ${form.patient.surname}&nbsp;${form.patient.name}&nbsp;${form.patient.middlename}</td>
    <td><b>Год рождения:</b> ${form.patient.birthyear}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Протокол операции:</b></td>
  </tr>
  <tr>
    <td colspan="2" align=justify>${form.c1}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Наименование операции:</b></td>
  </tr>
  <tr>
    <td colspan="2" align=justify>${form.c2}</b></td>
  </tr>
  <tr>
    <td colspan="2"><b>Дата операции:&nbsp;&nbsp;</ b>${operDate}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Операция:</b></td>
  </tr>
  <tr>
    <td colspan="2" align=justify>${form.c3}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Ход операции:</b></td>
  </tr>
  <tr>
    <td colspan="2" align=justify>${form.c4}</td>
  </tr>
  <tr><td colspan="2"><br/><br/><br/></td></tr>
  <tr>
    <td><b>Врач</b></td>
    <td align="right">${lvFio}</td>
  </tr>
</table>