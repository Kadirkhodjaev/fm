<%@ page pageEncoding="UTF-8" %>
<%-- Окна выбора показателей обследования (биохимия, коагулограмма, гормоны, TORCH): общий вид --%>
<style>
  .pm .modal-content { border:0; border-radius:14px; box-shadow:0 20px 60px rgba(20,25,40,.25); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .pm .modal-header { padding:14px 18px; border-bottom:1px solid #E6E8EC; }
  .pm .modal-title { font-size:15px; font-weight:700; color:#1F2430; }
  .pm .modal-body { padding:14px 18px; }
  .pm .modal-footer { padding:10px 18px; border-top:1px solid #E6E8EC; background:#FAFBFC; border-radius:0 0 14px 14px; }
  .pm-tools { display:flex; align-items:center; gap:14px; margin-bottom:10px; font-size:13px; }
  .pm-tools a { color:#3C4250; font-weight:600; }
  .pm-cnt { margin-left:auto; color:#6B7280; }
  .pm-grid { display:grid; grid-template-columns:1fr 1fr; gap:6px 10px; }
  .pm-it { display:flex; align-items:center; gap:9px; margin:0; padding:8px 12px; border:1px solid #E6E8EC; border-radius:9px; cursor:pointer;
    font-size:13.5px; font-weight:500; color:#1F2430; }
  .pm-it:hover { border-color:#C9CDD5; }
  .pm-it input { width:16px; height:16px; margin:0; accent-color:#1F2430; }
  .pm-it.on { border-color:#1F2430; background:#F5F6F8; font-weight:600; }
  .pm-btn { height:34px; padding:0 14px; border:1px solid #E6E8EC; border-radius:9px; background:#fff; color:#3C4250; font-size:13px; font-weight:600; }
  .pm-btn:hover { background:#F5F6F8; }
  .pm-btn.primary { background:#1F2430; border-color:#1F2430; color:#fff; }
  .pm-btn.primary:hover { background:#353B4A; }
</style>
<script>
  function pmMark() {
    var n = 0;
    $('#pmGrid .pm-it').each(function () { var on = $(this).find('input').prop('checked'); $(this).toggleClass('on', on); if (on) n++; });
    $('#pmCnt').text('выбрано: ' + n);
  }
  function pmAll(on) { $('#pmGrid input').prop('checked', on); pmMark(); }
  $(document).off('change.pm').on('change.pm', '#pmGrid input', pmMark);
  setTimeout(pmMark, 0);
</script>
