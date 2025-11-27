<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<div class="panel panel-info" style="width: 80%; margin: auto">
  <div class="panel-heading">
    Новая запись
  </div>
  <div class="panel-body">
    <table class="table table-bordered" style="width:100%; margin:auto">
      <tr>
        <td>
          <select class="form-control chzn-select" style="width:100%" required id="drug_id">
            <option></option>
            <c:forEach items="${drugs}" var="cc">
              <option value="${cc.id}">${cc.name}</option>
            </c:forEach>
          </select>
        </td>
        <td class="wpx-40 text-center">
          <button class="btn btn-success btn-icon" onclick="addNorma()"> <i class="fa fa-plus"></i></button>
        </td>
      </tr>
    </table>
  </div>
  <!-- /.panel-body -->
</div>

<div class="panel panel-info" style="width: 80%; margin: auto">
  <div class="panel-heading">
    Записы
  </div>
  <div class="panel-body">
    <table class="table-grid">
      <tr>
        <td class="text-center bold">#</td>
        <td class="text-center bold">#D</td>
        <td class="text-center bold">Наименование</td>
        <td class="text-center bold">Тип</td>
        <td class="text-center bold">Значение</td>
        <td class="text-center bold">Таб. в плас.</td>
      </tr>
      <c:forEach items="${rows}" var="r">
        <tr class="hover hand" ondblclick="$('#pager').load('/drugs/dict/drug/normas/view.s?id=' + ${r.drug.id})">
          <td class="center">${r.id}</td>
          <td class="center">${r.drug.id}</td>
          <td>${r.drug.name}</td>
          <td class="text-center">
            <c:if test="${r.normaType == 'ALL'}">Для всех</c:if>
            <c:if test="${r.normaType == 'MULTI'}">По складам</c:if>
          </td>
          <td class="text-right">
            <c:if test="${r.normaType == 'ALL'}">
              <input type="number" value="${r.norma}" class="form-control text-right" onchange="setNormaValue(${r.id}, this.value, 'norma')"/>
            </c:if>
          </td>
          <td class="text-right">
            <input type="number" value="${r.tab}" class="form-control text-right" onchange="setNormaValue(${r.id}, this.value, 'tab')"/>
          </td>
          <td class="text-center wpx-40">
            <button class="btn btn-danger btn-icon" onclick="delNorma(${r.id})"><i class="fa fa-minus"></i></button>
          </td>
        </tr>
      </c:forEach>
    </table>
  </div>
  <!-- /.panel-body -->
</div>

<script>
function setNormaValue(id, val, type) {
  $.ajax({
    url: '/drugs/dict/drug/norma/set.s',
    method: 'post',
    data: 'id=' + id + '&type=' + type + '&val=' + val,
    dataType: 'json',
    success: function (res) {
      openMsg(res);
    }
  });
}

function addNorma() {
    let dom = getDOM('drug_id');
    let drug = dom.options[dom.selectedIndex].text;
    let id = dom.options[dom.selectedIndex].value;
    if(drug == null || drug === '') {
      openMedMsg('Препарат не выбран', false);
      return;
    }
    $('#pager').load('/drugs/dict/drug/normas/view.s?id=' + id);
  }
  function delNorma(id) {
    if(confirm('Вы действительно хотите удалить выбранную запись?')) {
      $.ajax({
        url: '/drugs/dict/drug/norma/del.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          $('#pager').load('/drugs/dict/drug/normas.s');
        }
      });
    }
  }
  $(function(){
    $(".chzn-select").chosen();
  });
</script>
