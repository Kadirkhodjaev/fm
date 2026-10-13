<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Администрирование → Стационар → вкладка «Группы» (грузится в #pager страницы core/stat/hub.jsp) --%>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<%@include file="/WEB-INF/pages/core/ambv2/list_style.jsp"%>
<c:set var="cntA" value="0"/>
<c:forEach items="${groups}" var="g"><c:if test="${g.state == 'A'}"><c:set var="cntA" value="${cntA + 1}"/></c:if></c:forEach>

<div class="fm-page fm-admin">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-folder-o"></i></span>
        <div>
          <h2>Стационарные группы</h2>
          <span class="fm-count"><b id="sgShown">${fn:length(groups)}</b> из <b>${fn:length(groups)}</b> · активных <b>${cntA}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="sgSeg">
        <button type="button" data-f="" class="on" onclick="avSeg('sg', this)">Все</button>
        <button type="button" data-f="A" onclick="avSeg('sg', this)">Активные</button>
        <button type="button" data-f="P" onclick="avSeg('sg', this)">Пассивные</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="sgSearch" placeholder="Название или ID" oninput="avFilter('sg')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn primary" onclick="sgEdit(null)"><i class="fa fa-plus"></i>Новая группа</button>
    </div>

    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:60px">ID</th>
          <th>Наименование</th>
          <th style="width:110px" class="c">Группа</th>
          <th style="width:120px" class="c">Лаборатория</th>
          <th style="width:120px">Состояние</th>
          <th style="width:50px"></th>
        </tr>
        </thead>
        <tbody id="sgRows">
        <c:forEach items="${groups}" var="g">
          <tr data-f="${g.state == 'A' ? 'A' : 'P'}" data-s="${g.id} ${fn:toLowerCase(fn:escapeXml(g.name))}"
              data-id="${g.id}" data-name="${fn:escapeXml(g.name)}" data-group="${g.groupState}" data-lab="${g.labFlag}" data-active="${g.state}"
              onclick="sgEdit(this)" title="Изменить">
            <td class="mut"><b>${g.id}</b></td>
            <td><span class="nm">${g.name}</span></td>
            <td class="c">${g.groupState == 'Y' ? '<span class="av-yes">Да</span>' : '<span class="av-no">—</span>'}</td>
            <td class="c">${g.labFlag == 'Y' ? '<span class="av-yes">Да</span>' : '<span class="av-no">—</span>'}</td>
            <td><span class="av-st ${g.state == 'A' ? 'A' : 'P'}">${g.state == 'A' ? 'Активный' : 'Пассивный'}</span></td>
            <td class="r"><button type="button" class="fm-act" title="Изменить"><i class="fa fa-pencil"></i></button></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="sgEmpty" style="display:none"><i class="fa fa-folder-o"></i>Группы не найдены</div>
    </div>
  </div>
</div>

<div class="fm-overlay fm-admin" id="sgModal" onclick="if (event.target === this) avClose('sg')">
  <div class="fm-modal" style="width:500px">
    <div class="fm-modal-head">
      <h3 id="sgTitle">Группа</h3>
      <button type="button" class="fm-x" onclick="avClose('sg')"><i class="fa fa-times"></i></button>
    </div>
    <form id="sgForm" onsubmit="sgSave(); return false">
      <div class="fm-modal-body">
        <input type="hidden" name="id"/>
        <div class="fm-err" id="sgErr"></div>
        <div>
          <label class="fm-l">Наименование *</label>
          <input type="text" class="fm-in" name="name" maxlength="128" autocomplete="off"/>
        </div>
        <div style="display:flex; flex-wrap:wrap; align-items:center; gap:8px">
          <div class="fm-state">
            <label><input type="radio" class="a" name="active" value="A"/><span>Активная</span></label>
            <label><input type="radio" class="p" name="active" value=""/><span>Пассивная</span></label>
          </div>
          <label class="fm-tgl"><input type="checkbox" name="group" value="Y"/><span>Группа</span></label>
          <label class="fm-tgl"><input type="checkbox" name="lab_flag" value="Y"/><span>Лаборатория</span></label>
        </div>
      </div>
      <div class="fm-modal-foot">
        <span class="fm-spacer"></span>
        <button type="button" class="fm-btn" onclick="avClose('sg')">Отмена</button>
        <button type="submit" class="fm-btn primary" id="sgSaveBtn"><i class="fa fa-floppy-o"></i>Сохранить</button>
      </div>
    </form>
  </div>
</div>

<script>
  avFilter('sg');
  function sgEdit(tr) {
    var f = document.getElementById('sgForm'), d = tr ? $(tr).data() : {};
    f.reset();
    $('#sgErr').hide();
    f.elements['id'].value = tr ? d.id : '';
    f.elements['name'].value = tr ? $(tr).attr('data-name') : '';
    f.elements['group'].checked = tr && d.group == 'Y';
    f.elements['lab_flag'].checked = tr && d.lab == 'Y';
    $(f).find('[name=active][value="' + (!tr || d.active == 'A' ? 'A' : '') + '"]').prop('checked', true);
    $('#sgTitle').text(tr ? 'Изменить группу' : 'Новая группа');
    $('#sgModal').addClass('open');
    f.elements['name'].focus();
  }
  function sgSave() {
    var f = document.getElementById('sgForm');
    if (!$.trim(f.elements['name'].value)) { $('#sgErr').text('Укажите наименование').show(); return; }
    $('#sgSaveBtn').prop('disabled', true);
    $.ajax({
      url: '/core/stat/group/save.s', method: 'post', data: $(f).serialize(), dataType: 'json',
      success: function (res) {
        if (res.success) { openMsg(res); avClose('sg'); $('#pager').load('/core/stat/groups.s'); }
        else $('#sgErr').text(res.msg).show();
      },
      complete: function () { $('#sgSaveBtn').prop('disabled', false); }
    });
  }
</script>
