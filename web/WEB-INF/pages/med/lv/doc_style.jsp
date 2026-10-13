<%@ page pageEncoding="UTF-8" %>
<%-- Листы лечащего врача во фрейме карточки (осмотр, обоснование, выписка): общий вид блоков ld-* --%>
<style>
  html, body { background:#F7F8FA !important; }
  .ld-sheet { max-width:1100px; margin:14px auto 30px; background:#fff; border:1px solid #E6E8EC; border-radius:14px; color:#1F2430;
    font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .ld-title { padding:14px 20px; border-bottom:1px solid #F0F1F4; font-size:15px; font-weight:700; letter-spacing:.3px; }
  .ld-body { padding:6px 20px 22px; }
  .ld-head { display:grid; grid-template-columns:minmax(0, 1fr) auto auto 170px; gap:6px 18px; align-items:center; margin:12px 0 6px; padding:10px 14px;
    background:#F8F9FA; border-radius:10px; font-size:13.5px; }
  .ld-head b { margin-right:4px; color:#6B7280; font-weight:600; }
  .ld-sec { margin:24px 0 2px; padding-bottom:6px; border-bottom:2px solid #1F2430; font-size:13px; font-weight:700; text-transform:uppercase; letter-spacing:.4px; }
  .ld-l { display:flex; align-items:center; gap:8px; margin:18px 0 6px; font-size:12px; font-weight:600; color:#6B7280; text-transform:uppercase; letter-spacing:.3px; }
  .ld-l .btn-group, .ld-l > a.btn { float:none !important; margin-left:auto !important; text-transform:none; letter-spacing:0; font-weight:400; }
  .ld-l .btn-group ~ a.btn { margin-left:6px !important; }
  .ld-l .btn-xs { height:26px; padding:0 9px !important; border:1px solid #E6E8EC; border-radius:7px; background:#fff; color:#3C4250; font-size:12px; line-height:24px; }
  .ld-l .btn-xs:hover { background:#F5F6F8; }
  .ld-f .ql-toolbar.ql-snow { border-color:#E6E8EC; border-radius:10px 10px 0 0; background:#FAFBFC; }
  .ld-f .ql-container.ql-snow { border-color:#E6E8EC; border-radius:0 0 10px 10px; }
  .ld-f .ql-editor { min-height:120px; font-size:14px; }
  .ld-raw { margin:10px 0; }
  .ld-raw table td { padding:4px 6px; }
  .ld-sheet .form-control { height:34px; border:1px solid #E6E8EC; border-radius:8px; box-shadow:none; font-size:14px; }
  .ld-sheet .form-control:focus { border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  @media (max-width: 900px) { .ld-head { grid-template-columns:1fr 1fr; } }
</style>
