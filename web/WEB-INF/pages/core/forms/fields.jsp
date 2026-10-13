<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="style.jsp"%>
<style>
  .ff-add { display:flex; gap:8px; padding:0 14px 10px; }
  .ff-add .fm-in { max-width:420px; }
  table.fm-grid tbody tr.ff-row { cursor:pointer; }
  table.fm-grid tbody tr.ff-row.open td { background:#F1F4F9; }
  table.fm-grid tbody tr.ff-row.open td:first-child { box-shadow:inset 3px 0 0 #1F2430; }
  table.fm-grid tbody tr.ff-edit > td { height:auto; padding:0; background:#FAFBFC; }
  table.fm-grid tbody tr.ff-edit:hover > td { background:#FAFBFC; }
  .ff-panel { padding:14px 16px 16px; display:grid; grid-template-columns:minmax(0, 3fr) minmax(260px, 2fr); gap:18px; border-bottom:1px solid var(--border); }
  .ff-panel .fm-row { grid-template-columns:repeat(6, minmax(0, 1fr)); }
  .ff-panel .s2 { grid-column:span 2; } .ff-panel .s3 { grid-column:span 3; } .ff-panel .s4 { grid-column:span 4; } .ff-panel .s6 { grid-column:span 6; }
  .ff-opts { display:flex; flex-direction:column; gap:8px; }
  .ff-list { display:flex; flex-wrap:wrap; gap:6px; min-height:30px; padding:6px; border:1px dashed var(--border); border-radius:10px; background:#fff; }
  .ff-opt { display:inline-flex; align-items:center; gap:6px; padding:2px 4px 2px 9px; border-radius:7px; background:#F1F2F4; font-size:12.5px; }
  .ff-opt button { width:20px; height:20px; border:0; border-radius:5px; background:none; color:#9AA1AC; cursor:pointer; }
  .ff-opt button:hover { background:#FDECEE; color:#A50F22; }
  .ff-foot { grid-column:1 / -1; display:flex; gap:8px; align-items:center; }
  .code { font-family:Consolas, monospace; font-size:12px; color:#3C4250; }
  .vals-grid { display:grid; grid-template-columns:repeat(3, minmax(0, 1fr)); gap:4px 10px; }
  .vals-grid label { display:flex; align-items:center; gap:7px; padding:5px 6px; border-radius:7px; font-size:13px; font-weight:400; cursor:pointer; margin:0; }
  .vals-grid label:hover { background:#F5F6F8; }
</style>

<div class="fm-page fm-admin">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-list"></i></span>
        <div>
          <h2>${fn:escapeXml(form.name)}</h2>
          <span class="fm-count">ID ${form.id} · <b>${fn:length(fields)}</b> полей ·
            <span class="tag ${form.amb == 'Y' ? 'amb' : 'stat'}">${form.amb == 'Y' ? 'Амбулатория' : 'Стационар'}</span>
            <span class="flag ${form.normaFlag == 'N' ? 'off' : ''}">Норма</span><span class="flag ${form.eiFlag == 'N' ? 'off' : ''}">Ед.</span><span class="flag ${form.codeFlag == 'Y' ? '' : 'off'}">Код</span>
          </span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <button type="button" class="fm-btn" onclick="fmEdit(${form.id})"><i class="fa fa-pencil"></i>Изменить форму</button>
      <button type="button" class="fm-btn" onclick="setPage('/core/form/list.s')"><i class="fa fa-arrow-left"></i>Назад</button>
    </div>
    <div class="ff-add">
      <input class="fm-in" id="ffNew" placeholder="Наименование нового поля" maxlength="512" onkeydown="if(event.keyCode == 13) ffAdd()"/>
      <button type="button" class="fm-btn primary" onclick="ffAdd()"><i class="fa fa-plus"></i>Добавить поле</button>
    </div>

    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:56px" class="c">№</th>
          <th>Наименование</th>
          <th style="width:90px">Код поля</th>
          <th style="width:100px">Тип</th>
          <th style="width:110px">Ед. изм.</th>
          <th style="width:150px">Норма</th>
          <th style="width:150px">Коды</th>
          <th style="width:76px"></th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${fields}" var="f">
          <tr class="ff-row" id="ffr${f.id}" onclick="ffToggle(${f.id})">
            <td class="c mut">${empty f.ord ? '—' : f.ord}</td>
            <td><span class="nm">${fn:escapeXml(f.field)}</span><c:if test="${f.resFlag != 'Y'}"><span class="pill" style="background:#F1F2F4;color:#6B7280" title="resFlag не стоит">не в результате</span></c:if></td>
            <td><span class="code">${fn:escapeXml(f.fieldCode)}</span></td>
            <td class="mut">${f.fieldType == 'select' ? 'Список' : f.fieldType == 'textarea' ? 'Текст (много)' : f.fieldType == 'text' ? 'Текст' : f.fieldType}<c:if test="${f.fieldType == 'select'}"> · ${fn:length(f.opts)}</c:if></td>
            <td class="${empty f.EI ? 'none' : ''}">${empty f.EI ? '—' : fn:escapeXml(f.EI)}</td>
            <td class="${empty f.normaFrom && empty f.normaTo ? 'none' : ''}">${empty f.normaFrom && empty f.normaTo ? '—' : ''}${fn:escapeXml(f.normaFrom)}<c:if test="${not empty f.normaTo}"> – ${fn:escapeXml(f.normaTo)}</c:if></td>
            <td class="${empty f.codes ? 'none' : ''}">${empty f.codes ? '—' : fn:escapeXml(f.codes)}</td>
            <td class="r">
              <button type="button" class="fm-act" title="Изменить поле" onclick="event.stopPropagation(); ffToggle(${f.id})"><i class="fa fa-pencil"></i></button>
              <button type="button" class="fm-act danger" title="Удалить поле" onclick="event.stopPropagation(); ffRemove(${f.id}, this)"><i class="fa fa-trash-o"></i></button>
            </td>
          </tr>
          <tr class="ff-edit" id="ffe${f.id}" style="display:none">
            <td colspan="8">
              <form id="form${f.id}" class="ff-panel" onsubmit="ffSave(${f.id}); return false;" autocomplete="off">
                <div class="fm-row">
                  <div class="s4"><label class="fm-l">Наименование</label><input class="fm-in" name="field" value="${fn:escapeXml(f.field)}" maxlength="512"/></div>
                  <div class="s2"><label class="fm-l">Код поля</label><input class="fm-in" name="fieldCode" value="${fn:escapeXml(f.fieldCode)}"/></div>
                  <div class="s2"><label class="fm-l">Тип</label>
                    <select class="fm-in" name="fieldType" onchange="ffType(${f.id}, this.value)">
                      <option value=""></option>
                      <option <c:if test="${f.fieldType == 'text'}">selected</c:if> value="text">Текст</option>
                      <option <c:if test="${f.fieldType == 'select'}">selected</c:if> value="select">Список</option>
                      <option <c:if test="${f.fieldType == 'textarea'}">selected</c:if> value="textarea">Текст (много)</option>
                    </select>
                  </div>
                  <div class="s2"><label class="fm-l">Ед. изм.</label><input class="fm-in" name="EI" value="${fn:escapeXml(f.EI)}"/></div>
                  <div class="s2"><label class="fm-l">Очерёдность</label><input class="fm-in" type="number" name="ord" value="${f.ord}"/></div>
                  <div class="s2"><label class="fm-l">Норма с</label><input class="fm-in" name="normaFrom" value="${fn:escapeXml(f.normaFrom)}"/></div>
                  <div class="s2"><label class="fm-l">Норма по</label><input class="fm-in" name="normaTo" value="${fn:escapeXml(f.normaTo)}"/></div>
                  <div class="s2"><label class="fm-l">Коды</label><input class="fm-in" name="codes" value="${fn:escapeXml(f.codes)}" maxlength="512" placeholder="колонка «Код»"/></div>
                  <div class="s6"><label class="fm-l">Значение по умолчанию</label><input class="fm-in" name="defVal" value="${fn:escapeXml(f.defVal)}"/></div>
                  <div class="s2"><label class="fm-l">maxLength</label><input class="fm-in" type="number" name="maxLength" value="${f.maxLength}"/></div>
                  <div class="s2"><label class="fm-l">textCols</label><input class="fm-in" type="number" name="textCols" value="${f.textCols}"/></div>
                  <div class="s2"><label class="fm-l">textRows</label><input class="fm-in" type="number" name="textRows" value="${f.textRows}"/></div>
                  <div class="s3"><label class="fm-l">cssClass</label><input class="fm-in" name="cssClass" value="${fn:escapeXml(f.cssClass)}"/></div>
                  <div class="s3"><label class="fm-l">cssStyle</label><input class="fm-in" name="cssStyle" value="${fn:escapeXml(f.cssStyle)}"/></div>
                  <div class="s6"><label class="fm-chk"><input type="checkbox" name="resFlag" value="Y" <c:if test="${f.resFlag == 'Y'}">checked</c:if>/> Выводить в результат (resFlag)</label></div>
                </div>
                <div class="ff-opts">
                  <label class="fm-l" style="margin:0">Значения списка</label>
                  <div class="ff-list" id="ffl${f.id}">
                    <c:forEach items="${f.opts}" var="v">
                      <span class="ff-opt" id="ffo${f.id}_${v.id}" title="ID ${v.id}">${fn:escapeXml(v.name)}<button type="button" title="Убрать значение" onclick="ffRemoveVal(${f.id}, ${v.id})"><i class="fa fa-times"></i></button></span>
                    </c:forEach>
                    <c:if test="${empty f.opts}"><span class="fm-hint" style="padding:4px">Нет значений</span></c:if>
                  </div>
                  <div style="display:flex; gap:6px">
                    <input class="fm-in" name="selVal" placeholder="Новое значение" onkeydown="if(event.keyCode == 13) { ffSave(${f.id}); return false; }"/>
                    <button type="button" class="fm-btn" data-n="${fn:escapeXml(f.field)}" onclick="ffVals(${f.id}, $(this).data('n'))" title="Выбрать из справочника значений"><i class="fa fa-book"></i>Справочник</button>
                  </div>
                  <span class="fm-hint">Новое значение добавится при сохранении поля.</span>
                </div>
                <div class="ff-foot">
                  <button type="submit" class="fm-btn primary"><i class="fa fa-save"></i>Сохранить поле</button>
                  <button type="button" class="fm-btn" onclick="ffToggle(${f.id})">Свернуть</button>
                  <span class="fm-hint" style="margin-left:auto">ID поля ${f.id}</span>
                </div>
              </form>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <c:if test="${empty fields}">
        <div class="fm-empty"><i class="fa fa-list"></i>В форме ещё нет полей</div>
      </c:if>
    </div>
  </div>
</div>

<div class="fm-overlay fm-admin" id="ffValsWin" onclick="if(event.target == this) fmValsClose()">
  <div class="fm-modal" style="width:820px">
    <div class="fm-modal-head">
      <h3>Значения из справочника<span class="sub" id="ffValsFor"></span></h3>
      <button type="button" class="fm-x" onclick="fmValsClose()"><i class="fa fa-times"></i></button>
    </div>
    <div class="fm-modal-body" id="ffValsBody"></div>
    <div class="fm-modal-foot">
      <input class="fm-in" id="ffValsSearch" placeholder="Поиск значения" style="max-width:260px" oninput="ffValsFilter()"/>
      <span style="flex:1"></span>
      <button type="button" class="fm-btn" onclick="fmValsClose()">Отмена</button>
      <button type="button" class="fm-btn primary" onclick="ffValsSave()"><i class="fa fa-check"></i>Добавить выбранные</button>
    </div>
  </div>
</div>

<%@include file="edit.jsp"%>

<script>
  var ffUrl = '/core/form/fields.s?formId=${form.id}';
  var ffValsField = 0;
  function ffReload(openId) {
    try { if (openId) sessionStorage.setItem('ffOpen', openId); else sessionStorage.removeItem('ffOpen'); } catch (e) {}
    setPage(ffUrl);
  }
  function ffToggle(id) {
    var open = !$('#ffe' + id).is(':visible');
    $('#ffe' + id).toggle(open);
    $('#ffr' + id).toggleClass('open', open);
  }
  function ffType(id, val) {
    var ml = $('#form' + id + ' input[name=maxLength]');
    if (val == 'textarea') ml.val('255');
    if (val == 'text') ml.val('32');
  }
  function ffAdd() {
    var name = $.trim($('#ffNew').val());
    if (!name) { $('#ffNew').focus(); return; }
    $.ajax({
      url: '/core/form/fields/add.s', method: 'post', dataType: 'json', data: {formId: ${form.id}, field: name},
      success: function (res) {
        if (!res.success) { errMsg(res.msg); return; }
        ffReload();
      }
    });
  }
  function ffSave(id) {
    var f = $('#form' + id);
    // числовые поля сервер читает как числа
    f.find('input[type=number]').not('[name=ord]').each(function () { if ($(this).val() === '') $(this).val('0'); });
    $.ajax({
      url: '/core/form/fields/upd.s', method: 'post', dataType: 'json', data: 'id=' + id + '&' + f.serialize(),
      success: function (res) {
        if (!res.success) { errMsg(res.msg); return; }
        openMedMsg('Поле сохранено', true);
        ffReload(id);
      }
    });
  }
  function ffRemove(id, btn) {
    var name = $('#ffr' + id + ' .nm').text();
    FmsConfirm('Удалить поле «' + name + '»? Уже сохранённые результаты по этому полю перестанут выводиться.', function () {
    $.ajax({
      url: '/core/form/removeField.s', method: 'post', dataType: 'json', data: {id: id},
      success: function (res) {
        if (!res.success) { errMsg(res.msg); return; }
        ffReload();
      }
    });
  });
  }
  function ffRemoveVal(fieldId, valId) {
    $.ajax({
      url: '/core/form/fields/removeVal.s', method: 'post', dataType: 'json', data: {fieldId: fieldId, id: valId},
      success: function (res) {
        if (!res.success) { errMsg(res.msg); return; }
        $('#ffo' + fieldId + '_' + valId).remove();
      }
    });
  }
  function ffVals(fieldId, name) {
    ffValsField = fieldId;
    $('#ffValsFor').text(name);
    $('#ffValsSearch').val('');
    $('#ffValsBody').html('<div class="fm-hint">Загрузка...</div>').load('/core/form/fields/vals.s?fieldId=' + fieldId);
    $('#ffValsWin').addClass('open');
  }
  function ffValsFilter() {
    var q = $.trim($('#ffValsSearch').val()).toLowerCase();
    $('#ffValsBody .vals-grid label').each(function () { $(this).toggle(!q || $(this).text().toLowerCase().indexOf(q) >= 0); });
  }
  function ffValsSave() {
    var vals = $('#ffValsBody input:checked').map(function () { return 'val=' + this.value; }).get();
    if (!vals.length) { fmValsClose(); return; }
    $.ajax({
      url: '/core/form/fields/addVals.s', method: 'post', dataType: 'json', data: 'fieldId=' + ffValsField + '&' + vals.join('&'),
      success: function (res) {
        if (!res.success) { errMsg(res.msg); return; }
        fmValsClose();
        ffReload(ffValsField);
      }
    });
  }
  function fmValsClose() { $('#ffValsWin').removeClass('open'); }
  function fmSaved(id, isNew) { setPage(isNew ? '/core/form/fields.s?formId=' + id : ffUrl); }
  (function () {
    var id = null;
    try { id = sessionStorage.getItem('ffOpen'); sessionStorage.removeItem('ffOpen'); } catch (e) {}
    if (id && $('#ffe' + id).length) {
      ffToggle(id);
      var row = document.getElementById('ffr' + id);
      if (row && row.scrollIntoView) row.scrollIntoView({block: 'center'});
    } else {
      $('#ffNew').focus();
    }
  })();
</script>
