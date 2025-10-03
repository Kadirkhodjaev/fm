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
    <button  class="btn btn-icon float-right" onclick="setPage('/head_nurse/incomes.s')"><i class="fa fa-backward"></i> Назад</button>
    <c:if test="${(obj.id > 0 && obj.state == 'ENT') && fn:length(rows) > 0}">
      <button  class="btn btn-icon btn-info float-right mr-5" onclick="confirmIncome()"><i class="fa fa-check"></i> Подтвердить</button>
    </c:if>
    <c:if test="${(obj.id == 0 || obj.state == 'ENT') && fn:length(rows) == 0}">
      <button  class="btn btn-icon btn-success float-right mr-5" onclick="saveAct()"><i class="fa fa-save"></i> Сохранить</button>
    </c:if>
  </div>
  <div class="panel-body">
    <form id="addEditForm" style="padding:5px">
      <input type="hidden" name="id" value="${obj.id}">
      <table class="table table-bordered" style="width:100%; margin:auto;">
        <tr>
          <td style="text-align:right;font-weight:bold;vertical-align: middle">Рег № <i class="required">*</i>:</td>
          <td>
            <input type="text" class="form-control center" id="out_reg_num" name="reg_num" value="${obj.regNum}"/>
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
            <select class="form-control" required name="direction" id="out_direction">
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
      <button  class="btn btn-icon btn-success float-right" onclick="saveActRow()"><i class="fa fa-save"></i> Сохранить</button>
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
                  <option value="${cc.id}" measure="${cc.measure.name}">${cc.name}</option>
                </c:forEach>
              </select>
            </td>
            <td align="right">Количество: </td>
            <td style="width:100px"><input type="number" id="drug_count" disabled name="drug_count" class="form-control center"></td>
            <td>
              Ед. изм.
            </td>
            <td>
              <input class="form-control" disabled id="measure" value=""/>
            </td>
          </tr>
        </table>
      </form>
    </div>
  <!-- /.panel-body -->
  </div>
</c:if>
<c:if test="${fn:length(rows) > 0}">
  <div class="panel panel-info" style="width: 80%; margin: auto">
    <div class="panel-heading">
      Записи
      <c:if test="${obj.state == 'CON' && fn:length(rows) > 0 && obj.insFlag != 'Y'}">
        <button  class="btn btn-sm btn-info" onclick="updateDrop()" style="float:right;margin-top:-5px; margin-left:10px"><i class="fa fa-check"></i> Принять на склад</button>
      </c:if>
    </div>
    <div class="panel-body">
      <table class="table miniGrid">
        <thead>
          <tr>
            <th style="width:30px">#</th>
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
              <td class="center">
                <c:if test="${row.hndrug != null && row.hndrug > 0}">
                  <img src="/res/imgs/green.gif">
                </c:if>
                <c:if test="${!(row.hndrug != null && row.hndrug > 0)}">
                  <img src="/res/imgs/red.gif">
                </c:if>
              </td>
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
<script>
  let measures = [];
  <c:forEach items="${measures}" var="m">
    measures.push({drug: ${m.drug}, id: ${m.measure.id}, name: '${m.measure.name}'});
  </c:forEach>
  function saveAct() {
    if($('#out_reg_num').val() == '' || $('#reg_date').val() == '' || !($('#out_direction').val() > 0)) {
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
    let mn = dom.options[dom.selectedIndex].getAttribute("measure");
    $('#measure').val(mn);
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
    if(confirm('Вы действительно хотите принять данный приход на склад?')) {
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
