<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<script src="/res/datepicker/datetimepicker_css.js"></script>
<script src="/res/js/common.js" type="text/javascript"></script>
<f:form method="post">
  <div class="panel panel-info" style="width: 1000px !important; margin: auto">
    <div class="panel-heading">
      Назначение
      <div style="float:right">
        <button class="btn btn-sm" type="button" onclick="setLocation('/lv/drug/home.s')" title="Добавить новые препараты" style="margin-top: -5px"><i class="fa fa-plus"></i> Добавить</button>
        <button class="btn btn-sm btn-success" title="Сохранить" style="margin-top: -5px"><i class="fa fa-check"></i> Сохранить</button>
      </div>
    </div>
    <table class="formTable" style="width:100%">
      <tr>
        <td colspan="4">
          <ul class="leftMenu">
            <li style="padding: 5px" onclick="" class="">Комбинации</li>
            <li style="padding: 5px" onclick="" class=""></li>
            <li style="padding: 5px" onclick="" class=""></li>
            <li style="padding: 5px" onclick="" class=""></li>
            <li style="padding: 5px" onclick="" class=""></li>
          </ul>
        </td>
      </tr>
    </table>
  </div>
</f:form>