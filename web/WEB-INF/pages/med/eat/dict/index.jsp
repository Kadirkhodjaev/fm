<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script>
  function dictPage(code){
    $('#pager').load('/eats/dict/' + code + '.s');
  }
  $(document).ready(function(){
    $('#pager').load('${sessionScope.ENV.curSubUrl}');
  });
</script>
<div class="panel panel-info">
  <div class="panel-body">
    <ul class="nav nav-tabs">
      <li class="<c:if test="${sessionScope.ENV.curSubUrl == '/eats/dict/categories.s'}">active</c:if>">
        <a href="#page_category" onclick="dictPage('categories')" data-toggle="tab" aria-expanded="${sessionScope.ENV.curSubUrl == '/eats/dict/categories.s'}">Категории продуктов</a>
      </li>
      <li class="<c:if test="${sessionScope.ENV.curSubUrl == '/eats/dict/products.s'}">active</c:if>">
        <a href="#page_products" onclick="dictPage('products')" data-toggle="tab" aria-expanded="${sessionScope.ENV.curSubUrl == '/eats/dict/products.s'}">Продукты</a>
      </li>
      <li class="<c:if test="${sessionScope.ENV.curSubUrl == '/eats/dict/measures.s'}">active</c:if>">
        <a href="#page_measures" onclick="dictPage('measures')" data-toggle="tab" aria-expanded="${sessionScope.ENV.curSubUrl == '/eats/dict/measures.s'}">Единицы измерения</a>
      </li>
      <li class="<c:if test="${sessionScope.ENV.curSubUrl == '/eats/dict/tables.s'}">active</c:if>">
        <a href="#page_tables" onclick="dictPage('tables')" data-toggle="tab" aria-expanded="${sessionScope.ENV.curSubUrl == '/eats/dict/tables.s'}">Столы</a>
      </li>
      <li class="<c:if test="${sessionScope.ENV.curSubUrl == '/eats/dict/menuTypes.s'}">active</c:if>">
        <a href="#page_menuTypes" onclick="dictPage('menuTypes')" data-toggle="tab" aria-expanded="${sessionScope.ENV.curSubUrl == '/eats/dict/menuTypes.s'}">Типы меню</a>
      </li>
      <li class="<c:if test="${sessionScope.ENV.curSubUrl == '/eats/dict/types.s'}">active</c:if>">
        <a href="#page_types" onclick="dictPage('types')" data-toggle="tab" aria-expanded="${sessionScope.ENV.curSubUrl == '/eats/dict/types.s'}">Категории блюд</a>
      </li>
      <li class="<c:if test="${sessionScope.ENV.curSubUrl == '/eats/dict/eats.s'}">active</c:if>">
        <a href="#page_eats" onclick="dictPage('eats')" data-toggle="tab" aria-expanded="${sessionScope.ENV.curSubUrl == '/eats/dict/eats.s'}">Реестр блюд</a>
      </li>
    </ul>
    <div class="tab-content">
      <div class="tab-pane active fade in" id="pager"></div>
    </div>
  </div>
</div>
</div>