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
        <td colspan="3">
            ${patient.passportInfo}
        </td>
      </tr>
    </c:if>
    <tr>
      <td class="right bold">Услуга:</td>
      <td colspan="3">
        <select class="form-control" onchange="openService(this)">
          <c:forEach items="${services}" var="s">
            <option <c:if test="${s.id == service.id}">selected</c:if> data-state="${s.state}" value="${s.id}">${s.service.name}</option>
          </c:forEach>
        </select>
      </td>
    </tr>
    </tbody>
  </table>
  <div class="border-bottom-1"></div>
  <div id="amb_form"></div>
</div>
<script>
  $(() => {
    $('#amb_form').load('/ambs/work/${service.state == 'DONE' ? 'view' : 'form'}.s?id=${service.id}');
  })
  function openService(dom) {
    var selected = dom.options[dom.selectedIndex];
    var state = selected.getAttribute('data-state');
    $('#amb_form').load('/ambs/work/' + (state === 'DONE' ? 'view' : 'form') + '.s?id=' + dom.value);
  }
</script>

