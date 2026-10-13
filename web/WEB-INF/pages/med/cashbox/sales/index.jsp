<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<style>
  .sl-grid td .fm-in { height:30px; }
  .sl-grid td input.datepicker { min-width:0 !important; width:100%; }
  .sl-grid td input.pc { text-align:right; }
  .sl-grid tr.on td { background:#FFF8EC; }
  .sl-grid tr.on:hover td { background:#FFF1D9; }
  .sl-badge { display:inline-block; margin-left:8px; padding:0 7px; border-radius:6px; background:#D92D3C; color:#fff; font-size:11.5px; font-weight:700; line-height:18px; }
  .sl-grid tr.dirty .fm-act.save { background:#1F2430; border-color:#1F2430; color:#fff; }
  .sl-grid .fm-act.save { color:#9AA1AC; }
  .sl-grid tr.dirty .fm-act.save, .sl-grid .fm-act.save:hover { color:#fff; background:#1F2430; border-color:#1F2430; }
  .sl-msg { position:fixed; right:24px; bottom:24px; z-index:2000; display:none; padding:10px 14px; border-radius:10px; background:#1F2430; color:#fff;
    font-size:13px; box-shadow:0 8px 24px rgba(20,25,40,.25); }
  .sl-msg.err { background:#A50F22; }
</style>

<c:set var="cntOn" value="0"/>
<c:forEach items="${services}" var="k"><c:if test="${k.saleProc > 0}"><c:set var="cntOn" value="${cntOn + 1}"/></c:if></c:forEach>

<div class="fm-page fm-admin">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-tags"></i></span>
        <div>
          <h2>Акции · амбулатория</h2>
          <span class="fm-count">услуг <b id="slShown">${fn:length(services)}</b> · с акцией <b>${cntOn}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="slSeg">
        <button type="button" data-f="" class="${cntOn == 0 ? 'on' : ''}" onclick="slSeg(this)">Все</button>
        <button type="button" data-f="Y" class="${cntOn > 0 ? 'on' : ''}" onclick="slSeg(this)">С акцией</button>
      </div>
      <select class="fm-in fms-select" id="slGroup" style="width:220px; height:30px" onchange="slFilter()">
        <option value="">Все группы</option>
      </select>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="slSearch" placeholder="Услуга" oninput="slFilter()" autocomplete="off"/>
      </div>
    </div>

    <div class="fm-table-wrap">
      <table class="fm-grid sl-grid">
        <thead>
        <tr>
          <th style="width:200px">Группа</th>
          <th>Услуга</th>
          <th style="width:110px" class="r">Цена</th>
          <th style="width:160px">Начало</th>
          <th style="width:160px">Окончание</th>
          <th style="width:90px">Скидка, %</th>
          <th style="width:80px"></th>
        </tr>
        </thead>
        <tbody id="slRows">
        <c:forEach items="${services}" var="kdo" varStatus="loop">
          <tr class="${kdo.saleProc > 0 ? 'on' : ''}" data-id="${kdo.id}" data-on="${kdo.saleProc > 0 ? 'Y' : 'N'}"
              data-g="${fn:escapeXml(kdo.group.name)}" data-s="${fn:toLowerCase(fn:escapeXml(kdo.name))}">
            <td class="mut">${kdo.group.name}</td>
            <td><span class="nm">${kdo.name}</span><c:if test="${kdo.saleProc > 0}"><span class="sl-badge">−<fmt:formatNumber value="${kdo.saleProc}" maxFractionDigits="1"/>%</span></c:if></td>
            <td class="r mut"><fmt:formatNumber value="${kdo.price}" type="number" maxFractionDigits="0"/></td>
            <td><input type="text" class="fm-in datepicker st" autocomplete="off" value="<fmt:formatDate pattern="dd.MM.yyyy" value="${kdo.saleStart}"/>"/></td>
            <td><input type="text" class="fm-in datepicker en" autocomplete="off" value="<fmt:formatDate pattern="dd.MM.yyyy" value="${kdo.saleEnd}"/>"/></td>
            <td><input type="number" min="0" max="100" step="0.1" class="fm-in pc" value="${kdo.saleProc > 0 ? kdo.saleProc : ''}"/></td>
            <td class="r">
              <button type="button" class="fm-act save" title="Сохранить акцию" onclick="slSave(this)"><i class="fa fa-check"></i></button>
              <c:if test="${kdo.saleProc > 0}">
                <button type="button" class="fm-act danger" title="Отменить акцию" onclick="slRemove(this)"><i class="fa fa-times"></i></button>
              </c:if>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="slEmpty" style="display:none"><i class="fa fa-tags"></i>Услуги не найдены</div>
    </div>
  </div>
</div>
<div class="sl-msg" id="slMsg"></div>

<script>
  (function () {
    var g = {};
    $('#slRows tr').each(function () { var v = $(this).data('g'); if (v) g[v] = 1; });
    Object.keys(g).sort().forEach(function (v) { $('#slGroup').append($('<option>').val(v).text(v)); });
  })();
  function slSeg(btn) {
    $('#slSeg button').removeClass('on');
    $(btn).addClass('on');
    slFilter();
  }
  function slFilter() {
    var f = $('#slSeg button.on').data('f') || '', grp = $('#slGroup').val();
    var q = $.trim($('#slSearch').val()).toLowerCase(), words = q ? q.split(/\s+/) : [];
    var n = 0;
    $('#slRows tr').each(function () {
      var tr = $(this), s = String(tr.data('s')), ok = (!f || tr.data('on') == f) && (!grp || tr.data('g') == grp);
      for (var i = 0; ok && i < words.length; i++) if (s.indexOf(words[i]) < 0) ok = false;
      tr.toggle(ok);
      if (ok) n++;
    });
    $('#slShown').text(n);
    $('#slEmpty').toggle(n == 0);
  }
  slFilter();
  $('#slRows').on('input change', 'input', function () { $(this).closest('tr').addClass('dirty'); });
  function slMsg(text, err) { FmsToast.show(text, err ? 'err' : 'ok'); }
  function slReload() {
    setPage('/cashbox/sales.s?page=amb');
  }
  function slSave(btn) {
    var tr = $(btn).closest('tr');
    var start = $.trim(tr.find('.st').val()), end = $.trim(tr.find('.en').val()), proc = $.trim(tr.find('.pc').val());
    if (!start || !end || !proc) { slMsg('Укажите начало, окончание и процент скидки', true); return; }
    $.ajax({
      url: '/cashbox/sale/row/save.s', method: 'post', dataType: 'json',
      data: {id: tr.data('id'), start: start, end: end, proc: proc, code: 'amb'},
      success: function (res) {
        if (res.success) { slMsg('Акция сохранена'); slReload(); }
        else slMsg(res.msg, true);
      }
    });
  }
  function slRemove(btn) {
    var tr = $(btn).closest('tr');
    FmsConfirm('Отменить акцию по услуге «' + tr.find('.nm').text() + '»?', function () {
    $.ajax({
      url: '/cashbox/sale/row/remove.s', method: 'post', dataType: 'json',
      data: {id: tr.data('id'), code: 'amb'},
      success: function (res) {
        if (res.success) { slMsg('Акция отменена'); slReload(); }
        else slMsg(res.msg, true);
      }
    });
  });
  }
</script>
