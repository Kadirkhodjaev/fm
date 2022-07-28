<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    Услуги
  </div>
  <div class="panel-body">
    <%@include file="/incs/msgs/successError.jsp"%>
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>№</th>
          <th>Группа</th>
          <th>Категория</th>
          <th>Наименование</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${list}" var="obj" varStatus="loop">
          <tr>
            <td align="center">${loop.index + 1}</td>
            <td align="center">${obj.c4}</td>
            <td align="center">${obj.c2}</td>
            <td>
              <a href="#" onclick="$('#pager').load('/exp/dict/service.s?type=${obj.c5}&id=${obj.c1}');return false">${obj.c3}</a>
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