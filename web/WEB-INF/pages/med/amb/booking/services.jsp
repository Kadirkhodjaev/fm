<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Бронирование → добавление услуг в бронь: группы кнопками, поиск по всем услугам, итог выбранного --%>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<style>
  .sv-wrap { display:grid; grid-template-columns:1fr 320px; gap:12px; padding:12px; background:#F7F8FA; align-items:start; min-height:100%; }
  .sv-list { background:#fff; border:1px solid #E6E8EC; border-radius:14px; overflow:hidden; }
  .sv-grp { padding:8px 14px 4px; font-size:11px; font-weight:600; color:#9AA1AC; text-transform:uppercase; letter-spacing:.4px; background:#FAFBFC; border-top:1px solid #F0F1F4; }
  .sv-grp:first-child { border-top:0; }
  .sv-it { display:flex; align-items:center; gap:10px; margin:0; padding:7px 14px; border-top:1px solid #F5F6F8; cursor:pointer; font-weight:400; font-size:13.5px; }
  .sv-it:hover { background:#F7F9FC; }
  .sv-it input { width:16px; height:16px; margin:0; accent-color:#1F2430; }
  .sv-it .nm { flex:1; }
  .sv-it .pr { font-variant-numeric:tabular-nums; color:#374151; white-space:nowrap; }
  .sv-it.on { background:#EEF4FF; }
  .sv-sale { display:inline-block; margin-left:6px; padding:1px 8px; border-radius:999px; background:#FEF3E2; color:#B45309; font-size:12px; font-weight:700; }
  .sv-side { position:sticky; top:12px; background:#fff; border:1px solid #E6E8EC; border-radius:14px; }
  .sv-side h4 { margin:0; padding:12px 14px; border-bottom:1px solid #F0F1F4; font-size:14px; font-weight:700; }
  .sv-side ul { list-style:none; margin:0; padding:6px 0; max-height:calc(100vh - 330px); overflow:auto; }
  .sv-side li { display:flex; gap:8px; padding:4px 14px; font-size:12.5px; }
  .sv-side li span { flex:1; }
  .sv-side li b { font-weight:600; white-space:nowrap; font-variant-numeric:tabular-nums; }
  .sv-side .tot { display:flex; padding:12px 14px; border-top:1px solid #F0F1F4; font-weight:700; font-size:15px; }
  .sv-side .tot span { flex:1; }
  .sv-side .none { color:#9AA1AC; padding:10px 14px; }
</style>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-stethoscope"></i></span>
        <div>
          <h2>Услуги в бронь</h2>
          <span class="fm-count">выбрано <b id="svCnt">0</b></span>
        </div>
      </div>
      <div class="fm-seg" id="svSeg" style="flex-wrap:wrap">
        <button type="button" data-g="" class="on" onclick="svSeg(this)">Все</button>
        <c:forEach items="${groups}" var="g">
          <button type="button" data-g="${g.group.id}" onclick="svSeg(this)">${g.group.name}</button>
        </c:forEach>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="svSearch" placeholder="Поиск услуги" oninput="svFilter()" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn primary" id="svSaveBtn" onclick="saveServices()"><i class="fa fa-plus"></i>Добавить</button>
      <button type="button" class="fm-btn" onclick="setPage('/amb/booking.s?id=${id}')"><i class="fa fa-arrow-left"></i>Назад</button>
    </div>
    <div class="fm-table-wrap" style="padding:0">
      <form id="services" class="sv-wrap" onsubmit="saveServices(); return false">
        <input type="hidden" name="id" value="${id}">
        <div class="sv-list" id="svList">
          <c:forEach items="${groups}" var="g">
            <div class="sv-grp" data-g="${g.group.id}">${g.group.name}</div>
            <c:forEach items="${g.services}" var="k">
              <label class="sv-it" data-g="${g.group.id}" data-s="${fn:toLowerCase(fn:escapeXml(k.name))}" data-p="${k.price}">
                <input type="checkbox" value="${k.id}" name="ids" onchange="svSum()">
                <span class="nm">${k.name}<c:if test="${k.saleProc > 0}"><span class="sv-sale">акция −${k.saleProc}%</span></c:if></span>
                <span class="pr"><fmt:formatNumber pattern="#,##0.##" value="${k.price}"/></span>
              </label>
            </c:forEach>
          </c:forEach>
          <div class="fm-empty" id="svEmpty" style="display:none"><i class="fa fa-search"></i>Ничего не найдено</div>
        </div>
        <div class="sv-side">
          <h4>Выбранные услуги</h4>
          <ul id="svSel"><li class="none">Отметьте услуги слева</li></ul>
          <div class="tot"><span>Итого</span><b id="svTotal">0</b></div>
        </div>
      </form>
    </div>
  </div>
</div>
<script>
  function svFmt(n) { return (Math.round(n * 100) / 100).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ' '); }
  function svSeg(b) { $(b).addClass('on').siblings().removeClass('on'); svFilter(); }
  function svFilter() {
    var g = $('#svSeg button.on').attr('data-g'), q = $.trim($('#svSearch').val()).toLowerCase(), n = 0;
    $('#svList .sv-it').each(function () {
      var ok = (!g || $(this).attr('data-g') == g) && (!q || $(this).attr('data-s').indexOf(q) >= 0);
      $(this).toggle(ok);
      if (ok) n++;
    });
    $('#svList .sv-grp').each(function () { var gg = $(this).attr('data-g'); $(this).toggle($('#svList .sv-it[data-g=' + gg + ']:visible').length > 0); });
    $('#svEmpty').toggle(n == 0);
  }
  function svSum() {
    var h = [], t = 0, n = 0;
    $('#svList .sv-it').each(function () {
      var on = $(this).find('input').is(':checked');
      $(this).toggleClass('on', on);
      if (!on) return;
      var p = parseFloat($(this).attr('data-p')) || 0;
      t += p; n++;
      h.push('<li><span>' + $(this).find('.nm').clone().children().remove().end().text() + '</span><b>' + svFmt(p) + '</b></li>');
    });
    $('#svSel').html(n ? h.join('') : '<li class="none">Отметьте услуги слева</li>');
    $('#svCnt').text(n);
    $('#svTotal').text(svFmt(t));
  }
  function saveServices() {
    if (!$('#svList input:checked').length) { FmsToast.show('Отметьте хотя бы одну услугу', 'info'); return; }
    $('#svSaveBtn').prop('disabled', true);
    $.ajax({
      url: '/amb/booking/services.s', method: 'post', data: $('#services').serialize(), dataType: 'json',
      success: function (res) {
        if (res.success === false) { FmsToast.show(res.msg || 'Не удалось добавить', 'err'); $('#svSaveBtn').prop('disabled', false); return; }
        setPage('/amb/booking.s?id=${id}');
      },
      error: function () { $('#svSaveBtn').prop('disabled', false); }
    });
  }
  $('#svSearch').focus();
</script>
