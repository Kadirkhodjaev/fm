<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Аптека → Справочники → Договоры с поставщиками --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<script src="/res/js/fms-calendar.js" type="text/javascript"></script>
<jsp:useBean id="now" class="java.util.Date"/>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-file-text-o"></i></span>
        <div>
          <h2>Договоры</h2>
          <span class="fm-count"><b id="ctShown">${fn:length(list)}</b> из <b>${fn:length(list)}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="ctSeg">
        <button type="button" data-f="" class="on" onclick="DK.seg('ct', this)">Все</button>
        <button type="button" data-f="A" onclick="DK.seg('ct', this)">Действующие</button>
        <button type="button" data-f="P" onclick="DK.seg('ct', this)">Истёкшие</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="ctSearch" placeholder="Поставщик или номер" oninput="DK.filter('ct')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn primary" onclick="ctEdit(0)"><i class="fa fa-plus"></i>Добавить</button>
    </div>
    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:70px">ID</th>
          <th>Поставщик</th>
          <th style="width:220px">Договор</th>
          <th style="width:120px" class="nw">Начало</th>
          <th style="width:120px" class="nw">Окончание</th>
          <th style="width:50px"></th>
        </tr>
        </thead>
        <tbody id="ctRows">
        <c:forEach items="${list}" var="obj">
          <c:set var="expired" value="${obj.endDate != null && obj.endDate < now}"/>
          <tr data-f="${expired ? 'P' : 'A'}" data-s="${obj.id} ${fn:escapeXml(obj.partner.name)} ${fn:escapeXml(obj.regNum)}" data-name="${fn:escapeXml(obj.regNum)}" onclick="ctEdit(${obj.id})" title="Изменить">
            <td class="mut"><b>${obj.id}</b></td>
            <td><span class="nm">${obj.partner.name}</span></td>
            <td>№${obj.regNum} <span class="mut" style="color:#6B7280">от <fmt:formatDate pattern="dd.MM.yyyy" value="${obj.regDate}"/></span></td>
            <td class="nw"><fmt:formatDate pattern="dd.MM.yyyy" value="${obj.startDate}"/></td>
            <td class="nw"><c:choose><c:when test="${expired}"><span class="dk-st P"><fmt:formatDate pattern="dd.MM.yyyy" value="${obj.endDate}"/></span></c:when><c:otherwise><fmt:formatDate pattern="dd.MM.yyyy" value="${obj.endDate}"/></c:otherwise></c:choose></td>
            <td class="r" onclick="event.stopPropagation()">
              <button type="button" class="fm-act danger" title="Удалить" onclick="DK.del('contract', ${obj.id}, 'договор №' + $(this).closest('tr').attr('data-name'), 'contracts')"><i class="fa fa-trash-o"></i></button>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="ctEmpty" style="display:none"><i class="fa fa-file-text-o"></i>Ничего не найдено</div>
    </div>
  </div>
</div>

<div class="fm-overlay" id="ctModal" onclick="if (event.target === this) DK.close('ct')">
  <div class="fm-modal" style="width:560px">
    <div class="fm-modal-head">
      <h3 id="ctTitle"></h3>
      <button type="button" class="fm-x" onclick="DK.close('ct')"><i class="fa fa-times"></i></button>
    </div>
    <form id="ctForm" onsubmit="ctSave(); return false">
      <div class="fm-modal-body">
        <input type="hidden" name="id"/>
        <input type="hidden" name="code" value="contract"/>
        <div class="fm-err" id="ctErr"></div>
        <div>
          <label class="fm-l">Поставщик *</label>
          <select class="fm-in fms-select" name="partner">
            <option value="">Выберите поставщика</option>
            <c:forEach items="${partners}" var="p">
              <option value="${p.id}">${p.name}</option>
            </c:forEach>
          </select>
        </div>
        <div class="fm-row" style="grid-template-columns:1fr 1fr">
          <div><label class="fm-l">Рег. № *</label><input type="text" class="fm-in" name="reg_num" autocomplete="off"/></div>
          <div><label class="fm-l">Рег. дата *</label><input type="text" class="fm-in datepicker" name="reg_date" autocomplete="off"/></div>
          <div><label class="fm-l">Начало</label><input type="text" class="fm-in datepicker" name="start_date" autocomplete="off"/></div>
          <div><label class="fm-l">Окончание</label><input type="text" class="fm-in datepicker" name="end_date" autocomplete="off"/></div>
        </div>
        <div>
          <label class="fm-l">Описание</label>
          <textarea class="fm-in" name="extra_info" rows="2"></textarea>
        </div>
      </div>
      <div class="fm-modal-foot">
        <span class="fm-spacer"></span>
        <button type="button" class="fm-btn" onclick="DK.close('ct')">Отмена</button>
        <button type="submit" class="fm-btn primary"><i class="fa fa-floppy-o"></i>Сохранить</button>
      </div>
    </form>
  </div>
</div>
<script>
  DK.filter('ct');
  function ctEdit(id) {
    var f = document.getElementById('ctForm');
    f.reset();
    f.elements['id'].value = '';
    DK.open('ct', id ? 'Изменить договор' : 'Новый договор');
    if (!id) return;
    DK.get('ct', 'contract', id, function (res) {
      f.elements['id'].value = res.id;
      $(f.elements['partner']).val(res.partner).trigger('change');
      f.elements['reg_num'].value = res.reg_num || '';
      f.elements['reg_date'].value = res.reg_date || '';
      f.elements['start_date'].value = res.start_date || '';
      f.elements['end_date'].value = res.end_date || '';
      f.elements['extra_info'].value = res.extra_info || '';
    });
  }
  function ctSave() {
    var f = document.getElementById('ctForm');
    if (!f.elements['partner'].value || !$.trim(f.elements['reg_num'].value) || !$.trim(f.elements['reg_date'].value)) {
      DK.err('ct', 'Заполните поставщика, рег. № и рег. дату');
      return;
    }
    DK.save('ct', f, 'contracts');
  }
</script>
