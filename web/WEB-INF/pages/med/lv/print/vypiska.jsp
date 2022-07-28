<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<style>
  * {font-size:${sessionScope.fontSize}px !important;}
  * {font-weight: 100}
</style>
<table style="width:95%; margin:auto;">
  <tr>
    <td style="border-bottom:2px solid black; font-weight: bold; text-align: center" colspan="2">
      ГЛАВНОЕ МЕДИЦИНСКОЕ УПРАВЛЕНИЕ при АДМИНИСТРАЦИИ ПРЕЗИДЕНТА РЕСПУБЛИКИ УЗБЕКИСТАН <br/>
      ЦЕНТРАЛЬНАЯ КЛИНИЧЕСКАЯ БОЛЬНИЦА №1
    </td>
  </tr>
  <tr>
    <td style="font-weight: bold; text-align: center" colspan="2">
      <c:if test="${!dieFlag}">
        ВЫПИСКА из истории болезни №${form.patient.yearNum}
      </c:if>
      <c:if test="${dieFlag}">
        ПОСМЕРТНЫЙ ЭПИКРИЗ из истории болезни №${form.patient.yearNum}
      </c:if>
    </td>
  </tr>
  <tr>
    <td><b>Пациент(ка):</b> ${form.patient.surname}&nbsp;${form.patient.name}&nbsp;${form.patient.middlename}</td>
    <td><b>Год рождения:</b> ${form.patient.birthyear}</td>
  </tr>
  <tr>
    <td colspan="2">находился на стац. лечении в ЦКБ №1 ГМУ при АП РУз с ${dateBegin} по ${dateEnd}
  </tr>
  <tr>
    <td colspan="2"><b>Клинический диагноз:</b></td>
  </tr>
  <tr>
    <td colspan="2" align=justify>${form.c1}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Жалобы при поступлении:</b></td>
  </tr>
  <tr>
    <td colspan="2" align=justify>${form.c2}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Из анамнеза:</b></td>
  </tr>
  <tr>
    <td colspan="2" align=justify>${form.c3}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Состояние при поступлении:</b></td>
  </tr>
  <tr>
    <td colspan="2" align=justify>${form.c4}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Проведённые обследования:</b></td>
  </tr>
  <tr>
    <td colspan="2" align=justify${form.c5}</td>
  </tr>
  <tr>
    <td colspan="2"><b>Проведено лечение:</b></td>
  </tr>
  <tr>
    <td colspan="2" align=justify>${form.c6}</td>
  </tr>
  <tr>
    <td colspan="2"><b>
      <c:if test="${!dieFlag}">
        Рекомендовано:
      </c:if>
      <c:if test="${dieFlag}">
        Посмертный диагноз:
      </c:if>
    </b></td>
  </tr>
  <tr>
    <td colspan="2" align=justify>${form.c7}</td>
  </tr>
  <tr><td colspan="2"><br/><br/><br/></td></tr>
  <tr>
    <td><b>Лечащий врач</b></td>
    <td align="right">${lvFio}</td>
  </tr>
  <tr>
    <td><b>Зав. отделением</b></td>
    <td align="right">${zavOtdel.fio}</td>
  </tr>
  <tr>
    <td><b>Зам главного врача</b></td>
    <td align="right">${zamGlb}</td>
  </tr>
</table>