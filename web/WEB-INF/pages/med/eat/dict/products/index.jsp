<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Питание → Справочники → Продукты --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<style>.pr-cat { display:inline-block; padding:0 7px; border-radius:6px; background:#EEF1F6; color:#3C4A63; font-size:11.5px; font-weight:600; line-height:18px; }</style>
<c:set var="cntA" value="0"/>
<c:forEach items="${list}" var="o"><c:if test="${o.state == 'A'}"><c:set var="cntA" value="${cntA + 1}"/></c:if></c:forEach>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-shopping-cart"></i></span>
        <div>
          <h2>Продукты</h2>
          <span class="fm-count"><b id="prShown">${fn:length(list)}</b> из <b>${fn:length(list)}</b> · активных <b>${cntA}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="prSeg">
        <button type="button" data-f="" class="on" onclick="DK.seg('pr', this)">Все</button>
        <button type="button" data-f="A" onclick="DK.seg('pr', this)">Активные</button>
        <button type="button" data-f="P" onclick="DK.seg('pr', this)">Пассивные</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="prSearch" placeholder="Продукт или категория" oninput="DK.filter('pr')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn primary" onclick="prEdit(0)"><i class="fa fa-plus"></i>Добавить</button>
    </div>
    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:70px">ID</th>
          <th style="width:220px">Категория</th>
          <th>Наименование</th>
          <th style="width:130px">Состояние</th>
          <th style="width:50px"></th>
        </tr>
        </thead>
        <tbody id="prRows">
        <c:forEach items="${list}" var="obj">
          <tr data-f="${obj.state == 'A' ? 'A' : 'P'}" data-s="${obj.id} ${fn:escapeXml(obj.name)} ${fn:escapeXml(obj.category.name)}" data-name="${fn:escapeXml(obj.name)}" onclick="prEdit(${obj.id})" title="Изменить">
            <td class="mut"><b>${obj.id}</b></td>
            <td><span class="pr-cat">${obj.category.name}</span></td>
            <td><span class="nm">${obj.name}</span></td>
            <td><span class="dk-st ${obj.state == 'A' ? 'A' : 'P'}">${obj.state == 'A' ? 'Активный' : 'Пассивный'}</span></td>
            <td class="r" onclick="event.stopPropagation()">
              <button type="button" class="fm-act danger" title="Удалить" onclick="DK.del('product', ${obj.id}, $(this).closest('tr').attr('data-name'), 'products')"><i class="fa fa-trash-o"></i></button>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="prEmpty" style="display:none"><i class="fa fa-shopping-cart"></i>Ничего не найдено</div>
    </div>
  </div>
</div>

<div class="fm-overlay" id="prModal" onclick="if (event.target === this) DK.close('pr')">
  <div class="fm-modal" style="width:520px">
    <div class="fm-modal-head">
      <h3 id="prTitle"></h3>
      <button type="button" class="fm-x" onclick="DK.close('pr')"><i class="fa fa-times"></i></button>
    </div>
    <form id="prForm" onsubmit="prSave(); return false">
      <div class="fm-modal-body">
        <input type="hidden" name="id"/>
        <input type="hidden" name="code" value="product"/>
        <div class="fm-err" id="prErr"></div>
        <div>
          <label class="fm-l">Наименование *</label>
          <input type="text" class="fm-in" name="name" autocomplete="off"/>
        </div>
        <div class="fm-row" style="grid-template-columns:1fr 1fr">
          <div>
            <label class="fm-l">Категория *</label>
            <select class="fm-in fms-select" name="category">
              <c:forEach items="${categories}" var="category">
                <option value="${category.id}">${category.name}</option>
              </c:forEach>
            </select>
          </div>
          <div>
            <label class="fm-l">Тип ед. изм. *</label>
            <select class="fm-in fms-select" name="measureType">
              <c:forEach items="${measureTypes}" var="measureType">
                <option value="${measureType.id}">${measureType.name}</option>
              </c:forEach>
            </select>
          </div>
        </div>
        <div class="fm-state" style="align-self:flex-start">
          <label><input type="radio" class="a" name="state" value="Y" checked/><span>Активный</span></label>
          <label><input type="radio" class="p" name="state" value=""/><span>Пассивный</span></label>
        </div>
      </div>
      <div class="fm-modal-foot">
        <span class="fm-spacer"></span>
        <button type="button" class="fm-btn" onclick="DK.close('pr')">Отмена</button>
        <button type="submit" class="fm-btn primary"><i class="fa fa-floppy-o"></i>Сохранить</button>
      </div>
    </form>
  </div>
</div>
<script>
  DK.base = '/eats/dict';
  DK.filter('pr');
  function prEdit(id) {
    var f = document.getElementById('prForm');
    f.reset();
    f.elements['id'].value = '';
    DK.open('pr', id ? 'Изменить продукт' : 'Новый продукт');
    if (!id) { f.elements['name'].focus(); return; }
    DK.get('pr', 'product', id, function (res) {
      f.elements['id'].value = res.id;
      f.elements['name'].value = res.name || '';
      $(f.elements['category']).val(res.category).trigger('change');
      if (res.measureType) $(f.elements['measureType']).val(res.measureType).trigger('change');
      DK.setState(f, res.state == 'A');
    });
  }
  function prSave() {
    var f = document.getElementById('prForm');
    if (!$.trim(f.elements['name'].value)) { DK.err('pr', 'Укажите наименование'); return; }
    DK.save('pr', f, 'products');
  }
</script>
