<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
  function save(){
    $.ajax({
      url : $('#tempForm').attr('action'),
      data : $('#tempForm').serialize(),
      method : $('#tempForm').attr('method'),
      success : function(){
        alert('Данные успешно сохранены');
        openMainPage('/templates/index.s', true);
      }
    });
  }
</script>
<div class="banner" style="padding:1px; height:38px; border-top: 1px solid #eee; margin-top: -5px; margin-left:-5px">
  <table width="100%">
    <tr>
      <td class="bold"><div style="font-size:20px; margin-top: -10px; color: #337ab7">${kdo.name}</div></td>
      <td width="500px" class="right">
        <ul class="pagination" style="margin-top: 5px">
          <li class="paginate_button" tabindex="0"><a href="#" onclick="save(); return false;"><i title="Сохранить" class="fa fa-print"></i> Сохранить</a></li>
        </ul>
      </td>
    </tr>
  </table>
</div>
<form id="tempForm" method="post" action="/templates/edit.s">
  <input type="hidden" name="id" value="${kdo.id}"/>
  <table class="formTable" style="width:800px">
    <tr>
      <td class="bold">Заключение</td>
    </tr>
    <tr>
      <td>
        <textarea name="template" rows="20" cols="110" maxlength="10000">${kdo.template}</textarea>
      </td>
    </tr>
  </table>
</form>