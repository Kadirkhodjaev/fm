<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Администрирование → Параметры: цены койко-дня, реквизиты чека, прочие настройки --%>
<%@include file="/WEB-INF/pages/med/mn/mn_style.jsp"%>
<style>
  .pr-grid { display:grid; grid-template-columns:repeat(auto-fill, minmax(460px, 1fr)); gap:12px; align-items:start; }
  .pr-row { display:flex; align-items:center; gap:12px; padding:8px 14px; border-top:1px solid #F0F1F4; }
  .pr-row:first-child { border-top:0; }
  .pr-row .nm { flex:1; font-size:13px; color:#1F2430; }
  .pr-row .nm small { display:block; color:#9AA0AB; font-size:11px; }
  .pr-row .fm-in { width:170px; flex:none; }
  .pr-row .fm-in.num { text-align:right; font-variant-numeric:tabular-nums; }
  .pr-row .fm-in.txt { width:260px; }
  .pr-row.dirty .fm-in { border-color:#F59E0B; background:#FFFBEB; }
  .pr-row.hide { display:none; }
</style>
<div class="fm-page fm-admin">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-sliders"></i></span>
        <div>
          <h2>Параметры</h2>
          <span class="fm-count">изменено <b id="prDirty">0</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="prSearch" placeholder="Параметр" oninput="prFilter()" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn" id="prReload" onclick="prReload()" title="Перечитать из базы роли, меню, справочники, параметры и пользователей (после правок прямо в базе)"><i class="fa fa-refresh"></i>Обновить данные</button>
      <button type="button" class="fm-btn" onclick="setPage('/admin/price.s')"><i class="fa fa-undo"></i>Отменить</button>
      <button type="button" class="fm-btn primary" id="prSave" onclick="prSave()"><i class="fa fa-floppy-o"></i>Сохранить</button>
    </div>
    <div class="fm-table-wrap" style="padding:12px; background:#F7F8FA">
      <form id="prForm" onsubmit="prSave(); return false">
        <div class="pr-grid">
          <c:forTokens items="KOYKA,EXTRA,BRON,CHECK,OTHER" delims="," var="grp">
            <div class="mn-card">
              <div class="mn-card-h">
                <c:choose>
                  <c:when test="${grp == 'KOYKA'}"><i class="fa fa-building-o"></i>Палаты, стоимость за 1 койко-день</c:when>
                  <c:when test="${grp == 'EXTRA'}"><i class="fa fa-users"></i>Ухаживающие, за 1 койко-день</c:when>
                  <c:when test="${grp == 'BRON'}"><i class="fa fa-calendar"></i>Бронирование, за 1 койко-день</c:when>
                  <c:when test="${grp == 'CHECK'}"><i class="fa fa-print"></i>Реквизиты для чека</c:when>
                  <c:otherwise><i class="fa fa-cog"></i>Прочее</c:otherwise>
                </c:choose>
              </div>
              <c:forEach items="${prices}" var="s">
                <c:set var="g" value="OTHER"/>
                <c:if test="${fn:startsWith(s.code, 'KOYKA')}"><c:set var="g" value="KOYKA"/></c:if>
                <c:if test="${fn:startsWith(s.code, 'EXTRA')}"><c:set var="g" value="EXTRA"/></c:if>
                <c:if test="${fn:startsWith(s.code, 'BRON')}"><c:set var="g" value="BRON"/></c:if>
                <c:if test="${s.fieldType == 'STRING'}"><c:set var="g" value="CHECK"/></c:if>
                <c:if test="${g == grp}">
                  <div class="pr-row" data-s="${fn:escapeXml(s.name)} ${s.code}">
                    <input type="hidden" name="code" value="${s.code}"/>
                    <div class="nm">${s.name}</div>
                    <c:choose>
                      <c:when test="${s.fieldType == 'NUMBER'}">
                        <input type="text" class="fm-in num" name="price" inputmode="decimal" value="${s.val}" data-o="${s.val}" autocomplete="off"/>
                      </c:when>
                      <c:otherwise>
                        <input type="text" class="fm-in txt" name="price" value="${fn:escapeXml(s.val)}" data-o="${fn:escapeXml(s.val)}" autocomplete="off"/>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </c:if>
              </c:forEach>
            </div>
          </c:forTokens>
        </div>
      </form>
    </div>
  </div>
</div>
<script>
  (function () {
    // числа показываются с пробелами между разрядами, на сервер уходят без них
    function fmt(v) {
      v = String(v).replace(/[\s ]/g, '').replace(',', '.');
      if (v === '' || isNaN(v)) return v;
      var p = v.split('.'), d = p[1] && /[1-9]/.test(p[1]) ? '.' + p[1].replace(/0+$/, '') : '';
      return p[0].replace(/\B(?=(\d{3})+(?!\d))/g, ' ') + d;
    }
    function raw(v) { return String(v).replace(/[\s ]/g, '').replace(',', '.'); }
    function same(inp) {
      var a = inp.value, b = $(inp).attr('data-o');
      return $(inp).hasClass('num') ? Number(raw(a)) === Number(raw(b)) && raw(a) !== '' : $.trim(a) === $.trim(b);
    }
    window.prMark = function () {
      var n = 0;
      $('#prForm .pr-row').each(function () {
        var d = !same($(this).find('[name=price]')[0]);
        $(this).toggleClass('dirty', d);
        if (d) n++;
      });
      $('#prDirty').text(n);
      return n;
    };
    window.prFilter = function () {
      var q = $.trim($('#prSearch').val()).toLowerCase();
      $('#prForm .pr-row').each(function () { $(this).toggleClass('hide', q !== '' && String($(this).attr('data-s')).toLowerCase().indexOf(q) < 0); });
      $('#prForm .mn-card').each(function () { $(this).toggle($(this).find('.pr-row:not(.hide)').length > 0); });
    };
    window.prSave = function () {
      var bad = null;
      $('#prForm .fm-in.num').each(function () { var v = raw(this.value); if (!bad && (v === '' || isNaN(v) || Number(v) < 0)) bad = this; });
      if (bad) { FmsToast.show('Неверное число: ' + $(bad).closest('.pr-row').find('.nm').text(), 'err'); bad.focus(); return; }
      if (!prMark()) { FmsToast.show('Изменений нет', 'info'); return; }
      var data = $('#prForm').find('[name=code], [name=price]').map(function () {
        var v = this.name == 'price' && $(this).hasClass('num') ? raw(this.value) : this.value;
        return encodeURIComponent(this.name) + '=' + encodeURIComponent(v);
      }).get().join('&');
      $('#prSave').prop('disabled', true);
      $.ajax({
        url: '/admin/price.s', method: 'post', data: data, dataType: 'json',
        success: function (res) {
          if (res.success) {
            FmsToast.show('Сохранено: ' + res.changed, 'ok');
            $('#prForm .fm-in').each(function () { $(this).attr('data-o', $(this).hasClass('num') ? raw(this.value) : this.value); });
            prMark();
          } else FmsToast.show(res.msg, 'err');
        },
        complete: function () { $('#prSave').prop('disabled', false); }
      });
    };
    window.prReload = function () {
      var b = $('#prReload').prop('disabled', true);
      b.find('.fa').addClass('fa-spin');
      $.ajax({
        url: '/admin/reload.s', method: 'post', dataType: 'json',
        success: function (res) {
          if (res.success) FmsToast.show('Данные обновлены. Меню обновится после перезагрузки страницы (F5)', 'ok');
          else FmsToast.show(res.msg || 'Не удалось обновить', 'err');
        },
        complete: function () { b.prop('disabled', false).find('.fa').removeClass('fa-spin'); }
      });
    };
    $('#prForm .fm-in.num').each(function () { this.value = fmt(this.value); })
      .on('blur', function () { this.value = fmt(this.value); });
    $('#prForm .fm-in').on('input', prMark);
  })();
</script>
