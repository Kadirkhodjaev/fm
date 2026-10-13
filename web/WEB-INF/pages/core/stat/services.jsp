<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Администрирование → Стационар → вкладка «Услуги» (грузится в #pager страницы core/stat/hub.jsp) --%>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<%@include file="/WEB-INF/pages/core/ambv2/list_style.jsp"%>
<script src="/res/js/tableToExcel.js" type="text/javascript"></script>
<c:set var="nds" value="${sessionScope.ENV.params['NDS_PROC']}"/>
<style>
  .st-sub { display:block; font-size:11.5px; color:#9AA1AC; font-weight:400; }
</style>

<div class="fm-page fm-admin">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-hospital-o"></i></span>
        <div>
          <h2>Стационарные услуги</h2>
          <span class="fm-count"><b id="ssShown">${fn:length(services)}</b> из <b>${fn:length(services)}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg">
        <button type="button" class="${stateCode == '0' ? 'on' : ''}" onclick="ssLoad(null, '0')">Все</button>
        <button type="button" class="${stateCode == 'A' ? 'on' : ''}" onclick="ssLoad(null, 'A')">Активные</button>
        <button type="button" class="${stateCode == 'P' ? 'on' : ''}" onclick="ssLoad(null, 'P')">Пассивные</button>
      </div>
      <select class="fm-in fms-select" style="width:220px" onchange="ssLoad(this.value || '0', null)">
        <option value="0">Все группы</option>
        <c:forEach items="${groups}" var="g">
          <option <c:if test="${g.id == group}">selected</c:if> value="${g.id}">${g.name}</option>
        </c:forEach>
      </select>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="ssSearch" placeholder="Название или ID" oninput="avFilter('ss')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn" onclick="TableToExcel.convert(document.getElementById('excel_table'))"><i class="fa fa-file-excel-o"></i>Excel</button>
      <button type="button" class="fm-btn primary" onclick="ssEdit(0)"><i class="fa fa-plus"></i>Новая услуга</button>
    </div>

    <div class="fm-table-wrap">
      <table class="fm-grid" id="excel_table" data-cols-width="10,22,50,16,16,16,16,16,16,12">
        <thead>
        <tr>
          <th style="width:60px" data-f-bold="true">ID</th>
          <th style="width:180px" data-f-bold="true">Группа</th>
          <th data-f-bold="true">Наименование</th>
          <th style="width:105px" class="r" data-f-bold="true">Цена</th>
          <th style="width:105px" class="r" data-f-bold="true">С НДС</th>
          <th style="width:110px" class="r" data-f-bold="true">Иностранцы</th>
          <th style="width:115px" class="r" data-f-bold="true">Иностр. с НДС</th>
          <th style="width:105px" class="r" data-f-bold="true">Реальная</th>
          <th style="width:115px" class="r" data-f-bold="true">Реальная иностр.</th>
          <th style="width:105px" data-f-bold="true">Состояние</th>
          <th style="width:50px" data-exclude="true"></th>
        </tr>
        </thead>
        <tbody id="ssRows">
        <c:forEach items="${services}" var="s">
          <tr data-s="${s.id} ${fn:toLowerCase(fn:escapeXml(s.name))}" onclick="ssEdit(${s.id})" title="Изменить">
            <td class="mut" data-t="n"><b>${s.id}</b></td>
            <td><span class="av-grp">${s.kdoType.name}</span></td>
            <td><span class="nm">${s.name}</span></td>
            <td class="r"><fmt:formatNumber value="${s.price}" type="number" maxFractionDigits="2"/></td>
            <td class="r mut"><fmt:formatNumber value="${s.price * (100 + nds) / 100}" type="number" maxFractionDigits="2"/></td>
            <td class="r"><fmt:formatNumber value="${s.for_price}" type="number" maxFractionDigits="2"/></td>
            <td class="r mut"><fmt:formatNumber value="${s.for_price * (100 + nds) / 100}" type="number" maxFractionDigits="2"/></td>
            <td class="r"><fmt:formatNumber value="${s.real_price}" type="number" maxFractionDigits="2"/></td>
            <td class="r"><fmt:formatNumber value="${s.for_real_price}" type="number" maxFractionDigits="2"/></td>
            <td><span class="av-st ${s.state == 'A' ? 'A' : 'P'}">${s.state == 'A' ? 'Активный' : 'Пассивный'}</span></td>
            <td class="r" data-exclude="true"><button type="button" class="fm-act" title="Изменить"><i class="fa fa-pencil"></i></button></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="ssEmpty" style="display:none"><i class="fa fa-hospital-o"></i>Услуги не найдены</div>
    </div>
  </div>
</div>

<div class="fm-overlay fm-admin" id="ssModal" onclick="if (event.target === this) avClose('ss')">
  <div class="fm-modal" style="width:720px">
    <div class="fm-modal-head">
      <h3 id="ssTitle">Услуга</h3>
      <button type="button" class="fm-x" onclick="avClose('ss')"><i class="fa fa-times"></i></button>
    </div>
    <form id="addEditForm" name="addEditForm" onsubmit="saveStatKdo(); return false">
      <div class="fm-modal-body">
        <input type="hidden" name="id"/>
        <div class="fm-err" id="ssErr"></div>
        <div class="fm-row" style="grid-template-columns:1fr 2fr">
          <div>
            <label class="fm-l">Группа *</label>
            <select id="kdo_group" class="fm-in" name="group" onchange="ssKind()">
              <option value="">Не выбрано</option>
              <c:forEach items="${groups}" var="g">
                <option value="${g.id}">${g.name}</option>
              </c:forEach>
            </select>
          </div>
          <div>
            <label class="fm-l">Наименование *</label>
            <input type="text" id="kdo-name" class="fm-in" name="name" autocomplete="off"/>
          </div>
        </div>
        <div class="fm-row" style="grid-template-columns:2fr 1fr 1fr">
          <div>
            <label class="fm-l">Форма результата *</label>
            <select id="form_id" class="fm-in" name="form_id" onchange="ssKind()">
              <c:forEach items="${forms}" var="g">
                <option value="${g.id}">${g.id} - ${g.name}</option>
              </c:forEach>
            </select>
          </div>
          <div class="ss-777"><label class="fm-l">Норма</label><input type="text" class="fm-in" name="norma"/></div>
          <div class="ss-777"><label class="fm-l">Ед. изм.</label><input type="text" class="fm-in" name="ei"/></div>
        </div>

        <span class="fm-sec">Цены</span>
        <div class="fm-row" style="grid-template-columns:repeat(5, 1fr); margin-top:-6px">
          <div><label class="fm-l">Резиденты *</label><input type="text" class="fm-in" name="price" style="text-align:right"/></div>
          <div><label class="fm-l">Нерезиденты *</label><input type="text" class="fm-in" name="for_price" style="text-align:right"/></div>
          <div><label class="fm-l">Реальная</label><input type="text" class="fm-in" name="real_price" style="text-align:right"/></div>
          <div><label class="fm-l">Реальная иностр.</label><input type="text" class="fm-in" name="for_real_price" style="text-align:right"/></div>
          <div><label class="fm-l">Вознагр., %</label><input type="text" class="fm-in" name="bonus_proc" style="text-align:right"/></div>
        </div>

        <span class="fm-sec">Физиотерапия</span>
        <div class="fm-row" style="grid-template-columns:repeat(4, 1fr); margin-top:-6px">
          <div><label class="fm-l">Время, мин</label><input type="text" class="fm-in" name="minTime" style="text-align:right"/></div>
          <div><label class="fm-l">Время, макс</label><input type="text" class="fm-in" name="maxTime" style="text-align:right"/></div>
          <div><label class="fm-l">Комната</label><input type="text" class="fm-in" name="room" style="text-align:center"/></div>
          <div><label class="fm-l">Единица</label><input type="text" class="fm-in" name="fizei" style="text-align:center"/></div>
        </div>

        <span class="fm-sec">Состояние и настройки</span>
        <div style="display:flex; flex-wrap:wrap; align-items:center; gap:8px; margin-top:-6px">
          <div class="fm-state">
            <label><input type="radio" class="a" name="state" value="A"/><span>Активная</span></label>
            <label><input type="radio" class="p" name="state" value=""/><span>Пассивная</span></label>
          </div>
          <label class="fm-tgl"><input type="checkbox" name="necKdo" value="Y"/><span>Обязательное обследование</span></label>
          <label class="fm-tgl"><input type="checkbox" name="out_service" value="Y"/><span>Внешняя услуга</span></label>
          <label class="fm-tgl"><input type="checkbox" name="multiUser" value="Y"/><span>Выбор врача</span></label>
          <label class="fm-tgl" id="uzi-free"><input type="checkbox" name="priced" value="Y"/><span>1 услуга бесплатно</span></label>
        </div>
        <div class="fm-hint" id="kdo_users_box"><b style="color:#6B7280">Пользователи:</b> <span id="kdo_users"></span></div>
      </div>
      <div class="fm-modal-foot">
        <span class="fm-spacer"></span>
        <button type="button" class="fm-btn" onclick="avClose('ss')">Отмена</button>
        <button type="submit" class="fm-btn primary" id="ssSaveBtn"><i class="fa fa-floppy-o"></i>Сохранить</button>
      </div>
    </form>
  </div>
</div>

<script>
  avFilter('ss');
  var ssGroup = '${empty group ? '0' : group}', ssState = '${stateCode}';
  function ssLoad(group, state) {
    $('#pager').load('/core/stat/services.s?group=' + (group === null ? ssGroup : group) + '&state=' + (state === null ? ssState : state));
  }
  function ssKind() {
    var f = document.addEditForm;
    $('.ss-777').toggle(f.elements['form_id'].value == '777');
    $('#uzi-free').toggle(f.elements['group'].value == '4');
  }
  function ssFill(d) {
    var f = document.addEditForm;
    f.reset();
    $('#ssErr').hide();
    $.each(['id', 'name', 'price', 'for_price', 'real_price', 'for_real_price', 'bonus_proc', 'minTime', 'maxTime', 'room', 'fizei', 'norma', 'ei'], function (i, k) {
      f.elements[k].value = d[k] == null ? '' : d[k];
    });
    f.elements['group'].value = d.group || '';
    if (d.form != null) f.elements['form_id'].value = d.form;
    f.elements['necKdo'].checked = d.necKdo == 'Y';
    f.elements['out_service'].checked = d.out_service == 'Y';
    f.elements['multiUser'].checked = d.multiUser == 'Y';
    f.elements['priced'].checked = d.priced == 'Y';
    $(f).find('[name=state][value="' + (d.state == 'P' ? '' : 'A') + '"]').prop('checked', true);
    $('#kdo_users').text(d.users || '');
    $('#kdo_users_box').toggle(!!d.users);
    ssKind();
  }
  function ssEdit(id) {
    $('#ssTitle').text(id ? 'Изменить услугу' : 'Новая услуга');
    ssFill({id: '', price: 0, for_price: 0, real_price: 0, for_real_price: 0, group: ssGroup != '0' ? ssGroup : '', state: 'A'});
    $('#ssModal').addClass('open');
    if (!id) { document.addEditForm.elements['name'].focus(); return; }
    $.ajax({
      url: '/core/stat/kdo/get.s', method: 'post', data: 'id=' + id, dataType: 'json',
      success: function (res) {
        if (res.success) { res.id = id; ssFill(res); }
        else $('#ssErr').text(res.msg).show();
      }
    });
  }
  function saveStatKdo() {
    var f = document.addEditForm, err = '';
    if (!f.elements['group'].value) err = 'Выберите группу';
    else if (!$.trim(f.elements['name'].value)) err = 'Укажите наименование';
    if (err) { $('#ssErr').text(err).show(); return; }
    $('#ssSaveBtn').prop('disabled', true);
    $.ajax({
      url: '/core/stat/service/save.s', method: 'post', data: $(f).serialize(), dataType: 'json',
      success: function (res) {
        if (res.success) { openMsg(res); avClose('ss'); ssLoad(null, null); }
        else $('#ssErr').text(res.msg).show();
      },
      complete: function () { $('#ssSaveBtn').prop('disabled', false); }
    });
  }
</script>
