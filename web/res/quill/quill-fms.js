/*
 * fm additions for the Quill editor (load right after quill.js).
 *
 * Merged table cells (colspan / rowspan) are not supported by Quill: a table pasted from Excel, or an old document
 * written in nicEdit, lost its column positions (values moved left under other headings). Before Quill converts HTML,
 * every merged cell is expanded: the value stays in the first cell, the other cells of the merged area are empty,
 * so all columns keep their places. Works for paste, for documents opened in the editor and for templates.
 */
(function () {
  'use strict';
  if (!window.Quill || window.Quill.fmsUnmerge) return;

  function unmergeTable(table, doc) {
    var rows = [], grid = [];
    var trs = table.querySelectorAll('tr');
    for (var i = 0; i < trs.length; i++) {
      // only rows of this table, not of a nested one
      var owner = trs[i].parentNode;
      while (owner && owner.nodeName !== 'TABLE') owner = owner.parentNode;
      if (owner === table) rows.push(trs[i]);
    }
    for (var r = 0; r < rows.length; r++) {
      grid[r] = grid[r] || [];
      var c = 0;
      var cells = [];
      for (var k = 0; k < rows[r].children.length; k++) {
        var n = rows[r].children[k];
        if (n.nodeName === 'TD' || n.nodeName === 'TH') cells.push(n);
      }
      for (var j = 0; j < cells.length; j++) {
        var cell = cells[j];
        while (grid[r][c] !== undefined) c++;
        var cs = Math.max(1, Math.min(50, parseInt(cell.getAttribute('colspan'), 10) || 1));
        var rs = Math.max(1, Math.min(200, parseInt(cell.getAttribute('rowspan'), 10) || 1));
        for (var y = 0; y < rs; y++) {
          grid[r + y] = grid[r + y] || [];
          for (var x = 0; x < cs; x++) grid[r + y][c + x] = (y === 0 && x === 0) ? cell : null;
        }
        cell.removeAttribute('colspan');
        cell.removeAttribute('rowspan');
        c += cs;
      }
    }
    var width = 0;
    for (r = 0; r < grid.length; r++) width = Math.max(width, grid[r].length);
    for (r = 0; r < rows.length; r++) {
      var tr = rows[r];
      while (tr.firstChild) tr.removeChild(tr.firstChild);
      for (c = 0; c < width; c++) {
        var v = grid[r][c];
        if (v) {
          // header cells as normal cells: Quill keeps only td
          if (v.nodeName === 'TH') {
            var td = doc.createElement('td');
            td.innerHTML = '<b>' + v.innerHTML + '</b>';
            v = td;
          }
          tr.appendChild(v);
        } else tr.appendChild(doc.createElement('td'));
      }
    }
  }

  /** HTML with merged table cells expanded; any other HTML is returned unchanged */
  function unmerge(html) {
    if (typeof html !== 'string' || !/<t[dh][^>]*\b(col|row)span\s*=/i.test(html)) return html;
    try {
      var doc = new DOMParser().parseFromString(html, 'text/html');
      var tables = doc.querySelectorAll('table');
      for (var i = 0; i < tables.length; i++) unmergeTable(tables[i], doc);
      return /<html[\s>]/i.test(html) ? doc.documentElement.outerHTML : doc.body.innerHTML;
    } catch (e) {
      return html;
    }
  }
  window.Quill.fmsUnmerge = unmerge;

  // every HTML -> Quill conversion goes through Clipboard.convert (paste, setContents(convert(...)), dangerouslyPasteHTML)
  var Clipboard = window.Quill.import('modules/clipboard');
  var convert = Clipboard.prototype.convert;
  Clipboard.prototype.convert = function (arg, formats) {
    if (arg && typeof arg.html === 'string') {
      var h = unmerge(arg.html);
      if (h !== arg.html) arg = {html: h, text: arg.text};
    }
    return convert.call(this, arg, formats);
  };
})();
