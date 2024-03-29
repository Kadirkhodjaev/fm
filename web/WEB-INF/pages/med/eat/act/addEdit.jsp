<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<style>
  .form-name {background-color:#d9edf7;padding:8px;color:#31708f;font-weight:bold;}
  .required {color:red;}
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<div class="form-name">
  Реквизиты акта
  <ul class="pagination" style="float:right; margin-top:-5px">
    <c:if test="${obj.state == 'E'}">
      <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="actionDrugAct('confirm')"><i title="Подтвердить" class="fa fa-check"></i> Подтвердить</a></li>
    </c:if>
    <c:if test="${obj.state == 'E'}">
      <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="actionDrugAct('delete')"><i title="Удалить" class="fa fa-remove"></i> Удалить</a></li>
    </c:if>
    <c:if test="${obj.state == 'E' || obj.state == null}">
      <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="saveDrugAct()"><i title="Сохранить" class="fa fa-save"></i> Сохранить</a></li>
    </c:if>
    <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="setPage('/drugs/acts.s')"><i title="Сохранить" class="fa fa-backward"></i> Назад</a></li>
  </ul>
</div>
<form id="addEditForm" style="padding:5px">
  <input type="hidden" name="id" value="${obj.id}">
  <table class="table table-bordered" style="width:700px; margin:auto;">
    <tr>
      <td style="text-align:right;font-weight:bold;vertical-align: middle">Договор: </td>
      <td colspan="3">
        <select class="form-control" name="contract">
          <c:forEach items="${contracts}" var="contract">
            <option <c:if test="${contract.id == obj.contract.id}">selected</c:if> value="${contract.id}">№${contract.regNum} от <fmt:formatDate pattern = "dd.MM.yyyy" value = "${contract.regDate}"/> - ${contract.partner.name}</option>
          </c:forEach>
        </select>
      </td>
    </tr>
    <tr>
      <td style="text-align:right;font-weight:bold;vertical-align: middle">Рег № <i class="required">*</i>:</td>
      <td>
        <input type="text" class="form-control center" name="reg_num" value="${obj.regNum}"/>
      </td>
      <td style="text-align:right;font-weight:bold;vertical-align: middle">Рег дата <i class="required">*</i>:</td>
      <td>
        <input type="text" class="form-control datepicker" name="reg_date" id="reg_date" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.regDate}"/>"/>
      </td>
    </tr>
    <tr>
      <td style="text-align:right;font-weight:bold;vertical-align: middle">Дополнительная информация:</td>
      <td colspan="3">
        <textarea name="extra_info" class="form-control">${obj.extraInfo}</textarea>
      </td>
    </tr>
  </table>
</form>
<c:if test="${obj.state == 'O'}">
  <div class="form-name">
    Новый препарат
    <ul class="pagination" style="float:right; margin-top:-5px">
      <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="addActDrug()"><i title="Сохранить" class="fa fa-save"></i> Сохранить</a></li>
    </ul>
  </div>
  <form id="act-drug-form">
    <input type="hidden" name="act" value="${obj.id}"/>
    <table class="table table-bordered" style="width:99%; margin:5px">
      <tr>
        <td class="right bold">Наименование <i class="required">*</i>:</td>
        <td style="vertical-align: middle">
          <select class="form-control chzn-select" required name="drug">
            <c:forEach items="${drug_names}" var="cc">
              <option value="${cc.id}">${cc.name}</option>
            </c:forEach>
          </select>
          <span data-toggle="modal" data-target="#myModal" class="fa fa-plus hand" title="Добавить новое наименование в реестр" style="position:relative; top:3px"></span>
        </td>
        <td class="bold right">Ед.изм. <i class="required">*</i>:</td>
        <td>
          <select class="form-control" required name="measure">
            <c:forEach items="${measures}" var="cc">
              <option value="${cc.id}">${cc.name}</option>
            </c:forEach>
          </select>
        </td>
        <td class="bold right">Склад <i class="required">*</i>:</td>
        <td>
          <select class="form-control" required name="storage" id="storage-select" onchange="setCupboard()">
            <c:forEach items="${storages}" var="cc">
              <option value="${cc.id}">${cc.name}</option>
            </c:forEach>
          </select>
        </td>
        <td class="bold right">Шкаф <i class="required">*</i>:</td>
        <td>
          <select class="form-control" required name="cupboard" id="cupboard-select"></select>
        </td>
      </tr>
      <tr>
        <td class="bold right">Срок годности с <i class="required">*</i>:</td>
        <td>
          <input type="text" required class="form-control datepicker" id="start_date" name="start_date"/>
        </td>
        <td class="bold right">Срок годности по <i class="required">*</i>:</td>
        <td>
          <input type="text" required class="form-control datepicker" id="end_date" name="end_date"/>
        </td>
        <td class="bold right">Цена <i class="required">*</i>:</td>
        <td>
          <input type="text" required class="form-control right" onblur="removeVergul(this)" name="price"/>
        </td>
        <td class="bold right">Количество <i class="required">*</i>:</td>
        <td>
          <input type="text" required class="form-control center" onblur="removeVergul(this)" name="drug_count"/>
        </td>
      </tr>
    </table>
  </form>
  <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
          <h4 class="modal-title" id="myModalLabel">Реквизиты препарата</h4>
        </div>
        <div class="modal-body">
          <form id="new-drug-form">
            <input type="hidden" name="id" value="" />
            <input type="hidden" name="code" value="drug" />
            <input type="hidden" name="state" value="Y" />
            <table class="table table-bordered">
              <tr>
                <td class="right bold">Кетегория*:</td>
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
                  <input type="text" id="drug-name" class="form-control" name="name" value=""/>
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
</c:if>
<c:if test="${fn:length(drugs) > 0}">
  <div class="form-name">Список препаратов по акту</div>
  <table class="miniGrid table table-striped table-bordered" style="width:99%; margin:5px;">
    <thead>
      <tr>
        <th>Наименование</th>
        <th>Склад</th>
        <th>Шкаф</th>
        <th colspan="2">Срок годность</th>
        <th>Цена</th>
        <th>Кол-во</th>
        <th>Ед. изм.</th>
        <th>Расход</th>
        <th>Остаток</th>
        <th style="width:40px">Удалить</th>
      </tr>
    </thead>
    <c:forEach items="${drugs}" var="drug">
      <tr>
        <td>${drug.drug.name}</td>
        <td class="center">${drug.storage.name}</td>
        <td class="center">${drug.cupboard.name}</td>
        <td class="center"><fmt:formatDate pattern="dd.MM.yyyy" value="${drug.startDate}"/></td>
        <td class="center"><fmt:formatDate pattern="dd.MM.yyyy" value="${drug.endDate}"/></td>
        <td class="right">${drug.price}</td>
        <td class="right">${drug.drugCount}</td>
        <td>${drug.measure.name}</td>
        <td class="right">${drug.rasxod}</td>
        <td class="right">${drug.counter - drug.rasxod}</td>
        <td class="center">
          <c:if test="${drug.rasxod == 0}">
            <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delActDrug(${drug.id})"><i class="fa fa-minus"></i></button>
          </c:if>
        </td>
      </tr>
    </c:forEach>
  </table>
</c:if>
<script>
  const cupboards = [];
  <c:forEach items="${cupboards}" var="cupboard">
    cupboards.push({id:${cupboard.id}, name:'${cupboard.name}', storage:${cupboard.storage.id}});
  </c:forEach>
  function saveDrugAct(){
    if($('#reg_num').val() == '' || $('#reg_date').val() == '') {
      alert('Заполните все обязательные поля');
      return;
    }
    $.ajax({
      url: '/drugs/act/addEdit.s',
      method: 'post',
      data: $('#addEditForm').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert("<ui:message code="successSave"/>");
          setPage('/drugs/act/addEdit.s?id=' + res.id);
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function actionDrugAct(action) {
    if(confirm('Подтверждаете данное действие?')) {
      $.ajax({
        url: '/drugs/act/action.s',
        method: 'post',
        data: 'code=' + action + '&id=${obj.id}',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("<ui:message code="successSave"/>");
            if(action == 'confirm') {
              setPage('/drugs/act/addEdit.s?id=' + res.id);
            } else {
              setPage('/drugs/acts.s');
            }
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
  function setCupboard(){
    const dom = document.getElementById('storage-select');
    $("#cupboard-select").empty();
    for(const cupboard of cupboards) {
      if(cupboard.storage === parseInt(dom.value)) {
        $("#cupboard-select").append('<option value="' + cupboard.id + '">' + cupboard.name + '</option>');
      }
    }
  }
  function addActDrug(){
    var isOk = true;
    $('#act-drug-form').find('input, select').each(function(idx, elem){
      if(elem.name !== '' && elem.hasAttribute('required') && elem.value === '') {
        alert('Заполните все обязательные поля');
        isOk = false;
        return false;
      }
    });
    if(isOk) {
      $.ajax({
        url: '/drugs/act/drug/save.s',
        method: 'post',
        data: $('#act-drug-form').serialize(),
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("<ui:message code="successSave"/>");
            setPage('/drugs/act/addEdit.s?id=${obj.id}');
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
  function delActDrug(id){
    $.ajax({
      url: '/drugs/act/drug/delete.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert("<ui:message code="successSave"/>");
          setPage('/drugs/act/addEdit.s?id=${obj.id}');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function removeVergul(dom){
    dom.value.replace(',', '.');
  }
  function saveDrugForm() {
    if($('#drug-name').val() == '') {
      alert('Наименование не может быть пустым');
      return;
    }
    $.ajax({
      url: '/drugs/dict/save.s',
      method: 'post',
      data: $('#new-drug-form').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('select[name=drug]').each(function (elem, dom) {
            var options = dom.options;
            dom.options[options.length] = new Option(res.name, res.id);
            $(this).val(res.id);
            $(this).trigger('liszt:updated');
            document.getElementById("close-modal").click();
          });
          document.getElementById('new-drug-form').reset();
        } else {
          alert(res.msg);
        }
      }
    });
  }
  $(function(){
    $(".chzn-select").chosen();
    <c:if test="${obj.id > 0 && obj.state == 'O'}">
      setCupboard();
    </c:if>
  });
</script>
