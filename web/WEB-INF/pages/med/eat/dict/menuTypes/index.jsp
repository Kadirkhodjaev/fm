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
    Типы меню
    <button  class="btn btn-sm btn-success" onclick="addEatDict()" style="float:right;margin-top:-5px"><i class="fa fa-plus"></i> Добавить</button>
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
              <a href="#" onclick="editEatDict(${obj.id});return false">${obj.name}</a>
            </td>
            <td align="center">
              <c:if test="${obj.state == 'A'}">Активный</c:if>
              <c:if test="${obj.state != 'A'}">Пассивный</c:if>
            </td>
            <td class="center">
              <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delEatRow(${obj.id})"><i class="fa fa-minus"></i></button>
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

<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
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
          <input type="hidden" name="code" value="menuType" />
          <table class="table table-bordered">
            <tr>
              <td class="right bold">Наименование*:</td>
              <td>
                <input type="text" id="menuType-name" class="form-control" name="name" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Активный?:</td>
              <td class="left">
                <input type="checkbox" checked name="state" value="Y"/>
              </td>
            </tr>
          </table>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" onclick="saveEatForm()">Сохранить</button>
        <button type="button" class="btn btn-default" id="close-modal" data-dismiss="modal">Закрыть</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<script>
  function addEatDict(){
    addEditForm.reset();
    document.getElementById("modal_window").click();
  }
  function editEatDict(id) {
    $.ajax({
      url: '/eats/dict/get.s',
      method: 'post',
      data: 'code=menuType&id=' + id,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          document.getElementById("modal_window").click();
          $('*[name=id]').val(res.id);
          $('*[name=name]').val(res.name);
          $('*[name=state]').prop('checked', res.state == 'A');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function saveEatForm() {
    if($('#menuType-name').val() == '') {
      alert('Наименование не может быть пустым');
      return;
    }
    $.ajax({
      url: '/eats/dict/save.s',
      method: 'post',
      data: $('#addEditForm').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert("<ui:message code="successSave"/>");
          $('#close-modal').click();
          setPage('/eats/dicts.s');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function delEatRow(id) {
    if(confirm('Дейтвительно хотите удалить?')) {
      $.ajax({
        url: '/eats/dict/delete.s',
        method: 'post',
        data: 'code=menuType&id=' + id,
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