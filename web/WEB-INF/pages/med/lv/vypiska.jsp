<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet">

<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>

<script src="/res/js/common.js" type="text/javascript"></script>
<script src="/res/editor/nicEdit.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>

<script type="text/javascript">
  bkLib.onDomLoaded(nicEditors.allTextAreas);
  function getResults() {
    $.ajax({
      url:'/lv/results.s',
      mehtod:'post',
      dataType:'json',
      success:function(res) {
        alert(res.results);
      }
    });
  }
</script>
<div class="panel panel-info" style="width: 800px !important; margin: auto">
  <div class="panel-heading">
    Выписка
  </div>
  <f:form commandName="vyp" action='/lv/vypiska.s' method="post">
    <f:hidden path="id"/>
    <f:hidden path="patient.id"/>
    <div class="panel-body">
      <%@include file="/incs/msgs/successError.jsp"%>
      <table class="formTable" style="width:100%;">
        <tr>
          <td style="font-weight: bold; text-align: center" colspan="2">
            <c:if test="${!dieFlag}">
              ВЫПИСКА
            </c:if>
            <c:if test="${dieFlag}">
              ПОСМЕРТНЫЙ ЭПИКРИЗ
            </c:if>
          </td>
        </tr>
        <tr>
          <td><b>Пациент(ка):</b> ${vyp.patient.surname}&nbsp;${vyp.patient.name}&nbsp;${vyp.patient.middlename}</td>
          <td><b>Год рождения:</b> ${vyp.patient.birthyear}</td>
        </tr>
        <tr>
          <td nowrap class="bold">находился на стац. лечении в ЦКБ №1 ГМУ при АП РУз с ${p.patient.dateBegin} по:
          <td><input name="Date_End" id="Date_End" type="text" class="form-control datepicker" value="${Date_End}"/>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Клинический диагноз:
            <button style="float: right; font-weight: bold" title="Распечатать диагноз" class="btn btn-xs btn-default" onclick="window.open('/lv/print.s?diagnoz=Y'); return false;">
              <span title="Печать" class="fa fa-print"></span> Печать
            </button>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c1" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">Жалобы при поступлении:</td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c2" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">Из анамнеза:</td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c3" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">Состояние при поступлении:</td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c4" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Проведённые исследования:
            <a title="Результаты" style="float: right; font-weight: bold" class="btn btn-xs btn-default" onclick="getResult(); return false;">
              <span class="fa fa-flask"></span> Обновить
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c5" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">Проведено лечение:</td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c6" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            <c:if test="${!dieFlag}">
              Рекомендовано:
            </c:if>
            <c:if test="${dieFlag}">
              Посмертный диагноз:
            </c:if>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c7" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
      </table>
    </div>
    <div class="panel-footer" style="display: none">
      <button type="submit" id="saveBtn">Сохранить</button>
    </div>
  </f:form>
</div>