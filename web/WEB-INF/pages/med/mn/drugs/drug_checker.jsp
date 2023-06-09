<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/bs/metisMenu/metisMenu.min.css" rel="stylesheet">
<link href="/res/bs/sb_admin/css/timeline.css" rel="stylesheet">
<link href="/res/bs/sb_admin/css/sb-admin-2.css" rel="stylesheet">
<link href="/res/bs/morrisjs/morris.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<link href="/res/tinymce/jquery-te-1.4.0.css" rel="stylesheet">

<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/bs/metisMenu/metisMenu.min.js"></script>
<script src="/res/bs/morrisjs/morris.min.js"></script>
<script src="/res/bs/sb_admin/js/sb-admin-2.js"></script>
<script src="/res/js/common.js"></script>
<script src="/res/editor/nicEdit.js" type="text/javascript"></script>
<script src="/res/tinymce/jquery-te-1.4.0.js" type="text/javascript"></script>
<html>
<head>
  <title>Проверка всего баланса</title>
</head>
<style>
  table thead tr td {border:1px solid black; padding:5px; font-weight: bold; text-align: center}
</style>
<script>
  function setRasxod(code, id) {
    if(confirm('Вы действительно хотите исправить значения?')) {
      $('.btn-repair').attr('disabled', true);
      $.ajax({
        url: '/dch/repair.s',
        data: 'code=' + code + '&id=' + id,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (!res.success)
            alert(res.msg);
          document.location = '/dch/checker.s';
        }
      });
    }
  }
  function drug_detail(code, id) {
    $('#drug_detail').load('details.s?code=' + code + '&id=' + id, function() {
      $('#modal_window').click();
    });
  }
  function deleteRow(code, id, main) {
    if(confirm('Вы действительно хотите удалить данную запись?')) {
      $.ajax({
        url: '/dch/delete.s',
        data: 'code=' + code + '&id=' + id,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            $('#drug_detail').load('details.s?code=hn&id=' + main, function(){
              let rasxod = $('#hn_drug_rasxod_' + main).html();
              let inc = $('#hn_drug_in_' + main).html();
              let fact = $('#fact_rasxod').html();
              if(parseFloat(fact) <= parseFloat(inc))
                $('#hn_btn_' + main).css('display', 'inline');
              $('#hn_drug_fact_' + main).html(fact);
              $('#hn_drug_total_' + main).html((parseFloat(fact) - parseFloat(rasxod)));
            });
          } else
            alert(res.msg);
        }
      });
    }
  }
</script>
<body>
<div class="col-lg-12">
  <div class="panel panel-info">
    <div class="panel-heading">
      Аптека
    </div>
    <div class="panel-body">
      <table class="table table-striped table-bordered table-hover grid dataTable hand">
        <thead>
        <tr>
          <td>#</td>
          <td>Name</td>
          <td>Приход</td>
          <td>Расход</td>
          <td>Факт Расход</td>
          <td>Разница</td>
          <td>Исправить</td>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${drug_rows}" var="row" varStatus="loop">
          <tr>
            <td class="center" style="width:40px">${loop.index + 1}</td>
            <td><a href="#" onclick="drug_detail('drug', ${row.id})">${row.drug.name}</a></td>
            <td class="right" style="width:150px">${row.drugCount}</td>
            <td class="right" style="width:150px">${row.rasxod}</td>
            <td class="right" style="width:150px">${row.price}</td>
            <td class="right" style="width:150px">${row.price - row.rasxod}</td>
            <td class="center" style="width:120px">
              <button class="btn btn-success btn-repair" style="height:20px;padding:1px 10px" onclick="setRasxod('drug', ${row.id})"><span class="fa fa-check"></span></button>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div>

<div class="col-lg-12">
  <div class="panel panel-info">
    <div class="panel-heading">
      Склады
    </div>
    <div class="panel-body">
      <table class="table table-striped table-bordered table-hover grid dataTable hand">
        <thead>
        <tr>
          <td>#</td>
          <td>Склад</td>
          <td>Name</td>
          <td>Приход</td>
          <td>Расход</td>
          <td>Факт Расход</td>
          <td>Разница</td>
          <td>Исправить</td>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${hn_rows}" var="row" varStatus="loop">
          <tr title="HNDRUG_ID: ${row.id}">
            <td class="center" style="width:40px">${loop.index + 1}</td>
            <td>${row.direction.name}</td>
            <td><a href="#" onclick="drug_detail('hn', ${row.id})">${row.drug.name}</a></td>
            <td class="right" style="width:150px" id="hn_drug_in_${row.id}">${row.drugCount}</td>
            <td class="right" style="width:150px" id="hn_drug_rasxod_${row.id}">${row.rasxod}</td>
            <td class="right" style="width:150px" id="hn_drug_fact_${row.id}">${row.price}</td>
            <td class="right" style="width:150px" id="hn_drug_total_${row.id}">${row.price - row.rasxod}</td>
            <td class="center" style="width:120px">
              <button class="btn btn-success btn-repair" id="hn_btn_${row.id}" style="height:20px;padding:1px 10px;<c:if test="${row.price > row.drugCount}">display:none</c:if>" onclick="setRasxod('hn', ${row.id})"><span class="fa fa-check"></span></button>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div>

<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog" style="width:800px">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel">Медикамент Приход/Расход</h4>
      </div>
      <div class="modal-body" id="drug_detail"></div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" id="close-modal" data-dismiss="modal">Закрыть</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
</body>
</html>
