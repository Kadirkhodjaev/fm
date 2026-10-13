<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<%@include file="/WEB-INF/pages/core/ambv2/list_style.jsp"%>
<c:set var="cntA" value="0"/>
<c:forEach items="${services}" var="s"><c:if test="${s.service.state == 'A'}"><c:set var="cntA" value="${cntA + 1}"/></c:if></c:forEach>

<div class="fm-page fm-admin">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-flask"></i></span>
        <div>
          <h2>Амбулаторные услуги</h2>
          <span class="fm-count"><b id="asShown">${fn:length(services)}</b> из <b>${fn:length(services)}</b> · активных <b>${cntA}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="asSeg">
        <button type="button" data-f="" onclick="avSeg('as', this)">Все</button>
        <button type="button" data-f="A" class="on" onclick="avSeg('as', this)">Активные</button>
        <button type="button" data-f="P" onclick="avSeg('as', this)">Пассивные</button>
      </div>
      <select class="fm-in fms-select" id="asGroup" style="width:220px; height:30px" onchange="$('#pager').load('/core/ambv2/services.s?page=' + (this.value || 0))">
        <option value="">Все группы</option>
        <c:forEach items="${groups}" var="g">
          <option <c:if test="${page == g.id}">selected</c:if> value="${g.id}">${g.name}</option>
        </c:forEach>
      </select>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="asSearch" placeholder="Название или ID" oninput="avFilter('as')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn primary" onclick="asEdit(null)"><i class="fa fa-plus"></i>Новая услуга</button>
    </div>

    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:60px">ID</th>
          <th style="width:200px">Группа</th>
          <th>Наименование</th>
          <th style="width:120px" class="r">Цена</th>
          <th style="width:130px" class="r">Для иностранцев</th>
          <th style="width:90px" class="c">Лечение</th>
          <th style="width:110px" class="c">Новая форма</th>
          <th style="width:110px">Состояние</th>
          <th style="width:84px"></th>
        </tr>
        </thead>
        <tbody id="asRows">
        <c:forEach items="${services}" var="s">
          <c:set var="v" value="${s.service}"/>
          <tr data-f="${v.state == 'A' ? 'A' : 'P'}" data-g="${v.group.id}" data-s="${v.id} ${fn:toLowerCase(fn:escapeXml(v.name))}"
              data-id="${v.id}" data-name="${fn:escapeXml(v.name)}" data-group="${v.group.id}" data-price="${v.price}" data-for="${v.for_price}"
              data-state="${v.state}" data-consul="${v.consul}" data-treatment="${v.treatment}" data-diagnoz="${v.diagnoz}" data-newform="${v.newForm}"
              onclick="asEdit(this)" title="Изменить">
            <td class="mut"><b>${v.id}</b></td>
            <td><span class="av-grp">${v.group.name}</span></td>
            <td><span class="nm">${v.name}</span></td>
            <td class="r"><fmt:formatNumber value="${v.price}" type="number" maxFractionDigits="2"/></td>
            <td class="r mut"><fmt:formatNumber value="${v.for_price}" type="number" maxFractionDigits="2"/></td>
            <td class="c">${v.treatment == 'Y' ? '<span class="av-yes">Да</span>' : '<span class="av-no">—</span>'}</td>
            <td class="c">${s.newForm == 'Y' ? '<span class="av-yes">Да</span>' : '<span class="av-no">—</span>'}</td>
            <td><span class="av-st ${v.state == 'A' ? 'A' : 'P'}">${v.state == 'A' ? 'Активный' : 'Пассивный'}</span></td>
            <td class="r" onclick="event.stopPropagation()">
              <c:if test="${s.newForm == 'Y'}">
                <button type="button" class="fm-act" title="Настройка формы результата" onclick="asForm(${v.id})"><i class="fa fa-list-alt"></i></button>
              </c:if>
              <button type="button" class="fm-act" title="Изменить" onclick="asEdit($(this).closest('tr')[0])"><i class="fa fa-pencil"></i></button>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="asEmpty" style="display:none"><i class="fa fa-flask"></i>Услуги не найдены</div>
    </div>
  </div>
</div>

<div class="fm-overlay fm-admin" id="asModal" onclick="if (event.target === this) avClose('as')">
  <div class="fm-modal" style="width:560px">
    <div class="fm-modal-head">
      <h3 id="asTitle">Услуга</h3>
      <button type="button" class="fm-x" onclick="avClose('as')"><i class="fa fa-times"></i></button>
    </div>
    <form id="asForm" onsubmit="asSave(); return false">
      <div class="fm-modal-body">
        <input type="hidden" name="id"/>
        <div class="fm-err" id="asErr"></div>
        <div>
          <label class="fm-l">Группа *</label>
          <select name="group" class="fm-in">
            <option value="">Не выбрано</option>
            <c:forEach items="${groups}" var="g">
              <option value="${g.id}">${g.name}</option>
            </c:forEach>
          </select>
        </div>
        <div>
          <label class="fm-l">Наименование *</label>
          <input type="text" class="fm-in" name="name" maxlength="500" autocomplete="off"/>
        </div>
        <div class="fm-row" style="grid-template-columns:1fr 1fr">
          <div>
            <label class="fm-l">Цена *</label>
            <input type="number" class="fm-in" name="price" min="0" step="0.01" style="text-align:right"/>
          </div>
          <div>
            <label class="fm-l">Цена для иностранцев *</label>
            <input type="number" class="fm-in" name="for_price" min="0" step="0.01" style="text-align:right"/>
          </div>
        </div>
        <div>
          <span class="fm-sec">Настройки</span>
          <div style="margin-top:8px; display:flex; flex-wrap:wrap; row-gap:8px">
            <label class="fm-chk"><input type="checkbox" name="state" value="A"/> Активная</label>
            <label class="fm-chk"><input type="checkbox" name="consul" value="Y"/> Консультация</label>
            <label class="fm-chk"><input type="checkbox" name="treatment" value="Y"/> Амбулаторное лечение</label>
            <label class="fm-chk"><input type="checkbox" name="diagnoz" value="Y"/> Поле «Диагноз»</label>
            <label class="fm-chk"><input type="checkbox" name="new_form" value="Y"/> Новая форма результата</label>
          </div>
        </div>
      </div>
      <div class="fm-modal-foot">
        <button type="button" class="fm-btn" id="asFormBtn" onclick="asForm(document.getElementById('asForm').elements['id'].value)"><i class="fa fa-list-alt"></i>Настройка формы</button>
        <span class="fm-spacer"></span>
        <button type="button" class="fm-btn" onclick="avClose('as')">Отмена</button>
        <button type="submit" class="fm-btn primary" id="asSaveBtn"><i class="fa fa-check"></i>Сохранить</button>
      </div>
    </form>
  </div>
</div>

<script>
  avFilter('as');
  function asEdit(tr) {
    var f = document.getElementById('asForm'), d = tr ? $(tr).data() : {};
    f.reset();
    $('#asErr').hide();
    f.elements['id'].value = tr ? d.id : '';
    f.elements['group'].value = tr ? d.group : ($('#asGroup').val() || '');
    f.elements['name'].value = tr ? $(tr).attr('data-name') : '';
    f.elements['price'].value = tr ? d.price : '';
    f.elements['for_price'].value = tr ? d['for'] : '';
    f.elements['state'].checked = tr ? d.state == 'A' : true;
    f.elements['consul'].checked = tr && d.consul == 'Y';
    f.elements['treatment'].checked = tr && d.treatment == 'Y';
    f.elements['diagnoz'].checked = tr ? d.diagnoz == 'Y' : true;
    f.elements['new_form'].checked = tr && d.newform == 'Y';
    $('#asFormBtn').toggle(!!tr && d.newform == 'Y');
    $('#asTitle').text(tr ? 'Изменить услугу' : 'Новая услуга');
    $('#asModal').addClass('open');
    f.elements['name'].focus();
  }
  function asForm(id) {
    avClose('as');
    $('#pager').load('/core/ambv2/service/save.s?id=' + id);
  }
  function asSave() {
    var f = document.getElementById('asForm'), err = '';
    if (!f.elements['group'].value) err = 'Выберите группу';
    else if (!$.trim(f.elements['name'].value)) err = 'Укажите наименование';
    else if (f.elements['price'].value === '' || f.elements['for_price'].value === '') err = 'Укажите обе цены';
    if (err) { $('#asErr').text(err).show(); return; }
    $('#asSaveBtn').prop('disabled', true);
    $.ajax({
      url: '/core/ambv2/service/save.s', method: 'post', data: $(f).serialize(), dataType: 'json',
      success: function (res) {
        if (res.success) { openMsg(res); avClose('as'); $('#pager').load('/core/ambv2/services.s'); }
        else $('#asErr').text(res.msg).show();
      },
      complete: function () { $('#asSaveBtn').prop('disabled', false); }
    });
  }
</script>
