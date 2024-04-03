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
  <table class="table table-bordered" style="width:100%; margin:auto;">
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
        <input type="text" class="form-control" style="width:80px; text-align: center" readonly name="reg_date" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.regDate}"/>"/>
        <%--<input type="text" class="form-control datepicker" name="reg_date" id="reg_date" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.regDate}"/>"/>--%>
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
<c:if test="${obj.state == 'E'}">
  <div class="form-name">
    Новый препарат
    <ul class="pagination" style="float:right; margin-top:-5px">
      <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="addActDrug()"><i title="Сохранить" class="fa fa-save"></i> Сохранить</a></li>
    </ul>
  </div>
  <form id="act-drug-form">
    <input type="hidden" name="act" value="${obj.id}"/>
    <table class="table table-bordered miniGrid" style="width:99%; margin:5px">
      <thead>
        <tr>
          <th>Наименование</th>
          <th>Производитель</th>
          <th style="width:140px">Срок годности</th>
          <th>Цена</th>
          <th>Количество</th>
          <th>Кол-во единиц</th>
          <th>Цена за единицу</th>
          <th>С НДС</th>
        </tr>
      </thead>
      <tr>
        <td style="vertical-align: middle" nowrap>
          <select class="form-control chzn-select" required name="drug" id="selected_drug_id" onchange="setDrugName(this)">
            <option></option>
            <c:forEach items="${drug_names}" var="cc">
              <option value="${cc.id}" counter="${cc.counter}" measure="${cc.measure.name}">${cc.name} (Кол-во учет: ${cc.counter}; ед.изм.: ${cc.measure.name})</option>
            </c:forEach>
          </select>
          <span data-toggle="modal" data-target="#myModal" class="fa fa-plus hand" title="Добавить новое наименование в реестр" style="position:relative; top:3px"></span>
        </td>
        <td style="vertical-align: middle" nowrap>
          <select class="form-control chzn-select" required name="man">
            <option></option>
            <c:forEach items="${mans}" var="cc">
              <option value="${cc.id}">${cc.name}</option>
            </c:forEach>
          </select>
          <span data-toggle="modal" data-target="#myModal1" class="fa fa-plus hand" title="Добавить новое наименование в реестр" style="position:relative; top:3px"></span>
        </td>
        <td>
          <input type="text" required class="form-control datepicker" id="end_date" name="end_date"/>
        </td>
        <td>
          <input type="number" required class="form-control right" onblur="removeVergul(this, 'price')" id="drug_price" name="price" disabled />
        </td>
        <td>
          <input type="number" required class="form-control center" onblur="removeVergul(this, 'block_count')" id="block_count" name="block_count" disabled />
        </td>
        <td>
          <input type="number" required class="form-control right" onblur="removeVergul(this, 'counter')" id="counter" name="counter" disabled/>
        </td>
        <td>
          <input type="number" required class="form-control right" id="one_price" value="" name="one_price" disabled/>
        </td>
        <td>
          <input type="number" required class="form-control right" onblur="removeVergul(this, 'nds')" id="nds" name="nds" disabled />
        </td>
        <td id="drug_default_count" class="center"></td>
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
  <div class="modal fade" id="myModal1" tabindex="-1" role="dialog" aria-labelledby="myModal1Label" aria-hidden="true" style="display: none;">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
          <h4 class="modal-title" id="myModal1Label">Реквизиты производителя</h4>
        </div>
        <div class="modal-body">
          <form id="new-man-form">
            <input type="hidden" name="id" value="" />
            <input type="hidden" name="code" value="manufacturer" />
            <input type="hidden" name="state" value="Y" />
            <table class="table table-bordered">
              <tr>
                <td class="right bold">Наименование*:</td>
                <td>
                  <input type="text" id="man-name" class="form-control" name="name" value=""/>
                </td>
              </tr>
            </table>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary" onclick="saveManForm()">Сохранить</button>
          <button type="button" class="btn btn-default" id="close-modal1" data-dismiss="modal">Закрыть</button>
        </div>
      </div>
      <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
  </div>
</c:if>
<c:if test="${fn:length(drugs) > 0}">
  <div class="form-name">Список препаратов по акту на сумму: <span style="color: red"><fmt:formatNumber value="${drug_total_sum}" type = "number"/> сум</span></div>
  <table class="miniGrid table table-striped table-bordered" style="width:99%; margin:5px;">
    <thead>
      <tr>
        <th>Наименование</th>
        <th>Производитель</th>
        <th>Срок годность</th>
        <th>Цена</th>
        <th>Кол-во</th>
        <th>Сумма прихода</th>
        <th>Кол-во единиц</th>
        <th>Цена за единицу</th>
        <th>С НДС</th>
        <th>Расход</th>
        <th>Остаток</th>
        <th>Ед.изм.</th>
        <c:if test="${obj.state == 'E'}">
          <th style="width:40px">Удалить</th>
        </c:if>
      </tr>
    </thead>
    <c:forEach items="${drugs}" var="drug">
      <tr title="Цена за ед.: ${drug.countPrice}">
        <td>
          <c:if test="${drug.rasxod == 0}">
            <a href="#" onclick="editDrug(this, '${drug.id}','${drug.price}', '${drug.blockCount}', '${drug.countPrice}', '${drug.counter}')">${drug.drug.name} (Кол-во учет: ${drug.drug.counter} Ед.изм.: ${drug.measure.name})</a>
          </c:if>
          <c:if test="${drug.rasxod != 0}">
            ${drug.drug.name} (Кол-во учет: ${drug.drug.counter} Ед.изм.: ${drug.measure.name})
          </c:if>
        </td>
        <td>${drug.manufacturer.name}</td>
        <td class="center"><fmt:formatDate pattern="dd.MM.yyyy" value="${drug.endDate}"/></td>
        <td class="right"><fmt:formatNumber value="${drug.price}" type = "number"/></td>
        <td class="right"><fmt:formatNumber value="${drug.blockCount}" type = "number"/></td>
        <td class="right"><fmt:formatNumber value="${drug.blockCount * drug.price}" type = "number"/></td>
        <td class="right"><fmt:formatNumber value="${drug.counter}" type = "number"/></td>
        <td class="right"><fmt:formatNumber value="${drug.countPrice}" type = "number"/></td>
        <td class="right"><fmt:formatNumber value="${drug.countPrice + drug.ndsSum}" type = "number"/></td>
        <td class="right"><fmt:formatNumber value="${drug.rasxod}" type = "number"/></td>
        <td class="right"><fmt:formatNumber value="${drug.counter - drug.rasxod}" type = "number"/></td>
        <td class="left">${drug.measure.name}</td>
        <c:if test="${obj.state == 'E'}">
          <td class="center">
            <c:if test="${drug.rasxod == 0}">
              <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delActDrug(${drug.id})"><i class="fa fa-minus"></i></button>
            </c:if>
          </td>
        </c:if>
      </tr>
    </c:forEach>
  </table>
  <a href="#" data-toggle="modal" data-target="#editDrugModal" id="edit_drug" class="hidden"></a>
  <div class="modal fade" tabindex="-1" id="editDrugModal" role="dialog" aria-labelledby="modalLabel" aria-hidden="true" style="display: none;">
    <div class="modal-dialog" style="width:1000px">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
          <h4 class="modal-title" id="modalLabel">Реквизиты препарата: <span id="edit_drug_name"></span></h4>
        </div>
        <div class="modal-body">
          <form id="editDrugForm" name="editDrugForm">
            <input type="hidden" name="id" value="" />
            <table class="table table-bordered">
              <tr>
                <td class="right bold">Стоимость блока*:</td>
                <td>
                  <input type="number" class="form-control" required name="price_block" value=""/>
                </td>
              </tr>
              <tr>
                <td class="right bold">Кол-во блоков*:</td>
                <td>
                  <input type="number" class="form-control" required name="count_block" value=""/>
                </td>
              </tr>
              <tr>
                <td class="right bold">Стоимость единицы*:</td>
                <td>
                  <input type="number" class="form-control" required name="price_drug" value=""/>
                </td>
              </tr>
              <tr>
                <td class="right bold">Кол-во единиц*:</td>
                <td>
                  <input type="number" class="form-control" required name="count_drug" value=""/>
                </td>
              </tr>
            </table>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary" onclick="save_editDrug()">Сохранить</button>
          <button type="button" class="btn btn-default" id="edit-drug-close" data-dismiss="modal">Закрыть</button>
        </div>
      </div>
      <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
  </div>
</c:if>
<script>
  const cupboards = [];
  <c:forEach items="${cupboards}" var="cupboard">
    cupboards.push({id:${cupboard.id}, name:'${cupboard.name}', storage:${cupboard.storage.id}});
  </c:forEach>

  function editDrug(dom, id, price_block, count_block, price_drug, count_drug) {
    $('#edit_drug_name').html($(dom).html());
    $('#editDrugForm input[name=id]').val(id);
    $('#editDrugForm input[name=price_block]').val(price_block);
    $('#editDrugForm input[name=count_block]').val(count_block);
    $('#editDrugForm input[name=price_drug]').val(price_drug);
    $('#editDrugForm input[name=count_drug]').val(count_drug);
    $('#edit_drug').click();
  }
  function save_editDrug() {
    $.ajax({
      url: '/drugs/act/drug/update.s',
      method: 'post',
      data: $('#editDrugForm').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert("<ui:message code="successSave"/>");
          $('#edit-drug-close').click();
          $('.modal-backdrop').remove();
          $('body').removeClass('modal-open');
          setPage('/drugs/act/addEdit.s?id=${obj.id}');
        } else {
          alert(res.msg);
        }
      }
    });
  }

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
      if(elem.name !== '' && elem.hasAttribute('required') && (elem.value === '' || elem.value == null)) {
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
  function removeVergul(dom, code){
    dom.value.replace(',', '.');
    if(code === 'block_count') {
      let d = document.getElementById("selected_drug_id");
      let cn = d.options[d.selectedIndex].getAttribute('counter');
      $('#counter').val(cn * dom.value);
    }
    let price = getDOM("drug_price").value;
    let bc = getDOM("block_count").value;
    let count = document.getElementById("counter").value;
    if(price > 0 && bc > 0 && count > 0) {
      let p = Math.round((price / (count / bc)) * 100) / 100;
      getDOM("one_price").value = p;
      getDOM("nds").value = Math.round(Number('${ndsProc}') * p) / 100;
    }
  }
  function setDrugName(dom) {
    var cn = dom.options[dom.selectedIndex].getAttribute('counter');
    var mn = dom.options[dom.selectedIndex].getAttribute('measure');
    $('#drug_price').attr('disabled', dom.value === '' || cn === 0 || cn === '');
    $('#block_count').attr('disabled', dom.value === '' || cn === 0 || cn === '');
    $('#counter').attr('disabled', dom.value === '' || cn === 0 || cn === '');
    $('#one_price').attr('disabled', dom.value === '' || cn === 0 || cn === '');
    $('#nds').attr('disabled', dom.value === '' || cn === 0 || cn === '');
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
  function saveManForm() {
    if($('#man-name').val() == '') {
      alert('Наименование не может быть пустым');
      return;
    }
    $.ajax({
      url: '/drugs/dict/save.s',
      method: 'post',
      data: $('#new-man-form').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('select[name=man]').each(function (elem, dom) {
            var options = dom.options;
            dom.options[options.length] = new Option(res.name, res.id);
            $(this).val(res.id);
            $(this).trigger('liszt:updated');
            document.getElementById("close-modal1").click();
          });
          document.getElementById('new-man-form').reset();
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
