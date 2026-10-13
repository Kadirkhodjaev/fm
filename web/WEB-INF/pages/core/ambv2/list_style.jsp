<%@ page pageEncoding="UTF-8" %>
<%-- Общее для списков «Амбулатория → Услуги / Группы»: стили меток и фильтр строк.
     Префикс p: таблица #<p>Rows, поиск #<p>Search, переключатель #<p>Seg, счётчик #<p>Shown, пусто #<p>Empty,
     необязательный фильтр по группе #<p>Group (строки с data-g) --%>
<style>
  table.fm-grid tbody tr { cursor:pointer; }
  .av-yes { display:inline-block; padding:0 7px; border-radius:6px; background:#E9F7EF; color:#1E7B43; font-size:11.5px; font-weight:600; line-height:18px; }
  .av-no { color:#C3C7CE; }
  .av-st { display:inline-block; padding:0 8px; border-radius:6px; font-size:11.5px; font-weight:600; line-height:20px; }
  .av-st.A { background:#E9F7EF; color:#1E7B43; }
  .av-st.P { background:#F1F2F4; color:#6B7280; }
  table.fm-grid tr[data-f=P] .nm { color:#9AA1AC; }
  .av-grp { display:inline-block; padding:0 7px; border-radius:6px; background:#EEF1F6; color:#3C4A63; font-size:11.5px; font-weight:600; line-height:18px; white-space:nowrap; }
</style>
<script>
  function avSeg(p, btn) {
    $('#' + p + 'Seg button').removeClass('on');
    $(btn).addClass('on');
    avFilter(p);
  }
  function avFilter(p) {
    var f = $('#' + p + 'Seg button.on').data('f') || '', g = $('#' + p + 'Group').val() || '';
    var q = $.trim($('#' + p + 'Search').val() || '').toLowerCase(), words = q ? q.split(/\s+/) : [];
    var n = 0;
    $('#' + p + 'Rows tr').each(function () {
      var tr = $(this), s = String(tr.data('s')), ok = (!f || tr.data('f') == f) && (!g || String(tr.data('g')) == g);
      for (var i = 0; ok && i < words.length; i++) if (s.indexOf(words[i]) < 0) ok = false;
      tr.toggle(ok);
      if (ok) n++;
    });
    $('#' + p + 'Shown').text(n);
    $('#' + p + 'Empty').toggle(n == 0);
  }
  function avClose(p) { $('#' + p + 'Modal').removeClass('open'); }
</script>
