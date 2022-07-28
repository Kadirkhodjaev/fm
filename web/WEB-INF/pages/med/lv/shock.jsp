<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/js/common.js"></script>
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid2 thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #A6ACAF; cursor: pointer}
  .miniGrid tr.activeRow {background: #D0D3D4}
</style>
<div class="panel panel-info" style="font-size: 13px">
  <div class="panel-heading">Экстренный</div>
  <div class="panel-body">
    <div class="panel panel-info" style="width: 100%; margin: auto; margin-bottom:5px">
      <div class="panel-heading">
        Новая запись
        <button  class="btn btn-sm btn-success" onclick="saveDrugRow()" style="float:right;margin-top:-5px;"><i class="fa fa-save"></i> Сохранить</button>
      </div>
      <div class="panel-body" style="padding:2px!important; font-size: 13px">
        <form id="addEditFormRow" style="padding:5px">
          <input type="hidden" name="parent" value="${obj.id}"/>
          <table class="table table-bordered" style="width:100%; margin:auto">
            <tr>
              <td align="right">Препарат: </td>
              <td>
                <select class="form-control chzn-select" required name="drug" id="saldo_id" onchange="setOutDrug(this)">
                  <option value=""></option>
                  <c:forEach items="${drugs}" var="cc">
                    <option drug-measure="${cc.measure.name}" drug-saldo="${cc.drugCount - cc.rasxod}" value="${cc.id}">${cc.drug.name} (Остаток: ${cc.drugCount - cc.rasxod} ${cc.measure.name})</option>
                  </c:forEach>
                </select>
              </td>
              <td align="right" style="font-size: 13px">Остаток: </td>
              <td style="width:100px">
                <input class="form-control center" type="text" disabled id="drug_saldo" value="">
              </td>
              <td align="right" style="font-size: 13px">Списание: </td>
              <td style="width:100px"><input type="number" id="drug_count" name="drug_count" onchange="checkSaldo(this)" class="form-control center"></td>
            </tr>
          </table>
        </form>
      </div>
      <!-- /.panel-body -->
    </div>
    <div id="patient_drug_rows">
      <table class="table table-bordered miniGrid" style="font-size: 13px">
        <thead>
        <tr>
          <th style="width:50px">№</th>
          <th>Склад</th>
          <th>Наименование</th>
          <th style="width:100px">Расход</th>
          <th style="width:100px">Ед. изм.</th>
          <th>Врач</th>
          <th style="width:100px">Дата и время</th>
          <th style="width:60px">Удалить</th>
        </tr>
        </thead>
        <c:forEach items="${rows}" var="d" varStatus="lp">
          <tr class="hand hover">
            <td align="center">${lp.index + 1}</td>
            <td>${d.hndrug.direction.name}</td>
            <td id="edit_drug_name_${d.id}">${d.drug.name}</td>
            <td align="right">${d.rasxod}</td>
            <td id="edit_drug_measure_${d.id}">${d.hndrug.measure.name}</td>
            <td>${d.crBy.fio}</td>
            <td class="center"><fmt:formatDate pattern = "dd.MM.yyyy HH:mm" value = "${d.crOn}" /></td>
            <td class="center">
              <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delOutPatientRow(${d.id})"><span class="fa fa-minus"></span></button>
            </td>
          </tr>
        </c:forEach>
      </table>
    </div>
  </div>
  </div>
</div>
<script>
  // Новая запись
  function setOutDrug(dom) {
    var saldo = dom.options[dom.selectedIndex].getAttribute('drug-saldo');
    var measure = dom.options[dom.selectedIndex].getAttribute('drug-measure');
    $('#drug_saldo').val(saldo);
    $('#drug_measure').html(measure);
  }
  function checkSaldo(dom) {
    var saldo = parseFloat($('#drug_saldo').val());
    if(dom.value == '' || parseFloat(dom.value) <=0) {
      dom.value = 0;
      alert('Кол-во списании не соответствует требованиям');
      return;
    }
    if(parseFloat(dom.value) > saldo) {
      dom.value = 0;
      alert('Нельзя списать больше остатка');
    }
  }
  function saveDrugRow() {
    var id = $('#saldo_id').val();
    if(id == null || id === '') {
      alert('Препарат не выбран');
      return;
    }
    var count = $('#drug_count').val();
    var saldo = parseFloat($('#drug_saldo').val());
    if(count === '' || parseFloat(count) <=0) {
      alert('Кол-во списании не соответствует требованиям');
      return;
    }
    if(parseFloat(count) > saldo) {
      alert('Нельзя списать больше остатка');
      return;
    }
    $.ajax({
      url: '/lv/shock/row/save.s',
      data: 'id=' + id + '&rasxod=' + count,
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert('Данные успешно сохранены');
          document.location = '/lv/shock.s';
        } else
          alert(res.msg);
      }
    });
  }
  function delOutPatientRow(id) {
    if(confirm('Вы действительно хотите удалить выбранную запись?'))
      $.ajax({
        url: '/lv/shock/row/delete.s',
        data: 'id=' + id,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            document.location = '/lv/shock.s';
          } else
            alert(res.msg);
        }
      });
  }
  $(function() {
    $(".chzn-select").chosen();
  });
</script>
