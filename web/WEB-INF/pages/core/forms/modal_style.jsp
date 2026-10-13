<%@ page pageEncoding="UTF-8" %>
<%-- Окна Bootstrap (.modal) в новом виде: класс mdn на .modal или .modal-dialog, кнопки mdn-btn --%>
<style>
  .mdn .modal-content { border:0; border-radius:14px; box-shadow:0 20px 60px rgba(20,25,40,.25); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:#1F2430; }
  .mdn .modal-header { padding:14px 18px; border-bottom:1px solid #E6E8EC; }
  .mdn .modal-title { font-size:15px; font-weight:700; }
  .mdn .modal-body { padding:16px 18px; }
  .mdn .modal-footer { padding:10px 18px; border-top:1px solid #E6E8EC; background:#FAFBFC; border-radius:0 0 14px 14px; }
  .mdn .form-control { height:34px; border:1px solid #E6E8EC; border-radius:9px; box-shadow:none; font-size:14px; }
  .mdn .form-control:focus { border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .mdn label { font-size:12px; font-weight:600; color:#6B7280; }
  .mdn .table-bordered, .mdn .table-bordered > tbody > tr > td { border-color:#EEF0F3 !important; }
  .mdn .table > tbody > tr > td { vertical-align:middle; font-size:13.5px; }
  .mdn-btn { height:34px; padding:0 14px; border:1px solid #E6E8EC; border-radius:9px; background:#fff; color:#3C4250; font-size:13px; font-weight:600; font-family:inherit; cursor:pointer; }
  .mdn-btn:hover { background:#F5F6F8; }
  .mdn-btn.primary { background:#1F2430; border-color:#1F2430; color:#fff; }
  .mdn-btn.primary:hover { background:#353B4A; }
</style>
