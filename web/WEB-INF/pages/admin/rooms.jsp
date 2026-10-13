<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<style>
  table.fm-grid th, table.fm-grid td { white-space:nowrap; }
  table.fm-grid tr.fl-first td { border-top:2px solid #E6E8EC; }
  .rm-in { width:100%; min-width:90px; height:30px; padding:0 8px; border:1px solid transparent; border-radius:8px; background:#F8F9FB;
    text-align:right; font:inherit; font-variant-numeric:tabular-nums; color:#1F2430; }
  .rm-in:hover { border-color:#E6E8EC; background:#fff; }
  .rm-in:focus { outline:none; border-color:#4B5563; background:#fff; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .rm-in.lim { min-width:60px; text-align:center; }
  .rm-in.saving { opacity:.5; }
  .rm-in.saved { border-color:#9ED9B8; background:#F1FAF5; }
  .rm-in.bad { border-color:#F3C5CB; background:#FDECEE; }
  .rm-type { display:inline-block; padding:0 7px; border-radius:6px; background:#EEF1F6; color:#3C4A63; font-size:11.5px; font-weight:600; line-height:18px; }
  table.fm-grid th.grp { text-align:center; border-left:1px solid #E6E8EC; }
  table.fm-grid td.gl, table.fm-grid th.gl { border-left:1px solid #F0F1F4; }
</style>

<div class="fm-page fm-admin">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-building-o"></i></span>
        <div>
          <h2>Палаты</h2>
          <span class="fm-count"><b id="rmShown">${fn:length(rows)}</b> из <b>${fn:length(rows)}</b> · цены за сутки, изменения сохраняются сразу</span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="rmFloor"><button type="button" data-v="" class="on">Все этажи</button></div>
      <div class="fm-seg" id="rmType"><button type="button" data-v="" class="on">Все типы</button></div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="rmSearch" placeholder="Палата или этаж" oninput="rmFilter()" autocomplete="off"/>
      </div>
    </div>

    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:80px">Этаж</th>
          <th style="width:110px">Тип</th>
          <th style="width:80px">Палата</th>
          <th style="width:80px" class="c">Лимит</th>
          <th class="r gl">Цена</th>
          <th class="r">Цена (не рез.)</th>
          <th class="r gl">Уход</th>
          <th class="r">Уход (не рез.)</th>
          <th class="r gl">Бронь</th>
          <th class="r">Бронь (не рез.)</th>
        </tr>
        </thead>
        <tbody id="rmRows">
        <c:set var="prevFloor" value=""/>
        <c:forEach items="${rows}" var="obj">
          <tr class="${prevFloor != '' && prevFloor != obj.floor.name ? 'fl-first' : ''}" data-t="${fn:escapeXml(obj.roomType.name)}" data-fl="${fn:escapeXml(obj.floor.name)}"
              data-s="${fn:toLowerCase(fn:escapeXml(obj.name))} ${fn:toLowerCase(fn:escapeXml(obj.floor.name))}" data-id="${obj.id}">
            <td class="mut">${obj.floor.name}</td>
            <td><span class="rm-type">${obj.roomType.name}</span></td>
            <td><span class="nm">${obj.name}</span></td>
            <td class="c"><input class="rm-in lim" data-f="koykoLimit" data-int="1" value="${obj.koykoLimit}"/></td>
            <td class="gl"><input class="rm-in" data-f="price" value="${obj.price}"/></td>
            <td><input class="rm-in" data-f="for_price" value="${obj.for_price}"/></td>
            <td class="gl"><input class="rm-in" data-f="extra_price" value="${obj.extra_price}"/></td>
            <td><input class="rm-in" data-f="for_extra_price" value="${obj.for_extra_price}"/></td>
            <td class="gl"><input class="rm-in" data-f="bron_price" value="${obj.bron_price}"/></td>
            <td><input class="rm-in" data-f="for_bron_price" value="${obj.for_bron_price}"/></td>
          </tr>
          <c:set var="prevFloor" value="${obj.floor.name}"/>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="rmEmpty" style="display:none"><i class="fa fa-building-o"></i>Палаты не найдены</div>
    </div>
  </div>
</div>

<script>
  // кнопки этажей и типов строятся по самим палатам (в порядке появления)
  (function () {
    $.each([['#rmFloor', 'fl'], ['#rmType', 't']], function (i, p) {
      var seen = {};
      $('#rmRows tr').each(function () {
        var v = String($(this).data(p[1]) || '');
        if (v && !seen[v]) { seen[v] = 1; $(p[0]).append($('<button type="button">').attr('data-v', v).text(v)); }
      });
    });
    $('#rmFloor, #rmType').on('click', 'button', function () {
      $(this).addClass('on').siblings().removeClass('on');
      rmFilter();
    });
  })();
  function rmFilter() {
    var t = $('#rmType button.on').attr('data-v'), fl = $('#rmFloor button.on').attr('data-v'), q = $.trim($('#rmSearch').val()).toLowerCase(), n = 0;
    $('#rmRows tr').each(function () {
      var ok = (!t || String($(this).data('t')) == t) && (!fl || String($(this).data('fl')) == fl) && (!q || String($(this).data('s')).indexOf(q) >= 0);
      $(this).toggle(ok);
      if (ok) n++;
    });
    $('#rmShown').text(n);
    $('#rmEmpty').toggle(n == 0);
  }
  // число из поля: пробелы - разделители тысяч, запятая или точка - дробная часть
  function rmNum(s) {
    s = String(s == null ? '' : s).replace(/[\s ]/g, '').replace(',', '.');
    return s === '' || isNaN(+s) ? null : +s;
  }
  function rmFmt(v, isInt) {
    if (v == null) return '';
    return v.toLocaleString('ru-RU', {minimumFractionDigits: isInt ? 0 : 2, maximumFractionDigits: isInt ? 0 : 2});
  }
  $('#rmRows .rm-in').each(function () {
    var v = rmNum(this.value);
    $(this).data('v', v);
    this.value = rmFmt(v, $(this).data('int'));
  }).on('focus', function () {
    var v = $(this).data('v');
    this.value = v == null ? '' : String(v).replace('.', ',');
    this.select();
  }).on('keydown', function (e) {
    if (e.keyCode === 13) this.blur();
    if (e.keyCode === 27) { this.value = String($(this).data('v') == null ? '' : $(this).data('v')).replace('.', ','); this.blur(); }
  }).on('blur', function () {
    var inp = $(this), isInt = inp.data('int'), old = inp.data('v'), v = rmNum(this.value);
    if (v != null && isInt) v = Math.round(v);
    if (v == null || v < 0) {
      inp.addClass('bad');
      this.value = rmFmt(old, isInt);
      errMsg('Введите число не меньше нуля');
      setTimeout(function () { inp.removeClass('bad'); }, 1500);
      return;
    }
    this.value = rmFmt(v, isInt);
    if (v === old) return;
    inp.addClass('saving');
    $.ajax({
      url: '/admin/room/save.s', method: 'post', dataType: 'json',
      data: {id: inp.closest('tr').data('id'), type: inp.data('f'), value: v},
      success: function (res) {
        if (res.success) {
          inp.data('v', v).addClass('saved');
          openMsg(res);
          setTimeout(function () { inp.removeClass('saved'); }, 1500);
        } else {
          inp.val(rmFmt(old, isInt)).addClass('bad');
          errMsg(res.msg);
          setTimeout(function () { inp.removeClass('bad'); }, 1500);
        }
      },
      complete: function () { inp.removeClass('saving'); }
    });
  });
</script>
