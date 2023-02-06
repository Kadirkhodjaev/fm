<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<style>
  .miniGrid tr th {text-align: center; background: #e8e8e8}
  .miniGrid tr.selected {background: #e8e8e8}
  .miniGrid tr:hover {background: #ababab; cursor: pointer}
</style>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Анализ медикаментов для заказа
    <div style="float:right; width:200px">
      <table style="width:100%">
        <tr>
          <td style="text-align: right; padding-right:5px">Кол-во дней: </td>
          <td style="width:100px"><input type="number" class="form-control center" onkeydown="setDays(this, event)" value="${days}"></td>
        </tr>
      </table>
    </div>
  </div>
  <div class="panel-body">
    <table class="table table-bordered miniGrid">
      <tr>
        <th rowspan="2">#</th>
        <th rowspan="2" style="vertical-align: middle">Наименование</th>
        <th colspan="2" style="vertical-align: middle">Расход</th>
        <th colspan="2" style="vertical-align: middle">Средное значение</th>
        <th colspan="2" style="vertical-align: middle">Остаток</th>
        <th style="vertical-align: middle">Запас</th>
      </tr>
      <tr>
        <th>Кол-во</th>
        <th>Сумма</th>
        <th>Кол-во</th>
        <th>Сумма</th>
        <th>Кол-во</th>
        <th>Сумма</th>
        <th>Кол-во дней</th>
      </tr>
      <c:forEach items="${rows}" var="rw" varStatus="loop">
        <fmt:parseNumber var = "c3" type = "number" value = "${rw.c3}" />
        <fmt:parseNumber var = "c4" type = "number" value = "${rw.c4}" />
        <fmt:parseNumber var = "c5" type = "number" value = "${rw.c5}" />
        <fmt:parseNumber var = "c6" type = "number" value = "${rw.c6}" />
        <fmt:parseNumber var = "c7" type = "number" value = "${rw.c7}" />
        <fmt:parseNumber var = "c8" type = "number" value = "${rw.c8}" />
        <fmt:parseNumber var = "c9" type = "number" value = "${rw.c9}" />
        <tr id="row_${rw.ib}" onclick="setRow(${rw.c1})">
          <td class="center">${loop.index + 1}</td>
          <td>${rw.c2}</td>
          <td class="right"><fmt:formatNumber value="${rw.c3}" type="number"/></td>
          <td class="right"><fmt:formatNumber value="${rw.c4}" type="number"/></td>
          <td class="right"><fmt:formatNumber value="${rw.c5}" type="number"/></td>
          <td class="right"><fmt:formatNumber value="${rw.c6}" type="number"/></td>
          <td class="right"><fmt:formatNumber value="${rw.c7}" type="number"/></td>
          <td class="right"><fmt:formatNumber value="${rw.c8}" type="number"/></td>
          <td class="right"><fmt:formatNumber value="${rw.c9}" type="number"/></td>
        </tr>
      </c:forEach>
    </table>
  </div>
</div>
<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog" style="width:1400px">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel">Медикамент:<span id="drug_name"></span></h4>
      </div>
      <div class="modal-body" id="drug_analys">

      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<script>
  function setDays(dom, evt) {
    if(evt.keyCode == 13 && dom.value > 0) {
      setPage('/mn/drugs/days.s?days=' + dom.value);
    }
  }
  function drugAnalys(id, name) {
    $('#drug_name').html(id + ' ' + name);
    $('#drug_analys').load('/mn/drug/analys.s?id=' + id, () => {
      $('#modal_window').click();
    });
  }
  function setRow(id) {
    $('tr.selected').removeClass('selected');
    $('#row_' + id).addClass('selected');
  }
</script>
