<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<style>
  table tr.selected {background: #eee}
</style>
<div class="panel panel-info">
  <div class="panel-heading">
    Цена по типам коек
    <button class="btn btn-sm btn-success" style="float:right; margin-top:-5px" onclick="savePrice()">
      Сохранить
    </button>
  </div>
  <form id="price-form">
    <div class="panel-body">
      <div class="table-responsive">
        <table class="miniGrid table table-striped table-bordered">
          <thead>
          <tr>
            <th>#</th>
            <th>Наименование</th>
            <th>Стоимость за 1 к.д.</th>
          </thead>
          <tbody>
          <c:forEach items="${prices}" var="s" varStatus="loop">
            <input type="hidden" name="code" value="${s.code}"/>
            <tr>
              <td style="vertical-align: middle" class="center">${loop.index + 1}</td>
              <td style="vertical-align: middle">${s.name}</td>
              <td style="vertical-align: middle" class="right">
                <c:if test="${s.code == 'HEAD_NURSE'}">
                  <input type="text" class="form-control" name="price" value="${s.val}"/>
                </c:if>
                <c:if test="${s.code != 'HEAD_NURSE'}">
                  <input type="number" class="form-control right" name="price" value="${s.val}"/>
                </c:if>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
      <!-- /.table-responsive -->
    </div>
  </form>
  <!-- /.panel-body -->
</div>
<script>
  function savePrice() {
    $.ajax({
      url: '/admin/price.s',
      method: 'post',
      data: $('#price-form').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert("<ui:message code="successSave"/>");
        } else {
          alert(res.msg);
        }
      }
    });
  }
</script>