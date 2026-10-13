<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Карточка пациента → печать раздела: панель (шрифт, Word, Печать, Закрыть) и лист во фрейме (${printPage}?print=Y) --%>
<%
  String params = "";
  String consul = request.getParameter("consul");
  params = consul == null ? "" : "&consul=" + consul;
  String dairy = request.getParameter("dairyId");
  params += dairy == null ? "" : "&dairyId=" + dairy;
  String dairyIds = request.getParameter("dairyIds");
  params += dairyIds == null ? "" : "&dairyIds=" + dairyIds;
  String diagnoz = request.getParameter("diagnoz");
  params += diagnoz == null ? "" : "&diagnoz=" + diagnoz;
  String obos = request.getParameter("obos");
  params += obos == null ? "" : "&obos=" + obos;
%>
<html>
<head>
  <meta charset="UTF-8">
  <title>Печать · ${fn:escapeXml(patFio)}</title>
  <link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
  <%@include file="/WEB-INF/pages/med/kdo/print_style.jsp"%>
</head>
<body>
<div class="pv-bar">
  <span class="ic"><i class="fa fa-file-text-o"></i></span>
  <div class="ttl"><b>${fn:escapeXml(patFio)}</b><span>История болезни</span></div>
  <span class="sp"></span>
  <label class="fs">Шрифт
    <select onchange="document.location = '/lv/print.s?font=' + this.value + '<%=params%>'">
      <c:forEach begin="10" end="20" step="1" var="s"><option value="${s}" <c:if test="${sessionScope.fontSize == s}">selected</c:if>>${s}</option></c:forEach>
    </select>
  </label>
  <button type="button" class="b" onclick="pvWord()"><i class="fa fa-file-word-o"></i>Word</button>
  <button type="button" class="b main" onclick="pvPrint()"><i class="fa fa-print"></i>Печать</button>
  <button type="button" class="b" onclick="window.close()"><i class="fa fa-times"></i>Закрыть</button>
</div>
<div class="pv-sheet">
  <iframe name="frm" id="frm" src="${printPage}${fn:contains(printPage, '?') ? '&' : '?'}print=Y" style="min-height:900px"></iframe>
</div>
<script>
  function pvPrint() { var w = document.getElementById('frm').contentWindow; w.focus(); w.print(); }
  function pvWord() {
    var url = '${printPage}';
    document.getElementById('frm').src = url + (url.indexOf('?') == -1 ? '?' : '&') + 'print=Y&word=Y';
  }
  // высота листа по содержимому
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
