<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<style>
    .miniGrid thead tr th {text-align: center; background: #e8e8e8}
    .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Статционарные пакеты услуг
    <button  class="btn btn-sm btn-success" onclick="setPage('/admin/pack/info.s?id=0')" style="float:right;margin-top:-5px"><i class="fa fa-plus"></i> Добавить</button>
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
          <tr>
            <th>#</th>
            <th>Наименование</th>
            <th>Дата начала</th>
            <th>Дата окончания</th>
            <th>Стоимость</th>
            <th>Стоимость с НДС</th>
            <th>Состояние</th>
          </tr>
        </thead>
        <tbody>
        <c:forEach items="${rows}" var="obj" varStatus="loop">
          <tr ondblclick="setPage('/admin/pack/info.s?id=${obj.id}')">
            <td align="center">${loop.index + 1}</td>
            <td>${obj.name}</td>
            <td class="center"><fmt:formatDate pattern="dd.MM.yyyy" value="${obj.start}" /></td>
            <td class="center"><fmt:formatDate pattern="dd.MM.yyyy" value="${obj.end}" /></td>
            <td align="right"><fmt:formatNumber value="${obj.price}" type="number"/></td>
            <td align="right"><fmt:formatNumber value="${obj.price * (100 + ndsProc) / 100}" type="number"/></td>
            <td class="center">
              <c:if test="${obj.state == 'A'}">Активный</c:if>
              <c:if test="${obj.state != 'A'}">Пассивный</c:if>
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
