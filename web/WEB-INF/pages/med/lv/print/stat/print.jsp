<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Статистическая карта: панель (шрифт, Word, Печать, Закрыть) и лист во фрейме (${printPage}) --%>
<%
  String stat = request.getParameter("stat");
  String params = stat == null ? "" : "&stat=" + stat;
%>
<html>
<head>
  <meta charset="UTF-8">
  <title>Статистическая карта</title>
  <link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
  <%@include file="/WEB-INF/pages/med/kdo/print_style.jsp"%>
</head>
<body>
<div class="pv-bar">
  <span class="ic"><i class="fa fa-file-text-o"></i></span>
  <div class="ttl"><b>Статистическая карта</b><span>выбывшего из стационара</span></div>
  <span class="sp"></span>
  <label class="fs">Шрифт
    <select onchange="document.location = '/lv/stat.s?font=' + this.value + '<%=params%>'">
      <c:forEach begin="10" end="20" step="1" var="s"><option value="${s}" <c:if test="${sessionScope.fontSize == s}">selected</c:if>>${s}</option></c:forEach>
    </select>
  </label>
  <button type="button" class="b" onclick="pvWord()"><i class="fa fa-file-word-o"></i>Word</button>
  <button type="button" class="b main" onclick="pvPrint()"><i class="fa fa-print"></i>Печать</button>
  <button type="button" class="b" onclick="window.close()"><i class="fa fa-times"></i>Закрыть</button>
</div>
<div class="pv-sheet">
  <iframe name="frm" id="frm" src="${printPage}" style="min-height:900px"></iframe>
</div>
<script>
  function pvPrint() { var w = document.getElementById('frm').contentWindow; w.focus(); w.print(); }
  function pvWord() {
    var url = '${printPage}';
    document.getElementById('frm').src = url + (url.indexOf('?') == -1 ? '?' : '&') + 'print=Y&word=Y';
  }
  (function fit(n) {
    var f = document.getElementById('frm');
    try {
      var d = f.contentWindow.document, h = d.body.scrollHeight, w = d.documentElement.scrollWidth;
      if (h) f.style.height = (h + 30) + 'px';
      d.documentElement.style.overflowX = 'hidden';
      // широкое содержимое: лист расширяется, чтобы внутри не было прокрутки
      if (w > f.clientWidth + 1) { var sh = f.parentNode; sh.style.maxWidth = 'none'; sh.style.width = (w + sh.offsetWidth - f.clientWidth) + 'px'; }
    } catch (e) {}
    if (n > 0) setTimeout(function () { fit(n - 1); }, 700);
  })(15);
</script>
</body>
</html>
