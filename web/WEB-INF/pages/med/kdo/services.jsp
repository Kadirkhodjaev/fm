<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- КДО → По услугам: лабораторные услуги текущих пациентов с количеством; клик — ввод результатов по услуге --%>
<%@include file="/WEB-INF/pages/med/mn/mn_style.jsp"%>
<style>
  #svRows tr[data-k] { cursor:pointer; }
  .sv-n { display:inline-block; min-width:34px; padding:2px 9px; border-radius:999px; background:#F1F2F4; color:#374151; font-weight:600; font-size:12.5px; text-align:center; }
  .sv-n.todo { background:#FDECEE; color:#A50F22; }
  .sv-n.fill { background:#FEF6D6; color:#8A6100; }
  .sv-n.zero { background:none; color:#C3C7CE; }
  .sv-kind { font-size:12px; color:#9AA1AC; }
</style>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-list-alt"></i></span>
        <div>
          <h2>Ввод по услугам</h2>
          <span class="fm-count"><b id="svShown">${fn:length(rows)}</b> из <b>${fn:length(rows)}</b> · услуги текущих пациентов</span>
        </div>
      </div>
      <div class="fm-seg" id="svSeg">
        <button type="button" class="on" data-f="todo" onclick="svSeg(this)">Ожидают ввода</button>
        <button type="button" data-f="" onclick="svSeg(this)">Все</button>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="svSearch" placeholder="Услуга" oninput="svFilter()" autocomplete="off"/>
      </div>
    </div>
    <div class="fm-table-wrap">
      <table class="mn">
        <thead>
        <tr>
          <th style="width:50px">№</th>
          <th class="l">Услуга</th>
          <th style="width:140px">Бланк</th>
          <th style="width:130px" title="Назначено текущим пациентам">Назначено</th>
          <th style="width:150px" title="Без результата или не подтверждено">Не подтверждено</th>
          <th style="width:170px" title="Результат введён, ждёт подтверждения">Заполнено, ждёт подтв.</th>
        </tr>
        </thead>
        <tbody id="svRows">
        <c:set var="svType" value=""/>
        <c:forEach items="${rows}" var="r" varStatus="loop">
          <c:if test="${svType != r.c4}">
            <c:set var="svType" value="${r.c4}"/>
            <tr class="grp" data-g="${r.c4}"><td colspan="6">${r.c5}</td></tr>
          </c:if>
          <tr data-k="${r.c1}" data-g="${r.c4}" data-todo="${r.c7}" data-s="${fn:escapeXml(fn:toLowerCase(r.c2))}" onclick="setPage('/kdo/service.s?kdo=${r.c1}')" title="Открыть ввод по услуге">
            <td class="c m">${loop.index + 1}</td>
            <td class="nm">${r.c2}</td>
            <td class="c"><span class="sv-kind">${r.c3 == '777' || r.c3 == '888' ? 'одно поле' : 'бланк'}</span></td>
            <td class="c"><span class="sv-n">${r.c6}</span></td>
            <td class="c"><span class="sv-n ${r.c7 > 0 ? 'todo' : 'zero'}">${r.c7}</span></td>
            <td class="c"><span class="sv-n ${r.c8 > 0 ? 'fill' : 'zero'}">${r.c8}</span></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="svEmpty" style="display:none"><i class="fa fa-list-alt"></i>Услуг нет</div>
    </div>
  </div>
</div>
<script>
  function svSeg(b) { $(b).addClass('on').siblings().removeClass('on'); svFilter(); }
  function svFilter() {
    var todo = $('#svSeg .on').attr('data-f') == 'todo', q = $.trim($('#svSearch').val()).toLowerCase(), n = 0, rows = $('#svRows tr[data-k]');
    rows.each(function () {
      var ok = (!todo || Number($(this).attr('data-todo')) > 0) && (!q || $(this).attr('data-s').indexOf(q) >= 0);
      $(this).toggle(ok);
      if (ok) n++;
    });
    $('#svRows tr.grp').each(function () { $(this).toggle(rows.filter('[data-g=' + $(this).attr('data-g') + ']:visible').length > 0); });
    $('#svShown').text(n);
    $('#svEmpty').toggle(n == 0);
  }
  svFilter();
</script>
