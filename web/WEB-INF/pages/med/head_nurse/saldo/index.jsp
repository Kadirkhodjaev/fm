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

<iframe name="saldo_excel" class="hidden" src=""></iframe>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Детализация
    <button class="btn btn-info btn-sm" onclick="printSaldo()" style="width:100px; float:right; margin-left:5px; margin-top:-5px"><b class="fa fa-file-excel-o"></b> Excel</button>
    <button class="btn <c:if test="${page_code == 'saldo'}">btn-success</c:if> btn-sm" onclick="setPageCode('saldo')" style="width:120px; float:right; margin-left:5px; margin-top:-5px">Остаток</button>
    <button class="btn <c:if test="${page_code == 'all'}">btn-success</c:if> btn-sm" onclick="setPageCode('all')" style="width:120px; float:right;margin-left:5px; margin-top:-5px">Все</button>
    <input type="hidden" id="page_code" value="${page_code}">
    <div style="float:right; width:200px">
      <select class="form-control" id="saldo_direction" onchange="reloadPage()">
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
        <th>Ед.изм.</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach items="${rows}" var="row" varStatus="loop">
        <tr id="row_${row.id}" class="hover" title="ID: ${row.id} DRUG:${row.drug.id} Direction: ${row.direction.id}">
          <td align="center">${loop.index + 1}</td>
          <td>${row.direction.name}</td>
          <td>${row.drug.name}</td>
          <td class="center" style="width:250px">
            Акт №${row.outRow.doc.regNum} от <fmt:formatDate pattern="dd.MM.yyyy" value="${row.outRow.doc.regDate}"/>
          </td>
          <td class="center">
            <fmt:formatDate pattern="dd.MM.yyyy" value="${row.outRow.income.endDate}"/>
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
          <td>
            ${row.drug.measure.name}
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<script>
  function reloadPage() {
    setPage("head_nurse/saldo.s?code=" + $('#page_code').val() + "&direction=" + $('#saldo_direction').val() + '&filter=' + encodeURIComponent($('#filter_word').val()) + "&direction=" + $('#saldo_direction').val());
  }
  function setPageCode(code) {
    $('#page_code').val(code);
    reloadPage();
  }
  function setSaldoFilter() {
    if(event.keyCode == 13) {
      reloadPage();
    }
  }
  function printSaldo() {
    saldo_excel.location = "head_nurse/saldo/excel.s?code=" + $('#page_code').val() + "&direction=" + $('#saldo_direction').val() + '&filter=' + encodeURIComponent($('#filter_word').val()) + "&direction=" + $('#saldo_direction').val();
  }
  $(function() {
    $('#filter_word').focus();
  });
</script>
