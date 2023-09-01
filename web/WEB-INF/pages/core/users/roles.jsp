 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
  function doSave(){
    $.ajax({
      url: 'core/user/roles.s',
      method: 'post',
      data: $('#user_roles').serialize(),
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if(res.success)
          $('#closeBtn').click();
      }
    });
  }
  function setCheck(name, id){
    var dom = document.getElementById(name + id);
    dom.checked = !dom.checked;
    if (dom.id == 'role7') {
      if (dom.checked) $('#kdoListTr').show();
      $('#kdoListDiv').slideToggle("slow", function () {
        if (!dom.checked) $('#kdoListTr').hide()
      });
      $('input[name=kdo]').each(function () {
        if (!dom.checked) {
          $(this).prop('checked', false);
        }
      });
    }
    if (dom.id == 'role14') {
      if (dom.checked) $('#ambTr').show();
      $('#ambDiv').slideToggle("slow", function () {
        if (!dom.checked) $('#ambtTr').hide()
      });
      $('input[name=service]').each(function () {
        if (!dom.checked) {
          $(this).prop('checked', false);
        }
      });
    }
  }
  $('.roleChecker').bind('change', function () {
    var dom = $(this);
    if (dom.attr('id') == 'role7') {
      if (dom.is(':checked')) $('#kdoListTr').show();
      $('#kdoListDiv').slideToggle("slow", function () {
        if (!dom.is(':checked')) $('#kdoListTr').hide()
      });
      $('input[name=kdo]').each(function () {
        if (!dom.is(':checked')) {
          $(this).prop('checked', false);
        }
      });
    }
    if (dom.attr('id') == 'role14') {
      if (dom.is(':checked')) $('#ambTr').show();
      $('#ambDiv').slideToggle("slow", function () {
        if (!dom.is(':checked')) $('#ambTr').hide()
      });
      $('input[name=service]').each(function () {
        if (!dom.is(':checked')) {
          $(this).prop('checked', false);
        }
      });
    }
  })
  $(document).ready(function () {
    $('#kdoListTr').toggle($('#role7').is(':checked'));
    $('#kdoListDiv').toggle($('#role7').is(':checked'));
    $('#ambTr').toggle($('#role14').is(':checked'));
    $('#ambDiv').toggle($('#role14').is(':checked'));
  })
  function setKdo(id) {
    var dom = document.getElementById("kdo" + id);
    dom.checked = !dom.checked;
  }
  function setService(id) {
    var dom = document.getElementById("service" + id);
    dom.checked = !dom.checked;
  }
</script>
<div class="modal-dialog" style="width: 1200px">
  <div class="modal-content">
    <form id="user_roles">
      <input type="hidden" value="${user.id}" name="userId" />
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel">Пользовательские роли и отчеты - <b>${user.fio}</b></h4>
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
                  <c:forEach items="${roles}" var="r">
                    <tr>
                      <td class="center"><input class="roleChecker" id="role${r.id}" type="checkbox" name="role" <c:if test="${r.active}">checked</c:if> value="${r.id}"/></td>
                      <td onclick="setCheck('role', '${r.id}')">${r.name}</td></tr>
                    <c:if test="${r.id == 7}">
                      <tr id="kdoListTr">
                        <td colspan="2" style="padding-left:20px">
                          <div id="kdoListDiv">
                            <table class="miniGrid table table-striped table-bordered" style="margin:0; width:100%">
                              <c:forEach items="${kdos}" var="kdo">
                                <tr>
                                  <td align="center"><input id="kdo${kdo.id}" type="checkbox" name="kdo" <c:if test="${kdo.active}">checked</c:if> value="${kdo.id}"/></td>
                                  <td onclick="setKdo(${kdo.id})">${kdo.name}</td>
                                </tr>
                              </c:forEach>
                            </table>
                          </div>
                        </td>
                      </tr>
                    </c:if>
                    <c:if test="${r.id == 14}">
                      <tr id="ambTr">
                        <td colspan="2" style="padding-left:20px">
                          <div id="ambDiv">
                            <table class="miniGrid table table-striped table-bordered" style="margin:0; width:100%">
                              <c:forEach items="${services}" var="service">
                                <tr>
                                  <td align="center"><input id="service${service.id}" type="checkbox" name="service" <c:if test="${service.active}">checked</c:if> value="${service.id}"/></td>
                                  <td onclick="setService(${service.id})">${service.name}</td>
                                </tr>
                              </c:forEach>
                            </table>
                          </div>
                        </td>
                      </tr>
                    </c:if>
                  </c:forEach>
                  </tbody>
                </table>
              </div>
            </td>
            <td width="1%"></td>
            <td width="50%" valign="top">
              <div class="table-responsive">
                <table class="miniGrid table table-striped table-bordered">
                  <thead>
                  <tr>
                    <th>#</th>
                    <th>Отчеты</th>
                  </tr>
                  </thead>
                  <tbody>
                  <c:forEach items="${reports}" var="r">
                    <tr onclick="setCheck('report', ${r.id})"><td class="center"><input id="report${r.id}" type="checkbox" <c:if test="${r.active}">checked</c:if> name="report" value="${r.id}"/></td><td>${r.name}</td></tr>
                  </c:forEach>
                  </tbody>
                </table>
              </div>
            </td>
          </tr>
        </table>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" id="closeBtn" data-dismiss="modal">Закрыть</button>
        <button type="button" onclick="doSave()" class="btn btn-primary">Сохранить</button>
      </div>
    </form>
  </div>
</div>
