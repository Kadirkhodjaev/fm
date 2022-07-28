<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<style>
  .required {color:red;}
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<form target="_blank" method="post" action="/rep/run.s" name="write_off_print">
  <input type="hidden" name="repId" value="37"/>
  <input type="hidden" id="write_off_id" name="id" value="${obj.id}"/>
</form>
<div class="panel panel-info" style="width: 80%; margin: auto">
  <div class="panel-heading">
    Реквизиты акта списания
    <button  class="btn btn-sm" onclick="setPage('/drugs/write-off.s')" style="float:right;margin-top:-5px; margin-left:10px"><i class="fa fa-backward"></i> Назад</button>
    <c:if test="${obj.id > 0 && obj.state == 'SND'}">
      <button  class="btn btn-sm btn-danger" onclick="setConfirm()" style="float:right;margin-top:-5px; margin-left:10px"><i class="fa fa-check"></i> Подтвердить</button>
    </c:if>
    <c:if test="${obj.id > 0}">
      <button  class="btn btn-sm btn-info" onclick="printWriteOffPage()" style="float:right;margin-top:-5px; margin-left:10px"><i class="fa fa-print"></i> Печать</button>
    </c:if>
  </div>
  <div class="panel-body">
    <form id="addEditForm" style="padding:5px">
      <input type="hidden" name="id" value="${obj.id}">
      <table class="table table-bordered" style="width:100%; margin:auto;">
        <tr>
          <td style="text-align:right;font-weight:bold;vertical-align: middle">Рег № <i class="required">*</i>:</td>
          <td>
            ${obj.regNum}
          </td>
          <td style="text-align:right;font-weight:bold;vertical-align: middle">Рег дата <i class="required">*</i>:</td>
          <td>
            <fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.regDate}"/>
          </td>
          <td style="text-align:right;font-weight:bold;vertical-align: middle">Получатель:</td>
          <td colspan="3">${obj.direction.name}</td>
          <td style="text-align:right;font-weight:bold;vertical-align: middle">Дополнительная информация:</td>
          <td colspan="3">${obj.info}</td>
        </tr>
      </table>
    </form>
  </div>
  <!-- /.panel-body -->
</div>
<c:if test="${obj.id > 0 && obj.state == 'SND'}">
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
              <select class="form-control chzn-select" style="width:100%" required name="drug_id" onchange="setDrugCount1(this)">
                <option></option>
                <c:forEach items="${drugs}" var="cc">
                  <option value="${cc.id}">${cc.name}</option>
                </c:forEach>
              </select>
            </td>
            <td align="right">Количество: </td>
            <td style="width:100px"><input type="number" id="drug_count1" disabled name="drug_count" class="form-control center"></td>
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
      <c:if test="${obj.state == 'SND'}">
        <button class="btn btn-sm btn-success" onclick="saveRows()" style="float:right;margin-top:-5px; margin-left:10px"><i class="fa fa-save"></i> Сохранить</button>
      </c:if>
    </div>
    <div class="panel-body">
      <form id="act_rows_form">
        <input type="hidden" name="id" value="${obj.id}"/>
        <table class="table miniGrid" id="rows_table">
          <thead>
            <tr>
              <th>#</th>
              <th>#</th>
              <th>Наименование</th>
              <th>Аптека</th>
              <th>Кол-во по заявке</th>
              <th>Списание</th>
              <th>Цена</th>
              <th>Сумма</th>
              <th>Удалить</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${rows}" var="row" varStatus="loop">
              <c:if test="${row.drugCount == null}">
                <input type="hidden" name="row_id" value="${row.id}"/>
              </c:if>
              <tr id="line_${loop.index}">
                <td class="center" style="width:40px">
                  <c:if test="${row.drugCount == null && fn:length(row.list) > 0}">
                    <button title="Создать новую запись" onclick="copyRow(${row.id}, ${loop.index})" class="btn btn-success btn-sm" style="height:24px; padding:3px 5px;"><b class="fa fa-plus"></b></button>
                  </c:if>
                </td>
                <td style="text-align: center">
                  <c:if test="${row.drugCount == null}">
                    <img src="/res/imgs/red.gif">
                  </c:if>
                  <c:if test="${row.drugCount != null}">
                    <img src="/res/imgs/green.gif">
                  </c:if>
                </td>
                <td style="vertical-align: middle" id="drug_name_${loop.index}">
                    ${row.name}
                </td>
                <td class="center">
                  <c:if test="${fn:length(row.list) == 0 && row.drugCount == null}">Не имеется<input type="hidden" name="child_type" value="no"><input type="hidden" name="drug_id" value="0"></c:if>
                  <c:if test="${fn:length(row.list) > 0 && row.drugCount == null}">
                    <input type="hidden" name="child_type" id="child_type_${loop.index}" value="">
                    <select class="form-control saldo_field" name="drug_id" id="saldo_${loop.index}" onchange="setSaldoRow(this)">
                      <c:forEach items="${row.list}" var="l">
                        <option data-price="${l.c3}" data-saldo="${l.c2}" data-type="${l.c4}" value="${l.c1}">Остаток: <fmt:formatNumber value="${l.c2}" type="number"/>; Цена: <fmt:formatNumber value="${l.c3}" type="number"/></option>
                      </c:forEach>
                    </select>
                  </c:if>
                  <c:if test="${row.drugCount != null}">Подтвержден</c:if>
                </td>
                <td style="width:150px; text-align:center">
                  <c:if test="${row.drugCount == null}">
                    <input disabled class="form-control right" type="number" id="claim_count_${loop.index}" value="${row.claimCount}"/>
                  </c:if>
                  <c:if test="${row.drugCount != null}"><fmt:formatNumber value="${row.claimCount}" type="number"/></c:if>
                </td>
                <td style="width:150px; text-align:center">
                  <c:if test="${row.drugCount == null && fn:length(row.list) > 0}">
                    <input class="form-control right" type="number" name="drug_count" id="drug_count_${loop.index}" value="${row.drugCount == null ? row.claimCount : row.drugCount}" onchange="setDrugCount(this)"/>
                  </c:if>
                  <c:if test="${row.drugCount != null}"><fmt:formatNumber value="${row.drugCount}" type="number"/></c:if>
                  <c:if test="${row.drugCount == null && fn:length(row.list) == 0}">
                    <input type="hidden" name="drug_count" value="0"/>
                  </c:if>
                </td>
                <td style="width:150px; text-align:right">
                  <c:if test="${row.drugCount == null}">
                    <input disabled class="form-control right" type="text" id="saldo_price_${loop.index}" value="${row.price}"/>
                  </c:if>
                  <c:if test="${row.drugCount != null}"><fmt:formatNumber value="${row.price}" type="number"/></c:if>
                </td>
                <td style="width:150px; text-align:right">
                  <c:if test="${row.drugCount == null}">
                    <input disabled class="form-control right" type="text" id="saldo_sum_${loop.index}" value="${row.price * row.drugCount}"/>
                  </c:if>
                  <c:if test="${row.drugCount != null}"><fmt:formatNumber value="${row.price * row.drugCount}" type="number"/></c:if>
                </td>
                <td style="width:30px;text-align: center">
                  <c:if test="${row.drugCount != null && obj.state == 'SND'}">
                    <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="clearRow(${row.id})"><span class="fa fa-minus"></span></button>
                  </c:if>
                  <c:if test="${row.drugCount == null && fn:length(row.list) == 0 && obj.state == 'SND'}">
                    <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="deleteDocRow(${row.id})"><span class="fa fa-minus"></span></button>
                  </c:if>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </form>
    </div>
    <!-- /.panel-body -->
  </div>
  <a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
  <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
          <h4 class="modal-title" id="myModalLabel">Разделение заявки</h4>
        </div>
        <div class="modal-body">
          <div class="center" style="margin-bottom:10px">
          <h3 id="drug_name" style="margin:auto"></h3>
          </div>
          <form id="addEditForms" name="addEditForms">
            <input type="hidden" name="id" id="fact_id" value=""/>
            <table class="table table-bordered">
              <tr>
                <td class="right bold">Кол-во по заявке:</td>
                <td>
                  <input type="text" disabled id="fact_count" class="form-control right" value=""/>
                </td>
              </tr>
              <tr>
                <td class="right bold">Кол-во для разделения*:</td>
                <td>
                  <input type="number" id="drug_count" class="form-control right" name="drug_count" onchange="setDropCount(this)" value=""/>
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
</c:if>
<script>
  function setDrugCount(dom) {
    var id = dom.id.replace('drug_count_', '');
    var saldoElem = document.getElementById('saldo_' + id);
    var saldo = saldoElem.options[saldoElem.selectedIndex].getAttribute("data-saldo");
    var claimCount = $('#claim_count_' + id).val();
    if(parseFloat(saldo) < parseFloat(dom.value)) {
      dom.value = claimCount;
      alert('Количество перепаратов не может превышать остатка');
      return;
    }
    if(parseFloat(claimCount) < parseFloat(dom.value)) {
      dom.value = claimCount;
      alert('Количество перепаратов не может превышать количество по заявке');
      return;
    }
    setSaldoRow(saldoElem);
  }
  function printWriteOffPage() {
    write_off_print.submit();
  }
  function setSaldoRow(dom) {
    var price = dom.options[dom.selectedIndex].getAttribute("data-price");
    var id = dom.id.replace('saldo_', '');
    $('#saldo_price_' + id).val(Intl.NumberFormat('en-US', {}).format(price));
    $('#saldo_sum_' + id).val(Intl.NumberFormat('en-US', {}).format(price * $('#drug_count_' + id).val()));
    $('#child_type_' + id).val(dom.options[dom.selectedIndex].getAttribute("data-type"));
  }
  function setDropCount(dom) {
    var fc = parseFloat($('#fact_count').val());
    if(fc <= parseFloat(dom.value) || parseFloat(dom.value) <= 0) {
      dom.value = 0;
      alert('Кол-во для разделения не может быть меньше 0 или больше кол-во по заявке');
    }
  }
  function copyRow(id, idx) {
    $('#modal_window').click();
    $('#fact_id').val(id);
    $('#fact_count').val($('#claim_count_' + idx).val());
    $('#drug_name').html($('#drug_name_' + idx).html());
  }
  function saveLineDrop() {
    var fc = parseFloat($('#fact_count').val());
    var dc = $('#drug_count').val();
    if(dc == null || dc == '' || parseFloat(dc) <= 0 || parseFloat(dc) >= fc) {
      alert('Кол-во для разделения не соответствует требованиям');
      return;
    }
    $.ajax({
      url: '/drugs/write-off/row/copy.s',
      data: $('#addEditForms').serialize(),
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('#close-modal').click();
          alert('Данные успешно сохранены');
          setPage('/drugs/write-off/save.s?id=${obj.id}');
        } else
          alert(res.msg);
      }
    });
  }
  function saveRows() {
    if($('input[name=row_id]').length === 0) {
      return;
    }
    $.ajax({
      url: '/drugs/write-off/row/save.s',
      data: $('#act_rows_form').serialize(),
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if (res.success)
          alert('Данные успешно сохранены');
        else
          alert(res.msg);
        setPage('/drugs/write-off/save.s?id=${obj.id}');
      }
    });
  }
  function clearRow(id) {
    if(confirm('Вы действительно отменить списание по выбранной строке?'))
      $.ajax({
        url: '/drugs/write-off/row/clear.s',
        data: 'id=' + id,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success)
            alert('Данные успешно сохранены');
          else
            alert(res.msg);
          setPage('/drugs/write-off/save.s?id=${obj.id}');
        }
      });
  }
  function setConfirm() {
    if(confirm('Вы действительно подтвердить расход?'))
      $.ajax({
        url: '/drugs/write-off/confirm.s',
        data: 'id=${obj.id}',
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            setPage('/drugs/write-off/save.s?id=${obj.id}');
          } else
            alert(res.msg);
        }
      });
  }
  function setDrugCount1(dom) {
    $('#drug_count1').attr('disabled', !(dom.value > 0));
  }
  function saveActRow() {
    if(parseFloat($('#drug_count1').val()) > 0) {
      $.ajax({
        url: '/head_nurse/incomes/row/save.s',
        method: 'post',
        data: $('#addEditFormRow').serialize(),
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("<ui:message code="successSave"/>");
            setPage('/drugs/write-off/save.s?id=${obj.id}');
          } else {
            alert(res.msg);
          }
        }
      });
    } else {
      alert('Не правильный формат данных поле "Количество"');
    }
  }
  function deleteDocRow(id) {
    if(confirm('Вы действительно удалить выбранную запись?'))
      $.ajax({
        url: '/drugs/write-off/row/del.s',
        data: 'id=' + id,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success)
            alert('Данные успешно сохранены');
          else
            alert(res.msg);
          setPage('/drugs/write-off/save.s?id=${obj.id}');
        }
      });
  }
  $(function(){
    $(".chzn-select").chosen();
    $('#rows_table').find('.saldo_field').each((idx, dom) => {
      setSaldoRow(dom)
    })
  });
</script>