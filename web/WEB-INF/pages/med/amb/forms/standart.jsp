<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<html>

<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/bs/metisMenu/metisMenu.min.css" rel="stylesheet">
<link href="/res/bs/sb_admin/css/timeline.css" rel="stylesheet">
<link href="/res/bs/sb_admin/css/sb-admin-2.css" rel="stylesheet">
<link href="/res/bs/morrisjs/morris.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<link href="/res/tinymce/jquery-te-1.4.0.css" rel="stylesheet">

<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/bs/metisMenu/metisMenu.min.js"></script>
<script src="/res/bs/morrisjs/morris.min.js"></script>
<script src="/res/bs/sb_admin/js/sb-admin-2.js"></script>
<script src="/res/js/common.js"></script>
<script src="/res/editor/nicEdit.js" type="text/javascript"></script>
<script src="/res/tinymce/jquery-te-1.4.0.js" type="text/javascript"></script>

<script>
  function serviceSave() {
    $.ajax({
      url: '/amb/work.s',
      data: $('#amb-form').serialize(),
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert('Данные успешно сохранены');
          parent.setPage('/amb/work.s?id=${service.id}');
        } else
          alert(res.msg);
      }
    });
  }
  function confirmResult() {
    $.ajax({
      url: '/amb/confirmService.s',
      data: 'id=${service.id}',
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert('Данные успешно сохранены');
          parent.setPage('/amb/home.s');
        } else
          alert(res.msg);
      }
    });
  }
  function setPrintPage() {
    window.open('/amb/print.s?ids=${service.id}_');
  }
</script>
<body style="background: white">
<div class="panel panel-info" style="width: 700px !important; margin: auto">
  <div class="panel-heading">
    ${patient.surname} ${patient.name} ${patient.middlename}
    <ul class="pagination" style="float:right; margin-top:-5px">
      <c:if test="${curUser == service.worker.id}">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="serviceSave()"><i title="Сохранить" class="fa fa-save"></i> Сохранить</a></li>
      </c:if>
      <c:if test="${service.result > 0}">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="setPrintPage()"><i title="Печать" class="fa fa-print"></i> Печать</a></li>
      </c:if>
      <c:if test="${service.result > 0 && service.state == 'PAID'}">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="confirmResult()"><i title="Подтвердить" class="fa fa-check"></i> Подтвердить</a></li>
      </c:if>
      <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="parent.openMainPage('/amb/home.s', true)"><i title="Назад" class="fa fa-backward"></i> Назад</a></li>
    </ul>
  </div>
  <div class="panel-body">
    <table class="formTable" style="width:100%">
      <tr>
        <td class="right bold" nowrap>ФИО<d></d>:</td>
        <td colspan="3">
          ${patient.surname} ${patient.name} ${patient.middlename}
        </td>
      </tr>
      <tr>
        <td class="right bold" nowrap><ui:message code="birthyear"/>:</td>
        <td>${patient.birthyear}</td>
        <td class="right bold" nowrap><ui:message code="sex"/>:</td>
        <td>${patient.sex.name}</td>
      </tr>
      <tr>
        <td class="right bold" nowrap><ui:message code="phone"/>:</td>
        <td>${patient.tel}</td>
        <td class="right bold" nowrap><ui:message code="passportInfo"/>:</td>
        <td>${patient.passportInfo}</td>
      </tr>
      <tr>
        <td class="right bold" nowrap>Резиденство:</td>
        <td>${country}</td>
        <td class="right bold" nowrap>Область:</td>
        <td>${region}</td>
      </tr>
      <tr>
        <td class="right bold" nowrap><ui:message code="address"/>:</td>
        <td colspan="3">${patient.address}</td>
      </tr>
    </table>
  </div>
  <div class="" style="margin-left:-1px; width: 100% !important;">
    <div class="center" style="font-weight:bold; font-size:18px">
      ${service.service.name}
    </div>
    <form id="amb-form">
      <input type="hidden" name="id" value="${service.id}"/>
      <table width="100%" class="table-bordered">
        <tr>
          <td class="center bold">Показатель</td>
          <td class="center bold">Результат</td>
          <td class="center bold">Норма</td>
        </tr>
        <c:forEach items="${fields}" var="field">
          <tr>
            <td style="padding:5px;text-align:right">${field.name}</td>
            <td style="padding:5px">${field.html}</td>
            <td class="center" style="padding:5px">${field.norma} ${field.ei}</td>
          </tr>
        </c:forEach>
      </table>
    </form>
  </div>
</div>
</body>
<script>
  try {
    var data = {'formAction':[${data}]};
    for(var elv in data.formAction) {
      var r = data.formAction[elv];
      for (var e in r) {
        try {
          document.getElementsByName(e)[0].value = r[e];
        } catch (e) {}
      }
    }
  } catch(e) {
    alert(e);
  }
</script>
</html>
