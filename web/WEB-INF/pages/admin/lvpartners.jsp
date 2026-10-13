<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<style>
  table.fm-grid tbody tr { cursor:pointer; }
  .lp-yes { display:inline-block; padding:0 7px; border-radius:6px; background:#E9F7EF; color:#1E7B43; font-size:11.5px; font-weight:600; line-height:18px; }
  .lp-no { display:inline-block; padding:0 7px; border-radius:6px; background:#F1F2F4; color:#6B7280; font-size:11.5px; font-weight:600; line-height:18px; }
</style>

<div class="fm-page fm-admin">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-briefcase"></i></span>
        <div>
          <h2>Партнеры</h2>
          <span class="fm-count"><b id="lpShown">${fn:length(rows)}</b> из <b>${fn:length(rows)}</b> · ${state == 'P' ? 'пассивные' : 'активные'}</span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg">
        <button type="button" class="${state != 'P' ? 'on' : ''}" onclick="setPage('admin/lvpartners.s?state=A')">Активные</button>
        <button type="button" class="${state == 'P' ? 'on' : ''}" onclick="setPage('admin/lvpartners.s?state=P')">Пассивные</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="lpSearch" placeholder="Код, ФИО или ID" value="${fn:escapeXml(word)}" oninput="lpFilter()" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn primary" onclick="lpEdit(0)"><i class="fa fa-plus"></i>Добавить</button>
    </div>

    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:70px">ID</th>
          <th>Код</th>
          <th>ФИО</th>
          <th style="width:130px">Состояние</th>
          <th style="width:130px">В отчётах</th>
          <th style="width:60px"></th>
        </tr>
        </thead>
        <tbody id="lpRows">
        <c:forEach items="${rows}" var="obj">
          <tr onclick="lpEdit(${obj.id})" title="Изменить"
              data-s="${obj.id} ${fn:toLowerCase(fn:escapeXml(obj.code))} ${fn:toLowerCase(fn:escapeXml(obj.fio))}">
            <td class="mut"><b>${obj.id}</b></td>
            <td><span class="nm">${obj.code}</span></td>
            <td class="mut">${obj.fio}</td>
            <td><span class="${obj.state == 'A' ? 'lp-yes' : 'lp-no'}">${obj.state == 'A' ? 'Активный' : 'Пассивный'}</span></td>
            <td><span class="${obj.report == 'Y' ? 'lp-no' : 'lp-yes'}">${obj.report == 'Y' ? 'Нет' : 'Да'}</span></td>
            <td class="r"><button type="button" class="fm-act" title="Изменить"><i class="fa fa-pencil"></i></button></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="lpEmpty" style="display:none"><i class="fa fa-briefcase"></i>Партнеры не найдены</div>
    </div>
  </div>
</div>

<div class="fm-overlay fm-admin" id="lpModal" onclick="if (event.target === this) lpClose()">
  <div class="fm-modal" style="width:480px">
    <div class="fm-modal-head">
      <h3 id="lpTitle">Партнер</h3>
      <button type="button" class="fm-x" onclick="lpClose()"><i class="fa fa-times"></i></button>
    </div>
    <form id="addEditForm" name="addEditForm" onsubmit="saveDrugForm(); return false">
      <div class="fm-modal-body">
        <input type="hidden" name="id" value=""/>
        <div class="fm-err" id="lpErr"></div>
        <div>
          <label class="fm-l">Код *</label>
          <input type="text" id="category-code" class="fm-in" name="code" autocomplete="off"/>
        </div>
        <div>
          <label class="fm-l">ФИО</label>
          <input type="text" class="fm-in" name="fio" autocomplete="off"/>
        </div>
        <div style="display:flex; flex-wrap:wrap; align-items:center; gap:8px">
          <div class="fm-state">
            <label><input type="radio" class="a" name="state" value="A" checked/><span>Активный</span></label>
            <label><input type="radio" class="p" name="state" value="P"/><span>Пассивный</span></label>
          </div>
          <label class="fm-tgl"><input type="checkbox" name="report" value="Y"/><span>Не отображать в отчётах</span></label>
        </div>
      </div>
      <div class="fm-modal-foot">
        <span class="fm-spacer"></span>
        <button type="button" class="fm-btn" onclick="lpClose()">Отмена</button>
        <button type="submit" class="fm-btn primary" id="lpSave"><i class="fa fa-floppy-o"></i>Сохранить</button>
      </div>
    </form>
  </div>
</div>

<script>
  function lpFilter() {
    var q = $.trim($('#lpSearch').val()).toLowerCase();
    var n = 0;
    $('#lpRows tr').each(function () {
      var ok = !q || String($(this).data('s')).indexOf(q) >= 0;
      $(this).toggle(ok);
      if (ok) n++;
    });
    $('#lpShown').text(n);
    $('#lpEmpty').toggle(n == 0);
  }
  lpFilter();
  function lpClose() { $('#lpModal').removeClass('open'); }
  function lpEdit(id) {
    var f = document.addEditForm;
    f.reset();
    f.elements['id'].value = '';
    $('#lpErr').hide();
    $('#lpTitle').text(id ? 'Изменить партнера' : 'Новый партнер');
    $('#lpModal').addClass('open');
    if (!id) { f.code.focus(); return; }
    $.ajax({
      url: '/admin/lvpartner/get.s', method: 'post', data: 'id=' + id, dataType: 'json',
      success: function (res) {
        if (!res.success) { $('#lpErr').text(res.msg).show(); return; }
        f.elements['id'].value = res.id;
        f.code.value = res.code;
        f.fio.value = res.fio || '';
        $(f).find('[name=state][value=' + (res.state == 'A' ? 'A' : 'P') + ']').prop('checked', true);
        f.report.checked = res.report == 'Y';
      }
    });
  }
  function saveDrugForm() {
    if ($.trim($('#category-code').val()) == '') {
      $('#lpErr').text('Код не может быть пустым').show();
      return;
    }
    $('#lpSave').prop('disabled', true);
    $.ajax({
      url: '/admin/lvpartner/save.s', method: 'post', data: $('#addEditForm').serialize(), dataType: 'json',
      success: function (res) {
        if (res.success) {
          openMsg(res);
          lpClose();
          setPage('/admin/lvpartners.s?state=${state == 'P' ? 'P' : 'A'}');
        } else $('#lpErr').text(res.msg).show();
      },
      complete: function () { $('#lpSave').prop('disabled', false); }
    });
  }
</script>
