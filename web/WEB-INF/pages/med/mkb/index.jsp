<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Справочник МКБ-10 для выбора диагноза (окно из осмотра, обоснования и выписки).
     Поиск по коду и названию, дерево разделов, выбор диагноза кнопкой, двойным щелчком или Enter -> window.opener.setMkb(text, id) --%>
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <title>МКБ-10</title>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
  <link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
  <style>
    * { box-sizing:border-box; }
    html, body { height:100%; margin:0; }
    body { background:#F5F6F8; color:#1F2430; font:14px/1.45 Inter, -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; display:flex; flex-direction:column; }
    .mk-top { flex:none; display:flex; align-items:center; gap:14px; padding:12px 16px; background:#fff; border-bottom:1px solid #E6E8EC; }
    .mk-top h1 { margin:0; font-size:17px; font-weight:700; white-space:nowrap; }
    .mk-top h1 small { display:block; font-size:12px; font-weight:400; color:#6B7280; }
    .mk-search { flex:1; position:relative; max-width:640px; }
    .mk-search i { position:absolute; left:12px; top:50%; transform:translateY(-50%); color:#9AA1AC; }
    .mk-search input { width:100%; height:38px; padding:0 36px; border:1px solid #E6E8EC; border-radius:10px; font:inherit; background:#F9FAFB; }
    .mk-search input:focus { outline:none; border-color:#4B5563; background:#fff; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
    .mk-search .x { position:absolute; right:10px; top:50%; transform:translateY(-50%); border:0; background:none; color:#9AA1AC; cursor:pointer; font-size:16px; display:none; }
    .mk-main { flex:1; min-height:0; display:grid; grid-template-columns:minmax(0, 1fr) 340px; gap:12px; padding:12px; }
    .mk-card { background:#fff; border:1px solid #E6E8EC; border-radius:14px; min-height:0; display:flex; flex-direction:column; overflow:hidden; }
    .mk-head { flex:none; padding:10px 14px; border-bottom:1px solid #F0F1F4; font-size:12px; color:#6B7280; text-transform:uppercase; letter-spacing:.4px; font-weight:600; display:flex; justify-content:space-between; }
    .mk-list { flex:1; overflow:auto; padding:6px 0; }
    .mk-row { display:flex; align-items:flex-start; gap:8px; padding:6px 14px; cursor:pointer; user-select:none; }
    .mk-row:hover { background:#F5F6F8; }
    .mk-row.sel { background:#EEF0F3; box-shadow:inset 3px 0 0 #1F2430; }
    .mk-row .tg { flex:none; width:16px; color:#9AA1AC; text-align:center; padding-top:2px; font-size:12px; }
    .mk-row .cd { flex:none; min-width:64px; font-weight:600; font-variant-numeric:tabular-nums; color:#1F2430; }
    .mk-row .nm { flex:1; min-width:0; }
    .mk-row.grp .nm { font-weight:600; }
    .mk-row .pth { display:block; font-size:12px; color:#9AA1AC; }
    .mk-row mark { background:#FEF3C7; color:inherit; border-radius:3px; padding:0 1px; }
    .mk-empty { padding:40px 20px; text-align:center; color:#9AA1AC; }
    .mk-info { flex:1; overflow:auto; padding:16px; }
    .mk-info .cd { font-size:22px; font-weight:700; }
    .mk-info .nm { font-size:15px; font-weight:600; margin:4px 0 10px; }
    .mk-info .pth { font-size:12.5px; color:#6B7280; margin-bottom:12px; }
    .mk-info .txt { font-size:13.5px; color:#374151; text-align:justify; white-space:pre-line; }
    .mk-info .hint { color:#9AA1AC; font-size:13px; }
    .mk-foot { flex:none; padding:12px 16px; border-top:1px solid #F0F1F4; }
    .mk-btn { width:100%; height:40px; border:0; border-radius:10px; background:#1F2430; color:#fff; font:600 14px Inter, Arial, sans-serif; cursor:pointer; }
    .mk-btn[disabled] { background:#D1D5DB; cursor:default; }
    .mk-note { margin-top:8px; font-size:12px; color:#9AA1AC; text-align:center; }
    @media (max-width: 760px) { .mk-main { grid-template-columns:1fr; } }
  </style>
</head>
<body>
<div class="mk-top">
  <h1>МКБ-10<small>Международная классификация болезней</small></h1>
  <div class="mk-search">
    <i class="fa fa-search"></i>
    <input type="text" id="mkQ" autocomplete="off" placeholder="Код или название: I10, гипертензия, бронхит…" autofocus>
    <button type="button" class="x" id="mkX" title="Очистить">&times;</button>
  </div>
</div>
<div class="mk-main">
  <div class="mk-card">
    <div class="mk-head"><span id="mkTitle">Разделы</span><span id="mkCount"></span></div>
    <div class="mk-list" id="mkList"></div>
  </div>
  <div class="mk-card">
    <div class="mk-head"><span>Диагноз</span></div>
    <div class="mk-info" id="mkInfo"><div class="hint">Найдите диагноз поиском или в разделах слева и выберите его.</div></div>
    <div class="mk-foot">
      <button type="button" class="mk-btn" id="mkPick" disabled>Выбрать</button>
      <div class="mk-note">или двойной щелчок по диагнозу, Enter</div>
    </div>
  </div>
</div>

<script>
(function () {
  'use strict';
  var data = ${mkb};
  // узлы: id, parent, text, code, info; дети в порядке справочника
  var byId = {}, kids = {}, roots = [];
  data.forEach(function (n) {
    byId[n.id] = n;
    if (n.parent === '#') roots.push(n);
    else (kids[n.parent] = kids[n.parent] || []).push(n);
  });
  var open = {}, sel = null, found = null;
  var list = document.getElementById('mkList'), info = document.getElementById('mkInfo'), pick = document.getElementById('mkPick');
  var q = document.getElementById('mkQ'), clr = document.getElementById('mkX');

  function esc(s) { return String(s == null ? '' : s).replace(/[&<>"]/g, function (c) { return {'&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;'}[c]; }); }
  function isLeaf(n) { return !kids[n.id]; }
  function path(n) {
    var p = [], x = byId[n.parent];
    while (x) { p.unshift((x.code ? x.code + ' ' : '') + x.text); x = byId[x.parent]; }
    return p;
  }
  function mark(text, words) {
    var s = esc(text);
    words.forEach(function (w) {
      if (!w) return;
      s = s.replace(new RegExp('(' + w.replace(/[.*+?^$(){}|[\]\\]/g, '\\$&') + ')', 'ig'), '<mark>$1</mark>');
    });
    return s;
  }
  function row(n, depth, words) {
    var leaf = isLeaf(n);
    var el = document.createElement('div');
    el.className = 'mk-row' + (leaf ? '' : ' grp') + (sel === n ? ' sel' : '');
    if (depth != null) el.style.paddingLeft = (14 + depth * 18) + 'px';
    el.innerHTML = '<span class="tg">' + (leaf ? '' : '<i class="fa fa-' + (open[n.id] ? 'minus' : 'plus') + '-square-o"></i>') + '</span>' +
      '<span class="cd">' + (words ? mark(n.code || '', words) : esc(n.code || '')) + '</span>' +
      '<span class="nm">' + (words ? mark(n.text, words) : esc(n.text)) +
      (words ? '<span class="pth">' + esc(path(n).join(' › ')) + '</span>' : '') + '</span>';
    el.onclick = function () {
      if (!leaf && !words) { open[n.id] = !open[n.id]; }
      select(n);
      if (!words) renderTree();
    };
    el.ondblclick = function () { if (leaf) choose(n); };
    n._el = el;
    el._n = n;
    return el;
  }
  function renderTree() {
    found = null;
    var frag = document.createDocumentFragment(), count = 0;
    (function walk(nodes, depth) {
      nodes.forEach(function (n) {
        frag.appendChild(row(n, depth));
        count++;
        if (open[n.id] && kids[n.id]) walk(kids[n.id], depth + 1);
      });
    })(roots, 0);
    var top = list.scrollTop;
    list.innerHTML = '';
    list.appendChild(frag);
    list.scrollTop = top;
    document.getElementById('mkTitle').textContent = 'Разделы';
    document.getElementById('mkCount').textContent = '';
  }
  function renderSearch(text) {
    var words = text.toLowerCase().split(/\s+/).filter(function (w) { return w; });
    var res = [];
    for (var i = 0; i < data.length && res.length < 300; i++) {
      var n = data[i], hay = ((n.code || '') + ' ' + n.text).toLowerCase();
      if (words.every(function (w) { return hay.indexOf(w) >= 0; })) res.push(n);
    }
    // сначала точное совпадение кода, потом конечные диагнозы, потом разделы
    var c = text.toUpperCase();
    res.sort(function (a, b) {
      var ea = (a.code || '').toUpperCase().indexOf(c) === 0 ? 0 : 1, eb = (b.code || '').toUpperCase().indexOf(c) === 0 ? 0 : 1;
      if (ea !== eb) return ea - eb;
      return (isLeaf(a) ? 0 : 1) - (isLeaf(b) ? 0 : 1);
    });
    found = res;
    list.innerHTML = '';
    if (!res.length) { list.innerHTML = '<div class="mk-empty"><i class="fa fa-search"></i><br>Ничего не найдено</div>'; }
    var frag = document.createDocumentFragment();
    res.forEach(function (n) { frag.appendChild(row(n, null, words)); });
    list.appendChild(frag);
    list.scrollTop = 0;
    document.getElementById('mkTitle').textContent = 'Найдено';
    document.getElementById('mkCount').textContent = res.length >= 300 ? 'первые 300, уточните запрос' : res.length;
    if (res.length) select(res[0]);
  }
  function select(n) {
    if (sel && sel._el) sel._el.classList.remove('sel');
    sel = n;
    if (n._el) n._el.classList.add('sel');
    var leaf = isLeaf(n), p = path(n);
    info.innerHTML = (n.code ? '<div class="cd">' + esc(n.code) + '</div>' : '') + '<div class="nm">' + esc(n.text) + '</div>' +
      (p.length ? '<div class="pth">' + esc(p.join(' › ')) + '</div>' : '') +
      (n.info ? '<div class="txt">' + esc(n.info) + '</div>' : '') +
      (leaf ? '' : '<div class="hint">Это раздел. Откройте его и выберите конкретный диагноз.</div>');
    pick.disabled = !leaf;
  }
  function choose(n) {
    if (!n || !isLeaf(n)) return;
    var opener = null;
    try { opener = window.opener && typeof window.opener.setMkb === 'function' ? window.opener : null; } catch (e) {}
    if (!opener) {
      info.insertAdjacentHTML('beforeend', '<div class="txt" style="color:#A50F22;margin-top:12px">Документ, из которого открыт справочник, уже закрыт. ' +
        'Откройте МКБ-10 заново из осмотра, обоснования или выписки.</div>');
      return;
    }
    opener.setMkb(n.text, n.id.replace('padre', ''));
    window.close();
  }
  pick.onclick = function () { choose(sel); };

  var t = null;
  q.addEventListener('input', function () {
    clr.style.display = q.value ? 'block' : 'none';
    clearTimeout(t);
    t = setTimeout(function () {
      var v = q.value.trim();
      if (v.length >= 2) renderSearch(v); else renderTree();
    }, 200);
  });
  clr.onclick = function () { q.value = ''; clr.style.display = 'none'; renderTree(); q.focus(); };
  // стрелки по списку, Enter - выбрать, Esc - очистить поиск
  document.addEventListener('keydown', function (e) {
    var rows = Array.prototype.slice.call(list.querySelectorAll('.mk-row'));
    var i = sel && sel._el ? rows.indexOf(sel._el) : -1;
    if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
      e.preventDefault();
      var j = Math.max(0, Math.min(rows.length - 1, i + (e.key === 'ArrowDown' ? 1 : -1)));
      if (rows[j]) { select(rows[j]._n); rows[j].scrollIntoView({block: 'nearest'}); }
    } else if (e.key === 'Enter') {
      e.preventDefault();
      if (!sel) return;
      // раздел в дереве - открыть или закрыть, диагноз - выбрать
      if (!isLeaf(sel) && !found) { open[sel.id] = !open[sel.id]; renderTree(); }
      else choose(sel);
    } else if (e.key === 'Escape' && q.value) {
      clr.onclick();
    }
  });
  renderTree();
})();
</script>
</body>
</html>
