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
<script src="/res/js/common.js" type="text/javascript"></script>
<iframe style="display: none" name="drug_excel"></iframe>

<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    <span style="font-weight:bold" title="HNPATIENT: ${obj.id} PATIENT_ID: ${obj.patient.id}">Реквизиты пациента: №${obj.patient.yearNum} ${obj.patient.surname} ${obj.patient.name} ${obj.patient.middlename} - <fmt:formatDate pattern="dd.MM.yyyy" value="${obj.patient.dateBegin}"/></span>
    <button  class="btn btn-sm" onclick="setPage('/act/index.s')" style="float:right;margin-top:-5px; margin-left:10px"><i class="fa fa-backward"></i> Назад</button>
    <button class="btn btn-info btn-sm" style="float:right;margin-top:-5px; margin-left:10px" onclick="excel()"><span class="fa fa-file-excel-o"></span> Excel</button>
    <c:if test="${(obj.state == 'C' || (obj.closed != 'Y' && obj.state == 'D'))}">
      <button  class="btn btn-sm btn-primary" onclick="confirmPatient()" style="float:right;margin-top:-5px; margin-left:10px"><i class="fa fa-check"></i> Подтвердить</button>
    </c:if>
    <c:if test="${(obj.closed == 'Y' && obj.patient.state == 'LV') && sessionScope.ENV.userId == 1}">
      <button  class="btn btn-sm btn-danger" onclick="retPatient()" style="float:right;margin-top:-5px; margin-left:10px"><i class="fa fa-retweet"></i> Возобновить</button>
    </c:if>
    <c:if test="${obj.closed != 'Y'}">
      <button  class="btn btn-sm btn-success" onclick="savePatient()" style="float:right;margin-top:-5px;"><i class="fa fa-save"></i> Сохранить</button>
    </c:if>
    <c:if test="${obj.closed == 'Y' && obj.patient.paid == 'CLOSED' && sessionScope.ENV.userId == 1}">
      <button  class="btn btn-sm btn-success" onclick="openCash()" style="float:right;margin-top:-5px;"><i class="fa fa-repeat"></i> Открыть кассу</button>
    </c:if>
  </div>
  <div class="panel-body">
    <form id="addEditForm" style="padding:5px">
      <table class="table table-bordered" style="width:100%; margin:auto;">
        <tr>
          <td style="text-align:right;font-weight:bold;vertical-align: middle" nowrap >Дата выписки: </td>
          <td nowrap ><input type="text" id="act_end_date" class="form-control datepicker" value="<fmt:formatDate pattern="dd.MM.yyyy" value="${obj.dateEnd}" />"></td>
          <td style="text-align:right;font-weight:bold;vertical-align: middle" nowrap >Номер акта: </td>
          <td nowrap ><input type="text" id="act_num" class="form-control center" value="${obj.actNum}"></td>
          <td style="text-align:right;font-weight:bold;vertical-align: middle" nowrap >Койко дней: </td>
          <td nowrap ><input type="number" id="day_count" class="form-control center" value="${obj.dayCount}"></td>
          <td style="text-align:right;font-weight:bold;vertical-align: middle" nowrap >Цена за койку: </td>
          <td nowrap ><input type="number" id="koyko_price" class="form-control center" value="${obj.koykoPrice}"></td>
          <td style="text-align:right;font-weight:bold;vertical-align: middle" nowrap >Питание: </td>
          <td nowrap ><input type="number" id="eat_price" class="form-control center" value="${obj.eatPrice}"></td>
        </tr>
        <tr>
          <td style="text-align:right;font-weight:bold;vertical-align: middle">Оплачено: </td>
          <td align="center"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${paidSum}"/></td>
          <td style="text-align:right;font-weight:bold;vertical-align: middle">Общая сумма: </td>
          <td align="center"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${obj.totalSum}"/></td>
          <td style="text-align:right;font-weight:bold;vertical-align: middle">Скидка: </td>
          <td align="center"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${discountSum}"/></td>
          <td style="text-align:right;font-weight:bold;vertical-align:middle;">
            <c:if test="${obj.paySum >= 0}">
              К оплате:
            </c:if>
            <c:if test="${obj.paySum < 0}">
              Возврат:
            </c:if>
          </td>
          <td align="center">
            <c:if test="${obj.paySum >= 0}">
              <fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${obj.paySum}"/>
            </c:if>
            <c:if test="${obj.paySum < 0}">
              <span style="color:red;font-weight:bold"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${obj.paySum}"/></span>
            </c:if>
          </td>
        </tr>
      </table>
    </form>
  </div>
  <!-- /.panel-body -->
</div>

<c:if test="${fn:length(epics) > 0}">
  <div class="panel panel-info" style="width: 100%; margin: auto">
    <div class="panel-heading">
      <span style="font-weight:bold">Переводной эпикриз: <span style="color:red"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${epicSum}" type="number"/></span></span>
    </div>
    <div class="panel-body">
      <table class="table miniGrid" id="patient_epic_list">
        <thead>
        <tr>
          <th>Отделение</th>
          <th>Дата начала</th>
          <th>Дата окончания</th>
          <th>Койко дней</th>
          <th>Стоимость</th>
          <th>Сумма</th>
          <th>С НДС</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${epics}" var="row" varStatus="loop">
          <tr>
            <td>${row.c1}</td>
            <td class="center" width="140px">
              <input type="text" style="width:100px" class="form-control center" disabled value="${row.c3}">
            </td>
            <td class="center" width="140px">
              <input type="text" style="width:100px" class="form-control center" disabled value="${row.c4}">
            </td>
            <td style="width:150px; text-align:right">
              <input type="number" <c:if test="${row.ib == '-1' && sessionScope.ENV.userId != 1}">disabled</c:if> class="form-control right" onchange="setFieldValue('epic', 'koyko', ${row.ib}, this)" value="${row.c6}">
            </td>
            <td style="width:150px; text-align:right">
              <input type="number" <c:if test="${row.ib == '-1' && sessionScope.ENV.userId != 1}">disabled</c:if> class="form-control right" onchange="setFieldValue('epic', 'price', ${row.ib}, this)" value="${row.c5}">
            </td>
            <td style="width:150px; text-align:right">
              <input type="text" disabled class="form-control right" value="<fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${row.c5 * row.c6}" type = "number"/>">
            </td>
            <td style="width:150px; text-align:right">
              <input type="text" disabled class="form-control right" value="<fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${row.c5 * row.c6}" type = "number"/>">
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
    <!-- /.panel-body -->
  </div>
</c:if>

<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    <span style="font-weight:bold">Медикаменты: <span style="color:red"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${drugSum}" type="number"/></span></span>
    <c:if test="${obj.closed != 'Y'}">
      <button style="float:right; margin-top:-5px" class="btn btn-success btn-sm" onclick="addNewDrug()"><span class="fa fa-plus"></span> Добавить</button>
    </c:if>
  </div>
  <div class="panel-body">
    <table class="table miniGrid" id="patient_drug_list">
      <thead>
        <tr>
          <th>Наименование</th>
          <th>Стоимость (Аптека)</th>
          <th>Стоимость</th>
          <th>Цена за единицу</th>
          <th>Расход</th>
          <th>Сумма</th>
          <th>С НДС</th>
          <c:if test="${obj.closed != 'Y'}">
            <th>Удалить</th>
          </c:if>
        </tr>
      </thead>
      <tbody>
      <c:forEach items="${drugs}" var="row" varStatus="loop">
        <tr>
          <td>${row.drugName}</td>
          <td align="right">
            <fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${row.drugPrice}" type = "number"/>
          </td>
          <td style="width:150px; text-align:right">
            <input type="number" class="form-control right" onchange="setFieldValue('drug', 'price', ${row.id}, this)" value="${row.price}">
          </td>
          <td style="width:120px; text-align:right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${row.price}" type = "number"/></td>
          <td style="width:120px; text-align:center">
            <input type="number" class="form-control center" value="${row.serviceCount}" onchange="setFieldValue('drug', 'counter', ${row.id}, this)" >
          </td>
          <td style="width:120px; text-align:right">
            <input type="text" disabled class="form-control right" value="<fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${row.serviceCount * row.price}" type = "number"/>">
          </td>
          <td style="width:120px; text-align:right">
            <input type="text" disabled class="form-control right" value="<fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${row.serviceCount * (row.price + row.nds)}" type = "number"/>">
          </td>
          <c:if test="${obj.closed != 'Y'}">
            <td style="width:30px;text-align: center" class="center">
              <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delDrugRow(${row.id})"><span class="fa fa-minus"></span></button>
            </td>
          </c:if>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
  <!-- /.panel-body -->
</div>

<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    <span style="font-weight:bold">Лабораторные исследования: <span style="color:red"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${labSum}" type="number"/></span></span>
    <button style="float:right; margin-top:-5px; margin-left:5px; <c:if test="${not_done}">font-weight:bold; color:red;</c:if>" class="btn btn-default btn-sm" onclick="$('#modal_window').click()"><span class="fa fa-list"></span> Обследования</button>
    <c:if test="${obj.closed != 'Y'}">
      <button style="float:right; margin-top:-5px" class="btn btn-success btn-sm" onclick="addService('lab')"><span class="fa fa-plus"></span> Добавить</button>
      <button style="float:right; margin-top:-5px; margin-right:10px;" class="btn btn-info btn-sm" onclick="restoreServiceRow(0, ${obj.id})"><span class="fa fa-refresh"></span> Восстановить</button>
    </c:if>
  </div>
  <div class="panel-body">
    <table class="table miniGrid" id="patient_lab_list">
      <thead>
      <tr>
        <th>Наименование</th>
        <th style="width:150px">Реальная стоимость</th>
        <th style="width:150px">Стоимость</th>
        <th style="width:150px">Количество</th>
        <th style="width:150px">Сумма</th>
        <th style="width:150px">С НДС</th>
        <c:if test="${obj.closed != 'Y'}">
          <th>Удалить</th>
        </c:if>
      </tr>
      </thead>
      <tbody>
        <c:forEach items="${labs}" var="elem">
          <tr>
            <td>${elem.serviceName}</td>
            <td align="right"><input type="number" class="form-control right" value="${elem.real_price}" readonly></td>
            <td align="right"><input type="number" class="form-control right" value="${elem.price}" onchange="setFieldValue('service', 'price', ${elem.id}, this)"></td>
            <td align="center"><input type="number" class="form-control center" value="${elem.serviceCount}" onchange="setFieldValue('service', 'counter', ${elem.id}, this)"></td>
            <td align="right"><input type="text" disabled class="form-control right" value="<fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${elem.price * elem.serviceCount}" type = "number"/>"></td>
            <td align="right"><input type="text" disabled class="form-control right" value="<fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${(elem.price + elem.nds) * elem.serviceCount}" type = "number"/>"></td>
            <c:if test="${obj.closed != 'Y'}">
              <td style="width:30px;text-align: center" class="center">
                <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delServiceRow(${elem.id})"><span class="fa fa-minus"></span></button>
              </td>
            </c:if>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
  <!-- /.panel-body -->
</div>

<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    <span style="font-weight:bold">Узкие специалисты: <span style="color:red"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${consulSum}" type="number"/></span></span>
    <c:if test="${obj.closed != 'Y'}">
      <button style="float:right; margin-top:-5px" class="btn btn-success btn-sm" onclick="addService('consul')"><span class="fa fa-plus"></span> Добавить</button>
      <button style="float:right; margin-top:-5px; margin-right:10px;" class="btn btn-info btn-sm" onclick="restoreServiceRow(2, ${obj.id})"><span class="fa fa-refresh"></span> Восстановить</button>
    </c:if>
  </div>
  <div class="panel-body">
    <table class="table miniGrid" id="patient_consul_list">
      <thead>
      <tr>
        <th>Наименование</th>
        <th style="width:150px">Реальная стоимость</th>
        <th style="width:150px">Стоимость</th>
        <th style="width:150px">Количество</th>
        <th style="width:150px">Сумма</th>
        <th style="width:150px">С НДС</th>
        <c:if test="${obj.closed != 'Y'}">
          <th>Удалить</th>
        </c:if>
      </tr>
      </thead>
      <tbody>
        <c:forEach items="${consuls}" var="elem">
          <tr>
            <td>${elem.serviceName}</td>
            <td align="right"><input type="number" class="form-control right" value="${elem.real_price}" readonly></td>
            <td align="right"><input type="number" class="form-control right" value="${elem.price}" onchange="setFieldValue('service', 'price', ${elem.id}, this)"></td>
            <td align="center"><input type="number" class="form-control center" value="${elem.serviceCount}" onchange="setFieldValue('service', 'counter', ${elem.id}, this)"></td>
            <td align="right"><input type="text" disabled class="form-control right" value="<fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${elem.price * elem.serviceCount}" type = "number"/>"></td>
            <td align="right"><input type="text" disabled class="form-control right" value="<fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${(elem.price + elem.nds) * elem.serviceCount}" type = "number"/>"></td>
            <c:if test="${obj.closed != 'Y'}">
              <td style="width:30px;text-align: center" class="center">
                <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delServiceRow(${elem.id})"><span class="fa fa-minus"></span></button>
              </td>
            </c:if>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
  <!-- /.panel-body -->
</div>

<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    <span style="font-weight:bold">Медицинские услуги: <span style="color:red"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${kdoSum}" type="number"/></span></span>
    <c:if test="${obj.closed != 'Y'}">
      <button style="float:right; margin-top:-5px" class="btn btn-success btn-sm" onclick="addService('kdo')"><span class="fa fa-plus"></span> Добавить</button>
      <button style="float:right; margin-top:-5px; margin-right:10px;" class="btn btn-info btn-sm" onclick="restoreServiceRow(1, ${obj.id})"><span class="fa fa-refresh"></span> Восстановить</button>
    </c:if>
  </div>
  <div class="panel-body">
    <table class="table miniGrid" id="patient_kdo_list">
      <thead>
      <tr>
        <th>Наименование</th>
        <th style="width:150px">Реальная стоимость</th>
        <th style="width:150px">Стоимость</th>
        <th style="width:150px">Количество</th>
        <th style="width:150px">Сумма</th>
        <th style="width:150px">С НДС</th>
        <c:if test="${obj.closed != 'Y'}">
          <th>Удалить</th>
        </c:if>
      </tr>
      </thead>
      <tbody>
        <c:forEach items="${kdos}" var="elem">
          <tr>
            <td>${elem.serviceName}</td>
            <td align="right"><input type="number" class="form-control right" value="${elem.real_price}" readonly></td>
            <td align="right"><input type="number" class="form-control right" value="${elem.price}" onchange="setFieldValue('service', 'price', ${elem.id}, this)"></td>
            <td align="center"><input type="number" class="form-control center" value="${elem.serviceCount}" onchange="setFieldValue('service', 'counter', ${elem.id}, this)"></td>
            <td align="right"><input type="text" disabled class="form-control right" value="<fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${elem.price * elem.serviceCount}" type = "number"/>"></td>
            <td align="right"><input type="text" disabled class="form-control right" value="<fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${(elem.price + elem.nds) * elem.serviceCount}" type = "number"/>"></td>
            <c:if test="${obj.closed != 'Y'}">
              <td style="width:30px;text-align: center" class="center">
                <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delServiceRow(${elem.id})"><span class="fa fa-minus"></span></button>
              </td>
            </c:if>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
  <!-- /.panel-body -->
</div>

<c:if test="${fn:length(watchers) > 0}">
  <div class="panel panel-info" style="width: 100%; margin: auto">
    <div class="panel-heading">
      <span style="font-weight:bold">Дополнительное место: <span style="color:red"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${watcherSum}" type="number"/></span></span>
    </div>
    <div class="panel-body">
      <table class="table miniGrid">
        <thead>
        <tr>
          <th style="width:150px">Количество</th>
          <th style="width:150px">Стоимость</th>
          <th style="width:150px">Сумма</th>
          <th style="width:150px">С НДС</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${watchers}" var="row">
          <tr>
            <td align="center"><input type="number" class="form-control center" value="${row.dayCount}" onchange="setFieldValue('watcher', 'counter', ${row.id}, this)"></td>
            <td align="right"><input type="number" class="form-control right" value="${row.price}" onchange="setFieldValue('watcher', 'price', ${row.id}, this)"></td>
            <td class="center"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${row.price * row.dayCount}" type = "number"/></td>
            <td class="center"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${(row.price + row.nds) * row.dayCount}" type = "number"/></td>
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
  <div class="modal-dialog" style="width:100%">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" id="close-modal" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel">Пациент: ${obj.patient.surname} ${obj.patient.name} ${obj.patient.middlename}</h4>
      </div>
      <div class="modal-body" id="patient_drugs_list">
        <table class="formTable" style="width:100%">
          <tr>
            <td style="width:30px">&nbsp;</td>
            <td style="width:30px">&nbsp;</td>
            <td align="center" width="300"><b>Наименование</b></td>
            <td align="center" width="140"><b>Дата</b></td>
            <td align="center"><b>Примечание</b></td>
            <td align="center"><b>Назначил</b></td>
            <td align="center" width="30">&nbsp;</td>
          </tr>
          <c:forEach items="${plans}" var="p" varStatus="loop">
            <tr id="stat_obs_row_${p.c1}">
              <td align="center">${loop.index + 1}</td>
              <td align="center">
                <c:if test="${p.c7 == 'Y'}"><img src="/res/imgs/green.gif"></c:if>
                <c:if test="${p.c7 == 'N'}"><img src="/res/imgs/red.gif"></c:if>
              </td>
              <td width="300">${p.c4}</td>
              <td align="center" nowrap>${p.c5}</td>
              <td>${p.c6}</td>
              <td>${p.c9}</td>
              <td align="center">
                <c:if test="${p.c7 == 'N'}">
                  <button class="btn btn-danger btn-xs" type="button" onclick="delPlan('${p.c1}')"><i class="fa fa-minus"></i></button>
                </c:if>
              </td>
            </tr>
          </c:forEach>
        </table>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>

<script>
  var labCount = ${fn:length(labs)};
  var kdoCount = ${fn:length(kdos)};
  var consulCount = ${fn:length(consuls)};
  var drugCount = ${fn:length(drugs)};

  function openCash(){
    if(confirm('Вы действительно хотите удалить открыть кассу?')) {
      $.ajax({
        url: '/act/patient/cash.s',
        method: 'post',
        data: 'id=${obj.id}',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("<ui:message code="successSave"/>");
            parent.setPage('/act/info.s?id=${obj.id}');
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }

  function delPlan(id){
    if(confirm('Вы действительно хотите удалить?')) {
      $.ajax({
        url: '/act/stat/del/obs.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("<ui:message code="successSave"/>");
            $('#stat_obs_row_' + id).remove();
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
  function delDrugRow(id) {
    if(confirm('Дейтвительно хотите удалить?')) {
      $.ajax({
        url: '/head_nurse/patient/drug/delete.s',
        data: 'id=' + id,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            parent.setPage('/act/info.s?id=${obj.id}');
          } else
            alert(res.msg);
        }
      });
    }
  }
  function confirmPatient() {
    if(confirm('Дейтвительно хотите подтвердить?')) {
      $.ajax({
        url: '/act/confirm.s',
        data: 'id=${obj.id}',
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            setPage('/act/info.s?id=${obj.id}');
          } else
            alert(res.msg);
        }
      });
    }
  }
  function excel() {
    drug_excel.location = '/act/excel.s?id=${obj.id}';
  }
  function savePatient() {
    $.ajax({
      url: '/act/patient/save.s',
      data: 'id=${obj.id}&act=' + $('#act_num').val() + '&date_end=' + $('#act_end_date').val() + '&days=' + $('#day_count').val() + '&koyko=' + $('#koyko_price').val() + '&eat=' + $('#eat_price').val(),
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert('Данные успешно сохранены');
          setPage('/act/info.s?id=${obj.id}');
        } else
          alert(res.msg);
      }
    });
  }
  function addService(type) {
    var typeIdx = type === 'kdo' ? kdoCount++ : type === 'lab' ? labCount++ : type === 'consul' ? consulCount++ : 0;
    var tr = $('<tr id="row_' + typeIdx + '"></tr>');
    var td1 = $('<td><input type="text" class="form-control" name="name"/></td>');
    var td2 = $('<td><input type="number" class="form-control right" name="price"/></td>');
    var td3 = $('<td><input type="number" class="form-control center" name="counter"/></td>');
    var td4 = $('<td class="center"></td>');
    var sve = $('<button class="btn btn-success btn-sm" style="height:20px;padding:1px 20px" onclick=\'saveNewKdo("' + type + '", ' + typeIdx +')\'><span class="fa fa-check"></span></button>');
    var del = $('<button class="btn btn-danger btn-sm" style="height:20px;padding:1px 20px; margin-left:10px" onclick="removeNewKdo(' + typeIdx + ')"><span class="fa fa-minus"></span></button>');
    td4.append(sve).append(del);
    tr.append(td1).append(td2).append(td3).append(td4);
    $('#patient_' + type + '_list').find('tbody').before(tr);
  }
  function saveNewKdo(typeCode, idx) {
    var form = $('<form></form>');
    var id = $('<input type="text" name="id" value="${obj.id}">');
    var type = $('<input type="text" name="type" value="' + typeCode + '">');
    var name = $('<input type="text" name="name" value="' + $('#row_' + idx).find('input[name=name]').val() + '">');
    var price = $('<input type="text" name="price" value="' + $('#row_' + idx).find('input[name=price]').val() + '">');
    var counter = $('<input type="text" name="counter" value="' + $('#row_' + idx).find('input[name=counter]').val() + '">');
    form.append(id).append(type).append(name).append(price).append(counter);
    if(name.val() === '' || price.val() === '' || counter.val() === '') {
      alert('Не все поля заполнены');
      return;
    }
    $.ajax({
      url: '/act/service/save.s',
      data: form.serialize(),
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          setPage('/act/info.s?id=${obj.id}');
        } else
          alert(res.msg);
      }
    });
  }
  function removeNewKdo(idx) {
    $('#row_' + idx).remove();
  }
  function setFieldValue(cat, type, id, dom) {
    <c:if test="${obj.closed != 'Y'}">
      $.ajax({
        url: '/act/patient/row/save.s',
        data: 'id=' + id + '&value=' + dom.value + '&cat=' + cat + '&type=' + type,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/act/info.s?id=${obj.id}');
          } else
            alert(res.msg);
        }
      });
    </c:if>
  }
  function retPatient() {
    $.ajax({
      url: '/act/patient/open.s',
      data: 'id=${obj.id}',
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert('Данные успешно сохранены');
          setPage('/act/info.s?id=${obj.id}');
        } else
          alert(res.msg);
      }
    });
  }
  function delServiceRow(id) {
    if(confirm('Вы действительно хотите удалить?'))
      $.ajax({
        url: '/act/patient/service/del.s',
        data: 'id=' + id,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/act/info.s?id=${obj.id}');
          } else
            alert(res.msg);
        }
      });
  }
  function restoreServiceRow(type, id) {
    if(confirm('Вы действительно хотите восстановить данные! Все изменении будут сброшены?'))
      $.ajax({
        url: '/act/patient/service/restore.s',
        data: 'id=' + id + '&type=' + type,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/act/info.s?id=${obj.id}');
          } else
            alert(res.msg);
        }
      });
  }
  function addNewDrug() {
    var typeIdx = drugCount++;
    var tr = $('<tr id="drug_row_' + typeIdx + '"></tr>');
    var td1 = $('<td><input type="text" class="form-control" name="name"/></td>');
    var td1_1 = $('<td>&nbsp;</td>');
    var td2 = $('<td><input type="number" class="form-control right" name="price"/></td>');
    var td3 = $('<td><input type="number" class="form-control right" name="counter"/></td>');
    var td3_1 = $('<td>&nbsp;</td>');
    var td4 = $('<td><input type="number" class="form-control center" name="drug_count"/></td>');
    var td5 = $('<td class="center"></td>');
    var sve = $('<button class="btn btn-success btn-sm" style="height:20px;padding:1px 20px" onclick="saveNewDrug(' + typeIdx +')"><span class="fa fa-check"></span></button>');
    var del = $('<button class="btn btn-danger btn-sm" style="height:20px;padding:1px 20px; margin-left:10px" onclick="removeNewDrug(' + typeIdx + ')"><span class="fa fa-minus"></span></button>');
    td5.append(sve).append(del);
    tr.append(td1).append(td1_1).append(td2).append(td3).append(td3_1).append(td4).append(td5);
    $('#patient_drug_list').find('tbody').before(tr);
  }
  function saveNewDrug(idx) {
    var form = $('<form></form>');
    var id = $('<input type="text" name="id" value="${obj.id}">');
    var name = $('<input type="text" name="name" value="' + $('#drug_row_' + idx).find('input[name=name]').val() + '">');
    var price = $('<input type="text" name="price" value="' + $('#drug_row_' + idx).find('input[name=price]').val() + '">');
    var counter = $('<input type="text" name="counter" value="' + $('#drug_row_' + idx).find('input[name=counter]').val() + '">');
    var drug_count = $('<input type="text" name="drug_count" value="' + $('#drug_row_' + idx).find('input[name=drug_count]').val() + '">');
    form.append(id).append(name).append(price).append(counter).append(drug_count);
    if(name.val() === '' || price.val() === '' || counter.val() === '' || drug_count.val() === '') {
      alert('Не все поля заполнены');
      return;
    }
    $.ajax({
      url: '/act/drug/save.s',
      data: form.serialize(),
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          setPage('/act/info.s?id=${obj.id}');
        } else
          alert(res.msg);
      }
    });
  }
  function setArchive() {
    if(confirm('Вы действительно хотите архивировать пациента'))
      $.ajax({
        url: '/act/patient/confirm.s',
        data: 'id=${obj.patient.id}',
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            setPage('/act/info.s?id=${obj.id}');
          } else
            alert(res.msg);
        }
      });
  }
  function removeNewDrug(idx) {
    $('#drug_row_' + idx).remove();
  }
</script>
