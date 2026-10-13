<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Администрирование → Амб услуги → вкладка «Услуги» (грузится в #pager страницы core/amb/hub.jsp) --%>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<%@include file="/WEB-INF/pages/core/ambv2/list_style.jsp"%>
<script src="/res/js/tableToExcel.js" type="text/javascript"></script>
<c:set var="nds" value="${sessionScope.ENV.params['NDS_PROC']}"/>

<div class="fm-page fm-admin">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-flask"></i></span>
        <div>
          <h2>Амбулаторные услуги</h2>
          <span class="fm-count"><b id="amShown">${fn:length(services)}</b> из <b>${fn:length(services)}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg">
        <button type="button" class="${stateCode == '0' ? 'on' : ''}" onclick="amLoad('state=0')">Все</button>
        <button type="button" class="${stateCode == 'A' ? 'on' : ''}" onclick="amLoad('state=A')">Активные</button>
        <button type="button" class="${stateCode == 'P' ? 'on' : ''}" onclick="amLoad('state=P')">Пассивные</button>
      </div>
      <select class="fm-in fms-select" style="width:220px" onchange="amLoad('page=' + (this.value || 0))">
        <option value="0">Все группы</option>
        <c:forEach items="${groups}" var="g">
          <option <c:if test="${page == g.id}">selected</c:if> value="${g.id}">${g.name}</option>
        </c:forEach>
      </select>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="amSearch" placeholder="Название или ID" oninput="avFilter('am')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn" onclick="TableToExcel.convert(document.getElementById('excel_table'))"><i class="fa fa-file-excel-o"></i>Excel</button>
      <button type="button" class="fm-btn primary" onclick="amEdit(0)"><i class="fa fa-plus"></i>Новая услуга</button>
    </div>

    <div class="fm-table-wrap">
      <table class="fm-grid" id="excel_table" data-cols-width="10,20,50,16,16,16,16,12,12,10">
        <thead>
        <tr>
          <th style="width:60px" data-f-bold="true">ID</th>
          <th style="width:190px" data-f-bold="true">Группа</th>
          <th data-f-bold="true">Наименование</th>
          <th style="width:110px" class="r" data-f-bold="true">Цена</th>
          <th style="width:110px" class="r" data-f-bold="true">С НДС</th>
          <th style="width:120px" class="r" data-f-bold="true">Иностранцы</th>
          <th style="width:120px" class="r" data-f-bold="true">Иностр. с НДС</th>
          <th style="width:80px" class="c" data-f-bold="true">Лечение</th>
          <th style="width:110px" data-f-bold="true">Состояние</th>
          <th style="width:70px" class="c" data-f-bold="true">Форма</th>
          <th style="width:50px" data-exclude="true"></th>
        </tr>
        </thead>
        <tbody id="amRows">
        <c:forEach items="${services}" var="s">
          <c:set var="v" value="${s.service}"/>
          <tr data-s="${v.id} ${fn:toLowerCase(fn:escapeXml(v.name))}" onclick="amEdit(${v.id})" title="Изменить">
            <td class="mut" data-t="n"><b>${v.id}</b></td>
            <td><span class="av-grp">${v.group.name}</span></td>
            <td><span class="nm">${v.name}</span></td>
            <td class="r" data-v="${v.price}"><fmt:formatNumber value="${v.price}" type="number" maxFractionDigits="2"/></td>
            <td class="r mut" data-v="${v.price * (100 + nds) / 100}"><fmt:formatNumber value="${v.price * (100 + nds) / 100}" type="number" maxFractionDigits="2"/></td>
            <td class="r" data-v="${v.for_price}"><fmt:formatNumber value="${v.for_price}" type="number" maxFractionDigits="2"/></td>
            <td class="r mut" data-v="${v.for_price * (100 + nds) / 100}"><fmt:formatNumber value="${v.for_price * (100 + nds) / 100}" type="number" maxFractionDigits="2"/></td>
            <td class="c">${v.treatment == 'Y' ? '<span class="av-yes">Да</span>' : '<span class="av-no">—</span>'}</td>
            <td><span class="av-st ${v.state == 'A' ? 'A' : 'P'}">${v.state == 'A' ? 'Активный' : 'Пассивный'}</span></td>
            <td class="c mut">${v.form_id}</td>
            <td class="r" data-exclude="true"><button type="button" class="fm-act" title="Изменить"><i class="fa fa-pencil"></i></button></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="amEmpty" style="display:none"><i class="fa fa-flask"></i>Услуги не найдены</div>
    </div>
  </div>
</div>

<div class="fm-overlay fm-admin" id="amModal" onclick="if (event.target === this) avClose('am')">
  <div class="fm-modal" style="width:680px">
    <div class="fm-modal-head">
      <h3 id="amTitle">Услуга</h3>
      <button type="button" class="fm-x" onclick="avClose('am')"><i class="fa fa-times"></i></button>
    </div>
    <div class="fm-modal-body" id="amBody"></div>
    <div class="fm-modal-foot">
      <span class="fm-spacer"></span>
      <button type="button" class="fm-btn" onclick="avClose('am')">Отмена</button>
      <button type="button" class="fm-btn primary" id="amSaveBtn" onclick="amSave()"><i class="fa fa-floppy-o"></i>Сохранить</button>
    </div>
  </div>
</div>

<script>
  avFilter('am');
  function amLoad(q) { $('#pager').load('/core/amb/services.s?' + q); }
  function amEdit(id) {
    $('#amTitle').text(id ? 'Изменить услугу' : 'Новая услуга');
    $('#amBody').html('<div class="fm-hint">Загрузка…</div>');
    $('#amModal').addClass('open');
    $('#amBody').load('/core/amb/service/modal.s' + (id ? '?id=' + id : ''));
  }
  function amSave() {
    var f = $('#amForm'), err = '';
    if (!f.find('[name=group]').val()) err = 'Выберите группу';
    else if (!$.trim(f.find('[name=name]').val())) err = 'Укажите наименование';
    else if (!$.trim(f.find('[name=price]').val()) || !$.trim(f.find('[name=for_price]').val())) err = 'Укажите обе цены';
    if (err) { $('#amErr').text(err).show(); return; }
    $('#amSaveBtn').prop('disabled', true);
    $.ajax({
      url: '/core/amb/service/save.s', method: 'post', data: f.serialize(), dataType: 'json',
      success: function (res) {
        if (res.success) { openMsg(res); avClose('am'); $('#pager').load('/core/amb/services.s'); }
        else $('#amErr').text(res.msg).show();
      },
      complete: function () { $('#amSaveBtn').prop('disabled', false); }
    });
  }
</script>
