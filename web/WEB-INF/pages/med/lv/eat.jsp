<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Карточка пациента → Питание: стол на каждый приём пищи; сохранение кнопкой карточки (#saveBtn) --%>
<%@include file="/WEB-INF/pages/med/lv/frame_style.jsp"%>
<style>
  .pe-day td { border-top:2px solid #E6E8EC !important; }
  .pe-sel { max-width:260px; }
</style>
<div class="ld-sheet" style="max-width:860px">
  <div class="ld-title">Питание <span class="sub">выбор стола переносится на следующие приёмы пищи</span></div>
  <form name="patient-eat" id="patient-eat" onsubmit="return false">
    <c:if test="${empty eats}"><div class="ld-empty"><i class="fa fa-cutlery"></i> Питание ещё не назначено</div></c:if>
    <c:if test="${not empty eats}">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:130px">Дата</th>
          <th>Приём пищи</th>
          <th style="width:300px">Стол</th>
        </tr>
        </thead>
        <tbody>
        <c:set var="peDay" value=""/>
        <c:forEach items="${eats}" var="eat" varStatus="loop">
          <fmt:formatDate var="d" pattern="dd.MM.yyyy" value="${eat.actDate}"/>
          <tr id="patient-eat-row-${loop.index}" class="${d != peDay && loop.index > 0 ? 'pe-day' : ''}">
            <td><input type="hidden" name="id" value="${eat.id}"><c:if test="${d != peDay}"><b>${d}</b></c:if></td>
            <td class="mut">${eat.menuType.name}</td>
            <td>
              <c:if test="${eat.state == 'ENT' || eat.state == 'REF'}">
                <select class="fm-in pe-sel" name="table" onchange="setPatientTable(this, ${loop.index})">
                  <option value=""></option>
                  <option <c:if test="${eat.state == 'REF'}">selected</c:if> value="-1">Отказ</option>
                  <c:forEach items="${tables}" var="table">
                    <option <c:if test="${table.id == eat.table.id}">selected</c:if> value="${table.id}">${table.name}</option>
                  </c:forEach>
                </select>
              </c:if>
              <c:if test="${eat.state == 'CON'}">
                ${eat.table.name} <span class="ld-tag ok" title="Заявка на питание уже подтверждена">подтверждено</span>
              </c:if>
            </td>
          </tr>
          <c:set var="peDay" value="${d}"/>
        </c:forEach>
        </tbody>
      </table>
    </c:if>
  </form>
</div>
<span id="saveBtn" onclick="savePatientEat()"></span>
<script>
  function savePatientEat() {
    $.ajax({
      url: '/lv/eat.s', method: 'post', data: $('#patient-eat').serialize(), dataType: 'json',
      success: function (res) { FmsToast.show(res.success ? 'Сохранено' : (res.msg || 'Не удалось сохранить'), res.success ? 'ok' : 'err'); }
    });
  }
  function setPatientTable(dom, idx) {
    var counter = ${fn:length(eats)};
    for (var i = idx + 1; i < counter; i++) $('#patient-eat-row-' + i).find('select[name=table]').val(dom.value);
  }
</script>
