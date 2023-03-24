<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script>
  $('d').html('*').css('font-weight', 'bold').css('color', 'red');
</script>
<iframe onload="doSave()" src="about:blank" id="frmDiv" name="frm" style="display: none"></iframe>
<div class="panel panel-info" style="width: 800px; margin: auto">
  <div class="panel-heading">Реквизиты пользователя</div>
  <form id="nurse_form">
    <div class="panel-body">
      <input type="hidden" name="id" value="${d.id}"/>
      <div class="table-responsive center">
        <div class="row" style="margin:0">
          <div class="col-lg-6">
            <table class="formTable" style="width: 100%">
              <tr>
                <td class="right">Логин<d></d>:</td>
                <td><f:input path="login" class="form-control" type="text" required="true" autocomplete="off"/></td>
              </tr>
              <tr>
                <td class="right">Пароль<c:if test="${user.id == null}"><d></d></c:if>:</td>
                <td><f:input path="password" class="form-control" type="password" autocomplete="off"/></td>
              </tr>
              <tr>
                <td class="right" nowrap>Подтверждения пароля<c:if test="${user.id == null}"><d></d></c:if>:</td>
                <td><input name="confirm_password" class="form-control" type="password" autocomplete="off"/></td>
              </tr>
              <tr>
                <td class="right">ФИО<d></d>:</td>
                <td><f:input path="fio" class="form-control" type="text" required="true" autocomplete="off"/></td>
              </tr>
              <tr>
                <td class="right">Активный?</td>
                <td style="text-align: left"><f:checkbox path="active"/></td>
              </tr>
            </table>
          </div>
        </div>
      </div>
    </div>
  <div class="panel-footer right">
    <button type="button" onclick="setPage('/admin/users/list.s')" class="btn btn-sm btn-default"><i class="fa fa-mail-reply"></i> Назад</button>
    <button type="submit" class="btn btn-sm btn-success"><i class="fa fa-check"></i> Сохранить</button>
  </div>
  </form>
</div>

