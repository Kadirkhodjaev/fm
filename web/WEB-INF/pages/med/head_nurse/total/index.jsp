<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Склады → Пациенты: пациенты отделений склада и итог по препаратам --%>
<%@include file="/WEB-INF/pages/med/head_nurse/hn_style.jsp"%>
<c:set var="cntDone" value="0"/>
<c:forEach items="${rows}" var="o"><c:if test="${o.fizio}"><c:set var="cntDone" value="${cntDone + 1}"/></c:if></c:forEach>

<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-user"></i></span>
        <div>
          <h2>Пациенты</h2>
          <span class="fm-count"><b id="ptShown">${fn:length(rows)}</b> из <b>${fn:length(rows)}</b> пациентов</span>
        </div>
      </div>
      <div class="hn-flt">
        <input id="period_start" type="text" class="fm-in datepicker" value="${period_start}" title="Поступили с" autocomplete="off"/>
        <span class="dash">—</span>
        <input id="period_end" type="text" class="fm-in datepicker" value="${period_end}" title="по" autocomplete="off"/>
        <button type="button" class="fm-btn" onclick="ptLoad()"><i class="fa fa-search"></i>Показать</button>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="ptSeg">
        <button type="button" data-f="" class="on" onclick="hnSeg('pt', this)">Все</button>
        <button type="button" data-f="Y" onclick="hnSeg('pt', this)">С итогом · ${cntDone}</button>
        <button type="button" data-f="N" onclick="hnSeg('pt', this)">Без итога · ${fn:length(rows) - cntDone}</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="ptSearch" placeholder="ФИО или № ИБ" value="${fn:escapeXml(filter_word)}" oninput="hnFilter('pt')" autocomplete="off"/>
      </div>
    </div>

    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:110px">Итог</th>
          <th>ФИО</th>
          <th style="width:100px">№ ИБ</th>
          <th style="width:120px" class="nw">Поступил</th>
          <th style="width:120px" class="nw">Выписан</th>
          <th style="width:110px" class="c">Год рождения</th>
        </tr>
        </thead>
        <tbody id="ptRows">
        <c:forEach items="${rows}" var="obj">
          <tr class="go" data-f="${obj.fizio ? 'Y' : 'N'}" data-s="${fn:escapeXml(obj.surname)} ${fn:escapeXml(obj.name)} ${fn:escapeXml(obj.middlename)} ${obj.yearNum}"
              onclick="setPage('/head_nurse/total/patients/info.s?id=${obj.id}')">
            <td><span class="hn-st ${obj.fizio ? 'con' : 'off'}">${obj.fizio ? 'Есть' : 'Нет'}</span></td>
            <td><span class="nm">${obj.surname} ${obj.name} ${obj.middlename}</span></td>
            <td class="mut">${obj.yearNum}</td>
            <td class="nw"><fmt:formatDate pattern="dd.MM.yyyy" value="${obj.dateBegin}"/></td>
            <td class="nw mut"><fmt:formatDate pattern="dd.MM.yyyy" value="${obj.dateEnd}"/></td>
            <td class="c mut">${obj.birthyear}</td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="ptEmpty" style="display:none"><i class="fa fa-user"></i>Пациенты не найдены</div>
    </div>
  </div>
</div>
<script>
  hnFilter('pt');
  function ptLoad() {
    setPage('/head_nurse/total/patients.s?period_start=' + encodeURIComponent($('#period_start').val()) + '&period_end=' + encodeURIComponent($('#period_end').val()) + '&set=1&filter=');
  }
</script>
