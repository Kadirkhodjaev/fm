<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
  .miniGrid tr.activeRow {background: #D0D3D4}
</style>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script>
</script>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    <table style="width:100%">
      <tr>
        <td>Реестр препаратов</td>
        <td class="right">Категория: </td>
        <td style="width:200px">
          <select class="form-control" onchange="setPageCat(this)">
            <option <c:if test="${ct == 'A'}">selected</c:if> value="A">Активный</option>
            <option <c:if test="${ct == 'P'}">selected</c:if> value="P">Пассивный</option>
          </select>
        </td>
        <td style="width:110px">
          <button  class="btn btn-sm btn-success" onclick="addDrugDict()" style="float:right;margin-top:-5px"><i class="fa fa-plus"></i> Добавить</button>
        </td>
      </tr>
    </table>
  </div>
  <div class="panel-body">
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>#</th>
          <th>Наименование</th>
          <th>Состояние</th>
          <th>Детализация</th>
          <th style="width:40px">Удалить</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${drugs}" var="d">
          <tr class="" <c:if test="${d.counter == null || d.counter == 0}">title="Не корректная настройка кол-во учета" style="color:red"</c:if> id="row_${d.id}" ondblclick="editDrugDict(${d.id})" onclick="setRow(${d.id})">
            <td align="center">${d.id}</td>
            <td id="row_drug_name_${d.id}">${d.name}</td>
            <td align="center">
              <c:if test="${d.state == 'A'}">Активный</c:if>
              <c:if test="${d.state != 'A'}">Пассивный</c:if>
            </td>
            <td class="center" width="100px">
              <button class="btn btn-success btn-sm" style="height:20px;padding:1px 10px" title="Детализация по приходам" onclick="viewDrug(${d.id})"><i class="fa fa-list"></i></button>
            </td>
            <td class="center">
              <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delDrugRow(${d.id})"><i class="fa fa-minus"></i></button>
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
          <input type="hidden" name="id" value="" />
          <input type="hidden" name="code" value="drug" />
          <table class="table table-bordered">
            <tr>
              <td class="right bold">Наименование*:</td>
              <td>
                <input type="text" id="drug-name" class="form-control" name="name" value=""/>
              </td>
            </tr>
            <tr>
              <td colspan="2" class="bold center">Категории</td>
            </tr>
            <c:forEach items="${categories}" var="category">
              <tr>
                <td class="right">
                  <input type="checkbox" class="cat_checkbox" value="${category.id}" id="cat_${category.id}" name="cats"/>
                </td>
                <td>${category.name}</td>
              </tr>
            </c:forEach>
            <tr>
              <td class="right bold">Активный?:</td>
              <td class="left">
                <input type="checkbox" checked name="state" value="Y"/>
              </td>
            </tr>
            <tr>
              <td>Кол-во учет: </td>
              <td>
                <input type="number" class="form-control center" name="counter" value="">
              </td>
              <td></td>
            </tr>
            <tr>
              <td>Ед. изм.: </td>
              <td>
                <select class="form-control" name="measure">
                  <c:forEach items="${measures}" var="measure">
                    <option value="${measure.id}">${measure.name}</option>
                  </c:forEach>
                </select>
              </td>
              <td></td>
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

<a href="#" data-toggle="modal" data-target="#newModal" id="new_modal_window" class="hidden"></a>
<div class="modal fade" id="newModal" tabindex="-1" role="dialog" aria-labelledby="newModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog" style="width:1200px">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="newModalLabel">Препарат: <span id="modal_drug_name"></span></h4>
      </div>
      <div class="modal-body" id="drug_details"></div>
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
      data: 'code=drug&id=' + id,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('#table_counter').find('tbody').html('');
          $('*[name=id]').val(res.id);
          $('*[name=category]').val(res.category);
          $('*[name=name]').val(res.name);
          $('*[name=counter]').val(res.counter);
          $('*[name=measure]').val(res.measure);
          $('*[name=state]').prop('checked', res.state == 'A');
          var elems = document.getElementsByClassName("cat_checkbox");
          for(var elem of elems) elem.checked = false;
          for(var obj of res.cats) document.getElementById("cat_" + obj).checked = true;
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function saveDrugForm() {
    if($('#drug-name').val() == '') {
      alert('Наименование не может быть пустым');
      return;
    }
    if($('#default_count').val() == '') {
      alert('Кол-во не может быть пустым');
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
        data: 'code=drug&id=' + id,
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
  function viewDrug(id) {
    $('#modal_drug_name').html($('#row_drug_name_' + id).html());
    $('#drug_details').load('/drugs/dict/drug/incomes.s?id=' + id, () => {
      document.getElementById('new_modal_window').click();
    });
  }
  function setRow(id) {
    $('tr.activeRow').removeClass('activeRow');
    $('#row_' + id).addClass('activeRow');
    localStorage.setItem('drug_idx', id);

  }
  function setPageCat(dom) {
    setPage('/drugs/dicts.s?cat=' + dom.value);
  }
  $(function() {
    var curRow = localStorage.getItem('drug_idx') > 0 ? localStorage.getItem('drug_idx') : 1;
    $('#mainWindow').animate({ scrollTop: $('#row_' + curRow).offset().top - 450}, 300);
    setRow(curRow);
  });
</script>
