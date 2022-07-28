<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
  .miniGrid {margin-bottom:0!important;}
</style>
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/js/common.js" type="text/javascript"></script>
<%--<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Сальдо на начало
    <button class="btn btn-success btn-sm" onclick="saveSaldo()" style="width:120px; float:right; margin-left:5px; margin-top:-5px"><b class="fa fa-save"></b> Сохранить</button>
  </div>
  <div class="panel-body">
    <table class="table table-bordered">
      <tr>
        <td class="center bold">Склад</td>
        <td class="center bold">Препарат</td>
        <td class="center bold">Количественный учет</td>
        <td class="center bold">Остаток</td>
      </tr>
      <tr>
        <td>
          <select class="form-control" required id="direction">
            <c:forEach items="${receivers}" var="cc">
              <option value="${cc.direction.id}">${cc.direction.name}</option>
            </c:forEach>
          </select>
        </td>
        <td>
          <select class="form-control chzn-select" required id="drug_id" onchange="setSaldoDrug(this)">
            <option value=""></option>
            <c:forEach items="${drugs}" var="cc">
              <option value="${cc.id}">${cc.name}</option>
            </c:forEach>
          </select>
        </td>
        <td>
          <select class="form-control" style="width:100%" id="drug_counter"></select>
        </td>
        <td>
          <input type="number" class="form-control right" id="drug_saldo" value="">
        </td>
      </tr>
    </table>
  </div>
</div>--%>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Детализация
    <button class="btn <c:if test="${page_code == 'saldo'}">btn-success</c:if> btn-sm" onclick="setPageCode('saldo')" style="width:120px; float:right; margin-left:5px; margin-top:-5px">Остаток</button>
    <button class="btn <c:if test="${page_code == 'all'}">btn-success</c:if> btn-sm" onclick="setPageCode('all')" style="width:120px; float:right;margin-left:5px; margin-top:-5px">Все</button>
    <div style="float:right; width:200px">
      <select class="form-control" id="saldo_direction" onchange="setSaldoDirection()">
        <option value="">Все</option>
        <c:forEach items="${receivers}" var="cc">
          <option <c:if test="${filter_direction == cc.direction.id}">selected</c:if> value="${cc.direction.id}">${cc.direction.name}</option>
        </c:forEach>
      </select>
    </div>
    <div style="float:right; width:200px; margin-right:5px">
      <input class="form-control" type="text" id="filter_word" placeholder="Поиск..." value="${filter_word}" onkeydown="setSaldoFilter()">
    </div>
    <%--<input type="text" placeholder="Поиск..." class="form-control" style="float:right; padding:5px; width:300px; margin-top:-5px" onkeydown="setSearch(event, this)">--%>
  </div>
  <div class="panel-body">
    <table class="miniGrid table table-striped table-bordered" id="saldo_rows">
      <thead>
      <tr>
        <th width="50px">#</th>
        <th>Склад</th>
        <th>Наименование</th>
        <th>Документ</th>
        <th>Срок</th>
        <th>Приход</th>
        <th>Расход</th>
        <th>Остаток</th>
        <th style="width:40px">Удалить</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach items="${rows}" var="row" varStatus="loop">
        <tr id="row_${row.id}" class="hover" <c:if test="${row.parent_row == 0}">style="color:blue; font-weight: bold"</c:if> <c:if test="${row.parent_row == -1}">style="color:red; font-weight: bold"</c:if>>
          <td align="center">${loop.index + 1}</td>
          <td>${row.direction.name}</td>
          <td>${row.drug.name}</td>
          <td class="center" style="width:250px">
            <c:if test="${row.writeOffRows != null}">
              Акт №${row.writeOffRows.doc.regNum} от <fmt:formatDate pattern="dd.MM.yyyy" value="${row.writeOffRows.doc.regDate}"/>
            </c:if>
            <c:if test="${row.writeOffRows == null}">
              Сальдо
            </c:if>
          </td>
          <td class="center">
            <fmt:formatDate pattern="dd.MM.yyyy" value="${row.writeOffRows.income.endDate}"/>
          </td>
          <td class="right" style="width:150px">
              ${row.drugCount}
          </td>
          <td class="right" style="width:150px">
              ${row.rasxod}
          </td>
          <td class="right" style="width:150px">
              ${row.drugCount - row.rasxod}
          </td>
          <td class="center">
            <c:if test="${row.writeOffRows == null && row.rasxod == 0}">
              <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delSaldoRow(${row.id})"><i class="fa fa-minus"></i></button>
            </c:if>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<script>
  function setSaldoDrug(dom) {
    $('#drug_counter').empty();
    $.ajax({
      url: '/head_nurse/saldo/counter.s',
      data: 'id=' + dom.value,
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          // {id: 561, drug_count: 100, measure_id: 4, measure: "шт"}
          res.rows.forEach((obj) => {
            var opt = $('<option value="' + obj.id + '">' + obj.drug_count + ' - ' + obj.measure + '</option>');
            $('#drug_counter').append(opt);
          });
        } else
          alert(res.msg);
      }
    });
  }
  function saveSaldo() {
    var id = $('#drug_id').val(), counter = $('#drug_counter').val(), saldo = $('#drug_saldo').val(), direction = $('#direction').val();
    if(!(id > 0) || !(counter > 0) || !(saldo > 0) || !(direction > 0)) {
      alert('Проверьте правильность ввода данных. Не все поля заполнены правильно');
      return;
    }
    $.ajax({
      url: '/head_nurse/saldo/save.s',
      data: 'id=' + id + '&counter=' + counter + '&saldo=' + saldo + '&direction=' + direction,
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert('Данные успешно сохранены');
          setPage('/head_nurse/saldo.s');
        } else
          alert(res.msg);
      }
    });
  }
  function setPageCode(code) {
    setPage("/head_nurse/saldo.s?code=" + code)
  }
  function delSaldoRow(id) {
    if(confirm('Вы действительно хотите удалить выбранную запись?')) {
      $.ajax({
        url: '/head_nurse/saldo/row/del.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("<ui:message code="successSave"/>");
            setPage('/head_nurse/saldo.s');
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
  function setSaldoDirection(dom) {
    setPage("/head_nurse/saldo.s?direction=" + $('#saldo_direction').val());
  }
  function setSaldoFilter() {
    if(event.keyCode == 13)
      setPage("/head_nurse/saldo.s?direction=" + $('#saldo_direction').val() + '&filter=' + encodeURIComponent($('#filter_word').val()));
  }
  $(function() {
    $(".chzn-select").chosen();
    $('#filter_word').focus();
  });
</script>
