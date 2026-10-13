/*
 * Searchable drop-down in the new style (replaces the old "chosen" plugin on new-style pages).
 *   <select class="form-control fms-select" name="..." id="...">...</select>
 *   FmsSelect.attach(selectElement) / FmsSelect.attachAll(root)  - attachAll runs on load by itself
 * The original <select> stays in the form (hidden) and keeps the value; on pick it gets the value
 * and a "change" event, so existing onchange handlers and form serialize() keep working.
 * Option text "Name (details)" is shown as the name with the details in grey.
 * Only the first 300 matches are drawn, so lists with thousands of options stay fast.
 * Pure ASCII: Tomcat serves .js without a charset.
 */
(function (window, document) {
  'use strict';
  if (window.FmsSelect) { window.FmsSelect.attachAll(); return; }
  var T = {
    search: '\u041f\u043e\u0438\u0441\u043a\u2026',                                   // Poisk...
    none: '\u041d\u0438\u0447\u0435\u0433\u043e \u043d\u0435 \u043d\u0430\u0439\u0434\u0435\u043d\u043e', // Nichego ne naideno
    more: '\u0423\u0442\u043e\u0447\u043d\u0438\u0442\u0435 \u043f\u043e\u0438\u0441\u043a: \u043f\u043e\u043a\u0430\u0437\u0430\u043d\u044b \u043f\u0435\u0440\u0432\u044b\u0435 ' // Utochnite poisk: pokazany pervye
  };
  var LIMIT = 300;
  var open = null, all = [];
  // keeps the field text in sync with the hidden select; drops fields that left the page
  setInterval(function () {
    for (var i = all.length - 1; i >= 0; i--) if (!all[i].sync()) all.splice(i, 1);
  }, 250);
  // styles travel with the script: pages in the old style do not load the new styles
  if (!document.getElementById('fms-sel-css')) {
    var st = document.createElement('style');
    st.id = 'fms-sel-css';
    st.appendChild(document.createTextNode('.fms-sel { position: relative; width: 100%; font-family: Inter, -apple-system, "Segoe UI", Roboto, Arial, sans-serif; } .fms-sel-btn { width: 100%; min-height: 32px; display: flex; align-items: center; gap: 8px; padding: 4px 30px 4px 10px; position: relative; border: 1px solid #E6E8EC; border-radius: 9px; background: #fff; color: #1F2430; font-size: 13px; text-align: left; cursor: pointer; } .fms-sel-btn:hover { border-color: #C9CDD9; } .fms-sel-btn:focus { outline: none; border-color: #4B5563; box-shadow: 0 0 0 3px rgba(75, 85, 99, .14); } .fms-sel-btn:disabled { background: #F5F6F8; color: #6B7280; cursor: default; } .fms-sel-btn .t { flex: 0 1 auto; min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; font-weight: 600; } .fms-sel-btn .d { flex: 1 1 auto; min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; font-size: 12px; color: #6B7280; } .fms-sel-btn.ph .t { font-weight: 400; color: #9AA1AC; } .fms-sel-btn .fa { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); color: #9AA1AC; font-size: 16px; transition: transform .15s; } .fms-sel.on .fms-sel-btn { border-color: #4B5563; box-shadow: 0 0 0 3px rgba(75, 85, 99, .14); } .fms-sel.on .fms-sel-btn .fa { transform: translateY(-50%) rotate(180deg); } .fms-sel-drop { font-family: Inter, -apple-system, "Segoe UI", Roboto, Arial, sans-serif; display: none; position: absolute; left: 0; right: 0; top: calc(100% + 6px); z-index: 1050; min-width: 280px; background: #fff; border: 1px solid #E6E8EC; border-radius: 12px; box-shadow: 0 16px 40px rgba(20, 25, 40, .18); overflow: hidden; } .fms-sel.up .fms-sel-drop { top: auto; bottom: calc(100% + 6px); } .fms-sel.on .fms-sel-drop { display: block; } .fms-sel-q { padding: 8px; border-bottom: 1px solid #EEF0F4; } .fms-sel-q input { width: 100%; height: 34px; padding: 0 10px; border: 1px solid #E6E8EC; border-radius: 8px; background: #F5F6F8; font-size: 14px; color: #1F2430; } .fms-sel-q input:focus { outline: none; background: #fff; border-color: #4B5563; } .fms-sel-list { max-height: 300px; overflow-y: auto; padding: 4px; } .fms-sel-list .it { display: flex; flex-direction: column; gap: 1px; padding: 7px 10px; border-radius: 8px; cursor: pointer; } .fms-sel-list .it .t { font-size: 13px; color: #1F2430; } .fms-sel-list .it .d { font-size: 12px; color: #6B7280; } .fms-sel-list .it.cur { background: #F1F2F4; } .fms-sel-list .it.sel .t { font-weight: 700; color: #1F2430; } .fms-sel-list .it.off { opacity: .45; cursor: default; } .fms-sel-list .none { padding: 10px; font-size: 13px; color: #6B7280; text-align: center; } '));
    (document.head || document.documentElement).appendChild(st);
  }

  function esc(s) { return String(s).replace(/[&<>"]/g, function (c) { return {'&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;'}[c]; }); }
  function split(text) {
    var i = text.lastIndexOf(' (');
    return i > 0 && text.charAt(text.length - 1) === ')' ? [text.slice(0, i), text.slice(i + 2, -1)] : [text, ''];
  }

  function attach(sel) {
    if (!sel || sel.fmsSelect || sel.tagName !== 'SELECT') return;
    var wrap = document.createElement('div');
    wrap.className = 'fms-sel';
    var btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'fms-sel-btn';
    btn.setAttribute('aria-haspopup', 'listbox');
    if (sel.id) btn.setAttribute('aria-labelledby', sel.id);
    var drop = document.createElement('div');
    drop.className = 'fms-sel-drop';
    drop.innerHTML = '<div class="fms-sel-q"><input type="text" autocomplete="off" placeholder="' + T.search + '"></div><div class="fms-sel-list" role="listbox"></div>';
    var input = drop.firstChild.firstChild, list = drop.lastChild;
    sel.parentNode.insertBefore(wrap, sel);
    wrap.appendChild(sel);
    wrap.appendChild(btn);
    wrap.appendChild(drop);
    // an inline width of the select (old pages: style="width:300px") goes to the new field
    if (sel.style.width) wrap.style.width = sel.style.width;
    else {
      var wm = /(^|\s)wpx-(\d+)(\s|$)/.exec(sel.className);
      if (wm) wrap.style.width = wm[2] + 'px';
    }
    sel.style.display = 'none';
    sel.fmsSelect = true;

    var items = [], view = [], cur = -1, seen = '';
    function load() {
      items = [];
      for (var i = 0; i < sel.options.length; i++) {
        var o = sel.options[i], t = (o.text || '').replace(/\s+/g, ' ').trim();
        items.push({i: i, v: o.value, t: t, low: t.toLowerCase(), p: split(t), off: o.disabled});
      }
    }
    function label() {
      var o = sel.options[sel.selectedIndex];
      var t = o ? (o.text || '').replace(/\s+/g, ' ').trim() : '';
      var p = split(t);
      btn.innerHTML = '<span class="t">' + esc(p[0] || '\u00a0') + '</span>' + (p[1] ? '<span class="d">' + esc(p[1]) + '</span>' : '') + '<i class="fa fa-angle-down"></i>';
      btn.classList.toggle('ph', !o || o.value === '' || o.value === '0');
      btn.disabled = sel.disabled;
      seen = sel.selectedIndex + '|' + sel.options.length + '|' + (o ? o.text : '') + '|' + sel.disabled;
    }
    function render() {
      var q = input.value.trim().toLowerCase(), words = q ? q.split(' ') : [], h = '', n = 0;
      view = [];
      for (var k = 0; k < items.length; k++) {
        var it = items[k], ok = true;
        for (var w = 0; w < words.length && ok; w++) if (it.low.indexOf(words[w]) === -1) ok = false;
        if (!ok) continue;
        n++;
        if (view.length >= LIMIT) continue;
        view.push(it);
        h += '<div class="it' + (it.i === sel.selectedIndex ? ' sel' : '') + (it.off ? ' off' : '') + '" role="option" data-k="' + (view.length - 1) + '">' +
          '<span class="t">' + esc(it.p[0] || '\u00a0') + '</span>' + (it.p[1] ? '<span class="d">' + esc(it.p[1]) + '</span>' : '') + '</div>';
      }
      if (!n) h = '<div class="none">' + T.none + '</div>';
      else if (n > view.length) h += '<div class="none">' + T.more + view.length + ' \u0438\u0437 ' + n + '</div>';
      list.innerHTML = h;
      cur = -1;
      for (var j = 0; j < view.length; j++) if (view[j].i === sel.selectedIndex) { cur = j; break; }
      mark(true);
    }
    function mark(scroll) {
      var els = list.querySelectorAll('.it');
      for (var i = 0; i < els.length; i++) els[i].classList.toggle('cur', i === cur);
      if (scroll && cur >= 0 && els[cur]) {
        var e = els[cur], top = e.offsetTop, bottom = top + e.offsetHeight;
        if (top < list.scrollTop) list.scrollTop = top;
        else if (bottom > list.scrollTop + list.clientHeight) list.scrollTop = bottom - list.clientHeight;
      }
    }
    function pick(k) {
      var it = view[k];
      if (!it || it.off) return;
      var changed = sel.selectedIndex !== it.i;
      sel.selectedIndex = it.i;
      label();
      close();
      btn.focus();
      if (changed) {
        if (window.jQuery) window.jQuery(sel).trigger('change');
        else sel.dispatchEvent(new Event('change', {bubbles: true}));
      }
    }
    function show() {
      if (sel.disabled) return;
      if (open && open !== api) open.close();
      load();
      input.value = '';
      wrap.classList.add('on');
      // open upwards when there is no room below
      var r = wrap.getBoundingClientRect();
      var up = window.innerHeight - r.bottom < 300 && r.top > window.innerHeight - r.bottom;
      wrap.classList.toggle('up', up);
      // the list is fixed to the window, so tables and cards with overflow:hidden do not cut it off
      // into the body (or the bootstrap modal itself: its focus trap would steal focus from the search box)
      ((wrap.closest && wrap.closest('.modal')) || document.body).appendChild(drop);
      drop.style.display = 'block';
      drop.style.zIndex = '2100';
      drop.style.position = 'fixed';
      drop.style.left = r.left + 'px';
      drop.style.width = Math.max(r.width, 280) + 'px';
      drop.style.right = 'auto';
      drop.style.top = up ? 'auto' : (r.bottom + 6) + 'px';
      drop.style.bottom = up ? (window.innerHeight - r.top + 6) + 'px' : 'auto';
      render();
      open = api;
      setTimeout(function () { input.focus(); }, 0);
    }
    function close() {
      wrap.classList.remove('on');
      drop.style.display = '';
      if (drop.parentNode !== wrap) wrap.appendChild(drop);
      if (open === api) open = null;
    }

    btn.addEventListener('click', function () { wrap.classList.contains('on') ? close() : show(); });
    btn.addEventListener('keydown', function (e) {
      if (e.keyCode === 40 || e.keyCode === 13 || e.keyCode === 32) { e.preventDefault(); show(); }
      else if (e.key && e.key.length === 1 && !e.ctrlKey && !e.altKey) { show(); input.value = e.key; render(); e.preventDefault(); }
    });
    input.addEventListener('input', render);
    input.addEventListener('keydown', function (e) {
      if (e.keyCode === 40) { cur = Math.min(view.length - 1, cur + 1); mark(true); e.preventDefault(); }
      else if (e.keyCode === 38) { cur = Math.max(0, cur - 1); mark(true); e.preventDefault(); }
      else if (e.keyCode === 13) { e.preventDefault(); pick(cur < 0 ? 0 : cur); }
      else if (e.keyCode === 27) { e.preventDefault(); close(); btn.focus(); }
      else if (e.keyCode === 9) close();
    });
    list.addEventListener('mousedown', function (e) {
      var it = e.target.closest ? e.target.closest('.it') : null;
      if (it) { e.preventDefault(); pick(+it.getAttribute('data-k')); }
    });
    list.addEventListener('mousemove', function (e) {
      var it = e.target.closest ? e.target.closest('.it') : null;
      if (it) { var k = +it.getAttribute('data-k'); if (k !== cur) { cur = k; mark(false); } }
    });
    // value set from code (sel.value = ...; $(sel).trigger('change')) keeps the button text in sync
    sel.addEventListener('change', label);
    // old pages refresh chosen after changing options or value: keep the button text in sync
    if (window.jQuery) window.jQuery(sel).on('liszt:updated chosen:updated', function () { load(); label(); });

    var api = {close: close, refresh: function () { load(); label(); },
      // value, options or disabled changed from code without a change event (form.reset(), sel.value = ...)
      sync: function () {
        var o = sel.options[sel.selectedIndex];
        if (sel.selectedIndex + '|' + sel.options.length + '|' + (o ? o.text : '') + '|' + sel.disabled !== seen) label();
        return document.documentElement.contains(sel);
      }};
    sel.fmsSelectApi = api;
    all.push(api);
    label();
  }

  function attachAll(root) {
    var els = (root || document).querySelectorAll('select.fms-select');
    for (var i = 0; i < els.length; i++) attach(els[i]);
  }
  document.addEventListener('mousedown', function (e) {
    if (open && !(e.target.closest && e.target.closest('.fms-sel.on, .fms-sel-drop'))) open.close();
  });

  // the open list is fixed to the window: scrolling the page or resizing closes it
  window.addEventListener('scroll', function (e) {
    if (open && !(e.target && e.target.closest && e.target.closest('.fms-sel-drop'))) open.close();
  }, true);
  window.addEventListener('resize', function () { if (open) open.close(); });

  window.FmsSelect = {attach: attach, attachAll: attachAll};
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', function () { attachAll(); });
  else attachAll();
})(window, document);

/*
 * Old "chosen" drop-downs (class chzn-select / chosen-select) on every page get the searchable field above.
 * Pages are loaded into #mainWindow by ajax, so new content is watched with a MutationObserver.
 * Multiple selects and selects with class no-search stay as they are.
 */
(function (window, document) {
  'use strict';
  if (!window.FmsSelect || window.FmsSelect.upgrade) return;
  function upgrade(root) {
    if (!root) return;
    var sels = root.querySelectorAll('select.chzn-select, select.chosen-select, select.fms-select, .fm-skin select, .fm-admin select, .hn-page select');
    for (var i = 0; i < sels.length; i++) {
      var sel = sels[i];
      if (sel.fmsSelect || sel.multiple || sel.classList.contains('no-search') || !sel.parentNode) continue;
      // chosen draws its own box right after the select (and hides the select): remove it, the new field replaces it
      var nx = sel.nextElementSibling, chosen = nx && /(^|\s)(chzn-container|chosen-container)(\s|$)/.test(nx.className);
      // a select the page itself keeps hidden stays as it is
      if (sel.style.display === 'none' && !chosen) continue;
      if (chosen) nx.parentNode.removeChild(nx);
      window.FmsSelect.attach(sel);
    }
    // chosen applied after the upgrade (in a ready handler): drop its box again
    var boxes = root.querySelectorAll('.fms-sel > .chzn-container, .fms-sel > .chosen-container');
    for (var j = 0; j < boxes.length; j++) boxes[j].parentNode.removeChild(boxes[j]);
  }
  window.FmsSelect.upgrade = upgrade;
  var timer = null;
  function schedule() {
    if (timer) return;
    timer = setTimeout(function () { timer = null; upgrade(document.body); }, 30);
  }
  function start() {
    if (window.MutationObserver) {
      new MutationObserver(function (list) {
        for (var i = 0; i < list.length; i++) if (list[i].addedNodes.length) { schedule(); return; }
      }).observe(document.body, {childList: true, subtree: true});
    }
    schedule();
  }
  if (document.body) start(); else document.addEventListener('DOMContentLoaded', start);
})(window, document);
