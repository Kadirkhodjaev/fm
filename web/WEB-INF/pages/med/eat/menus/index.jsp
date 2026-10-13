<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Питание → Меню по дням (состав меню — menus/details.jsp) --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<script src="/res/js/fms-calendar.js" type="text/javascript"></script>
<c:set var="cntEnt" value="0"/>
<c:forEach items="${menus}" var="o"><c:if test="${o.state == 'ENT'}"><c:set var="cntEnt" value="${cntEnt + 1}"/></c:if></c:forEach>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-calendar"></i></span>
        <div>
          <h2>Меню</h2>
          <span class="fm-count"><b id="mnShown">${fn:length(menus)}</b> из <b>${fn:length(menus)}</b> · двойной клик — состав меню</span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="mnSeg">
        <button type="button" data-f="" class="on" onclick="DK.seg('mn', this)">Все</button>
        <button type="button" data-f="A" onclick="DK.seg('mn', this)">Введены · ${cntEnt}</button>
        <button type="button" data-f="P" onclick="DK.seg('mn', this)">Подтверждены · ${fn:length(menus) - cntEnt}</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="mnSearch" placeholder="Дата или описание" oninput="DK.filter('mn')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn primary" onclick="newEatMenu()"><i class="fa fa-plus"></i>Новое меню</button>
    </div>
    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:70px">ID</th>
          <th style="width:140px">Дата</th>
          <th>Описание</th>
          <th style="width:150px">Состояние</th>
          <th style="width:90px"></th>
        </tr>
        </thead>
        <tbody id="mnRows">
        <c:forEach items="${menus}" var="obj">
          <fmt:formatDate var="md" pattern="dd.MM.yyyy" value="${obj.menuDate}"/>
          <tr data-f="${obj.state == 'ENT' ? 'A' : 'P'}" data-s="${obj.id} ${md} ${fn:escapeXml(obj.info)}" data-date="${md}" data-info="${fn:escapeXml(obj.info)}"
              ondblclick="setPage('/eats/menu/details.s?id=${obj.id}')" onclick="setPage('/eats/menu/details.s?id=${obj.id}')" title="Открыть состав меню">
            <td class="mut"><b>${obj.id}</b></td>
            <td><span class="nm">${md}</span></td>
            <td class="mut">${obj.info}</td>
            <td><span class="dk-st ${obj.state == 'ENT' ? 'P' : 'A'}">${obj.state == 'ENT' ? 'Введено' : 'Подтверждено'}</span></td>
            <td class="r" onclick="event.stopPropagation()">
              <c:if test="${obj.state == 'ENT'}">
                <button type="button" class="fm-act" title="Изменить дату и описание" onclick="editEatMenu(${obj.id}, $(this).closest('tr'))"><i class="fa fa-pencil"></i></button>
                <button type="button" class="fm-act danger" title="Удалить меню" onclick="delMenuRow(${obj.id}, '${md}')"><i class="fa fa-trash-o"></i></button>
              </c:if>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="mnEmpty" style="display:none"><i class="fa fa-calendar"></i>Меню нет</div>
    </div>
  </div>
</div>

<div class="fm-overlay" id="mnModal" onclick="if (event.target === this) DK.close('mn')">
  <div class="fm-modal" style="width:460px">
    <div class="fm-modal-head">
      <h3 id="mnTitle">Меню</h3>
      <button type="button" class="fm-x" onclick="DK.close('mn')"><i class="fa fa-times"></i></button>
    </div>
    <form id="addEditForm" name="addEditForm" onsubmit="saveEatForm(); return false">
      <div class="fm-modal-body">
        <input type="hidden" name="id"/>
        <div class="fm-err" id="mnErr"></div>
        <div style="max-width:180px">
          <label class="fm-l">Дата *</label>
          <input name="menu_date" id="menu-date" type="text" class="fm-in datepicker" autocomplete="off"/>
        </div>
        <div>
          <label class="fm-l">Описание</label>
          <input type="text" class="fm-in" name="extra_info" maxlength="256" autocomplete="off"/>
        </div>
      </div>
      <div class="fm-modal-foot">
        <span class="fm-spacer"></span>
        <button type="button" class="fm-btn" onclick="DK.close('mn')">Отмена</button>
        <button type="submit" class="fm-btn primary"><i class="fa fa-floppy-o"></i>Сохранить</button>
      </div>
    </form>
  </div>
</div>
<script>
  DK.filter('mn');
  function newEatMenu() {
    var f = document.addEditForm;
    f.reset();
    f.elements['id'].value = '';
    $('#menu-date').val('${curDate}');
    DK.open('mn', 'Новое меню');
  }
  function editEatMenu(id, tr) {
    var f = document.addEditForm;
    f.reset();
    f.elements['id'].value = id;
    $('#menu-date').val(tr.attr('data-date'));
    f.elements['extra_info'].value = tr.attr('data-info') || '';
    DK.open('mn', 'Изменить меню');
  }
  function saveEatForm() {
    if (!$.trim($('#menu-date').val())) { DK.err('mn', 'Укажите дату'); return; }
    $.ajax({
      url: '/eats/menu/save.s', method: 'post', data: $('#addEditForm').serialize(), dataType: 'json',
      success: function (res) {
        if (res.success) { openMsg(res); DK.close('mn'); setPage('/eats/menu.s'); }
        else DK.err('mn', res.msg);
      }
    });
  }
  function delMenuRow(id, date) {
    FmsConfirm('Удалить меню на ' + date + '?', function () {
      $.ajax({
        url: '/eats/menu/del.s', method: 'post', data: 'id=' + id, dataType: 'json',
        success: function (res) {
          if (res.success) { openMedMsg('Меню удалено', true); setPage('/eats/menu.s'); }
          else errMsg(res.msg);
        }
      });
    });
  }
</script>
