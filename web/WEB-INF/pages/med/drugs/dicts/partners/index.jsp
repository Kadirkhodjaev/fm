<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Аптека → Справочники → Поставщики --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-truck"></i></span>
        <div>
          <h2>Поставщики</h2>
          <span class="fm-count"><b id="ptShown">${fn:length(list)}</b> из <b>${fn:length(list)}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="ptSearch" placeholder="Название, телефон, email" oninput="DK.filter('pt')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn primary" onclick="ptEdit(0)"><i class="fa fa-plus"></i>Добавить</button>
    </div>
    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:70px">ID</th>
          <th>Наименование</th>
          <th style="width:180px">Телефон</th>
          <th style="width:240px">Email</th>
          <th style="width:110px" class="c">Очерёдность</th>
          <th style="width:50px"></th>
        </tr>
        </thead>
        <tbody id="ptRows">
        <c:forEach items="${list}" var="obj">
          <tr data-s="${obj.id} ${fn:escapeXml(obj.name)} ${fn:escapeXml(obj.phone)} ${fn:escapeXml(obj.email)}" data-name="${fn:escapeXml(obj.name)}" onclick="ptEdit(${obj.id})" title="Изменить">
            <td class="mut"><b>${obj.id}</b></td>
            <td><span class="nm">${obj.name}</span></td>
            <td class="mut">${obj.phone}</td>
            <td class="mut">${obj.email}</td>
            <td class="c"><fmt:formatNumber value="${obj.ord}" maxFractionDigits="0"/></td>
            <td class="r" onclick="event.stopPropagation()">
              <button type="button" class="fm-act danger" title="Удалить" onclick="DK.del('partner', ${obj.id}, $(this).closest('tr').attr('data-name'), 'partners')"><i class="fa fa-trash-o"></i></button>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="ptEmpty" style="display:none"><i class="fa fa-truck"></i>Ничего не найдено</div>
    </div>
  </div>
</div>

<div class="fm-overlay" id="ptModal" onclick="if (event.target === this) DK.close('pt')">
  <div class="fm-modal" style="width:520px">
    <div class="fm-modal-head">
      <h3 id="ptTitle"></h3>
      <button type="button" class="fm-x" onclick="DK.close('pt')"><i class="fa fa-times"></i></button>
    </div>
    <form id="ptForm" onsubmit="ptSave(); return false">
      <div class="fm-modal-body">
        <input type="hidden" name="id"/>
        <input type="hidden" name="code" value="partner"/>
        <div class="fm-err" id="ptErr"></div>
        <div>
          <label class="fm-l">Наименование *</label>
          <input type="text" class="fm-in" name="name" autocomplete="off"/>
        </div>
        <div class="fm-row" style="grid-template-columns:1fr 1fr 110px">
          <div><label class="fm-l">Телефон</label><input type="text" class="fm-in" name="phone" autocomplete="off"/></div>
          <div><label class="fm-l">Email</label><input type="text" class="fm-in" name="email" autocomplete="off"/></div>
          <div><label class="fm-l">Очерёдность</label><input type="number" class="fm-in" name="ord" style="text-align:center"/></div>
        </div>
      </div>
      <div class="fm-modal-foot">
        <span class="fm-spacer"></span>
        <button type="button" class="fm-btn" onclick="DK.close('pt')">Отмена</button>
        <button type="submit" class="fm-btn primary"><i class="fa fa-floppy-o"></i>Сохранить</button>
      </div>
    </form>
  </div>
</div>
<script>
  DK.filter('pt');
  function ptEdit(id) {
    var f = document.getElementById('ptForm');
    f.reset();
    f.elements['id'].value = '';
    DK.open('pt', id ? 'Изменить поставщика' : 'Новый поставщик');
    f.elements['name'].focus();
    if (!id) return;
    DK.get('pt', 'partner', id, function (res) {
      f.elements['id'].value = res.id;
      f.elements['name'].value = res.name || '';
      f.elements['phone'].value = res.phone || '';
      f.elements['email'].value = res.email || '';
      f.elements['ord'].value = res.ord == null ? '' : res.ord;
    });
  }
  function ptSave() {
    var f = document.getElementById('ptForm');
    if (!$.trim(f.elements['name'].value)) { DK.err('pt', 'Укажите наименование'); return; }
    DK.save('pt', f, 'partners');
  }
</script>
