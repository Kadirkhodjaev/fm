<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script>
  function delUser(){
    if(!$('.userId').is(':checked')) {
      alert('Выбирите пользователя!');
      $('#myModal').fadeToggle();
    } else
      if(confirm('Вы действительно хотите удалить?'))
        setPage('/admin/users/del.s?id=' + $('.userId:checked').val());
  }
  function setRoles(){
    if(!$('.userId').is(':checked'))
      alert('Выбирите пользователя!');
    else {
      $('#myModal').load('/admin/users/roles.s?id=' + $('.userId:checked').val());
      $('#modalBtn').click();
    }
  }
  $(document).ready(function(){
    $('#frmDiv').bind('load', function (){
      try {
        var res = frm.document.getElementById('frmDiv').innerHTML;
        $('body').removeClass().css("padding", "0");
        $('.modal-backdrop').remove();
        $('#mainWindow').html($('#frmDiv').contents().find('html').html());
      } catch(e){}
    });
    $('#myModal').hide();
    <c:if test="${kdoUser != null}">
      $('#myModal').load('/admin/users/kdos.s?id=${kdoUser}');
      $('#modalBtn').click();
    </c:if>
  });
  function setUser(id) {
    document.getElementById("user" + id).checked = true;
  }
</script>
<iframe src="about:blank" id="frmDiv" name="frm" style="display: none"></iframe>
<button data-toggle="modal" data-target="#myModal" style="display: none" id="modalBtn"></button>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" style="display: none;"></div>

<div class="panel panel-info" style="width: 800px; margin: auto">
  <div class="panel-heading">Список пользователей</div>
  <div class="panel-body">
    <%@include file="/incs/msgs/successError.jsp"%>
    <div class="table-responsive">
      <button onclick="setPage('/admin/users/addEdit.s')" class="btn btn-sm btn-success" style="float:left; margin-bottom: 10px; margin-right: 5px"><i class="fa fa-plus"></i> Добавить нового пользователя</button>
      <button onclick="delUser()" class="btn btn-sm btn-danger" title="Удалить пользователя" style="float:left; margin-bottom: 10px; margin-right: 5px"><i class="glyphicon glyphicon-remove"></i> Удалить</button>
      <button onclick="setRoles()" class="btn btn-sm btn-primary" style="float:left; margin-bottom: 10px"><i class="fa fa-tasks"></i> Роли и отчеты</button>
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>#</th>
          <th>#</th>
          <th>Логин</th>
          <th>ФИО</th>
          <th>Отделение</th>
          <th>Активный?</th>
          <th>Консультант?</th>
          <th>Зав отдел?</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${users}" var="u">
          <tr ondblclick="setPage('/admin/users/addEdit.s?id=${u.id}')" onclick="setUser(${u.id})">
            <td class="center"><input type="radio" class="userId" id="user${u.id}" name="userId" value="${u.id}"/></td>
            <td class="center">${u.id}</td>
            <td>${u.login}</td>
            <td>${u.fio}</td>
            <td class="center">${u.dept.name}</td>
            <td class="center">${u.active ? 'Да' : 'Нет'}</td>
            <td class="center">${u.consul ? 'Да' : 'Нет'}</td>
            <td class="center">${u.zavlv ? 'Да' : 'Нет'}</td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
    <!-- /.table-responsive -->
  </div>
  <!-- /.panel-body -->
</div>