<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<div class="panel panel-info" style="width: 80%; margin: auto">
  <div class="panel-heading">
    Новая запись
  </div>
  <div class="panel-body">
    <table class="table table-bordered" style="width:100%; margin:auto">
      <tr>
        <td>
          <select class="form-control chzn-select" style="width:100%" required id="drug_id">
            <option></option>
            <c:forEach items="${drugs}" var="cc">
              <option value="${cc.id}">${cc.name}</option>
            </c:forEach>
          </select>
        </td>
        <td class="wpx-40 text-center">
          <button class="btn btn-success btn-icon" onclick="addNorma()"> <i class="fa fa-plus"></i></button>
        </td>
      </tr>
    </table>
  </div>
  <!-- /.panel-body -->
</div>

<div class="panel panel-info" style="width: 80%; margin: auto">
  <div class="panel-heading">
    Записы
  </div>
  <div class="panel-body">
    <table class="table table-bordered" style="width:100%; margin:auto">
      <tr>
        <td class="text-center bold">Наименование</td>
        <td class="text-center bold">Тип</td>
        <td class="text-center bold">Значение</td>
      </tr>
      <c:forEach items="${rows}" var="r">
        <tr class="hover hand" ondblclick="view(${r.id})">
          <td>${r.drug.name}</td>
          <td class="text-center">
            <c:if test="${r.normaType == 'ALL'}">Для всех</c:if>
            <c:if test="${r.normaType == 'MULTI'}">По складам</c:if>
          </td>
          <td class="text-right"><fmt:formatNumber value="${r.norma}" type="number"/></td>
        </tr>
      </c:forEach>
    </table>
  </div>
  <!-- /.panel-body -->
</div>

<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel">Добавление нового норматива</h4>
      </div>
      <div class="modal-body">
        <div class="center" style="margin-bottom:10px">
          <h3 id="drug_name" style="margin:auto"></h3>
        </div>
        <form id="addEditForms" name="addEditForms">
          <input type="hidden" name="id" id="id" value="0"/>
          <input type="hidden" name="drug" id="drug" value=""/>
          <table class="table table-bordered">
            <tr>
              <td class="right bold">Препарат:</td>
              <td>
                <input class="form-control" readonly name="drug_name" value=""/>
              </td>
            </tr>
            <tr>
              <td class="right bold">Тип норматива:</td>
              <td>
                <select class="form-control" name="type" id="norma_type">
                  <option value="ALL">Для всех</option>
                  <option value="MULTI">По складам</option>
                </select>
              </td>
            </tr>
            <c:forEach items="${directions}" var="a">
              <tr>
                <td>${a.name}<input type="hidden" name="ids" value="${a.id}"/></td>
                <td class="text-center">
                  <input type="number" class="form-control right" name="normas" value=""/>
                </td>
              </tr>
            </c:forEach>
            <tr id="ALL_VIEW">
              <td class="right bold">Норма *:</td>
              <td>
                <input type="number" id="norma" class="form-control right" name="norma" value=""/>
              </td>
            </tr>
          </table>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" onclick="saveNorma()">Сохранить</button>
        <button type="button" class="btn btn-default" id="close-modal" data-dismiss="modal">Закрыть</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>

<script>
  function addNorma() {
    let dom = getDOM('drug_id');
    let drug = dom.options[dom.selectedIndex].text;
    let id = dom.options[dom.selectedIndex].value;
    if(drug == null || drug === '') {
      openMedMsg('Препарат не выбран', false);
      return;
    }
    $('#addEditForms').find('*[name=drug_name]').val(drug);
    $('#addEditForms').find('*[name=drug]').val(id);
    getDOM('modal_window').click();
  }
  function saveNorma() {
    if(getDOM('norma_type').value === 'ALL' && (getDOM('norma').value === '' || getDOM('norma').value === '0')) {
      openMedMsg('Нельзя сохранить пустое значение для нормы', false);
      return;
    }
    $.ajax({
      url: '/drugs/dict/drug/norma.s',
      method: 'post',
      data: $('#addEditForms').serialize(),
      dataType: 'json',
      success: function (res) {
        getDOM('close-modal').click();
        openMsg(res);
        setTimeout(() => {
          $('#pager').load('drugs/dict/drug/normas.s');
        }, 500)
      }
    });
  }
  function view() {

  }
  $(function(){
    $(".chzn-select").chosen();
  });
</script>
