<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Администрирование → Отделения и старшие медсёстры --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<c:set var="cntA" value="0"/>
<c:forEach items="${rows}" var="o"><c:if test="${o.state == 'A'}"><c:set var="cntA" value="${cntA + 1}"/></c:if></c:forEach>
<div class="fm-page fm-admin">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-sitemap"></i></span>
        <div>
          <h2>Отделения</h2>
          <span class="fm-count"><b id="dpShown">${fn:length(rows)}</b> из <b>${fn:length(rows)}</b> · активных <b>${cntA}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="dpSeg">
        <button type="button" data-f="" class="on" onclick="DK.seg('dp', this)">Все</button>
        <button type="button" data-f="A" onclick="DK.seg('dp', this)">Активные</button>
        <button type="button" data-f="P" onclick="DK.seg('dp', this)">Пассивные</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="dpSearch" placeholder="Отделение или медсестра" oninput="DK.filter('dp')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn primary" onclick="dpEdit(0)"><i class="fa fa-plus"></i>Новое отделение</button>
    </div>
    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:70px">ID</th>
          <th>Наименование</th>
          <th style="width:300px">Старшая медсестра</th>
          <th style="width:130px">Состояние</th>
          <th style="width:50px"></th>
        </tr>
        </thead>
        <tbody id="dpRows">
        <c:forEach items="${rows}" var="obj">
          <tr data-f="${obj.state == 'A' ? 'A' : 'P'}" data-s="${obj.id} ${fn:escapeXml(obj.name)} ${fn:escapeXml(obj.nurse.fio)}" onclick="dpEdit(${obj.id})" title="Изменить">
            <td class="mut"><b>${obj.id}</b></td>
            <td><span class="nm">${obj.name}</span></td>
            <td class="mut">${obj.nurse.fio}</td>
            <td><span class="dk-st ${obj.state == 'A' ? 'A' : 'P'}">${obj.state == 'A' ? 'Активный' : 'Пассивный'}</span></td>
            <td class="r"><button type="button" class="fm-act" title="Изменить"><i class="fa fa-pencil"></i></button></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="dpEmpty" style="display:none"><i class="fa fa-sitemap"></i>Ничего не найдено</div>
    </div>
  </div>
</div>

<div class="fm-overlay fm-admin" id="dpModal" onclick="if (event.target === this) DK.close('dp')">
  <div class="fm-modal" style="width:500px">
    <div class="fm-modal-head">
      <h3 id="dpTitle"></h3>
      <button type="button" class="fm-x" onclick="DK.close('dp')"><i class="fa fa-times"></i></button>
    </div>
    <form id="dpForm" onsubmit="dpSave(); return false">
      <div class="fm-modal-body">
        <input type="hidden" name="id"/>
        <div class="fm-err" id="dpErr"></div>
        <div>
          <label class="fm-l">Наименование *</label>
          <input type="text" class="fm-in" name="name" autocomplete="off"/>
        </div>
        <div>
          <label class="fm-l">Старшая медсестра *</label>
          <select class="fm-in" name="user">
            <c:forEach items="${users}" var="user">
              <option value="${user.id}">${user.fio}</option>
            </c:forEach>
          </select>
        </div>
        <div class="fm-state" style="align-self:flex-start">
          <label><input type="radio" class="a" name="state" value="A" checked/><span>Активное</span></label>
          <label><input type="radio" class="p" name="state" value="P"/><span>Пассивное</span></label>
        </div>
      </div>
      <div class="fm-modal-foot">
        <span class="fm-spacer"></span>
        <button type="button" class="fm-btn" onclick="DK.close('dp')">Отмена</button>
        <button type="submit" class="fm-btn primary"><i class="fa fa-floppy-o"></i>Сохранить</button>
      </div>
    </form>
  </div>
</div>
<script>
  DK.filter('dp');
  function dpEdit(id) {
    var f = document.getElementById('dpForm');
    f.reset();
    f.elements['id'].value = '';
    DK.open('dp', id ? 'Изменить отделение' : 'Новое отделение');
    if (!id) { f.elements['name'].focus(); return; }
    $.ajax({
      url: '/admin/dept/get.s', method: 'post', data: 'id=' + id, dataType: 'json',
      success: function (res) {
        if (!res.success) { DK.err('dp', res.msg); return; }
        f.elements['id'].value = res.id;
        f.elements['name'].value = res.name || '';
        $(f.elements['user']).val(res.nurse).trigger('change');
        $(f).find('[name=state][value=' + (res.state == 'A' ? 'A' : 'P') + ']').prop('checked', true);
      }
    });
  }
  function dpSave() {
    var f = document.getElementById('dpForm');
    if (!$.trim(f.elements['name'].value)) { DK.err('dp', 'Укажите наименование'); return; }
    $.ajax({
      url: '/admin/dept/save.s', method: 'post', data: $(f).serialize(), dataType: 'json',
      success: function (res) {
        if (res.success) { openMsg(res); DK.close('dp'); setPage('/admin/depts.s'); }
        else DK.err('dp', res.msg);
      }
    });
  }
</script>
