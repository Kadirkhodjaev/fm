<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script>
  function addAmb() {
    setPage('/admin/addStatGroup.s');
  }
</script>
<style>
  table tr.selected {background: #eee}
</style>
<div class="panel panel-info">
  <div class="panel-heading">
    Список стационарных групп
    <div style="float:right">
      <button class="btn btn-sm btn-success" type="button" onclick="addAmb()" style="margin-top: -5px"><i class="fa fa-plus"></i> Добавить</button>
    </div>
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>ID</th>
          <th>Наименование</th>
          <th>Группа</th>
          <th>Состояние</th>
        </thead>
        <tbody>
        <c:forEach items="${groups}" var="g" varStatus="loop">
          <tr>
            <td style="vertical-align: middle" class="center">${loop.index + 1}</td>
            <td style="vertical-align: middle">
              <a href="#" onclick="setPage('/admin/addStatGroup.s?id=${g.id}');return false;">${g.name}</a>
            </td>
            <td style="vertical-align: middle; text-align: center">
              <c:if test="${g.groupState != 'N'}">Да</c:if>
              <c:if test="${g.groupState == 'N'}">Нет</c:if>
            </td>
            <td style="vertical-align: middle; text-align: center">
              <c:if test="${g.state == 'A'}">Активный</c:if>
              <c:if test="${g.state != 'A'}">Пассивный</c:if>
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