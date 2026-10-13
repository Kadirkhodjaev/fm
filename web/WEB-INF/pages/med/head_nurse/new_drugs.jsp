<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Склады → Новые назначения: листы назначения по дням --%>
<%@include file="/WEB-INF/pages/med/head_nurse/hn_style.jsp"%>
<div class="fm-page" style="height:auto; min-height:100%">
  <div class="fm-toolbar" style="background:#fff; border:1px solid #E6E8EC; border-radius:16px">
    <div class="fm-title">
      <span class="ic"><i class="fa fa-medkit"></i></span>
      <div>
        <h2>Новые назначения</h2>
        <span class="fm-count">листов назначения: <b>${fn:length(list)}</b></span>
      </div>
    </div>
    <span class="fm-spacer"></span>
    <div class="fm-search-wrap">
      <i class="fa fa-search"></i>
      <input type="text" class="fm-search" id="ndSearch" placeholder="Пациент или препарат" oninput="ndFilter()" autocomplete="off"/>
    </div>
  </div>
  <c:if test="${empty list}">
    <div class="fm-box" style="flex:none"><div class="fm-empty"><i class="fa fa-medkit"></i>Новых назначений нет</div></div>
  </c:if>
  <c:forEach items="${list}" var="f">
    <div class="fm-box nd-day" style="flex:none">
      <div class="fm-toolbar">
        <div class="fm-title"><h2 style="font-size:14px">Лист назначения · <fmt:formatDate pattern="dd.MM.yyyy" value="${f.date}"/></h2></div>
        <span class="fm-count">· ${fn:length(f.drugs)}</span>
      </div>
      <div style="border-top:1px solid #E6E8EC">
        <table class="fm-grid">
          <thead>
          <tr>
            <th style="width:280px">Пациент</th>
            <th>Назначение</th>
            <th style="width:300px">Описание</th>
            <th style="width:130px" class="nw">Назначено</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach items="${f.drugs}" var="d">
            <c:set var="names"><c:forEach items="${d.rows}" var="row" varStatus="loop">${row.name}<c:if test="${!loop.last}"> + </c:if></c:forEach></c:set>
            <tr data-s="${fn:toLowerCase(fn:escapeXml(d.patient.fio))} ${d.patient.yearNum} ${fn:toLowerCase(fn:escapeXml(names))}">
              <td><span class="nm">${d.patient.fio}</span><span class="mut" style="color:#6B7280"> · ИБ №${d.patient.yearNum}</span></td>
              <td>${names}</td>
              <td class="mut">${d.note}</td>
              <td class="mut nw"><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${d.crOn}"/></td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </c:forEach>
</div>
<script>
  function ndFilter() {
    var q = $.trim($('#ndSearch').val()).toLowerCase();
    $('.nd-day').each(function () {
      var n = 0;
      $(this).find('tbody tr').each(function () {
        var ok = !q || String($(this).attr('data-s')).indexOf(q) >= 0;
        $(this).toggle(ok);
        if (ok) n++;
      });
      $(this).toggle(n > 0);
    });
  }
</script>
