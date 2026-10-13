<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Аптека → Справочники: вкладки, содержимое вкладки грузится в #pager --%>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<c:set var="cur" value="${sessionScope.ENV.curSubUrl}"/>
<style>
  .dk-wrap { height:100%; display:flex; flex-direction:column; }
  .dk-tabs { flex:none; display:flex; align-items:center; gap:10px; padding:10px 14px 0; background:#F5F6F8; overflow-x:auto; }
  .dk-tabs .fm-seg button { height:30px; padding:0 12px; font-size:13px; white-space:nowrap; }
  #pager { flex:1; min-height:0; }
  #pager > .fm-page { padding-top:8px; }
</style>
<div class="dk-wrap">
  <div class="dk-tabs">
    <div class="fm-seg" id="dkTabs">
      <button type="button" data-p="drugs" class="${fn:endsWith(cur, '/dict/drugs.s') ? 'on' : ''}" onclick="dictPage('drugs')">Препараты</button>
      <button type="button" data-p="drug/normas" class="${fn:indexOf(cur, '/dict/drug/norma') > -1 ? 'on' : ''}" onclick="dictPage('drug/normas')">Нормативы</button>
      <button type="button" data-p="categories" class="${fn:endsWith(cur, '/dict/categories.s') ? 'on' : ''}" onclick="dictPage('categories')">Категории</button>
      <button type="button" data-p="measures" class="${fn:endsWith(cur, '/dict/measures.s') ? 'on' : ''}" onclick="dictPage('measures')">Ед. измерения</button>
      <button type="button" data-p="manufacturers" class="${fn:endsWith(cur, '/dict/manufacturers.s') ? 'on' : ''}" onclick="dictPage('manufacturers')">Производители</button>
      <button type="button" data-p="partners" class="${fn:endsWith(cur, '/dict/partners.s') ? 'on' : ''}" onclick="dictPage('partners')">Поставщики</button>
      <button type="button" data-p="contracts" class="${fn:endsWith(cur, '/dict/contracts.s') ? 'on' : ''}" onclick="dictPage('contracts')">Договоры</button>
      <button type="button" data-p="directions" class="${fn:endsWith(cur, '/dict/directions.s') ? 'on' : ''}" onclick="dictPage('directions')">Получатели</button>
      <button type="button" data-p="rasxodtypes" class="${fn:endsWith(cur, '/dict/rasxodtypes.s') ? 'on' : ''}" onclick="dictPage('rasxodtypes')">Типы расходов</button>
    </div>
  </div>
  <div id="pager"></div>
</div>
<script>
  function dictPage(code) {
    $('#dkTabs button').removeClass('on').filter('[data-p="' + code + '"]').addClass('on');
    $('#pager').load('/drugs/dict/' + code + '.s');
  }
  (function () {
    var cur = '${cur}';
    if (!$('#dkTabs button.on').length) { $('#dkTabs button').first().addClass('on'); cur = '/drugs/dict/drugs.s'; }
    $('#pager').load(cur);
  })();
</script>
