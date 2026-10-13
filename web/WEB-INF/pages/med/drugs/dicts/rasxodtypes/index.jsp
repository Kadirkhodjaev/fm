<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Аптека → Справочники → Типы расходов и склады, где они доступны --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<c:set var="cntA" value="0"/>
<c:forEach items="${list}" var="o"><c:if test="${o.state == 'A'}"><c:set var="cntA" value="${cntA + 1}"/></c:if></c:forEach>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-random"></i></span>
        <div>
          <h2>Типы расходов</h2>
          <span class="fm-count"><b id="rtShown">${fn:length(list)}</b> из <b>${fn:length(list)}</b> · активных <b>${cntA}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="rtSeg">
        <button type="button" data-f="" class="on" onclick="DK.seg('rt', this)">Все</button>
        <button type="button" data-f="A" onclick="DK.seg('rt', this)">Активные</button>
        <button type="button" data-f="P" onclick="DK.seg('rt', this)">Пассивные</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="rtSearch" placeholder="Название или ID" oninput="DK.filter('rt')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn primary" onclick="rtEdit(0)"><i class="fa fa-plus"></i>Добавить</button>
    </div>
    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:70px">ID</th>
          <th>Наименование</th>
          <th style="width:130px">Состояние</th>
          <th style="width:50px"></th>
        </tr>
        </thead>
        <tbody id="rtRows">
        <c:forEach items="${list}" var="obj">
          <tr data-f="${obj.state == 'A' ? 'A' : 'P'}" data-s="${obj.id} ${fn:escapeXml(obj.name)}" data-name="${fn:escapeXml(obj.name)}" onclick="rtEdit(${obj.id})" title="Изменить">
            <td class="mut"><b>${obj.id}</b></td>
            <td><span class="nm">${obj.name}</span></td>
            <td><span class="dk-st ${obj.state == 'A' ? 'A' : 'P'}">${obj.state == 'A' ? 'Активный' : 'Пассивный'}</span></td>
            <td class="r" onclick="event.stopPropagation()">
              <button type="button" class="fm-act danger" title="Удалить" onclick="DK.del('rasxodtype', ${obj.id}, $(this).closest('tr').attr('data-name'), 'rasxodtypes')"><i class="fa fa-trash-o"></i></button>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="rtEmpty" style="display:none"><i class="fa fa-random"></i>Ничего не найдено</div>
    </div>
  </div>
</div>

<div class="fm-overlay" id="rtModal" onclick="if (event.target === this) DK.close('rt')">
  <div class="fm-modal" style="width:620px">
    <div class="fm-modal-head">
      <h3 id="rtTitle"></h3>
      <button type="button" class="fm-x" onclick="DK.close('rt')"><i class="fa fa-times"></i></button>
    </div>
    <form id="rtForm" onsubmit="rtSave(); return false">
      <div class="fm-modal-body">
        <input type="hidden" name="id"/>
        <input type="hidden" name="code" value="rasxodtype"/>
        <div class="fm-err" id="rtErr"></div>
        <div>
          <label class="fm-l">Наименование *</label>
          <input type="text" class="fm-in" name="name" autocomplete="off"/>
        </div>
        <div class="fm-state" style="align-self:flex-start">
          <label><input type="radio" class="a" name="state" value="Y" checked/><span>Активный</span></label>
          <label><input type="radio" class="p" name="state" value=""/><span>Пассивный</span></label>
        </div>
        <div>
          <label class="fm-l">Склады, где доступен</label>
          <div class="dk-checks">
            <c:forEach items="${rows}" var="r">
              <label><input type="checkbox" class="rt_dir" name="direction_${r.id}" value="${r.id}"/> ${r.name}</label>
            </c:forEach>
          </div>
        </div>
      </div>
      <div class="fm-modal-foot">
        <span class="fm-spacer"></span>
        <button type="button" class="fm-btn" onclick="DK.close('rt')">Отмена</button>
        <button type="submit" class="fm-btn primary"><i class="fa fa-floppy-o"></i>Сохранить</button>
      </div>
    </form>
  </div>
</div>
<script>
  DK.filter('rt');
  function rtEdit(id) {
    var f = document.getElementById('rtForm');
    f.reset();
    f.elements['id'].value = '';
    $('.rt_dir').prop('checked', false);
    DK.open('rt', id ? 'Изменить тип расхода' : 'Новый тип расхода');
    f.elements['name'].focus();
    if (!id) return;
    DK.get('rt', 'rasxodtype', id, function (res) {
      f.elements['id'].value = res.id;
      f.elements['name'].value = res.name || '';
      DK.setState(f, !!res.state);
      $.each(res, function (k, v) { if (k.indexOf('direction_') === 0 && f.elements[k]) f.elements[k].checked = !!v; });
    });
  }
  function rtSave() {
    var f = document.getElementById('rtForm');
    if (!$.trim(f.elements['name'].value)) { DK.err('rt', 'Укажите наименование'); return; }
    DK.save('rt', f, 'rasxodtypes');
  }
</script>
