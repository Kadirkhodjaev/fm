<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Мониторинг → «Проверка расходов» (отдельное окно, только для администратора): расхождения учётного и фактического расхода --%>
<html>
<head>
  <meta charset="UTF-8">
  <title>Проверка расходов</title>
  <link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
  <script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
  <script src="/res/js/common.js?v=2026101501"></script>
  <%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
  <style>
    html, body { height:100%; margin:0; background:#F5F6F8; }
    .ck-wrap { max-width:1300px; margin:0 auto; padding:14px; display:flex; flex-direction:column; gap:12px; }
    .ck-card { background:#fff; border:1px solid #E6E8EC; border-radius:14px; overflow:hidden; }
    .ck-h { display:flex; align-items:center; gap:10px; padding:12px 16px; border-bottom:1px solid #F0F1F4; font-weight:700; font-size:15px; }
    .ck-h .fm-count { font-weight:500; }
    .ck-card .fm-grid td.r, .ck-card .fm-grid th.r { text-align:right; font-variant-numeric:tabular-nums; }
    .ck-card .fm-grid td.bad { color:#A50F22; font-weight:700; }
    .ck-card .fm-grid a { color:#1F2430; font-weight:600; text-decoration:none; border-bottom:1px dashed #9AA1AC; }
    .modal-content { border:0; border-radius:16px; }
  </style>
</head>
<body class="fm-page" style="height:auto">
<div class="ck-wrap">
  <div class="fm-toolbar" style="background:#fff; border:1px solid #E6E8EC; border-radius:14px">
    <div class="fm-title">
      <span class="ic"><i class="fa fa-check-square-o"></i></span>
      <div><h2>Проверка расходов</h2><span class="fm-count">учётный и фактический расход по партиям; «Исправить» записывает фактический расход</span></div>
    </div>
    <span class="fm-spacer"></span>
    <button type="button" class="fm-btn" onclick="self.close()"><i class="fa fa-times"></i>Закрыть</button>
  </div>

  <div class="ck-card">
    <div class="ck-h">Аптека <span class="fm-count">${fn:length(drug_rows)}</span></div>
    <table class="fm-grid">
      <thead>
      <tr>
        <th style="width:50px">#</th>
        <th>Препарат</th>
        <th class="r" style="width:130px">Приход</th>
        <th class="r" style="width:130px">Расход</th>
        <th class="r" style="width:130px">Факт расход</th>
        <th class="r" style="width:130px">Разница</th>
        <th style="width:120px"></th>
      </tr>
      </thead>
      <tbody>
      <c:forEach items="${drug_rows}" var="row" varStatus="loop">
        <tr>
          <td class="mut">${loop.index + 1}</td>
          <td><a href="#" onclick="drug_detail('drug', ${row.id}); return false">${row.drug.name}</a></td>
          <td class="r">${row.counter}</td>
          <td class="r">${row.rasxod}</td>
          <td class="r">${row.price}</td>
          <td class="r ${row.price - row.rasxod != 0 ? 'bad' : ''}">${row.price - row.rasxod}</td>
          <td class="r"><button type="button" class="fm-btn btn-repair" onclick="setRasxod('drug', ${row.id})"><i class="fa fa-check"></i>Исправить</button></td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
    <c:if test="${empty drug_rows}"><div class="fm-empty" style="display:block"><i class="fa fa-check"></i>Расхождений нет</div></c:if>
  </div>

  <div class="ck-card">
    <div class="ck-h">Склады <span class="fm-count">${fn:length(hn_rows)}</span></div>
    <table class="fm-grid">
      <thead>
      <tr>
        <th style="width:50px">#</th>
        <th style="width:220px">Склад</th>
        <th>Препарат</th>
        <th class="r" style="width:120px">Приход</th>
        <th class="r" style="width:120px">Расход</th>
        <th class="r" style="width:120px">Факт расход</th>
        <th class="r" style="width:120px">Разница</th>
        <th style="width:120px"></th>
      </tr>
      </thead>
      <tbody>
      <c:forEach items="${hn_rows}" var="row" varStatus="loop">
        <tr title="HNDRUG_ID: ${row.id}">
          <td class="mut">${loop.index + 1}</td>
          <td class="mut">${row.direction.name}</td>
          <td><a href="#" onclick="drug_detail('hn', ${row.id}); return false">${row.drug.name}</a></td>
          <td class="r" id="hn_drug_in_${row.id}">${row.drugCount}</td>
          <td class="r" id="hn_drug_rasxod_${row.id}">${row.rasxod}</td>
          <td class="r" id="hn_drug_fact_${row.id}">${row.price}</td>
          <td class="r bad" id="hn_drug_total_${row.id}">${row.price - row.rasxod}</td>
          <td class="r"><button type="button" class="fm-btn btn-repair" id="hn_btn_${row.id}" style="<c:if test="${row.price > row.drugCount}">display:none</c:if>" onclick="setRasxod('hn', ${row.id})"><i class="fa fa-check"></i>Исправить</button></td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
    <c:if test="${empty hn_rows}"><div class="fm-empty" style="display:block"><i class="fa fa-check"></i>Расхождений нет</div></c:if>
  </div>
</div>

<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">
  <div class="modal-dialog" style="width:800px">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" style="font-weight:700">Приход и расход партии</h4>
      </div>
      <div class="modal-body" id="drug_detail"></div>
    </div>
  </div>
</div>
<script>
  function setRasxod(code, id) {
    FmsConfirm('Записать фактический расход вместо учётного?', function () {
      $('.btn-repair').prop('disabled', true);
      $.ajax({
        url: '/dch/repair.s', data: 'code=' + code + '&id=' + id, method: 'post', dataType: 'json',
        success: function (res) {
          if (!res.success) { FmsToast.show(res.msg, 'err'); $('.btn-repair').prop('disabled', false); return; }
          document.location = '/dch/checker.s';
        },
        error: function () { $('.btn-repair').prop('disabled', false); }
      });
    }, {ok: 'Исправить'});
  }
  function drug_detail(code, id) {
    $('#drug_detail').load('details.s?code=' + code + '&id=' + id, function () { $('#modal_window').click(); });
  }
  function deleteRow(code, id, main) {
    FmsConfirm('Удалить эту запись расхода?', function () {
      $.ajax({
        url: '/dch/delete.s', data: 'code=' + code + '&id=' + id, method: 'post', dataType: 'json',
        success: function (res) {
          if (!res.success) { FmsToast.show(res.msg, 'err'); return; }
          $('#drug_detail').load('details.s?code=hn&id=' + main, function () {
            var rasxod = $('#hn_drug_rasxod_' + main).html(), inc = $('#hn_drug_in_' + main).html(), fact = $('#fact_rasxod').html();
            if (parseFloat(fact) <= parseFloat(inc)) $('#hn_btn_' + main).css('display', '');
            $('#hn_drug_fact_' + main).html(fact);
            $('#hn_drug_total_' + main).html(parseFloat(fact) - parseFloat(rasxod));
          });
        }
      });
    });
  }
</script>
</body>
</html>
