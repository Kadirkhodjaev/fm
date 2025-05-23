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
    Партнеры
    <a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
    <button  class="btn btn-sm btn-success" onclick="addDrugDict()" style="float:right;margin-top:-5px"><i class="fa fa-plus"></i> Добавить</button>
    <select class="form-control wpx-100 float-right" id="sel_state" style="margin-right:5px" onchange="setState(this.value)">
      <option <c:if test="${state == 'A'}">selected</c:if> value="A">Активные</option>
      <option <c:if test="${state == 'P'}">selected</c:if> value="P">Пассивные</option>
    </select>
    <input type="text" class="form-control wpx-200 float-right" placeholder="Поиск" style="margin-right:5px" value="${word}" onkeydown="setFilter(event, this.value)"/>
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>#</th>
          <th>Код</th>
          <th>ФИО</th>
          <th>Состояние</th>
          <th>Отчет</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${rows}" var="obj">
          <tr ondblclick="editDrugDict(${obj.id})" class="hover">
            <td align="center">${obj.id}</td>
            <td>
              ${obj.code}
            </td>
            <td>
              ${obj.fio}
            </td>
            <td class="center">
              <c:if test="${obj.state == 'A'}">Активный</c:if>
              <c:if test="${obj.state != 'A'}">Пассивный</c:if>
            </td>
            <td class="center">
              <c:if test="${obj.report != 'Y'}">Да</c:if>
              <c:if test="${obj.report == 'Y'}">Нет</c:if>
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
              <td class="right bold">Код*:</td>
              <td>
                <input type="text" id="category-code" class="form-control" name="code" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">ФИО*:</td>
              <td>
                <input type="text" id="category-name" class="form-control" name="fio" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Активный?:</td>
              <td class="left">
                <input type="checkbox" checked name="state" value="A"/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Не отображать в отчетах?:</td>
              <td class="left">
                <input type="checkbox" checked name="report" value="Y"/>
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
      url: '/admin/lvpartner/get.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('*[name=id]').val(res.id);
          $('*[name=code]').val(res.code);
          $('*[name=fio]').val(res.fio);
          $('*[name=state]').prop('checked', res.state == 'A');
          $('*[name=report]').prop('checked', res.report == 'Y');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function saveDrugForm() {
    if($('#category-code').val() == '') {
      alert('Код не может быть пустым');
      return;
    }
    $.ajax({
      url: '/admin/lvpartner/save.s',
      method: 'post',
      data: $('#addEditForm').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('#close-modal').click();
          alert("Данные успешно сохранены");
          setPage('/admin/lvpartners.s');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function setState(val) {
    setPage('admin/lvpartners.s?state=' + val);
  }
  function setFilter(evt, str) {
    if(evt.keyCode === 13)
      setPage('admin/lvpartners.s?state=' + $('#sel_state').val() + '&word=' + str);
  }
</script>
