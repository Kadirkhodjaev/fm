<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@include file="nurse_style.jsp"%>
<%-- Постовая: палаты отделения. Рассчитано на планшет: крупные плитки, нажатие открывает палату с выбором пациента. --%>
<div class="np">
  <div class="np-head">
    <div class="np-title">
      <span class="ic"><i class="fa fa-hospital-o"></i></span>
      <div>
        <h2>Палаты · ${fn:escapeXml(dep_name)}</h2>
        <span class="sub"><b>${patientsAll}</b> пациентов<c:if test="${pendingAll > 0}"> · <span class="warn">${pendingAll} ждут процедур</span></c:if></span>
      </div>
    </div>
    <span class="np-spacer"></span>
    <div class="np-seg">
      <button type="button" class="${time == '1' ? 'on' : ''}" onclick="setPage('/proc/palatas.s?time=1')"><i class="fa fa-sun-o"></i> Утро</button>
      <button type="button" class="${time == '2' ? 'on' : ''}" onclick="setPage('/proc/palatas.s?time=2')"><i class="fa fa-cutlery"></i> День</button>
      <button type="button" class="${time == '3' ? 'on' : ''}" onclick="setPage('/proc/palatas.s?time=3')"><i class="fa fa-moon-o"></i> Вечер</button>
    </div>
  </div>

  <div class="np-rooms">
    <c:forEach items="${rooms}" var="r">
      <button type="button" class="np-room ${r.pending > 0 ? 'pending' : r.withMeds > 0 ? 'done' : ''}" onclick="setPage('/proc/palata.s?id=${r.id}')">
        <span class="rn">${fn:escapeXml(r.name)}<c:if test="${not empty r.type}"><small>${fn:escapeXml(r.type)}</small></c:if></span>
        <span class="people">
          <c:forEach items="${r.patients}" var="p">
            <i class="fa ${p.sex == 'F' ? 'fa-female' : p.sex == 'M' ? 'fa-male' : 'fa-user'} ${p.pending > 0 ? 'p-pend' : p.meds ? 'p-done' : 'p-none'}"
               title="${fn:escapeXml(p.fio)}"></i>
          </c:forEach>
        </span>
        <span class="st">
          <c:choose>
            <c:when test="${r.pending > 0}"><i class="fa fa-clock-o"></i> ждут: ${r.pending} из ${fn:length(r.patients)}</c:when>
            <c:when test="${r.withMeds > 0}"><i class="fa fa-check"></i> всё сделано</c:when>
            <c:otherwise>${fn:length(r.patients)} пац. · нет процедур</c:otherwise>
          </c:choose>
        </span>
      </button>
    </c:forEach>
  </div>
  <c:if test="${empty rooms}">
    <div class="np-empty"><i class="fa fa-hospital-o"></i>В отделении нет пациентов на лечении</div>
  </c:if>
</div>
