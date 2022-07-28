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
    Отделении
    <a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
    <button  class="btn btn-sm btn-success" onclick="addDrugDict()" style="float:right;margin-top:-5px"><i class="fa fa-plus"></i> Добавить</button>
  </div>
  <div class="panel-body">
    <%@include file="/incs/msgs/successError.jsp"%>
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>#</th>
          <th>Наименование</th>
          <th>Старшая медсестра</th>
          <th>Состояние</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${rows}" var="obj">
          <tr ondblclick="editDrugDict(${obj.id})" class="hover">
            <td align="center">${obj.id}</td>
            <td>
              ${obj.name}
            </td>
            <td align="center">
              ${obj.nurse.fio}
            </td>
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
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel">Реквизиты кетогорий</h4>
      </div>
      <div class="modal-body">
        <form id="addEditForm" name="addEditForm">
          <input type="hidden" name="id" value="" />
          <table class="table table-bordered">
            <tr>
              <td class="right bold">Наименование*:</td>
              <td>
                <input type="text" id="category-name" class="form-control" name="name" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Старшая медсестра*:</td>
              <td>
                <select class="form-control" name="user">
                  <c:forEach items="${users}" var="user">
                    <option value="${user.id}">${user.fio}</option>
                  </c:forEach>
                </select>
              </td>
            </tr>
            <tr>
              <td class="right bold">Активный?:</td>
              <td class="left">
                <input type="checkbox" checked name="state" value="A"/>
              </td>
            </tr>
          </table>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" onclick="saveDrugForm()">Сохранить</button>
        <button type="button" class="btn btn-default" id="close-modal" data-dismiss="modal">Закрыть</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<script>
  function addDrugDict(){
    addEditForm.reset();
    document.getElementById("modal_window").click();
  }
  function editDrugDict(id) {
    document.getElementById("modal_window").click();
    $.ajax({
      url: '/admin/dept/get.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('*[name=id]').val(res.id);
          $('*[name=name]').val(res.name);
          $('*[name=user]').val(res.user);
          $('*[name=state]').prop('checked', res.state == 'A');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function saveDrugForm() {
    if($('#category-name').val() == '') {
      alert('Наименование не может быть пустым');
      return;
    }
    $.ajax({
      url: '/admin/dept/save.s',
      method: 'post',
      data: $('#addEditForm').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('#close-modal').click();
          alert("Данные успешно сохранены");
          setPage('/admin/depts.s');
        } else {
          alert(res.msg);
        }
      }
    });
  }
</script>