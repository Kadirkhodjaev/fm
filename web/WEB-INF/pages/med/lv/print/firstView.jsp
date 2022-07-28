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
<table width="95%" style="margin:auto; border-spacing: 0">
  <tr>
    <td colspan="2" align="center"><b>ПЕРВИЧНЫЙ ОСМОТР ВРАЧА</b></td>
  </tr>
  <tr>
    <td colspan="2"><br/></td>
  </tr>
  <tr>
    <td style="border:1px solid #e8e8e8"><b>Пациент(ка):</b> ${p.surname}&nbsp;${p.name}&nbsp;${p.middlename}</td>
    <td style="border:1px solid #e8e8e8"><b>Год рождения:</b> ${p.birthyear}</td>
  </tr>
  <tr>
    <td colspan="2" style="border:1px solid #e8e8e8"><b>Жалобы при поступлении:</b></td>
  </tr>
  <tr>
    <td colspan="2" style="border:1px solid #e8e8e8">${p.jaloby}</td>
  </tr>
  <tr>
    <td colspan="2" style="border:1px solid #e8e8e8">
      <b>Анамнез:</b>
      <p>${p.anamnez}</p>
    </td>
  </tr>
  <tr>
    <td colspan="2" style="border:1px solid #e8e8e8">
      <b>Состояние при поступлении:</b>
      <p>${p.c1}</p>
    </td>
  </tr>
  <tr>
    <td colspan="2" style="border:1px solid #e8e8e8">
      <b>Предварительный диагноз:</b>
      <p>${p.diagnoz}</p>
    </td>
  </tr>
  <tr><td colspan="2"><br/><br/><br/></td></tr>
  <tr>
    <td><b>Врач</b></td>
    <td align="right">${lvFio}</td>
  </tr>
</table>