<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Питание → Справочники → Реестр блюд (карточка блюда с нормами продуктов — eats/addEdit.jsp) --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<c:set var="cntA" value="0"/>
<c:forEach items="${list}" var="o"><c:if test="${o.state == 'A'}"><c:set var="cntA" value="${cntA + 1}"/></c:if></c:forEach>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-cutlery"></i></span>
        <div>
          <h2>Реестр блюд</h2>
          <span class="fm-count"><b id="ebShown">${fn:length(list)}</b> из <b>${fn:length(list)}</b> · активных <b>${cntA}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="ebSeg">
        <button type="button" data-f="" class="on" onclick="DK.seg('eb', this)">Все</button>
        <button type="button" data-f="A" onclick="DK.seg('eb', this)">Активные</button>
        <button type="button" data-f="P" onclick="DK.seg('eb', this)">Пассивные</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="ebSearch" placeholder="Блюдо или ID" oninput="DK.filter('eb')" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn primary" onclick="ebOpen(0)"><i class="fa fa-plus"></i>Новое блюдо</button>
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
        <tbody id="ebRows">
        <c:forEach items="${list}" var="obj">
          <tr data-f="${obj.state == 'A' ? 'A' : 'P'}" data-s="${obj.id} ${fn:escapeXml(obj.name)}" data-name="${fn:escapeXml(obj.name)}" onclick="ebOpen(${obj.id})" title="Открыть блюдо">
            <td class="mut"><b>${obj.id}</b></td>
            <td><span class="nm">${obj.name}</span></td>
            <td><span class="dk-st ${obj.state == 'A' ? 'A' : 'P'}">${obj.state == 'A' ? 'Активный' : 'Пассивный'}</span></td>
            <td class="r" onclick="event.stopPropagation()">
              <%-- раньше здесь отправлялся code=category, и удалялась категория продуктов с тем же номером вместо блюда --%>
              <button type="button" class="fm-act danger" title="Удалить блюдо" onclick="DK.del('eat', ${obj.id}, $(this).closest('tr').attr('data-name'), 'eats')"><i class="fa fa-trash-o"></i></button>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="ebEmpty" style="display:none"><i class="fa fa-cutlery"></i>Ничего не найдено</div>
    </div>
  </div>
</div>
<script>
  DK.base = '/eats/dict';
  DK.filter('eb');
  function ebOpen(id) { $('#pager').load('/eats/dict/eat/addEdit.s?id=' + id); }
</script>
