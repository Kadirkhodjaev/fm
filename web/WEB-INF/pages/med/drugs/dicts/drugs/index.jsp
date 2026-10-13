<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Аптека → Справочники → Препараты (реестр) --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<style>
  .dg-warn { display:inline-block; margin-left:8px; padding:0 7px; border-radius:6px; background:#FDECEE; color:#A50F22; font-size:11.5px; font-weight:600; line-height:18px; }
  table.fm-grid tr.cur td { background:#EEF3FB; }
</style>
<c:set var="cntBad" value="0"/>
<c:forEach items="${drugs}" var="d"><c:if test="${d.counter == null || d.counter == 0}"><c:set var="cntBad" value="${cntBad + 1}"/></c:if></c:forEach>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-medkit"></i></span>
        <div>
          <h2>Препараты</h2>
          <span class="fm-count"><b id="dgShown">${fn:length(drugs)}</b> из <b>${fn:length(drugs)}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg">
        <button type="button" class="${ct != 'P' ? 'on' : ''}" onclick="setPage('/drugs/dicts.s?cat=A')">Активные</button>
        <button type="button" class="${ct == 'P' ? 'on' : ''}" onclick="setPage('/drugs/dicts.s?cat=P')">Пассивные</button>
      </div>
      <div class="fm-seg" id="dgSeg">
        <button type="button" data-f="" class="on" onclick="DK.seg('dg', this)">Все</button>
        <button type="button" data-f="bad" onclick="DK.seg('dg', this)">Без кол-ва учёта · ${cntBad}</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="dgSearch" placeholder="Название или ID" oninput="DK.filter('dg')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn primary" onclick="dgEdit(0)"><i class="fa fa-plus"></i>Добавить</button>
    </div>
    <div class="fm-table-wrap" id="dgWrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:70px">ID</th>
          <th>Наименование</th>
          <th style="width:130px">Состояние</th>
          <th style="width:90px"></th>
        </tr>
        </thead>
        <tbody id="dgRows">
        <c:forEach items="${drugs}" var="d">
          <c:set var="bad" value="${d.counter == null || d.counter == 0}"/>
          <tr id="row_${d.id}" data-f="${bad ? 'bad' : 'ok'}" data-s="${d.id} ${fn:escapeXml(d.name)}" data-name="${fn:escapeXml(d.name)}" onclick="dgEdit(${d.id})" title="Изменить">
            <td class="mut"><b>${d.id}</b></td>
            <td><span class="nm">${d.name}</span><c:if test="${bad}"><span class="dg-warn" title="Не настроено количество для учёта">нет кол-ва учёта</span></c:if></td>
            <td><span class="dk-st ${d.state == 'A' ? 'A' : 'P'}">${d.state == 'A' ? 'Активный' : 'Пассивный'}</span></td>
            <td class="r" onclick="event.stopPropagation()">
              <button type="button" class="fm-act" title="Детализация по приходам" onclick="viewDrug(${d.id})"><i class="fa fa-list"></i></button>
              <button type="button" class="fm-act danger" title="Удалить" onclick="DK.del('drug', ${d.id}, $(this).closest('tr').attr('data-name'), 'drugs')"><i class="fa fa-trash-o"></i></button>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="dgEmpty" style="display:none"><i class="fa fa-medkit"></i>Ничего не найдено</div>
    </div>
  </div>
</div>

<div class="fm-overlay" id="dgModal" onclick="if (event.target === this) DK.close('dg')">
  <div class="fm-modal" style="width:640px">
    <div class="fm-modal-head">
      <h3 id="dgTitle"></h3>
      <button type="button" class="fm-x" onclick="DK.close('dg')"><i class="fa fa-times"></i></button>
    </div>
    <form id="dgForm" onsubmit="dgSave(); return false">
      <div class="fm-modal-body">
        <input type="hidden" name="id"/>
        <input type="hidden" name="code" value="drug"/>
        <div class="fm-err" id="dgErr"></div>
        <div>
          <label class="fm-l">Наименование *</label>
          <input type="text" class="fm-in" name="name" autocomplete="off"/>
        </div>
        <div class="fm-row" style="grid-template-columns:140px 1fr">
          <div><label class="fm-l">Кол-во для учёта *</label><input type="number" step="any" min="0" class="fm-in" name="counter" style="text-align:center"/></div>
          <div>
            <label class="fm-l">Ед. измерения</label>
            <select class="fm-in fms-select" name="measure">
              <c:forEach items="${measures}" var="m">
                <option value="${m.id}">${m.name}</option>
              </c:forEach>
            </select>
          </div>
        </div>
        <div class="fm-state" style="align-self:flex-start">
          <label><input type="radio" class="a" name="state" value="Y" checked/><span>Активный</span></label>
          <label><input type="radio" class="p" name="state" value=""/><span>Пассивный</span></label>
        </div>
        <div>
          <label class="fm-l">Категории</label>
          <div class="dk-checks">
            <c:forEach items="${categories}" var="category">
              <label><input type="checkbox" class="cat_checkbox" value="${category.id}" id="cat_${category.id}" name="cats"/> ${category.name}</label>
            </c:forEach>
          </div>
        </div>
      </div>
      <div class="fm-modal-foot">
        <span class="fm-spacer"></span>
        <button type="button" class="fm-btn" onclick="DK.close('dg')">Отмена</button>
        <button type="submit" class="fm-btn primary"><i class="fa fa-floppy-o"></i>Сохранить</button>
      </div>
    </form>
  </div>
</div>

<div class="fm-overlay" id="dgInModal" onclick="if (event.target === this) DK.close('dgIn')">
  <div class="fm-modal" style="width:860px">
    <div class="fm-modal-head">
      <h3>Приходы · <span id="dgInTitle"></span></h3>
      <button type="button" class="fm-x" onclick="DK.close('dgIn')"><i class="fa fa-times"></i></button>
    </div>
    <div class="fm-modal-body" id="drug_details" style="padding:0"></div>
  </div>
</div>
<script>
  DK.filter('dg');
  function dgMark(id) {
    $('#dgRows tr.cur').removeClass('cur');
    $('#row_' + id).addClass('cur');
    try { localStorage.setItem('drug_idx', id); } catch (e) {}
  }
  function dgEdit(id) {
    var f = document.getElementById('dgForm');
    f.reset();
    f.elements['id'].value = '';
    $('.cat_checkbox').prop('checked', false);
    DK.open('dg', id ? 'Изменить препарат' : 'Новый препарат');
    if (!id) { f.elements['name'].focus(); return; }
    dgMark(id);
    DK.get('dg', 'drug', id, function (res) {
      f.elements['id'].value = res.id;
      f.elements['name'].value = res.name || '';
      f.elements['counter'].value = res.counter == null ? '' : res.counter;
      $(f.elements['measure']).val(res.measure).trigger('change');
      DK.setState(f, res.state == 'A');
      $.each(res.cats || [], function (i, c) { $('#cat_' + c).prop('checked', true); });
    });
  }
  function dgSave() {
    var f = document.getElementById('dgForm');
    if (!$.trim(f.elements['name'].value)) { DK.err('dg', 'Укажите наименование'); return; }
    if (!(parseFloat(f.elements['counter'].value) > 0)) { DK.err('dg', 'Укажите количество для учёта больше нуля'); return; }
    DK.save('dg', f, 'drugs');
  }
  function viewDrug(id) {
    dgMark(id);
    $('#dgInTitle').text($('#row_' + id).attr('data-name'));
    $('#drug_details').html('<div class="fm-hint" style="padding:16px">Загрузка…</div>').load('/drugs/dict/drug/incomes.s?id=' + id);
    $('#dgInModal').addClass('open');
  }
  // вернуться к препарату, с которым работали в прошлый раз
  (function () {
    var id = null;
    try { id = localStorage.getItem('drug_idx'); } catch (e) {}
    var row = id ? document.getElementById('row_' + id) : null;
    if (row) { $(row).addClass('cur'); row.scrollIntoView({block: 'center'}); }
  })();
</script>
