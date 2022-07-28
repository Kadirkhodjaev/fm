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
  function getResult() {
    $.ajax({
      url:'/lv/results.s',
      data:'',
      method:'post',
      dataType:'json',
      success:function(res) {
        nicEditors.findEditor("c5").setContent(res.results);
      }
    });
  }
  function getDrugResult() {
    $.ajax({
      url:'/lv/drug_results.s',
      data:'',
      method:'post',
      dataType:'json',
      success:function(res) {
        nicEditors.findEditor("c6").setContent(res.results);
      }
    });
  }
  function setMkb(text, id) {
    var obos =  nicEditors.findEditor('c1').getContent();
    $('#mkb').val(text);
    $('#mkb_id').val(id);
    nicEditors.findEditor('c1').setContent(obos.length > 0 && obos != '<br>' ? obos + ', ' + text : text);
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
      <%@include file="/incs/msgs/errors.jsp"%>
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
          <td nowrap class="bold">находился на стац. лечении в клинике с ${p.patient.dateBegin} по:
          <td><input name="Date_End" id="Date_End" type="text" class="form-control datepicker" value="${Date_End}"/>
        </tr>
        <tr><td colspan="2"><b>Клинический диагноз</b></td></tr>
        <tr>
          <td colspan="2">
            <table style="width:100%">
              <tr>
                <td style="width:100px"><a href="#" onclick="window.open('/mkb/index.s', '_blank')">МКБ 10</a>:</td>
                <td>
                  <f:hidden path="mkb_id"/>
                  <f:input type="text" readonly="true" path="mkb" cssClass="form-control"/>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Основной диагноз
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('vyp_c1', 'c1'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('vyp_c1', 'c1'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c1" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Сопуствующие болезни
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('vyp_c8', 'c8'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('vyp_c8', 'c8'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c8" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Осложнение
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('vyp_c9', 'c9'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('vyp_c9', 'c9'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c9" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Жалобы при поступлении:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('vyp_c2', 'c2'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('vyp_c2', 'c2'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c2" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Из анамнеза:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('vyp_c3', 'c3'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('vyp_c3', 'c3'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c3" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Состояние при поступлении:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('vyp_c4', 'c4'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('vyp_c4', 'c4'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c4" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Проведённые исследования:
            <a title="Результаты" style="float: right; font-weight: bold" class="btn btn-xs btn-default" onclick="getResult (); return false;">
              <span class="fa fa-flask"></span> Обновить
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c5" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Проведено лечение:
            <a title="Результаты" style="float: right; font-weight: bold" class="btn btn-xs btn-default" onclick="getDrugResult (); return false;">
              <span class="fa fa-flask"></span> Обновить
            </a>
          </td>
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
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('vyp_c7', 'c7'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('vyp_c7', 'c7'); return false;">
              <span class="fa fa-plus"></span>
            </a>
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
