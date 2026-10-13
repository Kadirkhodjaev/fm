<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- ЭКГ пациента в отдельном окне: результат КДО во фрейме, печать / Word --%>
<html>
<head>
  <meta charset="UTF-8">
  <title>ЭКГ · ${fn:escapeXml(patFio)}</title>
  <link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
  <style>
    html, body { margin:0; height:100%; background:#F5F6F8; font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:#1F2430; }
    .bar { display:flex; align-items:center; gap:10px; height:52px; padding:0 16px; background:#fff; border-bottom:1px solid #E6E8EC; box-sizing:border-box; }
    .bar h1 { margin:0; flex:1; font-size:16px; font-weight:700; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
    .bar h1 small { color:#6B7280; font-weight:500; font-size:13px; margin-left:6px; }
    .btn { display:inline-flex; align-items:center; gap:7px; height:34px; padding:0 14px; border:1px solid #E6E8EC; border-radius:9px; background:#fff; color:#1F2430;
      font:600 13px inherit; font-family:inherit; cursor:pointer; }
    .btn:hover { background:#F5F6F8; }
    .btn .fa { color:#6B7280; }
    iframe { display:block; width:100%; height:calc(100% - 52px); border:0; background:#fff; }
    .empty { display:flex; flex-direction:column; align-items:center; justify-content:center; gap:12px; height:calc(100% - 52px); color:#6B7280; font-size:15px; }
    .empty .fa { font-size:42px; color:#C3C7CE; }
  </style>
</head>
<body>
<div class="bar">
  <h1>${fn:escapeXml(patFio)}<small>ЭКГ</small></h1>
  <c:if test="${printPage != ''}">
    <button type="button" class="btn" onclick="frames['frm'].print()"><i class="fa fa-print"></i>Печать</button>
  </c:if>
  <button type="button" class="btn" onclick="self.close()"><i class="fa fa-times"></i>Закрыть</button>
</div>
<c:choose>
  <c:when test="${printPage == ''}">
    <div class="empty"><i class="fa fa-file-o"></i>Результат ЭКГ ещё не готов</div>
  </c:when>
  <c:otherwise>
    <iframe name="frm" id="frm" src="${printPage}"></iframe>
  </c:otherwise>
</c:choose>
</body>
</html>
