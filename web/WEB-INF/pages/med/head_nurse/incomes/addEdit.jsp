<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
  .required {color:red;}
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<div class="panel panel-info" style="width: 80%; margin: auto">
  <div class="panel-heading">
    Реквизиты акта
    <button  class="btn btn-sm" onclick="setPage('/head_nurse/incomes.s')" style="float:right;margin-top:-5px; margin-left:10px"><i class="fa fa-backward"></i> Назад</button>
    <c:if test="${obj.id > 0 && obj.state == 'ENT'}">
      <button  class="btn btn-sm btn-info" onclick="confirmIncome()" style="float:right;margin-top:-5px; margin-left:10px"><i class="fa fa-check"></i> Подтвердить</button>
    </c:if>
    <c:if test="${obj.id == 0 || obj.state == 'ENT'}">
      <button  class="btn btn-sm btn-success" onclick="saveAct()" style="float:right;margin-top:-5px"><i class="fa fa-save"></i> Сохранить</button>
    </c:if>
  </div>
  <div class="panel-body">
    <form id="addEditForm" style="padding:5px">
      <input type="hidden" name="id" value="${obj.id}">
      <table class="table table-bordered" style="width:100%; margin:auto;">
        <tr>
          <td style="text-align:right;font-weight:bold;vertical-align: middle">Рег № <i class="required">*</i>:</td>
          <td>
            <input type="text" class="form-control center" id="write_off_reg_num" name="reg_num" value="${obj.regNum}"/>
          </td>
          <td style="text-align:right;font-weight:bold;vertical-align: middle">Рег дата <i class="required">*</i>:</td>
          <td>
            <input type="text" readonly style="width:80px; text-align: center" class="form-control" name="reg_date" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.regDate}"/>"/>
            <%--<input type="text" class="form-control datepicker" name="reg_date" id="reg_date" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.regDate}"/>"/>--%>
          </td>
        </tr>
        <tr>
          <td style="text-align:right;font-weight:bold;vertical-align: middle">Получатель <i class="required">*</i>:</td>
          <td colspan="3">
            <select class="form-control" required name="direction" id="write_off_direction">
              <c:forEach items="${directions}" var="cc">
                <option <c:if test="${obj.direction.id == cc.direction.id}">selected</c:if> value="${cc.direction.id}">${cc.direction.name}</option>
              </c:forEach>
            </select>
          </td>
        </tr>
        <tr>
          <td style="text-align:right;font-weight:bold;vertical-align: middle">Дополнительная информация:</td>
          <td colspan="3">
            <textarea name="info" class="form-control">${obj.info}</textarea>
          </td>
        </tr>
      </table>
    </form>
  </div>
  <!-- /.panel-body -->
</div>
<c:if test="${obj.id > 0 && obj.state == 'ENT'}">
  <div class="panel panel-info" style="width: 80%; margin: auto">
    <div class="panel-heading">
      Новая запись
    </div>
    <div class="panel-body">
      <form id="addEditFormRow" style="padding:5px">
        <input type="hidden" name="doc" value="${obj.id}"/>
        <table class="table table-bordered" style="width:100%; margin:auto">
          <tr>
            <td align="right">Препарат: </td>
            <td>
              <select class="form-control chzn-select" style="width:100%" required name="drug_id" onchange="setDrugCount(this)">
                <option></option>
                <c:forEach items="${drugs}" var="cc">
                  <option value="${cc.id}">${cc.name}</option>
                </c:forEach>
              </select>
            </td>
            <td align="right">Количество: </td>
            <td style="width:100px"><input type="number" id="drug_count" disabled name="drug_count" class="form-control center"></td>
            <td>
              Ед. изм.
            </td>
            <td>
              <select class="form-control" style="width:100%" required name="measure_id">
                <option></option>
                <c:forEach items="${measures}" var="cc">
                  <option value="${cc.id}">${cc.name}</option>
                </c:forEach>
              </select>
            </td>
          </tr>
        </table>
      </form>
      <div style="text-align:center; padding-top:10px; margin-top:10px; border-top:1px solid #ababab">
        <button  class="btn btn-sm btn-success" onclick="saveActRow()"><i class="fa fa-save"></i> Сохранить</button>
      </div>
    </div>
  <!-- /.panel-body -->
  </div>
</c:if>
<c:if test="${fn:length(rows) > 0}">
  <div class="panel panel-info" style="width: 80%; margin: auto">
    <div class="panel-heading">
      Записи
    </div>
    <div class="panel-body">
      <table class="table miniGrid">
        <thead>
          <tr>
            <th>Наименование</th>
            <th>Количество заявки</th>
            <th>Ед. изм.</th>
            <th>Получено</th>
            <c:if test="${obj.state == 'ENT'}">
              <th>Удалить</th>
            </c:if>
          </tr>
        </thead>
        <tbody>
          <c:forEach items="${rows}" var="row" varStatus="loop">
            <tr>
              <td>${row.drug.name}</td>
              <td style="width:150px; text-align:right"><fmt:formatNumber value = "${row.claimCount}" type = "number"/></td>
              <td style="width:150px;">${row.measure.name}</td>
              <td style="width:150px; text-align:center"><fmt:formatNumber value = "${row.drugCount == null ? 0 : row.drugCount}" type = "number"/></td>
              <c:if test="${obj.state == 'ENT'}">
                <td style="width:30px;text-align: center">
                  <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delActRow(${row.id})"><span class="fa fa-minus"></span></button>
                </td>
              </c:if>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
    <!-- /.panel-body -->
  </div>
</c:if>
<c:if test="${obj.state == 'CON' && fn:length(rows) > 0}">
  <div class="panel panel-info" style="width: 80%; margin: auto">
    <div class="panel-heading">
      Распаковка
      <button  class="btn btn-sm btn-info" onclick="updateDrop()" style="float:right;margin-top:-5px; margin-left:10px"><i class="fa fa-refresh"></i> Распаковка</button>
    </div>
    <div class="panel-body">
      <table class="table miniGrid">
        <thead>
        <tr>
          <th>#</th>
          <th>Наименование</th>
          <th>Получено</th>
          <th>Количественный учет</th>
          <th>Итого</th>
          <th>Ед. изм.</th>
          <th>#</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${drops}" var="row" varStatus="loop">
          <tr style="<c:if test="${!row.active}">color:red; font-weight: bold</c:if> ">
            <td class="center" style="width:40px">
              <c:if test="${fn:length(row.list) > 1}">
                <button title="Создать новую запись" onclick="copyRow(${row.id}, ${loop.index})" class="btn btn-success btn-sm" style="height:24px; padding:3px 5px;"><b class="fa fa-plus"></b></button>
              </c:if>
            </td>
            <td id="drug_name_${loop.index}">
                ${row.name}
            </td>
            <td style="width:150px; text-align:center">
              <input class="form-control right" type="number" value="${row.claimCount}" id="drug_count_${loop.index}" disabled/>
            </td>
            <td style="width: 250px" class="center">
              <c:if test="${fn:length(row.list) > 1}">
                <select class="form-control" id="drug_counter_${row.id}">
                  <c:forEach items="${row.list}" var="ds" varStatus="loop">
                    <option <c:if test="${ds.ib == row.extraId}">selected</c:if> value="${ds.ib}">${ds.c1} - ${ds.c3}</option>
                  </c:forEach>
                </select>
              </c:if>
              <c:if test="${!(fn:length(row.list) > 1)}">
                ${row.list[0].c1} - ${row.list[0].c3}
              </c:if>
            </td>
            <td style="width:150px" class="right">
              <c:if test="${!row.active}">Выбор</c:if>
              <fmt:formatNumber value = "${row.drugCount}" type = "number"/>
            </td>
            <td style="width:80px">
              ${row.fio}
            </td>
            <td class="center" style="width:40px">
              <c:if test="${fn:length(row.list) > 1}">
                <button title="Сохранить" onclick="saveRow(${row.id})" class="btn btn-success btn-sm" style="height:24px; padding:3px 5px;"><b class="fa fa-check"></b></button>
              </c:if>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
    <!-- /.panel-body -->
  </div>
</c:if>
<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel">Разделение препарата</h4>
      </div>
      <div class="modal-body">
        <div class="center" style="margin-bottom:10px">
          <h3 id="drug_name" style="margin:auto"></h3>
        </div>
        <form id="addEditForms" name="addEditForms">
          <input type="hidden" name="id" id="fact_id" value=""/>
          <table class="table table-bordered">
            <tr>
              <td class="right bold">Кол-во:</td>
              <td>
                <input type="text" disabled id="fact_count" class="form-control right" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Кол-во для разделения*:</td>
              <td>
                <input type="number" id="drop_count" class="form-control right" name="drug_count" onchange="setDropCount(this)" value="0"/>
              </td>
            </tr>
          </table>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" onclick="saveLineDrop()">Сохранить</button>
        <button type="button" class="btn btn-default" id="close-modal" data-dismiss="modal">Закрыть</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<script>
  function saveAct() {
    if($('#write_off_reg_num').val() == '' || $('#reg_date').val() == '' || !($('#write_off_direction').val() > 0)) {
      alert('Не заполнены обязательные поля');
      return;
    }
    $.ajax({
      url: '/head_nurse/incomes/save.s',
      method: 'post',
      data: $('#addEditForm').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert("<ui:message code="successSave"/>");
          setPage('/head_nurse/incomes/save.s?id=' + res.id);
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function saveActRow() {
    if(parseFloat($('#drug_count').val()) > 0) {
      $.ajax({
        url: '/head_nurse/incomes/row/save.s',
        method: 'post',
        data: $('#addEditFormRow').serialize(),
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("<ui:message code="successSave"/>");
            setPage('/head_nurse/incomes/save.s?id=${obj.id}');
          } else {
            alert(res.msg);
          }
        }
      });
    } else {
      alert('Не правильный формат данных поле "Количество"');
    }
  }
  function delActRow(id) {
    if(confirm('Вы действительно хотите удалить выбранную запись?')) {
      $.ajax({
        url: '/head_nurse/incomes/row/del.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("<ui:message code="successSave"/>");
            setPage('/head_nurse/incomes/save.s?id=${obj.id}');
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
  function setDrugCount(dom) {
    $('#drug_count').attr('disabled', !(dom.value > 0));
  }
  function confirmIncome() {
    if(confirm('Вы действительно хотите подтвердить заявку?')) {
      $.ajax({
        url: '/head_nurse/incomes/confirm.s',
        method: 'post',
        data: 'id=${obj.id}',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("<ui:message code="successSave"/>");
            setPage('/head_nurse/incomes/save.s?id=${obj.id}');
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
  function copyRow(id, idx) {
    $('#modal_window').click();
    $('#fact_id').val(id);
    $('#fact_count').val($('#drug_count_' + idx).val());
    $('#drug_name').html($('#drug_name_' + idx).html());
  }
  function saveLineDrop() {
    var fc = parseFloat($('#fact_count').val());
    var dc = $('#drop_count').val();
    if(dc == null || dc == '' || parseFloat(dc) <= 0 || parseFloat(dc) >= fc) {
      alert('Кол-во для разделения не соответствует требованиям');
      return;
    }
    $.ajax({
      url: '/head_nurse/incomes/row/copy.s',
      data: $('#addEditForms').serialize(),
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('#close-modal').click();
          alert('Данные успешно сохранены');
          setPage('/head_nurse/incomes/save.s?id=${obj.id}');
        } else
          alert(res.msg);
      }
    });
  }
  function setDropCount(dom) {
    var fc = parseFloat($('#fact_count').val());
    if(fc <= parseFloat(dom.value) || parseFloat(dom.value) <= 0) {
      dom.value = 0;
      alert('Кол-во для разделения не может быть меньше 0 или больше кол-во препарата');
    }
  }
  function updateDrop() {
    if(confirm('Вы действительно хотите обновить распаковку?')) {
      $.ajax({
        url: '/head_nurse/incomes/drop.s',
        method: 'post',
        data: 'id=${obj.id}',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("<ui:message code="successSave"/>");
            setPage('/head_nurse/incomes/save.s?id=${obj.id}');
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
  function saveRow(id) {
    $.ajax({
      url: '/head_nurse/incomes/drop/save.s',
      data: 'id=' + id + '&value=' + $('#drug_counter_' + id).val(),
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert('Данные успешно сохранены');
          setPage('/head_nurse/incomes/save.s?id=${obj.id}');
        } else
          alert(res.msg);
      }
    });
  }
  $(function(){
    $(".chzn-select").chosen();
  });
</script>