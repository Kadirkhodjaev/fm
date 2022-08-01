<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script>
  function addAmb() {
    setPage('/admin/addAmb.s');
  }
</script>
<style>
  table tr.selected {background: #eee}
</style>
<div class="panel panel-info">
  <div class="panel-heading">
    Список форм
    <div style="float:right">
      <button class="btn btn-sm btn-success" type="button" onclick="addAmb()" style="margin-top: -5px"><i class="fa fa-plus"></i> Добавить</button>
    </div>
    <select class="form-control" onchange="setGroup(this)">
      <option value="0">Все</option>
      <c:forEach items="${groups}" var="g">
        <option <c:if test="${page == g.id}">selected</c:if> value="${g.id}">${g.name}</option>
      </c:forEach>
    </select>
  </div>
  </div>
  <div class="panel-body">
    <%@include file="/incs/msgs/successError.jsp"%>
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>ID</th>
          <th>Группировка</th>
          <th>Наименование</th>
          <th>Стоимость</th>
          <th>Стоимость (Иностранцы)</th>
          <th>Состояние</th>
          <th>Форма</th>
        </thead>
        <tbody>
        <c:forEach items="${services}" var="s" varStatus="loop">
          <tr>
            <td style="vertical-align: middle" class="center">${s.id}</td>
            <td style="vertical-align: middle">${s.service.group.name}</td>
            <td style="vertical-align: middle">
              <a href="#" onclick="setPage('/admin/addAmb.s?id=${s.service.id}');return false;">${s.service.name}</a>
            </td>
            <td style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.service.price}" type = "number"/></td>
            <td style="vertical-align: middle" class="right"><fmt:formatNumber value = "${s.service.for_price}" type = "number"/></td>
            <td style="vertical-align: middle; text-align: center">
              <c:if test="${s.service.state == 'A'}">Активный</c:if>
              <c:if test="${s.service.state == 'P'}">Пассивный</c:if>
            </td>
            <td style="vertical-align: middle; text-align: center">
              ${s.service.form_id}
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
