<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Администрирование → Пакеты услуг → карточка пакета: реквизиты, услуги пакета со скидкой --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<style>
  .pv-wrap { max-width:1200px; margin:0 auto; padding:12px; display:flex; flex-direction:column; gap:12px; }
  .pv-card { background:#fff; border:1px solid #E6E8EC; border-radius:14px; }
  .pv-h { display:flex; align-items:center; gap:10px; padding:11px 16px; border-bottom:1px solid #F0F1F4; font-weight:700; font-size:14px; flex-wrap:wrap; }
  .pv-h small { font-weight:500; color:#9AA1AC; font-size:12px; }
  .pv-h .fm-spacer { flex:1; }
  .pv-b { padding:14px 16px; }
  .pv-form { display:grid; grid-template-columns:2fr 1fr 1fr auto; gap:12px; align-items:end; }
  .pv-form .s4 { grid-column:span 4; }
  .pv-tiles { display:grid; grid-template-columns:repeat(4, 1fr); gap:10px; }
  .pv-tiles > div { border:1px solid #E6E8EC; border-radius:12px; padding:10px 14px; background:#FAFBFC; }
  .pv-tiles .k { font-size:12px; color:#6B7280; }
  .pv-tiles .v { font-size:18px; font-weight:700; font-variant-numeric:tabular-nums; margin-top:2px; }
  .pv-tiles .eq { background:#EEF4FF; border-color:#D5E2FB; }
  .pv-tiles .sale .v { color:#B45309; }
  .pv-add { display:flex; gap:10px; align-items:center; padding:12px 16px; border-bottom:1px solid #F0F1F4; background:#FAFBFC; }
  .pv-add .fms-sel, .pv-add select { flex:1; }
  .pv-num { text-align:right; white-space:nowrap; font-variant-numeric:tabular-nums; }
  .pv-old { color:#9AA1AC; }
  .pv-proc { width:80px; text-align:right; }
</style>
<div class="fm-page fm-admin">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-medkit"></i></span>
        <div>
          <h2>${obj.id > 0 ? fn:escapeXml(obj.name) : 'Новый пакет'}</h2>
          <span class="fm-count"><c:choose><c:when test="${obj.id > 0}">услуг <b>${fn:length(rows)}</b> · ${obj.ambStat == 'STAT' ? 'стационар' : 'амбулатория'}</c:when><c:otherwise>сначала сохраните реквизиты, затем добавьте услуги</c:otherwise></c:choose></span>
        </div>
      </div>
      <c:if test="${obj.id > 0}"><span class="dk-st ${obj.state == 'A' ? 'A' : 'P'}">${obj.state == 'A' ? 'Активный' : 'Пассивный'}</span></c:if>
      <span class="fm-spacer"></span>
      <button type="button" class="fm-btn primary" id="pvSaveBtn" onclick="savePackage()"><i class="fa fa-check"></i>${obj.id > 0 ? 'Сохранить' : 'Создать'}</button>
      <button type="button" class="fm-btn" onclick="setPage('/admin/pack/index.s')"><i class="fa fa-arrow-left"></i>Назад</button>
    </div>
    <div class="fm-table-wrap" style="background:#F7F8FA">
      <div class="pv-wrap">
        <div class="pv-card">
          <div class="pv-h">Реквизиты</div>
          <div class="pv-b">
            <div class="fm-err" id="pvErr" style="margin-bottom:12px"></div>
            <form id="addEditForm" class="pv-form" onsubmit="savePackage(); return false" autocomplete="off">
              <input type="hidden" name="id" value="${obj.id}"/>
              <div><label class="fm-l">Наименование *</label><input class="fm-in" type="text" maxlength="512" value="${fn:escapeXml(obj.name)}" name="name"/></div>
              <div><label class="fm-l">Действует с</label><input name="start" id="date_start" type="text" class="fm-in datepicker" style="text-align:center" value="<fmt:formatDate pattern="dd.MM.yyyy" value="${obj.start}"/>"/></div>
              <div><label class="fm-l">по <span style="font-weight:400; color:#9AA1AC">(пусто — без срока)</span></label><input name="end" id="date_end" type="text" class="fm-in datepicker" style="text-align:center" value="<fmt:formatDate pattern="dd.MM.yyyy" value="${obj.end}"/>"/></div>
              <div class="fm-state">
                <label><input type="radio" class="a" name="state" value="A" <c:if test="${obj.id == null || obj.id == 0 || obj.state == 'A'}">checked</c:if>/><span>Активный</span></label>
                <label><input type="radio" class="p" name="state" value="" <c:if test="${obj.id > 0 && obj.state != 'A'}">checked</c:if>/><span>Пассивный</span></label>
              </div>
              <div class="s4"><label class="fm-l">Описание</label><textarea class="fm-in" maxlength="2000" name="text" rows="2">${fn:escapeXml(obj.text)}</textarea></div>
            </form>
          </div>
        </div>

        <c:if test="${obj.id > 0}">
          <div class="pv-tiles">
            <div><div class="k">Без скидки</div><div class="v"><fmt:formatNumber value="${real_summ}" pattern="#,##0.##"/></div></div>
            <div class="sale"><div class="k">Скидка</div><div class="v"><fmt:formatNumber value="${real_summ - summ}" pattern="#,##0.##"/><c:if test="${real_summ > 0}"> <span style="font-size:13px">· <fmt:formatNumber value="${(real_summ - summ) * 100 / real_summ}" pattern="#0.#"/>%</span></c:if></div></div>
            <div><div class="k">Стоимость пакета</div><div class="v"><fmt:formatNumber value="${summ}" pattern="#,##0.##"/></div></div>
            <div class="eq"><div class="k">С НДС (${ndsProc}%)</div><div class="v"><fmt:formatNumber value="${summ * (100 + ndsProc) / 100}" pattern="#,##0.##"/></div></div>
          </div>

          <div class="pv-card">
            <div class="pv-h">Услуги пакета <small>скидка задаётся в процентах для каждой услуги, Enter или выход из поля сохраняет</small></div>
            <div class="pv-add">
              <select class="fm-in fms-select" id="kdo_id">
                <option value="">Выберите услугу, чтобы добавить</option>
                <c:choose>
                  <c:when test="${obj.ambStat == 'STAT'}">
                    <c:forEach items="${kdos}" var="cc">
                      <option value="${cc.id}">${cc.name} (${cc.kdoType.name} · <fmt:formatNumber pattern="#,##0.##" value="${cc.price}"/> сум)</option>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <c:forEach items="${services}" var="cc">
                      <option value="${cc.id}">${cc.name} (${cc.group.name} · <fmt:formatNumber pattern="#,##0.##" value="${cc.price}"/> сум)</option>
                    </c:forEach>
                  </c:otherwise>
                </c:choose>
              </select>
              <button type="button" class="fm-btn primary" id="pvAddBtn" onclick="addKdo()"><i class="fa fa-plus"></i>Добавить</button>
            </div>
            <table class="fm-grid">
              <thead>
              <tr>
                <th style="width:50px">№</th>
                <th>Услуга</th>
                <th class="r" style="width:140px">Цена</th>
                <th class="r" style="width:120px">Скидка, %</th>
                <th class="r" style="width:140px">В пакете</th>
                <th class="r" style="width:140px">С НДС</th>
                <th style="width:50px"></th>
              </tr>
              </thead>
              <tbody>
              <c:forEach items="${rows}" var="rw" varStatus="loop">
                <tr>
                  <td class="mut">${loop.index + 1}</td>
                  <td>${rw.name}</td>
                  <td class="pv-num pv-old"><fmt:formatNumber pattern="#,##0.##" value="${rw.claimCount}"/></td>
                  <td class="r"><input class="fm-in pv-proc" type="text" inputmode="decimal" value="<fmt:formatNumber pattern="#0.##" value="${rw.drugCount}"/>" data-o="<fmt:formatNumber pattern="#0.##" value="${rw.drugCount}"/>" onkeydown="if (event.keyCode == 13) this.blur()" onblur="setKdoPrice(${rw.id}, this)"/></td>
                  <td class="pv-num"><b><fmt:formatNumber pattern="#,##0.##" value="${rw.price}"/></b></td>
                  <td class="pv-num"><fmt:formatNumber pattern="#,##0.##" value="${rw.price * (100 + ndsProc) / 100}"/></td>
                  <td class="r"><button type="button" class="fm-act danger" title="Убрать из пакета" onclick="delKdo(${rw.id})"><i class="fa fa-trash-o"></i></button></td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
            <c:if test="${empty rows}"><div class="fm-empty" style="display:block"><i class="fa fa-medkit"></i>В пакете пока нет услуг</div></c:if>
          </div>
        </c:if>
      </div>
    </div>
  </div>
</div>
<script>
  var PID = '${obj.id}';
  function pvReload(id) { setPage('/admin/pack/info.s?id=' + (id || PID)); }
  function setKdoPrice(id, dom) {
    var v = $.trim(dom.value).replace(',', '.');
    if (v === $(dom).attr('data-o')) return;
    if (v === '' || isNaN(v) || Number(v) < 0 || Number(v) > 100) { FmsToast.show('Скидка от 0 до 100%', 'err'); dom.value = $(dom).attr('data-o'); return; }
    $.ajax({
      url: '/admin/pack/price.s', method: 'post', data: 'id=' + id + '&proc=' + encodeURIComponent(v), dataType: 'json',
      success: function (res) { if (res.success) { FmsToast.show('Скидка сохранена', 'ok'); pvReload(); } else { FmsToast.show(res.msg, 'err'); dom.value = $(dom).attr('data-o'); } }
    });
  }
  function savePackage() {
    var f = document.getElementById('addEditForm');
    if (!$.trim(f.elements['name'].value)) { DK.err('pv', 'Укажите наименование'); f.elements['name'].focus(); return; }
    $('#pvErr').hide();
    $('#pvSaveBtn').prop('disabled', true);
    var data = $(f).serializeArray().filter(function (o) { return !(o.name == 'state' && o.value === ''); });
    $.ajax({
      url: '/admin/pack/info.s', method: 'post', data: $.param(data), dataType: 'json',
      success: function (res) { if (res.success) { openMsg(res); pvReload(res.id); } else DK.err('pv', res.msg); },
      complete: function () { $('#pvSaveBtn').prop('disabled', false); }
    });
  }
  function addKdo() {
    var v = $('#kdo_id').val();
    if (!v) { FmsToast.show('Выберите услугу', 'info'); return; }
    $('#pvAddBtn').prop('disabled', true);
    $.ajax({
      url: '/admin/pack/add.s', method: 'post', data: 'id=' + PID + '&kdo=' + v, dataType: 'json',
      success: function (res) { if (res.success) { FmsToast.show('Услуга добавлена', 'ok'); pvReload(); } else { FmsToast.show(res.msg, 'err'); $('#pvAddBtn').prop('disabled', false); } },
      error: function () { $('#pvAddBtn').prop('disabled', false); }
    });
  }
  function delKdo(id) {
    FmsConfirm('Убрать услугу из пакета?', function () {
      $.ajax({
        url: '/admin/pack/del.s', method: 'post', data: 'id=' + id, dataType: 'json',
        success: function (res) { if (res.success) { FmsToast.show('Услуга убрана', 'ok'); pvReload(); } else FmsToast.show(res.msg, 'err'); }
      });
    }, {danger: true, ok: 'Убрать'});
  }
</script>
