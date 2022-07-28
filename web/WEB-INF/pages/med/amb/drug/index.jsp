<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<script src="/res/datepicker/datetimepicker_css.js"></script>
<style>
  #drugAddEdit tr td {padding: 4px}
</style>
<c:if test="${pat.state != 'ARCH'}">
  <div class="panel panel-info" style="width: 100%; margin: auto;">
    <div class="panel-heading">
      Новое назначение
    </div>
    <div class="panel-body" id="patient-drug-add">
      <form name="add_edit_drug" id="add_edit_drug">
        <input type="hidden" name="id" value="${drug.id}">
        <table class="table table-bordered" id="drugAddEdit" style="margin:auto; width:1000px;font-size:12px">
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
            <td class="bold" style="vertical-align: middle">Описание: </td>
            <td colspan="8">
              <input style="width:100%" name="note" type="text" class="form-control" value="${drug.note}">
            </td>
          </tr>
        </table>
      </form>
      <div class="right">
        <button class="btn btn-sm btn-success" type="button" onclick="save()"><i class="fa fa-save"></i> Сохранить</button>
      </div>
    </div>
  </div>
</c:if>
<div class="panel panel-info" style="width: 100%; margin: auto;">
  <div class="panel-heading">
    Лист назначения
  </div>
  <div class="panel-body">
    <table style="width:100%; font-size:13px" class="table table-bordered miniGrid">
      <thead>
      <tr>
        <th class="bold center">Наименование</th>
        <th class="bold center">Описание</th>
        <c:forEach items="${dates}" var="date">
          <th class="center">${date}</th>
        </c:forEach>
        <c:if test="${pat.state != 'ARCH'}">
          <th class="bold center" style="width:30px">Удалить</th>
        </c:if>
      </tr>
      </thead>
      <c:forEach items="${rows}" var="d" varStatus="lp">
        <tr id="patient-drug-${d.id}">
          <td style="vertical-align: middle">
            <c:if test="${pat.state != 'ARCH'}">
            <a href="#" title="Изменить" onclick="editDrug(${d.id})">
              <c:forEach items="${d.rows}" var="row" varStatus="loop">
                ${row.name}  <c:if test="${loop.index + 1 < fn:length(d.rows)}"> + </c:if>
              </c:forEach>
            </a>
            </c:if>
            <c:if test="${pat.state == 'ARCH'}">
              <c:forEach items="${d.rows}" var="row" varStatus="loop">
                ${row.name}  <c:if test="${loop.index + 1 < fn:length(d.rows)}"> + </c:if>
              </c:forEach>
            </c:if>
          </td>
          <td style="vertical-align: middle; width:300px">${d.drugType.name}<c:if test="${d.drugType.id == 16}"> - ${d.injectionType.name}</c:if>; ${d.note}</td>
          <c:forEach var="i" begin="1" end="${fn:length(dates)}" step="1" varStatus="loop">
            <td style="vertical-align:middle; text-align:center">&nbsp;<c:forEach items="${d.dates}" var="date"><c:if test="${date.dateMonth == dates[i-1] && date.checked}"><b class="fa fa-plus"></b></c:if></c:forEach>&nbsp;</td>
          </c:forEach>
          <c:if test="${pat.state != 'ARCH'}">
            <td style="vertical-align: middle; width:20px" class="hand text-center">
              <button class="btn btn-sm btn-danger" type="button" onclick="removePatientDrug(${d.id})">
                <span class="fa fa-minus"></span>
              </button>
            </td>
          </c:if>
        </tr>
      </c:forEach>
    </table>
  </div>
</div>

<script>
  var idx = 1, selected = 0;
  var drugs = [], measures = [];
  <c:forEach items="${drugs}" var="d">
    drugs.push({id: ${d.id}, name: `${d.name}`});
  </c:forEach>
  <c:forEach items="${counters}" var="d">
    measures.push({drug: ${d.drug.id}, id: ${d.measure.id}, name: `${d.measure.name}`});
  </c:forEach>
  <c:forEach begin="0" end="${fn:length(rows)}" var="x">
    setSourceCode(${x});
  </c:forEach>
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
  function setDrugType(dom) {
    $('#injection_type_label').toggle(dom.value == 16);
    $('#injection_type').attr('required', dom.value == 16).toggle(dom.value == 16);
  }
  function setPeriod() {
    $.ajax({
      url:'/amb/drugs/setPeriod.s',
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
    for(var dg of drugs) drugId.append($('<option value="' + dg.id + '">' + dg.name + '</option>'));
    drugDiv.append(drugId);
    td2.append(nameDiv).append(drugDiv);
    var td3 = $('<td></td>');
    var outInput = $('<input type="number" class="form-control center" value="1" name="out_count"/>');
    td3.append(outInput);
    var td4 = $('<td></td>');
    var measureInput = $('<select class="form-control measure_select" name="drug_measure"></select>');
    td4.append(measureInput);
    var td5 = $('<td style="width:30px; text-align:center"></td>');
    var btn = $('<button class="btn btn-sm btn-danger" type="button" style="height:20px;padding:1px 10px" title="Удалить" onclick=\'$("#line_' + this.idx + '").remove()\'><span class="fa fa-minus"></span></button>');
    td5.append(btn);
    tr.append(td1).append(td2).append(td3).append(td4).append(td5);
    $('#drug-lines').find('tbody').append(tr);
    $(".chzn-select").chosen();
  }
  function setMeasure(dom, idx) {
    var elems = measures.filter(obj => obj.drug == dom.value);
    $('#line_' + idx).find('.measure_select').empty();
    elems.forEach(obj => {
      $('#line_' + idx).find('.measure_select').append($('<option value="' + obj.id + '">' + obj.name + '</option>'));
    });
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
      url:'/amb/drug/save.s',
      method:'post',
      data: $('#add_edit_drug').serialize(),
      dataType:'json',
      success:function (res) {
        if(res.success) {
          alert('Данные успешно сохранены');
          $('#amb_drug').load('/amb/drug.s');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function editDrug(id) {
    $('#amb_drug').load('/amb/drug.s?id=' + id);
  }
  function removePatientDrug(id) {
    if(confirm('Вы действительно хотите удалить выбранную запись?'))
      $.ajax({
        url: '/amb/drug/delete.s',
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
</script>
