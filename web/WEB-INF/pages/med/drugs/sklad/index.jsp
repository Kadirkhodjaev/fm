<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script>
  function setCashStat(){
    var start = document.getElementById("period_start");
    var end = document.getElementById("period_end");
    setPage('/drugs/sklad.s?period_start=' + start.value + '&period_end=' + end.value);
  }
  $('#drug-list').hide();
  //
  function details() {
    window.open('/drugs/sklad/details.s');
  }
</script>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Остаток за период
  </div>
  <table class="table table-bordered">
    <tr>
      <td style="width:100px; font-weight:bold; padding:10px; text-align:right">Период:</td>
      <td style="width:140px;padding:5px">
        <input name="period_start" id="period_start" type="text" class="form-control datepicker" value="${period_start}"/>
      </td>
      <td style="width:20px;padding:10px">
        -
      </td>
      <td style="width:140px;padding:5px">
        <input name="period_end" id="period_end" type="text" class="form-control datepicker" value="${period_end}"/>
      </td>
      <td style="vertical-align: middle">
        <button onclick="setCashStat()" class="btn btn-success btn-sm">Поиск</button>
      </td>
      <td align="right" style="vertical-align: middle; padding-right:15px">
        <%--<button class="btn btn-sm btn-primary" onclick="details()">Детализация</button>--%>
      </td>
    </tr>
  </table>
  <div class="panel-body">
    <div class="row">
      <div class="col-lg-3">
        <div class="panel panel-info">
          <div class="panel-heading">
            <div class="row">
              <div class="col-xs-3">
                <i class="fa fa-money fa-5x"></i>
              </div>
              <div class="col-xs-9 text-right">
                <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value = "${saldo_in}" type = "number"/></p>
              </div>
            </div>
          </div>
          <a href="#" onclick="return false;">
            <div class="panel-footer announcement-bottom">
              <div class="row">
                <div class="col-xs-12">
                  Сальдо на начало
                </div>
              </div>
            </div>
          </a>
        </div>
      </div>
      <div class="col-lg-3">
        <div class="panel panel-success">
          <div class="panel-heading">
            <div class="row">
              <div class="col-xs-3">
                <i class="fa fa-money fa-5x"></i>
              </div>
              <div class="col-xs-9 text-right">
                <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value = "${income_sum}" type = "number"/></p>
              </div>
            </div>
          </div>
          <a href="#" onclick="return false;">
            <div class="panel-footer announcement-bottom">
              <div class="row">
                <div class="col-xs-12">
                  Приход
                </div>
              </div>
            </div>
          </a>
        </div>
      </div>
      <div class="col-lg-3">
        <div class="panel panel-green">
          <div class="panel-heading">
            <div class="row">
              <div class="col-xs-3">
                <i class="fa fa-money fa-5x"></i>
              </div>
              <div class="col-xs-9 text-right">
                <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value = "${outcome_sum}" type = "number"/></p>
              </div>
            </div>
          </div>
          <a href="#" onclick="return false;">
            <div class="panel-footer announcement-bottom">
              <div class="row">
                <div class="col-xs-12">
                  Расход
                </div>
              </div>
            </div>
          </a>
        </div>
      </div>
      <div class="col-lg-3">
        <div class="panel panel-default">
          <div class="panel-heading">
            <div class="row">
              <div class="col-xs-3">
                <i class="fa fa-money fa-5x"></i>
              </div>
              <div class="col-xs-9 text-right">
                <p class="announcement-heading" style="font-size:20px"><fmt:formatNumber value = "${saldo_out}" type = "number"/></p>
              </div>
            </div>
          </div>
          <a href="#" onclick="return false;">
            <div class="panel-footer announcement-bottom">
              <div class="row">
                <div class="col-xs-12">
                  Сальдо на конец
                </div>
              </div>
            </div>
          </a>
        </div>
      </div>
    </div>
    <!-- Список препаратов -->
    <div class="panel panel-success" style="margin: auto">
      <div class="panel-heading bold hand" style="height:40px">
        <div class="row">
          <div class="col-lg-8" onclick="$('#drug-list').slideToggle('slow')">
            Реестр препаратов (Остаток на текущий момент)
          </div>
          <div class="col-lg-1 right">
            <button class="btn btn-info btn-sm" style="display: inline; margin-top:-6px; padding:4px 10px;" onclick="excel()">
              <span class="fa fa-file-excel-o"></span>
              Excel
            </button>
          </div>
          <div class="col-lg-3">
            <input type="text" placeholder="Поиск..." class="form-control" style="display: inline; padding:5px; position:relative; top:-4px;" onkeydown="setSearch(event, this)">
          </div>
        </div>
      </div>
      <div class="panel-body" id="drug-list">
        <table class="table miniGrid" id="saldo_rows">
          <thead>
          <tr>
            <th>Наименование</th>
            <th>Остаток</th>
            <th>Цена за единицу</th>
            <th>Сумма</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach items="${rows}" var="row" varStatus="loop">
            <tr>
              <td>${row.c1}</td>
              <td align="center">${row.c2}</td>
              <td align="right"><fmt:formatNumber value = "${row.c4}" type = "number"/></td>
              <td align="right"><fmt:formatNumber value = "${row.c3}" type = "number"/></td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
    <!-- /.table-responsive -->
  </div>
  <!-- /.panel-body -->
</div>
<iframe style="display: none" name="drug_excel"></iframe>
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/js/common.js"></script>
<script>
  var drugs = [];
  <c:forEach items="${rows}" var="row" varStatus="loop">
    drugs.push({name: '${row.c1}', saldo: '${row.c2}', price: '<fmt:formatNumber value = "${row.c4}" type = "number"/>', summ: '<fmt:formatNumber value = "${row.c3}" type = "number"/>'});
  </c:forEach>
  function setSearch(evt, dom) {
    if(dom.value.length > 0)
      $('#drug-list').slideDown('slow');
    setTimeout(() => {
      $('#saldo_rows').find('tbody').html('');
      for(var drug of drugs) {
        if(drug.name.toLowerCase().indexOf(dom.value.toLowerCase()) != -1) {
          var tr = $('<tr></tr>');
          var td1 = $('<td>' + drug.name + '</td>');
          var td2 = $("<td align='center'>" + drug.saldo + "</td>");
          var td3 = $("<td align='right'>" + drug.price + "</td>");
          var td4 = $("<td align='right'>" + drug.summ + "</td>");
          tr.append(td1).append(td2).append(td3).append(td4);
          $('#saldo_rows').find('tbody').append(tr);
        }
      }
    }, 500);
  }
  function excel() {
    drug_excel.location = '/drugs/sklad/excel.s';
  }
</script>