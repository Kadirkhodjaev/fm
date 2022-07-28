<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/res/js/common.js"></script>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<script>
  function saveFizio() {
    $.ajax({
      url : '/view/fizio/set.s',
      data : $('#fizioForm').serialize(),
      method:'post',
      dataType : 'json',
      success : function (res) {
        document.location = '/view/fizio/index.s';
      }
    });
  }
</script>
<div class="panel panel-info" style="width: 900px !important; margin: auto">
  <div class="panel-heading">
    Физиотерапевтические процедуры
    <div style="float:right">
      <button class="btn btn-success btn-sm" id="saveBtn" type="button" onclick="saveFizio()" title="Сохранить" style="margin-top: -5px"><i class="fa fa-check"></i> Сохранить</button>
      <button class="btn btn-sm" type="button" onclick="setLocation('/view/fizio/index.s')" style="margin-top: -5px"><i class="fa fa-reply"></i> Назад</button>
    </div>
  </div>
  <form id="fizioForm">
    <table class="formTable" style="width:100%">
      <tr><td align="center" width="20">&nbsp;</td><td align="center" width="250"><b>Наименование</b></td></tr>
      <c:forEach items="${fizios}" var="k">
        <tr><td align="center"><input type="checkbox" id="kdo${k.id}" value="${k.id}" name="ids"></td><td><label for="kdo${k.id}">${k.name}</label></td></tr>
      </c:forEach>
    </table>
  </form>
</div>
