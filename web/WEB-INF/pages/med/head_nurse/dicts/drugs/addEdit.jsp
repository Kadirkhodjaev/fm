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
    <span style="font-size:20px">Настройка ед.изм.: ${obj.name}</span>
  </div>
  <div class="panel-body">
    <form id="addEditForm" style="padding:5px">
      <input type="hidden" name="id" id="row_id" value="${obj.id}">
      <table class="table table-bordered" style="width:100%; margin:auto;" id="counter_table">
        <tr>
          <td class="center bold">#</td>
          <td class="center bold">Единица измерения</td>
        </tr>
        <c:forEach items="${measures}" var="row">
          <tr class="hover" onclick="setCheck(${row.id})">
            <td class="center">
              <input id="measure_${row.id}" type="checkbox" name="measure_id" <c:if test="${row.active}">checked</c:if>>
            </td>
            <td>${row.name}</td>
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
  function setCheck(id) {
    $('#measure_' + id).attr('checked', !$('#measure_' + id).is(':checked'));
  }
  function saveCountRows() {
    var measures = $('select[name=measure]');
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
