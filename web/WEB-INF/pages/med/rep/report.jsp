<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Отчёты: панель над отчётом (Печать, Word, Закрыть). Подключается в начало каждой страницы отчёта (med/rep/forms/*.jsp) --%>
<% if (request.getParameter("word") == null) { %>
<%-- при выгрузке в файл (word=Y) панель не выводится; во фрейме страницы «Отчёты» (frame=Y) только стили, панель там своя --%>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<%-- те же стили, что раньше: таблицы отчётов на них свёрстаны --%>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<style>
  body { background:#fff; color:#111; }
  .rp-bar { position:sticky; top:0; z-index:5; display:flex; align-items:center; gap:10px; margin:-8px -8px 12px; padding:10px 18px; background:#fff; border-bottom:1px solid #E6E8EC;
    font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:#1F2430; }
  .rp-bar .ic { width:32px; height:32px; border-radius:9px; display:flex; align-items:center; justify-content:center; background:#EEF1F5; color:#4B5563; }
  .rp-bar .ttl b { display:block; font-size:15px; font-weight:700; }
  .rp-bar .ttl span { font-size:12.5px; color:#6B7280; }
  .rp-bar .sp { flex:1; }
  .rp-bar .b { display:inline-flex; align-items:center; gap:7px; height:34px; padding:0 14px; border:1px solid #E6E8EC; border-radius:9px; background:#fff;
    color:#3C4250; font-family:inherit; font-size:13px; font-weight:600; cursor:pointer; }
  .rp-bar .b:hover { background:#F5F6F8; }
  .rp-bar .b.main { background:#1F2430; border-color:#1F2430; color:#fff; }
  .rp-bar .b.main:hover { background:#353B4A; }
  @media print { .rp-bar { display:none; } }
</style>
<script src="/res/js/fms-rep-excel.js?v=2026101402" type="text/javascript"></script>
<script>
  function repPrint() { window.print(); }
</script>
<% if (request.getParameter("frame") == null) { %>
<div class="rp-bar">
  <span class="ic"><i class="fa fa-bar-chart"></i></span>
  <div class="ttl"><b>${empty rep.name ? 'Отчёт' : rep.name}</b><span>${empty patFio ? 'отчёт' : patFio}</span></div>
  <span class="sp"></span>
  <button type="button" class="b" onclick="FmsRepExcel(document, $('.rp-bar .ttl b').text())"><i class="fa fa-file-excel-o"></i>Excel</button>
  <button type="button" class="b main" onclick="repPrint()"><i class="fa fa-print"></i>Печать</button>
  <button type="button" class="b" onclick="window.close()"><i class="fa fa-times"></i>Закрыть</button>
</div>
<% } %>
<% } %>
