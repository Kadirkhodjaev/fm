/*
 * Time picker in the MedOnline style for <input class="fms-time"> (the pair of fms-calendar.js).
 *   <script src="/res/js/fms-time.js?v=..."></script>  - handlers are on document, pages loaded by setPage() work too.
 * Drop-down: hours 00-23, minutes every 5, "Now" and "Clear". The value is written as HH:MM and a change event is fired.
 * The time can still be typed by hand: 930, 9.30, 9-30, 9 30 become 09:30 when the field is left; other text is kept as is
 * (old records may contain any text, it is never erased by opening the field).
 * Needs jQuery. Pure ASCII: Tomcat serves .js without a charset.
 */
(function ($) {
  if (window.__fmsTime) return;
  window.__fmsTime = true;

  var T = {
    hours: 'Часы',            // Chasy
    minutes: 'Минуты', // Minuty
    now: 'Сейчас',    // Seichas
    clear: 'Очистить' // Ochistit
  };

  var css = document.createElement('style');
  css.textContent = [
    'input.fms-time{padding-right:34px !important;min-width:110px;box-sizing:border-box;background-repeat:no-repeat;background-position:right 10px center;font-variant-numeric:tabular-nums;',
    'background-image:url("data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'16\' height=\'16\' viewBox=\'0 0 24 24\' fill=\'none\' stroke=\'%239AA1AC\' stroke-width=\'2\' stroke-linecap=\'round\' stroke-linejoin=\'round\'%3E%3Ccircle cx=\'12\' cy=\'12\' r=\'9\'/%3E%3Cpath d=\'M12 7v5l3 2\'/%3E%3C/svg%3E")}',
    '.fms-tp{position:fixed;z-index:3000;width:276px;padding:12px;background:#fff;border:1px solid #E6E8EC;border-radius:14px;box-shadow:0 12px 32px rgba(20,25,40,.14);',
    'font-family:Inter,-apple-system,"Segoe UI",Roboto,Arial,sans-serif;color:#1F2430;font-size:13.5px;user-select:none;display:none}',
    '.fms-tp.open{display:block}',
    '.fms-tp .h{font-size:11px;font-weight:600;color:#6B7280;text-transform:uppercase;letter-spacing:.4px;margin:2px 2px 6px}',
    '.fms-tp .g{display:grid;grid-template-columns:repeat(6,1fr);gap:4px;margin-bottom:10px}',
    '.fms-tp .g button{height:30px;border:0;border-radius:8px;background:#F5F6F8;color:#1F2430;font:500 13px Inter,Arial,sans-serif;cursor:pointer;font-variant-numeric:tabular-nums}',
    '.fms-tp .g button:hover{background:#E9EBEF}',
    '.fms-tp .g button.on{background:#1F2430;color:#fff}',
    '.fms-tp .f{display:flex;justify-content:space-between;gap:8px;border-top:1px solid #F0F1F4;padding-top:10px}',
    '.fms-tp .f button{flex:1;height:32px;border:1px solid #E6E8EC;border-radius:9px;background:#fff;color:#1F2430;font:600 13px Inter,Arial,sans-serif;cursor:pointer}',
    '.fms-tp .f button.now{background:#1F2430;border-color:#1F2430;color:#fff}'
  ].join('');
  document.head.appendChild(css);

  var box = null, inp = null;
  function pad(n) { return (n < 10 ? '0' : '') + n; }

  /** "9.30", "930", "9 30", "09:30" -> "09:30"; null when the text is not a time */
  function norm(v) {
    var s = $.trim(String(v || '')), m;
    if ((m = /^(\d{1,2})\s*[:.\-\s]\s*(\d{1,2})$/.exec(s)) || (m = /^(\d{1,2})(\d{2})$/.exec(s))) {
      var h = +m[1], mi = +m[2];
      if (h < 24 && mi < 60) return pad(h) + ':' + pad(mi);
    }
    if ((m = /^(\d{1,2})$/.exec(s)) && +m[1] < 24) return pad(+m[1]) + ':00';
    return null;
  }
  function parts() {
    var n = norm(inp.value);
    return n ? [+n.substr(0, 2), +n.substr(3, 2)] : [null, null];
  }
  function set(h, mi) {
    var v = pad(h) + ':' + pad(mi);
    if (inp.value !== v) { inp.value = v; $(inp).trigger('change'); }
  }
  function draw() {
    var p = parts(), h = '';
    h += '<div class="h">' + T.hours + '</div><div class="g">';
    for (var i = 0; i < 24; i++) h += '<button type="button" data-h="' + i + '" class="' + (p[0] === i ? 'on' : '') + '">' + pad(i) + '</button>';
    h += '</div><div class="h">' + T.minutes + '</div><div class="g">';
    for (var k = 0; k < 60; k += 5) h += '<button type="button" data-m="' + k + '" class="' + (p[1] === k ? 'on' : '') + '">' + pad(k) + '</button>';
    h += '</div><div class="f"><button type="button" class="now">' + T.now + '</button><button type="button" class="clr">' + T.clear + '</button></div>';
    box.innerHTML = h;
  }
  function place() {
    var r = inp.getBoundingClientRect(), bh = box.offsetHeight || 300;
    var top = r.bottom + 6;
    if (top + bh > window.innerHeight - 8 && r.top - bh - 6 > 8) top = r.top - bh - 6;
    box.style.top = top + 'px';
    box.style.left = Math.max(8, Math.min(r.left, window.innerWidth - 284)) + 'px';
  }
  function open(el) {
    if (el.readOnly || el.disabled) return;
    inp = el;
    if (!box) {
      box = document.createElement('div');
      box.className = 'fms-tp';
      document.body.appendChild(box);
      // mousedown: the field keeps the focus, typing by hand still works
      $(box).on('mousedown', function (e) {
        e.preventDefault();
        var b = $(e.target).closest('button');
        if (!b.length || !inp) return;
        var p = parts();
        if (b.is('[data-h]')) { set(+b.attr('data-h'), p[1] == null ? 0 : p[1]); draw(); }
        else if (b.is('[data-m]')) { set(p[0] == null ? new Date().getHours() : p[0], +b.attr('data-m')); close(); }
        else if (b.hasClass('now')) { var d = new Date(); set(d.getHours(), d.getMinutes()); close(); }
        else if (b.hasClass('clr')) { if (inp.value !== '') { inp.value = ''; $(inp).trigger('change'); } close(); }
      });
    }
    draw();
    box.classList.add('open');
    place();
  }
  function close() {
    if (box) box.classList.remove('open');
    inp = null;
  }

  $(document).on('focus click', 'input.fms-time', function () { if (inp !== this || !box || !box.classList.contains('open')) open(this); });
  $(document).on('input', 'input.fms-time', function () { if (box && inp === this) draw(); });
  $(document).on('keydown', 'input.fms-time', function (e) { if (e.keyCode === 27 || e.keyCode === 9 || e.keyCode === 13) close(); });
  $(document).on('blur', 'input.fms-time', function () {
    var n = norm(this.value);
    if (n && n !== this.value) { this.value = n; $(this).trigger('change'); }
    var self = this;
    setTimeout(function () { if (inp === self && document.activeElement !== self) close(); }, 150);
  });
  $(document).on('mousedown', function (e) {
    if (box && box.classList.contains('open') && !$(e.target).closest('.fms-tp').length && !$(e.target).is('input.fms-time')) close();
  });
  $(window).on('resize scroll', function () { if (box && inp && box.classList.contains('open')) place(); });
})(jQuery);
