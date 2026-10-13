<%@ page pageEncoding="UTF-8" %>
<%-- Общий список сотрудников. Перед include задаются: empOpen (страница сотрудника, без id), empAdd (Y - кнопка «Добавить») --%>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<style>
  .em-st { display:inline-block; padding:0 8px; border-radius:6px; font-size:11.5px; font-weight:600; line-height:20px; }
  .em-st.A { background:#E9F7EF; color:#1E7B43; }
  .em-st.P { background:#F1F2F4; color:#6B7280; }
  table.fm-grid tbody tr { cursor:pointer; }
</style>
<c:set var="cntA" value="0"/>
<c:forEach items="${rows}" var="a"><c:if test="${a.state == 'A'}"><c:set var="cntA" value="${cntA + 1}"/></c:if></c:forEach>

<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-users"></i></span>
        <div>
          <h2>Сотрудники</h2>
          <span class="fm-count"><b>${fn:length(rows)}</b> сотрудников · активных <b>${cntA}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="emSeg">
        <button type="button" data-f="" onclick="emSeg(this)">Все</button>
        <button type="button" data-f="A" class="on" onclick="emSeg(this)">Активные</button>
        <button type="button" data-f="P" onclick="emSeg(this)">Пассивные</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="emSearch" placeholder="ФИО или описание" oninput="emFilter()" autocomplete="off"/>
      </div>
      <c:if test="${empAdd == 'Y'}">
        <button type="button" class="fm-btn primary" onclick="setPage('/emp/addEdit.s?id=0')"><i class="fa fa-plus"></i>Добавить</button>
      </c:if>
    </div>

    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:50px" class="c">№</th>
          <th>ФИО</th>
          <th>Описание</th>
          <th style="width:130px">Добавлен</th>
          <th style="width:120px">Состояние</th>
        </tr>
        </thead>
        <tbody id="emRows">
        <c:forEach items="${rows}" var="a" varStatus="loop">
          <tr data-f="${a.state}" data-s="${fn:toLowerCase(fn:escapeXml(a.client.fio))} ${fn:toLowerCase(fn:escapeXml(a.text))}"
              onclick="setPage('${empOpen}?id=${a.id}')" title="Открыть">
            <td class="c mut">${loop.index + 1}</td>
            <td><span class="nm">${a.client.fio}</span></td>
            <td class="mut">${a.text}</td>
            <td class="mut"><fmt:formatDate pattern="dd.MM.yyyy" value="${a.crOn}"/></td>
            <td><span class="em-st ${a.state}">${a.state == 'A' ? 'Активный' : a.state == 'P' ? 'Пассивный' : a.state}</span></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="emEmpty" style="display:none"><i class="fa fa-users"></i>Сотрудники не найдены</div>
    </div>
  </div>
</div>
<script>
  function emSeg(btn) {
    $('#emSeg button').removeClass('on');
    $(btn).addClass('on');
    emFilter();
  }
  function emFilter() {
    var f = $('#emSeg button.on').data('f') || '';
    var q = $.trim($('#emSearch').val()).toLowerCase();
    var n = 0;
    $('#emRows tr').each(function () {
      var ok = (!f || $(this).data('f') == f) && (!q || String($(this).data('s')).indexOf(q) >= 0);
      $(this).toggle(ok);
      if (ok) n++;
    });
    $('#emEmpty').toggle(n == 0);
  }
  emFilter();
</script>
