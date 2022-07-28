<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Реквизиты блюды
  </div>
  <div class="panel-body">
    <form id="addEditForm" name="addEditForm">
      <input type="hidden" name="id" value="${eat.id}" />
      <input type="hidden" name="code" value="eat" />
      <table class="table table-bordered" style="margin:auto; width:500px">
        <tr>
          <td class="right bold">Наименование*:</td>
          <td>
            <input type="text" id="category-name" class="form-control" name="name" value="${eat.name}"/>
          </td>
        </tr>
        <tr>
          <td class="right bold">Категория*:</td>
          <td>
            <select class="form-control" name="type_id">
              <c:forEach items="${types}" var="type">
                <option <c:if test="${eat.type.id == type.id}">selected</c:if> value="${type.id}">${type.name}</option>
              </c:forEach>
            </select>
          </td>
        </tr>
        <tr>
          <td class="right bold">Активный?:</td>
          <td class="left">
            <input type="checkbox" <c:if test="${eat.state == 'A' || eat.id == null}">checked</c:if> name="state" value="Y"/>
          </td>
        </tr>
      </table>
      <fieldset>
        <legend>
          Расходы
          <button  class="btn btn-sm btn-success" type="button" onclick="newProductRow()" style="float:right;margin-top:-5px"><i class="fa fa-plus"></i></button>
        </legend>
        <table class="table table-bordered miniGrid" id="eat-products">
          <thead>
            <tr>
              <th>Наименование продукта</th>
              <th>Количество</th>
              <th>Ед. изм.</th>
              <th style="width: 60px">Удалить</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${norms}" var="norm" varStatus="loop">
              <tr id="rasxod-row-${loop.index}">
                <td>
                  <input type="hidden" name="norm_id" value="${norm.id}">
                  <input type="hidden" readonly name="product" value="${norm.product.id}">
                  <input type="text" class="form-control" readonly value="${norm.product.name}">
                </td>
                <td>
                  <input type="text" class="form-control right" name="rasxod" value="${norm.rasxod}">
                </td>
                <td>
                  <input type="hidden" readonly name="measure" value="${norm.measure.id}">
                  <input type="text" class="form-control" readonly value="${norm.measure.name}">
                </td>
                <td class="center">
                  <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" type="button" title="Удалить" onclick="delEatNormRow(${norm.id}, this)"><i class="fa fa-minus"></i></button>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </fieldset>
    </form>
    <table id="rasxod-row" class="hidden">
      <tr>
        <td>
          <input type="hidden" name="norm_id" value="0">
          <select class="form-control" name="product" onchange="buildMeasureOptions(this)">
            <option value=""></option>
            <c:forEach items="${products}" var="product">
              <option value="${product.id}" data-cat="${product.measureType.id}">${product.name}</option>
            </c:forEach>
          </select>
        </td>
        <td>
          <input type="text" class="form-control right" name="rasxod" value="0">
        </td>
        <td>
          <select class="form-control" name="measure"></select>
        </td>
        <td class="center">
          <button class="btn btn-danger btn-sm" type="button" style="height:20px;padding:1px 10px" title="Удалить" onclick="delEatNormRow(0, this)"><i class="fa fa-minus"></i></button>
        </td>
      </tr>
    </table>
    <div class="modal-footer">
      <button type="button" class="btn btn-primary" onclick="saveEatForm()">Сохранить</button>
      <button type="button" class="btn btn-default" onclick="$('#pager').load('/eats/dict/eats.s');">Назад</button>
    </div>
  </div>
</div>
<script>
  var rasxodRowCount = ${fn:length(norms)};
  var opts = [];
  <c:forEach items="${measures}" var="measure">
    opts.push({id:${measure.id}, name: '${measure.name}', type: '${measure.cat.id}'});
  </c:forEach>
  function saveEatForm() {
    if($('#category-name').val() == '') {
      alert('Наименование не может быть пустым');
      return;
    }
    $.ajax({
      url: '/eats/dict/save.s',
      method: 'post',
      data: $('#addEditForm').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert("<ui:message code="successSave"/>");
          $('#pager').load('/eats/dict/eat/addEdit.s?id=' + res.id);
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function newProductRow(){
    rasxodRowCount++;
    var html = $('#rasxod-row').html();
    $('#eat-products').append(html);
    checkMeasures($(html));
  }
  function checkMeasures(html) {
    html.find('select[name=product]').each((idx, obj) => {
      buildMeasureOptions(obj);
    });
  }
  function buildMeasureOptions(dom) {
    var ops = opts.filter(obj => obj.type === dom.options[dom.selectedIndex].getAttribute("data-cat"));
    var measure = $(dom).parent().parent().find('select[name=measure]');
    measure.html('');
    ops.forEach(obj => {
      measure.append($("<option value='" + obj.id + "' data-cat='" + obj.type + "'>" + obj.name + "</option>"));
    });
  }
  function delEatNormRow(id, btn){
    if(id == 0) {
      $(btn).parent().parent().remove();
    } else {
      $.ajax({
        url: '/eats/dict/delete.s',
        method: 'post',
        data: 'code=eat-product&id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("<ui:message code="successSave"/>");
            $(btn).parent().parent().remove();
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
</script>