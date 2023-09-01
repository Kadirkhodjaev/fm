<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
  function setCheck(id){
    var dom = document.getElementById('valCheckBox' + id);
    dom.checked = !dom.checked;
  }
  function doSave() {
    var vals = '';
    $('.valCheckBox').each(function(){
      if($(this).is(":checked"))
        vals += 'val=' + $(this).val() + '&';
    });
    $.ajax({
      url: '/core/form/fields/addVals.s',
      method: 'post',
      data: 'fieldId=${fieldId}&' + vals,
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if(res.success) setLocation('main.s')
      }
    });
  }
</script>
<div class="modal-dialog" style="width: 800px">
  <div class="modal-content">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      <h4 class="modal-title" id="myModalLabel">Пользовательские роли и отчеты</h4>
    </div>
    <div class="modal-body">
      <div class="table-responsive">
        <table class="miniGrid table table-striped table-bordered">
          <tbody>
            <c:forEach items="${opts}" var="o" varStatus="loop">
              <c:if test="${loop.index%3 == 0}">
                <tr style="cursor: pointer">
              </c:if>
                <td class="center"><input class="valCheckBox" id="valCheckBox${o.id}" type="checkbox" value="${o.id}"></td>
                <td onclick="setCheck(${o.id})">${o.name}</td>
              <c:if test="${loop.index%3 == 2}">
                </tr>
              </c:if>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
    <div class="modal-footer">
      <button type="button" class="btn btn-default" id="closeBtn" data-dismiss="modal">Закрыть</button>
      <button type="button" onclick="doSave()" class="btn btn-primary">Сохранить</button>
    </div>
  </div>
</div>
