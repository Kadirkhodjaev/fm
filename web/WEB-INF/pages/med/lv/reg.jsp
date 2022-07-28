<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://www.springframework.org/tags/form" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">
<script>
  function nursePage(){
    $('#home').load('/reg/nurse/view.s');
  }
  function docPage(id){
    $('#profile' + id).load('/reg/doctor/view.s?page=' + id);
  }
  $(document).ready(function(){
    $('#home').load('/reg/nurse/view.s');
  });
</script>
<div class="panel panel-info">
  <div class="panel-body">
    <ul class="nav nav-tabs">
      <li class="active"><a href="#home" onclick="nursePage()" data-toggle="tab" aria-expanded="true">Регистрационные данные</a></li>
      <li class=""><a href="#profile1" onclick="docPage(1)" data-toggle="tab" aria-expanded="false">Основные данные</a></li>
      <li class=""><a href="#profile2" data-toggle="tab" onclick="docPage(2)" aria-expanded="false">Дополнительные данные</a></li>
    </ul>
    <div class="tab-content">
      <div class="tab-pane active fade in" id="home"></div>
      <div class="tab-pane fade" id="profile1"></div>
      <div class="tab-pane fade" id="profile2"></div>
      </div>
    </div>
  </div>
</div>