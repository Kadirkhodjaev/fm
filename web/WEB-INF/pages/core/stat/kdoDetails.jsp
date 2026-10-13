<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Администрирование → Детали лаб: цены показателей лабораторных исследований --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<style>
  .kd-num { text-align:right; white-space:nowrap; font-variant-numeric:tabular-nums; }
  .kd-num.z { color:#C0C5CE; }
  .kd-grp { display:inline-block; padding:2px 8px; border-radius:6px; background:#F1F2F4; color:#4B5563; font-size:12px; white-space:nowrap; }
  .kd-pr { display:grid; grid-template-columns:1fr 1fr; gap:12px; }
  .kd-pr .fm-in { text-align:right; font-variant-numeric:tabular-nums; }
  .kd-sub { color:#9AA0AB; font-size:12px; margin-top:-6px; }
</style>
<div class="fm-page fm-admin">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-flask"></i></span>
        <div>
          <h2>Детали лаб</h2>
          <span class="fm-count"><b id="kdShown">${fn:length(services)}</b> из <b>${fn:length(services)}</b> показателей</span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="kdSeg">
        <button type="button" data-f="" class="on" onclick="DK.seg('kd', this)">Все</button>
        <c:set var="prevKdo" value=""/>
        <c:forEach items="${services}" var="s">
          <c:if test="${s.kdo.id != prevKdo}">
            <button type="button" data-f="${s.kdo.id}" onclick="DK.seg('kd', this)">${s.kdo.name}</button>
            <c:set var="prevKdo" value="${s.kdo.id}"/>
          </c:if>
        </c:forEach>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="kdSearch" placeholder="Показатель" oninput="DK.filter('kd')" autocomplete="off"/>
      </div>
    </div>
    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:50px">#</th>
          <th style="width:220px">Исследование</th>
          <th>Показатель</th>
          <th class="r" style="width:140px">Цена</th>
          <th class="r" style="width:140px">Цена (нерез.)</th>
          <th class="r" style="width:150px">Реальная стоимость</th>
          <th class="r" style="width:150px">Реальная (нерез.)</th>
          <th style="width:50px"></th>
        </tr>
        </thead>
        <tbody id="kdRows">
        <c:forEach items="${services}" var="s" varStatus="loop">
          <tr data-f="${s.kdo.id}" data-s="${fn:escapeXml(s.name)} ${fn:escapeXml(s.kdo.name)}" onclick="kdEdit(this)" title="Изменить цены"
              data-id="${s.id}" data-nm="${fn:escapeXml(s.name)}" data-kdo="${fn:escapeXml(s.kdo.name)}"
              data-p1="${s.price}" data-p2="${s.for_price}" data-p3="${s.real_price}" data-p4="${s.for_real_price}">
            <td class="mut">${loop.index + 1}</td>
            <td><span class="kd-grp">${s.kdo.name}</span></td>
            <td><span class="nm">${s.name}</span></td>
            <td class="kd-num${empty s.price || s.price == 0 ? ' z' : ''}"><fmt:formatNumber value="${s.price}" pattern="#,##0.##"/></td>
            <td class="kd-num${empty s.for_price || s.for_price == 0 ? ' z' : ''}"><fmt:formatNumber value="${s.for_price}" pattern="#,##0.##"/></td>
            <td class="kd-num${empty s.real_price || s.real_price == 0 ? ' z' : ''}"><fmt:formatNumber value="${s.real_price}" pattern="#,##0.##"/></td>
            <td class="kd-num${empty s.for_real_price || s.for_real_price == 0 ? ' z' : ''}"><fmt:formatNumber value="${s.for_real_price}" pattern="#,##0.##"/></td>
            <td class="r"><button type="button" class="fm-act" title="Изменить"><i class="fa fa-pencil"></i></button></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="kdEmpty" style="display:none"><i class="fa fa-flask"></i>Ничего не найдено</div>
    </div>
  </div>
</div>

<div class="fm-overlay fm-admin" id="kdModal" onclick="if (event.target === this) DK.close('kd')">
  <div class="fm-modal" style="width:520px">
    <div class="fm-modal-head">
      <h3 id="kdTitle"></h3>
      <button type="button" class="fm-x" onclick="DK.close('kd')"><i class="fa fa-times"></i></button>
    </div>
    <form id="kdForm" onsubmit="kdSave(); return false">
      <div class="fm-modal-body">
        <input type="hidden" name="id"/>
        <div class="kd-sub" id="kdSub"></div>
        <div class="fm-err" id="kdErr"></div>
        <div class="kd-pr">
          <div><label class="fm-l">Цена (резиденты) *</label><input type="text" class="fm-in" name="price" inputmode="decimal" autocomplete="off"/></div>
          <div><label class="fm-l">Цена (нерезиденты) *</label><input type="text" class="fm-in" name="for_price" inputmode="decimal" autocomplete="off"/></div>
          <div><label class="fm-l">Реальная стоимость *</label><input type="text" class="fm-in" name="real_price" inputmode="decimal" autocomplete="off"/></div>
          <div><label class="fm-l">Реальная (нерезиденты) *</label><input type="text" class="fm-in" name="for_real_price" inputmode="decimal" autocomplete="off"/></div>
        </div>
      </div>
      <div class="fm-modal-foot">
        <span class="fm-spacer"></span>
        <button type="button" class="fm-btn" onclick="DK.close('kd')">Отмена</button>
        <button type="submit" class="fm-btn primary" id="kdSaveBtn"><i class="fa fa-floppy-o"></i>Сохранить</button>
      </div>
    </form>
  </div>
</div>
<script>
  (function () {
    var F = ['price', 'for_price', 'real_price', 'for_real_price'];
    function raw(v) { return String(v == null ? '' : v).replace(/[\s ]/g, '').replace(',', '.'); }
    function fmt(v) {
      v = raw(v);
      if (v === '' || isNaN(v)) return v;
      var p = v.split('.'), d = p[1] && /[1-9]/.test(p[1]) ? '.' + p[1].replace(/0+$/, '') : '';
      return p[0].replace(/\B(?=(\d{3})+(?!\d))/g, ' ') + d;
    }
    window.kdEdit = function (tr) {
      var f = document.getElementById('kdForm'), t = $(tr);
      f.reset();
      f.elements['id'].value = t.attr('data-id');
      for (var i = 0; i < F.length; i++) f.elements[F[i]].value = fmt(t.attr('data-p' + (i + 1)));
      $('#kdSub').text(t.attr('data-kdo'));
      DK.open('kd', t.attr('data-nm'));
      f.elements['price'].select();
    };
    window.kdSave = function () {
      var f = document.getElementById('kdForm'), data = 'id=' + encodeURIComponent(f.elements['id'].value);
      for (var i = 0; i < F.length; i++) {
        var v = raw(f.elements[F[i]].value);
        if (v === '' || isNaN(v) || Number(v) < 0) { DK.err('kd', 'Неверная сумма'); f.elements[F[i]].focus(); return; }
        data += '&' + F[i] + '=' + encodeURIComponent(v);
      }
      $('#kdSaveBtn').prop('disabled', true);
      $.ajax({
        url: '/core/stat/details.s', method: 'post', data: data, dataType: 'json',
        success: function (res) {
          if (res.success) { openMsg(res); DK.close('kd'); setPage('/core/stat/details.s'); }
          else DK.err('kd', res.msg);
        },
        complete: function () { $('#kdSaveBtn').prop('disabled', false); }
      });
    };
    $('#kdForm .fm-in').on('blur', function () { this.value = fmt(this.value); });
    DK.filter('kd');
  })();
</script>
