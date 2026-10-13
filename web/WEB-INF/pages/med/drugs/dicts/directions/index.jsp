<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Аптека → Справочники → Получатели (склады отделений) --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<c:set var="cntA" value="0"/>
<c:forEach items="${list}" var="o"><c:if test="${o.state == 'A'}"><c:set var="cntA" value="${cntA + 1}"/></c:if></c:forEach>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-sitemap"></i></span>
        <div>
          <h2>Получатели</h2>
          <span class="fm-count"><b id="drShown">${fn:length(list)}</b> из <b>${fn:length(list)}</b> · активных <b>${cntA}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="drSeg">
        <button type="button" data-f="" class="on" onclick="DK.seg('dr', this)">Все</button>
        <button type="button" data-f="A" onclick="DK.seg('dr', this)">Активные</button>
        <button type="button" data-f="P" onclick="DK.seg('dr', this)">Пассивные</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="drSearch" placeholder="Название или ID" oninput="DK.filter('dr')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn primary" onclick="drEdit(0)"><i class="fa fa-plus"></i>Добавить</button>
    </div>
    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:70px">ID</th>
          <th>Наименование</th>
          <th style="width:150px" class="c">Экстренный шкаф</th>
          <th style="width:110px" class="c">Перевод</th>
          <th style="width:130px">Состояние</th>
          <th style="width:50px"></th>
        </tr>
        </thead>
        <tbody id="drRows">
        <c:forEach items="${list}" var="obj">
          <tr data-f="${obj.state == 'A' ? 'A' : 'P'}" data-s="${obj.id} ${fn:escapeXml(obj.name)}" data-name="${fn:escapeXml(obj.name)}" onclick="drEdit(${obj.id})" title="Изменить">
            <td class="mut"><b>${obj.id}</b></td>
            <td><span class="nm">${obj.name}</span></td>
            <td class="c">${obj.shock == 'Y' ? '<span class="dk-yes">Да</span>' : '<span class="dk-no">—</span>'}</td>
            <td class="c">${obj.transfer == 'Y' ? '<span class="dk-yes">Да</span>' : '<span class="dk-no">—</span>'}</td>
            <td><span class="dk-st ${obj.state == 'A' ? 'A' : 'P'}">${obj.state == 'A' ? 'Активный' : 'Пассивный'}</span></td>
            <td class="r" onclick="event.stopPropagation()">
              <button type="button" class="fm-act danger" title="Удалить" onclick="DK.del('direction', ${obj.id}, $(this).closest('tr').attr('data-name'), 'directions')"><i class="fa fa-trash-o"></i></button>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="drEmpty" style="display:none"><i class="fa fa-sitemap"></i>Ничего не найдено</div>
    </div>
  </div>
</div>

<div class="fm-overlay" id="drModal" onclick="if (event.target === this) DK.close('dr')">
  <div class="fm-modal" style="width:640px">
    <div class="fm-modal-head">
      <h3 id="drTitle"></h3>
      <button type="button" class="fm-x" onclick="DK.close('dr')"><i class="fa fa-times"></i></button>
    </div>
    <form id="drForm" onsubmit="drSave(); return false">
      <div class="fm-modal-body">
        <input type="hidden" name="id"/>
        <input type="hidden" name="code" value="direction"/>
        <div class="fm-err" id="drErr"></div>
        <div>
          <label class="fm-l">Наименование *</label>
          <input type="text" class="fm-in" name="name" autocomplete="off"/>
        </div>
        <div style="display:flex; flex-wrap:wrap; align-items:center; gap:8px">
          <div class="fm-state">
            <label><input type="radio" class="a" name="state" value="Y" checked/><span>Активный</span></label>
            <label><input type="radio" class="p" name="state" value=""/><span>Пассивный</span></label>
          </div>
          <label class="fm-tgl"><input type="checkbox" name="shock" value="Y"/><span>Экстренный шкаф</span></label>
          <label class="fm-tgl"><input type="checkbox" name="transfer" value="Y"/><span>Перевод</span></label>
        </div>
        <div>
          <label class="fm-l">Отделения</label>
          <div class="dk-checks">
            <c:forEach items="${deps}" var="dep">
              <label><input type="checkbox" class="dep_checkbox" value="${dep.id}" id="dep_${dep.id}" name="dep"/> ${dep.name}</label>
            </c:forEach>
          </div>
        </div>
        <div class="fm-hint" id="drUsersBox"><b style="color:#6B7280">Пользователи:</b> <span id="direction_users"></span></div>
      </div>
      <div class="fm-modal-foot">
        <span class="fm-spacer"></span>
        <button type="button" class="fm-btn" onclick="DK.close('dr')">Отмена</button>
        <button type="submit" class="fm-btn primary"><i class="fa fa-floppy-o"></i>Сохранить</button>
      </div>
    </form>
  </div>
</div>
<script>
  DK.filter('dr');
  function drEdit(id) {
    var f = document.getElementById('drForm');
    f.reset();
    f.elements['id'].value = '';
    $('#direction_users').text('');
    $('#drUsersBox').hide();
    DK.open('dr', id ? 'Изменить получателя' : 'Новый получатель');
    if (!id) return;
    DK.get('dr', 'direction', id, function (res) {
      f.elements['id'].value = res.id;
      f.elements['name'].value = res.name || '';
      DK.setState(f, res.state == 'A');
      f.elements['shock'].checked = res.shock == 'Y';
      f.elements['transfer'].checked = res.transfer == 'Y';
      $('.dep_checkbox').prop('checked', false);
      $.each(res.deps || [], function (i, d) { $('#dep_' + d).prop('checked', true); });
      $('#direction_users').text(res.users || '');
      $('#drUsersBox').toggle(!!res.users);
    });
  }
  function drSave() {
    var f = document.getElementById('drForm');
    if (!$.trim(f.elements['name'].value)) { DK.err('dr', 'Укажите наименование'); return; }
    DK.save('dr', f, 'directions');
  }
</script>
