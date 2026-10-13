<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@include file="/WEB-INF/pages/core/skin.jsp"%>
<c:set var="isGroups" value="${fn:indexOf(sessionScope.ENV.curSubUrl, 'core/ambv2/group') > -1}"/>
<style>
  .av-wrap { height:100%; display:flex; flex-direction:column; }
  .av-tabs { flex:none; display:flex; align-items:center; gap:10px; padding:10px 14px 0; background:#F5F6F8; }
  .av-tabs .fm-seg button { height:30px; padding:0 14px; font-size:13px; }
  #pager { flex:1; min-height:0; }
  #pager > .fm-page { padding-top:8px; }
</style>
<div class="av-wrap">
  <div class="av-tabs">
    <div class="fm-seg" id="avTabs">
      <button type="button" data-p="services" class="${isGroups ? '' : 'on'}" onclick="dictPage('services')"><i class="fa fa-flask"></i> Услуги</button>
      <button type="button" data-p="groups" class="${isGroups ? 'on' : ''}" onclick="dictPage('groups')"><i class="fa fa-folder-o"></i> Группы</button>
    </div>
  </div>
  <div id="pager"></div>
</div>
<script>
  function dictPage(code) {
    $('#avTabs button').removeClass('on').filter('[data-p=' + code + ']').addClass('on');
    $('#pager').load('core/ambv2/' + code + '.s');
  }
  $('#pager').load('${sessionScope.ENV.curSubUrl}');
</script>
