<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Администрирование → Пакеты услуг: список пакетов амбулатории со сроком действия и стоимостью --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<jsp:useBean id="pkNow" class="java.util.Date"/>
<c:set var="cntA" value="0"/>
<c:forEach items="${rows}" var="o"><c:if test="${o.state == 'A'}"><c:set var="cntA" value="${cntA + 1}"/></c:if></c:forEach>
<style>
  .pk-num { text-align:right; white-space:nowrap; font-variant-numeric:tabular-nums; }
  .pk-exp { color:#A50F22; font-size:12px; font-weight:600; margin-left:6px; }
</style>
<div class="fm-page fm-admin">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-medkit"></i></span>
        <div>
          <h2>Пакеты услуг</h2>
          <span class="fm-count"><b id="pkShown">${fn:length(rows)}</b> из <b>${fn:length(rows)}</b> · активных <b>${cntA}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="pkSeg">
        <button type="button" data-f="" onclick="DK.seg('pk', this)">Все</button>
        <button type="button" data-f="A" class="on" onclick="DK.seg('pk', this)">Активные</button>
        <button type="button" data-f="P" onclick="DK.seg('pk', this)">Пассивные</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="pkSearch" placeholder="Название пакета" oninput="DK.filter('pk')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn primary" onclick="setPage('/admin/pack/info.s?id=0')"><i class="fa fa-plus"></i>Новый пакет</button>
    </div>
    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:50px">№</th>
          <th>Пакет</th>
          <th style="width:200px">Действует</th>
          <th class="r" style="width:150px">Стоимость</th>
          <th class="r" style="width:150px">С НДС</th>
          <th style="width:120px">Состояние</th>
          <th style="width:50px"></th>
        </tr>
        </thead>
        <tbody id="pkRows">
        <c:forEach items="${rows}" var="obj" varStatus="loop">
          <tr class="go" style="cursor:pointer" data-f="${obj.state == 'A' ? 'A' : 'P'}" data-s="${fn:escapeXml(obj.name)}" onclick="setPage('/admin/pack/info.s?id=${obj.id}')" title="Открыть пакет">
            <td class="mut">${loop.index + 1}</td>
            <td><span class="nm">${obj.name}</span></td>
            <td class="mut" style="white-space:nowrap">
              <fmt:formatDate pattern="dd.MM.yyyy" value="${obj.start}"/> — <c:choose><c:when test="${empty obj.end}">без срока</c:when><c:otherwise><fmt:formatDate pattern="dd.MM.yyyy" value="${obj.end}"/></c:otherwise></c:choose>
              <c:if test="${not empty obj.end && obj.end.time < pkNow.time}"><span class="pk-exp">истёк</span></c:if>
            </td>
            <td class="pk-num"><fmt:formatNumber value="${obj.price}" pattern="#,##0.##"/></td>
            <td class="pk-num"><b><fmt:formatNumber value="${obj.price * (100 + ndsProc) / 100}" pattern="#,##0.##"/></b></td>
            <td><span class="dk-st ${obj.state == 'A' ? 'A' : 'P'}">${obj.state == 'A' ? 'Активный' : 'Пассивный'}</span></td>
            <td class="r"><button type="button" class="fm-act" title="Открыть"><i class="fa fa-pencil"></i></button></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="pkEmpty" style="display:none"><i class="fa fa-medkit"></i>Пакетов нет</div>
    </div>
  </div>
</div>
<script>DK.filter('pk');</script>
