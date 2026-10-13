<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Карточка пациента → История: прежние госпитализации и амбулаторные визиты этого клиента --%>
<%@include file="/WEB-INF/pages/med/lv/frame_style.jsp"%>
<style>
  .hs-row { cursor:pointer; }
  .hs-row:hover td { background:#F8F9FB; }
  .hs-row .nm { color:#1F2430; font-weight:600; }
</style>
<div class="ld-sheet" style="max-width:960px">
  <div class="ld-title"><i class="fa fa-hospital-o" style="color:#9AA1AC"></i> Стационар <span class="sub">${fn:length(stats)}</span></div>
  <c:if test="${empty stats}"><div class="ld-empty">Госпитализаций нет</div></c:if>
  <c:if test="${not empty stats}">
    <table class="fm-grid">
      <thead>
      <tr><th>ФИО</th><th style="width:110px">Поступил</th><th style="width:110px">Выписан</th><th style="width:80px">№ ИБ</th><th>Отд. / палата</th><th style="width:110px">Состояние</th></tr>
      </thead>
      <tbody>
      <c:forEach items="${stats}" var="p">
        <tr class="hs-row" onclick="parent.openMainPage('/${p.state == 'ARCH' ? 'view' : 'lv'}/index.s?id=${p.id}', false)" title="Открыть карточку">
          <td class="nm">${p.fio}</td>
          <td><fmt:formatDate pattern="dd.MM.yyyy" value="${p.dateBegin}"/></td>
          <td><fmt:formatDate pattern="dd.MM.yyyy" value="${p.dateEnd}"/></td>
          <td>${p.yearNum}</td>
          <td class="mut">${p.dept.name}<c:if test="${not empty p.room}"> / ${p.room.name}</c:if></td>
          <td><span class="ld-tag ${p.state == 'ARCH' ? '' : 'ok'}">${p.state == 'ARCH' ? 'Архив' : 'Текущий'}</span></td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </c:if>
</div>
<div class="ld-sheet" style="max-width:960px">
  <div class="ld-title"><i class="fa fa-stethoscope" style="color:#9AA1AC"></i> Амбулатория <span class="sub">${fn:length(ambs)}</span></div>
  <c:if test="${empty ambs}"><div class="ld-empty">Амбулаторных визитов нет</div></c:if>
  <c:if test="${not empty ambs}">
    <table class="fm-grid">
      <thead>
      <tr><th>ФИО</th><th style="width:120px">Год рождения</th><th style="width:130px">Дата рег.</th><th style="width:110px">Состояние</th></tr>
      </thead>
      <tbody>
      <c:forEach items="${ambs}" var="p">
        <tr class="hs-row" onclick="parent.openMainPage('/amb/reg.s?id=${p.id}&stat=${pat.id}', false)" title="Открыть визит">
          <td class="nm">${p.fio}</td>
          <td>${p.birthyear}</td>
          <td><fmt:formatDate pattern="dd.MM.yyyy" value="${p.crOn}"/></td>
          <td><span class="ld-tag ${p.state == 'ARCH' ? '' : 'ok'}">${p.state == 'ARCH' ? 'Архив' : 'Текущий'}</span></td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </c:if>
</div>
