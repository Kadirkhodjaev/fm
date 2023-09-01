<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script>
  function addAmb() {
    setPage('/core/amb/group/save.s');
  }
</script>
<style>
  table tr.selected {background: #eee}
</style>
<div class="panel panel-info">
  <div class="panel-heading">
    Список амбулаторных групп
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
          <tr ondblclick="setPage('/core/amb/group/save.s?id=${g.id}');return false;">
            <td style="vertical-align: middle" class="center">${loop.index + 1}</td>
            <td style="vertical-align: middle">
              <a href="#" onclick="setPage('/core/amb/group/save.s?id=${g.id}');return false;">${g.name}</a>
            </td>
            <td style="vertical-align: middle; text-align: center">
              <c:if test="${g.group}">Да</c:if>
              <c:if test="${!g.group}">Нет</c:if>
            </td>
            <td style="vertical-align: middle; text-align: center">
              <c:if test="${g.active}">Активный</c:if>
              <c:if test="${!g.active}">Пассивный</c:if>
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
