<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Приход по акту
    <button  class="btn btn-sm btn-success" onclick="addEditDrugAct(0)" style="float:right;margin-top:-5px"><i class="fa fa-plus"></i> Добавить</button>
  </div>
  <div class="panel-body">
    <%@include file="/incs/msgs/successError.jsp"%>
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
          <tr>
            <th>#</th>
            <th>Акт</th>
            <th>Состояние</th>
          </tr>
        </thead>
        <tbody>
        <c:forEach items="${acts}" var="obj">
          <tr>
            <td align="center">${obj.id}</td>
            <td>
              <a href="#" onclick="addEditDrugAct(${obj.id}); return false">№${obj.regNum} от <fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.regDate}" /></a>
            </td>
            <td align="center">
              <c:if test="${obj.state == 'E'}">Введен</c:if>
              <c:if test="${obj.state == 'O'}">Подтвержден</c:if>
              <c:if test="${obj.state == 'C'}">Закрыт</c:if>
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
  function addEditDrugAct(id){
    setPage('/drugs/act/addEdit.s?id=' + id);
  }
</script>