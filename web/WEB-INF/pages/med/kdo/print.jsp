<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Просмотр печати анализа: панель (шрифт, Печать, Word, Закрыть) и лист во фрейме (/kdo/obs.s?print=Y) --%>
<html>
<head>
  <meta charset="UTF-8">
  <title>Печать · ${fn:escapeXml(patFio)}</title>
  <link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
  <%@include file="/WEB-INF/pages/med/kdo/print_style.jsp"%>
</head>
<body>
<div class="pv-bar">
  <span class="ic"><i class="fa fa-flask"></i></span>
  <div class="ttl"><b>${fn:escapeXml(patFio)}</b><span>Результат анализа</span></div>
  <span class="sp"></span>
  <label class="fs">Шрифт
    <select id="pvFont" onchange="pvFont(this.value)">
      <c:forEach begin="10" end="20" step="1" var="s"><option value="${s}" <c:if test="${sessionScope.fontSize == s}">selected</c:if>>${s}</option></c:forEach>
    </select>
  </label>
  <button type="button" class="b" onclick="pvWord()"><i class="fa fa-file-word-o"></i>Word</button>
  <button type="button" class="b main" onclick="pvPrint()"><i class="fa fa-print"></i>Печать</button>
  <button type="button" class="b" onclick="window.close()"><i class="fa fa-times"></i>Закрыть</button>
</div>
<div class="pv-sheet">
  <iframe name="frm" id="frm" src="/kdo/obs.s?print=Y&id=${id}&kdo=${kdoId}&font=${sessionScope.fontSize}" onload="pvFit(this)"></iframe>
</div>
<script>
  function pvFit(f) { try { f.style.height = (f.contentWindow.document.body.scrollHeight + 20) + 'px'; } catch (e) {} }
  function pvFont(s) { document.getElementById('frm').src = '/kdo/obs.s?print=Y&id=${id}&kdo=${kdoId}&font=' + s; }
  function pvPrint() { var w = document.getElementById('frm').contentWindow; w.focus(); w.print(); }
  function pvWord() { document.getElementById('frm').src = '/kdo/obs.s?print=Y&word=Y&id=${id}&kdo=${kdoId}'; }
</script>
</body>
</html>
