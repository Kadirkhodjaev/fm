<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<style>
  .miniGrid thead tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script>
</script>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    Операционный день
    <button  class="btn btn-sm btn-success" onclick="addEditOperday(0)" style="float:right;margin-top:-5px"><i class="fa fa-plus"></i> Добавить</button>
    <button  class="btn btn-sm btn-danger" onclick="closeOperday()" style="float:right; height:30px; margin-top:-5px; margin-right:5px;"><i class="fa fa-close"></i> Закрыть</button>
  </div>
  <div class="panel-body">
    <%@include file="/incs/msgs/successError.jsp"%>
    <div class="table-responsive">
      <table class="miniGrid table table-striped table-bordered">
        <thead>
        <tr>
          <th>&nbsp;</th>
          <th>#</th>
          <th>Дата</th>
          <th>Состояние</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${list}" var="obj">
          <tr>
            <td align="center" width="30px">
              <c:if test="${obj.state == 'OPEN'}">
                <input type="radio" name="operday_id" value="${obj.id}"/>
              </c:if>
            </td>
            <td align="center">${obj.id}</td>
            <td align="center">
              <a href="#" onclick="addEditOperday(this, ${obj.id});return false">
                <fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.operday}" />
              </a>
            </td>
            <td align="center">
              <c:if test="${obj.state == 'OPEN'}">Открыт</c:if>
              <c:if test="${obj.state != 'OPEN'}">Закрыт</c:if>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
    <!-- /.table-responsive -->
  </div>
  <!-- /.panel-body -->
</div>
<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel">Реквизиты опер дня</h4>
      </div>
      <div class="modal-body">
        <form id="addEditForm" name="addEditForm">
          <input type="hidden" name="id" value="" />
          <input type="hidden" name="code" value="category" />
          <table class="table table-bordered">
            <tr>
              <td class="right bold">Опер день*:</td>
              <td>
                <input name="oper_day" id="oper_day" type="text" class="form-control datepicker" />
              </td>
            </tr>
          </table>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" onclick="saveAddEditForm()">Сохранить</button>
        <button type="button" class="btn btn-default" id="close-modal" data-dismiss="modal">Закрыть</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<script>
  function addEditOperday(dom, id) {
    document.getElementById("modal_window").click();
    if(id > 0) {
      $('*[name=id]').val(id);
      $('*[name=oper_day]').val(dom.innerText);
    } else
      addEditForm.reset();
  }
  function saveAddEditForm() {
    if($('#oper_day').val() == '') {
      alert('Опер день не может быть пустым');
      return;
    }
    $.ajax({
      url: '/cashbox/operday.s',
      method: 'post',
      data: $('#addEditForm').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert("<ui:message code="successSave"/>");
          $('#close-modal').click();
          setPage('/cashbox/operday.s');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function closeOperday() {
    const lk = $('input[name=operday_id]').val();
    if(lk > 0)
      if(confirm('Дейтвительно хотите закрыть?')) {
        $.ajax({
          url: '/cashbox/closeOperday.s',
          method: 'post',
          data: 'id=' + lk,
          dataType: 'json',
          success: function (res) {
            if (res.success) {
              setPage('/cashbox/operday.s');
            } else {
              alert(res.msg);
            }
          }
        });
      }
  }
</script>