<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script>
  function dictPage(code){
    $('#pager').load('/drugs/dict/' + code + '.s');
  }
  $(document).ready(function(){
    $('#pager').load('${sessionScope.ENV.curSubUrl}');
  });
</script>
<div class="panel panel-info">
  <div class="panel-body">
    <ul class="nav nav-tabs">
      <li class="<c:if test="${sessionScope.ENV.curSubUrl == '/drugs/dict/contracts.s'}">active</c:if>"><a href="#page_contracts" onclick="dictPage('contracts')" data-toggle="tab" aria-expanded="${sessionScope.ENV.curSubUrl == '/drugs/dict/contracts.s'}">Договора</a></li>
      <li class="<c:if test="${sessionScope.ENV.curSubUrl == '/drugs/dict/partners.s'}">active</c:if>"><a href="#page_partners" onclick="dictPage('partners')" data-toggle="tab" aria-expanded="${sessionScope.ENV.curSubUrl == '/drugs/dict/partners.s'}">Партнеры</a></li>
      <li class="<c:if test="${sessionScope.ENV.curSubUrl == '/drugs/dict/categories.s'}">active</c:if>"><a href="#page_categories" data-toggle="tab" onclick="dictPage('categories')" aria-expanded="${sessionScope.ENV.curSubUrl == '/drugs/dict/categories.s'}">Категории</a></li>
      <li class="<c:if test="${sessionScope.ENV.curSubUrl == '/drugs/dict/drugs.s'}">active</c:if>"><a href="#page_drugs" data-toggle="tab" onclick="dictPage('drugs')" aria-expanded="${sessionScope.ENV.curSubUrl == '/drugs/dict/drugs.s'}">Препараты</a></li>
      <li class="<c:if test="${sessionScope.ENV.curSubUrl == '/drugs/dict/drug/normas.s'}">active</c:if>"><a href="#page_drug_normas" data-toggle="tab" onclick="dictPage('drug/normas')" aria-expanded="${sessionScope.ENV.curSubUrl == '/drugs/dict/drug/normas.s'}">Нормативы</a></li>
      <li class="<c:if test="${sessionScope.ENV.curSubUrl == '/drugs/dict/measures.s'}">active</c:if>"><a href="#page_measures" data-toggle="tab" onclick="dictPage('measures')" aria-expanded="${sessionScope.ENV.curSubUrl == '/drugs/dict/measures.s'}">Единицы измерения</a></li>
      <li class="<c:if test="${sessionScope.ENV.curSubUrl == '/drugs/dict/directions.s'}">active</c:if>"><a href="#page_directions" data-toggle="tab" onclick="dictPage('directions')" aria-expanded="${sessionScope.ENV.curSubUrl == '/drugs/dict/directions.s'}">Получатели</a></li>
      <li class="<c:if test="${sessionScope.ENV.curSubUrl == '/drugs/dict/manufacturers.s'}">active</c:if>"><a href="#page_manufacturers" data-toggle="tab" onclick="dictPage('manufacturers')" aria-expanded="${sessionScope.ENV.curSubUrl == '/drugs/dict/manufacturers.s'}">Производители</a></li>
      <li class="<c:if test="${sessionScope.ENV.curSubUrl == '/drugs/dict/rasxodtypes.s'}">active</c:if>"><a href="#page_manufacturers" data-toggle="tab" onclick="dictPage('rasxodtypes')" aria-expanded="${sessionScope.ENV.curSubUrl == '/drugs/dict/rasxodtypes.s'}">Типы расходов</a></li>
    </ul>
    <div class="tab-content">
      <div class="tab-pane active fade in" id="pager"></div>
    </div>
  </div>
</div>
</div>
