<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Питание → Заявки по пациентам --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<c:set var="cntEnt" value="0"/>
<c:forEach items="${list}" var="o"><c:if test="${o.state == 'ENT'}"><c:set var="cntEnt" value="${cntEnt + 1}"/></c:if></c:forEach>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-file-text-o"></i></span>
        <div>
          <h2>Заявки по пациентам</h2>
          <span class="fm-count"><b id="ecShown">${fn:length(list)}</b> из <b>${fn:length(list)}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="ecSeg">
        <button type="button" data-f="" class="on" onclick="DK.seg('ec', this)">Все</button>
        <button type="button" data-f="A" onclick="DK.seg('ec', this)">Введены · ${cntEnt}</button>
        <button type="button" data-f="P" onclick="DK.seg('ec', this)">Подтверждены · ${fn:length(list) - cntEnt}</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="ecSearch" placeholder="Дата или тип меню" oninput="DK.filter('ec')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn primary" onclick="addEatClaim()"><i class="fa fa-plus"></i>Сформировать заявку</button>
    </div>
    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:140px">Дата меню</th>
          <th>Тип меню</th>
          <th style="width:150px">Состояние</th>
          <th style="width:50px"></th>
        </tr>
        </thead>
        <tbody id="ecRows">
        <c:forEach items="${list}" var="obj">
          <fmt:formatDate var="md" pattern="dd.MM.yyyy" value="${obj.menu.menuDate}"/>
          <tr data-f="${obj.state == 'ENT' ? 'A' : 'P'}" data-s="${md} ${fn:escapeXml(obj.menuType.name)}" onclick="setPage('/eats/claim.s?id=${obj.id}')" title="Открыть заявку">
            <td><span class="nm">${md}</span></td>
            <td>${obj.menuType.name}</td>
            <td><span class="dk-st ${obj.state == 'ENT' ? 'P' : 'A'}">${obj.state == 'ENT' ? 'Введена' : 'Подтверждена'}</span></td>
            <td class="r" onclick="event.stopPropagation()">
              <button type="button" class="fm-act danger" title="Удалить заявку" onclick="delClaimRow(${obj.id}, '${md}')"><i class="fa fa-trash-o"></i></button>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="ecEmpty" style="display:none"><i class="fa fa-file-text-o"></i>Заявок нет</div>
    </div>
  </div>
</div>

<div class="fm-overlay" id="ecModal" onclick="if (event.target === this) DK.close('ec')">
  <div class="fm-modal" style="width:440px">
    <div class="fm-modal-head">
      <h3 id="ecTitle">Сформировать заявку</h3>
      <button type="button" class="fm-x" onclick="DK.close('ec')"><i class="fa fa-times"></i></button>
    </div>
    <form id="addEditForm" name="addEditForm" onsubmit="saveEatForm(); return false">
      <div class="fm-modal-body">
        <div class="fm-err" id="ecErr"></div>
        <div>
          <label class="fm-l">Меню *</label>
          <select class="fm-in" name="menu">
            <c:forEach items="${eatMenus}" var="eatMenu">
              <option value="${eatMenu.id}"><fmt:formatDate pattern="dd.MM.yyyy" value="${eatMenu.menuDate}"/></option>
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
        <button type="button" class="fm-btn" onclick="DK.close('ec')">Отмена</button>
        <button type="submit" class="fm-btn primary"><i class="fa fa-check"></i>Сформировать</button>
      </div>
    </form>
  </div>
</div>
<script>
  DK.filter('ec');
  function addEatClaim() {
    document.addEditForm.reset();
    DK.open('ec', 'Сформировать заявку');
  }
  function saveEatForm() {
    var f = $('#addEditForm'), menu = f.find('[name=menu]').val(), type = f.find('[name=menu_type]').val();
    if (!menu || !type) { DK.err('ec', 'Выберите меню и тип'); return; }
    $.ajax({
      url: '/eats/claims/check.s', method: 'post', dataType: 'json',
      data: 'menu=' + menu + '&menu_type=' + type,
      success: function (res) {
        if (res.success) { DK.close('ec'); setPage('/eats/claim.s?menu=' + menu + '&menu_type=' + type); }
        else DK.err('ec', res.msg);
      }
    });
  }
  function delClaimRow(id, date) {
    FmsConfirm('Удалить заявку на ' + date + '?', function () {
      $.ajax({
        url: '/eats/claim/del.s', method: 'post', data: 'id=' + id, dataType: 'json',
        success: function (res) {
          if (res.success) { openMedMsg('Заявка удалена', true); setPage('/eats/claims.s'); }
          else errMsg(res.msg);
        }
      });
    });
  }
</script>
