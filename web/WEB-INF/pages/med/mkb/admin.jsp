<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Администрирование → МКБ-10: дерево разделов, карточка выбранного узла, добавление / изменение / удаление --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<style>
  .mk-wrap { display:flex; gap:12px; height:100%; min-height:0; padding:12px; background:#F7F8FA; }
  .mk-tree { flex:1 1 62%; min-width:0; overflow:auto; background:#fff; border:1px solid #E6E8EC; border-radius:14px; padding:6px 0; }
  .mk-side { flex:0 0 38%; min-width:300px; overflow:auto; background:#fff; border:1px solid #E6E8EC; border-radius:14px; padding:16px; }
  .mk-n { display:flex; align-items:flex-start; gap:6px; padding:5px 10px 5px 0; cursor:pointer; font-size:13px; line-height:18px; border-left:3px solid transparent; }
  .mk-n:hover { background:#F5F7FA; }
  .mk-n.sel { background:#EEF4FF; border-left-color:#3B6FE0; }
  .mk-n .tg { width:16px; flex:none; text-align:center; color:#9AA0AB; }
  .mk-n .tg .fa { transition:transform .12s; }
  .mk-n.open > .tg .fa { transform:rotate(90deg); }
  .mk-n .cd { flex:none; min-width:58px; font-weight:700; color:#3B6FE0; font-variant-numeric:tabular-nums; }
  .mk-n .tx { flex:1; color:#1F2430; }
  .mk-n.off .tx, .mk-n.off .cd { color:#A3A9B3; }
  .mk-n .cnt { flex:none; color:#9AA0AB; font-size:11px; }
  .mk-n mark { background:#FFF1B8; padding:0; border-radius:2px; }
  .mk-kids { display:none; }
  .mk-kids.open { display:block; }
  .mk-side h3 { margin:6px 0 4px; font-size:17px; line-height:23px; }
  .mk-side .code { display:inline-block; padding:2px 10px; border-radius:7px; background:#EEF4FF; color:#3B6FE0; font-weight:700; font-size:13px; }
  .mk-side .path { color:#6B7280; font-size:12px; margin:10px 0; }
  .mk-side .path span + span:before { content:'\203A'; margin:0 6px; color:#C0C5CE; }
  .mk-side .info { white-space:pre-wrap; text-align:justify; font-size:13px; line-height:19px; color:#374151; background:#F7F8FA; border-radius:10px; padding:10px 12px; }
  .mk-side .acts { display:flex; flex-wrap:wrap; gap:8px; margin:14px 0; }
  .mk-side .hint { color:#9AA0AB; text-align:center; margin-top:40px; }
  .mk-side .hint .fa { display:block; font-size:34px; margin-bottom:8px; color:#D3D7DE; }
</style>
<div class="fm-page fm-admin">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-stethoscope"></i></span>
        <div>
          <h2>МКБ-10</h2>
          <span class="fm-count">узлов <b id="mkTotal">0</b> · найдено <b id="mkShown">0</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="mkSeg">
        <button type="button" data-f="" class="on" onclick="mkSeg(this)">Все</button>
        <button type="button" data-f="A" onclick="mkSeg(this)">Активные</button>
        <button type="button" data-f="P" onclick="mkSeg(this)">Пассивные</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="mkSearch" placeholder="Код или название" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn" onclick="mkExpand(false)" title="Свернуть всё"><i class="fa fa-compress"></i></button>
      <button type="button" class="fm-btn primary" onclick="mkEdit(0, 0)"><i class="fa fa-plus"></i>Новый раздел</button>
    </div>
    <div class="fm-table-wrap" style="padding:0">
      <div class="mk-wrap">
        <div class="mk-tree" id="mkTree"></div>
        <div class="mk-side" id="mkSide"></div>
      </div>
    </div>
  </div>
</div>

<div class="fm-overlay fm-admin" id="mkModal" onclick="if (event.target === this) DK.close('mk')">
  <div class="fm-modal" style="width:640px">
    <div class="fm-modal-head">
      <h3 id="mkTitle"></h3>
      <button type="button" class="fm-x" onclick="DK.close('mk')"><i class="fa fa-times"></i></button>
    </div>
    <form id="mkForm" onsubmit="mkSave(); return false">
      <div class="fm-modal-body">
        <input type="hidden" name="id"/>
        <input type="hidden" name="parent_id"/>
        <div class="fm-err" id="mkErr"></div>
        <div class="path" id="mkParent" style="color:#6B7280; font-size:12px"></div>
        <div style="display:flex; gap:12px">
          <div style="width:140px">
            <label class="fm-l">Код *</label>
            <input type="text" class="fm-in" name="code" maxlength="20" autocomplete="off"/>
          </div>
          <div style="flex:1">
            <label class="fm-l">Наименование *</label>
            <input type="text" class="fm-in" name="name" maxlength="512" autocomplete="off"/>
          </div>
        </div>
        <div>
          <label class="fm-l">Описание диагноза</label>
          <textarea class="fm-in" name="info" rows="10" style="height:auto; resize:vertical"></textarea>
        </div>
        <div class="fm-state" style="align-self:flex-start">
          <label><input type="radio" class="a" name="state" value="A" checked/><span>Активный</span></label>
          <label><input type="radio" class="p" name="state" value="P"/><span>Пассивный</span></label>
        </div>
        <div style="color:#9AA0AB; font-size:12px" id="mkStateHint">Состояние раздела переходит на все вложенные узлы</div>
      </div>
      <div class="fm-modal-foot">
        <span class="fm-spacer"></span>
        <button type="button" class="fm-btn" onclick="DK.close('mk')">Отмена</button>
        <button type="submit" class="fm-btn primary" id="mkSaveBtn"><i class="fa fa-floppy-o"></i>Сохранить</button>
      </div>
    </form>
  </div>
</div>
<script>
  (function () {
    var raw = ${mkb}, nodes = {}, roots = [], selId = '${sel}', flt = '';
    for (var i = 0; i < raw.length; i++) {
      var r = raw[i], id = String(r.id).replace('padre', '');
      nodes[id] = {id: id, parent: r.parent == '#' ? '' : String(r.parent).replace('padre', ''), code: r.code || '', name: r.text || '', info: r.info || '',
        on: !!(r.state && r.state.selected), kids: []};
    }
    for (var k in nodes) {
      var n = nodes[k];
      if (n.parent && nodes[n.parent]) nodes[n.parent].kids.push(n); else roots.push(n);
    }
    function esc(t) { return String(t == null ? '' : t).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;'); }
    function hl(t, q) {
      t = esc(t);
      if (!q) return t;
      var i = t.toLowerCase().indexOf(esc(q).toLowerCase());
      return i < 0 ? t : t.slice(0, i) + '<mark>' + t.slice(i, i + q.length) + '</mark>' + t.slice(i + q.length);
    }
    function count(n) { var c = n.kids.length; for (var i = 0; i < n.kids.length; i++) c += count(n.kids[i]); return c; }
    // видимость узла: совпадение сам или кто-то из потомков (родители совпавших показываются и раскрываются)
    function match(n, q) {
      if (flt && (flt == 'A') != n.on) return false;
      return !q || n.code.toLowerCase().indexOf(q) >= 0 || n.name.toLowerCase().indexOf(q) >= 0;
    }
    function html(list, q, depth, out) {
      var shown = 0;
      for (var i = 0; i < list.length; i++) {
        var n = list[i], sub = [], subN = html(n.kids, q, depth + 1, sub), me = match(n, q);
        if (!me && !subN) continue;
        shown += (me ? 1 : 0) + subN;
        var open = (q || flt) ? subN > 0 : n._open;
        out.push('<div class="mk-n' + (n.on ? '' : ' off') + (n.id == selId ? ' sel' : '') + (open ? ' open' : '') + '" data-id="' + n.id + '" style="padding-left:' + (8 + depth * 18) + 'px">' +
          '<span class="tg">' + (n.kids.length ? '<i class="fa fa-caret-right"></i>' : '') + '</span>' +
          '<span class="cd">' + hl(n.code, q) + '</span><span class="tx">' + hl(n.name, q) + '</span>' +
          (n.kids.length ? '<span class="cnt">' + n.kids.length + '</span>' : '') + '</div>');
        if (n.kids.length) out.push('<div class="mk-kids' + (open ? ' open' : '') + '">' + sub.join('') + '</div>');
      }
      return shown;
    }
    function render() {
      var q = $.trim($('#mkSearch').val()).toLowerCase(), out = [];
      var shown = html(roots, q, 0, out);
      $('#mkTree').html(out.length ? out.join('') : '<div class="fm-empty" style="display:block"><i class="fa fa-stethoscope"></i>Ничего не найдено</div>');
      $('#mkShown').text(shown);
    }
    function pathOf(n) { var p = []; while (n && n.parent && nodes[n.parent]) { n = nodes[n.parent]; p.unshift(n); } return p; }
    function side() {
      var n = nodes[selId];
      if (!n) { $('#mkSide').html('<div class="hint"><i class="fa fa-arrow-left"></i>Выберите узел в дереве</div>'); return; }
      var p = pathOf(n), ph = [];
      for (var i = 0; i < p.length; i++) ph.push('<span>' + esc(p[i].code) + '</span>');
      $('#mkSide').html(
        '<span class="code">' + esc(n.code) + '</span> <span class="dk-st ' + (n.on ? 'A' : 'P') + '">' + (n.on ? 'Активный' : 'Пассивный') + '</span>' +
        '<h3>' + esc(n.name) + '</h3>' +
        (ph.length ? '<div class="path">' + ph.join('') + '</div>' : '') +
        '<div class="acts">' +
        '<button type="button" class="fm-btn primary" onclick="mkEdit(0, ' + n.id + ')"><i class="fa fa-plus"></i>Вложенный узел</button>' +
        '<button type="button" class="fm-btn" onclick="mkEdit(' + n.id + ')"><i class="fa fa-pencil"></i>Изменить</button>' +
        '<button type="button" class="fm-btn danger" onclick="mkDel(' + n.id + ')"><i class="fa fa-trash-o"></i>Удалить</button>' +
        '</div>' +
        (n.kids.length ? '<div class="path">Вложенных узлов: <b>' + count(n) + '</b></div>' : '') +
        (n.info ? '<div class="info">' + esc(n.info) + '</div>' : ''));
    }
    window.mkExpand = function (open) { for (var k in nodes) nodes[k]._open = open; render(); };
    window.mkSeg = function (b) { $(b).addClass('on').siblings().removeClass('on'); flt = $(b).attr('data-f'); render(); };
    window.mkEdit = function (id, parent) {
      var f = document.getElementById('mkForm'), n = nodes[id];
      f.reset();
      f.elements['id'].value = n ? n.id : '';
      f.elements['parent_id'].value = n ? '' : (parent || '');
      var par = n ? nodes[n.parent] : nodes[parent];
      $('#mkParent').html(par ? 'Раздел: <b>' + esc(par.code) + '</b> ' + esc(par.name) : 'Раздел верхнего уровня').toggle(true);
      $('#mkStateHint').toggle(!!(n && n.kids.length));
      if (n) {
        f.elements['code'].value = n.code;
        f.elements['name'].value = n.name;
        f.elements['info'].value = n.info;
        $(f).find('[name=state][value=' + (n.on ? 'A' : 'P') + ']').prop('checked', true);
      }
      DK.open('mk', n ? 'Изменить узел' : 'Новый узел');
      f.elements[n ? 'name' : 'code'].focus();
    };
    window.mkSave = function () {
      var f = document.getElementById('mkForm');
      if (!$.trim(f.elements['code'].value)) { DK.err('mk', 'Укажите код'); return; }
      if (!$.trim(f.elements['name'].value)) { DK.err('mk', 'Укажите наименование'); return; }
      $('#mkSaveBtn').prop('disabled', true);
      $.ajax({
        url: '/mkb/save.s', method: 'post', data: $(f).serialize(), dataType: 'json',
        success: function (res) {
          if (res.success) { openMsg(res); DK.close('mk'); setPage('/mkb/admin.s?sel=' + res.id); }
          else DK.err('mk', res.msg);
        },
        complete: function () { $('#mkSaveBtn').prop('disabled', false); }
      });
    };
    window.mkDel = function (id) {
      var n = nodes[id], c = count(n);
      FmsConfirm('Удалить «' + n.code + ' ' + n.name + '»' + (c ? ' вместе с вложенными узлами (' + c + ')' : '') + '?', function () {
        $.ajax({
          url: '/mkb/del.s', method: 'post', data: 'id=' + id, dataType: 'json',
          success: function (res) {
            if (res.success) { FmsToast.show('Удалено: ' + res.count, 'ok'); setPage('/mkb/admin.s?sel=' + (n.parent || 0)); }
            else FmsToast.show(res.msg, 'err');
          }
        });
      }, null, {danger: true, ok: 'Удалить'});
    };
    $('#mkTree').on('click', '.mk-n', function (e) {
      var n = nodes[$(this).attr('data-id')];
      if (n.kids.length && ($(e.target).closest('.tg').length || n.id == selId || !n._open)) {
        n._open = !$(this).hasClass('open');
        $(this).toggleClass('open', n._open).next('.mk-kids').toggleClass('open', n._open);
      }
      selId = n.id;
      $('#mkTree .mk-n.sel').removeClass('sel');
      $(this).addClass('sel');
      side();
    }).on('dblclick', '.mk-n', function () { mkEdit($(this).attr('data-id')); });
    var to = null;
    $('#mkSearch').on('input', function () { clearTimeout(to); to = setTimeout(render, 200); });
    // выбранный узел после сохранения: раскрыть путь до него
    if (nodes[selId]) { var p = pathOf(nodes[selId]); for (var j = 0; j < p.length; j++) p[j]._open = true; }
    $('#mkTotal').text(raw.length);
    render();
    side();
    var s = $('#mkTree .mk-n.sel')[0];
    if (s) s.scrollIntoView({block: 'center'});
  })();
</script>
