<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<div class="panel panel-info">
  <div class="panel-heading">
    Список форм
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
          <tr>
            <th style="width:50px">ID</th>
            <th>Наименование</th>
            <th>Edit?</th>
          </tr>
        </thead>
        <tbody>
        <c:forEach items="${forms}" var="f" varStatus="loop">
          <tr ondblclick="<c:if test="${sessionScope.ENV.userId == 1}">setPage('/core/form/fields.s?formId=${f.id}')</c:if>">
            <td class="center">${f.id}</td>
            <td>${f.name}</td>
            <td class="center">${f.type == 0 ? 'Да' : 'Нет'}</td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
    <!-- /.table-responsive -->
  </div>
  <!-- /.panel-body -->
</div>
