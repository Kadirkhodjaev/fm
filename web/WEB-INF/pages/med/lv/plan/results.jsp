<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Карточка пациента → Обследования → «Результаты»: все готовые результаты пациента одним списком.
     Открывается во фрейме карточки или отдельным окном (newWindow) --%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Результаты · ${fio}</title>
  <%@include file="/WEB-INF/pages/med/lv/frame_style.jsp"%>
  <style>
    .rs-list { padding:14px 20px 22px; font-size:14px; line-height:1.55; }
    .rs-list b { color:#1F2430; }
    .rs-list i { color:#6B7280; font-style:normal; }
    .rs-list > * { margin-bottom:2px; }
  </style>
</head>
<body>
<div class="ld-sheet" style="max-width:960px">
  <div class="ld-title">
    <i class="fa fa-flask" style="color:#9AA1AC"></i> Результаты обследований <span class="sub">${fio}</span>
    <span class="sp"></span>
    <c:if test="${newWindow}">
      <button type="button" class="fm-btn" onclick="window.print()"><i class="fa fa-print"></i>Печать</button>
      <button type="button" class="fm-btn" onclick="window.close()"><i class="fa fa-times"></i>Закрыть</button>
    </c:if>
    <c:if test="${!newWindow}">
      <button type="button" class="fm-btn" onclick="setLocation('/lv/plan/index.s')"><i class="fa fa-arrow-left"></i>Назад</button>
    </c:if>
  </div>
  <div class="rs-list" id="results">
    <c:forEach items="${results}" var="r">${r}</c:forEach>
    <c:if test="${empty results}"><div class="ld-empty">Готовых результатов пока нет</div></c:if>
  </div>
</div>
<script>
  function delPlan(id) { FmsConfirm('Удалить обследование?', function () { setLocation('?delPlan=Y&id=' + id); }, null, {ok: 'Удалить', danger: true}); }
  function printPlan(id) { window.open('/kdo/print.s?id=' + id); }
</script>
</body>
</html>
