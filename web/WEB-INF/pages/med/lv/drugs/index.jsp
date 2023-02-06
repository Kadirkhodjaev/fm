<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<script src="/res/datepicker/datetimepicker_css.js"></script>
<script src="/res/js/common.js" type="text/javascript"></script>
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<style>
  #patient-drug-add table tr td {padding:5px}
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<div class="panel panel-info" style="width: 100%; margin: auto;">
  <div class="panel-heading">
    Новое назначение
    <button  class="btn btn-sm btn-success" onclick="addDrug()" style="float:right;margin-top:-5px"><i class="fa fa-plus"></i> Добавить</button>
    <c:if test="${drug.id != null}">
      <button  class="btn btn-sm btn-default" onclick="saveTemplate()" style="float:right;margin-top:-5px; margin-right:10px"><i class="fa fa-save"></i> Сохранить как шаблон</button>
    </c:if>
    <button  class="btn btn-sm btn-default" onclick="fromTemplate()" style="float:right;margin-top:-5px; margin-right:10px"><i class="fa fa-list"></i> Шаблоны</button>
  </div>
  <div class="panel-body" id="patient-drug-add">
    <form name="add_edit_drug" id="add_edit_drug">
      <input type="hidden" name="id" value="${drug.id}">
      <table class="table table-bordered" style="margin:auto; width:1000px;font-size:12px">
        <tr>
          <td class="bold" style="vertical-align: middle">Тип: </td>
          <td>
            <select class="form-control" name="drug_type" onchange="setDrugType(this)" required >
              <c:forEach items="${drugTypes}" var="drugType">
                <option <c:if test="${drug.drugType.id == drugType.id}">selected</c:if> value="${drugType.id}">${drugType.name}</option>
              </c:forEach>
            </select>
          </td>
          <td colspan="3" style="vertical-align: middle; font-weight: bold" class="right">
            <span id="injection_type_label" style="<c:if test="${drug.drugType.id == 16}">display:block</c:if><c:if test="${drug.drugType.id != 16}">display:none</c:if>">Тип инъекции:</span>
          </td>
          <td colspan="2">
            <select class="form-control" style="<c:if test="${drug.drugType.id == 16}">display:block</c:if><c:if test="${drug.drugType.id != 16}">display:none</c:if>" name="injection_type" id="injection_type" >
              <option value=""></option>
              <c:forEach items="${injectionTypes}" var="injectionType">
                <option <c:if test="${drug.injectionType.id == injectionType.id}">selected</c:if> value="${injectionType.id}">${injectionType.name}</option>
              </c:forEach>
            </select>
          </td>
        </tr>
        <tr>
          <td class="bold" nowrap style="vertical-align: middle">
            Препарат:
            <button class="btn btn-success btn-sm" id="add_new_drug" onclick="newDrugLine()" type="button">
              <b class="fa fa-plus"></b>
            </button>
          </td>
          <td colspan="6">
            <table class="table-bordered" style="width:100%;font-size:12px" id="drug-lines">
              <thead>
              <tr>
                <td class="center bold" style="width:100px">Источник</td>
                <td class="bold center">Наименование</td>
                <td class="bold center" style="width:120px">За раз</td>
                <td class="bold center" style="width:120px">Ед. изм.</td>
                <td class="bold center" style="width:40px">#</td>
              </tr>
              </thead>
              <tbody>
              <c:forEach items="${drug.rows}" var="rw" varStatus="loop">
                <input type="hidden" name="row_id" value="${rw.id}"/>
                <tr id="line_${loop.index}">
                  <td style="width:100px" class="center">
                    <input type="hidden" name="source_code" value="${rw.source}">
                    <c:if test="${rw.source == 'own'}">Свой</c:if><c:if test="${rw.source == 'cln'}">Клиника</c:if>
                  </td>
                  <td>
                    <c:if test="${rw.source == 'own'}">
                      <input type="hidden" name="drug_drug" value="_">
                      <input type="text" name="drug_name" maxlength="256" class="form-control" value="${rw.name}">
                    </c:if>
                    <c:if test="${rw.source != 'own'}">
                      <input type="hidden" name="drug_name" value="_">
                      <input type="hidden" name="drug_drug" value="${rw.drug.id}">
                      ${rw.name}
                    </c:if>
                  </td>
                  <td align="center" style="width:120px">
                    <c:if test="${rw.source != 'own'}">
                      <input type="number" class="form-control center" value="${rw.expanse}" name="out_count"/>
                    </c:if>
                  </td>
                  <td align="center" style="width:120px">
                    <input type="hidden" name="drug_measure" value="${rw.measure.id}">
                      ${rw.measure.name}
                  </td>
                  <td style="width:40px">
                    <c:if test="${rw.state == 'ENT'}">
                      <button class="btn btn-sm btn-danger" type="button" style="height:20px;padding:1px 10px" title="Удалить" onclick="removeDrug(${loop.index}, ${rw.id})"><span class="fa fa-minus"></span></button>
                    </c:if>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </td>
        </tr>
        <tr>
          <td class="bold" style="vertical-align: middle">
            Цель:
          </td>
          <td nowrap style="width:300px" colspan="6">
            <select class="form-control chzn-select" name="goal" style="width:800px">
              <c:forEach items="${goals}" var="gl">
                <option <c:if test="${drug.goal.id == gl.id}">selected</c:if> value="${gl.id}">${gl.name}</option>
              </c:forEach>
            </select>
            <a href="#" onclick="addGoal()">
              <b class="fa fa-plus"></b>
            </a>
          </td>
        </tr>
        <tr>
          <td class="bold" style="vertical-align: middle">
            Период:
          </td>
          <td colspan="6">
            <div style="float:left">
              <input class="form-control datepicker" id="dateBegin" type="text" onchange="setPeriod()" name="dateBegin" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${drug.dateBegin}" />"/>
            </div>
            <div style="float:left;padding-right:10px;padding-left:10px;">
              по
            </div>
            <div>
              <input class="form-control datepicker" id="dateEnd" type="text" onchange="setPeriod()" name="dateEnd" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${drug.dateEnd}" />"/>
            </div>
          </td>
        </tr>
        <tr>
          <td class="bold" style="vertical-align: middle">Даты:</td>
          <td colspan="6">
            <table class="table-bordered" id="period_rows" style="width:100%; font-size: 12px">
              <tr>
                <c:forEach items="${drug.dates}" var="date">
                  <td class="bold center"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${date.date}" /></td>
                </c:forEach>
              </tr>
              <tr>
                <c:forEach items="${drug.dates}" var="date">
                  <td class="center hover hand" onclick="setCheckbox()">
                    <input type="hidden" name="date_id" value="${date.id}"/>
                    <input type="hidden" name="dt_state" value="${date.state}"/>
                    <input type="hidden" name="dates" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${date.date}" />" />
                    <input type="checkbox" name="date_state" <c:if test="${date.checked}">checked</c:if> value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${date.date}" />" />
                  </td>
                </c:forEach>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td class="bold" style="vertical-align: middle" rowspan="4">Время:</td>
          <td class="bold center" colspan="2">Утро</td>
          <td class="bold center" colspan="2">Обед</td>
          <td class="bold center" colspan="2">Вечер</td>
        </tr>
        <tr>
          <td class="bold center hover hand" colspan="2" onclick="setCheckbox()"><input type="checkbox" name="morningTime" onchange="setTimeCheck('morning')" <c:if test="${drug.morningTime}">checked</c:if> /></td>
          <td class="bold center hover hand" colspan="2" onclick="setCheckbox()"><input type="checkbox" name="noonTime" onchange="setTimeCheck('noon')" <c:if test="${drug.noonTime}">checked</c:if> /></td>
          <td class="bold center hover hand" colspan="2" onclick="setCheckbox()"><input type="checkbox" name="eveningTime" onchange="setTimeCheck('evening')" <c:if test="${drug.eveningTime}">checked</c:if> /></td>
        </tr>
        <tr>
          <td class="bold center">До еды</td>
          <td class="bold center">После еды</td>
          <td class="bold center">До еды</td>
          <td class="bold center">После еды</td>
          <td class="bold center">До еды</td>
          <td class="bold center">После еды</td>
        </tr>
        <tr>
          <td class="bold center hover hand" onclick="setCheckbox()"><input type="checkbox" name="morningTimeBefore" <c:if test="${drug.morningTimeBefore}">checked</c:if> /></td>
          <td class="bold center hover hand" onclick="setCheckbox()"><input type="checkbox" name="morningTimeAfter" <c:if test="${drug.morningTimeAfter}">checked</c:if> /></td>
          <td class="bold center hover hand" onclick="setCheckbox()"><input type="checkbox" name="noonTimeBefore" <c:if test="${drug.noonTimeBefore}">checked</c:if> /></td>
          <td class="bold center hover hand" onclick="setCheckbox()"><input type="checkbox" name="noonTimeAfter" <c:if test="${drug.noonTimeAfter}">checked</c:if> /></td>
          <td class="bold center hover hand" onclick="setCheckbox()"><input type="checkbox" name="eveningTimeBefore" <c:if test="${drug.eveningTimeBefore}">checked</c:if> /></td>
          <td class="bold center hover hand" onclick="setCheckbox()"><input type="checkbox" name="eveningTimeAfter" <c:if test="${drug.eveningTimeAfter}">checked</c:if> /></td>
        </tr>
        <tr>
          <td class="bold" style="vertical-align: middle">Описание: </td>
          <td colspan="7">
            <input style="width:800px" name="note" type="text" class="form-control" value="${drug.note}">
          </td>
        </tr>
      </table>
    </form>
    <div class="right">
      <button class="btn btn-sm btn-success" type="button" onclick="save()"><i class="fa fa-save"></i> Сохранить</button>
      <button class="btn btn-sm btn-default" type="button" onclick="$('#patient-drug-add').slideToggle();"><i class="fa fa-remove"></i> Выход</button>
    </div>
  </div>
</div>
<div class="panel panel-info" style="width: 100%; margin: auto;"2 >
  <div class="panel-heading">
    Лист назначения
    <button class="btn btn-sm" title="Обоснование" type="button" onclick="printObos()" style="float:right;margin-top:-5px"><i class="fa fa-print"></i> Обоснование</button>
  </div>
  <div class="panel-body">
    <table style="width:100%; font-size:13px" class="table table-bordered miniGrid">
      <thead>
      <tr>
        <th class="bold center">Наименование</th>
        <th class="bold center">Тип</th>
        <th class="bold center">Цель</th>
        <th class="bold center" colspan="2" style="width:100px">Период</th>
        <th class="bold center">Описание</th>
        <th class="bold center">#</th>
        <th class="bold center" style="width:30px">Удалить</th>
      </tr>
      </thead>
      <c:forEach items="${list}" var="d" varStatus="lp">
        <tr id="patient-drug-${d.id}">
          <td style="vertical-align: middle">
            <a href="#" title="Изменить" onclick="editDrug(${d.id})">
              <c:forEach items="${d.rows}" var="row" varStatus="loop">
                ${row.name}  <c:if test="${loop.index + 1 < fn:length(d.rows)}"> + </c:if>
              </c:forEach>
            </a>
          </td>
          <td style="vertical-align: middle; width:220px">
              ${d.drugType.name}<c:if test="${d.drugType.id == 16}"> - ${d.injectionType.name}</c:if>
          </td>
          <td style="vertical-align: middle">
              ${d.goal.name}
          </td>
          <td style="vertical-align: middle;width:100px;" class="text-center">
            <fmt:formatDate pattern = "dd.MM.yyyy" value = "${d.dateBegin}"/>
          </td>
          <td style="vertical-align: middle; width:100px;" class="text-center">
            <fmt:formatDate pattern = "dd.MM.yyyy" value = "${d.dateEnd}"/>
          </td>
          <td style="vertical-align: middle; width:300px">${d.note}</td>
          <td style="vertical-align: middle" class="hand text-center" title="Дополнительные детали">
            <button class="btn btn-sm" type="button" onclick="viewDetails(${lp.index})">
              <span class="fa fa-align-justify"></span>
            </button>
          </td>
          <td style="vertical-align: middle; width:20px" class="hand text-center">
            <c:if test="${d.canDel}">
              <button class="btn btn-sm btn-danger" type="button" onclick="removePatientDrug(${d.id})">
                <span class="fa fa-minus"></span>
              </button>
            </c:if>
          </td>
        </tr>
        <c:if test="${fn:length(d.dates) > 0}">
          <tr id="patient-drug-details-${d.id}">
            <td colspan="8" style="border-bottom:2px solid #ababab">
              <div id="drug-line-${lp.index}" style="display: none">
                <table class="table table-bordered">
                  <tr>
                    <td class="bold right" style="vertical-align: middle">
                      Даты:
                    </td>
                    <c:forEach items="${d.dates}" var="date" varStatus="loop">
                      <td class="text-center <c:if test="${date.checked}">bg-danger bold</c:if>"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${date.date}"/></td>
                    </c:forEach>
                  </tr>
                </table>
              </div>
            </td>
          </tr>
        </c:if>
      </c:forEach>
    </table>
    <div id="patient_drug_rows">
      <div class="bold">Экстренный шкаф</div>
      <table class="table table-bordered miniGrid" style="width:100%; font-size:13px">
        <thead>
        <tr>
          <th style="width:50px">№</th>
          <th>Склад</th>
          <th>Наименование</th>
          <th style="width:100px">Расход</th>
          <th style="width:100px">Ед. изм.</th>
          <th>Врач</th>
          <th style="width:100px">Дата и время</th>
        </tr>
        </thead>
        <c:forEach items="${shocks}" var="d" varStatus="lp">
          <tr class="hand hover">
            <td align="center">${lp.index + 1}</td>
            <td>${d.hndrug.direction.name}</td>
            <td id="edit_drug_name_${d.id}">${d.drug.name}</td>
            <td align="right">${d.rasxod}</td>
            <td id="edit_drug_measure_${d.id}">${d.hndrug.measure.name}</td>
            <td>${d.crBy.fio}</td>
            <td class="center"><fmt:formatDate pattern = "dd.MM.yyyy HH:mm" value = "${d.crOn}" /></td>
          </tr>
        </c:forEach>
      </table>
    </div>
  </div>
</div>

<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog" style="width:1100px">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel">
          <input type="text" placeholder="Поиск препаратов" onkeyup="filterDrugs()" class="form-control" style="font-size: 16px; width:400px" id="drug-list-filter" value="">
        </h4>
      </div>
      <div class="modal-body">
        <table class="table table-bordered miniGrid" id="drug-list" style="width:100%">
          <thead>
          <tr>
            <th>№</th>
            <th>Наименование</th>
          </tr>
          </thead>
          <tbody>
          </tbody>
        </table>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>

<a href="#" data-toggle="modal" data-target="#newModal" id="new_modal_window" class="hidden"></a>
<div class="modal fade" id="newModal" tabindex="-1" role="dialog" aria-labelledby="newModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog" style="width:1400px">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="newModalLabel">
          <input type="text" placeholder="Поиск препаратов" onkeyup="filterDrugTemps(this)" class="form-control" style="font-size: 16px; width:400px" id="temp-list-filter" value="">
        </h4>
      </div>
      <div class="modal-body" id="drug-temp-list"></div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>

<script>
  var idx = 1, selected = 0;
  var drugs = [], measures = [];
  <c:forEach items="${drugs}" var="d">
  drugs.push({id: ${d.id}, name: `${d.name}`, measure: `${d.measure.name}`});
  </c:forEach>
  <c:forEach items="${counters}" var="d">
  measures.push({drug: ${d.drug.id}, id: ${d.measure.id}, name: `${d.measure.name}`});
  </c:forEach>
  $(".chzn-select").chosen();
  <c:forEach begin="0" end="${fn:length(rows)}" var="x">
  setSourceCode(${x});
  </c:forEach>
  initCheckers();
  <c:if test="${drug.id == null}">
  //$('#patient-drug-add').slideToggle();
  </c:if>
  /*region Scripts*/
  function setSourceCode(idx) {
    if($('#line_' + idx + ' [name=source_code]').val() === 'own') {
      $('#line_' + idx).find('.source_code_own').show();
      $('#line_' + idx).find('.source_code_cln').hide();
      $('#line_' + idx).find('.measure_select').hide();
      $('#line_' + idx).find('input[name=out_count]').hide();
    } else {
      $('#line_' + idx).find('.source_code_cln').show();
      $('#line_' + idx).find('.source_code_own').hide();
      $('#line_' + idx).find('.measure_select').show();
      $('#line_' + idx).find('input[name=out_count]').show();
    }
  }
  function addDrug() {
    setLocation('drugs.s');
  }
  function addGoal() {
    var pr = prompt('Новая цель! Введите наименование');
    if (pr != null) {
      $.ajax({
        url:'/lv/drug/addgoal.s',
        method:'post',
        data:'goal=' + pr,
        dataType:'json',
        success:function (res) {
          $('select[name=goal]').each(function (elem, dom) {
            var options = dom.options;
            dom.options[options.length] = new Option(pr, res.id);
            $(this).trigger('liszt:updated');
          });
        }
      });
    }
  }
  function save() {
    var elems = $('input,select').filter('[required]:visible');
    var sls = $('.chzn-single').filter(':visible');
    var isErr = false;
    for(var i=0;i<sls.length;i++) {
      if($(sls[i]).hasClass('chzn-default')) {
        sls[i].style.border = '1px solid red';
        isErr = true;
      } else {
        sls[i].style.border = '1px solid #ababab';
      }
    }
    for(var i=0;i<elems.length;i++) {
      if(elems[i].value === '') {
        elems[i].style.border = '1px solid red';
        isErr = true;
      } else {
        elems[i].style.border = '1px solid #ababab';
      }
    }
    if(isErr) {
      alert('Заполните все обязательные поля');
      return;
    }
    if($('#drug-lines').find('tbody').find('tr').length === 0) {
      alert('Список препаратов не может быть пустым');
      return;
    }
    $.ajax({
      url:'/lv/drugs/save.s',
      method:'post',
      data: $('#add_edit_drug').serialize(),
      dataType:'json',
      success:function (res) {
        if(res.success) {
          alert('Данные успешно сохранены');
          setLocation('/lv/drugs.s');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function setTimeCheck(code) {
    var status = $('input[name=' + code + 'Time]').is(':checked');
    if(code === 'morning') {
      $('input[name=morningTimeBefore]').attr('disabled', !status).attr('checked', false);
      $('input[name=morningTimeAfter]').attr('disabled', !status).attr('checked', false);
    }
    if(code === 'noon') {
      $('input[name=noonTimeBefore]').attr('disabled', !status).attr('checked', false);
      $('input[name=noonTimeAfter]').attr('disabled', !status).attr('checked', false);
    }
    if(code === 'evening') {
      $('input[name=eveningTimeBefore]').attr('disabled', !status).attr('checked', false);
      $('input[name=eveningTimeAfter]').attr('disabled', !status).attr('checked', false);
    }
  }
  function newDrugLine() {
    this.idx++;
    var tr = $('<tr id="line_' + this.idx + '"></tr>');
    var td1 = $('<td></td>');
    var rowId = $('<input type="hidden" name="row_id" value="0"/>');
    var sourceCode = $('<select name="source_code" class="form-control" onchange="setSourceCode(' + this.idx + ')"><option value="cln">Клиника</option><option value="own">Свой</option></select>')
    td1.append(sourceCode).append(rowId);
    var td2 = $('<td></td>');
    var nameDiv = $('<div class="source_code_own" style="display: none"></div>');
    var drugName = $('<input type="text" name="drug_name" maxlength="256" value="" class="form-control">')
    nameDiv.append(drugName);
    var drugDiv = $('<div class="source_code_cln" style="width:100%"></div>');
    var drugId = $('<select class="form-control chzn-select" name="drug_drug" onchange="setMeasure(this, ' + this.idx + ')"><option value="0"></option></select>');
    for(var dg of drugs) drugId.append($('<option measure="' + dg.measure + '" value="' + dg.id + '">' + dg.name + '</option>'));
    drugDiv.append(drugId);
    td2.append(nameDiv).append(drugDiv);
    var td3 = $('<td></td>');
    var outInput = $('<input type="number" class="form-control center" value="1" name="out_count"/>');
    td3.append(outInput);
    var td4 = $('<td></td>');
    var measureInput = $('<input class="form-control measure_select" disabled name="drug_measure"/>');
    td4.append(measureInput);
    var td5 = $('<td style="width:30px; text-align:center"></td>');
    var btn = $('<button class="btn btn-sm btn-danger" type="button" style="height:20px;padding:1px 10px" title="Удалить" onclick=\'$("#line_' + this.idx + '").remove()\'><span class="fa fa-minus"></span></button>');
    td5.append(btn);
    tr.append(td1).append(td2).append(td3).append(td4).append(td5);
    $('#drug-lines').find('tbody').append(tr);
    $(".chzn-select").chosen();
  }
  function setMeasure(dom, idx) {
    $('#line_' + idx).find('.measure_select').val(dom.options[dom.selectedIndex].getAttribute("measure"));
  }
  function setPeriod() {
    $.ajax({
      url:'/lv/drugs/setPeriod.s',
      method:'post',
      data: 'begin=' + $('#dateBegin').val() + '&end=' + $('#dateEnd').val(),
      dataType:'json',
      success:function (res) {
        if(res.success) {
          var tr = $('<tr></tr>');
          for(var i=0;i<res.dates.length;i++) {
            var td = $('<td class="bold center">' + res.dates[i].date + '</td>');
            tr.append(td);
          }
          var trs = $('<tr></tr>');
          for(var i=0;i<res.dates.length;i++) {
            var td = $('<td class="bold center hand hover" onclick="setCheckbox()"></td>');
            var input = $('<input type="checkbox" name="date_state" value="' + res.dates[i].date + '"/>');
            if(res.dates[i].state)
              input.attr('checked', true);
            input.val(res.dates[i].date);
            td.append(input).append($('<input type="hidden" name="date_id" value="0"/>'))
                            .append('<input type="hidden" name="dates" value="' + res.dates[i].date + '" />')
                            .append($('<input type="hidden" name="dt_state" value="ENT"/>'));
            trs.append(td);
          }
          $('#period_rows').empty().append(tr);
          $('#period_rows').append(trs);
        } else {
          alert(res.msg);
        }
      }
    });
  }
  //
  function viewDetails(idx) {
    $('#drug-line-' + idx).slideToggle();
  }
  function editDrug(id) {
    document.location = '/lv/drugs.s?id=' + id;
  }
  function initCheckers() {
    var morningStatus = $('input[name=morningTime]').is(':checked');
    var noonStatus = $('input[name=noonTime]').is(':checked');
    var eveningStatus = $('input[name=eveningTime]').is(':checked');
    $('input[name=morningTimeBefore]').attr('disabled', !morningStatus);
    $('input[name=morningTimeAfter]').attr('disabled', !morningStatus);
    $('input[name=noonTimeBefore]').attr('disabled', !noonStatus);
    $('input[name=noonTimeAfter]').attr('disabled', !noonStatus);
    $('input[name=eveningTimeBefore]').attr('disabled', !eveningStatus);
    $('input[name=eveningTimeAfter]').attr('disabled', !eveningStatus);
  }
  function removeDrug(idx, id) {
    if(confirm('Вы действительно хотите удалить выбранную запись?'))
      $.ajax({
        url: '/lv/drugs/removeDrug.s',
        data: 'id=' + id,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно удалены');
            $('#line_' + idx).remove();
          } else
            alert(res.msg);
        }
      });
  }
  function removePatientDrug(id) {
    if(confirm('Вы действительно хотите удалить выбранную запись?'))
      $.ajax({
        url: '/lv/drugs/removePatientDrug.s',
        data: 'id=' + id,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно удалены');
            $('#patient-drug-' + id).remove();
            $('#patient-drug-details-' + id).remove();
          } else
            alert(res.msg);
        }
      });
  }
  function setCheckbox() {
    if(event.target.tagName == 'TD') {
      var elem = event.target.querySelector('INPUT[type=checkbox]');
      if(!elem.disabled)
        elem.click();
    }
  }
  function setDrugType(dom) {
    $('#injection_type_label').toggle(dom.value == 16);
    $('#injection_type').attr('required', dom.value == 16).toggle(dom.value == 16);
  }
  function printObos() {
    window.open('/lv/print.s?obos=Y');
  }
  function saveTemplate() {
    var elems = $('input,select').filter('[required]:visible');
    var sls = $('.chzn-single').filter(':visible');
    var isErr = false;
    for(var i=0;i<sls.length;i++) {
      if($(sls[i]).hasClass('chzn-default')) {
        sls[i].style.border = '1px solid red';
        isErr = true;
      } else {
        sls[i].style.border = '1px solid #ababab';
      }
    }
    for(var i=0;i<elems.length;i++) {
      if(elems[i].value === '') {
        elems[i].style.border = '1px solid red';
        isErr = true;
      } else {
        elems[i].style.border = '1px solid #ababab';
      }
    }
    if(isErr) {
      alert('Заполните все обязательные поля');
      return;
    }
    if($('#drug-lines').find('tbody').find('tr').length === 0) {
      alert('Список препаратов не может быть пустым');
      return;
    }
    $.ajax({
      url:'/lv/drugs/template/save.s',
      method:'post',
      data: 'id=${drug.id}',
      dataType:'json',
      success:function (res) {
        if(res.success) {
          alert('Данные успешно сохранены');
          setLocation('/lv/drugs.s');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function fromTemplate() {
    $('#drug-temp-list').load('drug/temps.s', ()=> {
      $('#new_modal_window').click();
    });
  }
  function filterDrugTemps(dom) {
    event.preventDefault();
    if(event.keyCode == 13) {
      $('#drug-temp-list').load('drug/temps.s?filter=' + dom.value);
    }
  }
  function removeDrugTemp(id) {
    if(confirm('Вы действительно хотите удалить запись?'))
      $.ajax({
        url: '/lv/drug/temp/delete.s',
        data: 'id=' + id,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            $('#drug-row-temp-' + id).remove();
          } else
            alert(res.msg);
        }
      });
  }
  /*endregion*/
</script>
