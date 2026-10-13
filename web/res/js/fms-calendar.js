/*
 * Новый календарь MedOnline для полей <input class="fms-cal">.
 * Подключается постранично (не через main.jsp), чтобы не пересекаться со старым datepicker:
 *   <script src="/res/js/fms-calendar.js"></script>
 * Поля со старым классом datepicker тоже обслуживаются этим календарём (старый datetimepicker_css.js теперь только подключает этот файл).
 * Свой выпадающий календарь в стиле системы (вместо встроенного в браузер):
 * русские месяцы, неделя с понедельника, быстрый выбор месяца и года, «Сегодня» и «Очистить».
 * Дату пишет в формате дд.мм.гггг (или гггг-мм-дд, если поле уже было в таком формате / задан data-format="iso"),
 * после выбора вызывает событие change. С клавиатуры дату по-прежнему можно ввести вручную.
 * Работает и на страницах, подгружаемых через setPage(): обработчики висят на document.
 * Нужен jQuery. Повторное подключение (страница перезагрузилась через setPage) безопасно.
 */
(function ($) {
  if (window.__fmsCalendar) return;
  window.__fmsCalendar = true;

  var MONTHS = ['\u042f\u043d\u0432\u0430\u0440\u044c', '\u0424\u0435\u0432\u0440\u0430\u043b\u044c', '\u041c\u0430\u0440\u0442', '\u0410\u043f\u0440\u0435\u043b\u044c', '\u041c\u0430\u0439', '\u0418\u044e\u043d\u044c', '\u0418\u044e\u043b\u044c', '\u0410\u0432\u0433\u0443\u0441\u0442', '\u0421\u0435\u043d\u0442\u044f\u0431\u0440\u044c', '\u041e\u043a\u0442\u044f\u0431\u0440\u044c', '\u041d\u043e\u044f\u0431\u0440\u044c', '\u0414\u0435\u043a\u0430\u0431\u0440\u044c'];
  var DAYS = ['\u041f\u043d', '\u0412\u0442', '\u0421\u0440', '\u0427\u0442', '\u041f\u0442', '\u0421\u0431', '\u0412\u0441'];

  var css = document.createElement('style');
  css.textContent = [
    // иконка календаря в поле
    // ширина не меньше 140px: дата дд.мм.гггг всегда видна целиком, даже если странице задана узкая ширина поля
    'input.fms-cal,input.datepicker{text-align:left !important;padding-left:12px !important;padding-right:34px !important;min-width:140px !important;box-sizing:border-box;background-repeat:no-repeat;background-position:right 10px center;',
    'background-image:url("data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'16\' height=\'16\' viewBox=\'0 0 24 24\' fill=\'none\' stroke=\'%239AA1AC\' stroke-width=\'2\' stroke-linecap=\'round\' stroke-linejoin=\'round\'%3E%3Crect x=\'3\' y=\'4\' width=\'18\' height=\'18\' rx=\'2\'/%3E%3Cpath d=\'M16 2v4M8 2v4M3 10h18\'/%3E%3C/svg%3E")}',
    // окно календаря
    '.fms-dp{position:fixed;z-index:3000;width:272px;padding:12px;background:#fff;border:1px solid #E6E8EC;border-radius:14px;',
    'box-shadow:0 12px 32px rgba(20,25,40,.14);font-family:Inter,-apple-system,"Segoe UI",Roboto,Arial,sans-serif;color:#1F2430;font-size:13.5px;',
    'user-select:none;display:none}',
    '.fms-dp.open{display:block}',
    '.fms-dp *{box-sizing:border-box}',
    '.fms-dp-h{display:flex;align-items:center;gap:6px;margin-bottom:8px}',
    '.fms-dp-nav{flex:none;width:30px;height:30px;border:0;border-radius:8px;background:none;color:#6B7280;font-size:18px;line-height:1;cursor:pointer}',
    '.fms-dp-nav:hover{background:#F1F2F4;color:#1F2430}',
    '.fms-dp-sel{flex:1;display:flex;gap:4px;justify-content:center}',
    '.fms-dp select{height:30px;padding:0 4px;border:1px solid transparent;border-radius:8px;background:#fff;font:inherit;font-weight:600;color:#1F2430;cursor:pointer;outline:none}',
    '.fms-dp select:hover,.fms-dp select:focus{border-color:#E6E8EC;background:#F8F9FA}',
    '.fms-dp-w,.fms-dp-g{display:grid;grid-template-columns:repeat(7,1fr);gap:2px}',
    '.fms-dp-w span{height:26px;line-height:26px;text-align:center;font-size:11.5px;font-weight:600;color:#9AA1AC}',
    '.fms-dp-w span:nth-child(n+6){color:#C3C7CE}',
    '.fms-dp-g button{height:34px;border:0;border-radius:8px;background:none;font:inherit;color:#1F2430;cursor:pointer;font-variant-numeric:tabular-nums}',
    '.fms-dp-g button:hover{background:#F1F2F4}',
    '.fms-dp-g button.out{color:#C3C7CE}',
    '.fms-dp-g button.we{color:#9AA1AC}',
    '.fms-dp-g button.today{box-shadow:inset 0 0 0 1.5px #9AA1AC;font-weight:600}',
    '.fms-dp-g button.sel,.fms-dp-g button.sel:hover{background:#1F2430;color:#fff;font-weight:600;box-shadow:none}',
    '.fms-dp-f{display:flex;justify-content:space-between;margin-top:10px;padding-top:10px;border-top:1px solid #F0F1F4}',
    '.fms-dp-f button{height:30px;padding:0 10px;border:0;border-radius:8px;background:none;font:inherit;font-weight:600;color:#4B5563;cursor:pointer}',
    '.fms-dp-f button:hover{background:#F1F2F4;color:#1F2430}'
  ].join('');
  document.head.appendChild(css);

  function pad(n) { return (n < 10 ? '0' : '') + n; }
  function parse(v) {
    var m;
    if ((m = /^\s*(\d{1,2})\.(\d{1,2})\.(\d{4})/.exec(v))) return mk(+m[3], +m[2] - 1, +m[1]);
    if ((m = /^\s*(\d{4})-(\d{2})-(\d{2})/.exec(v))) return mk(+m[1], +m[2] - 1, +m[3]);
    return null;
  }
  function mk(y, mo, d) {
    var dt = new Date(y, mo, d);
    return (dt.getFullYear() === y && dt.getMonth() === mo && dt.getDate() === d) ? dt : null;
  }
  function same(a, b) { return a && b && a.getFullYear() === b.getFullYear() && a.getMonth() === b.getMonth() && a.getDate() === b.getDate(); }

  var box, inp, view, selected, iso;

  function build() {
    box = document.createElement('div');
    box.className = 'fms-dp';
    box.innerHTML =
      '<div class="fms-dp-h">' +
      '<button type="button" class="fms-dp-nav" data-nav="-1" title="\u041f\u0440\u0435\u0434\u044b\u0434\u0443\u0449\u0438\u0439 \u043c\u0435\u0441\u044f\u0446">\u2039</button>' +
      '<div class="fms-dp-sel"><select class="fms-dp-m"></select><select class="fms-dp-y"></select></div>' +
      '<button type="button" class="fms-dp-nav" data-nav="1" title="\u0421\u043b\u0435\u0434\u0443\u044e\u0449\u0438\u0439 \u043c\u0435\u0441\u044f\u0446">\u203a</button>' +
      '</div>' +
      '<div class="fms-dp-w">' + DAYS.map(function (d) { return '<span>' + d + '</span>'; }).join('') + '</div>' +
      '<div class="fms-dp-g"></div>' +
      '<div class="fms-dp-f"><button type="button" data-act="today">\u0421\u0435\u0433\u043e\u0434\u043d\u044f</button><button type="button" data-act="clear">\u041e\u0447\u0438\u0441\u0442\u0438\u0442\u044c</button></div>';
    document.body.appendChild(box);

    var ms = box.querySelector('.fms-dp-m');
    ms.innerHTML = MONTHS.map(function (m, i) { return '<option value="' + i + '">' + m + '</option>'; }).join('');

    // клики внутри окна не должны уводить фокус из поля и закрывать окно
    box.addEventListener('mousedown', function (e) { if (e.target.tagName !== 'SELECT') e.preventDefault(); });
    box.addEventListener('click', function (e) {
      var t = e.target;
      if (t.getAttribute('data-nav')) { view.setMonth(view.getMonth() + (+t.getAttribute('data-nav'))); draw(); }
      else if (t.getAttribute('data-d')) { var p = t.getAttribute('data-d').split('-'); pick(new Date(+p[0], +p[1], +p[2])); }
      else if (t.getAttribute('data-act') === 'today') pick(new Date());
      else if (t.getAttribute('data-act') === 'clear') { inp.value = ''; $(inp).trigger('change'); close(); }
    });
    ms.addEventListener('change', function () { view.setMonth(+ms.value); draw(); });
    box.querySelector('.fms-dp-y').addEventListener('change', function () { view.setFullYear(+this.value); draw(); });
  }

  function draw() {
    var y = view.getFullYear(), mo = view.getMonth(), today = new Date();
    box.querySelector('.fms-dp-m').value = mo;
    var ys = box.querySelector('.fms-dp-y'), cy = today.getFullYear(), from = Math.min(cy - 100, y), to = Math.max(cy + 5, y), h = '';
    for (var i = to; i >= from; i--) h += '<option value="' + i + '"' + (i === y ? ' selected' : '') + '>' + i + '</option>';
    ys.innerHTML = h;

    var first = new Date(y, mo, 1), shift = (first.getDay() + 6) % 7, start = new Date(y, mo, 1 - shift), g = '';
    for (var k = 0; k < 42; k++) {
      var d = new Date(start.getFullYear(), start.getMonth(), start.getDate() + k), wd = (d.getDay() + 6) % 7, cls = [];
      if (d.getMonth() !== mo) cls.push('out'); else if (wd > 4) cls.push('we');
      if (same(d, today)) cls.push('today');
      if (same(d, selected)) cls.push('sel');
      g += '<button type="button" class="' + cls.join(' ') + '" data-d="' + d.getFullYear() + '-' + d.getMonth() + '-' + d.getDate() + '">' + d.getDate() + '</button>';
    }
    box.querySelector('.fms-dp-g').innerHTML = g;
  }

  function place() {
    var r = inp.getBoundingClientRect(), bh = box.offsetHeight, bw = box.offsetWidth;
    var top = r.bottom + 6;
    if (top + bh > window.innerHeight - 8 && r.top - bh - 6 > 8) top = r.top - bh - 6;
    var left = Math.min(r.left, window.innerWidth - bw - 8);
    box.style.top = Math.max(8, top) + 'px';
    box.style.left = Math.max(8, left) + 'px';
  }

  function open(el) {
    // old .datepicker fields could be readonly and were still picked from the calendar
    if ((el.readOnly && !$(el).hasClass('datepicker')) || el.disabled) return;
    if (!box) build();
    inp = el;
    iso = $(el).attr('data-format') == 'iso' || /^\d{4}-\d{2}-\d{2}/.test(el.value);
    selected = parse(el.value);
    view = selected ? new Date(selected.getFullYear(), selected.getMonth(), 1) : new Date(new Date().getFullYear(), new Date().getMonth(), 1);
    draw();
    box.classList.add('open');
    place();
  }

  function close() { if (box) box.classList.remove('open'); inp = null; }

  function pick(d) {
    inp.value = iso ? d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate())
      : pad(d.getDate()) + '.' + pad(d.getMonth() + 1) + '.' + d.getFullYear();
    $(inp).trigger('change');
    close();
  }

  $(document).on('focus click', 'input.fms-cal, input.datepicker', function () { if (inp !== this || !box || !box.classList.contains('open')) open(this); });
  // ввод с клавиатуры: календарь подстраивается под набранную дату
  $(document).on('input', 'input.fms-cal, input.datepicker', function () {
    if (inp !== this) return;
    var d = parse(this.value);
    if (d) { selected = d; view = new Date(d.getFullYear(), d.getMonth(), 1); draw(); }
  });
  $(document).on('keydown', 'input.fms-cal, input.datepicker', function (e) {
    if (e.key === 'Escape' || e.key === 'Tab') close();
    if (e.key === 'Enter' && inp === this) { close(); }
  });
  $(document).on('mousedown', function (e) {
    if (!box || !inp) return;
    if (box.contains(e.target) || e.target === inp) return;
    close();
  });
  $(window).on('resize', close);
  // прокрутка страницы или #mainWindow — окно едет за полем
  document.addEventListener('scroll', function () { if (inp && box.classList.contains('open')) place(); }, true);
})(jQuery);
