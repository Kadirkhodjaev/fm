<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script>
  function dictPage(code){
    $('#pager').load('/head_nurse/dicts/' + code + '.s');
  }
  $(document).ready(function(){
    $('#pager').load('${sessionScope.ENV.curSubUrl}');
  });
</script>
<div class="panel panel-info">
  <div class="panel-body">
    <ul class="nav nav-tabs">
      <li class="<c:if test="${sessionScope.ENV.curSubUrl == '/head_nurse/dicts/directions.s'}">active</c:if>"><a href="#page_drugs" data-toggle="tab" onclick="dictPage('directions')" aria-expanded="${sessionScope.ENV.curSubUrl == '/head_nurse/dicts/directions.s'}">Получатели</a></li>
    </ul>
    <div class="tab-content">
      <div class="tab-pane active fade in" id="pager"></div>
    </div>
  </div>
</div>
