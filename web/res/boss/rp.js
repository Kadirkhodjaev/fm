/*
 * Выбор периода по календарю для модуля «Руководство и учредители».
 * Пресеты, два месяца, ручной ввод дат дд.мм.гггг.
 * Без зависимостей. Держите файл отдельным .js: внутри JSP запись ${...} съест EL.
 */
(function (w) {
  'use strict';
  var MN = ['Январь','Февраль','Март','Апрель','Май','Июнь','Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'];
  var MNl = ['январь','февраль','март','апрель','май','июнь','июль','август','сентябрь','октябрь','ноябрь','декабрь'];
  var D = function (y, m, d) { return new Date(y, m, d); };
  var same = function (a, b) { return !!(a && b && a.getTime() === b.getTime()); };
  var addD = function (d, n) { return D(d.getFullYear(), d.getMonth(), d.getDate() + n); };
  var days = function (a, b) { return Math.round((b - a) / 864e5) + 1; };
  var p2 = function (n) { return (n < 10 ? '0' : '') + n; };
  var f = function (d) { return p2(d.getDate()) + '.' + p2(d.getMonth() + 1) + '.' + d.getFullYear(); };
  var parse = function (s) {
    var m = /^(\d{1,2})\.(\d{1,2})\.(\d{4})$/.exec(String(s || '').trim());
    if (!m) return null;
    var d = D(+m[3], +m[2] - 1, +m[1]);
    return d.getMonth() === +m[2] - 1 ? d : null;
  };
  var endOf = function (y, m) { return D(y, m + 1, 0); };

  function label(a, b) {
    if (same(a, b)) return f(a);
    if (a.getDate() === 1 && same(b, endOf(a.getFullYear(), a.getMonth()))) return MNl[a.getMonth()] + ' ' + a.getFullYear();
    if (a.getDate() === 1 && a.getMonth() % 3 === 0 && same(b, endOf(a.getFullYear(), a.getMonth() + 2)))
      return ['I','II','III','IV'][a.getMonth() / 3] + ' квартал ' + a.getFullYear();
    return f(a) + ' – ' + f(b);
  }

  /*
   * Прошлый период для сравнения.
   * Квартал: прошлый квартал (до того же числа, если квартал ещё идёт).
   * Месяц или его часть с 1-го числа: прошлый месяц по те же числа.
   * Неделя с понедельника: прошлая неделя по те же дни.
   * Иначе: столько же дней сразу перед выбранным.
   * Возвращает [from, to] или null, если данных за прошлый период нет (раньше min).
   */
  function prevPeriod(a, b, today, min) {
    var y = a.getFullYear(), mo = a.getMonth(), p;
    var isQuarter = a.getDate() === 1 && mo % 3 === 0 && b > endOf(y, mo) && b <= endOf(y, mo + 2) &&
      (same(b, endOf(y, mo + 2)) || same(b, today));
    if (isQuarter) {
      var bm = b.getMonth() - 3;
      p = [D(y, mo - 3, 1), same(b, endOf(y, mo + 2)) ? endOf(y, mo - 1) : D(y, bm, Math.min(b.getDate(), endOf(y, bm).getDate()))];
    } else if (a.getDate() === 1 && b <= endOf(y, mo)) {
      p = [D(y, mo - 1, 1), same(b, endOf(y, mo)) ? endOf(y, mo - 1) : D(y, mo - 1, Math.min(b.getDate(), endOf(y, mo - 1).getDate()))];
    } else if (a.getDay() === 1 && days(a, b) <= 7) {
      p = [addD(a, -7), addD(b, -7)];
    } else {
      var n = days(a, b);
      p = [addD(a, -n), addD(a, -1)];
    }
    return min && p[0] < min ? null : p;
  }

  function make(root, o) {
    var today = o.today, min = o.min, max = o.max;
    var from = o.from, to = o.to, ta = from, tb = to, preset = o.preset || null;
    var view = D(to.getFullYear(), to.getMonth() - 1, 1);
    var q = D(today.getFullYear(), Math.floor(today.getMonth() / 3) * 3, 1);
    var mon = addD(today, -((today.getDay() + 6) % 7));
    var presets = [
      ['today', 'Сегодня', today, today],
      ['yday', 'Вчера', addD(today, -1), addD(today, -1)],
      ['week', 'Эта неделя', mon, today],
      ['d30', 'Последние 30 дней', addD(today, -29), today],
      ['month', 'Этот месяц', D(today.getFullYear(), today.getMonth(), 1), today],
      ['pmonth', 'Прошлый месяц', D(today.getFullYear(), today.getMonth() - 1, 1), D(today.getFullYear(), today.getMonth(), 0)],
      ['quarter', 'Этот квартал', q, today],
      ['y12', '12 месяцев', D(today.getFullYear() - 1, today.getMonth(), today.getDate() + 1), today]
    ];
    var firstMonth = function () { return D(min.getFullYear(), min.getMonth(), 1); };

    root.innerHTML =
      '<button type="button" class="rp-btn" aria-haspopup="dialog" aria-expanded="false">' +
        '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 10h18M8 3v4M16 3v4"/></svg>' +
        '<span class="rp-l num"></span>' +
        '<svg class="chev" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round"><path d="M6 9l6 6 6-6"/></svg>' +
      '</button>' +
      '<div class="rp-pop" role="dialog" aria-label="Выбор периода" hidden>' +
        '<div class="rp-pre">' + presets.map(function (p) { return '<button type="button" data-k="' + p[0] + '">' + p[1] + '</button>'; }).join('') + '</div>' +
        '<div class="rp-main"><div class="rp-months"></div>' +
          '<div class="rp-foot">' +
            '<input class="rp-a" inputmode="numeric" aria-label="Начало периода" placeholder="дд.мм.гггг"><span>—</span>' +
            '<input class="rp-b" inputmode="numeric" aria-label="Конец периода" placeholder="дд.мм.гггг">' +
            '<span class="grow"></span>' +
            '<button type="button" class="btn-g" data-x="cancel">Отмена</button>' +
            '<button type="button" class="btn-p" data-x="ok">Применить</button>' +
            '<div class="err" hidden></div>' +
          '</div>' +
        '</div>' +
      '</div>';

    var btn = root.querySelector('.rp-btn'), pop = root.querySelector('.rp-pop'), ms = root.querySelector('.rp-months');
    var ia = root.querySelector('.rp-a'), ib = root.querySelector('.rp-b'), err = root.querySelector('.err');

    function month(y, m, first) {
      var d1 = D(y, m, 1), off = (d1.getDay() + 6) % 7, n = endOf(y, m).getDate();
      var canPrev = D(y, m, 0) >= firstMonth(), canNext = D(y, m + 1, 1) <= max;
      var h = '<div class="rp-m"><div class="rp-mh">' +
        '<button type="button" class="rp-nav ' + (first ? '' : 'ghost') + '" data-nav="-1" aria-label="Предыдущий месяц" ' + (canPrev ? '' : 'disabled') + '>‹</button>' +
        '<span>' + MN[d1.getMonth()] + ' ' + d1.getFullYear() + '</span>' +
        '<button type="button" class="rp-nav ' + (first ? 'ghost' : '') + '" data-nav="1" aria-label="Следующий месяц" ' + (canNext ? '' : 'disabled') + '>›</button>' +
        '</div><div class="rp-g">';
      h += ['Пн','Вт','Ср','Чт','Пт','Сб','Вс'].map(function (x) { return '<span class="wd">' + x + '</span>'; }).join('');
      for (var i = 0; i < off; i++) h += '<button type="button" class="rp-d out" tabindex="-1" aria-hidden="true"></button>';
      var b = tb || ta;
      for (var d = 1; d <= n; d++) {
        var x = D(y, m, d), dis = x < min || x > max, c = 'rp-d';
        if (ta && b && x > ta && x < b) c += ' in';
        if (same(x, ta)) c += ' a';
        if (same(x, b)) c += ' b';
        if (same(x, today)) c += ' today';
        h += '<button type="button" class="' + c + '" data-d="' + x.getTime() + '" ' + (dis ? 'disabled' : '') + ' aria-label="' + f(x) + '">' + d + '</button>';
      }
      return h + '</div></div>';
    }
    function fixView() { if (view < firstMonth()) view = firstMonth(); }
    function draw() {
      ms.innerHTML = month(view.getFullYear(), view.getMonth(), true) + month(view.getFullYear(), view.getMonth() + 1, false);
      ia.value = ta ? f(ta) : ''; ib.value = tb ? f(tb) : '';
      var pb = root.querySelectorAll('.rp-pre button');
      for (var i = 0; i < pb.length; i++) pb[i].setAttribute('aria-pressed', String(pb[i].getAttribute('data-k') === preset));
    }
    function setLabel() { root.querySelector('.rp-l').textContent = label(from, to); }
    function showErr(t) { err.textContent = t; err.hidden = false; }
    function open() {
      ta = from; tb = to; view = D(to.getFullYear(), to.getMonth() - 1, 1); fixView();
      err.hidden = true; draw(); pop.hidden = false; btn.setAttribute('aria-expanded', 'true');
    }
    function close() { pop.hidden = true; btn.setAttribute('aria-expanded', 'false'); }
    function apply() {
      if (!ta) { showErr('Выберите начало периода'); return; }
      from = ta; to = tb || ta; close(); setLabel(); o.onChange(from, to);
    }
    btn.onclick = function () { if (pop.hidden) open(); else close(); };
    pop.addEventListener('click', function (e) {
      var t = e.target;
      var nav = t.closest('[data-nav]');
      if (nav && !nav.disabled) { view = D(view.getFullYear(), view.getMonth() + (+nav.getAttribute('data-nav')), 1); draw(); return; }
      var dd = t.closest('[data-d]');
      if (dd && !dd.disabled) {
        var x = new Date(+dd.getAttribute('data-d')); preset = null;
        if (!ta || tb) { ta = x; tb = null; } else if (x < ta) { ta = x; } else { tb = x; }
        err.hidden = true; draw(); return;
      }
      var p = t.closest('[data-k]');
      if (p) {
        var pr = presets.filter(function (z) { return z[0] === p.getAttribute('data-k'); })[0];
        preset = pr[0]; ta = pr[2] < min ? min : pr[2]; tb = pr[3] > max ? max : pr[3];
        view = D(tb.getFullYear(), tb.getMonth() - 1, 1); fixView(); draw(); return;
      }
      var xb = t.closest('[data-x]');
      if (xb) { if (xb.getAttribute('data-x') === 'ok') apply(); else close(); }
    });
    function typed() {
      var a = parse(ia.value), b = parse(ib.value);
      if (!a || (ib.value.trim() && !b)) { showErr('Введите даты в формате дд.мм.гггг, например 01.09.2026'); return; }
      if (a < min || (b || a) > max) { showErr('Данные есть с ' + f(min) + ' по ' + f(max)); return; }
      if (b && b < a) { showErr('Конец периода раньше начала'); return; }
      err.hidden = true; ta = a; tb = b; preset = null;
      view = D((b || a).getFullYear(), (b || a).getMonth() - 1, 1); fixView(); draw();
    }
    ia.onchange = typed; ib.onchange = typed;
    [ia, ib].forEach(function (i) { i.onkeydown = function (e) { if (e.key === 'Enter') { typed(); if (err.hidden) apply(); } }; });
    // Страница может быть перезагружена в #mainWindow, поэтому слушатели проверяют, что календарь ещё в документе
    function outside(e) { if (!document.contains(root)) { document.removeEventListener('mousedown', outside); return; } if (!pop.hidden && !root.contains(e.target)) close(); }
    function esc(e) { if (!document.contains(root)) { document.removeEventListener('keydown', esc); return; } if (e.key === 'Escape' && !pop.hidden) { close(); btn.focus(); } }
    document.addEventListener('mousedown', outside);
    document.addEventListener('keydown', esc);
    setLabel();
    return { get: function () { return [from, to]; } };
  }

  w.FmsRukPicker = { make: make, label: label, prevPeriod: prevPeriod, parse: parse, format: f, days: days, addD: addD };
})(window);
