<%@ page pageEncoding="UTF-8" %>
<%-- Разделы карточки пациента во фрейме: jQuery, common.js, общий набор fm-* и лист ld-* --%>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/js/common.js?v=2026101309" type="text/javascript"></script>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<%@include file="/WEB-INF/pages/med/lv/doc_style.jsp"%>
<style>
  body { margin:0; }
  .ld-title { display:flex; align-items:center; gap:10px; }
  .ld-title .sub { font-size:12.5px; font-weight:400; color:#6B7280; letter-spacing:0; }
  .ld-title .sp { flex:1; }
  .ld-sheet .fm-grid { width:100%; }
  .ld-empty { padding:30px; text-align:center; color:#9AA1AC; }
  .ld-tag { display:inline-flex; align-items:center; gap:6px; padding:2px 10px; border-radius:999px; font-size:12px; font-weight:600; background:#F1F2F4; color:#4B5563; }
  .ld-tag.ok { background:#E3F6EC; color:#1E7A4C; }
  .ld-tag.warn { background:#FDECEE; color:#A50F22; }
</style>
