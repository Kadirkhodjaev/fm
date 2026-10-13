<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Карточка пациента (просмотр) → Обследования: список назначенных обследований; по названию открывается печать результата --%>
<%@include file="/WEB-INF/pages/med/lv/frame_style.jsp"%>
<style>
  .pv-n { color:#1F2430; font-weight:600; cursor:pointer; }
  .pv-n:hover { color:#A50F22; text-decoration:underline; }
</style>
<div class="ld-sheet" style="max-width:1100px">
  <div class="ld-title">
    <i class="fa fa-flask" style="color:#9AA1AC"></i> Обследования
    <span class="sub">${pat.surname} ${pat.name} ${pat.middlename}<c:if test="${not empty pat.birthyear}"> · ${pat.birthyear} г.р.</c:if></span>
    <span class="sp"></span>
    <c:if test="${pat.state == 'ARCH'}"><span class="ld-tag" title="Пациент в архиве"><i class="fa fa-lock"></i>только просмотр</span></c:if>
  </div>
  <div class="ld-body">
    <c:if test="${empty plans}"><div class="ld-empty">Обследования не назначены</div></c:if>
    <c:if test="${not empty plans}">
      <table class="fm-grid" style="margin-top:12px">
        <thead>
        <tr>
          <th style="width:40px">№</th>
          <th>Наименование</th>
          <th style="width:110px">Дата</th>
          <th style="width:70px">Кол-во</th>
          <th style="width:110px">Статус</th>
          <th>Примечание</th>
          <th style="width:200px">Врач</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${plans}" var="p" varStatus="loop">
          <tr>
            <td class="mut">${loop.index + 1}</td>
            <td><span class="pv-n" title="Открыть результат" onclick="window.open('/kdo/print.s?id=${p.c1}')">${p.c4}</span></td>
            <td>${p.c5}</td>
            <td>${p.c14}</td>
            <td><span class="ld-tag ${p.c7 == 'Y' ? 'ok' : ''}">${p.c7 == 'Y' ? 'готово' : 'ожидает'}</span></td>
            <td class="mut">${p.c6}</td>
            <td>${p.c9}</td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </c:if>
  </div>
</div>
