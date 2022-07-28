<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions"%>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<script src="/res/js/common.js"></script>
<script>
  var ln = '${fn:length(rows)}';
  function doSaved() {
    if (checkForm($('#bf'))) {
      $.ajax({
        url: '/admin/addAmb.s',
        method: 'post',
        data: $('#bf').serialize(),
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            setPage('/admin/amb.s');
          }
        }
      });
    }
  }
  function addRow() {
    ln++;
    var r = $('<tr id="row-' + (ln-1) + '"><td class="bold">Наименование</td><td><input class="form-control" type="text" name="names"/></td><td style="width:10px;" class="center"><button type="button" onclick="deleteRow(' + (ln-1) + ')" class="btn btn-danger btn-sm"><i class="fa fa-minus"></i></button></td></tr>')
    $('#rows-id').append(r);
  }
  function deleteRow(id) {
    $('#row-' + id).remove();
  }
</script>
<style>
  .table tr td {padding:10px !important;}
</style>
<div class="panel panel-info" style="width: 800px !important; margin: auto">
  <div class="panel-heading">
    Реквизиты услуги
    <ul class="pagination" style="float:right; margin-top:-5px">
      <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="doSaved()"><i title="Сохранить" class="fa fa-save"></i> Сохранить</a></li>
    </ul>
  </div>
  <hidden path="id"/>
  <div class="panel-body">
    <form id="bf">
      <input type="hidden" name="id" value="${ser.id}">
      <table class="table table-bordered">
        <tr>
          <td class="bold">Категория:</td>
          <td>
            <select name="group" class="form-control" required>
              <option value="">Не выбрано</option>
              <c:forEach items="${groups}" var="t">
                <option <c:if test="${ser.group.id == t.id}">selected</c:if> value="${t.id}">${t.name}</option>
              </c:forEach>
            </select>
          </td>
        </tr>
        <tr>
          <td class="bold">Наименование:</td>
          <td><input type="text" class="form-control" value="${ser.name}" name="name" required></td>
        </tr>
        <tr>
          <td class="bold">Стоимость:</td>
          <td><input type="text" class="form-control right" value="${ser.price}" name="price" required></td>
        </tr>
        <tr>
          <td class="bold">Стоимость (Иностранцы):</td>
          <td><input type="text" class="form-control right" value="${ser.for_price}" name="for_price" required></td>
        </tr>
        <tr>
          <td class="bold">Активный?:</td>
          <td><input type="checkbox" value="A" name="state" <c:if test="${ser.state == 'A'}">checked</c:if>></td>
        </tr>
        <tr>
          <td class="bold">Консультация?:</td>
          <td><input type="checkbox" value="Y" name="consul" <c:if test="${ser.consul == 'Y'}">checked</c:if>></td>
        </tr>
        <tr>
          <td class="bold">Форма:</td>
          <td>
            <select name="form_id" class="form-control" onchange="setAmbForm(this.value)">
              <option value="-1">Ручная настройка</option>
              <c:forEach items="${forms}" var="t">
                <option <c:if test="${ser.form_id == t.id}">selected</c:if> value="${t.id}">${t.id} - ${t.name}</option>
              </c:forEach>
            </select>
          </td>
        </tr>
        <tr class="default-form">
          <td class="bold">Поле диагноз?:</td>
          <td><input type="checkbox" value="Y" name="diagnoz" <c:if test="${ser.diagnoz == 'Y'}">checked</c:if>></td>
        </tr>
        <tr class="form-777">
          <td class="bold">Единица изм:</td>
          <td><input type="text" value="${ser.ei}" class="form-control" name="ei"></td>
        </tr>
        <tr class="form-777">
          <td class="bold">Норма с:</td>
          <td><input type="text" value="${ser.normaFrom}" class="form-control" name="normaFrom"></td>
        </tr>
        <tr class="form-777">
          <td class="bold">Норма по:</td>
          <td><input type="text" value="${ser.normaTo}" class="form-control" name="normaTo"></td>
        </tr>
      </table>
      <fieldset class="default-form">
        <legend>Поля</legend>
        <table class="table table-bordered" id="rows-id">
          <c:forEach items="${rows}" var="row" varStatus="loop">
            <tr id="row-${loop.index}">
              <td class="bold">Наименование</td>
              <td><input type="text" name="names" class="form-control" value="${row.name}"></td>
              <td style="width:10px"><button type="button" onclick="deleteRow(${loop.index})" class="btn btn-danger btn-sm"><i class="fa fa-minus"></i></button></td>
            </tr>
          </c:forEach>
        </table>
        <button class="btn btn-success btn-sm" type="button" onclick="addRow()" style="float:right"><i class="fa fa-plus"></i> Добавить поля</button>
      </fieldset>
    </form>
  </div>
</div>
<script>
  function setAmbForm(id){
    if(id > 0) {
      $('.default-form').hide();
      if(id == 777) {
        $('.form-777').show();
      } else {
        $('.form-777').hide();
      }
    } else {
      $('.form-777').hide();
      $('.default-form').show();
    }
  }
  setAmbForm(${ser.form_id});
</script>