<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script>
</script>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Реестр блюд
    <button  class="btn btn-sm btn-success" onclick="$('#pager').load('/eats/dict/eat/addEdit.s?id=0');" style="float:right;margin-top:-5px"><i class="fa fa-plus"></i> Добавить</button>
  </div>
  <div class="panel-body">
    <%@include file="/incs/msgs/successError.jsp"%>
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>#</th>
          <th>Наименование</th>
          <th>Состояние</th>
          <th style="width:40px">Удалить</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${list}" var="obj">
          <tr>
            <td align="center">${obj.id}</td>
            <td>
              <a href="#" onclick="$('#pager').load('/eats/dict/eat/addEdit.s?id=${obj.id}'); return false">${obj.name}</a>
            </td>
            <td align="center">
              <c:if test="${obj.state == 'A'}">Активный</c:if>
              <c:if test="${obj.state != 'A'}">Пассивный</c:if>
            </td>
            <td class="center">
              <button class="btn btn-danger btn-sm" type="button" style="height:20px;padding:1px 10px" title="Удалить" onclick="delEatRow(${obj.id})"><i class="fa fa-minus"></i></button>
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
<script>
  function delEatRow(id) {
    if(confirm('Дейтвительно хотите удалить?')) {
      $.ajax({
        url: '/eats/dict/delete.s',
        method: 'post',
        data: 'code=category&id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/eats/dicts.s');
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
</script>