<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/js/common.js"></script>

<div class="panel panel-info wpx-1400 margin-auto">
  <div class="panel-heading">
    <span class="fa fa-user"></span> Пациент - <span class="text-danger bold">${patient.fio} (${patient.client.birthdate != null ? "ДР" : "ГР"}: <c:if test="${patient.client.birthdate != null}"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${patient.client.birthdate}" /></c:if><c:if test="${patient.client.birthdate == null}">${patient.client.birthyear}</c:if>)</span>
    <ul class="pagination" style="float:right; margin-top:-5px">
      <li class="paginate_button" tabindex="0"><a href="#" onclick="setPage('/ambs/patients.s');return false;"><i class="fa fa-backward"></i> Назад</a></li>
    </ul>
  </div>
  <form id="form-data">
    <input type="hidden" name="id" value="${patient.id}"/>
    <table class="w-100 table-bordered p-5">
      <tbody>
      <tr>
        <td class="right bold" nowrap>Телефон:</td>
        <td class="center">
          ${patient.tel}
        </td>
        <td class="right bold" nowrap>Адрес:</td>
        <td>
          <c:if test="${fn:length(fn:trim(patient.client.country.name)) != 0}">${patient.client.country.name},</c:if> <c:if test="${fn:length(fn:trim(patient.client.region.name)) != 0}">${patient.client.region.name},</c:if> ${patient.address}
        </td>
      </tr>
      <c:if test="${patient.passportInfo != null && patient.passportInfo != '' && fn:length(fn:trim(patient.passportInfo)) != 0}">
        <tr>
          <td class="right bold" nowrap>Паспортные данные:</td>
          <td>
              ${patient.passportInfo}
          </td>
        </tr>
      </c:if>
      <c:if test="${patient.lvpartner != null}">
        <tr>
          <td class="right bold" nowrap>Код отправителя:</td>
          <td colspan="3">
              ${patient.lvpartner.code}
          </td>
        </tr>
      </c:if>
      </tbody>
    </table>
  </form>
</div>
<div id="patient_fizio"></div>

<!--Услуги -->
<div id="patient_services"></div>

<script>
  $(function() {
    <c:if test="${patient.fizio == 'Y'}">
      $('#patient_fizio').load('/ambs/doctor/fizio.s?id=${patient.id}');
    </c:if>
    $('#patient_services').load('/ambs/patient/services.s?id=${patient.id}');
  });
</script>

