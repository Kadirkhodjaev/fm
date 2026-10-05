<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/js/fms-calendar.js" type="text/javascript"></script>
<style>
  .ac { --brand:#D7182E; --brand-soft:#FDECEE; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8; --ok:#15803D; --ok-bg:#E8F7EE; --warn:#B45309; --warn-bg:#FEF3C7;
    padding:12px 14px 28px; color:var(--text); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; font-size:14px; }
  .ac * { box-sizing:border-box; }
  .ac-top { display:flex; align-items:flex-end; gap:10px 12px; flex-wrap:wrap; margin-bottom:12px; }
  .ac-top h2 { margin:0 8px 4px 0; font-size:19px; font-weight:700; }
  .ac .f { display:flex; flex-direction:column; gap:3px; }
  .ac .f > label { margin:0; font-size:11.5px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.2px; }
  .ac .ai { height:34px; border:1.5px solid var(--border); border-radius:9px; padding:4px 10px; font-size:14px; background:#fff; color:var(--text); }
  .ac .ai:focus { border-color:var(--brand); box-shadow:0 0 0 3px rgba(215,24,46,.10); outline:none; }
  .ac .ab { display:inline-flex; align-items:center; gap:7px; height:34px; padding:0 13px; border-radius:9px; border:1.5px solid var(--border); background:#fff; color:var(--text);
    font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  .ac .ab:hover { background:var(--bg); }
  .ac .ab.primary { background:var(--brand); border-color:var(--brand); color:#fff; }
  .ac-card { background:#fff; border:1px solid var(--border); border-radius:14px; overflow:hidden; }
  .ac-bar { display:flex; align-items:center; gap:8px; flex-wrap:wrap; padding:10px 14px; border-bottom:1px solid var(--border); background:#FAFBFC; }
  .ac-bar .sp { flex:1; }
  .ac-chip { display:inline-flex; align-items:center; gap:6px; height:30px; padding:0 12px; border-radius:15px; border:1.5px solid var(--border); background:#fff; font-size:13px; font-weight:600; cursor:pointer; color:#374151; }
  .ac-chip.on { background:var(--brand-soft); border-color:var(--brand); color:var(--brand); }
  table.act { width:100%; border-collapse:collapse; }
  table.act th { padding:8px 12px; font-size:11px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px; text-align:left; background:#F8F9FA; border-bottom:1px solid var(--border); white-space:nowrap; }
  table.act th.r, table.act td.r { text-align:right; }
  table.act td { padding:9px 12px; border-bottom:1px solid #F0F1F4; vertical-align:middle; font-variant-numeric:tabular-nums; }
  table.act tbody tr { cursor:pointer; }
  table.act tbody tr:hover td { background:#FAFBFC; }
  table.act td.nm { font-weight:600; }
  .ac-st { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; font-weight:600; background:var(--warn-bg); color:var(--warn); }
  .ac-st.o { background:var(--ok-bg); color:var(--ok); }
  .ac-st.c { background:#F1F2F4; color:var(--muted); }
  .ac-foot { display:flex; gap:6px 28px; flex-wrap:wrap; padding:10px 14px; border-top:1px solid var(--border); background:#FAFBFC; font-size:13px; color:var(--muted); }
  .ac-foot b { color:var(--text); }
  .ac-empty { padding:26px; text-align:center; color:var(--muted); }
</style>
<div class="ac" id="ac">
  <div class="ac-top">
    <h2>Приход</h2>
    <div class="f"><label>С</label><input name="period_start" id="period_start" type="text" class="ai fms-cal" autocomplete="off" style="width:125px; text-align:center" value="${period_start}"/></div>
    <div class="f"><label>По</label><input name="period_end" id="period_end" type="text" class="ai fms-cal" autocomplete="off" style="width:125px; text-align:center" value="${period_end}"/></div>
    <div class="f" style="min-width:260px; flex:0 1 380px">
      <label>Поставщик</label>
      <select class="ai" id="partner" onchange="AC.filter()">
        <option value="">Все поставщики</option>
        <c:forEach items="${partners}" var="par">
          <option <c:if test="${partner == par.id}">selected</c:if> value="${par.id}"><c:out value="${par.name}"/></option>
        </c:forEach>
      </select>
    </div>
    <button onclick="AC.filter()" class="ab" type="button"><i class="fa fa-search"></i> Показать</button>
    <span style="flex:1"></span>
    <button class="ab primary" onclick="AC.open(0)" type="button"><i class="fa fa-plus"></i> Новый акт прихода</button>
  </div>

  <div class="ac-card">
    <div class="ac-bar">
      <button type="button" class="ac-chip on" data-s="">Все <b id="cn-all">0</b></button>
      <button type="button" class="ac-chip" data-s="E">Не подтверждены <b id="cn-e">0</b></button>
      <button type="button" class="ac-chip" data-s="O">Подтверждены <b id="cn-o">0</b></button>
      <span class="sp"></span>
      <input type="text" class="ai" id="ac-search" placeholder="Поиск по поставщику, номеру акта..." style="width:300px" autocomplete="off">
    </div>
    <%@include file="/incs/msgs/successError.jsp"%>
    <div style="overflow-x:auto">
      <table class="act" id="ac-table">
        <thead>
          <tr>
            <th style="width:70px">№</th>
            <th>Поставщик</th>
            <th>Акт</th>
            <th class="r">Позиций</th>
            <th class="r">Сумма с НДС</th>
            <th>Состояние</th>
            <th>Дата и время ввода</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach items="${acts}" var="obj">
            <tr data-id="${obj.ib}" data-s="${obj.c5}" data-sum="${empty obj.c4 ? 0 : obj.c4}">
              <td>${obj.ib}</td>
              <td class="nm"><c:out value="${obj.c1}"/></td>
              <td><c:out value="${obj.c2}"/></td>
              <td class="r">${obj.c3}</td>
              <td class="r"><fmt:formatNumber value="${obj.c4}" type="number"/></td>
              <td>
                <c:if test="${obj.c5 == 'E'}"><span class="ac-st">Введён</span></c:if>
                <c:if test="${obj.c5 == 'O'}"><span class="ac-st o">Подтверждён</span></c:if>
                <c:if test="${obj.c5 == 'C'}"><span class="ac-st c">Закрыт</span></c:if>
              </td>
              <td>${obj.c6}</td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
      <div class="ac-empty" id="ac-empty" style="display:none">Актов за выбранный период нет</div>
    </div>
    <div class="ac-foot"><span>Актов: <b id="f-n">0</b></span><span>На сумму: <b id="f-sum">0</b></span><span style="margin-left:auto">Двойной клик или клик по строке открывает акт</span></div>
  </div>
</div>
<script>
  window.AC = (function () {
    var st = '', q = '';
    function num(v) { var n = parseFloat(('' + v).replace(/[\s ]/g, '').replace(',', '.')); return isNaN(n) ? 0 : n; }
    function fmt2(n) { return n.toLocaleString('ru-RU', {minimumFractionDigits: 2, maximumFractionDigits: 2}); }
    function open(id) { setPage('/drugs/act/addEdit.s?id=' + id); }
    function filter() {
      setPage('/drugs/acts.s?period_start=' + $('#period_start').val() + '&period_end=' + $('#period_end').val() + '&partner=' + $('#partner').val());
    }
    function apply() {
      var words = $.trim(q).toLowerCase().split(/\s+/).filter(Boolean), n = 0, sum = 0;
      $('#ac-table tbody tr').each(function () {
        var t = $(this), ok = !st || t.data('s') === st;
        if (ok) { var text = t.text().toLowerCase(); for (var i = 0; i < words.length; i++) if (text.indexOf(words[i]) === -1) { ok = false; break; } }
        t.toggle(ok);
        if (ok) { n++; sum += num(t.data('sum')); }
      });
      $('#f-n').text(n); $('#f-sum').text(fmt2(sum));
      $('#ac-empty').toggle(!n); $('#ac-table').toggle(n > 0);
    }
    $(function () {
      var rows = $('#ac-table tbody tr');
      $('#cn-all').text(rows.length);
      $('#cn-e').text(rows.filter('[data-s=E]').length);
      $('#cn-o').text(rows.filter('[data-s=O]').length);
      $('.ac-chip').on('click', function () { st = '' + $(this).data('s'); $('.ac-chip').removeClass('on'); $(this).addClass('on'); apply(); });
      $('#ac-search').on('input', function () { q = this.value; apply(); });
      $('#ac-table tbody').on('click', 'tr', function () { open($(this).data('id')); });
      $('#period_start, #period_end').on('keydown', function (e) { if (e.which === 13) filter(); });
      apply();
    });
    return {open: open, filter: filter};
  })();
</script>
