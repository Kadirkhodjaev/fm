<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
  function doSave() {
    try {
      var res = frm.document.getElementById('changePass').id;
      $('#mainWindow').html($('#frmDiv').contents().find('html').html());
    } catch(e){}
  }
  function save(){
    var a = document.getElementById('currPass').value;
    var b = document.getElementById('newPass').value;
    var c = document.getElementById('confPass').value;
    if(a == '' || b == '' || c == ''){
      alert('Заполните все поля');
      return;
    }
    if(b != c) {
      alert('Новый пароль и подтверждения не совподает');
      return;
    }
    document.getElementById('changeForm').submit();

  }
</script>
<iframe onload="doSave()" src="about:blank" id="frmDiv" name="frm" style="display: none "></iframe>
<style>
  #changePass tr td {padding:10px}
</style>
<form method="post" target="frm" action="/admin/changePass.s" id="changeForm">
  <div class="panel panel-info" style="width: 500px; margin: auto">
    <div class="panel-heading">Изменить пароль</div>
    <div>
      <%@include file="/incs/msgs/successError.jsp"%>
      <table widht="95%" style="margin:auto" id="changePass">
        <tr>
          <td width="260">Текущий пароль:</td>
          <td><input type="password" name="currPass" id="currPass" class="form-control center" maxlength="16"/></td>
        </tr>
        <tr>
          <td>Новый пароль:</td>
          <td><input type="password" name="newPass" id="newPass" class="form-control center" maxlength="16"/></td>
        </tr>
        <tr>
          <td>Подтверждения нового пароля:</td>
          <td><input type="password" name="confPass" id="confPass" class="form-control center" maxlength="16"/></td>
        </tr>
      </table>
    </div>
    <div class="panel-footer right">
      <button type="button" onclick="setPage('/main.s')" class="btn btn-sm btn-default"><i class="fa fa-mail-reply"></i> Назад</button>
      <button type="button" onclick="save()" class="btn btn-sm btn-success"><i class="fa fa-check"></i> Сохранить</button>
    </div>
  </div>
</form>