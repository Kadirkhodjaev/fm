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
    Получатели (Расход)
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
          <th>Экстренный шкаф?</th>
          <th>Перевод?</th>
          <th>Состояние</th>
          <th style="width:40px">Удалить</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${list}" var="obj">
          <tr>
            <td align="center">${obj.id}</td>
            <td>
              <a href="#" onclick="editDrugDict(${obj.id});return false">${obj.name}</a>
            </td>
            <td align="center">
              <c:if test="${obj.shock == 'Y'}">Да</c:if>
              <c:if test="${obj.shock != 'Y'}">Нет</c:if>
            </td>
            <td align="center">
              <c:if test="${obj.transfer == 'Y'}">Да</c:if>
              <c:if test="${obj.transfer != 'Y'}">Нет</c:if>
            </td>
            <td align="center">
              <c:if test="${obj.state == 'A'}">Активный</c:if>
              <c:if test="${obj.state != 'A'}">Пассивный</c:if>
            </td>
            <td class="center">
              <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delDrugRow(${obj.id})"><i class="fa fa-minus"></i></button>
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
        <h4 class="modal-title" id="myModalLabel">Реквизиты получателя</h4>
      </div>
      <div class="modal-body">
        <form id="addEditForm" name="addEditForm">
          <input type="hidden" name="id" value="" />
          <input type="hidden" name="code" value="direction" />
          <table class="table table-bordered">
            <tr>
              <td class="right bold">Наименование*:</td>
              <td>
                <input type="text" id="direction-name" class="form-control" name="name" value=""/>
              </td>
            </tr>
            <tr>
              <td colspan="2" class="bold center">Отделении</td>
            </tr>
            <c:forEach items="${deps}" var="dep">
              <tr>
                <td class="right">
                  <input type="checkbox" class="dep_checkbox" value="${dep.id}" id="dep_${dep.id}" name="dep"/>
                </td>
                <td>${dep.name}</td>
              </tr>
            </c:forEach>
            <tr>
              <td class="right bold">Активный?:</td>
              <td class="left">
                <input type="checkbox" checked name="state" value="Y"/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Экстренный шкаф?:</td>
              <td class="left">
                <input type="checkbox" checked name="shock" value="Y"/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Перевод?:</td>
              <td class="left">
                <input type="checkbox" checked name="transfer" value="Y"/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Пользователи:</td>
              <td class="left" id="direction_users"></td>
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
      url: '/drugs/dict/get.s',
      method: 'post',
      data: 'code=direction&id=' + id,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('*[name=id]').val(res.id);
          $('*[name=name]').val(res.name);
          $('#direction_users').html(res.users);
          $('*[name=state]').prop('checked', res.state == 'A');
          $('*[name=shock]').prop('checked', res.shock == 'Y');
          $('*[name=transfer]').prop('checked', res.transfer == 'Y');
          var elems = document.getElementsByClassName("dep_checkbox");
          for(var elem of elems) elem.checked = false;
          for(var obj of res.deps) document.getElementById("dep_" + obj).checked = true;
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function saveDrugForm() {
    if($('#direction-name').val() == '') {
      alert('Наименование не может быть пустым');
      return;
    }
    $.ajax({
      url: '/drugs/dict/save.s',
      method: 'post',
      data: $('#addEditForm').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert("<ui:message code="successSave"/>");
          $('#close-modal').click();
          setPage('/drugs/dicts.s');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function delDrugRow(id) {
    if(confirm('Дейтвительно хотите удалить?')) {
      $.ajax({
        url: '/drugs/dict/delete.s',
        method: 'post',
        data: 'code=direction&id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/drugs/dicts.s');
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
</script>
