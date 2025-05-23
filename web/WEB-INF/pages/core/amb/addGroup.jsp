<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<script src="/res/js/common.js"></script>
<script>
  function doSave() {
    if (checkForm($('#bf'))) {
      $.ajax({
        url: '/core/amb/group/save.s',
        method: 'post',
        data: $('#bf').serialize(),
        dataType: 'json',
        success: function (res) {
          openMsg(res)
          if (res.success)
            setPage('/core/amb/groups.s');
        }
      });
    }
  }
</script>
<style>
  .table tr td {padding:10px !important;}
</style>
<div class="panel panel-info" style="width: 800px !important; margin: auto">
  <div class="panel-heading">
    Реквизиты услуги
    <ul class="pagination" style="float:right; margin-top:-5px">
      <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="doSave()"><i title="Сохранить" class="fa fa-save"></i> Сохранить</a></li>
    </ul>
  </div>
  <hidden path="id"/>
  <div class="panel-body">
    <form id="bf">
      <input type="hidden" name="id" value="${ser.id}">
      <table class="table table-bordered">
        <tr>
          <td class="bold">Наименование:</td>
          <td><input type="text" class="form-control" value="${ser.name}" name="name" required></td>
        </tr>
        <tr>
          <td class="bold">Процент для партнеров:</td>
          <td><input type="number" class="form-control right" value="${ser.partnerProc}" name="partnerProc" required></td>
        </tr>
        <tr>
          <td class="bold">Процент бонуса (%):</td>
          <td><input type="number" class="form-control right" value="${ser.bonusProc}" name="bonusProc"></td>
        </tr>
        <tr>
          <td class="bold">Процент для сотрудников (%):</td>
          <td><input type="number" class="form-control right" value="${ser.empProc}" name="empProc" required></td>
        </tr>
        <tr>
          <td class="bold">Группа?:</td>
          <td><input type="checkbox" value="A" name="group" <c:if test="${ser.group}">checked</c:if>></td>
        </tr>
        <tr>
          <td class="bold">Физиотерапия?:</td>
          <td><input type="checkbox" value="A" name="fizio" <c:if test="${ser.fizio}">checked</c:if>></td>
        </tr>
        <tr>
          <td class="bold">Активный?:</td>
          <td><input type="checkbox" value="A" name="active" <c:if test="${ser.active}">checked</c:if>></td>
        </tr>
      </table>
    </form>
  </div>
</div>
