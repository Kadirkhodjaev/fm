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
<table style="width:500px; margin: auto">
  <tr>
    <td colspan="2" align=center><b>ДОПОЛНИТЕЛЬНЫЕ ДАННЫЕ</b></td>
  </tr>
  <tr><td colspan="2">&nbsp;</td></tr>
  <tr>
    <td><b>Пациент(ка):</b></td>
    <td>${form.patient.surname}&nbsp;${form.patient.name}&nbsp;${form.patient.middlename}</td>
  </tr>
  <tr>
    <td><b>Год рождения:</b></td>
    <td>${form.patient.birthyear}</td>
  </tr>
  <tr>
    <td><b>Лист нетрудоспобности №:</b></td>
    <td>${form.c1}</td>
  </tr>
  <tr>
    <td><b>Продлен:</b></td>
    <td>
      <div style="float:left"><b>с</b>&nbsp;&nbsp;${dateBegin}</div>
      <div style="float:left">&nbsp;&nbsp;<b>по</b>&nbsp;&nbsp;${dateEnd}</div>
    </td>
  </tr>
  <tr>
    <td><b>Умер:</b></td>
    <td>
      ${dateStart}
    </td>
  </tr>
  <tr>
    <td><b>Исход болезни:<b></td>
    <td>${form.c5.name}</td>
  <tr>
    <td><b>Трудоспособность:<b></td>
    <td>${form.c6.name}</td>
  <tr>
    <td><b>Утр. трудоспособности:<b></td>
    <td>${form.c7.name}</td>
  </tr>
</table>