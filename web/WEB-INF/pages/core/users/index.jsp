<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script>
  function delUser(id){
    if(confirm('Вы действительно хотите удалить?')) {
      $.ajax({
        url: '/core/user/del.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          openMsg(res);
        }
      });
    }
  }
  function setRoles(id){
    $('#myModal').load('/core/user/roles.s?id=' + id);
    $('#modalBtn').click();
  }
</script>
<button data-toggle="modal" data-target="#myModal" style="display: none" id="modalBtn"></button>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" style="display: none;"></div>

<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Список пользователей
    <button onclick="setPage('/core/user/save.s')" class="btn btn-sm btn-success margin-top-5" style="float:right"><i class="fa fa-plus"></i> Добавить нового пользователя</button>
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>#</th>
          <th>Логин</th>
          <th>ФИО</th>
          <th>Отделение</th>
          <th>Активный?</th>
          <th>Консультант?</th>
          <th>Зав отдел?</th>
          <th>Действии</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${users}" var="u">
          <tr ondblclick="setPage('/core/user/save.s?id=${u.id}')">
            <td class="center">${u.id}</td>
            <td>${u.login}</td>
            <td>${u.fio}</td>
            <td class="center">${u.dept.name}</td>
            <td class="center">${u.active ? 'Да' : 'Нет'}</td>
            <td class="center">${u.consul ? 'Да' : 'Нет'}</td>
            <td class="center">${u.zavlv ? 'Да' : 'Нет'}</td>
            <td class="center">
              <button class="btn btn-sm btn-danger" type="button" title="Удалить" onclick="delUser(${u.id})"><span class="fa fa-remove"></span></button>
              <button class="btn btn-sm btn-primary" type="button" title="Роли" onclick="setRoles(${u.id})"><span class="fa fa-list"></span></button>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
    <!-- /.table-responsive -->
  </div>
  <!-- /.panel-body -->
</div>
