/*
 * Шаблоны текста врача: окно выбора шаблона и окно сохранения (Bootstrap 3 modal).
 *   fmsTpl.pick('osm_c1', 'c1')  - выбрать шаблон поля osm_c1 и вставить в редактор c1
 *   fmsTpl.save('osm_c1', 'c1')  - сохранить текст редактора c1 как шаблон поля osm_c1
 * Нужны: jQuery, Bootstrap 3 (modal), редактор Quill (window.quills) и common.js (getEditorHtml / setEditorHtml).
 * Сервер: /templates/lv/list.s, /templates/lv/store.s, /templates/delete.s
 */
(function ($) {
  if (window.fmsTpl) return;

  var SKIP = {SCRIPT: 1, STYLE: 1, IFRAME: 1, OBJECT: 1, EMBED: 1};
  var KEEP = {B: 1, STRONG: 1, I: 1, EM: 1, U: 1, S: 1, STRIKE: 1, SUB: 1, SUP: 1, BR: 1, P: 1, DIV: 1, SPAN: 1, UL: 1, OL: 1, LI: 1};

  // безопасный предпросмотр: оставляем только простое форматирование, без атрибутов и скриптов
  function clean(html) {
    var doc = new DOMParser().parseFromString('<body>' + (html || '') + '</body>', 'text/html');
    (function walk(node) {
      Array.prototype.slice.call(node.childNodes).forEach(function (ch) {
        if (ch.nodeType === 8) { node.removeChild(ch); return; }
        if (ch.nodeType !== 1) return;
        if (SKIP[ch.tagName]) { node.removeChild(ch); return; }
        if (!KEEP[ch.tagName]) {
          walk(ch);
          while (ch.firstChild) node.insertBefore(ch.firstChild, ch);
          node.removeChild(ch);
          return;
        }
        Array.prototype.slice.call(ch.attributes).forEach(function (a) { ch.removeAttribute(a.name); });
        walk(ch);
      });
    })(doc.body);
    return doc.body.innerHTML;
  }
  function plain(html) {
    return $('<div/>').html(clean(html).replace(/<\/(p|div|li)>|<br\s*\/?>/gi, function (m) { return m + ' '; })).text().replace(/\s+/g, ' ').trim();
  }
  function fieldTitle(editorId) {
    try {
      var td = $('#' + editorId).closest('tr').prev().find('td').first().clone();
      td.find('a, div, input, button, ul').remove();
      var t = td.text().replace(/\s+/g, ' ').trim();
      return t.replace(/:$/, '');
    } catch (e) { return ''; }
  }
  function toast(msg, ok) {
    if (typeof showMsg === 'function') showMsg(msg, ok); else alert(msg);
  }
  function editor(id) { return window.quills && window.quills[id]; }

  var css = [
    '#fmsTplPick .modal-body{padding:0}',
    '.fts-wrap{display:flex;min-height:340px;max-height:60vh}',
    '.fts-left{width:42%;border-right:1px solid #E6E8EC;display:flex;flex-direction:column}',
    '.fts-search{padding:10px;border-bottom:1px solid #E6E8EC}',
    '.fts-list{overflow-y:auto;flex:1}',
    '.fts-item{padding:9px 12px;border-bottom:1px solid #F0F1F4;cursor:pointer;position:relative}',
    '.fts-item:hover{background:#FAFBFC}',
    '.fts-item.sel{background:#FDECEE}',
    '.fts-item .n{font-weight:600;padding-right:26px;word-break:break-word}',
    '.fts-item .s{font-size:12px;color:#6B7280;margin-top:2px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}',
    '.fts-item .del{position:absolute;top:8px;right:8px;border:0;background:none;color:#B0B6BF;padding:2px 5px;border-radius:6px}',
    '.fts-item .del:hover{background:#FDECEE;color:#D7182E}',
    '.fts-right{flex:1;padding:12px 16px;overflow-y:auto}',
    '.fts-preview{padding:10px 12px;border:1px solid #E6E8EC;border-radius:8px;background:#FCFCFD;max-height:260px;overflow-y:auto;word-break:break-word}',
    '.fts-empty{padding:26px 16px;color:#6B7280;text-align:center}',
    '#fmsTplPick .modal-footer .hint{float:left;color:#6B7280;line-height:34px;font-size:12.5px}'
  ].join('');

  var html =
    '<div class="modal fade" id="fmsTplPick" tabindex="-1" role="dialog"><div class="modal-dialog modal-lg"><div class="modal-content">' +
    '<div class="modal-header"><button type="button" class="close" data-dismiss="modal">&times;</button><h4 class="modal-title">\u0428\u0430\u0431\u043b\u043e\u043d\u044b</h4></div>' +
    '<div class="modal-body"><div class="fts-wrap">' +
    '<div class="fts-left"><div class="fts-search"><input type="text" class="form-control" id="ftsSearch" placeholder="\u041f\u043e\u0438\u0441\u043a \u043f\u043e \u043d\u0430\u0437\u0432\u0430\u043d\u0438\u044e \u0438 \u0442\u0435\u043a\u0441\u0442\u0443" autocomplete="off"></div><div class="fts-list" id="ftsList"></div></div>' +
    '<div class="fts-right"><div id="ftsPreview" class="fts-empty">\u0412\u044b\u0431\u0435\u0440\u0438\u0442\u0435 \u0448\u0430\u0431\u043b\u043e\u043d \u0441\u043b\u0435\u0432\u0430</div></div>' +
    '</div></div>' +
    '<div class="modal-footer"><span class="hint">\u0414\u0432\u043e\u0439\u043d\u043e\u0439 \u043a\u043b\u0438\u043a \u043f\u043e \u0448\u0430\u0431\u043b\u043e\u043d\u0443 \u0432\u0441\u0442\u0430\u0432\u043b\u044f\u0435\u0442 \u0435\u0433\u043e \u0432 \u043c\u0435\u0441\u0442\u043e \u043a\u0443\u0440\u0441\u043e\u0440\u0430</span>' +
    '<button type="button" class="btn btn-default" data-dismiss="modal">\u0417\u0430\u043a\u0440\u044b\u0442\u044c</button> ' +
    '<button type="button" class="btn btn-default" id="ftsReplace" disabled>\u0417\u0430\u043c\u0435\u043d\u0438\u0442\u044c \u0432\u0435\u0441\u044c \u0442\u0435\u043a\u0441\u0442</button> ' +
    '<button type="button" class="btn btn-primary" id="ftsInsert" disabled><i class="fa fa-download"></i> \u0412\u0441\u0442\u0430\u0432\u0438\u0442\u044c</button></div>' +
    '</div></div></div>' +
    '<div class="modal fade" id="fmsTplSave" tabindex="-1" role="dialog"><div class="modal-dialog"><div class="modal-content">' +
    '<div class="modal-header"><button type="button" class="close" data-dismiss="modal">&times;</button><h4 class="modal-title">\u0421\u043e\u0445\u0440\u0430\u043d\u0438\u0442\u044c \u043a\u0430\u043a \u0448\u0430\u0431\u043b\u043e\u043d</h4></div>' +
    '<div class="modal-body">' +
    '<div class="form-group"><label for="ftsName">\u041d\u0430\u0437\u0432\u0430\u043d\u0438\u0435 \u0448\u0430\u0431\u043b\u043e\u043d\u0430</label><input type="text" class="form-control" id="ftsName" maxlength="200" autocomplete="off"></div>' +
    '<label>\u0427\u0442\u043e \u0431\u0443\u0434\u0435\u0442 \u0441\u043e\u0445\u0440\u0430\u043d\u0435\u043d\u043e</label><div id="ftsSavePreview" class="fts-preview"></div>' +
    '<div class="text-danger" id="ftsSaveErr" style="margin-top:8px;display:none"></div></div>' +
    '<div class="modal-footer"><button type="button" class="btn btn-default" data-dismiss="modal">\u041e\u0442\u043c\u0435\u043d\u0430</button> ' +
    '<button type="button" class="btn btn-primary" id="ftsSaveBtn"><i class="fa fa-save"></i> \u0421\u043e\u0445\u0440\u0430\u043d\u0438\u0442\u044c</button></div>' +
    '</div></div></div>';

  var st = {field: null, editorId: null, items: [], sel: null, range: null};
  var built = false;
  function build() {
    if (built) return;
    built = true;
    $('<style/>').text(css).appendTo('head');
    $('body').append(html);
    $('#ftsSearch').on('input', renderList);
    $('#ftsList').on('click', '.fts-item', function () { select($(this).data('id')); });
    $('#ftsList').on('dblclick', '.fts-item', function () { select($(this).data('id')); insert(false); });
    $('#ftsList').on('click', '.del', function (e) { e.stopPropagation(); remove($(this).closest('.fts-item').data('id')); });
    $('#ftsInsert').on('click', function () { insert(false); });
    $('#ftsReplace').on('click', function () { insert(true); });
    $('#ftsSaveBtn').on('click', function () { store(false); });
    $('#ftsName').on('keydown', function (e) { if (e.which === 13) { e.preventDefault(); store(false); } });
    $('#fmsTplSave').on('shown.bs.modal', function () { $('#ftsName').focus().select(); });
    $('#fmsTplPick').on('shown.bs.modal', function () { $('#ftsSearch').focus(); });
  }

  function select(id) {
    st.sel = null;
    $.each(st.items, function (i, t) { if (t.id === id) st.sel = t; });
    $('#ftsList .fts-item').removeClass('sel').filter(function () { return $(this).data('id') === id; }).addClass('sel');
    if (st.sel) {
      $('#ftsPreview').removeClass('fts-empty').html('<div style="font-weight:700;margin-bottom:8px">' + $('<div/>').text(st.sel.name).html() + '</div><div class="fts-preview">' + clean(st.sel.template) + '</div>');
    } else {
      $('#ftsPreview').addClass('fts-empty').text('\u0412\u044b\u0431\u0435\u0440\u0438\u0442\u0435 \u0448\u0430\u0431\u043b\u043e\u043d \u0441\u043b\u0435\u0432\u0430');
    }
    $('#ftsInsert, #ftsReplace').prop('disabled', !st.sel);
  }

  function renderList() {
    var q = $.trim($('#ftsSearch').val()).toLowerCase();
    var box = $('#ftsList').empty();
    var shown = 0;
    $.each(st.items, function (i, t) {
      var text = plain(t.template);
      if (q && (t.name || '').toLowerCase().indexOf(q) === -1 && text.toLowerCase().indexOf(q) === -1) return;
      shown++;
      var item = $('<div class="fts-item"/>').data('id', t.id);
      item.append($('<div class="n"/>').text(t.name || '(\u0431\u0435\u0437 \u043d\u0430\u0437\u0432\u0430\u043d\u0438\u044f)'));
      item.append($('<div class="s"/>').text(text.substring(0, 110)));
      item.append('<button type="button" class="del" title="\u0423\u0434\u0430\u043b\u0438\u0442\u044c \u0448\u0430\u0431\u043b\u043e\u043d"><i class="fa fa-trash-o"></i></button>');
      if (st.sel && st.sel.id === t.id) item.addClass('sel');
      box.append(item);
    });
    if (!shown) {
      box.append($('<div class="fts-empty"/>').text(st.items.length ? '\u041d\u0438\u0447\u0435\u0433\u043e \u043d\u0435 \u043d\u0430\u0439\u0434\u0435\u043d\u043e' : '\u0414\u043b\u044f \u044d\u0442\u043e\u0433\u043e \u043f\u043e\u043b\u044f \u0448\u0430\u0431\u043b\u043e\u043d\u043e\u0432 \u043f\u043e\u043a\u0430 \u043d\u0435\u0442. \u041d\u0430\u043f\u0438\u0448\u0438\u0442\u0435 \u0442\u0435\u043a\u0441\u0442 \u0438 \u0432\u044b\u0431\u0435\u0440\u0438\u0442\u0435 \u00ab\u0421\u043e\u0445\u0440\u0430\u043d\u0438\u0442\u044c \u043a\u0430\u043a \u0448\u0430\u0431\u043b\u043e\u043d\u00bb.'));
    }
  }

  function load() {
    $('#ftsList').html('<div class="fts-empty">\u0417\u0430\u0433\u0440\u0443\u0437\u043a\u0430...</div>');
    $.ajax({
      url: '/templates/lv/list.s', data: {field: st.field}, dataType: 'json', cache: false,
      success: function (res) {
        if (!res.success) { $('#ftsList').empty().append($('<div class="fts-empty text-danger"/>').text(res.msg || '\u041d\u0435 \u0443\u0434\u0430\u043b\u043e\u0441\u044c \u0437\u0430\u0433\u0440\u0443\u0437\u0438\u0442\u044c \u0448\u0430\u0431\u043b\u043e\u043d\u044b')); return; }
        st.items = res.templates || [];
        if (st.sel && !$.grep(st.items, function (t) { return t.id === st.sel.id; }).length) select(null);
        renderList();
      },
      error: function () { $('#ftsList').empty().append('<div class="fts-empty text-danger">\u041d\u0435 \u0443\u0434\u0430\u043b\u043e\u0441\u044c \u0437\u0430\u0433\u0440\u0443\u0437\u0438\u0442\u044c \u0448\u0430\u0431\u043b\u043e\u043d\u044b</div>'); }
    });
  }

  function insert(replace) {
    if (!st.sel) return;
    var q = editor(st.editorId), html = clean(st.sel.template || '');
    if (!q) { setEditorHtml(st.editorId, html); }
    else if (replace) { q.setContents(q.clipboard.convert({html: html})); }
    else {
      var len = q.getLength() - 1;
      var idx = st.range ? Math.min(st.range.index + st.range.length, len) : len;
      if (idx > 0 && idx >= len && q.getText(idx - 1, 1) !== '\n') { q.insertText(idx, '\n'); idx += 1; }
      q.clipboard.dangerouslyPasteHTML(idx, html);
    }
    $('#fmsTplPick').modal('hide');
    if (q) q.focus();
  }

  function remove(id) {
    var t = null;
    $.each(st.items, function (i, x) { if (x.id === id) t = x; });
    if (!t || !confirm('\u0423\u0434\u0430\u043b\u0438\u0442\u044c \u0448\u0430\u0431\u043b\u043e\u043d \u00ab' + (t.name || '') + '\u00bb?')) return;
    var code = prompt('\u041a\u043e\u0434 \u043f\u043e\u0434\u0442\u0432\u0435\u0440\u0436\u0434\u0435\u043d\u0438\u044f');
    if (code === null || code === '') return;
    $.ajax({
      url: '/templates/delete.s', method: 'post', dataType: 'json',
      data: {id: id, pas: code},
      success: function (res) { toast(res.msg, res.msg && res.msg.indexOf('\u0443\u0434\u0430\u043b\u0435\u043d') !== -1); load(); }
    });
  }

  function store(overwrite) {
    var name = $.trim($('#ftsName').val());
    var err = $('#ftsSaveErr').hide();
    if (!name) { err.text('\u0412\u0432\u0435\u0434\u0438\u0442\u0435 \u043d\u0430\u0437\u0432\u0430\u043d\u0438\u0435 \u0448\u0430\u0431\u043b\u043e\u043d\u0430').show(); $('#ftsName').focus(); return; }
    $('#ftsSaveBtn').prop('disabled', true);
    $.ajax({
      url: '/templates/lv/store.s', method: 'post', dataType: 'json',
      data: {field: st.field, name: name, template: getEditorHtml(st.editorId), overwrite: overwrite ? 'Y' : 'N'},
      success: function (res) {
        if (res.success) { $('#fmsTplSave').modal('hide'); toast(res.msg, true); }
        else if (res.exists) {
          if (confirm('\u0428\u0430\u0431\u043b\u043e\u043d \u00ab' + name + '\u00bb \u0443\u0436\u0435 \u0435\u0441\u0442\u044c. \u041e\u0431\u043d\u043e\u0432\u0438\u0442\u044c \u0435\u0433\u043e \u0442\u0435\u043a\u0441\u0442\u043e\u043c \u0438\u0437 \u043f\u043e\u043b\u044f?')) store(true);
        } else err.text(res.msg || '\u041d\u0435 \u0443\u0434\u0430\u043b\u043e\u0441\u044c \u0441\u043e\u0445\u0440\u0430\u043d\u0438\u0442\u044c').show();
      },
      error: function () { err.text('\u041e\u0448\u0438\u0431\u043a\u0430 \u0441\u0432\u044f\u0437\u0438 \u0441 \u0441\u0435\u0440\u0432\u0435\u0440\u043e\u043c').show(); },
      complete: function () { $('#ftsSaveBtn').prop('disabled', false); }
    });
  }

  window.fmsTpl = {
    pick: function (field, editorId) {
      build();
      var q = editor(editorId);
      st = {field: field, editorId: editorId, items: [], sel: null, range: (q && window.quillRange && window.quillRange[editorId]) || null};
      $('#fmsTplPick .modal-title').text('\u0428\u0430\u0431\u043b\u043e\u043d\u044b' + (fieldTitle(editorId) ? ': ' + fieldTitle(editorId) : ''));
      $('#ftsSearch').val('');
      select(null);
      $('#fmsTplPick').modal('show');
      load();
    },
    save: function (field, editorId) {
      build();
      var html = getEditorHtml(editorId);
      st = {field: field, editorId: editorId, items: [], sel: null, range: null};
      if (!html) { toast('\u041f\u043e\u043b\u0435 \u043f\u0443\u0441\u0442\u043e\u0435: \u043d\u0435\u0447\u0435\u0433\u043e \u0441\u043e\u0445\u0440\u0430\u043d\u044f\u0442\u044c', false); return; }
      var text = plain(html);
      $('#ftsName').val(text.substring(0, 50));
      $('#ftsSavePreview').html(clean(html));
      $('#ftsSaveErr').hide();
      $('#fmsTplSave .modal-title').text('\u0421\u043e\u0445\u0440\u0430\u043d\u0438\u0442\u044c \u043a\u0430\u043a \u0448\u0430\u0431\u043b\u043e\u043d' + (fieldTitle(editorId) ? ': ' + fieldTitle(editorId) : ''));
      $('#fmsTplSave').modal('show');
    }
  };
})(jQuery);
