<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Окно «Похожие клиенты» при регистрации: клиенты с такой же фамилией и именем, выбор существующего --%>
<style>
  .cl-pick { width:100%; border-collapse:separate; border-spacing:0; font-size:13.5px; }
  .cl-pick th { padding:9px 10px; background:#F8F9FA; border-bottom:1px solid #E6E8EC; color:#6B7280; font-size:12px; font-weight:600; text-align:left; white-space:nowrap; }
  .cl-pick td { padding:8px 10px; border-bottom:1px solid #F0F1F4; vertical-align:middle; }
  .cl-pick tr:hover td { background:#FAFBFC; }
  .cl-pick .mut { color:#6B7280; }
  .cl-pick-hint { margin:0 0 12px; color:#6B7280; }
</style>
<p class="cl-pick-hint">В реестре уже есть клиенты с такими данными. Выберите существующего клиента, чтобы не создавать дубликат.</p>
<table class="cl-pick">
  <thead>
  <tr>
    <th style="width:40px">№</th>
    <th>ФИО</th>
    <th style="width:110px">Рождение</th>
    <th style="width:80px">Пол</th>
    <th style="width:150px">Резидентство</th>
    <th style="width:120px">Паспорт</th>
    <th style="width:140px">Телефон</th>
    <th style="width:110px"></th>
  </tr>
  </thead>
  <tbody>
  <c:forEach items="${clients}" var="c" varStatus="loop">
    <tr>
      <td class="mut">${loop.index + 1}</td>
      <td><b>${fn:escapeXml(c.fio)}</b></td>
      <td><fmt:formatDate pattern="dd.MM.yyyy" value="${c.birthdate}"/></td>
      <td class="mut">${c.sex.name}</td>
      <td class="mut">${c.country.name}</td>
      <td>${fn:escapeXml(c.docSeria)} ${fn:escapeXml(c.docNum)}</td>
      <td>${fn:escapeXml(c.tel)}</td>
      <td style="text-align:right"><button type="button" class="ab sm primary" onclick="chooseClient(${c.id})"><i class="fa fa-check"></i> Выбрать</button></td>
    </tr>
  </c:forEach>
  </tbody>
</table>
<c:if test="${empty clients}"><p class="cl-pick-hint" style="margin-top:12px">Похожих клиентов не найдено</p></c:if>
