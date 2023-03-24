<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .miniGrid thead tr th {text-align: center; background: #e8e8e8}
    .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>

<div class="panel panel-info" style="width: 800px; margin: auto">
  <div class="panel-heading">Список медсестр</div>
  <div class="panel-body">
    <div class="table-responsive">
      <button onclick="setPage('/admin/nurse/info.s?id=0')" class="btn btn-sm btn-success" style="float:left; margin-bottom: 10px; margin-right: 5px"><i class="fa fa-plus"></i> Добавить нового пользователя</button>
      <button onclick="delUser()" class="btn btn-sm btn-danger" title="Удалить пользователя" style="float:left; margin-bottom: 10px; margin-right: 5px"><i class="glyphicon glyphicon-remove"></i> Удалить</button>
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>#</th>
          <th>#</th>
          <th>Логин</th>
          <th>ФИО</th>
          <th>Активный?</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${users}" var="u">
          <tr ondblclick="setPage('/admin/nurse/save.s?id=${u.id}')" onclick="setUser(${u.id})">
            <td class="center"><input type="radio" class="id" id="user${u.id}" name="id" value="${u.id}"/></td>
            <td class="center">${u.id}</td>
            <td>${u.login}</td>
            <td>${u.fio}</td>
            <td class="center">${u.active ? 'Да' : 'Нет'}</td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
    <!-- /.table-responsive -->
  </div>
  <!-- /.panel-body -->
</div>
