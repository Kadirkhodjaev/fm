<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/js/common.js" type="text/javascript"></script>

<div class="panel panel-info" style="width: 80%; margin: auto">
  <div class="panel-heading">
    <span style="font-weight: bold; font-size:16px" title="${obj.id}">ИБ №${obj.yearNum} - ${obj.surname} ${obj.name} ${obj.middlename}</span>
    <button  class="btn btn-sm" onclick="setPage('/head_nurse/total/patients.s')" style="float:right;margin-top:-5px; margin-left:10px"><i class="fa fa-backward"></i> Назад</button>
    <c:if test="${parent == null}">
      <button  class="btn btn-sm btn-info" onclick="confirmPatient()" style="float:right;margin-top:-5px; margin-left:5px"><i class="fa fa-check"></i> Подтвердить</button>
    </c:if>
  </div>
  <div class="panel-body">
    <form id="addEditForm" style="padding:5px">
      <input type="hidden" name="id" id="row_id" value="${obj.id}">
      <input type="hidden" name="patient_id" id="patient_id" value="${obj.id}">
      <table class="table table-bordered" style="width:100%; margin:auto;">
        <tr>
          <td style="text-align:right;font-weight:bold;vertical-align: middle">Год рождения: </td>
          <td><input type="text" disabled id="birth_year" class="form-control center" value="${obj.birthyear}"></td>
          <td style="text-align:right;font-weight:bold;vertical-align: middle">Дата поступления: </td>
          <td><input type="text" disabled id="start_date" class="form-control center" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.dateBegin}" />"></td>
          <td style="text-align:right;font-weight:bold;vertical-align: middle">Дата выписки: </td>
          <td><input type="text" disabled id="end_date" class="form-control center" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.dateEnd}" />"></td>
          <td style="text-align:right;font-weight:bold;vertical-align: middle">Палата: </td>
          <td><input type="text" disabled id="palata" class="form-control center" value="${obj.room.name}"></td>
        </tr>
      </table>
    </form>
  </div>
  <!-- /.panel-body -->
</div>
<div class="panel panel-info" style="width: 80%; margin: auto">
  <div class="panel-heading">
    Расходы по дням
  </div>
  <div class="panel-body">
    <table class="table table-bordered miniGrid">
      <thead>
      <tr>
        <th style="width:50px">№</th>
        <th>Склад</th>
        <th style="width:100px">Дата</th>
        <th style="width:100px">Состояние</th>
      </tr>
      </thead>
      <c:forEach items="${dates}" var="d" varStatus="lp">
        <tr class="hand hover" ondblclick="setPage('head_nurse/out/patient/save.s?id=${d.c1}')">
          <td align="center">${lp.index + 1}</td>
          <td>${d.c2}</td>
          <td align="center">${d.c3}</td>
          <td align="center">
            <c:if test="${d.c4 == 'ENT'}">Введен</c:if>
            <c:if test="${d.c4 != 'ENT'}">Подтвержден</c:if>
          </td>
        </tr>
      </c:forEach>
    </table>
  </div>
  <!-- /.panel-body -->
</div>
<div class="panel panel-info" style="width: 80%; margin: auto">
  <div class="panel-heading">
    Записи
    <c:if test="${parent != null && parent.closed == 'N'}">
      <button  class="btn btn-sm btn-default" onclick="updateDrugs()" style="float:right;margin-top:-5px; margin-left:5px"><i class="fa fa-refresh"></i> Обновить</button>
    </c:if>
  </div>
  <c:if test="${fn:length(rows) > 0}">
    <div class="panel-body">
      <table class="table table-bordered miniGrid">
        <thead>
        <tr>
          <th style="width:50px">№</th>
          <th>Наименование</th>
          <th style="width:100px">Расход</th>
          <th style="width:100px">Ед. изм.</th>
        </tr>
        </thead>
        <c:forEach items="${rows}" var="d" varStatus="lp">
          <tr class="hand hover">
            <td align="center">${lp.index + 1}</td>
            <td>${d.c1}</td>
            <td align="right">${d.c2}</td>
            <td>${d.c3}</td>
          </tr>
        </c:forEach>
      </table>
    </div>
  </c:if>
  <!-- /.panel-body -->
</div>
<script>
  function confirmPatient() {
    if(confirm('Дейтвительно хотите подтвердить документ?')) {
      $.ajax({
        url: '/head_nurse/total/patients/confirm.s',
        data: 'id=${obj.id}',
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            parent.setPage('/head_nurse/total/patients/info.s?id=${obj.id}');
          } else
            alert(res.msg);
        }
      });
    }
  }
  function updateDrugs() {
    if(confirm('Дейтвительно хотите препараты с бухгалтерией?')) {
      $.ajax({
        url: '/head_nurse/total/patients/update.s',
        data: 'id=${parent.id}',
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            parent.setPage('/head_nurse/total/patients/info.s?id=${obj.id}');
          } else
            alert(res.msg);
        }
      });
    }
  }
</script>