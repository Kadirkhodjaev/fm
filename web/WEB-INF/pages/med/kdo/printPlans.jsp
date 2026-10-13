<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Печать нескольких анализов одним листом: каждый бланк грузится из /kdo/obs.s?print=Y (idx — номер, шапка пациента только у первого) --%>
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
  <span class="ic"><i class="fa fa-flask"></i></span>
  <div class="ttl"><b>${fn:escapeXml(patFio)}</b><span>Анализов: ${fn:length(plans)}</span></div>
  <span class="sp"></span>
  <label class="fs">Шрифт
    <select onchange="pvLoad(this.value)">
      <c:forEach begin="10" end="20" step="1" var="s"><option value="${s}" <c:if test="${sessionScope.fontSize == s}">selected</c:if>>${s}</option></c:forEach>
    </select>
  </label>
  <button type="button" class="b main" onclick="pvPrint()"><i class="fa fa-print"></i>Печать</button>
  <button type="button" class="b" onclick="window.close()"><i class="fa fa-times"></i>Закрыть</button>
</div>
<div class="pv-sheet" id="print-content">
  <c:forEach items="${plans}" var="plan">
    <div class="pv-part" id="plan${plan.c1}"></div>
  </c:forEach>
</div>
<script>
  var pvPlans = [<c:forEach items="${plans}" var="plan" varStatus="loop">${loop.index > 0 ? ',' : ''}{id: ${plan.c1}, kdo: ${plan.c2}}</c:forEach>];
  function pvLoad(font) {
    $.each(pvPlans, function (i, p) {
      $.ajax({
        url: '/kdo/obs.s', method: 'get', dataType: 'html',
        data: {idx: i, print: 'Y', id: p.id, kdo: p.kdo, font: font},
        success: function (res) { $('#plan' + p.id).html(res); }
      });
    });
  }
  function pvPrint() {
    var w = window.open('', 'Print-Window');
    w.document.open();
    w.document.write('<html><head><meta charset="UTF-8"></head><body onload="window.print()">' + document.getElementById('print-content').innerHTML + '</body></html>');
    w.document.close();
  }
  pvLoad('${empty sessionScope.fontSize ? 14 : sessionScope.fontSize}');
</script>
</body>
</html>
