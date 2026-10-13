<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Отчёты: список доступных отчётов слева, справа параметры и сам отчёт (/rep/params.s) --%>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<style>
  .rp-wrap { display:grid; grid-template-columns:minmax(260px, 22%) 1fr; gap:12px; height:100%; min-height:0; padding:12px; background:#F7F8FA; box-sizing:border-box; }
  .rp-list, .rp-params { background:#fff; border:1px solid #E6E8EC; border-radius:14px; overflow:auto; min-height:0; }
  .rp-params { display:flex; flex-direction:column; overflow:hidden; }
  .rp-it { display:flex; gap:10px; align-items:center; padding:9px 14px; border-bottom:1px solid #F3F4F6; cursor:pointer; font-size:13.5px; }
  .rp-it:hover { background:#F7F9FC; }
  .rp-it.active { background:#EEF4FF; box-shadow:inset 3px 0 0 #3B6FE0; font-weight:600; }
  .rp-it .n { flex:none; min-width:30px; color:#9AA1AC; font-variant-numeric:tabular-nums; }
</style>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-bar-chart"></i></span>
        <div>
          <h2>Отчёты</h2>
          <span class="fm-count"><b id="rpShown">${fn:length(repList)}</b> из <b>${fn:length(repList)}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="rpSearch" placeholder="Название отчёта" oninput="rpFilter()" autocomplete="off"/>
      </div>
    </div>
    <div class="fm-table-wrap" style="padding:0">
      <div class="rp-wrap">
        <div class="rp-list" id="rpList">
          <c:forEach items="${repList}" var="r">
            <div class="rp-it repList" id="rep-${r.id}" repId="${r.id}" data-s="${r.id} ${fn:toLowerCase(fn:escapeXml(r.name))}">
              <span class="n">${r.id}</span><span>${r.name}</span>
            </div>
          </c:forEach>
          <div class="fm-empty" id="rpEmpty" style="display:none"><i class="fa fa-bar-chart"></i>Ничего не найдено</div>
        </div>
        <div class="rp-params" id="repParams"></div>
      </div>
    </div>
  </div>
</div>
<script>
  if ('${authErr}' === 'true') parent.location = '/login.s';
  function rpOpen(el) {
    $('#rpList .rp-it').removeClass('active');
    $(el).addClass('active');
    $('#repParams').load('/rep/params.s?id=' + $(el).attr('repId'));
  }
  function rpFilter() {
    var q = $.trim($('#rpSearch').val()).toLowerCase(), n = 0;
    $('#rpList .rp-it').each(function () { var ok = !q || $(this).attr('data-s').indexOf(q) >= 0; $(this).toggle(ok); if (ok) n++; });
    $('#rpShown').text(n);
    $('#rpEmpty').toggle(n == 0);
  }
  $('#rpList').on('click', '.rp-it', function () { rpOpen(this); });
  (function () {
    var repId = Number('${id}') || 0, first = repId > 0 ? $('#rep-' + repId) : $('#rpList .rp-it').first();
    if (first.length) rpOpen(first[0]);
  })();
</script>
