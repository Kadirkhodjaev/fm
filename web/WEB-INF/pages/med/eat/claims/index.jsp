<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script>
</script>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Заявки по пациентам
    <button  class="btn btn-sm btn-success" onclick="addEatClaim()" style="float:right;margin-top:-5px"><i class="fa fa-plus"></i> Добавить</button>
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>Дата</th>
          <th>Тип</th>
          <th>Состояние</th>
          <th style="width:40px">Удалить</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${list}" var="obj">
          <tr ondblclick="setPage('/eats/claim.s?id=${obj.id}')">
            <td align="center">
              <a href="#" onclick="setPage('/eats/claim.s?id=${obj.id}'); return false">
                <fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.menu.menuDate}" />
              </a>
            </td>
            <td>
              ${obj.menuType.name}
            </td>
            <td align="center">
              <c:if test="${obj.state == 'ENT'}">Введен</c:if>
              <c:if test="${obj.state != 'ENT'}">Подтвержден</c:if>
            </td>
            <td class="center">
              <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delClaimRow(${obj.id})"><i class="fa fa-minus"></i></button>
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
        <h4 class="modal-title" id="myModalLabel">Сформировать заявку</h4>
      </div>
      <div class="modal-body">
        <form id="addEditForm" name="addEditForm">
          <table class="table table-bordered">
            <tr>
              <td class="right bold">Меню *:</td>
              <td>
                <select class="form-control" name="menu">
                  <c:forEach items="${eatMenus}" var="eatMenu">
                    <option value="${eatMenu.id}"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${eatMenu.menuDate}" /></option>
                  </c:forEach>
                </select>
              </td>
            </tr>
            <tr>
              <td class="right bold">Тип *:</td>
              <td>
                <select class="form-control" name="menu_type">
                  <c:forEach items="${menuTypes}" var="menuType">
                    <option value="${menuType.id}">${menuType.name}</option>
                  </c:forEach>
                </select>
              </td>
            </tr>
          </table>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" onclick="saveEatForm()">Выполнить</button>
        <button type="button" class="btn btn-default" id="close-modal" data-dismiss="modal">Закрыть</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<script>
  function addEatClaim(){
    addEditForm.reset();
    document.getElementById("modal_window").click();
  }
  function saveEatForm() {
    var menu = $('#addEditForm').find('*[name=menu]').val();
    var type = $('#addEditForm').find('*[name=menu_type]').val();
    if(menu == null || menu === '' || type == null || type === '') {
      alert('Все поля должны быть заполнеными');
      return;
    }
    $.ajax({
      url: '/eats/claims/check.s',
      method: 'post',
      data: 'menu=' + $('#addEditForm').find('*[name=menu]').val() + '&menu_type=' + $('#addEditForm').find('*[name=menu_type]').val(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('#close-modal').click();
          setPage('/eats/claim.s?menu=' + $('#addEditForm').find('*[name=menu]').val() + '&menu_type=' + $('#addEditForm').find('*[name=menu_type]').val())
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function delClaimRow(id) {
    if(confirm('Дейтвительно хотите удалить?')) {
      $.ajax({
        url: '/eats/claim/del.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/eats/claims.s');
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
</script>