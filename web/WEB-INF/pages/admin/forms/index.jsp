<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>

<div class="panel panel-info">
  <div class="panel-heading">
    Список форм
    <div style="float:right">
      <a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
      <button class="btn btn-sm btn-success" type="button" onclick="addForm()" style="margin-top: -5px"><i class="fa fa-plus"></i> Добавить</button>
    </div>
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
          <tr>
            <th>ID</th>
            <th>Наименование</th>
            <th>Edit?</th>
          </tr>
        </thead>
        <tbody>
        <c:forEach items="${forms}" var="f" varStatus="loop">
          <tr ondblclick="<c:if test="${sessionScope.ENV.userId == 1}">setPage('/admin/forms/fields.s?formId=${f.id}')</c:if>">
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
                <input type="text" id="form_name" class="form-control" name="name" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Ед. изм.?:</td>
              <td class="left">
                <input type="checkbox" checked name="ei_flag" value="Y"/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Норма?:</td>
              <td class="left">
                <input type="checkbox" checked name="norma_flag" value="Y"/>
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
  function editDrugDict(id) {
    document.getElementById("modal_window").click();
    $.ajax({
      url: '/admin/form/get.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('*[name=id]').val(res.id);
          $('*[name=form_name]').val(res.form_name);
          $('*[name=ei_flag]').prop('checked', res.ei_flag == 'Y');
          $('*[name=norma_flag]').prop('checked', res.norma_flag == 'Y');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function saveDrugForm() {
    alert(1);
  }
  function addForm() {
    addEditForm.reset();
    document.getElementById("modal_window").click();
  }
</script>