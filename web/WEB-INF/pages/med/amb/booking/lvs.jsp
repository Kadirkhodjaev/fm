<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Амбулаторные услуги → Бронирование: предстоящие брони, где врач назначен исполнителем --%>
<%@include file="/WEB-INF/pages/med/mn/mn_style.jsp"%>
<style>
  .bk-st { display:inline-flex; align-items:center; gap:6px; font-size:12.5px; color:#6B7280; white-space:nowrap; }
  .bk-st::before { content:''; width:8px; height:8px; border-radius:50%; background:#E0A33A; }
  .bk-st.done::before { background:#2E9E62; }
  #bkRows td.tm { font-weight:700; font-variant-numeric:tabular-nums; white-space:nowrap; }
</style>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-calendar"></i></span>
        <div>
          <h2>Бронирование</h2>
          <span class="fm-count"><b id="bkShown">${fn:length(rows)}</b> из <b>${fn:length(rows)}</b> · мои предстоящие приёмы</span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="bkSearch" placeholder="ФИО, телефон или услуга" oninput="mnFilter('bk')" autocomplete="off"/>
      </div>
    </div>
    <div class="fm-table-wrap">
      <table class="mn">
        <thead>
        <tr>
          <th style="width:50px">№</th>
          <th style="width:140px">Дата и время</th>
          <th class="l">ФИО</th>
          <th class="l">Услуги</th>
          <th style="width:110px">Рождение</th>
          <th style="width:150px">Телефон</th>
          <th style="width:150px">Статус</th>
        </tr>
        </thead>
        <tbody id="bkRows">
        <c:forEach items="${rows}" var="a" varStatus="loop">
          <tr data-s="${fn:escapeXml(a.fio)} ${fn:escapeXml(a.tel)} ${fn:escapeXml(services[a.id])}" onclick="mnSel(this)">
            <td class="c m">${loop.index + 1}</td>
            <td class="c tm"><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${a.regDate}"/></td>
            <td class="nm">${fn:escapeXml(a.fio)}</td>
            <td>${fn:escapeXml(services[a.id])}</td>
            <td class="c"><fmt:formatDate pattern="dd.MM.yyyy" value="${a.birthday}"/></td>
            <td class="c">${fn:escapeXml(a.tel)}</td>
            <td class="c"><span class="bk-st ${a.state == 'ENT' ? '' : 'done'}">${a.state == 'ENT' ? 'Ожидает' : 'Зарегистрирован'}</span></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="bkEmpty" style="display:${empty rows ? 'block' : 'none'}"><i class="fa fa-calendar"></i>Предстоящих броней нет</div>
    </div>
  </div>
</div>
