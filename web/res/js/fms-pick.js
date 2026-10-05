/*
 * Поле выбора со списком подсказок (замена выпадающим спискам chosen).
 *
 *   var pick = fmsPick(inputElement, {
 *     items: [{id: 1, name: 'Кетанов', hint: 'ампула'}, ...],   // hint - необязательная подпись справа
 *     onPick: function (item) { ... },                          // выбрали элемент
 *     onClear: function () { ... },                             // текст изменили вручную - выбор сброшен
 *     max: 60                                                   // максимум подсказок
 *   });
 *   pick.setItems(list); pick.set(item); pick.clear(); pick.get();
 *
 * Ввод нескольких слов ищет их в любом порядке, найденное подсвечивается.
 * Управление: стрелки, Enter - выбрать, Esc/Tab - закрыть. Список не обрезается таблицами (position: fixed).
 * Нужен jQuery. Стили вшиты.
 */
(function ($) {
  if (window.fmsPick) return;

  var css = [
    '.fp-list{position:fixed;z-index:5000;max-height:280px;overflow-y:auto;background:#fff;border:1px solid #E6E8EC;border-radius:10px;',
    'box-shadow:0 12px 28px rgba(20,25,40,.16);display:none;font-family:Inter,-apple-system,"Segoe UI",Roboto,Arial,sans-serif}',
    '.fp-list.open{display:block}',
    '.fp-item{display:flex;justify-content:space-between;gap:14px;padding:7px 12px;cursor:pointer;font-size:13.5px;border-bottom:1px solid #F5F6F8;color:#1F2430}',
    '.fp-item:last-child{border-bottom:0}',
    '.fp-item.act{background:#FDECEE}',
    '.fp-item .h{color:#6B7280;font-size:12px;white-space:nowrap;align-self:center}',
    '.fp-item mark{background:transparent;color:#D7182E;font-weight:700;padding:0}',
    '.fp-none{padding:10px 12px;color:#6B7280;font-size:13px}',
    'input.fp-bad{border-color:#D7182E !important}'
  ].join('');
  $('<style/>').text(css).appendTo('head');

  function esc(s) { return $('<div/>').text(s == null ? '' : s).html(); }
  function mark(name, q) {
    var low = name.toLowerCase(), ranges = [];
    $.each($.trim(q).toLowerCase().split(/\s+/), function (i, w) {
      if (!w) return;
      var p = low.indexOf(w);
      while (p > -1) { ranges.push([p, p + w.length]); p = low.indexOf(w, p + w.length); }
    });
    ranges.sort(function (a, b) { return a[0] - b[0]; });
    var out = '', pos = 0;
    $.each(ranges, function (i, r) {
      if (r[1] <= pos) return;
      var s = Math.max(r[0], pos);
      out += esc(name.substring(pos, s)) + '<mark>' + esc(name.substring(s, r[1])) + '</mark>';
      pos = r[1];
    });
    return out + esc(name.substring(pos));
  }
  function list() {
    var l = $('#fp-list');
    if (!l.length) l = $('<div id="fp-list" class="fp-list"></div>').appendTo('body');
    return l;
  }

  var current = null;   // открытый в данный момент список: {inst, shown, i}

  function closeList() { $('#fp-list').removeClass('open'); current = null; }

  window.fmsPick = function (input, opts) {
    var $in = $(input), items = opts.items || [], max = opts.max || 60, selected = null;
    if ($in.data('fmsPick')) return $in.data('fmsPick');
    $in.attr('autocomplete', 'off');

    function matches(q) {
      q = $.trim(q).toLowerCase();
      if (!q) return items.slice(0, max);
      var words = q.split(/\s+/), res = [];
      for (var i = 0; i < items.length; i++) {
        var n = items[i].name.toLowerCase(), ok = true;
        for (var w = 0; w < words.length; w++) { if (n.indexOf(words[w]) === -1) { ok = false; break; } }
        if (ok) res.push({d: items[i], s: n.indexOf(words[0]) === 0 ? 0 : 1});
      }
      res.sort(function (a, b) { return a.s - b.s; });
      return res.slice(0, max).map(function (x) { return x.d; });
    }
    function render() {
      var q = $in.val(), shown = matches(q), l = list();
      current = {inst: inst, shown: shown, i: shown.length ? 0 : -1};
      l.empty();
      if (!shown.length) l.append('<div class="fp-none">\u041d\u0438\u0447\u0435\u0433\u043e \u043d\u0435 \u043d\u0430\u0439\u0434\u0435\u043d\u043e</div>');
      $.each(shown, function (i, d) {
        l.append($('<div class="fp-item"></div>').toggleClass('act', i === 0).attr('data-i', i)
          .html('<span>' + mark(d.name, q) + '</span>' + (d.hint ? '<span class="h">' + esc(d.hint) + '</span>' : '')));
      });
      var r = $in[0].getBoundingClientRect();
      l.addClass('open').css({left: r.left, width: Math.max(r.width, 360)});
      var h = l.outerHeight();
      l.css({top: (r.bottom + h + 8 > window.innerHeight && r.top > h + 8) ? r.top - h - 2 : r.bottom + 2});
    }
    function move(step) {
      if (!current || !current.shown.length) return;
      current.i = (current.i + step + current.shown.length) % current.shown.length;
      var l = list();
      l.find('.fp-item').removeClass('act').eq(current.i).addClass('act');
      var el = l.find('.fp-item').eq(current.i)[0];
      if (el && el.scrollIntoView) el.scrollIntoView({block: 'nearest'});
    }
    function pick(d) {
      selected = d;
      $in.val(d.name).removeClass('fp-bad');
      closeList();
      if (opts.onPick) opts.onPick(d);
    }
    var inst = {
      setItems: function (list2) { items = list2 || []; },
      addItem: function (d) { items.push(d); },
      set: function (d) { selected = d; $in.val(d ? d.name : ''); },
      clear: function () { selected = null; $in.val('').removeClass('fp-bad'); },
      get: function () { return selected; },
      _pick: pick
    };
    $in.on('focus click', render)
      .on('input', function () {
        if (selected) { selected = null; if (opts.onClear) opts.onClear(); }
        render();
      })
      .on('keydown', function (e) {
        if (e.which === 40) { e.preventDefault(); if (!current) render(); else move(1); }
        else if (e.which === 38) { e.preventDefault(); move(-1); }
        else if (e.which === 13) {
          if (current && current.i > -1) { e.preventDefault(); pick(current.shown[current.i]); }
        } else if (e.which === 27 || e.which === 9) closeList();
      })
      .on('focusout', function () {
        var v = $.trim($in.val()).toLowerCase();
        if (selected || !v) return;
        for (var i = 0; i < items.length; i++) {
          if (items[i].name.toLowerCase() === v) { pick(items[i]); return; }
        }
      });
    $in.data('fmsPick', inst);
    return inst;
  };

  $(document)
    .on('mousedown', '.fp-item', function (e) {
      e.preventDefault();
      if (current) current.inst._pick(current.shown[$(this).data('i')]);
    })
    .on('mousedown', function (e) {
      if (current && !$(e.target).closest('#fp-list').length && !$(e.target).is('input')) closeList();
    });
  $(window).on('resize scroll', function () { closeList(); });
})(jQuery);
