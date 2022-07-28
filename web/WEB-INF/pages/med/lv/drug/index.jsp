<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
  .autocomplete {
    position: relative;
  }
  .autocomplete-items {
    position: absolute;
    border: 1px solid #d4d4d4;
    z-index: 99;
    left: 3px;
    width: 400px;
  }
  .autocomplete-items div {
    padding: 5px;
    cursor: pointer;
    background-color: #fff;
    border-bottom: 1px solid #d4d4d4;
  }
  /*when hovering an item:*/
  .autocomplete-items div:hover {
    background-color: #e9e9e9;
  }
  /*when navigating through the items using the arrow keys:*/
  .autocomplete-active {
    background-color: DodgerBlue !important;
    color: #ffffff;
  }
</style>
<script>
  var loop = '${fn:length(drugs)}';
  var opts = '';
  <c:forEach items="${goals}" var="goal">
  opts += '<option value="${goal.id}">${goal.name}';
  </c:forEach>
  var templates = [];
  <c:forEach items="${templates}" var="temp">
    var item = {};
    item.label = '${temp.name} - ${temp.doza}';
    item.name = '${temp.name}';
    item.cat = '${temp.cat}';
    item.goal = '${temp.goal}';
    item.doza = '${temp.doza}';
    templates.push(item);
  </c:forEach>
  //
  var cats =
    '<option value="ine-ven">Ин.- Вена ичига</option>' +
    '<option value="ine-mus">Ин.- Мускул орасига</option>' +
    '<option value="ine-ter">Ин.- Тери остига</option>'+
    '<option value="ine-tic">Ин.- Тери ичига</option>'+
    '<option value="ine-suy">Ин.- Суяк ичига</option>'+
    '<option value="ine-art">Ин.- Артерия ичига</option>'+
    '<option value="tab">Таблетка</option>';
  //
  function addRow() {
    var tr = $('<tr></tr>');
    tr.attr('id', 'drugTr' + loop);
    tr.html(
      '<input type=hidden name="id" value=""/><input type=hidden name="idx" value="' + loop + '"/>' +
      '<td class="autocomplete"><input autocomplete="off" type=text class="form-control" required="true" name="drugName"/></td>' +
      '<td width="100"><select class="form-control" name="cat">' + cats + '</select></td>' +
      '<td width="230"><select class="form-control chzn-select" name="goal"></td>' +
      '<td><select class="form-control" name="type"><option value="own">Свой<option value="clin">Кл.</select></td>' +
      '<td align="center"><input type="checkbox" name="morningTime' + loop + '"/></td>' +
      '<td align="center"><input type="checkbox" name="noonTime' + loop + '"/></td>' +
      '<td align="center"><input type="checkbox" name="eveningTime' + loop + '"/></td>' +
      '<td align="center">' +
      '<table width="100%"><tr><td width="20">c</td><td><input class="form-control datepicker" id="startDate' + loop + '" type="text" name="startDate"/></td></tr>' +
      '<tr><td>по</td><td><input class="form-control datepicker" id="endDate' + loop + '" type="text" name="endDate"/></td></tr></table>' +
      '</td>' +
      '<td><input type=text class="form-control" name="note"/></td>'+
      '<td width="30px"><button type=button onclick="delRow(' + loop + ')" class="btn btn-danger btn-xs"><i class="fa fa-minus"></i></button></td>'
    );
    $('table.formTable').append(tr);
    tr.find('select[name=goal]').html(opts);
    initDates();
    loop++;
    $(".chzn-select").chosen();
    var names = document.getElementsByName('drugName');
    for (var i=0;i<names.length;i++)
      autocomplete(names[i], templates);
  }
  function delRow(idx) {
    if (confirm('Вы действительно хотети удалить запись?')) {
      var id = $('#drugTr' + idx).find('input[name=id]').val();
      if (id != '')
        $.ajax({
          url: '/lv/drug/delete.s',
          method: 'post',
          data: 'id=' + id,
          dataType: 'json'
        });
      document.getElementById('drugTr' + idx).remove();
    }
  }
  $(function() {
    $(".chzn-select").chosen();
    var names = document.getElementsByName('drugName');
    for (var i=0;i<names.length;i++)
      autocomplete(names[i], templates);
  });
  function printObos() {
    window.open('/lv/print.s?obos=Y');
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
</script>
<f:form method="post">
  <div class="panel panel-info" style="width: 100% !important; margin: auto">
    <%@include file="/incs/msgs/successError.jsp"%>
    <div class="panel-heading">
      Назначение
      <c:if test="${pat.paid != 'CLOSED'}">
        <button class="btn btn-sm btn-success" style="float:right; margin-top:-5px; margin-left:5px;" onclick="addRow()" type="button">
          <i class="fa fa-plus"></i> Добавить
        </button>
      </c:if>
      <button class="btn btn-sm" title="Обоснование" type="button" onclick="printObos()" style="float:right;margin-top:-5px"><i class="fa fa-print"></i> Обоснование</button>
      <div style="float:right">
        <button class="btn btn-sm hidden" type="button" onclick="setLocation('/lv/drug/home.s')" title="Добавить новые препараты" style="margin-top: -5px"><i class="fa fa-plus"></i> Добавить</button>
        <button class="btn btn-sm btn-success hidden" title="Сохранить" style="margin-top: -5px"><i class="fa fa-check"></i> Сохранить</button>
      </div>
    </div>
    <table class="formTable" style="width:100%">
      <tr>
        <td colspan="4"><b>Пациент(ка):</b> ${fio}</td>
        <td nowrap colspan="7"><b>Год рождения:</b>${birthyear}</td>
      </tr>
      <tr>
        <td rowspan="2" align="center"><b>Наименование</b></td>
        <td rowspan="2" align="center"><b>Категория</b></td>
        <td rowspan="2" align="center">
          <b>Цель</b>
          <a href="#" onclick="addGoal()">
            <b class="fa fa-plus"></b>
          </a>
        </td>
        <td rowspan="2" align="center" width="20"><b>Тип</b></td>
        <td colspan="3" align="center" width="140"><b>Время</b></td>
        <td rowspan="2" align="center"><b>Период</b></td>
        <td rowspan="2" align="center"><b>Доза</b></td>
        <td rowspan="2" align="center" width="20">&nbsp;</td>
      </tr>
      <tr>
        <td align=center style="padding:1px;width:50px;"><b>Утр</b></td>
        <td align=center style="padding:1px;width:50px;"><b>Обед</b></td>
        <td align=center style="padding:1px;width:50px;"><b>Веч</b></td>
      </tr>
      <c:forEach items="${drugs}" var="drug" varStatus="loop">
        <tr id="drugTr${loop.index}">
          <input type="hidden" value="${drug.id}" name="id"/><input type="hidden" name="idx" value="${loop.index}">
          <td class="autocomplete"><input autocomplete="off" type=text class="form-control" required="true" name="drugName" value="${drug.drugName}"/></td>
          <td width="100">
            <select class="form-control" name="cat">
              <option <c:if test="${drug.cat == 'ine-ven'}">selected</c:if> value="ine-ven">Ин.- Вена ичига</option>
              <option <c:if test="${drug.cat == 'ine-mus'}">selected</c:if> value="ine-mus">Ин.- Мускул орасига</option>
              <option <c:if test="${drug.cat == 'ine-ter'}">selected</c:if> value="ine-ter">Ин.- Тери остига</option>
              <option <c:if test="${drug.cat == 'ine-tic'}">selected</c:if> value="ine-tic">Ин.- Тери ичига</option>
              <option <c:if test="${drug.cat == 'ine-suy'}">selected</c:if> value="ine-suy">Ин.- Суяк ичига</option>
              <option <c:if test="${drug.cat == 'ine-art'}">selected</c:if> value="ine-art">Ин.- Артерия ичига</option>
              <option <c:if test="${drug.cat == 'tab'}">selected</c:if> value="tab">Таблетка</option>
            </select>
          </td>
          <td width="230">
            <select class="form-control chzn-select" name="goal">
              <c:forEach items="${goals}" var="gl">
                <option <c:if test="${drug.goal.id == gl.id}">selected</c:if> value="${gl.id}">${gl.name}</option>
              </c:forEach>
            </select>
          </td>
          <td width="75">
            <select class="form-control" name="type">
              <option <c:if test="${drug.type == 'own'}">selected</c:if> value="own">Свой</option>
              <option <c:if test="${drug.type == 'clin'}">selected</c:if> value="clin">Кл.</option>
            </select>
          </td>
          <td align="center"><input type="checkbox" name="morningTime${loop.index}" <c:if test="${drug.morningTime}">checked</c:if> /></td>
          <td align="center"><input type="checkbox" name="noonTime${loop.index}" <c:if test="${drug.noonTime}">checked</c:if> /></td>
          <td align="center"><input type="checkbox" name="eveningTime${loop.index}" <c:if test="${drug.eveningTime}">checked</c:if> /></td>
          <td align="center" style="width:180px;">
            <table width="100%">
              <tr>
                <td width="20">c</td>
                <td><input class="form-control datepicker" id="startDate${loop.index}" type="text" name="startDate" value="${drug.dateStart}"/></td>
              </tr>
              <tr>
                <td>по</td>
                <td><input class="form-control datepicker" id="endDate${loop.index}" type="text" name="endDate" value="${drug.dateEnd}"/></td>
              </tr>
            </table>
          </td>
          <td align="center" width="300"><input type=text class="form-control" name="note" value="${drug.note}"/></td>
          <td align="center" width="20">
            <button type=button class="btn btn-success btn-xs" onclick="saveDrugTemplate(${loop.index})"><i class="fa fa-save"></i></button>
            <button type=button class="btn btn-danger btn-xs" onclick="delRow(${loop.index})"><i class="fa fa-minus"></i></button>
          </td>
        </tr>
      </c:forEach>
    </table>
  </div>
  <input type="submit" id="saveBtn" class="hidden"/>
</f:form>
