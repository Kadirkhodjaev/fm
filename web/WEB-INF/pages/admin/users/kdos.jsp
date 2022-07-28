<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
  function doSave(){
    $('#closeBtn').click();
    bf.submit();
  }
</script>
<div class="modal-dialog" style="width: 400px">
  <div class="modal-content">
    <form action="/admin/users/kdos.s" target="frm" method="post" name="bf">
      <input type="hidden" value="${userId}" name="userId" />
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel">Доступные КДО</h4>
      </div>
      <div class="modal-body">
        <table style="width: 100%">
          <tr>
            <td width="49%" valign="top">
              <div class="table-responsive">
                <table class="miniGrid table table-striped table-bordered">
                  <thead>
                  <tr>
                    <th>#</th>
                    <th>Роли</th>
                  </tr>
                  </thead>
                  <tbody>
                  <c:forEach items="${kdos}" var="k">
                    <tr>
                      <td class="center"><input id="ids${k.id}" type="checkbox" name="ids" <c:if test="${k.active}">checked</c:if> value="${k.id}"/></td>
                      <td onclick="setCheck('ids', '${k.id}')">${k.name}</td></tr>
                  </c:forEach>
                  </tbody>
                </table>
              </div>
            </td>
        </table>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" id="closeBtn" data-dismiss="modal">Закрыть</button>
        <button type="button" onclick="doSave()" class="btn btn-primary">Сохранить</button>
      </div>
    </form>
  </div>
</div>