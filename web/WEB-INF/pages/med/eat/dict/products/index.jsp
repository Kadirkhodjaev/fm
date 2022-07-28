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
    Реестр продуктов
    <button  class="btn btn-sm btn-success" onclick="addEatDict()" style="float:right;margin-top:-5px"><i class="fa fa-plus"></i> Добавить</button>
  </div>
  <div class="panel-body">
    <%@include file="/incs/msgs/successError.jsp"%>
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>#</th>
          <th>Категория</th>
          <th>Наименование</th>
          <th>Состояние</th>
          <th style="width:40px">Удалить</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${list}" var="obj">
          <tr>
            <td align="center">${obj.id}</td>
            <td align="center">${obj.category.name}</td>
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
          <input type="hidden" name="code" value="product" />
          <table class="table table-bordered">
            <tr>
              <td class="right bold">Категория *:</td>
              <td>
                <select class="form-control" name="category">
                  <c:forEach items="${categories}" var="category">
                    <option value="${category.id}">${category.name}</option>
                  </c:forEach>
                </select>
              </td>
            </tr>
            <tr>
              <td class="right bold">Наименование*:</td>
              <td>
                <input type="text" id="product-name" class="form-control" name="name" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Тип ед. изм. *:</td>
              <td>
                <select class="form-control" name="measureType">
                  <c:forEach items="${measureTypes}" var="measureType">
                    <option value="${measureType.id}">${measureType.name}</option>
                  </c:forEach>
                </select>
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
    document.getElementById("modal_window").click();
    $.ajax({
      url: '/eats/dict/get.s',
      method: 'post',
      data: 'code=product&id=' + id,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('*[name=id]').val(res.id);
          $('*[name=category]').val(res.category);
          $('*[name=name]').val(res.name);
          $('*[name=state]').prop('checked', res.state == 'A');
          $('*[name=measureType]').val(res.measureType);
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function saveEatForm() {
    if($('#product-name').val() == '') {
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
        data: 'code=product&id=' + id,
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