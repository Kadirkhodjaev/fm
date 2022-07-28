<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script>
  function dictPage(code){
    $('#pager').load('/exp/dict/' + code + '.s');
  }
  $(document).ready(function(){
    $('#pager').load('${sessionScope.ENV.curSubUrl}');
  });
</script>
<div class="panel panel-info">
  <div class="panel-body">
    <ul class="nav nav-tabs">
      <li class="<c:if test="${sessionScope.ENV.curSubUrl == '/exp/dict/categories.s'}">active</c:if>">
        <a href="#page_category" onclick="dictPage('categories')" data-toggle="tab" aria-expanded="${sessionScope.ENV.curSubUrl == '/exp/dict/categories.s'}">Категории товаров</a>
      </li>
      <li class="<c:if test="${sessionScope.ENV.curSubUrl == '/exp/dict/products.s'}">active</c:if>">
        <a href="#page_products" onclick="dictPage('products')" data-toggle="tab" aria-expanded="${sessionScope.ENV.curSubUrl == '/exp/dict/products.s'}">Товары</a>
      </li>
      <li class="<c:if test="${sessionScope.ENV.curSubUrl == '/exp/dict/measures.s'}">active</c:if>">
        <a href="#page_measures" onclick="dictPage('measures')" data-toggle="tab" aria-expanded="${sessionScope.ENV.curSubUrl == '/exp/dict/measures.s'}">Единицы измерения</a>
      </li>
      <li class="<c:if test="${fn:contains(sessionScope.ENV.curSubUrl, '/exp/dict/service')}">active</c:if>">
        <a href="#page_services" onclick="dictPage('services')" data-toggle="tab" aria-expanded="${fn:contains(sessionScope.ENV.curSubUrl, '/exp/dict/service')}">Услуги</a>
      </li>
    </ul>
    <div class="tab-content">
      <div class="tab-pane active fade in" id="pager"></div>
    </div>
  </div>
</div>
</div>