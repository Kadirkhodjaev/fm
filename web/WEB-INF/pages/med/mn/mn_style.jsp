<%@ page pageEncoding="UTF-8" %>
<%-- Мониторинг: общий вид отчётов (период, поиск по строкам, таблица с двухуровневой шапкой, итоги, Excel) --%>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<script src="/res/js/fms-calendar.js" type="text/javascript"></script>
<script src="/res/js/tableToExcel.js" type="text/javascript"></script>
<style>
  .mn-flt { display:flex; align-items:center; flex-wrap:wrap; gap:8px; }
  .mn-flt input.fm-in { width:120px; height:30px; text-align:center; }
  .mn-flt .dash { color:#9AA1AC; }
  table.mn { width:100%; border-collapse:separate; border-spacing:0; font-size:13px; }
  table.mn thead th { position:sticky; top:0; z-index:2; padding:6px 8px; background:#F8F9FA; border-bottom:1px solid #E6E8EC; color:#6B7280;
    font-size:11px; font-weight:600; text-transform:uppercase; letter-spacing:.3px; text-align:center; white-space:nowrap; }
  table.mn thead tr + tr th { top:29px; }
  table.mn thead th.l { text-align:left; }
  table.mn thead th.g { border-left:1px solid #E6E8EC; }
  table.mn td { height:36px; padding:0 8px; border-bottom:1px solid #F0F1F4; vertical-align:middle; font-variant-numeric:tabular-nums; }
  table.mn td.n { text-align:right; white-space:nowrap; }
  table.mn td.c { text-align:center; white-space:nowrap; }
  table.mn td.g { border-left:1px solid #F0F1F4; }
  table.mn td.m { color:#6B7280; }
  table.mn tbody tr:hover td { background:#F8F9FB; }
  table.mn tr.neg td { background:#FDECEE; color:#A50F22; font-weight:600; }
  table.mn tr.neg:hover td { background:#FBDDE1; }
  table.mn tr.sel td { background:#EEF3FB; }
  table.mn tr.tot td { background:#FAFBFC; font-weight:700; border-top:1px solid #E6E8EC; }
  table.mn tr.grp td { background:#F5F6F8; font-weight:700; color:#1F2430; padding-top:6px; padding-bottom:6px; }
  table.mn .nm { font-weight:600; }
  .mn-sum { display:flex; flex-wrap:wrap; gap:6px 24px; font-size:13px; color:#6B7280; }
  .mn-sum b { color:#1F2430; font-variant-numeric:tabular-nums; }
  .mn-scroll { height:100%; overflow:auto; }
  .mn-cards { display:flex; flex-direction:column; gap:12px; }
  .mn-card { background:#fff; border:1px solid #E6E8EC; border-radius:14px; overflow:hidden; }
  .mn-card-h { display:flex; align-items:center; gap:10px; padding:10px 14px; border-bottom:1px solid #F0F1F4; font-weight:700; font-size:14px; }
  .mn-card-h .fm-count { font-weight:500; }
</style>
<script>
  // строки tbody#<p>Rows с data-s; tr без data-s (итоги, группы) не скрываются
  function mnFilter(p) {
    var q = $.trim($('#' + p + 'Search').val() || '').toLowerCase(), words = q ? q.split(/\s+/) : [], n = 0;
    $('#' + p + 'Rows > tr[data-s]').each(function () {
      var s = String($(this).attr('data-s')).toLowerCase(), ok = true;
      for (var i = 0; ok && i < words.length; i++) if (s.indexOf(words[i]) < 0) ok = false;
      $(this).toggle(ok);
      if (ok) n++;
    });
    $('#' + p + 'Shown').text(n);
    $('#' + p + 'Empty').toggle(n == 0);
  }
  function mnPeriod(url, extra) {
    setPage(url + '?period_start=' + encodeURIComponent($('#period_start').val()) + '&period_end=' + encodeURIComponent($('#period_end').val()) + (extra || ''));
  }
  function mnExcel(id, name) { TableToExcel.convert(document.getElementById(id), {name: (name || 'report') + '.xlsx'}); }
  function mnSel(tr) { $(tr).addClass('sel').siblings().removeClass('sel'); }
</script>
