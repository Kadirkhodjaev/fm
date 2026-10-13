<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Склады → Питание: заявки на питание по отделениям --%>
<%@include file="/WEB-INF/pages/med/head_nurse/hn_style.jsp"%>
<c:set var="cntEnt" value="0"/>
<c:forEach items="${list}" var="o"><c:if test="${o.c1 == 'ENT'}"><c:set var="cntEnt" value="${cntEnt + 1}"/></c:if></c:forEach>

<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-cutlery"></i></span>
        <div>
          <h2>Питание</h2>
          <span class="fm-count"><b id="etShown">${fn:length(list)}</b> из <b>${fn:length(list)}</b> заявок</span>
        </div>
      </div>
      <div class="hn-flt">
        <input id="period_start" type="text" class="fm-in datepicker" value="${period_start}" title="С" autocomplete="off"/>
        <span class="dash">—</span>
        <input id="period_end" type="text" class="fm-in datepicker" value="${period_end}" title="По" autocomplete="off"/>
        <button type="button" class="fm-btn" onclick="etLoad()"><i class="fa fa-search"></i>Показать</button>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="etSeg">
        <button type="button" data-f="" class="on" onclick="hnSeg('et', this)">Все</button>
        <button type="button" data-f="ENT" onclick="hnSeg('et', this)">Введены · ${cntEnt}</button>
        <button type="button" data-f="CON" onclick="hnSeg('et', this)">Подтверждены · ${fn:length(list) - cntEnt}</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="etSearch" placeholder="Отделение или тип" oninput="hnFilter('et')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn primary" onclick="etNew()"><i class="fa fa-plus"></i>Новая заявка</button>
    </div>

    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th>Отделение</th>
          <th style="width:120px" class="nw">Дата</th>
          <th>Тип меню</th>
          <th style="width:120px" class="r">Пациентов</th>
          <th style="width:120px" class="r">Доп. порций</th>
          <th style="width:140px">Состояние</th>
          <th style="width:50px"></th>
        </tr>
        </thead>
        <tbody id="etRows">
        <c:forEach items="${list}" var="obj">
          <tr class="go" data-f="${obj.c1 == 'ENT' ? 'ENT' : 'CON'}" data-s="${fn:escapeXml(obj.c4)} ${fn:escapeXml(obj.fio)} ${obj.date}"
              onclick="setPage('/head_nurse/eat.s?id=${obj.ib}')">
            <td><span class="nm">${obj.c4}</span></td>
            <td class="nw">${obj.date}</td>
            <td><span class="hn-tag">${obj.fio}</span></td>
            <td class="r">${obj.c2}</td>
            <td class="r mut">${obj.c3}</td>
            <td><span class="hn-st ${obj.c1 == 'ENT' ? 'ent' : 'con'}">${obj.c1 == 'ENT' ? 'Введена' : 'Подтверждена'}</span></td>
            <td class="r" onclick="event.stopPropagation()">
              <button type="button" class="fm-act danger" title="Удалить заявку" onclick="delClaimRow(${obj.ib})"><i class="fa fa-trash-o"></i></button>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="etEmpty" style="display:none"><i class="fa fa-cutlery"></i>Заявок за период нет</div>
    </div>
  </div>
</div>

<div class="fm-overlay" id="etModal" onclick="if (event.target === this) $('#etModal').removeClass('open')">
  <div class="fm-modal" style="width:460px">
    <div class="fm-modal-head">
      <h3>Новая заявка на питание</h3>
      <button type="button" class="fm-x" onclick="$('#etModal').removeClass('open')"><i class="fa fa-times"></i></button>
    </div>
    <form id="addEditForm" name="addEditForm" onsubmit="saveEatForm(); return false">
      <div class="fm-modal-body">
        <div class="fm-err" id="etErr"></div>
        <div>
          <label class="fm-l">Дата меню *</label>
          <input name="menu_date" id="menu-date" type="text" class="fm-in datepicker" autocomplete="off"/>
        </div>
        <div>
          <label class="fm-l">Отделение *</label>
          <select class="fm-in" name="dept">
            <c:forEach items="${depts}" var="dept">
              <option value="${dept.id}">${dept.name}</option>
            </c:forEach>
          </select>
        </div>
        <div>
          <label class="fm-l">Тип меню *</label>
          <select class="fm-in" name="menu_type">
            <c:forEach items="${menuTypes}" var="menuType">
              <option value="${menuType.id}">${menuType.name}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="fm-modal-foot">
        <span class="fm-spacer"></span>
        <button type="button" class="fm-btn" onclick="$('#etModal').removeClass('open')">Отмена</button>
        <button type="submit" class="fm-btn primary"><i class="fa fa-check"></i>Сформировать</button>
      </div>
    </form>
  </div>
</div>
<script>
  hnFilter('et');
  function etLoad() {
    setPage('/head_nurse/eats.s?period_start=' + encodeURIComponent($('#period_start').val()) + '&period_end=' + encodeURIComponent($('#period_end').val()));
  }
  function etNew() {
    document.addEditForm.reset();
    $('#etErr').hide();
    $('#etModal').addClass('open');
  }
  function saveEatForm() {
    if (!$.trim($('#menu-date').val())) { $('#etErr').text('Укажите дату меню').show(); return; }
    $.ajax({
      url: '/head_nurse/eat/save.s', method: 'post', data: $('#addEditForm').serialize(), dataType: 'json',
      success: function (res) {
        if (res.success) { openMedMsg('Заявка сформирована', true); $('#etModal').removeClass('open'); setPage('/head_nurse/eat.s?id=' + res.id); }
        else $('#etErr').text(res.msg).show();
      }
    });
  }
  function delClaimRow(id) {
    FmsConfirm('Удалить заявку на питание?', function () {
    $.ajax({
      url: '/head_nurse/eat/del.s', method: 'post', data: 'id=' + id, dataType: 'json',
      success: function (res) {
        if (res.success) { openMedMsg('Заявка удалена', true); setPage('/head_nurse/eats.s'); }
        else errMsg(res.msg);
      }
    });
  });
  }
</script>
