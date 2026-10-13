<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Содержимое окна «Услуга» (Администрирование → Амб услуги). Сохранение - amSave() в core/amb/index.jsp --%>
<form id="amForm" onsubmit="amSave(); return false" style="display:flex; flex-direction:column; gap:14px">
  <input type="hidden" name="id" value="${ser.id}">
  <div class="fm-err" id="amErr"></div>
  <div class="fm-row" style="grid-template-columns:1fr 2fr">
    <div>
      <label class="fm-l">Группа *</label>
      <select name="group" class="fm-in">
        <option value="">Не выбрано</option>
        <c:forEach items="${groups}" var="t">
          <option <c:if test="${ser.group.id == t.id}">selected</c:if> value="${t.id}">${t.name}</option>
        </c:forEach>
      </select>
    </div>
    <div>
      <label class="fm-l">Наименование *</label>
      <input type="text" class="fm-in" name="name" value="${fn:escapeXml(ser.name)}" autocomplete="off">
    </div>
  </div>
  <div class="fm-row" style="grid-template-columns:1fr 1fr 1fr 1fr">
    <div>
      <label class="fm-l">Цена *</label>
      <input type="number" step="0.01" min="0" class="fm-in" name="price" value="${ser.price}" style="text-align:right">
    </div>
    <div>
      <label class="fm-l">Для иностранцев *</label>
      <input type="number" step="0.01" min="0" class="fm-in" name="for_price" value="${ser.for_price}" style="text-align:right">
    </div>
    <div>
      <label class="fm-l">Вознаграждение, %</label>
      <input type="number" step="0.01" min="0" max="100" class="fm-in" name="bonus_proc" value="${ser.bonusProc}" style="text-align:right">
    </div>
    <div>
      <label class="fm-l">Очерёдность</label>
      <input type="number" class="fm-in" name="ord" value="${ser.ord}" style="text-align:center">
    </div>
  </div>
  <div>
    <span class="fm-sec">Состояние и настройки</span>
    <div style="margin-top:8px; display:flex; flex-wrap:wrap; align-items:center; gap:8px">
      <c:set var="isOn" value="${ser == null || ser.state == 'A'}"/>
      <div class="fm-state">
        <label><input type="radio" class="a" name="state" value="A" <c:if test="${isOn}">checked</c:if>><span>Активная</span></label>
        <label><input type="radio" class="p" name="state" value="" <c:if test="${!isOn}">checked</c:if>><span>Пассивная</span></label>
      </div>
      <label class="fm-tgl"><input type="checkbox" value="Y" name="consul" <c:if test="${ser.consul == 'Y'}">checked</c:if>><span>Консультация</span></label>
      <label class="fm-tgl"><input type="checkbox" value="Y" name="treatment" <c:if test="${ser.treatment == 'Y'}">checked</c:if>><span>Амбулаторное лечение</span></label>
      <label class="fm-tgl"><input type="checkbox" value="Y" name="out_service" <c:if test="${ser.out_service == 'Y'}">checked</c:if>><span>Внешняя услуга</span></label>
    </div>
  </div>
  <div>
    <span class="fm-sec">Результат</span>
    <div class="fm-row" style="grid-template-columns:1fr; margin-top:8px">
      <div>
        <label class="fm-l">Форма</label>
        <select name="form_id" class="fm-in" onchange="amFormKind(this.value)">
          <option value="-1">Ручная настройка</option>
          <c:forEach items="${forms}" var="t">
            <option <c:if test="${ser.form_id == t.id}">selected</c:if> value="${t.id}">${t.id} - ${t.name}</option>
          </c:forEach>
        </select>
      </div>
    </div>
    <div class="am-777 fm-row" style="grid-template-columns:1fr 1fr 1fr; margin-top:10px">
      <div><label class="fm-l">Единица измерения</label><input type="text" class="fm-in" name="ei" value="${fn:escapeXml(ser.ei)}"></div>
      <div><label class="fm-l">Норма с</label><input type="text" class="fm-in" name="normaFrom" value="${fn:escapeXml(ser.normaFrom)}"></div>
      <div><label class="fm-l">Норма по</label><input type="text" class="fm-in" name="normaTo" value="${fn:escapeXml(ser.normaTo)}"></div>
    </div>
    <div class="am-manual" style="margin-top:10px">
      <label class="fm-tgl"><input type="checkbox" value="Y" name="diagnoz" <c:if test="${ser == null || ser.diagnoz == 'Y'}">checked</c:if>><span>Поле «Диагноз»</span></label>
      <div style="margin-top:10px">
        <label class="fm-l">Поля результата</label>
        <div id="amRowsEdit" style="display:flex; flex-direction:column; gap:6px">
          <c:forEach items="${rows}" var="row">
            <div class="am-fr" style="display:flex; gap:6px">
              <input type="text" name="names" class="fm-in" value="${fn:escapeXml(row.name)}">
              <button type="button" class="fm-act danger" title="Удалить поле" onclick="$(this).parent().remove()"><i class="fa fa-times"></i></button>
            </div>
          </c:forEach>
        </div>
        <button type="button" class="fm-btn" style="margin-top:8px" onclick="amAddRow()"><i class="fa fa-plus"></i>Добавить поле</button>
      </div>
    </div>
  </div>
  <c:if test="${not empty users}">
    <div class="fm-hint"><b style="color:#6B7280">Пользователи:</b> ${users}</div>
  </c:if>
</form>
<script>
  function amAddRow() {
    $('<div class="am-fr" style="display:flex; gap:6px"><input type="text" name="names" class="fm-in">' +
      '<button type="button" class="fm-act danger" title="Удалить поле" onclick="$(this).parent().remove()"><i class="fa fa-times"></i></button></div>')
      .appendTo('#amRowsEdit').find('input').focus();
  }
  function amFormKind(id) {
    id = parseInt(id, 10) || -1;
    $('.am-manual').toggle(id <= 0);
    $('.am-777').toggle(id == 777);
  }
  amFormKind('${ser.form_id}');
  $('#amForm [name=name]').focus();
</script>
