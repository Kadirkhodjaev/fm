<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Регистрация → Клиенты: реестр клиентов (без финансовой информации) --%>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<style>
  .cl-dot { display:inline-block; width:8px; height:8px; border-radius:50%; background:#C3C7CE; }
  .cl-dot.ok { background:#2E9E62; }
  .cl-pg { display:flex; align-items:center; gap:6px; flex:none; }
  .cl-pg .fm-btn { padding:0 9px; }
  .cl-pg .fm-btn[disabled] { opacity:.4; cursor:default; }
  .cl-pg select { height:32px; border:1px solid #E6E8EC; border-radius:9px; background:#fff; padding:0 6px; font-family:inherit; font-size:13px; }
  .cl-pg .of { color:#6B7280; font-size:12.5px; white-space:nowrap; }
  #clRows tr { cursor:pointer; }
  #clRows tr.sel td { background:#EEF4FF; }
  #clRows td { white-space:nowrap; }
  #clRows td.fio { white-space:normal; }
  .cl-flag { display:inline-flex; align-items:center; gap:6px; }
</style>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-users"></i></span>
        <div>
          <h2>Клиенты</h2>
          <span class="fm-count">найдено <b><fmt:formatNumber value="${grid.rowCount}" pattern="#,##0"/></b><c:if test="${not empty grid.word}"> по «${fn:escapeXml(grid.word)}»</c:if></span>
        </div>
      </div>
      <div class="fm-seg">
        <button type="button" class="${empty flag ? 'on' : ''}" onclick="clGo('?flag=0')">Все</button>
        <button type="button" class="${flag == 'DONE' ? 'on' : ''}" onclick="clGo('?flag=DONE')"><span class="cl-flag"><span class="cl-dot ok"></span>Проверено</span></button>
        <button type="button" class="${flag == 'UNDONE' ? 'on' : ''}" onclick="clGo('?flag=UNDONE')"><span class="cl-flag"><span class="cl-dot"></span>Не проверено</span></button>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="clSearch" style="width:280px" value="${fn:escapeXml(grid.word)}" placeholder="ФИО, телефон или паспорт + Enter" autocomplete="off"
               onkeydown="if (event.keyCode == 13) clGo('?action=search&word=' + encodeURIComponent($.trim(this.value)))"/>
      </div>
      <c:if test="${not empty grid.word}">
        <button type="button" class="fm-btn" onclick="clGo('?action=search&word=')" title="Сбросить поиск"><i class="fa fa-times"></i></button>
      </c:if>
      <div class="cl-pg">
        <button type="button" class="fm-btn" onclick="clGo('?action=prev')" title="Назад" <c:if test="${grid.page <= 1}">disabled</c:if>><i class="fa fa-chevron-left"></i></button>
        <select onchange="clGo('?action=page_num&page_num=' + this.value)" title="Страница">
          <c:forEach begin="1" end="${grid.maxPage < 1 ? 1 : grid.maxPage}" var="p">
            <option value="${p}" <c:if test="${grid.page == p}">selected</c:if>>${p}</option>
          </c:forEach>
        </select>
        <span class="of">из ${grid.maxPage < 1 ? 1 : grid.maxPage}</span>
        <button type="button" class="fm-btn" onclick="clGo('?action=next')" title="Вперёд" <c:if test="${grid.page >= grid.maxPage}">disabled</c:if>><i class="fa fa-chevron-right"></i></button>
        <select onchange="clGo('?action=page_size&page_size=' + this.value)" title="Строк на странице">
          <c:forEach items="${grid.pageSizes}" var="s">
            <option value="${s}" <c:if test="${grid.pageSize == s}">selected</c:if>>${s}</option>
          </c:forEach>
        </select>
      </div>
    </div>
    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:60px">№</th>
          <th style="width:30px"></th>
          <th>ФИО</th>
          <th style="width:90px">Пол</th>
          <th style="width:120px">Дата рождения</th>
          <th style="width:130px">Документ</th>
          <th style="width:200px">Страна / область</th>
          <th style="width:140px">Телефон</th>
          <th style="width:140px">Дата рег.</th>
        </tr>
        </thead>
        <tbody id="clRows">
        <c:forEach items="${rows}" var="p" varStatus="loop">
          <tr data-id="${p.id}" onclick="clView(${p.id})" title="Открыть карточку">
            <td class="mut">${grid.startPos + loop.index}</td>
            <td><span class="cl-dot ${p.flag == 'DONE' ? 'ok' : ''}" title="${p.flag == 'DONE' ? 'Проверено' : 'Не проверено'}"></span></td>
            <td class="fio"><span class="nm">${fn:escapeXml(p.fio)}</span></td>
            <td class="mut">${p.sex}</td>
            <td>${p.birthdate}</td>
            <td>${fn:escapeXml(p.docSeria)} ${fn:escapeXml(p.docNum)}</td>
            <td class="mut">${p.country}<c:if test="${not empty p.region}"> · ${p.region}</c:if></td>
            <td>${fn:escapeXml(p.tel)}</td>
            <td class="mut">${p.dateReg}</td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <c:if test="${empty rows}">
        <div class="fm-empty" style="display:block"><i class="fa fa-users"></i>Клиенты не найдены</div>
      </c:if>
    </div>
  </div>
</div>
<script>
  function clGo(q) { setPage('/clients/list.s' + q); }
  function clView(id) {
    try { sessionStorage.setItem('clLast', id); } catch (e) {}
    setPage('/clients/view.s?id=' + id);
  }
  (function () {
    var last = null;
    try { last = sessionStorage.getItem('clLast'); } catch (e) {}
    var tr = last ? $('#clRows tr[data-id=' + Number(last) + ']') : $();
    if (tr.length) { tr.addClass('sel'); tr[0].scrollIntoView({block: 'center'}); }
    <c:if test="${not empty grid.word}">$('#clSearch').focus();</c:if>
  })();
</script>
