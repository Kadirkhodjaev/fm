<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  .roles-page { --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
                padding:28px 32px 40px; font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:var(--text); }
  .roles-page * { box-sizing:border-box; }
  .rp-box { max-width:1280px; margin:0 auto; }
  .rp-head { display:flex; align-items:flex-end; gap:16px; flex-wrap:wrap; margin-bottom:18px; }
  .rp-head .t { flex:1; min-width:220px; }
  .rp-head h1 { margin:0 0 4px; font-size:22px; font-weight:700; }
  .rp-head p  { margin:0; font-size:14px; color:var(--muted); }

  .rp-search { position:relative; width:320px; max-width:100%; }
  .rp-search i { position:absolute; left:14px; top:50%; transform:translateY(-50%); color:#9AA1AC; font-size:14px; }
  .rp-search input { width:100%; height:44px; padding:0 14px 0 38px; border:1px solid var(--border); border-radius:10px; background:#fff;
                     font-size:15px; font-family:inherit; color:var(--text); outline:none; transition:border-color .15s, box-shadow .15s; }
  .rp-search input:focus { border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }

  .rp-list { display:grid; grid-template-columns:repeat(auto-fill, minmax(260px, 1fr)); gap:12px; }

  /* Цвет иконки берётся из старого r.color (panel-primary / panel-green / …); по умолчанию — нейтральный */
  .rp-item              { --acc:#4B5563; --acc-soft:#F1F2F4; }
  .rp-item[data-color*="primary"] { --acc:#2563EB; --acc-soft:#EAF1FE; }
  .rp-item[data-color*="info"]    { --acc:#0891B2; --acc-soft:#E6F6FA; }
  .rp-item[data-color*="green"],
  .rp-item[data-color*="success"] { --acc:#16A34A; --acc-soft:#E8F7EE; }
  .rp-item[data-color*="yellow"],
  .rp-item[data-color*="warning"] { --acc:#D97706; --acc-soft:#FEF3E2; }
  .rp-item[data-color*="red"],
  .rp-item[data-color*="danger"]  { --acc:#D7182E; --acc-soft:#FDECEE; }

  .rp-item { display:flex; align-items:center; gap:14px; padding:14px 16px; background:#fff; border:1px solid var(--border); border-radius:12px;
             color:var(--text); text-decoration:none !important; cursor:pointer; outline:none; transition:background .1s; }
  .rp-item:hover { border-color:#C9CDD4; color:var(--text); }
  .rp-item.cur { border-color:#4B5563; box-shadow:0 0 0 1px #4B5563, 0 6px 16px rgba(20,25,40,.06); color:var(--text); }
  .rp-item .ic { flex:none; width:40px; height:40px; border-radius:10px; display:flex; align-items:center; justify-content:center;
                 background:var(--acc-soft); color:var(--acc); font-size:18px; }
  .rp-item .nm { flex:1; min-width:0; font-size:15px; font-weight:600; line-height:1.3; }
  .rp-item .last { display:none; margin-top:3px; padding:2px 8px; border-radius:10px; background:#F1F2F4; color:var(--muted);
                   font-size:11.5px; font-weight:600; vertical-align:middle; }
  .rp-item.was .last { display:table; }
  .rp-item kbd { flex:none; min-width:24px; height:24px; padding:0 6px; border:1px solid var(--border); border-bottom-width:2px; border-radius:6px;
                 background:#fff; color:var(--muted); font-size:12px; font-weight:600; line-height:20px; font-family:inherit; text-align:center; box-shadow:none; }
  .rp-item .go { flex:none; color:#C3C7CE; font-size:13px; }
  .rp-item:hover .go, .rp-item.cur .go { color:var(--text); }
  .rp-item.hid { display:none; }
  .rp-none { display:none; padding:28px 16px; text-align:center; color:var(--muted); font-size:14px; }
  .rp-none { grid-column:1 / -1; }
  .rp-list.empty .rp-none { display:block; }
  .rp-hint { margin-top:14px; font-size:12.5px; color:#9AA1AC; text-align:center; }
</style>

<div class="roles-page">
  <div class="rp-box">
    <div class="rp-head">
      <div class="t">
        <h1>Выберите роль</h1>
        <p>В какой роли вы будете работать сейчас</p>
      </div>
      <div class="rp-search">
        <i class="fa fa-search"></i>
        <input type="text" id="rpSearch" placeholder="Найти роль" autocomplete="off">
      </div>
    </div>

    <div class="rp-list" id="rpList">
      <c:forEach items="${roles}" var="r" varStatus="st">
        <a href="#" class="rp-item" data-id="${r.id}" data-color="${r.color}" title="${r.name}"
           onclick="return rpGo(this);">
          <span class="ic"><i class="${r.icon}"></i></span>
          <span class="nm">${r.name}<span class="last">Последняя</span></span>
          <c:if test="${st.count <= 9}"><kbd>${st.count}</kbd></c:if>
          <i class="fa fa-chevron-right go"></i>
        </a>
      </c:forEach>
      <div class="rp-none">Роль не найдена</div>
    </div>
    <div class="rp-hint">Стрелки — выбрать, Enter — войти, 1–9 — сразу в роль</div>
  </div>
</div>

<script>
  function rpGo(a) {
    try { localStorage.setItem('fms.lastRole', a.getAttribute('data-id')); } catch (e) {}
    setLocation('/setRole.s?id=' + a.getAttribute('data-id'));
    return false;
  }

  (function () {
    var list = document.getElementById('rpList'), inp = document.getElementById('rpSearch');
    if (!list || !inp) return;
    var items = [].slice.call(list.querySelectorAll('.rp-item'));
    var cur = null;

    function visible() { return items.filter(function (a) { return !a.classList.contains('hid'); }); }
    function setCur(a) {
      if (cur) cur.classList.remove('cur');
      cur = a || null;
      if (cur) { cur.classList.add('cur'); if (cur.scrollIntoView) cur.scrollIntoView({ block: 'nearest' }); }
    }

    // Последняя роль: отмечаем и ставим курсор на неё
    var last = null;
    try { last = localStorage.getItem('fms.lastRole'); } catch (e) {}
    var lastItem = items.filter(function (a) { return a.getAttribute('data-id') === last; })[0];
    if (lastItem) lastItem.classList.add('was');
    setCur(lastItem || items[0]);

    // Если роль одна или ролей мало, поиск не нужен
    if (items.length <= 6) inp.parentNode.style.display = 'none';
    else inp.focus();

    inp.addEventListener('input', function () {
      var q = inp.value.trim().toLowerCase();
      items.forEach(function (a) { a.classList.toggle('hid', !!q && a.textContent.toLowerCase().indexOf(q) < 0); });
      var v = visible();
      list.classList.toggle('empty', !v.length);
      setCur(v[0]);
    });

    // Сколько плиток в ряду — по первой строке сетки
    function cols0(v) {
      if (!v.length) return 1;
      var top = v[0].offsetTop, n = 0;
      while (n < v.length && v[n].offsetTop === top) n++;
      return n || 1;
    }

    items.forEach(function (a) { a.addEventListener('mouseenter', function () { setCur(a); }); });

    document.addEventListener('keydown', function onKey(e) {
      if (!document.body.contains(list)) { document.removeEventListener('keydown', onKey); return; }
      var v = visible(), i = v.indexOf(cur);
      var cols = cols0(v), step = { ArrowRight: 1, ArrowLeft: -1, ArrowDown: cols, ArrowUp: -cols }[e.key];
      if (step && (e.key.indexOf('Arrow') === 0) && !(document.activeElement === inp && inp.value && (step === 1 || step === -1))) {
        var j = i + step; if (j >= 0 && j < v.length) setCur(v[j]); e.preventDefault();
      }
      else if (e.key === 'Enter' && cur) { rpGo(cur); e.preventDefault(); }
      else if (/^[1-9]$/.test(e.key) && !inp.value && !e.ctrlKey && !e.altKey && !e.metaKey) {
        var a = items[+e.key - 1]; if (a) { rpGo(a); e.preventDefault(); }
      }
    });
  })();
</script>
