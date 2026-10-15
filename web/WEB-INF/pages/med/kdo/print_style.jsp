<%@ page pageEncoding="UTF-8" %>
<%-- Общий вид страниц просмотра печати анализов (print.jsp, printPlans.jsp): панель сверху и белый лист на сером фоне --%>
<style>
  /* tables from the text editor (Quill: td[data-row]) - cell borders on print */ td[data-row] { border:1px solid #888 !important; padding:3px 6px !important; vertical-align:top; } table:has(td[data-row]) { border-collapse:collapse; max-width:100%; }
  html, body { margin:0; background:#ECEEF1; font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:#1F2430; }
  .pv-bar { position:sticky; top:0; z-index:5; display:flex; align-items:center; gap:10px; padding:10px 18px; background:#fff; border-bottom:1px solid #E6E8EC; }
  .pv-bar .ic { width:32px; height:32px; border-radius:9px; display:flex; align-items:center; justify-content:center; background:#EEF1F5; color:#4B5563; }
  .pv-bar .ttl b { display:block; font-size:15px; font-weight:700; }
  .pv-bar .ttl span { font-size:12.5px; color:#6B7280; }
  .pv-bar .sp { flex:1; }
  .pv-bar .fs { display:inline-flex; align-items:center; gap:6px; margin:0; font-size:12.5px; font-weight:600; color:#6B7280; }
  .pv-bar select { height:32px; padding:0 6px; border:1px solid #E6E8EC; border-radius:9px; background:#fff; font-family:inherit; font-size:13px; }
  .pv-bar .b { display:inline-flex; align-items:center; gap:7px; height:34px; padding:0 14px; border:1px solid #E6E8EC; border-radius:9px; background:#fff;
    color:#3C4250; font-family:inherit; font-size:13px; font-weight:600; cursor:pointer; }
  .pv-bar .b:hover { background:#F5F6F8; }
  .pv-bar .b.main { background:#1F2430; border-color:#1F2430; color:#fff; }
  .pv-bar .b.main:hover { background:#353B4A; }
  .pv-sheet { width:210mm; max-width:calc(100% - 32px); margin:20px auto 40px; padding:12mm 12mm; box-sizing:border-box; background:#fff; border-radius:4px;
    box-shadow:0 1px 3px rgba(20,25,40,.08), 0 8px 24px rgba(20,25,40,.08); }
  .pv-sheet iframe { display:block; width:100%; min-height:400px; border:0; }
  .pv-sheet .pv-part + .pv-part { margin-top:18px; padding-top:18px; border-top:1px dashed #D5D8DD; }
</style>
