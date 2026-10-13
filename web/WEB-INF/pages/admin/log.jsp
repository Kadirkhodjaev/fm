<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Администрирование → Протокол входов пользователей --%>
<%@include file="/WEB-INF/pages/med/mn/mn_style.jsp"%>
<div class="fm-page fm-admin">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-history"></i></span>
        <div>
          <h2>Протокол</h2>
          <span class="fm-count"><b id="lgShown">${fn:length(rows)}</b> из <b>${fn:length(rows)}</b> · входы за период</span>
        </div>
      </div>
      <div class="mn-flt">
        <input id="period_start" type="text" class="fm-in datepicker" value="${period_start}" autocomplete="off"/>
        <span class="dash">—</span>
        <input id="period_end" type="text" class="fm-in datepicker" value="${period_end}" autocomplete="off"/>
        <div style="width:240px">
          <select class="fm-in" id="lgUser" onchange="lgGo()">
            <option value="0">Все пользователи</option>
            <c:forEach items="${users}" var="u">
              <option <c:if test="${u.id == user_id}">selected</c:if> value="${u.id}">${u.fio}</option>
            </c:forEach>
          </select>
        </div>
        <input id="lgIp" type="text" class="fm-in" style="width:150px" value="${fn:escapeXml(filterWord)}" placeholder="IP адрес" autocomplete="off" onkeydown="if (event.keyCode == 13) lgGo()"/>
        <button type="button" class="fm-btn" onclick="lgGo()"><i class="fa fa-search"></i>Показать</button>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="lgSearch" placeholder="Пользователь или IP" oninput="mnFilter('lg')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn" onclick="mnExcel('lgTable', 'protokol')"><i class="fa fa-file-excel-o"></i>Excel</button>
    </div>
    <div class="fm-table-wrap">
      <table class="mn" id="lgTable">
        <thead>
        <tr>
          <th style="width:60px">#</th>
          <th class="l">Пользователь</th>
          <th style="width:200px">IP</th>
          <th style="width:180px">Дата и время</th>
        </tr>
        </thead>
        <tbody id="lgRows">
        <c:forEach items="${rows}" var="s" varStatus="loop">
          <tr data-s="${fn:escapeXml(s.user.fio)} ${fn:escapeXml(s.ip)}" onclick="mnSel(this)">
            <td>${loop.index + 1}</td>
            <td class="l">${s.user.fio}</td>
            <td>${fn:escapeXml(s.ip)}</td>
            <td><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${s.dateTime}"/></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="lgEmpty" style="display:${empty rows ? 'block' : 'none'}"><i class="fa fa-history"></i>Записей нет</div>
    </div>
  </div>
</div>
<script>
  function lgGo() {
    mnPeriod('/admin/log.s', '&user=' + $('#lgUser').val() + '&ip=' + encodeURIComponent($.trim($('#lgIp').val())));
  }
</script>
