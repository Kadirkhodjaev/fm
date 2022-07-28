<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  if(request.getParameter("word") != null) {
    response.setContentType("application/msword;charset=UTF-8");
    response.setHeader("Content-Disposition", "attachment; filename=report.doc;");
  }
%>
<c:if test="${print}">
  <style>
    * {font-size:${sessionScope.fontSize}px !important;}
    table {width:95% !important;}
  </style>
</c:if>
<table class="formTable" width="700px" style="margin:auto; border-spacing: 0">
  <tr>
    <td style="border:1px solid #e8e8e8"><b><ui:message code="surname"/> :</b></td>
    <td style="border:1px solid #e8e8e8">${p.surname}</td>
    <td style="border:1px solid #e8e8e8"><b><ui:message code="category"/> :</b></td>
    <td style="border:1px solid #e8e8e8">${p.cat.name}</td>
  </tr>
  <tr>
    <td style="border:1px solid #e8e8e8"><b><ui:message code="first_name"/> :</b></td>
    <td style="border:1px solid #e8e8e8">${p.name}</td>
    <td style="border:1px solid #e8e8e8"><b><ui:message code="terBeseda"/> :</b></td>
    <td style="border:1px solid #e8e8e8">${p.tarDate}</td>
  </tr>
  <tr>
    <td style="border:1px solid #e8e8e8"><b><ui:message code="middle_name"/> :</b></td>
    <td style="border:1px solid #e8e8e8">${p.middlename}</td>
    <td style="border:1px solid #e8e8e8"><b><ui:message code="temperature"/> :</b></td>
    <td style="border:1px solid #e8e8e8">${p.temp}</td>
  </tr>
  <tr>
    <td style="border:1px solid #e8e8e8"><b><ui:message code="birthyear"/> :</b></td>
    <td style="border:1px solid #e8e8e8">${p.birthyear}</td>
    <td style="border:1px solid #e8e8e8"><b><ui:message code="rost"/> :</b></td>
    <td style="border:1px solid #e8e8e8">${p.rost}</td>
  </tr>
  <tr>
    <td style="border:1px solid #e8e8e8"><b><ui:message code="post"/> :</b></td>
    <td style="border:1px solid #e8e8e8">${p.post}</td>
    <td style="border:1px solid #e8e8e8"><b><ui:message code="ves"/> :</b></td>
    <td style="border:1px solid #e8e8e8">${p.ves}</td>
  </tr>
  <tr>
    <td style="border:1px solid #e8e8e8"><b><ui:message code="phone"/> :</b></td>
    <td style="border:1px solid #e8e8e8">${p.tel}</td>
    <td style="border:1px solid #e8e8e8"><b><ui:message code="ambNomer"/> :</b></td>
    <td style="border:1px solid #e8e8e8">${p.ambNum}</td>
  </tr>
  <tr>
    <td style="border:1px solid #e8e8e8"><b><ui:message code="workPlace"/> :</b></td>
    <td style="border:1px solid #e8e8e8">${p.work}</td>
    <td style="border:1px solid #e8e8e8"><b><ui:message code="pitanie"/> :</b></td>
    <td style="border:1px solid #e8e8e8">${p.pitanie.name}</td>
  </tr>
  <tr>
    <td style="border:1px solid #e8e8e8"><b><ui:message code="passportInfo"/> :</b></td>
    <td style="border:1px solid #e8e8e8">${p.passportInfo}</td>
    <td style="border:1px solid #e8e8e8"><b><ui:message code="lgotaType"/> :</b></td>
    <td style="border:1px solid #e8e8e8">${p.lgotaType.name}</td>
  </tr>
  <tr>
    <td style="border:1px solid #e8e8e8"><b><ui:message code="livePlace"/> :</b></td>
    <td style="border:1px solid #e8e8e8">${p.address}</td>
    <td style="border:1px solid #e8e8e8"><b><ui:message code="patientRedirect"/> :</b></td>
    <td style="border:1px solid #e8e8e8">${p.redirect.name}</td>
  </tr>
  <tr>
    <td style="border:1px solid #e8e8e8"><b><ui:message code="sex"/> :</b></td>
    <td style="border:1px solid #e8e8e8">${p.sex.name}</td>
    <td style="border:1px solid #e8e8e8"><b><ui:message code="vidPerevoz"/> :</b></td>
    <td style="border:1px solid #e8e8e8">${p.vidPer.name}</td>
  </tr>
  <tr>
    <td style="border:1px solid #e8e8e8"><b><ui:message code="metka"/> :</b></td>
    <td style="border:1px solid #e8e8e8">${p.metka.name}</td>
    <td style="border:1px solid #e8e8e8"><b>Время регистраций :</b></td>
    <td style="border:1px solid #e8e8e8">${p.time}</td>
  </tr>
  <tr>
    <td><b><ui:message code="diagnozOrg"/> :</b></td>
    <td colspan="3">${p.diagnoz}</td>
  </tr>
  <tr><td colspan="4"><br/></td></tr>
  <tr>
    <td colspan="4"><b>ПРАВИЛА ВНУТРЕННЕГО РАСПОРЯДКА</b><br/></td>
  </tr>
  <tr><td colspan="4"><br/></td></tr>
  <tr>
    <td colspan="4"><b>
      <ul>
        <li>Больной не имеет права отлучаться без ведома главного врача.
        <li>Должен соблюдать больничный режим и распорядок дня.
        <li>Несет прямую ответственность за порчу оборудования, инвентаря, инструментария, аппаратуры.
        <li>Не имеет права пользоваться электрообогревателем и кипятильником.
        <li>За сохранность ценных вещей и денег администрация ответственности не несет.
        <li>Курение в палатах категорически запрещается!
        <li>Выписка больных до 12:00.
      </ul></b>
    </td>
  </tr>
</table>