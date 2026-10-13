<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<%@include file="/WEB-INF/pages/core/ambv2/list_style.jsp"%>
<c:set var="cntA" value="0"/>
<c:forEach items="${groups}" var="g"><c:if test="${g.active}"><c:set var="cntA" value="${cntA + 1}"/></c:if></c:forEach>

<div class="fm-page fm-admin">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-folder-o"></i></span>
        <div>
          <h2>Амбулаторные группы</h2>
          <span class="fm-count"><b id="agShown">${fn:length(groups)}</b> из <b>${fn:length(groups)}</b> · активных <b>${cntA}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="agSeg">
        <button type="button" data-f="" class="on" onclick="avSeg('ag', this)">Все</button>
        <button type="button" data-f="A" onclick="avSeg('ag', this)">Активные</button>
        <button type="button" data-f="P" onclick="avSeg('ag', this)">Пассивные</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="agSearch" placeholder="Название или ID" oninput="avFilter('ag')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn primary" onclick="agEdit(null)"><i class="fa fa-plus"></i>Новая группа</button>
    </div>

    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:60px">ID</th>
          <th>Наименование</th>
          <th style="width:150px" class="r">Бонус партнёрам</th>
          <th style="width:110px" class="c">Группа</th>
          <th style="width:130px" class="c">Физиотерапия</th>
          <th style="width:120px">Состояние</th>
          <th style="width:50px"></th>
        </tr>
        </thead>
        <tbody id="agRows">
        <c:forEach items="${groups}" var="g">
          <tr data-f="${g.active ? 'A' : 'P'}" data-s="${g.id} ${fn:toLowerCase(fn:escapeXml(g.name))}"
              data-id="${g.id}" data-name="${fn:escapeXml(g.name)}" data-proc="${g.partnerProc}"
              data-group="${g.group ? 'Y' : 'N'}" data-fizio="${g.fizio ? 'Y' : 'N'}" data-active="${g.active ? 'Y' : 'N'}"
              onclick="agEdit(this)" title="Изменить">
            <td class="mut"><b>${g.id}</b></td>
            <td><span class="nm">${g.name}</span></td>
            <td class="r"><c:if test="${g.partnerProc > 0}"><fmt:formatNumber value="${g.partnerProc}" maxFractionDigits="2"/>%</c:if><c:if test="${!(g.partnerProc > 0)}"><span class="av-no">—</span></c:if></td>
            <td class="c">${g.group ? '<span class="av-yes">Да</span>' : '<span class="av-no">—</span>'}</td>
            <td class="c">${g.fizio ? '<span class="av-yes">Да</span>' : '<span class="av-no">—</span>'}</td>
            <td><span class="av-st ${g.active ? 'A' : 'P'}">${g.active ? 'Активный' : 'Пассивный'}</span></td>
            <td class="r"><button type="button" class="fm-act" title="Изменить"><i class="fa fa-pencil"></i></button></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="agEmpty" style="display:none"><i class="fa fa-folder-o"></i>Группы не найдены</div>
    </div>
  </div>
</div>

<div class="fm-overlay fm-admin" id="agModal" onclick="if (event.target === this) avClose('ag')">
  <div class="fm-modal" style="width:480px">
    <div class="fm-modal-head">
      <h3 id="agTitle">Группа</h3>
      <button type="button" class="fm-x" onclick="avClose('ag')"><i class="fa fa-times"></i></button>
    </div>
    <form id="agForm" onsubmit="agSave(); return false">
      <div class="fm-modal-body">
        <input type="hidden" name="id"/>
        <div class="fm-err" id="agErr"></div>
        <div>
          <label class="fm-l">Наименование *</label>
          <input type="text" class="fm-in" name="name" maxlength="255" autocomplete="off"/>
        </div>
        <div style="max-width:200px">
          <label class="fm-l">Бонус партнёрам, %</label>
          <input type="number" class="fm-in" name="partnerProc" min="0" max="100" step="0.01" style="text-align:right"/>
        </div>
        <div>
          <label class="fm-chk"><input type="checkbox" name="group" value="A"/> Группа</label>
          <label class="fm-chk"><input type="checkbox" name="fizio" value="A"/> Физиотерапия</label>
          <label class="fm-chk"><input type="checkbox" name="active" value="A"/> Активная</label>
        </div>
      </div>
      <div class="fm-modal-foot">
        <span class="fm-spacer"></span>
        <button type="button" class="fm-btn" onclick="avClose('ag')">Отмена</button>
        <button type="submit" class="fm-btn primary" id="agSaveBtn"><i class="fa fa-check"></i>Сохранить</button>
      </div>
    </form>
  </div>
</div>

<script>
  avFilter('ag');
  function agEdit(tr) {
    var f = document.getElementById('agForm'), d = tr ? $(tr).data() : {};
    f.reset();
    $('#agErr').hide();
    f.elements['id'].value = tr ? d.id : '';
    f.elements['name'].value = tr ? $(tr).attr('data-name') : '';
    f.elements['partnerProc'].value = tr ? d.proc : '';
    f.elements['group'].checked = tr ? d.group == 'Y' : true;
    f.elements['fizio'].checked = tr && d.fizio == 'Y';
    f.elements['active'].checked = tr ? d.active == 'Y' : true;
    $('#agTitle').text(tr ? 'Изменить группу' : 'Новая группа');
    $('#agModal').addClass('open');
    f.elements['name'].focus();
  }
  function agSave() {
    var f = document.getElementById('agForm');
    if (!$.trim(f.elements['name'].value)) { $('#agErr').text('Укажите наименование').show(); return; }
    $('#agSaveBtn').prop('disabled', true);
    $.ajax({
      url: '/core/ambv2/group/save.s', method: 'post', data: $(f).serialize(), dataType: 'json',
      success: function (res) {
        if (res.success) { openMsg(res); avClose('ag'); $('#pager').load('/core/ambv2/groups.s'); }
        else $('#agErr').text(res.msg).show();
      },
      complete: function () { $('#agSaveBtn').prop('disabled', false); }
    });
  }
</script>
