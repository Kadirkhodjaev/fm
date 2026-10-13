<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- КДО → шаблоны заключений по обследованиям --%>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<c:set var="withTpl" value="0"/>
<c:forEach items="${kdos}" var="k"><c:if test="${not empty k.template}"><c:set var="withTpl" value="${withTpl + 1}"/></c:if></c:forEach>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-file-text-o"></i></span>
        <div>
          <h2>Шаблоны заключений</h2>
          <span class="fm-count"><b id="ktShown">${fn:length(kdos)}</b> из <b>${fn:length(kdos)}</b> · с шаблоном <b>${withTpl}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="ktSeg">
        <button type="button" data-f="" class="on" onclick="ktSeg(this)">Все</button>
        <button type="button" data-f="Y" onclick="ktSeg(this)">С шаблоном</button>
        <button type="button" data-f="N" onclick="ktSeg(this)">Без шаблона</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="ktSearch" placeholder="Обследование или тип" oninput="ktFilter()" autocomplete="off"/>
      </div>
    </div>
    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:240px">Тип</th>
          <th>Обследование</th>
          <th style="width:140px">Шаблон</th>
          <th style="width:50px"></th>
        </tr>
        </thead>
        <tbody id="ktRows">
        <c:forEach items="${kdos}" var="k">
          <tr class="go" style="cursor:pointer" onclick="openKdo(${k.id})" data-f="${empty k.template ? 'N' : 'Y'}" data-s="${fn:toLowerCase(fn:escapeXml(k.name))} ${fn:toLowerCase(fn:escapeXml(k.kdoType.name))}">
            <td class="mut">${k.kdoType.name}</td>
            <td><span class="nm">${k.name}</span></td>
            <td><span class="dk-st ${empty k.template ? 'P' : 'A'}" style="display:inline-block; padding:1px 9px; border-radius:6px; font-size:12px; font-weight:600; background:${empty k.template ? '#F1F2F4; color:#6B7280' : '#E9F7EF; color:#1E7B43'}">${empty k.template ? 'Нет' : 'Есть'}</span></td>
            <td class="r"><button type="button" class="fm-act" title="Изменить"><i class="fa fa-pencil"></i></button></td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="ktEmpty" style="display:none"><i class="fa fa-file-text-o"></i>Ничего не найдено</div>
    </div>
  </div>
</div>
<script>
  function openKdo(id) { openMainPage('/templates/edit.s?id=' + id, true); }
  function ktSeg(b) { $(b).addClass('on').siblings().removeClass('on'); ktFilter(); }
  function ktFilter() {
    var f = $('#ktSeg button.on').attr('data-f'), q = $.trim($('#ktSearch').val()).toLowerCase(), n = 0;
    $('#ktRows tr').each(function () {
      var ok = (!f || $(this).attr('data-f') == f) && (!q || $(this).attr('data-s').indexOf(q) >= 0);
      $(this).toggle(ok); if (ok) n++;
    });
    $('#ktShown').text(n);
    $('#ktEmpty').toggle(n == 0);
  }
</script>
