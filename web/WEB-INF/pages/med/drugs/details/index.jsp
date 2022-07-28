<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
  .miniGrid {margin-bottom:0!important;}
</style>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Детализация
    <button class="btn <c:if test="${page_code == 'write_off'}">btn-success</c:if> btn-sm" onclick="setPageCode('write_off')" style="width:120px; float:right; margin-left:5px; margin-top:-5px">Списанные</button>
    <button class="btn <c:if test="${page_code == 'rasxod'}">btn-success</c:if> btn-sm" onclick="setPageCode('rasxod')" style="width:120px; float:right; margin-left:5px; margin-top:-5px">Расход</button>
    <button class="btn <c:if test="${page_code == 'saldo'}">btn-success</c:if> btn-sm" onclick="setPageCode('saldo')" style="width:120px; float:right; margin-left:5px; margin-top:-5px">Остаток</button>
    <button class="btn <c:if test="${page_code == 'all'}">btn-success</c:if> btn-sm" onclick="setPageCode('all')" style="width:120px; float:right;margin-left:5px; margin-top:-5px">Все</button>
    <input type="text" placeholder="Поиск..." class="form-control" style="float:right; padding:5px; width:300px; margin-top:-5px" onkeydown="setSearch(event, this)">
  </div>
  <div class="panel-body">
    <table class="miniGrid table table-striped table-bordered" id="saldo_rows">
      <thead>
        <tr>
          <th width="50px">#</th>
          <th>Наименование</th>
          <th>Источник</th>
          <th width="150px">Цена за единицу</th>
          <th width="150px">Количество</th>
          <th width="150px">Расход</th>
          <th width="150px">Остаток</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach items="${rows}" var="row" varStatus="loop">
          <tr id="row_${row.ib}" row_type="${row.c2}" onclick="viewDetail(${row.ib})" class="hover">
            <td align="center">${loop.index + 1}</td>
            <td>${row.c1}</td>
            <td align="center">
              <c:if test="${row.c2 == 'act'}">Приход</c:if>
              <c:if test="${row.c2 == 'saldo'}">Сальдо на начало</c:if>
            </td>
            <td align="right"><fmt:formatNumber value = "${row.c3}" type = "number"/></td>
            <td align="center"><fmt:formatNumber value = "${row.c4}" type = "number"/></td>
            <td align="center"><fmt:formatNumber value = "${row.c6}" type = "number"/></td>
            <td align="center"><fmt:formatNumber value = "${row.c4 - row.c6}" type = "number"/></td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog" style="width:1200px">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel">Детализация: <span id="drug_name" class="bold"></span></h4>
      </div>
      <div class="modal-body">
        <table class="table table-bordered">
          <tr>
            <td colspan="8" class="center bold">Информация</td>
          </tr>
          <tr>
            <td width="15%" class="center bold">Цена</td>
            <td width="10%" align="center" id="drug_price">0</td>
            <td width="15%" class="center bold">Приход</td>
            <td width="10%" align="center" id="drug_count">0</td>
            <td width="15%" class="center bold">Расход</td>
            <td width="10%" align="center" id="rasxod_count">0</td>
            <td width="15%" class="center bold">Всего по детализациям</td>
            <td width="10%" align="center" id="detail_count">0</td>
          </tr>
          <tr>
            <td colspan="8">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="8" class="center bold">Детализация</td>
          </tr>
          <tr>
            <td colspan="8">
              <table class="table miniGrid" id="write_off_rows">
                <thead>
                  <tr>
                    <th>Дата расхода</th>
                    <th>Получатель</th>
                    <th>Количество</th>
                  </tr>
                </thead>
                <tbody></tbody>
              </table>
            </td>
          </tr>
        </table>
      </div>
      <div class="modal-footer">
        <div style="float:left; color:red; font-weight:bold" id="error_text">Ошибка! Расход и детализация не совподает</div>
        <button type="button" class="btn btn-default" id="close-modal" data-dismiss="modal">Закрыть</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<script>
  var drugs = [];
  <c:forEach items="${rows}" var="row" varStatus="loop">
    drugs.push({id: ${row.ib}, name: '${row.c1}', type: '${row.c2}', price: '<fmt:formatNumber value = "${row.c3}" type = "number"/>', counter: '<fmt:formatNumber value = "${row.c4}" type = "number"/>', rasxod: '<fmt:formatNumber value = "${row.c6}" type = "number"/>', saldo: '<fmt:formatNumber value = "${row.c4-row.c6}" type = "number"/>'});
  </c:forEach>
  function viewDetail(id) {
    var type_code = $('#row_' + id).attr('row_type');
    $.ajax({
      url: '/drugs/details.s',
      data: 'id=' + id + '&type=' + type_code,
      method: 'post',
      dataType: 'json',
      success: function (res) {
        $('#error_text').hide();
        if (res.success) {
          $('#write_off_rows').find('tbody').html('');
          $('#drug_name').html(res.name);
          $('#drug_price').html(res.price);
          $('#drug_count').html(res.drug_count);
          $('#rasxod_count').html(res.rasxod);
          $('#detail_count').html(res.counter);
          if(parseFloat(res.rasxod) != parseFloat(res.counter))
            $('#error_text').show();
          res.rows.forEach(dom => {
            var tr = $('<tr></tr>');
            var td1 = $('<td align="center" title="' + dom.doc_id + '">№' + dom.reg_num + ' от ' + dom.reg_date + '</td>');
            var td2 = $('<td align="center" title="' + dom.id + '">' + dom.direction_name + '</td>');
            var td3 = $('<td align="center">' + dom.drug_count + '</td>');
            tr.append(td1).append(td2).append(td3);
            $('#write_off_rows').find('tbody').append(tr);
          });
          $('#modal_window').click();
        } else
          alert(res.msg);
      }
    });
  }
  function setSearch(evt, dom) {
    setTimeout(() => {
      $('#saldo_rows').find('tbody').html('');
      var i=0;
      for(var drug of drugs) {
        if(drug.name.toLowerCase().indexOf(dom.value.toLowerCase()) != -1) {
          var tr = $('<tr id="row_' + drug.id + '" row_type="' + drug.type + '" onclick="viewDetail(' + drug.id + ')"></tr>');
          var td0 = $('<td align="center">' + (++i) + '</td>');
          var td1 = $('<td>' + drug.name + '</td>');
          var td2 = $("<td align='center'>" + (drug.type === 'saldo' ? 'Сальдо на начало' : 'Приход') + "</td>");
          var td3 = $("<td align='right'>" + drug.price + "</td>");
          var td4 = $("<td align='center'>" + drug.counter + "</td>");
          var td5 = $("<td align='center'>" + drug.rasxod + "</td>");
          var td6 = $("<td align='center'>" + drug.saldo + "</td>");
          tr.append(td0).append(td1).append(td2).append(td3).append(td4).append(td5).append(td6);
          $('#saldo_rows').find('tbody').append(tr);
        }
      }
    }, 500);
  }
  function setPageCode(code) {
    setPage("/drugs/details.s?code=" + code)
  }
</script>