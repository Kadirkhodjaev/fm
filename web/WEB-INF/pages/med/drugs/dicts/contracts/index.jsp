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
  <div class="panel-heading">
    Реестр договоров
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
          <th>Партнер</th>
          <th>Договор</th>
          <th>Дата начала</th>
          <th>Дата окончания</th>
          <th style="width:40px">Удалить</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${list}" var="obj">
          <tr>
            <td align="center">${obj.id}</td>
            <td align="center">${obj.partner.name}</td>
            <td align="center">
              <a href="#" onclick="editDrugDict(${obj.id}); return false">№${obj.regNum} от <fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.regDate}" /></a>
            </td>
            <td align="center">
              <fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.startDate}" />
            </td>
            <td align="center">
              <fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.endDate}" />
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
        <h4 class="modal-title" id="myModalLabel">Реквизиты препарата</h4>
      </div>
      <div class="modal-body">
        <form id="addEditForm" name="addEditForm">
          <input type="hidden" name="id" value=""/>
          <input type="hidden" name="code" value="contract"/>
          <table class="table table-bordered">
            <tr>
              <td class="right bold">Партнер*:</td>
              <td>
                <select class="form-control" name="partner">
                  <c:forEach items="${partners}" var="partner">
                    <option value="${partner.id}">${partner.name}</option>
                  </c:forEach>
                </select>
              </td>
            </tr>
            <tr>
              <td class="right bold">Рег №*:</td>
              <td>
                <input type="text" id="reg-num" class="form-control" name="reg_num" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Рег дата*:</td>
              <td>
                <input name="reg_date" id="reg-date" type="text" class="form-control datepicker" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Дата начала:</td>
              <td>
                <input name="start_date" id="start-date" type="text" class="form-control datepicker" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Дата окончания:</td>
              <td>
                <input name="end_date" id="end-date" type="text" class="form-control datepicker" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Описание:</td>
              <td>
                <input type="text" class="form-control" name="extra_info" value=""/>
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
      url: '/drugs/dict/get.s',
      method: 'post',
      data: 'code=contract&id=' + id,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('*[name=id]').val(res.id);
          $('*[name=partner]').val(res.partner);
          $('*[name=reg_num]').val(res.reg_num);
          $('*[name=reg_date]').val(res.reg_date);
          $('*[name=start_date]').val(res.start_date);
          $('*[name=end_date]').val(res.end_date);
          $('*[name=extra_info]').val(res.extra_info);
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function saveDrugForm() {
    if($('#reg-num').val() == '' || $('#reg-date').val() == '') {
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
        data: 'code=contract&id=' + id,
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