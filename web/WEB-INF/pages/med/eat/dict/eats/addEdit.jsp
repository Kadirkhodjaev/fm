<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Питание → Справочники → Реестр блюд → карточка блюда: название, категория, нормы продуктов на порцию --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<style>
  .ed-wrap { max-width:960px; margin:0 auto; padding:12px; display:flex; flex-direction:column; gap:12px; }
  .ed-card { background:#fff; border:1px solid #E6E8EC; border-radius:14px; }
  .ed-h { display:flex; align-items:center; gap:8px; padding:11px 16px; border-bottom:1px solid #F0F1F4; font-weight:700; font-size:14px; }
  .ed-h small { font-weight:500; color:#9AA1AC; font-size:12px; }
  .ed-h .fm-spacer { flex:1; }
  .ed-b { padding:14px 16px; }
  .ed-main { display:grid; grid-template-columns:2fr 1fr auto; gap:12px; align-items:end; }
  #edRows td { vertical-align:middle; }
  #edRows .fm-in.num { text-align:right; }
  #edRows .ro { background:#F5F6F8; }
</style>
<div class="fm-page fm-admin">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-cutlery"></i></span>
        <div>
          <h2>${eat.id == null ? 'Новое блюдо' : fn:escapeXml(eat.name)}</h2>
          <span class="fm-count">карточка блюда · продуктов <b id="edCnt">${fn:length(norms)}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <button type="button" class="fm-btn primary" id="edSaveBtn" onclick="saveEatForm()"><i class="fa fa-floppy-o"></i>Сохранить</button>
      <button type="button" class="fm-btn" onclick="$('#pager').load('/eats/dict/eats.s')"><i class="fa fa-arrow-left"></i>Назад</button>
    </div>
    <div class="fm-table-wrap" style="background:#F7F8FA">
      <form id="addEditForm" class="ed-wrap" onsubmit="saveEatForm(); return false" autocomplete="off">
        <input type="hidden" name="id" value="${eat.id}"/>
        <input type="hidden" name="code" value="eat"/>
        <div class="ed-card">
          <div class="ed-h">Блюдо</div>
          <div class="ed-b">
            <div class="fm-err" id="edErr" style="margin-bottom:12px"></div>
            <div class="ed-main">
              <div><label class="fm-l">Наименование *</label><input type="text" id="category-name" class="fm-in" name="name" maxlength="255" value="${fn:escapeXml(eat.name)}"/></div>
              <div>
                <label class="fm-l">Категория *</label>
                <select class="fm-in" name="type_id">
                  <c:forEach items="${types}" var="type">
                    <option <c:if test="${eat.type.id == type.id}">selected</c:if> value="${type.id}">${type.name}</option>
                  </c:forEach>
                </select>
              </div>
              <label class="fm-tgl"><input type="checkbox" name="state" value="Y" <c:if test="${eat.state == 'A' || eat.id == null}">checked</c:if>/><span>Активное</span></label>
            </div>
          </div>
        </div>
        <div class="ed-card">
          <div class="ed-h">Нормы продуктов <small>расход на одну порцию; блюдо без норм не попадает в меню</small><span class="fm-spacer"></span>
            <button type="button" class="fm-btn" onclick="newProductRow()"><i class="fa fa-plus"></i>Продукт</button>
          </div>
          <table class="fm-grid">
            <thead>
            <tr>
              <th>Продукт</th>
              <th class="r" style="width:140px">Количество</th>
              <th style="width:180px">Ед. изм.</th>
              <th style="width:50px"></th>
            </tr>
            </thead>
            <tbody id="edRows">
            <c:forEach items="${norms}" var="norm">
              <tr>
                <td>
                  <input type="hidden" name="norm_id" value="${norm.id}">
                  <input type="hidden" name="product" value="${norm.product.id}">
                  <span class="nm">${norm.product.name}</span>
                </td>
                <td><input type="text" inputmode="decimal" class="fm-in num" name="rasxod" value="${norm.rasxod}"></td>
                <td>
                  <input type="hidden" name="measure" value="${norm.measure.id}">
                  <span class="mut">${norm.measure.name}</span>
                </td>
                <td class="r"><button type="button" class="fm-act danger" title="Удалить" onclick="delEatNormRow(${norm.id}, this)"><i class="fa fa-trash-o"></i></button></td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
          <div class="fm-empty" id="edEmpty" style="display:${empty norms ? 'block' : 'none'}"><i class="fa fa-cubes"></i>Добавьте продукты блюда</div>
        </div>
      </form>
    </div>
  </div>
</div>
<%-- шаблон строки нового продукта (вне формы, в отправку не попадает) --%>
<table style="display:none"><tbody id="edTpl">
  <tr>
    <td>
      <input type="hidden" name="norm_id" value="0">
      <select class="fm-in" name="product" onchange="buildMeasureOptions(this)">
        <option value="">Выберите продукт</option>
        <c:forEach items="${products}" var="product">
          <option value="${product.id}" data-cat="${product.measureType.id}">${product.name}</option>
        </c:forEach>
      </select>
    </td>
    <td><input type="text" inputmode="decimal" class="fm-in num" name="rasxod" value=""></td>
    <td><select class="fm-in" name="measure"></select></td>
    <td class="r"><button type="button" class="fm-act danger" title="Убрать" onclick="delEatNormRow(0, this)"><i class="fa fa-times"></i></button></td>
  </tr>
</tbody></table>
<script>
  var opts = [];
  <c:forEach items="${measures}" var="measure">opts.push({id: ${measure.id}, name: '${fn:escapeXml(measure.name)}', type: '${measure.cat.id}'});
  </c:forEach>
  function edCount() {
    var n = $('#edRows tr').length;
    $('#edCnt').text(n);
    $('#edEmpty').toggle(n == 0);
  }
  function saveEatForm() {
    var f = $('#addEditForm'), err = '';
    if (!$.trim($('#category-name').val())) err = 'Укажите наименование';
    else if (!$('#edRows tr').length) err = 'Добавьте хотя бы один продукт';
    $('#edRows tr').each(function () {
      if (err) return;
      var p = $(this).find('[name=product]').val(), m = $(this).find('[name=measure]').val(), r = String($(this).find('[name=rasxod]').val()).replace(',', '.');
      if (!p) err = 'Выберите продукт в каждой строке';
      else if (!m) err = 'Выберите единицу измерения';
      else if (r === '' || isNaN(r) || Number(r) <= 0) err = 'Количество должно быть больше нуля';
    });
    if (err) { DK.err('ed', err); return; }
    $('#edErr').hide();
    $('#edSaveBtn').prop('disabled', true);
    $.ajax({
      url: '/eats/dict/save.s', method: 'post', data: f.serialize(), dataType: 'json',
      success: function (res) {
        if (res.success) { openMsg(res); $('#pager').load('/eats/dict/eat/addEdit.s?id=' + res.id); }
        else DK.err('ed', res.msg);
      },
      complete: function () { $('#edSaveBtn').prop('disabled', false); }
    });
  }
  function newProductRow() {
    var tr = $($('#edTpl').html());
    $('#edRows').append(tr);
    edCount();
    buildMeasureOptions(tr.find('select[name=product]')[0]);
  }
  // единицы измерения по типу единиц продукта
  function buildMeasureOptions(dom) {
    var o = dom.options[dom.selectedIndex], cat = o ? o.getAttribute('data-cat') : null;
    var measure = $(dom).closest('tr').find('select[name=measure]').html('');
    for (var i = 0; i < opts.length; i++) if (cat && opts[i].type === cat) measure.append($('<option>').val(opts[i].id).text($('<div>').html(opts[i].name).text()));
    measure.trigger('change');
  }
  function delEatNormRow(id, btn) {
    if (id == 0) { $(btn).closest('tr').remove(); edCount(); return; }
    FmsConfirm('Удалить продукт из норм блюда?', function () {
      $.ajax({
        url: '/eats/dict/delete.s', method: 'post', data: 'code=eat-product&id=' + id, dataType: 'json',
        success: function (res) {
          if (res.success) { FmsToast.show('Продукт удалён', 'ok'); $(btn).closest('tr').remove(); edCount(); }
          else FmsToast.show(res.msg, 'err');
        }
      });
    });
  }
</script>
