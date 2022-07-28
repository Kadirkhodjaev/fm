<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/js/common.js" type="text/javascript"></script>

<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    <span style="font-size:20px">Количественный учет: ${obj.name}</span>
    <button  class="btn btn-sm btn-info" onclick="addCountRow()" style="float:right;margin-left:10px;"><i class="fa fa-plus"></i></button>
  </div>
  <div class="panel-body">
    <form id="addEditForm" style="padding:5px">
      <input type="hidden" name="id" id="row_id" value="${obj.id}">
      <table class="table table-bordered" style="width:100%; margin:auto;" id="counter_table">
        <tr>
          <td class="center bold">Количество</td>
          <td class="center bold">Единица измерения</td>
          <th style="width:40px">Удалить</th>
        </tr>
        <c:forEach items="${rows}" var="row">
          <tr>
            <td><input type="hidden" name="ids" value="${row.id}"><input type="number" class="form-control center" name="counter" value="${row.drugCount}"></td>
            <td>
              <select class="form-control" name="measure">
                <c:forEach items="${measures}" var="measure">
                  <option <c:if test="${row.measure.id == measure.id}">selected</c:if> value="${measure.id}">${measure.name}</option>
                </c:forEach>
              </select>
            </td>
            <td class="center">
              <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delCountRow(${row.id})"><i class="fa fa-minus"></i></button>
            </td>
          </tr>
        </c:forEach>
      </table>
    </form>
  </div>
  <!-- /.panel-body -->
</div>
<div class="modal-footer">
  <button type="button" class="btn btn-primary" onclick="saveCountRows()">Сохранить</button>
  <button type="button" class="btn btn-default" id="close-modal" data-dismiss="modal">Закрыть</button>
</div>
<script>
  var ops = '<option></option>';
  <c:forEach items="${measures}" var="measure">
    ops += '<option value="${measure.id}">${measure.name}</option>';
  </c:forEach>
  function addCountRow() {
    var tr = $('<tr></tr>');
    var td = $('<td><input type="hidden" name="ids" value="0"><input type="number" class="form-control center" name="counter" value=""/></td>');
    var td1 = $('<td><select class="form-control" name="measure">' + ops + '</select></td>');
    tr.append(td).append(td1);
    $('#counter_table').append(tr);
  }
  function delCountRow(id) {
    if(confirm('Вы действительно хотите удалить?')) {
      $.ajax({
        url: '/head_nurse/dicts/drug/del.s',
        data: 'id=' + id,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно удалены');
            setPage('/head_nurse/dicts/drug/info.s?id=${obj.id}');
          } else
            alert(res.msg);
        }
      });
    }
  }
  function saveCountRows() {
    var counts = $('input[name=counter]');
    var measures = $('select[name=measure]');
    counts.each((idx, dom) => {
      if(dom.value === '' || dom.value === 0 || dom.value < 0) {
        alert('Неправильный формат в поле количество в строке: ' + (idx + 1));
        return;
      }
    });
    measures.each((idx, dom) => {
      if(dom.value === '' || dom.value === 0 || dom.value < 0) {
        alert('Неправильный формат в поле Ед. изм. в строке: ' + (idx + 1));
        return;
      }
    });
    $.ajax({
      url: '/head_nurse/dicts/drug/info.s',
      data: $('#addEditForm').serialize(),
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert('Данные успешно сохранены');
          document.getElementById("close-modal").click();
          $('#res_${obj.id}').html(res.res);
        } else
          alert(res.msg);
      }
    });
  }
</script>