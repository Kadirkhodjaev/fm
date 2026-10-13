/*
 * Отчёты → Excel (.xlsx): таблицы отчёта из документа doc собираются в один лист.
 *   FmsRepExcel(doc, fileName)
 * Текст над первой таблицей (название, параметры) идёт заголовком, между таблицами пустая строка.
 * Числа выгружаются числами, объединённые ячейки (colspan/rowspan) сохраняются, у ячеек тонкие границы.
 * Использует /res/js/tableToExcel.js (подгружается при первом вызове).
 */
(function () {
  var LIB = '/res/js/tableToExcel.js';

  function loadLib(cb) {
    if (window.TableToExcel) { cb(); return; }
    var s = document.createElement('script');
    s.src = LIB;
    s.onload = cb;
    s.onerror = function () { if (window.FmsToast) FmsToast.show('Не удалось подключить выгрузку в Excel', 'err'); };
    document.head.appendChild(s);
  }

  function clean(t) { return (t || '').replace(/\u00A0/g, ' ').replace(/[ \t]+/g, ' ').replace(/\s*\n\s*/g, '\n').trim(); }

  // число: «1 234,5» → 1234.5; номера с ведущим нулём и длинные коды (телефоны, паспорта) остаются текстом
  function asNumber(t) {
    var s = t.replace(/\s/g, '').replace(',', '.');
    if (!/^-?\d+(\.\d+)?$/.test(s) || s.length > 12 || /^-?0\d/.test(s)) return null;
    return s;
  }

  function topTables(doc) {
    return Array.prototype.filter.call(doc.querySelectorAll('table'), function (t) {
      if (t.parentElement.closest('table')) return false;
      if (t.closest('.rp-bar, .pv-bar')) return false;
      var st = (doc.defaultView || window).getComputedStyle(t);
      return st.display != 'none' && st.visibility != 'hidden' && t.rows.length > 0;
    });
  }

  function width(tr) { var w = 0; for (var i = 0; i < tr.cells.length; i++) w += tr.cells[i].colSpan || 1; return w; }

  function headText(doc, first) {
    var r = doc.createRange();
    r.setStart(doc.body, 0);
    if (first) r.setEndBefore(first); else r.setEnd(doc.body, doc.body.childNodes.length);
    var box = document.createElement('div');
    box.appendChild(r.cloneContents());
    $(box).find('script, style, iframe, .rp-bar, .pv-bar, input, button, select').remove();
    box.style.cssText = 'position:absolute; left:-10000px; top:0; white-space:pre-wrap';
    document.body.appendChild(box);
    var t = box.innerText;
    document.body.removeChild(box);
    return clean(t).split('\n').filter(function (l) { return l; }).slice(0, 5);
  }

  function build(doc) {
    var tables = topTables(doc);
    if (!tables.length) return null;
    var cols = 1;
    tables.forEach(function (t) { for (var i = 0; i < Math.min(t.rows.length, 30); i++) cols = Math.max(cols, width(t.rows[i])); });
    var out = document.createElement('table'), widths = [];
    function row() { return out.insertRow(-1); }
    function cell(tr, text, attrs) {
      var td = document.createElement('td');
      td.textContent = text;
      for (var k in attrs) td.setAttribute(k, attrs[k]);
      tr.appendChild(td);
      return td;
    }
    headText(doc, tables[0]).forEach(function (l, i) {
      cell(row(), l, {colspan: cols, 'data-f-bold': 'true', 'data-f-sz': i == 0 ? '14' : '11', 'data-a-h': 'center'});
    });
    if (out.rows.length) row();
    var win = doc.defaultView || window;
    tables.forEach(function (t, ti) {
      if (ti > 0) row();
      // ширину колонок считаем по полным строкам (строки-группы вида «Лаборатория» короче и её не задают)
      var full = 0;
      for (var q = 0; q < t.rows.length; q++) full = Math.max(full, t.rows[q].cells.length);
      for (var i = 0; i < t.rows.length; i++) {
        var src = t.rows[i], tr = row(), pos = 0;
        for (var j = 0; j < src.cells.length; j++) {
          var c = src.cells[j], text = clean(c.innerText), num = asNumber(text), a = {'data-b-a-s': 'thin', 'data-a-wrap': 'true', 'data-a-v': 'middle'};
          if (c.colSpan > 1) a.colspan = c.colSpan;
          if (c.rowSpan > 1) a.rowspan = c.rowSpan;
          var st = win.getComputedStyle(c);
          if (c.tagName == 'TH' || parseInt(st.fontWeight, 10) >= 600) a['data-f-bold'] = 'true';
          if (st.textAlign == 'center') a['data-a-h'] = 'center';
          if (num != null) { a['data-t'] = 'n'; text = num; }
          cell(tr, text, a);
          if ((c.colSpan || 1) == 1 && src.cells.length == full) {
            var len = Math.max.apply(null, text.split('\n').map(function (s) { return s.length; }));
            widths[pos] = Math.max(widths[pos] || 6, Math.min(len + 2, 60));
          }
          pos += c.colSpan || 1;
        }
      }
    });
    var w = [];
    for (var k = 0; k < cols; k++) w.push(widths[k] || 10);
    out.setAttribute('data-cols-width', w.join(','));
    return out;
  }

  window.FmsRepExcel = function (doc, fileName) {
    loadLib(function () {
      var t;
      try { t = build(doc); } catch (e) { t = null; }
      if (!t) { if (window.FmsToast) FmsToast.show('В отчёте нет таблиц для выгрузки', 'info'); return; }
      var name = (fileName || 'Отчёт').replace(/[\\\/:*?"<>|]+/g, ' ').trim();
      TableToExcel.convert(t, {name: name + '.xlsx', sheet: {name: name.replace(/[\[\]*?:\/\\]/g, ' ').slice(0, 31) || 'Отчёт'}});
    });
  };
})();
