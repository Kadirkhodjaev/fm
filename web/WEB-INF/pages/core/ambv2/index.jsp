<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script>
  function dictPage(code){
    $('#pager').load('core/ambv2/' + code + '.s');
  }
  $(document).ready(function(){
    $('#pager').load('${sessionScope.ENV.curSubUrl}');
  });
</script>
<div class="panel panel-info">
  <div class="panel-body">
    <ul class="nav nav-tabs">
      <li class="hand <c:if test="${fn:indexOf(sessionScope.ENV.curSubUrl, 'core/ambv2/service') > -1}">active</c:if>"><a onclick="dictPage('services')" aria-expanded="${fn:indexOf(sessionScope.ENV.curSubUrl, 'core/ambv2/service') > -1}" data-toggle="tab">Услуги</a></li>
      <li class="hand <c:if test="${fn:indexOf(sessionScope.ENV.curSubUrl, 'core/ambv2/group') > -1}">active</c:if>"><a onclick="dictPage('groups')" aria-expanded="${fn:indexOf(sessionScope.ENV.curSubUrl, 'core/ambv2/group') > -1}" data-toggle="tab">Группы</a></li>
    </ul>
    <div class="tab-content">
      <div class="tab-pane active fade in" id="pager"></div>
    </div>
  </div>
</div>
