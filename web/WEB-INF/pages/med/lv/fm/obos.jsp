<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/res/editor/nicEdit.js" type="text/javascript"></script>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script>
  bkLib.onDomLoaded(nicEditors.allTextAreas);
  function getResult() {
    $.ajax({
      url:'/lv/results.s',
      data:'',
      method:'post',
      dataType:'json',
      success:function(res) {
        nicEditors.findEditor("c4").setContent(res.results);
      }
    });
  }
  function setMkb(text, id) {
    var obos =  nicEditors.findEditor('c5').getContent();
    $('#mkb').val(text);
    $('#mkb_id').val(id);
    nicEditors.findEditor('c5').setContent(obos.length > 0 && obos != '<br>' ? obos + ', ' + text : text);
  }
</script>
<div class="panel panel-info" style="width: 800px !important; margin: auto">
  <div class="panel-heading">
    КЛИНИК ТАШХИСНИ АСОСЛАШ
  </div>
  <f:form commandName="obos" action='/lv/obos.s' method="post">
    <f:hidden path="id"/>
    <f:hidden path="patient.id"/>
    <div class="panel-body">
      <%@include file="/incs/msgs/successError.jsp"%>
      <%@include file="/incs/msgs/errors.jsp"%>
      <table class="formTable" style="width:100%">
        <tr>
          <td>Сана:</td>
          <td><f:input id="Doc_Date" type="text" class="form-control datepicker" path="c8"/></td>
        </tr>
        <tr>
          <td><b>Бемор:</b> ${obos.patient.surname}&nbsp;${obos.patient.name}&nbsp;${obos.patient.middlename}</td>
          <td><b>Тугилган йили:</b> ${obos.patient.birthyear}</td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Шикоятлар:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('obos_c1', 'c1'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('obos_c1', 'c1'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c1" cssStyle="width: 100%;" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Anamnesis:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('obos_c2', 'c2'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('obos_c2', 'c2'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c2" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Status praesens:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('obos_c3', 'c3'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('obos_c3', 'c3'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c3" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">Текширув ва тахлиллар:
            <a title="Результаты" style="float: right; font-weight: bold" class="btn btn-xs btn-default" onclick="getResult (); return false;">
              <span class="fa fa-flask"></span> Обновить
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c4" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr><td colspan="2" class="bold">Ташхис</td></tr>
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
            Асосий
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('obos_c5', 'c5'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('obos_c5', 'c5'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c5" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Хамрох
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('obos_c6', 'c6'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('obos_c6', 'c6'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c6" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Асорати
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('obos_c7', 'c7'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('obos_c7', 'c7'); return false;">
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
      <button id=saveBtn type="submit" title="Сохранить">Сохранить</button>
    </div>
  </f:form>
</div>
