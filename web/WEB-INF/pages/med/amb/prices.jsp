<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<link href="/res/css/styles.css" rel="stylesheet" type="text/css">
<style>
  .pr { --brand:#D7182E; --brand-dark:#A50F22; --brand-soft:#FDECEE; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    height:100%; box-sizing:border-box; display:flex; gap:16px; padding:16px 20px; color:var(--text);
    font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .pr *, .pr *:before, .pr *:after { box-sizing:border-box; }
  .pr-card { background:#fff; border:1px solid var(--border); border-radius:14px; overflow:hidden; }
  /* Левая часть: шапка и вкладки на месте, прокручивается только список услуг */
  .pr-main { flex:1; min-width:0; display:flex; flex-direction:column; }
  .pr-main > .pr-h, .pr-main > .pr-foot { flex:none; }
  .pr-scroll { flex:1; min-height:0; overflow-y:auto; }
  .pr-t thead th { position:sticky; top:0; z-index:1; }

  /* ---------- Шапка ---------- */
  .pr-h { display:flex; align-items:center; gap:14px; padding:16px 18px; border-bottom:1px solid var(--border); flex-wrap:wrap; }
  .pr-h .ico { flex:none; width:38px; height:38px; border-radius:10px; background:var(--brand-soft); color:var(--brand);
    display:flex; align-items:center; justify-content:center; font-size:17px; }
  .pr-h h3 { margin:0; font-size:17px; font-weight:700; line-height:1.2; }
  .pr-h .sub { font-size:12.5px; color:var(--muted); margin-top:2px; }
  .pr-h .sp { flex:1; }
  .pr-search { position:relative; width:320px; max-width:100%; }
  .pr-search i { position:absolute; left:12px; top:50%; transform:translateY(-50%); color:#9AA1AC; font-size:14px; }
  .pr-search input { width:100%; height:38px; padding:0 34px 0 34px; border:1px solid var(--border); border-radius:10px;
    font-size:14px; color:var(--text); background:#fff; outline:none; transition:border-color .15s, box-shadow .15s; }
  .pr-search input:focus { border-color:var(--brand); box-shadow:0 0 0 3px var(--brand-soft); }
  .pr-search .clr { position:absolute; right:8px; top:50%; transform:translateY(-50%); border:0; background:none; color:#9AA1AC;
    font-size:16px; line-height:1; padding:4px; cursor:pointer; display:none; }
  .pr.searching .pr-search .clr { display:block; }

  /* ---------- Группы: колонка слева со своим скроллом ---------- */
  .pr-nav { flex:0 0 270px; display:flex; flex-direction:column; }
  .pr-nav .s-h { flex:none; display:flex; align-items:center; gap:10px; padding:16px 18px; border-bottom:1px solid var(--border); }
  .pr-nav .s-h h3 { margin:0; font-size:16px; font-weight:700; flex:1; }
  .pr-nav .s-h span { font-size:13px; font-weight:600; color:var(--muted); }
  .pr .pr-tabs { flex:1; min-height:0; overflow-y:auto; display:block; padding:6px 8px; margin:0; border:0; list-style:none; }
  .pr .pr-tabs > li { float:none; display:block; margin:0 0 2px; }
  .pr .pr-tabs > li > a { display:flex; align-items:center; gap:8px; padding:8px 10px; margin:0; border:0 !important; border-radius:9px;
    color:var(--text); font-size:13.5px; font-weight:500; line-height:1.3; background:none; text-decoration:none; }
  .pr .pr-tabs > li > a .gn { flex:1; min-width:0; }
  .pr .pr-tabs > li > a:hover { background:var(--bg); }
  .pr .pr-tabs > li.active > a, .pr .pr-tabs > li.active > a:hover, .pr .pr-tabs > li.active > a:focus
  { background:var(--brand-soft); color:var(--brand); font-weight:600; }
  .pr .pr-tabs .cnt { flex:none; font-size:11.5px; font-weight:600; color:#9AA1AC; }
  .pr .pr-tabs > li.active .cnt { color:var(--brand); }
  .pr.searching .pr-tabs > li.active > a { background:none; color:var(--text); font-weight:500; }
  .pr.searching .pr-tabs > li.active .cnt { color:#9AA1AC; }

  /* ---------- Таблица ---------- */
  .pr-grp { padding:12px 16px; background:#F8F9FA; border-bottom:1px solid var(--border); font-weight:700; font-size:13.5px; }
  .pr.searching .tab-content > .tab-pane { display:block !important; opacity:1 !important; }
  .pr.searching .tab-pane.empty { display:none !important; }
  .pr-t { width:100%; border-collapse:separate; border-spacing:0; font-size:14px; }
  .pr-t th { padding:10px 16px; background:#F8F9FA; border-bottom:1px solid var(--border); color:var(--muted); font-size:12px; font-weight:600;
    text-transform:uppercase; letter-spacing:.3px; text-align:right; white-space:nowrap; }
  .pr-t th:first-child { text-align:left; }
  .pr-t td { padding:10px 16px; border-bottom:1px solid #F0F1F4; text-align:right; white-space:nowrap; font-variant-numeric:tabular-nums; }
  .pr-t td:first-child { text-align:left; white-space:normal; }
  .pr-t th.nm, .pr-t td.nm { text-align:left; white-space:normal; }
  .pr-t td.num { color:#9AA1AC; width:44px; text-align:left; }
  .pr-t td.pr-for { color:var(--muted); }
  .pr-t tbody tr:hover td { background:#FAFBFC; }
  .pr-t tbody tr:last-child td { border-bottom:0; }
  .pr-t .z { color:#C3C7CE; }
  .pr-t tr.hid { display:none; }
  .pr-t mark { background:#FEF3E2; color:inherit; padding:0 1px; border-radius:3px; }
  .pr-empty { display:none; padding:40px 16px; text-align:center; color:var(--muted); font-size:14px; }
  .pr-empty i { display:block; font-size:28px; color:#C3C7CE; margin-bottom:8px; }
  .pr.nothing .pr-empty { display:block; }
  /* ---------- Калькулятор ---------- */
  .pr-t tbody tr { cursor:pointer; }
  .pr-t td.chk { width:40px; padding-right:0; text-align:left; }
  .pr-t .cb { display:inline-flex; align-items:center; justify-content:center; width:18px; height:18px; border:1.5px solid #C9CDD4;
    border-radius:5px; background:#fff; color:#fff; font-size:11px; transition:all .12s; }
  .pr-t tr.on td { background:#FFF7F8; }
  .pr-t tbody tr.on:hover td { background:#FDECEE; }
  .pr-t tr.on .cb { background:var(--brand); border-color:var(--brand); }
  .pr .pr-tabs .sel { flex:none; display:none; font-size:11.5px; font-weight:700; padding:1px 7px; border-radius:10px; background:var(--brand); color:#fff; }
  .pr .pr-tabs .sel.show { display:inline-block; }
  /* Правая панель расчёта — всегда на виду */
  .pr-side { flex:0 0 330px; display:flex; flex-direction:column; }
  .pr-side .s-h { display:flex; align-items:center; gap:10px; padding:16px 18px; border-bottom:1px solid var(--border); }
  .pr-side .s-h h3 { margin:0; font-size:16px; font-weight:700; flex:1; }
  .pr-side .s-h .cnt-b { font-size:13px; font-weight:600; color:var(--muted); }
  .pr-tot { padding:16px 18px; border-bottom:1px solid var(--border); background:#FCFCFD; }
  .pr-tot .lbl { font-size:12px; color:var(--muted); font-weight:600; text-transform:uppercase; letter-spacing:.3px; }
  .pr-tot .sum { font-size:30px; font-weight:700; line-height:1.15; margin:2px 0 12px; font-variant-numeric:tabular-nums; letter-spacing:-.5px; }
  .pr-tot .sum small, .pr-tot .sumf small { font-size:13px; font-weight:600; color:var(--muted); margin-left:4px; letter-spacing:0; }
  .pr-tot .sumf { font-size:18px; font-weight:700; color:var(--muted); font-variant-numeric:tabular-nums; }
  .pr.has-sel .pr-tot .sum { color:var(--brand); }
  .pr-sel { flex:1; min-height:0; overflow-y:auto; padding:6px 0; }
  .pr-sel .it { display:flex; align-items:flex-start; gap:8px; padding:8px 12px 8px 18px; font-size:13.5px; }
  .pr-sel .it:hover { background:#FAFBFC; }
  .pr-sel .it .n { flex:1; min-width:0; line-height:1.35; }
  .pr-sel .it .g { display:block; font-size:11.5px; color:#9AA1AC; }
  .pr-sel .it b { font-weight:600; white-space:nowrap; font-variant-numeric:tabular-nums; }
  .pr-sel .it button { border:0; background:none; color:#9AA1AC; font-size:17px; line-height:1; padding:0 4px; cursor:pointer; }
  .pr-sel .it button:hover { color:var(--brand); }
  .pr-sel .none { padding:28px 18px; text-align:center; color:#9AA1AC; font-size:13.5px; line-height:1.5; }
  .pr-sel .none i { display:block; font-size:26px; color:#D5D8DD; margin-bottom:8px; }
  .pr.has-sel .pr-sel .none { display:none; }
  .pr-side .s-f { padding:12px 18px; border-top:1px solid var(--border); }
  .pr-btn { width:100%; height:40px; border-radius:10px; font-size:14px; font-weight:600; cursor:pointer; display:flex; justify-content:center;
    align-items:center; gap:8px; border:1px solid var(--brand); background:var(--brand); color:#fff; }
  .pr-btn:hover { background:var(--brand-dark); }
  .pr-btn:disabled { background:#F1F2F4; border-color:var(--border); color:#9AA1AC; cursor:default; }
  @media (max-width: 1400px) { .pr-nav { flex-basis:230px; } .pr-side { flex-basis:290px; } .pr-tot .sum { font-size:26px; } }
  @media (max-width: 1100px) { .pr { gap:10px; padding:12px; } .pr-nav { flex-basis:200px; } .pr-side { flex-basis:250px; } .pr-tot .sum { font-size:22px; } }
  .pr-foot { padding:10px 18px; border-top:1px solid var(--border); font-size:12.5px; color:#9AA1AC; background:#FCFCFD; }
</style>
<script type="text/javascript">
  function saveServices() {
    $.ajax({
      url: '/amb/services.s',
      method: 'post',
      data: $('#services').serialize(),
      dataType: 'json',
      success:function (res) {
        openMainPage('/amb/reg.s?id=${id}');
      }
    });
  }
</script>

<div class="pr" id="prPage">
  <div class="pr-card pr-nav">
    <div class="s-h"><h3>Группы</h3><span>${fn:length(groups)}</span></div>
    <ul class="nav pr-tabs">
      <c:forEach items="${groups}" var="g" varStatus="loop">
        <li <c:if test="${loop.index == 0}">class="active"</c:if>>
          <a href="#page${g.group.id}" data-toggle="tab" aria-expanded="true"><span class="gn">${g.group.name}</span><span class="sel" data-g="${g.group.id}"></span><span class="cnt">${fn:length(g.services)}</span></a>
        </li>
      </c:forEach>
    </ul>
  </div>

  <div class="pr-card pr-main">
    <div class="pr-h">
      <span class="ico"><i class="fa fa-list-alt"></i></span>
      <div>
        <h3>Список обследования</h3>
        <div class="sub">Цены указаны с НДС 12%</div>
      </div>
      <span class="sp"></span>
      <div class="pr-search">
        <i class="fa fa-search"></i>
        <input type="text" id="prSearch" placeholder="Поиск услуги по названию" autocomplete="off">
        <button type="button" class="clr" id="prClear" title="Очистить">&times;</button>
      </div>
    </div>


    <div class="pr-scroll">
      <div class="tab-content">
        <c:forEach items="${groups}" var="g" varStatus="loop">
          <div class="tab-pane <c:if test="${loop.index == 0}">active</c:if> fade in" id="page${g.group.id}">
            <div class="pr-grp">${g.group.name}</div>
            <table class="pr-t">
              <thead>
              <tr>
                <th style="width:40px"></th>
                <th style="width:44px">№</th>
                <th class="nm">Наименование</th>
                <th style="width:180px">Стоимость</th>
                <th style="width:200px">Стоимость (иностранцы)</th>
              </tr>
              </thead>
              <tbody>
              <c:forEach items="${g.services}" var="k" varStatus="st">
                <tr data-k="${g.group.id}-${st.index}" data-g="${g.group.id}" data-p="${k.price * 1.12}" data-f="${k.for_price * 1.12}">
                  <td class="chk"><span class="cb"><i class="fa fa-check"></i></span></td>
                  <td class="num">${st.count}</td>
                  <td class="nm" data-gn="${g.group.name}">${k.name}</td>
                  <td>
                    <c:choose>
                      <c:when test="${k.price > 0}"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${k.price * 1.12}"/></c:when>
                      <c:otherwise><span class="z">—</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td class="pr-for">
                    <c:choose>
                      <c:when test="${k.for_price > 0}"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${k.for_price * 1.12}"/></c:when>
                      <c:otherwise><span class="z">—</span></c:otherwise>
                    </c:choose>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </c:forEach>
      </div>

      <div class="pr-empty"><i class="fa fa-search"></i>Ничего не найдено</div>
    </div>
    <div class="pr-foot">Нажмите на строку, чтобы добавить услугу в расчёт. Цена со знаком «—» не задана.</div>
  </div>

  <div class="pr-card pr-side" id="prCalc">
    <div class="s-h"><h3>Расчёт</h3><span class="cnt-b" id="prCnt">0 услуг</span></div>
    <div class="pr-tot">
      <div class="lbl">Итого</div>
      <div class="sum" id="prSum">0.00<small>сум</small></div>
      <div class="lbl">Для иностранцев</div>
      <div class="sumf" id="prSumF">0.00<small>сум</small></div>
    </div>
    <div class="pr-sel">
      <div class="none"><i class="fa fa-calculator"></i>Отметьте услуги в списке,<br>здесь появится их сумма</div>
      <div id="prChips"></div>
    </div>
    <div class="s-f"><button type="button" class="pr-btn" id="prReset" disabled><i class="fa fa-times"></i> Сбросить</button></div>
  </div>
</div>

<script>
  // Поиск по всем группам: при вводе показываются все вкладки сразу, с заголовками групп
  (function () {
    var page = document.getElementById('prPage'), inp = document.getElementById('prSearch');
    if (!page || !inp) return;
    var cells = page.querySelectorAll('.pr-t td.nm');
    cells.forEach(function (td) { td.setAttribute('data-t', td.textContent.trim()); });

    function esc(s) { return s.replace(/[&<>"]/g, function (c) { return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]; }); }

    function run() {
      var q = inp.value.trim().toLowerCase();
      page.classList.toggle('searching', !!q);
      var total = 0;
      page.querySelectorAll('.tab-content > .tab-pane').forEach(function (pane) {
        var n = 0;
        pane.querySelectorAll('td.nm').forEach(function (td) {
          var t = td.getAttribute('data-t'), i = q ? t.toLowerCase().indexOf(q) : 0, ok = !q || i >= 0;
          td.parentNode.classList.toggle('hid', !ok);
          td.innerHTML = q && ok ? esc(t.slice(0, i)) + '<mark>' + esc(t.slice(i, i + q.length)) + '</mark>' + esc(t.slice(i + q.length)) : esc(t);
          if (ok) n++;
        });
        pane.classList.toggle('empty', !n);
        total += n;
      });
      page.classList.toggle('nothing', !!q && !total);
    }

    inp.addEventListener('input', run);
    inp.addEventListener('keydown', function (e) { if (e.key === 'Escape') { inp.value = ''; run(); } });
    page.querySelectorAll('.pr-tabs a').forEach(function (a) {
      a.addEventListener('click', function () {
        if (inp.value) { inp.value = ''; run(); }
        var sc = page.querySelector('.pr-scroll'); if (sc) sc.scrollTop = 0;
      });
    });
    document.getElementById('prClear').addEventListener('click', function () { inp.value = ''; run(); inp.focus(); });
  })();

  // Калькулятор: клик по строке добавляет услугу в расчёт, выбор сохраняется при смене вкладки и поиске
  (function () {
    var page = document.getElementById('prPage'); if (!page) return;
    var chips = document.getElementById('prChips'), resetBtn = document.getElementById('prReset');

    // Высота страницы по окну: если обёртка не задаёт высоту, всё равно прокручивается только список
    function fit() {
      page.style.height = '';
      var avail = window.innerHeight - page.getBoundingClientRect().top - 8;
      if (avail > 300 && page.offsetHeight > avail) page.style.height = avail + 'px';
    }
    fit(); window.addEventListener('resize', fit);

    function money(v) {
      var p = (Math.round(v * 100) / 100).toFixed(2).split('.');
      return p[0].replace(/\B(?=(\d{3})+(?!\d))/g, ' ') + ',' + p[1];
    }
    function word(n) {
      var a = n % 10, b = n % 100;
      return n + (a == 1 && b != 11 ? ' услуга' : a >= 2 && a <= 4 && (b < 12 || b > 14) ? ' услуги' : ' услуг');
    }
    function esc(s) { return s.replace(/[&<>"]/g, function (c) { return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]; }); }
    function num(v) { return Math.round((parseFloat(v) || 0) * 100) / 100; }

    function update() {
      var on = page.querySelectorAll('.pr-t tbody tr.on'), sum = 0, sumF = 0, html = '', groups = {};
      on.forEach(function (tr) {
        var p = num(tr.getAttribute('data-p')), f = num(tr.getAttribute('data-f')), g = tr.getAttribute('data-g');
        sum += p; sumF += f; groups[g] = (groups[g] || 0) + 1;
        var nm = tr.querySelector('td.nm');
        html += '<div class="it"><span class="n">' + esc(nm.getAttribute('data-t') || nm.textContent.trim()) +
          '<span class="g">' + esc(nm.getAttribute('data-gn') || '') + '</span></span><b>' + (p ? money(p) : '—') +
          '</b><button type="button" data-k="' + tr.getAttribute('data-k') + '" title="Убрать">&times;</button></div>';
      });
      document.getElementById('prCnt').textContent = word(on.length);
      document.getElementById('prSum').innerHTML = money(sum) + '<small>сум</small>';
      document.getElementById('prSumF').innerHTML = money(sumF) + '<small>сум</small>';
      chips.innerHTML = html;
      page.querySelectorAll('.pr-tabs .sel').forEach(function (b) {
        var n = groups[b.getAttribute('data-g')] || 0;
        b.textContent = n; b.classList.toggle('show', n > 0);
      });
      page.classList.toggle('has-sel', on.length > 0);
      resetBtn.disabled = !on.length;
    }

    page.querySelectorAll('.pr-t tbody tr').forEach(function (tr) {
      tr.addEventListener('click', function () { tr.classList.toggle('on'); update(); });
    });
    chips.addEventListener('click', function (e) {
      var k = e.target.getAttribute && e.target.getAttribute('data-k'); if (!k) return;
      var tr = page.querySelector('.pr-t tr[data-k="' + k + '"]'); if (tr) tr.classList.remove('on');
      update();
    });
    resetBtn.addEventListener('click', function () {
      page.querySelectorAll('.pr-t tbody tr.on').forEach(function (tr) { tr.classList.remove('on'); });
      update();
    });
  })();
</script>
