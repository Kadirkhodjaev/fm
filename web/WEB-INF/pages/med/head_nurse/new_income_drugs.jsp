<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Склады → Новые медикаменты: новое поступление в аптеку по датам --%>
<%@include file="/WEB-INF/pages/med/head_nurse/hn_style.jsp"%>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-plus-square"></i></span>
        <div>
          <h2>Новые медикаменты в аптеке</h2>
          <span class="fm-count"><b id="niShown">${fn:length(drugs)}</b> из <b>${fn:length(drugs)}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="niSearch" placeholder="Препарат" oninput="hnFilter('ni')" autocomplete="off"/>
      </div>
    </div>
    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:60px">№</th>
          <th>Наименование</th>
          <th style="width:140px" class="nw">Поступило</th>
        </tr>
        </thead>
        <tbody id="niRows">
        <c:forEach items="${drugs}" var="d" varStatus="loop">
          <tr data-s="${fn:escapeXml(d.drug.name)}">
            <td class="mut">${loop.index + 1}</td>
            <td><span class="nm">${d.drug.name}</span></td>
            <td class="nw"><fmt:formatDate pattern="dd.MM.yyyy" value="${d.act.regDate}"/></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="niEmpty" style="display:none"><i class="fa fa-plus-square"></i>Ничего не найдено</div>
    </div>
  </div>
</div>
<script>hnFilter('ni');</script>
