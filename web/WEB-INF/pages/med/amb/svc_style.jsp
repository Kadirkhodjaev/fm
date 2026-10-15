<%@ page pageEncoding="UTF-8" %>
<%-- Амбулаторные услуги: общий вид страницы услуги (svc.jsp) и пакетного ввода (batch.jsp), загрузка бланка услуги фрагментом --%>
<style>
  .sv-wrap { display:grid; grid-template-columns:300px minmax(0, 900px); gap:14px; padding:14px; background:#F7F8FA; min-height:100%; align-items:start; }
  .sv-card { background:#fff; border:1px solid #E6E8EC; border-radius:14px; overflow:hidden; }
  .sv-card.dirty { border-color:#F59E0B; }
  .sv-info { padding:14px 16px; display:flex; flex-direction:column; gap:10px; font-size:13px; }
  .sv-info .l { display:block; font-size:11px; font-weight:600; color:#9AA1AC; text-transform:uppercase; letter-spacing:.3px; margin-bottom:2px; }
  .sv-info b { font-weight:600; color:#1F2430; }
  .sv-note { padding:8px 10px; border-radius:9px; background:#F5F6F8; color:#6B7280; font-size:12.5px; }
  .sv-st { display:inline-flex; align-items:center; gap:7px; padding:3px 11px; border-radius:999px; font-size:12.5px; font-weight:600; }
  .sv-st::before { content:''; width:8px; height:8px; border-radius:50%; background:currentColor; }
  .sv-st.new { background:#FDECEE; color:#A50F22; }
  .sv-st.fill { background:#FEF6D6; color:#8A6100; }
  .sv-st.done { background:#E3F6EC; color:#1E7A4C; }
  .sv-head { display:flex; align-items:center; gap:10px; padding:12px 16px; border-bottom:1px solid #F0F1F4; background:#FAFBFC; }
  .sv-head h3 { flex:1; margin:0; font-size:15px; font-weight:700; }
  .sv-body { padding:8px 14px 14px; font-size:13px; overflow-x:auto; }
  /* широкий бланк: на услуге - колонка бланка на всю ширину, в пакетном вводе - карточка на всю строку; если и так не влезает - прокрутка */
  .sv-wrap.wide { grid-template-columns:300px minmax(0, 1fr); }
  .ab-form.wide { grid-column:1 / -1; }
  .sv-body table { width:100% !important; border-collapse:collapse; border:0 !important; }
  .sv-body td { padding:4px 8px !important; border:0 !important; border-bottom:1px solid #F0F1F4 !important; background:none !important; font-size:13px; text-align:left !important; }
  .sv-body tr:first-child td { color:#6B7280; font-size:11px; font-weight:600; text-transform:uppercase; letter-spacing:.3px; }
  .sv-body .form-control, .sv-body input[type=text], .sv-body select, .sv-body textarea { width:100%; height:30px; padding:2px 10px; border:1px solid #E6E8EC; border-radius:8px;
    box-shadow:none; font-size:13.5px; font-weight:600; background:#fff; }
  .sv-body textarea { height:auto; font-weight:400; }
  .sv-body input:focus, .sv-body select:focus, .sv-body textarea:focus { outline:none; border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .sv-body [disabled] { background:#F5F6F8 !important; border-color:transparent !important; color:#1F2430; }
  .sv-txt { padding:14px 16px 16px; display:flex; flex-direction:column; gap:14px; }
  .sv-lbl { display:flex; align-items:center; gap:8px; margin:0 0 6px; font-size:12px; font-weight:600; color:#6B7280; text-transform:uppercase; letter-spacing:.3px; }
  .sv-lbl .sp { flex:1; }
  .sv-lbl .btn-group { text-transform:none; letter-spacing:0; font-weight:400; }
  .sv-txt .ql-toolbar { border-color:#E6E8EC; border-radius:10px 10px 0 0; }
  .sv-txt .ql-container { border-color:#E6E8EC; border-radius:0 0 10px 10px; font-family:inherit; font-size:14px; }
  .sv-txt .ql-editor { min-height:140px; }
  .sv-txt .ql-disabled .ql-editor { background:#F9FAFB; }
  .sv-in { width:100%; height:34px; padding:0 12px; border:1px solid #E6E8EC; border-radius:10px; font-family:inherit; font-size:14px; }
  .sv-in:focus { outline:none; border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .sv-in[disabled] { background:#F9FAFB; }
  .sv-load { padding:30px; text-align:center; color:#9AA1AC; }
  @media (max-width: 1100px) { .sv-wrap { grid-template-columns:1fr; } }
</style>
<script>
  // Бланк амбулаторной услуги для встраивания: страница /amb/doWork.s?frag=1 целиком, из неё берётся форма #amb-form
  // и данные (var data = {'formAction':[...]}), значения раскладываются по полям. cb вызывается после загрузки.
  function svFrag(body, id, cb) {
    $.ajax({
      url: '/amb/doWork.s', data: {id: id, frag: 1}, dataType: 'text',
      success: function (html) {
        var m = /var data = \{'formAction':\[([\s\S]*?)\]\};/.exec(html), d = {};
        try { d = m && $.trim(m[1]) ? JSON.parse(m[1]) : {}; } catch (e) {}
        var form = $('<div>').append($.parseHTML(html)).find('#amb-form');
        if (!form.length) { body.html('<div class="sv-load">Бланк не открылся</div>'); return; }
        form.removeAttr('id').addClass('sv-form').on('submit', function () { return false; });
        body.empty().append(form);
        form.find('input[name], select[name], textarea[name]').each(function () { if (this.name != 'id' && d[this.name] != null) $(this).val(d[this.name]); });
        var wide = function () {
          if (body[0].scrollWidth <= body[0].clientWidth + 2) return;
          body.closest('.sv-wrap').addClass('wide');
          body.closest('.ab-form').addClass('wide');
        };
        wide();
        setTimeout(wide, 300);
        if (cb) cb();
      },
      error: function () { body.html('<div class="sv-load">Бланк не открылся</div>'); }
    });
  }
</script>
