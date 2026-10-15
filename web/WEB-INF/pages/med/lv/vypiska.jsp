<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet">

<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>

<script src="/res/js/common.js?v=2026101501" type="text/javascript"></script>
<link href="/res/quill/quill.snow.css" rel="stylesheet">
<script src="/res/quill/quill.js" type="text/javascript"></script>
<script src="/res/quill/quill-fms.js?v=2026101501" type="text/javascript" charset="UTF-8"></script>
<script src="/res/js/fms-calendar.js" type="text/javascript"></script>
<script src="/res/js/fms-templates.js?v=4" type="text/javascript" charset="UTF-8"></script>

<style>
  .osm-editor .ql-editor { min-height: 150px; max-height: 420px; overflow-y: auto; font-size: 14px; }
  .osm-editor.ql-container { border-bottom-left-radius: 6px; border-bottom-right-radius: 6px; }
  .ql-toolbar.ql-snow { border-top-left-radius: 6px; border-top-right-radius: 6px; }
  /* Препараты на дом: строки для напоминаний пациенту (приложение и бот пациента) */
  .hd-box { border: 1px solid #E6E8EC; border-radius: 8px; padding: 10px 12px; background: #FAFBFC; margin: 4px 0 8px; }
  .hd-head { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; margin-bottom: 6px; }
  .hd-head .hd-hint { color: #6B7280; font-weight: normal; font-size: 12px; }
  .hd-head .hd-btns { margin-left: auto; display: flex; gap: 6px; }
  .hd-table { width: 100%; border-collapse: collapse; }
  .hd-table th { font-size: 12px; color: #6B7280; font-weight: 600; padding: 3px 4px; text-align: left; white-space: nowrap; }
  .hd-table td { padding: 3px 4px; vertical-align: middle; }
  .hd-table td.hd-c { text-align: center; width: 54px; }
  .hd-table input[type=text], .hd-table input[type=number], .hd-table select { height: 28px; padding: 2px 6px; font-size: 13px; }
  .hd-table .hd-err { border-color: #D7182E; background: #FDECEE; }
  .hd-empty { color: #6B7280; font-size: 12.5px; padding: 4px 2px; }
  .hd-follow { display: flex; align-items: center; gap: 6px; flex-wrap: wrap; margin-top: 8px; font-size: 13px; }
  .hd-follow input { height: 28px; padding: 2px 6px; font-size: 13px; }
  /* выбор МКБ-10 как в «Осмотре врача»: поиск по коду и названию, плашка выбранного диагноза, справочник */
  .mkb-pick { position: relative; font-size: 14px; }
  .mkb-field { display: flex; align-items: center; gap: 8px; min-height: 38px; padding: 0 4px 0 12px; background: #fff;
    border: 1px solid #ccc; border-radius: 6px; transition: border-color .15s, box-shadow .15s; }
  .mkb-field:focus-within { border-color: #9AA1AC; box-shadow: 0 0 0 3px rgba(31, 36, 48, .06); }
  .mkb-pick.mkb-error .mkb-field { border-color: #d9534f; box-shadow: 0 0 0 3px rgba(217, 83, 79, .12); }
  .mkb-ico { flex: none; color: #9AA1AC; font-size: 14px; }
  .mkb-pick.mkb-error .mkb-ico { color: #d9534f; }
  .mkb-field input.mkb-input { flex: 1; min-width: 0; height: 36px !important; padding: 0; border: 0; outline: none;
    box-shadow: none; background: transparent; font-size: 14px; color: #1F2430; }
  .mkb-input::placeholder { color: #9AA1AC; }
  .mkb-chip { flex: 1; min-width: 0; display: none; align-items: center; gap: 8px; margin: 5px 0; color: #1F2430; }
  .mkb-pick.has-value .mkb-chip { display: flex; }
  .mkb-pick.has-value .mkb-input, .mkb-pick.has-value .mkb-ico { display: none; }
  .mkb-chip-code { flex: none; padding: 3px 8px; border-radius: 5px; background: #FDECEC; color: #C62828; font-weight: 700; font-size: 13px; }
  .mkb-chip-name { min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
  .mkb-btn { flex: none; height: 28px; padding: 0 10px; border: 0; border-radius: 6px; background: none; color: #4B5563; font-size: 13px; font-weight: 600; cursor: pointer; }
  .mkb-btn:hover { background: #F1F2F4; color: #1F2430; }
  .mkb-btn-clear { width: 28px; padding: 0; color: #9AA1AC; }
  .mkb-pick:not(.has-value) .mkb-btn-clear { display: none; }
  .mkb-sep { flex: none; width: 1px; height: 20px; background: #E6E8EC; }
  .mkb-list { display: none; position: absolute; z-index: 1000; left: 0; right: 0; top: calc(100% + 4px); margin: 0; padding: 6px; list-style: none;
    max-height: 320px; overflow-y: auto; background: #fff; border: 1px solid #E6E8EC; border-radius: 10px; box-shadow: 0 12px 32px rgba(20, 25, 40, .14); }
  .mkb-list li a { display: flex; gap: 10px; padding: 7px 10px; border-radius: 6px; color: #1F2430; text-decoration: none; line-height: 1.35; }
  .mkb-list li a:hover, .mkb-list li.active a { background: #F1F2F4; }
  .mkb-list li.disabled a { color: #9AA1AC; cursor: default; background: none; }
  .mkb-list .mkb-code { flex: none; min-width: 56px; font-weight: 700; color: #C62828; }
</style>
<script type="text/javascript">
  window.quills = window.quills || {};
  window.quillRange = window.quillRange || {};
  $(function () {
    $('#lv_doc textarea').each(function () {
      var ta = this;
      var host = $('<div class="osm-editor"></div>').insertAfter(ta)[0];
      var q = new Quill(host, {
        theme: 'snow',
        modules: {
          toolbar: [['bold', 'italic', 'underline', 'strike'], [{list: 'ordered'}, {list: 'bullet'}], [{script: 'sub'}, {script: 'super'}], ['clean']]
        }
      });
      if (ta.value && ta.value.trim() !== '')
        q.setContents(q.clipboard.convert({html: ta.value}), 'silent');
      window.quills[ta.id] = q;
      q.on('selection-change', function (r) { if (r) window.quillRange[ta.id] = r; });
    });
  });
  function getResult() {
    $.ajax({
      url:'/lv/results.s',
      data:'',
      method:'post',
      dataType:'json',
      success:function(res) {
        setEditorHtml('c5', res.results);
      }
    });
  }
  function getDrugResult() {
    $.ajax({
      url:'/lv/drug_results.s',
      data:'',
      method:'post',
      dataType:'json',
      success:function(res) {
        setEditorHtml('c6', res.results);
      }
    });
  }
  // Показывает выбранный диагноз плашкой: код отдельно, название рядом (как в «Осмотре врача»)
  function showMkbChip(text) {
    var m = /^([A-ZА-Я]\d{2}(?:[.\-][\w.\-]*)?)\s+(.*)$/i.exec(text || '');
    $('.mkb-chip-code').text(m ? m[1] : 'МКБ').toggle(true);
    $('.mkb-chip-name').text(m ? m[2] : text).attr('title', text);
    $('.mkb-pick').toggleClass('has-value', !!$('#mkb_id').val());
  }
  // выбор из поиска или из окна справочника (/mkb/index.s вызывает opener.setMkb): диагноз добавляется в «Основной диагноз»
  function setMkb(text, id) {
    text = $.trim(text);
    $('#mkb_id').val(id);
    $('#mkb').val(text);
    $('#mkb_search').val('');
    $('#mkb_list').hide().empty();
    $('.mkb-pick').removeClass('mkb-error');
    showMkbChip(text);
    var q = window.quills['c1'];
    if (q && q.getText().indexOf(text) < 0) {
      var hasText = q.getText().trim().length > 0;
      q.insertText(q.getLength() - 1, (hasText ? ', ' : '') + text);
    }
  }
  function clearMkb() {
    $('#mkb_id, #mkb, #mkb_search').val('');
    $('#mkb_list').hide().empty();
    $('.mkb-pick').removeClass('has-value');
    $('#mkb_search').focus();
  }
  $(function () {
    var timer = null, xhr = null;
    var box = $('#mkb_list'), inp = $('#mkb_search');
    // Старые записи хранили id диагноза в поле mkb: подтягиваем название из справочника
    if (!$('#mkb_id').val() && /^\d+$/.test($('#mkb').val())) $('#mkb_id').val($('#mkb').val());
    if ($('#mkb_id').val() && !/\D/.test($('#mkb').val())) {
      showMkbChip('');
      $.post('/mkb/get.s', {id: $('#mkb_id').val()}, function (res) {
        if (res.success && res.name) {
          var t = (res.code ? res.code + ' ' : '') + res.name;
          $('#mkb').val(t);
          showMkbChip(t);
        }
      }, 'json');
    } else {
      showMkbChip($('#mkb').val());
    }
    function render(rows) {
      box.empty();
      if (!rows.length) box.append('<li class="disabled"><a href="#">Ничего не найдено</a></li>');
      $.each(rows, function (i, r) {
        var text = (r.code ? r.code + ' ' : '') + r.name;
        var a = $('<a href="#"></a>').attr('data-id', r.id).attr('data-text', text);
        if (r.code) a.append($('<span class="mkb-code"></span>').text(r.code));
        a.append($('<span></span>').text(r.name));
        box.append($('<li></li>').append(a));
      });
      box.show();
    }
    inp.on('input', function () {
      $('#mkb_id').val('');
      $('#mkb').val('');
      var v = $.trim(inp.val());
      clearTimeout(timer);
      if (v.length < 2) { box.hide().empty(); return; }
      timer = setTimeout(function () {
        if (xhr) xhr.abort();
        xhr = $.post('/mkb/search.s', {q: v}, function (res) {
          if (res.success) render(res.rows || []);
        }, 'json');
      }, 300);
    });
    inp.on('keydown', function (e) {
      if (!box.is(':visible')) return;
      var items = box.find('li:not(.disabled)'), cur = items.index(items.filter('.active'));
      if (e.keyCode === 40 || e.keyCode === 38) {
        e.preventDefault();
        cur = e.keyCode === 40 ? Math.min(cur + 1, items.length - 1) : Math.max(cur - 1, 0);
        items.removeClass('active').eq(cur).addClass('active');
        var el = items.eq(cur)[0];
        if (el) el.scrollIntoView({block: 'nearest'});
      } else if (e.keyCode === 13) {
        e.preventDefault();
        if (cur >= 0) items.eq(cur).find('a').click();
      } else if (e.keyCode === 27) {
        box.hide();
      }
    });
    box.on('click', 'a', function (e) {
      e.preventDefault();
      if ($(this).attr('data-id')) setMkb($(this).attr('data-text'), $(this).attr('data-id'));
    });
    $(document).on('click', function (e) {
      if (!$(e.target).closest('.mkb-pick').length) box.hide();
    });
  });
  function printRecommend() {
    window.open('/lv/print_recommend.s');
  }
  // Препараты на дом: таблица сохраняется вместе с выпиской, блок в «Рекомендовано» (c7) собирается из неё сам
  var homeDrugs = {
    DRUGS_TITLE: 'Препараты на дом:',
    FOLLOW_TITLE: 'Повторный приём:',
    loaded: false,
    timer: null,
    esc: function (s) { return String(s == null ? '' : s).replace(/[&<>"]/g, function (c) { return {'&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;'}[c]; }); },
    init: function () {
      if (!$('#homeDrugs').length) return;
      var self = this;
      $.ajax({url: '/lv/home/get.s', method: 'post', dataType: 'json', success: function (res) {
        if (!res.success) { errMsg(res.msg || 'Не удалось загрузить препараты на дом'); return; }
        $.each(res.plan.drugs, function (i, d) { self.addRow(d); });
        $('#hdFollowDays').val(res.plan.followupDays);
        $('#hdFollowDoctor').val(res.plan.followupDoctor);
        self.loaded = true;
        self.refreshEmpty();
      }});
      $('#homeDrugs').on('input change', 'input, select', function () {
        $(this).removeClass('hd-err');
        clearTimeout(self.timer);
        self.timer = setTimeout(function () { self.updateC7(); }, 300);
      });
    },
    addRow: function (d) {
      d = d || {drug: '', dose: '', m: true, n: false, e: false, food: '', days: ''};
      var tr = $('<tr>' +
        '<td><input type="text" class="form-control hd-drug" maxlength="255" placeholder="Препарат"/></td>' +
        '<td style="width:140px"><input type="text" class="form-control hd-dose" maxlength="128" placeholder="1 таблетка"/></td>' +
        '<td class="hd-c"><input type="checkbox" class="hd-m"/></td>' +
        '<td class="hd-c"><input type="checkbox" class="hd-n"/></td>' +
        '<td class="hd-c"><input type="checkbox" class="hd-e"/></td>' +
        '<td style="width:150px"><select class="form-control hd-food"><option value="">—</option><option value="B">до еды</option><option value="W">во время еды</option><option value="A">после еды</option></select></td>' +
        '<td style="width:80px"><input type="number" class="form-control hd-days" min="1" max="365"/></td>' +
        '<td style="width:30px"><a href="#" class="text-danger" title="Удалить строку" onclick="homeDrugs.remove(this); return false;"><i class="fa fa-times"></i></a></td>' +
        '</tr>');
      tr.find('.hd-drug').val(d.drug);
      tr.find('.hd-dose').val(d.dose);
      tr.find('.hd-m').prop('checked', !!d.m);
      tr.find('.hd-n').prop('checked', !!d.n);
      tr.find('.hd-e').prop('checked', !!d.e);
      tr.find('.hd-food').val(d.food || '');
      tr.find('.hd-days').val(d.days);
      $('#homeDrugs tbody').append(tr);
      this.refreshEmpty();
      return tr;
    },
    add: function () {
      this.addRow().find('.hd-drug').focus();
    },
    remove: function (a) {
      $(a).closest('tr').remove();
      this.refreshEmpty();
      this.updateC7();
    },
    refreshEmpty: function () {
      var n = $('#homeDrugs tbody tr').length;
      $('#homeDrugs table').toggle(n > 0);
      $('#homeDrugs .hd-empty').toggle(n === 0);
    },
    fromLv: function () {
      var self = this;
      $.ajax({url: '/lv/home/from_lv.s', method: 'post', dataType: 'json', success: function (res) {
        if (!res.success) { errMsg(res.msg || 'Не удалось получить лист назначений'); return; }
        var have = {};
        $('#homeDrugs .hd-drug').each(function () { have[$(this).val().trim().toLowerCase()] = 1; });
        var added = 0;
        $.each(res.drugs, function (i, d) {
          if (have[d.drug.toLowerCase()]) return;
          self.addRow(d).find('.hd-days').addClass('hd-err');
          added++;
        });
        if (added === 0) { openMedMsg('В листе назначений нет новых таблеток', true); return; }
        self.updateC7();
        openMedMsg('Перенесено препаратов: ' + added + '. Укажите, сколько дней принимать.', true);
      }});
    },
    rows: function () {
      var list = [];
      $('#homeDrugs tbody tr').each(function () {
        var tr = $(this);
        var d = {drug: tr.find('.hd-drug').val().trim(), dose: tr.find('.hd-dose').val().trim(), m: tr.find('.hd-m').prop('checked'),
          n: tr.find('.hd-n').prop('checked'), e: tr.find('.hd-e').prop('checked'), food: tr.find('.hd-food').val(), days: tr.find('.hd-days').val().trim(), tr: tr};
        if (d.drug !== '') list.push(d);
      });
      return list;
    },
    validate: function () {
      if (!this.loaded) return null;
      var err = null;
      $.each(this.rows(), function (i, d) {
        if (!d.m && !d.n && !d.e) { err = err || ('«' + d.drug + '»: отметьте утро, обед или вечер'); d.tr.find('.hd-c input').addClass('hd-err'); }
        var n = parseInt(d.days, 10);
        if (!(n >= 1 && n <= 365)) { err = err || ('«' + d.drug + '»: укажите, сколько дней принимать (1–365)'); d.tr.find('.hd-days').addClass('hd-err'); }
      });
      var f = $('#hdFollowDays').val().trim();
      if (f !== '' && !(parseInt(f, 10) >= 1 && parseInt(f, 10) <= 365)) { err = err || 'Повторный приём: укажите число дней (1–365)'; $('#hdFollowDays').addClass('hd-err'); }
      return err;
    },
    text: function () {
      var self = this, list = this.rows(), html = '';
      if (list.length) {
        html += '<p><strong>' + this.DRUGS_TITLE + '</strong></p><ol>';
        $.each(list, function (i, d) {
          var when = [];
          if (d.m) when.push('утром');
          if (d.n) when.push('в обед');
          if (d.e) when.push('вечером');
          var food = {B: 'до еды', W: 'во время еды', A: 'после еды'}[d.food];
          var parts = [];
          if (d.dose) parts.push(d.dose);
          if (when.length) parts.push(when.join(', '));
          if (food) parts.push(food);
          if (parseInt(d.days, 10) > 0) parts.push(parseInt(d.days, 10) + ' дн.');
          html += '<li>' + self.esc(d.drug) + (parts.length ? ' — ' + self.esc(parts.join(', ')) : '') + '</li>';
        });
        html += '</ol>';
      }
      var fd = parseInt($('#hdFollowDays').val(), 10), doc = $('#hdFollowDoctor').val().trim();
      if (fd > 0 || doc)
        html += '<p><strong>' + this.FOLLOW_TITLE + '</strong> ' + self.esc((fd > 0 ? 'через ' + fd + ' дн.' : '') + (fd > 0 && doc ? ', ' : '') + doc) + '</p>';
      return html;
    },
    updateC7: function () {
      if (!window.quills || !window.quills['c7']) return;
      var self = this, box = $('<div>').html(getEditorHtml('c7'));
      box.children('p').each(function () {
        var p = $(this), t = p.text().trim();
        if (t.indexOf(self.DRUGS_TITLE) === 0) {
          var n = p.next();
          while (n.length && /^(OL|UL)$/.test(n[0].tagName)) { var nn = n.next(); n.remove(); n = nn; }
          p.remove();
        } else if (t.indexOf(self.FOLLOW_TITLE) === 0) p.remove();
      });
      setEditorHtml('c7', this.text() + box.html());
    },
    save: function () {
      if (!this.loaded) return;
      var data = {drugs: [], followupDays: $('#hdFollowDays').val().trim(), followupDoctor: $('#hdFollowDoctor').val().trim()};
      $.each(this.rows(), function (i, d) { data.drugs.push({drug: d.drug, dose: d.dose, m: d.m, n: d.n, e: d.e, food: d.food, days: d.days}); });
      $.ajax({url: '/lv/home/save.s', method: 'post', data: {data: JSON.stringify(data)}, dataType: 'json', success: function (res) {
        if (!res.success) errMsg(res.msg || 'Препараты на дом не сохранены');
      }});
    }
  };
  $(function () { homeDrugs.init(); });
  function saveDoc() {
    if (!$('#mkb_id').val()) {
      $('.mkb-pick').addClass('mkb-error');
      $('#mkb_search')[0].scrollIntoView({block: 'center'});
      $('#mkb_search').focus();
      errMsg('Выберите основной диагноз по МКБ-10: без него выписку сохранить нельзя');
      return;
    }
    var hdErr = homeDrugs.validate();
    if (hdErr) { errMsg(hdErr); return; }
    $('#doc_form').html('');
    $('#lv_doc input[name], #lv_doc textarea[name]').each((i, v) => {
      let input = $('<input type="hidden" name="' + v.name + '"/>');
      input.val(v.tagName == 'TEXTAREA' ? getEditorHtml(v.id) : v.value);
      $('#doc_form').append(input);
    })
    $.ajax({
      url: '/lv/doc/save.s',
      method: 'post',
      data: $('#doc_form').serialize(),
      dataType: 'json',
      success: function (res) {
        FmsToast.show(res.success ? 'Сохранено' : (res.msg || 'Не удалось сохранить'), res.success ? 'ok' : 'err');
        if(res.success && res.id)
          $('#lv_doc input[name=id]').val(res.id);
        if(res.success)
          homeDrugs.save();
      }
    });
  }
</script>
<%@include file="/WEB-INF/pages/med/lv/doc_style.jsp"%>
<form id="doc_form" action="#"></form>
<div class="ld-sheet">
  <div class="ld-title">Выписка</div>
  <form action='#' method="post" id="lv_doc">
    <input type="hidden" name="id" value="${doc.id}"/>
    <input type="hidden" name="doc_code" value="vypiska"/>
    <div class="ld-body">

        <div class="ld-head"><div class="ld-c"><b>Пациент(ка):</b> ${patient.fio}</div><div class="ld-c"><b>Год рождения:</b> ${patient.birthyear}</div><div class="ld-c"><b>Дата выписки:</b></div><div class="ld-c">
          <%-- дата выписки не вводится: всегда дата регистрации + кол-во койко-дней (меняет лечащий врач в Регистрации) --%>
          <input type="hidden" name="Date_End" id="Date_End" value=""/>
          <span id="vyEnd" style="font-weight:700"></span>
          <c:if test="${empty patient.dateEnd}">
            <label style="display:inline-flex;align-items:center;gap:6px;margin:0 0 0 10px;font-weight:600;cursor:pointer">
              <input type="checkbox" id="vyOut" onchange="$('#Date_End').val(this.checked ? 'Y' : '')"/> Оформить выписку
            </label>
          </c:if>
          <c:if test="${not empty patient.dateEnd}"><span style="margin-left:8px;color:#15803D;font-weight:600">выписан</span></c:if>
          <div style="font-size:11.5px;color:#9AA1AC;margin-top:2px">Регистрация <fmt:formatDate pattern="dd.MM.yyyy" value="${patient.dateBegin}"/> + ${patient.dayCount} дн. − 1. Кол-во дней и время ухода выбирает лечащий врач: Регистрация → «Койко-дни».</div>
          <script>
            (function () {
              var b = '<fmt:formatDate pattern="dd.MM.yyyy" value="${patient.dateBegin}"/>'.split('.'), n = parseInt('${patient.dayCount}', 10);
              var t = '<fmt:formatDate pattern="dd.MM.yyyy" value="${patient.dateEnd}"/>';
              if (!t && b.length === 3 && n > 0) {
                var d = new Date(+b[2], +b[1] - 1, +b[0] + n - 1);
                t = ('0' + d.getDate()).slice(-2) + '.' + ('0' + (d.getMonth() + 1)).slice(-2) + '.' + d.getFullYear();
              }
              document.getElementById('vyEnd').textContent = t || '—';
            })();
          </script>
        </div></div>
        <div class="ld-sec">Клинический диагноз</div>
        <div class="ld-l">
            Основной диагноз по МКБ-10 <span style="color:#d9534f" title="Обязательное поле">*</span>
        </div>
        <div class="ld-raw">
            <input type="hidden" name="mkb_id" id="mkb_id" value="${doc.mkb_id}"/>
            <input type="hidden" name="mkb" id="mkb" value="<c:out value='${doc.mkb}'/>"/>
            <div class="mkb-pick">
              <div class="mkb-field">
                <i class="fa fa-search mkb-ico"></i>
                <input type="text" id="mkb_search" class="mkb-input" autocomplete="off" placeholder="Начните вводить код или название диагноза, например I10 или гипертензия"/>
                <div class="mkb-chip" title="Выбранный диагноз">
                  <span class="mkb-chip-code"></span>
                  <span class="mkb-chip-name"></span>
                </div>
                <button class="mkb-btn mkb-btn-clear" type="button" onclick="clearMkb()" title="Убрать диагноз"><i class="fa fa-times"></i></button>
                <span class="mkb-sep"></span>
                <button class="mkb-btn" type="button" onclick="window.open('/mkb/index.s', '_blank')" title="Открыть справочник МКБ-10"><i class="fa fa-sitemap"></i> Справочник</button>
              </div>
              <ul id="mkb_list" class="mkb-list"></ul>
            </div>
        </div>
        <div class="ld-l">
            Основной диагноз
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('vyp_c1', 'c1'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('vyp_c1', 'c1'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea id="c1" name="c1" style="display:none" rows="8" cols="2">${doc.c1}</textarea>
        </div>
        <div class="ld-l">
            Сопуствующие болезни
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('vyp_c8', 'c8'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('vyp_c8', 'c8'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea id="c8" name="c8" style="display:none" rows="8" cols="2">${doc.c8}</textarea>
        </div>
        <div class="ld-l">
            Осложнение
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('vyp_c9', 'c9'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('vyp_c9', 'c9'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea id="c9" name="c9" style="display:none" rows="8" cols="2">${doc.c9}</textarea>
        </div>
        <div class="ld-l">
            Жалобы при поступлении:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('vyp_c2', 'c2'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('vyp_c2', 'c2'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea id="c2" name="c2" style="display:none" rows="8" cols="2">${doc.c2}</textarea>
        </div>
        <div class="ld-l">
            Из анамнеза:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('vyp_c3', 'c3'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('vyp_c3', 'c3'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea id="c3" name="c3" style="display:none" rows="8" cols="2">${doc.c3}</textarea>
        </div>
        <div class="ld-l">
            Состояние при поступлении:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('vyp_c4', 'c4'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('vyp_c4', 'c4'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea id="c4" name="c4" style="display:none" rows="8" cols="2">${doc.c4}</textarea>
        </div>
        <div class="ld-l">
            Проведённые исследования:
            <a title="Результаты" style="float: right; font-weight: bold" class="btn btn-xs btn-default" onclick="getResult (); return false;">
              <span class="fa fa-refresh"></span> Обновить
            </a>
        </div>
        <div class="ld-f"><textarea id="c5" name="c5" style="display:none" rows="8" cols="2">${doc.c5}</textarea>
        </div>
        <div class="ld-l">
            Проведено лечение:
            <a title="Результаты" style="float: right; font-weight: bold" class="btn btn-xs btn-default" onclick="getDrugResult (); return false;">
              <span class="fa fa-refresh"></span> Обновить
            </a>
        </div>
        <div class="ld-f"><textarea id="c6" name="c6" style="display:none" rows="8" cols="2">${doc.c6}</textarea>
        </div>





        <div class="ld-sec">Диагноз при выписке</div>
        <div class="ld-l">
            Основной диагноз
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('vyp_c10', 'c10'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('vyp_c10', 'c10'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea id="c10" name="c10" style="display:none" rows="8" cols="2">${doc.c10}</textarea>
        </div>
        <div class="ld-l">
            Сопуствующие болезни
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('vyp_c11', 'c11'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('vyp_c11', 'c11'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea id="c11" name="c11" style="display:none" rows="8" cols="2">${doc.c11}</textarea>
        </div>
        <div class="ld-l">
            Осложнение
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('vyp_c12', 'c12'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('vyp_c12', 'c12'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea id="c12" name="c12" style="display:none" rows="8" cols="2">${doc.c12}</textarea>
        </div>
        <c:if test="${!dieFlag}">
        <div class="ld-raw">
            <div class="hd-box" id="homeDrugs">
              <div class="hd-head">
                <b>Препараты на дом</b>
                <span class="hd-hint">пациент получит напоминания в приложении или в Telegram-боте до конца курса</span>
                <span class="hd-btns">
                  <button type="button" class="btn btn-xs btn-default" onclick="homeDrugs.fromLv()"><i class="fa fa-download"></i> Перенести из листа назначений</button>
                  <button type="button" class="btn btn-xs btn-default" onclick="homeDrugs.add()"><i class="fa fa-plus"></i> Добавить</button>
                </span>
              </div>
              <table class="hd-table" style="display:none">
                <thead><tr><th>Препарат</th><th>Доза</th><th style="text-align:center">Утро</th><th style="text-align:center">Обед</th><th style="text-align:center">Вечер</th><th>Приём</th><th>Дней</th><th></th></tr></thead>
                <tbody></tbody>
              </table>
              <div class="hd-empty">Нет препаратов. Если таблица пустая, пациент увидит только текст рекомендаций, без напоминаний.</div>
              <div class="hd-follow">
                Повторный приём через <input type="number" id="hdFollowDays" class="form-control" style="width:80px" min="1" max="365"/> дней, к врачу
                <input type="text" id="hdFollowDoctor" class="form-control" style="width:260px" maxlength="255" placeholder="например, кардиолог"/>
                <span class="hd-hint" style="color:#6B7280;font-size:12px">напомним за день</span>
              </div>
            </div>
        </div>
        </c:if>
        <div class="ld-l">
            <c:if test="${!dieFlag}">
              Рекомендовано:
            </c:if>
            <c:if test="${dieFlag}">
              Посмертный диагноз:
            </c:if>
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('vyp_c7', 'c7'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('vyp_c7', 'c7'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
            <a title="Распечатать рекомендацию" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="printRecommend(); return false;">
              <span class="fa fa-print"></span>
            </a>
        </div>
        <div class="ld-f"><textarea id="c7" name="c7" style="display:none" rows="8" cols="2">${doc.c7}</textarea>
        </div>
      
    </div>
    <div style="display:none">
      <button id=saveBtn type="button" onclick="saveDoc()">Сохранить</button>
    </div>
  </form>
</div>
