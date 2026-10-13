<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Питание → заявка → пациенты на дату и приём пищи, со столом --%>
<%@include file="/WEB-INF/pages/med/head_nurse/hn_style.jsp"%>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-users"></i></span>
        <div>
          <h2>Пациенты заявки · <fmt:formatDate pattern="dd.MM.yyyy" value="${claim.menu.menuDate}"/> · ${claim.menuType.name}</h2>
          <span class="fm-count"><b id="epShown">${fn:length(patients)}</b> из <b>${fn:length(patients)}</b> пациентов</span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="epSeg" style="flex-wrap:wrap">
        <button type="button" data-f="" class="on" onclick="hnSeg('ep', this)">Все столы</button>
        <c:set var="prevT" value="-"/>
        <c:forEach items="${patients}" var="r">
          <c:if test="${r.c5 != prevT}">
            <button type="button" data-f="${fn:escapeXml(r.c5)}" onclick="hnSeg('ep', this)">${empty r.c5 ? 'Без стола' : r.c5}</button>
            <c:set var="prevT" value="${r.c5}"/>
          </c:if>
        </c:forEach>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="epSearch" placeholder="ФИО, ИБ, отделение, врач" oninput="hnFilter('ep')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn" onclick="setPage('/eats/claim.s?id=${claim.id}')"><i class="fa fa-arrow-left"></i>Назад</button>
    </div>
    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:50px">№</th>
          <th style="width:80px">ИБ</th>
          <th>ФИО</th>
          <th style="width:200px">Лечащий врач</th>
          <th style="width:220px">Отд. / палата</th>
          <th style="width:150px" class="nw">Поступил</th>
          <th style="width:110px" class="nw">Выписка</th>
          <th style="width:130px">Стол</th>
        </tr>
        </thead>
        <tbody id="epRows">
        <c:forEach items="${patients}" var="r" varStatus="loop">
          <tr data-f="${fn:escapeXml(r.c5)}" data-s="${fn:toLowerCase(fn:escapeXml(r.fio))} ${r.ib} ${fn:toLowerCase(fn:escapeXml(r.c1))} ${fn:toLowerCase(fn:escapeXml(r.c6))}">
            <td class="mut">${loop.index + 1}</td>
            <td>${r.ib}</td>
            <td><span class="nm">${fn:escapeXml(r.fio)}</span></td>
            <td class="mut">${r.c6}</td>
            <td class="mut">${r.c1}</td>
            <td class="nw">${r.c2}<c:if test="${not empty r.c3}"> <span class="mut">${r.c3}</span></c:if></td>
            <td class="nw">${empty r.c4 ? '—' : r.c4}</td>
            <td><span class="hn-tag">${empty r.c5 ? 'без стола' : r.c5}</span></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="epEmpty" style="display:${empty patients ? 'block' : 'none'}"><i class="fa fa-users"></i>Пациентов нет</div>
    </div>
  </div>
</div>
