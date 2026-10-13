<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="style.jsp"%>
<c:set var="canEdit" value="${sessionScope.ENV.userId == 1}"/>

<div class="fm-page fm-admin">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-list-alt"></i></span>
        <div>
          <h2>Формы</h2>
          <span class="fm-count"><b id="fmShown">${fn:length(forms)}</b> из <b>${fn:length(forms)}</b> форм</span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="fmSeg">
        <button type="button" data-f="" class="on" onclick="fmSeg(this)">Все</button>
        <button type="button" data-f="Y" onclick="fmSeg(this)">Амбулатория</button>
        <button type="button" data-f="N" onclick="fmSeg(this)">Стационар</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="fmSearch" placeholder="Название или ID" oninput="fmFilter()" autocomplete="off"/>
      </div>
      <c:if test="${canEdit}">
        <button type="button" class="fm-btn primary" onclick="fmEdit(0)"><i class="fa fa-plus"></i>Новая форма</button>
      </c:if>
    </div>

    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:60px">ID</th>
          <th>Наименование</th>
          <th style="width:120px">Раздел</th>
          <th style="width:80px" class="c">Полей</th>
          <th style="width:150px">Используется</th>
          <th style="width:190px">Колонки</th>
          <th style="width:110px">Шаблон</th>
          <th style="width:90px"></th>
        </tr>
        </thead>
        <tbody id="fmRows">
        <c:forEach items="${forms}" var="f">
          <c:set var="fc" value="${fieldCounts[f.id]}"/>
          <c:set var="au" value="${ambUse[f.id]}"/>
          <c:set var="ku" value="${kdoUse[f.id]}"/>
          <tr data-a="${f.amb == 'Y' ? 'Y' : 'N'}" data-s="${f.id} ${fn:toLowerCase(fn:escapeXml(f.name))}"
              <c:if test="${canEdit}">ondblclick="fmFields(${f.id})" title="Двойной щелчок - поля формы"</c:if>>
            <td class="mut"><b>${f.id}</b></td>
            <td><span class="nm">${fn:escapeXml(f.name)}</span><c:if test="${f.type == 0}"><span class="pill" title="Результат можно редактировать">редактируемая</span></c:if></td>
            <td><span class="tag ${f.amb == 'Y' ? 'amb' : 'stat'}">${f.amb == 'Y' ? 'Амбулатория' : 'Стационар'}</span></td>
            <td class="c ${empty fc ? 'none' : ''}">${empty fc ? '—' : fc}</td>
            <td class="mut">
              <c:if test="${not empty au}">${au} амб. усл.</c:if><c:if test="${not empty au && not empty ku}"> · </c:if><c:if test="${not empty ku}">${ku} КДО</c:if>
              <c:if test="${empty au && empty ku}"><span style="color:#C3C7CE">не используется</span></c:if>
            </td>
            <td>
              <span class="flag ${f.normaFlag == 'N' ? 'off' : ''}" title="Колонка «Норма»">Норма</span>
              <span class="flag ${f.eiFlag == 'N' ? 'off' : ''}" title="Колонка «Ед. изм.»">Ед.</span>
              <span class="flag ${f.codeFlag == 'Y' ? '' : 'off'}" title="Колонка «Код»">Код</span>
            </td>
            <td class="${empty f.jsp ? 'none' : 'mut'}">${empty f.jsp ? 'стандартный' : fn:escapeXml(f.jsp)}</td>
            <td class="r">
              <c:if test="${canEdit}">
                <button type="button" class="fm-act" title="Поля формы" onclick="fmFields(${f.id})"><i class="fa fa-list"></i></button>
                <button type="button" class="fm-act" title="Изменить форму" onclick="fmEdit(${f.id})"><i class="fa fa-pencil"></i></button>
              </c:if>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="fmEmpty" style="display:none"><i class="fa fa-list-alt"></i>Формы не найдены</div>
    </div>
  </div>
</div>

<%@include file="edit.jsp"%>

<script>
  function fmSeg(btn) {
    $('#fmSeg button').removeClass('on');
    $(btn).addClass('on');
    fmFilter();
  }
  function fmFilter() {
    var f = $('#fmSeg button.on').data('f') || '';
    var q = $.trim($('#fmSearch').val()).toLowerCase();
    var n = 0;
    $('#fmRows tr').each(function () {
      var ok = (!f || $(this).data('a') == f) && (!q || String($(this).data('s')).indexOf(q) >= 0);
      $(this).toggle(ok);
      if (ok) n++;
    });
    $('#fmShown').text(n);
    $('#fmEmpty').toggle(n == 0);
  }
  function fmFields(id) {
    setPage('/core/form/fields.s?formId=' + id);
  }
  function fmSaved(id, isNew) {
    if (isNew) fmFields(id); else setPage('/core/form/list.s');
  }
</script>
