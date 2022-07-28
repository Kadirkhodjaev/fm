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
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">Определяемые параметры</td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px" colspan="2"></td>
        </tr>
        <tr>
          <td style="border:1px solid #e8e8e8"></td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ВЫЯВЛЕНО</td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">НЕ ВЫЯВЛЕНО</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${fields[0].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[0].html}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[1].html}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${fields[2].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[2].html}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[3].html}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${fields[4].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[4].html}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[5].html}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${fields[6].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[6].html}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[7].html}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${fields[8].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[8].html}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[9].html}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${fields[10].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[10].html}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[11].html}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${fields[12].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[12].html}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[13].html}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${fields[14].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[14].html}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[15].html}</td>
        </tr>
        <tr>
          <td colspan="3" style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">АНТИБИОГРАММА</td>
        </tr>
        <tr>
          <td></td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">РЕЗИСТЕНТНЫЙ</td>
          <td style="text-align: center; font-weight: bold; border:1px solid #e8e8e8; padding:5px">ЧУВСТВИТЕЛЬНЫЙ</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${fields[16].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[16].html}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[17].html}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${fields[18].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[18].html}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[19].html}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${fields[20].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[20].html}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[21].html}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${fields[22].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[22].html}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[23].html}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${fields[24].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[24].html}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[25].html}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${fields[26].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[26].html}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[27].html}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${fields[28].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[28].html}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[29].html}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${fields[30].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[30].html}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[31].html}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${fields[32].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[32].html}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[33].html}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${fields[34].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[34].html}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[35].html}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${fields[36].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[36].html}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[37].html}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${fields[38].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[38].html}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[39].html}</td>
        </tr>
        <tr>
          <td style="padding:5px; border:1px solid #e8e8e8">${fields[40].name}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[40].html}</td>
          <td style="border:1px solid #e8e8e8; padding:5px">${fields[41].html}</td>
        </tr>
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
