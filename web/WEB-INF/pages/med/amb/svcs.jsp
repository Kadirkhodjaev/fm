<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Амбулаторные услуги → По услугам: услуги врача у текущих пациентов с количеством; клик — ввод по услуге (/amb/svcPatients.s) --%>
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
          <span class="fm-count"><b id="svShown">${fn:length(rows)}</b> из <b>${fn:length(rows)}</b> · мои услуги у текущих пациентов</span>
        </div>
      </div>
      <div class="fm-seg" id="svSeg">
        <button type="button" class="on" data-f="todo" onclick="svSeg(this)">Ждут выполнения</button>
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
          <th style="width:150px">Бланк</th>
          <th style="width:120px" title="Назначено текущим пациентам">Всего</th>
          <th style="width:150px" title="Ещё не выполнено">К выполнению</th>
          <th style="width:170px" title="Результат введён, не подтверждено">Заполнено, ждёт подтв.</th>
        </tr>
        </thead>
        <tbody id="svRows">
        <c:forEach items="${rows}" var="r" varStatus="loop">
          <tr data-k="${r.id}" data-todo="${r.todo}" data-s="${fn:escapeXml(fn:toLowerCase(r.name))}" onclick="setPage('/amb/svcPatients.s?service=${r.id}')" title="Открыть ввод по услуге">
            <td class="c m">${loop.index + 1}</td>
            <td class="nm">${r.name}</td>
            <td class="c"><span class="sv-kind">${r.kind == 'single' ? 'одно поле' : r.kind == 'form' ? 'бланк анализа' : 'заключение'}</span></td>
            <td class="c"><span class="sv-n">${r.total}</span></td>
            <td class="c"><span class="sv-n ${r.todo > 0 ? 'todo' : 'zero'}">${r.todo}</span></td>
            <td class="c"><span class="sv-n ${r.filled > 0 ? 'fill' : 'zero'}">${r.filled}</span></td>
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
    var todo = $('#svSeg .on').attr('data-f') == 'todo', q = $.trim($('#svSearch').val()).toLowerCase(), n = 0;
    $('#svRows tr[data-k]').each(function () {
      var ok = (!todo || Number($(this).attr('data-todo')) > 0) && (!q || $(this).attr('data-s').indexOf(q) >= 0);
      $(this).toggle(ok);
      if (ok) n++;
    });
    $('#svShown').text(n);
    $('#svEmpty').toggle(n == 0);
  }
  svFilter();
</script>
