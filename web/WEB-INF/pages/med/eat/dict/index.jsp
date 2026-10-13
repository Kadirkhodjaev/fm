<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Питание → Справочники: вкладки, содержимое вкладки грузится в #pager --%>
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
      <button type="button" data-p="eats" class="${fn:indexOf(cur, '/eats/dict/eat') > -1 ? 'on' : ''}" onclick="dictPage('eats')">Реестр блюд</button>
      <button type="button" data-p="types" class="${fn:endsWith(cur, '/eats/dict/types.s') ? 'on' : ''}" onclick="dictPage('types')">Категории блюд</button>
      <button type="button" data-p="products" class="${fn:endsWith(cur, '/eats/dict/products.s') ? 'on' : ''}" onclick="dictPage('products')">Продукты</button>
      <button type="button" data-p="categories" class="${fn:endsWith(cur, '/eats/dict/categories.s') ? 'on' : ''}" onclick="dictPage('categories')">Категории продуктов</button>
      <button type="button" data-p="measures" class="${fn:endsWith(cur, '/eats/dict/measures.s') ? 'on' : ''}" onclick="dictPage('measures')">Ед. измерения</button>
      <button type="button" data-p="tables" class="${fn:endsWith(cur, '/eats/dict/tables.s') ? 'on' : ''}" onclick="dictPage('tables')">Столы</button>
      <button type="button" data-p="menuTypes" class="${fn:endsWith(cur, '/eats/dict/menuTypes.s') ? 'on' : ''}" onclick="dictPage('menuTypes')">Типы меню</button>
    </div>
  </div>
  <div id="pager"></div>
</div>
<script>
  function dictPage(code) {
    $('#dkTabs button').removeClass('on').filter('[data-p="' + code + '"]').addClass('on');
    $('#pager').load('/eats/dict/' + code + '.s');
  }
  (function () {
    var cur = '${cur}';
    if (!$('#dkTabs button.on').length || cur.indexOf('/eats/dict/') < 0) { $('#dkTabs button').removeClass('on').first().addClass('on'); cur = '/eats/dict/eats.s'; }
    $('#pager').load(cur);
  })();
</script>
