<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<style>
  .miniGrid thead tr th {text-align: center;background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5;cursor: pointer}
</style>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Меню
    <button class="btn btn-sm btn-success" onclick="newEatMenu()" style="float:right;margin-top:-5px"><i class="fa fa-plus"></i> Добавить</button>
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>#</th>
          <th style="width:60px">Детали</th>
          <th>Дата</th>
          <th>Описание</th>
          <th>Состояние</th>
          <th style="width:60px">Удалить</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${menus}" var="obj">
          <tr ondblclick="setPage('/eats/menu/details.s?id=${obj.id}');">
            <td align="center">${obj.id}</td>
            <td class="center">
              <button class="btn btn-success btn-sm" type="button" style="height:20px;padding:1px 10px" onclick="setPage('/eats/menu/details.s?id=${obj.id}');">
                <span class="fa fa-align-justify"></span>
              </button>
            </td>
            <td class="center">
              <c:if test="${obj.state == 'ENT'}">
                <a href="#" onclick="editEatMenu(${obj.id}, '<fmt:formatDate pattern="dd.MM.yyyy" value="${obj.menuDate}"/>', '${obj.info}'); return false"><fmt:formatDate pattern="dd.MM.yyyy" value="${obj.menuDate}"/></a>
              </c:if>
              <c:if test="${obj.state == 'CON'}">
                <fmt:formatDate pattern="dd.MM.yyyy" value="${obj.menuDate}"/>
              </c:if>
            </td>
            <td>
              ${obj.info}
            </td>
            <td align="center">
              <c:if test="${obj.state == 'ENT'}">Введен</c:if>
              <c:if test="${obj.state == 'CON'}">Подтвержден</c:if>
            </td>
            <td class="center">
              <c:if test="${obj.state == 'ENT'}">
                <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delMenuRow(${obj.id})"><i class="fa fa-minus"></i></button>
              </c:if>
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
        <h4 class="modal-title" id="myModalLabel">Реквизиты препарата</h4>
      </div>
      <div class="modal-body">
        <form id="addEditForm" name="addEditForm">
          <input type="hidden" name="id" value=""/>
          <table class="table table-bordered">
            <tr>
              <td class="right bold">Дата *:</td>
              <td>
                <input name="menu_date" id="menu-date" type="text" class="form-control datepicker" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Описание:</td>
              <td>
                <input type="text" class="form-control" name="extra_info" maxlength="256" value=""/>
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
  function newEatMenu() {
    addEditForm.reset();
    $('#menu-date').val('${curDate}');
    document.getElementById('modal_window').click()
  }
  function saveEatForm() {
    if($('#menu-date').val() == '') {
      alert('Дата не может быть пустым');
      return;
    }
    $.ajax({
      url: '/eats/menu/save.s',
      method: 'post',
      data: $('#addEditForm').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert("<ui:message code="successSave"/>");
          $('#close-modal').click();
          setPage('/eats/menu.s');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function editEatMenu(id, date, info) {
    addEditForm.reset();
    $('*[name=id]').val(id);
    $('*[name=menu_date]').val(date);
    $('*[name=extra_info]').val(info);
    document.getElementById('modal_window').click()
  }
  function delMenuRow(id) {
    if(confirm('Вы действительно хотите удалить')) {
      $.ajax({
        url: '/eats/menu/del.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("<ui:message code="successSave"/>");
            setPage('/eats/menu.s');
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
</script>