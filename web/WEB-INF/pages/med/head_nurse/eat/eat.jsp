<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script>
</script>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading" style="padding:0 10px">
    <table style="margin:0;width:100%">
      <tr>
        <td style="width:70px; font-weight:bold; vertical-align: middle">Заяки</td>
        <td style="width:140px;padding:5px">
          <input name="period_start" id="period_start" type="text" class="form-control datepicker" value="${period_start}"/>
        </td>
        <td style="width:10px;vertical-align: middle">
          -
        </td>
        <td style="width:140px;padding:5px">
          <input name="period_end" id="period_end" type="text" class="form-control datepicker" value="${period_end}"/>
        </td>
        <td style="vertical-align: middle">
          <button onclick="setCashStat()" class="btn btn-success btn-xs">Поиск</button>
        </td>
        <td class="right">
          <button  class="btn btn-xs btn-success" onclick="addEatClaim()" style="float:right;margin-top:-5px"><i class="fa fa-plus"></i> Добавить</button>
        </td>
      </tr>
    </table>
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>Отделение</th>
          <th>Дата</th>
          <th>Тип</th>
          <th>Кол-во пациентов</th>
          <th>Кол-во доп.</th>
          <th>Состояние</th>
          <th style="width:40px">Удалить</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${list}" var="obj">
          <tr ondblclick="setPage('/head_nurse/eat.s?id=${obj.ib}')">
            <td class="center">${obj.c4}</td>
            <td align="center">
              <a href="#" onclick="setPage('/head_nurse/eat.s?id=${obj.ib}'); return false">
                ${obj.date}
              </a>
            </td>
            <td class="center">${obj.fio}</td>
            <td class="center">${obj.c2}</td>
            <td class="center">${obj.c3}</td>
            <td align="center">
              <c:if test="${obj.c1 == 'ENT'}">Введен</c:if>
              <c:if test="${obj.c1 != 'ENT'}">Подтвержден</c:if>
            </td>
            <td class="center">
              <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delClaimRow(${obj.ib})"><i class="fa fa-minus"></i></button>
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

<button data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></button>
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
                <input name="menu_date" required id="menu-date" type="text" class="form-control datepicker" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Отделение *:</td>
              <td>
                <select class="form-control" required name="dept">
                  <c:forEach items="${depts}" var="dept">
                    <option value="${dept.id}">${dept.name}</option>
                  </c:forEach>
                </select>
              </td>
            </tr>
            <tr>
              <td class="right bold">Тип *:</td>
              <td>
                <select class="form-control" required name="menu_type">
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
    if(checkForm($('#addEditForm'))) {
      $.ajax({
        url: '/head_nurse/eat/save.s',
        method: 'post',
        data: $('#addEditForm').serialize(),
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            $('#close-modal').click();
            setPage('/head_nurse/eat.s?id=' + res.id)
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
  function delClaimRow(id) {
    if(confirm('Дейтвительно хотите удалить?')) {
      $.ajax({
        url: '/head_nurse/eat/del.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/head_nurse/eats.s');
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
  function setCashStat(){
    var start = document.getElementById("period_start");
    var end = document.getElementById("period_end");
    setPage('/head_nurse/eats.s?period_start=' + start.value + '&period_end=' + end.value);
  }
</script>
