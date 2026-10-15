<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Амбулатория → просмотр печати: панель (шрифт, Word, Печать, Закрыть) и лист во фрейме.
     Лист: результаты услуг (/amb/printPage.s), физиотерапия, чек кассы или чек аптеки --%>
<%
  String ids = request.getParameter("ids");
  String fizioPrint = request.getParameter("fizio");
  String params = ids == null ? "" : "&ids=" + ids;
  if(fizioPrint != null) params += "&fizio=Y";
%>
<html>
<head>
  <meta charset="UTF-8">
  <title>Печать · ${fn:escapeXml(patFio)}</title>
  <script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
  <link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
  <%@include file="/WEB-INF/pages/med/kdo/print_style.jsp"%>
</head>
<body>
<div class="pv-bar">
  <span class="ic"><i class="fa fa-stethoscope"></i></span>
  <div class="ttl"><b>${fn:escapeXml(patFio)}</b><span>Амбулатория</span></div>
  <span class="sp"></span>
  <label class="fs">Шрифт
    <select onchange="document.location = '/amb/print.s?font=' + this.value + '<%=params%>'">
      <c:forEach begin="10" end="20" step="1" var="s"><option value="${s}" <c:if test="${sessionScope.fontSize == s}">selected</c:if>>${s}</option></c:forEach>
    </select>
  </label>
  <button type="button" class="b" onclick="var u = '/amb/word.s?<%=params%>'; document.getElementById('frm').src = u;"><i class="fa fa-file-word-o"></i>Word</button>
  <button type="button" class="b main" onclick="var w = document.getElementById('frm').contentWindow; w.focus(); w.print();"><i class="fa fa-print"></i>Печать</button>
  <button type="button" class="b" onclick="window.close()"><i class="fa fa-times"></i>Закрыть</button>
</div>
<div class="pv-sheet">
  <c:choose>
    <c:when test="${drugcheck != null}"><c:set var="pvSrc" value="/cashbox/amb/drugcheck.s"/></c:when>
    <c:when test="${check}"><c:set var="pvSrc" value="/cashbox/amb/check.s?id=${check_id}"/></c:when>
    <c:when test="${isFizio}"><c:set var="pvSrc" value="/amb/fizio/print.s"/></c:when>
    <c:otherwise><c:set var="pvSrc" value="/amb/printPage.s?ids=${ids}"/></c:otherwise>
  </c:choose>
  <iframe name="frm" id="frm" src="${pvSrc}" style="min-height:900px"></iframe>
</div>
<script>
  // высота листа по содержимому (услуги догружаются внутри, поэтому проверяем несколько раз)
  (function fit(n) {
    var f = document.getElementById('frm');
    try {
      var d = f.contentWindow.document, w = d.documentElement.scrollWidth, h = 0;
      // высота по низу содержимого, а не scrollHeight: тот растёт вместе с фреймом, и снизу копилось пустое место
      Array.prototype.forEach.call(d.body.children, function (el) { var r = el.getBoundingClientRect(); if (r.height) h = Math.max(h, r.bottom); });
      h = Math.ceil(h + (d.defaultView.pageYOffset || 0));
      if (h) f.style.height = (h + 30) + 'px';
      d.documentElement.style.overflowX = 'hidden';
      // широкое содержимое (таблица фиксированной ширины): лист расширяется один раз и не шире окна.
      // Раньше расширялся при каждой проверке: содержимое шириной 100% росло вместе с листом, и лист «уезжал»
      if (!f.getAttribute('data-wide') && w > f.clientWidth + 20) {
        var sh = f.parentNode;
        f.setAttribute('data-wide', 'Y');
        sh.style.maxWidth = 'calc(100% - 32px)';
        sh.style.width = (w + sh.offsetWidth - f.clientWidth) + 'px';
      }
    } catch (e) {}
    if (n > 0) setTimeout(function () { fit(n - 1); }, 700);
  })(15);
</script>
</body>
</html>
