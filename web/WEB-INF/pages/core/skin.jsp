<%@ page pageEncoding="UTF-8" %>
<%-- Новый стиль для старых страниц на Bootstrap (panel, table, btn, form-control, modal) без переписывания их логики.
     Подключается через include, содержимое страницы оборачивается в <div class="fm-skin">...</div>.
     Новые страницы используют классы fm-* из core/forms/style.jsp (подключается здесь же). --%>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<style>
  .fm-skin { --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    min-height:100%; box-sizing:border-box; padding:10px 14px; background:var(--bg); color:var(--text);
    font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; font-size:13px; }
  .fm-skin .fm-skin, .modal .fm-skin { min-height:0; padding:0; background:none; }
  .fm-skin .row { margin-left:0; margin-right:0; }
  .fm-skin .row > [class*=col-] { padding-left:0; padding-right:0; }
  .fm-skin .row > [class*=col-] + [class*=col-] { padding-left:12px; }

  /* карточки */
  .fm-skin .panel { margin:0 0 12px; background:#fff; border:1px solid var(--border); border-radius:16px; overflow:visible;
    box-shadow:0 1px 2px rgba(20,25,40,.04), 0 8px 24px rgba(20,25,40,.06); }
  .fm-skin .panel > .panel-heading { padding:10px 14px; background:none !important; border:0; border-bottom:1px solid var(--border);
    border-radius:16px 16px 0 0; color:var(--text) !important; font-size:15px; font-weight:700; line-height:30px; }
  .fm-skin .panel > .panel-heading table td { font-size:15px; font-weight:700; color:var(--text); vertical-align:middle; }
  .fm-skin .panel > .panel-heading .fa-fw:first-child { color:#3C4A63; }
  /* кнопки в заголовке: старые float/pagination выстраиваются в ряд справа */
  .fm-skin .panel > .panel-heading:not(:has(> table)) { display:flex; align-items:center; flex-wrap:wrap; gap:8px; }
  .fm-skin .panel > .panel-heading > [style*="float"], .fm-skin .panel > .panel-heading > .pull-right,
  .fm-skin .panel > .panel-heading > .pagination { float:none !important; margin:0 0 0 auto !important; }
  .fm-skin .panel > .panel-heading > [style*="float"] ~ [style*="float"],
  .fm-skin .panel > .panel-heading > .pull-right ~ .pull-right { margin-left:0 !important; }
  .fm-skin .panel-heading .margin-top-5, .fm-skin .panel-heading [style*="margin-top"] { margin-top:0 !important; }
  .fm-skin .panel > .panel-heading > .float-right { float:none !important; margin:0 0 0 auto !important; width:auto; }
  .fm-skin .panel > .panel-heading > .float-right ~ .float-right, .fm-skin .panel > .panel-heading > [style*="float"] ~ .float-right { margin-left:0 !important; }
  .fm-skin .panel > .panel-heading .form-control { height:30px; font-weight:400; }
  .fm-skin .panel > .panel-heading table { margin:0; }
  .fm-skin .panel > .panel-heading table td { padding:0 4px; }
  .fm-skin .panel > .panel-heading table td:first-child { padding-left:0; }
  .fm-skin table.miniGrid { width:100%; }
  .fm-skin .table-striped > tbody > tr:nth-of-type(odd) > td { background:none; }
  .fm-skin .table-responsive { border:0; }
  .fm-skin .fm-hbtns { display:flex; align-items:center; gap:8px; margin-left:auto; }
  .fm-skin .fm-hbtns .fm-btn { font-size:12.5px; line-height:normal; }
  .fm-skin ul.pagination { display:flex; gap:6px; margin:0 !important; padding:0; border-radius:0; }
  .fm-skin ul.pagination > li { width:auto !important; display:block; }
  .fm-skin ul.pagination > li > a { float:none; display:inline-flex; align-items:center; gap:6px; height:30px; margin:0; padding:0 12px;
    border:1px solid #E6E8EC !important; border-radius:9px !important; background:#fff; color:#3C4250; font-size:12.5px; font-weight:600; text-decoration:none; }
  .fm-skin ul.pagination > li > a:hover { background:#F5F6F8; color:#1F2430; }
  .fm-skin ul.pagination > li:first-child > a { background:#1F2430; border-color:#1F2430 !important; color:#fff; }
  .fm-skin ul.pagination > li:first-child > a:hover { background:#353B4A; }
  .fm-skin fieldset { margin-top:14px; padding:0; border:0; }
  .fm-skin fieldset::after { content:''; display:table; clear:both; }
  .fm-skin legend { margin:0 0 8px; padding:0; border:0; font-size:11px; font-weight:600; color:#9AA1AC; text-transform:uppercase; letter-spacing:.4px; }
  .fm-skin fieldset > .btn[style*="float"] { margin-top:8px; }
  .fm-skin .panel > .panel-body { padding:12px 14px; }
  .fm-skin .panel > .panel-body > form > table.table td:first-child,
  .fm-skin .panel > .panel-body > table.table td.bold:first-child { color:var(--muted); font-size:12.5px; font-weight:600; }
  .fm-skin .panel > .panel-footer { padding:10px 14px; background:#FAFBFC; border-top:1px solid var(--border); border-radius:0 0 16px 16px; }

  /* таблицы */
  .fm-skin table.table { margin:0; border-collapse:separate; border-spacing:0; font-size:13px; background:#fff; }
  .fm-skin table.table-bordered { border:1px solid var(--border); border-radius:12px; overflow:hidden; }
  .fm-skin table.table > thead > tr > th, .fm-skin table.table > tbody > tr > th, .fm-skin table.table > tr > th {
    height:32px; padding:6px 8px; background:#F8F9FA; border:0; border-bottom:1px solid var(--border); vertical-align:middle;
    color:var(--muted); font-size:11px; font-weight:600; text-transform:uppercase; letter-spacing:.3px; }
  .fm-skin table.table td { padding:6px 8px; border:0; border-bottom:1px solid #F0F1F4; vertical-align:middle; }
  .fm-skin table.table-bordered td + td, .fm-skin table.table-bordered th + th { border-left:1px solid #F0F1F4; }
  .fm-skin table.table tr:last-child > td { border-bottom:0; }
  .fm-skin table.table tr.hover:hover > td, .fm-skin table.table-hover > tbody > tr:hover > td { background:#F8F9FB; }
  .fm-skin table.table tr[style*="f1f1f1"] > td, .fm-skin table.table td.bold.center, .fm-skin table.table td.center.bold {
    color:var(--muted); font-size:11px; font-weight:600; text-transform:uppercase; letter-spacing:.3px; background:#F8F9FA; }
  .fm-skin td.right, .fm-skin td.text-right:not(:last-child) { color:var(--muted); font-size:12.5px; font-weight:600; }
  .fm-skin .formTable td { padding:4px 6px; }
  .fm-skin .tablehover tr:hover td { background:#F8F9FB; cursor:pointer; }

  /* поля */
  .fm-skin .form-control, .fm-modal-skin .form-control { height:32px; padding:4px 10px; border:1px solid var(--border, #E6E8EC); border-radius:9px;
    box-shadow:none; font-size:13px; font-family:inherit; color:#1F2430; }
  .fm-skin textarea.form-control, .fm-modal-skin textarea.form-control { height:auto; min-height:60px; }
  .fm-skin .form-control:focus, .fm-modal-skin .form-control:focus { border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .fm-skin .form-control[readonly], .fm-skin .form-control[disabled] { background:#F5F6F8; color:#4B5563; }
  .fm-skin label { font-size:12px; font-weight:600; color:var(--muted); }
  .fm-skin req, .fm-modal-skin req { color:#D92D3C; }

  /* кнопки */
  .fm-skin .btn, .fm-modal-skin .btn { height:30px; padding:0 12px; border:1px solid #E6E8EC; border-radius:9px; background:#fff; color:#3C4250;
    font-size:12.5px; font-weight:600; font-family:inherit; line-height:28px; box-shadow:none; text-shadow:none; white-space:nowrap; }
  .fm-skin .btn:hover, .fm-modal-skin .btn:hover { background:#F5F6F8; color:#1F2430; }
  .fm-skin .btn .fa, .fm-skin .btn .glyphicon, .fm-modal-skin .btn .fa { margin-right:2px; }
  .fm-skin .btn-success, .fm-skin .btn-primary, .fm-skin .btn-info,
  .fm-modal-skin .btn-success, .fm-modal-skin .btn-primary, .fm-modal-skin .btn-info { background:#1F2430; border-color:#1F2430; color:#fff; }
  .fm-skin .btn-success:hover, .fm-skin .btn-primary:hover, .fm-skin .btn-info:hover,
  .fm-modal-skin .btn-success:hover, .fm-modal-skin .btn-primary:hover, .fm-modal-skin .btn-info:hover { background:#353B4A; border-color:#353B4A; color:#fff; }
  .fm-skin .btn-danger, .fm-modal-skin .btn-danger { background:#fff; color:#A50F22; }
  .fm-skin .btn-danger:hover, .fm-modal-skin .btn-danger:hover { background:#FDECEE; border-color:#F3C5CB; color:#A50F22; }
  .fm-skin .btn-warning { background:#FFF4D6; border-color:#F5DFA3; color:#8A5A00; }
  .fm-skin .btn-sm, .fm-skin .btn-xs { height:28px; line-height:26px; padding:0 9px; }
  .fm-skin .btn-icon { min-width:30px; padding:0 8px; }
  .fm-skin table.table td .btn { height:26px; line-height:24px; padding:0 8px; }

  /* окна Bootstrap */
  .fm-skin .modal-content, .fm-modal-skin .modal-content { border:0; border-radius:16px; box-shadow:0 20px 60px rgba(20,25,40,.25);
    font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:#1F2430; }
  .fm-skin .modal-header, .fm-modal-skin .modal-header { padding:14px 18px; border-bottom:1px solid #E6E8EC; }
  .fm-skin .modal-title, .fm-modal-skin .modal-title { font-size:15px; font-weight:700; color:#1F2430 !important; }
  .fm-skin .modal-body, .fm-modal-skin .modal-body { padding:16px 18px; }
  .fm-skin .modal-footer, .fm-modal-skin .modal-footer { padding:10px 18px; border-top:1px solid #E6E8EC; background:#FAFBFC; border-radius:0 0 16px 16px; }
  .fm-skin .nav-tabs > li > a { border-radius:9px 9px 0 0; font-weight:600; color:var(--muted); }
  .fm-skin .nav-tabs > li.active > a { color:var(--text); }
</style>
