<%@ page pageEncoding="UTF-8" %>
<%-- Общее для страниц роли «Склады» (старшая медсестра): новый стиль, календарь, метки состояний --%>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<script src="/res/js/fms-calendar.js" type="text/javascript"></script>
<style>
  .hn-flt { display:flex; align-items:center; flex-wrap:wrap; gap:8px; }
  .hn-flt input.fm-in { width:120px; height:30px; text-align:center; }
  .hn-flt .dash { color:#9AA1AC; }
  table.fm-grid tbody tr.go { cursor:pointer; }
  table.fm-grid td.nw, table.fm-grid th.nw { white-space:nowrap; }
  .hn-st { display:inline-flex; align-items:center; gap:6px; padding:0 8px; border-radius:6px; font-size:11.5px; font-weight:600; line-height:20px; white-space:nowrap; }
  .hn-st::before { content:''; width:7px; height:7px; border-radius:50%; background:currentColor; }
  .hn-st.ent { background:#FFF4D6; color:#8A5A00; }
  .hn-st.snd { background:#E8F1FD; color:#1F5FBF; }
  .hn-st.con { background:#E9F7EF; color:#1E7B43; }
  .hn-st.off { background:#F1F2F4; color:#6B7280; }
  .hn-st.err { background:#FDECEE; color:#A50F22; }
  .hn-tag { display:inline-block; padding:0 7px; border-radius:6px; background:#EEF1F6; color:#3C4A63; font-size:11.5px; font-weight:600; line-height:18px; white-space:nowrap; }
  .hn-auto { display:inline-block; margin-right:6px; padding:0 7px; border-radius:6px; background:#FDECEE; color:#A50F22; font-size:11.5px; font-weight:600; line-height:18px; }
  .hn-foot { flex:none; display:flex; gap:6px 28px; flex-wrap:wrap; padding:9px 14px; border-top:1px solid #E6E8EC; background:#FAFBFC; font-size:13px; color:#6B7280; }
  .hn-foot b { color:#1F2430; font-variant-numeric:tabular-nums; }
  .hn-ok { color:#1E7B43; } .hn-no { color:#C3C7CE; }
  /* карточки документа (приход, расход, перевод) */
  .hn-page { min-height:100%; padding:10px 14px; background:#F5F6F8; font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:#1F2430; font-size:13px; }
  .hn-page * { box-sizing:border-box; }
  .hn-doc { max-width:1100px; margin:0 auto; display:flex; flex-direction:column; gap:12px; }
  .hn-card { background:#fff; border:1px solid #E6E8EC; border-radius:16px; box-shadow:0 1px 2px rgba(20,25,40,.04), 0 8px 24px rgba(20,25,40,.06); overflow:hidden; }
  .hn-card-h { display:flex; align-items:center; flex-wrap:wrap; gap:8px 10px; padding:12px 16px; border-bottom:1px solid #E6E8EC; }
  .hn-card-h h3 { margin:0 0 2px; font-size:15px; font-weight:700; }
  .hn-card-b { padding:14px 16px; display:flex; flex-direction:column; gap:12px; }
  .hn-req { color:#D92D3C; }
  .hn-ro { background:#F5F6F8 !important; }
  table.fm-grid.flat td { height:40px; }
</style>
<script>
  // фильтр строк таблицы по поиску и кнопкам: строки с data-s (текст), data-f (значение кнопки)
  function hnFilter(p) {
    var f = $('#' + p + 'Seg button.on').attr('data-f') || '';
    var q = $.trim($('#' + p + 'Search').val() || '').toLowerCase(), words = q ? q.split(/\s+/) : [];
    var n = 0;
    $('#' + p + 'Rows > tr').each(function () {
      var tr = $(this), s = String(tr.attr('data-s') || '').toLowerCase(), ok = !f || tr.attr('data-f') == f;
      for (var i = 0; ok && i < words.length; i++) if (s.indexOf(words[i]) < 0) ok = false;
      tr.toggle(ok);
      if (ok) n++;
    });
    $('#' + p + 'Shown').text(n);
    $('#' + p + 'Empty').toggle(n == 0);
  }
  function hnSeg(p, btn) {
    $(btn).addClass('on').siblings().removeClass('on');
    hnFilter(p);
  }
  // кнопки, которые стоят в форме с onsubmit: не отправляют форму
  function hnNoSubmit(root) { $(root || document).find('form button:not([type])').attr('type', 'button'); }
</script>
