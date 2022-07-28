<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/res/editor/nicEdit.js" type="text/javascript"></script>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet">
<script src="/res/js/common.js" type="text/javascript"></script>
<script type="text/javascript">
  bkLib.onDomLoaded(nicEditors.allTextAreas);
  function setMkb(text, id) {
    var osm =  nicEditors.findEditor('c5').getContent();
    $('#mkb').val(id);
    nicEditors.findEditor('c5').setContent(osm.length > 0 && osm != '<br>' ? osm + ', ' + text : text);
  }
</script>
<div class="panel panel-info" style="width: 800px !important; margin: auto">
  <div class="panel-heading">
    БУЛИМДАГИ КУРИК
  </div>
  <f:form commandName="osm" action='/lv/osm.s' method="post">
    <f:hidden path="id"/>
    <f:hidden path="patient.id"/>
    <div class="panel-body">
      <%@include file="/incs/msgs/successError.jsp"%>
      <table class="formTable" style="width:100%">
        <tr>
          <td>Сана:</td>
          <td><f:input id="Doc_Date" type="text" class="form-control datepicker" path="c7"/></td>
        </tr>
        <tr>
          <td><b>Бемор:</b> ${osm.patient.surname}&nbsp;${osm.patient.name}&nbsp;${osm.patient.middlename}</td>
          <td><b>Тугилган йили:</b> ${osm.patient.birthyear}</td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Шикоятлар:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c1', 'c1'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c1', 'c1'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c1" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Anamnesis morbi:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c2', 'c2'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c2', 'c2'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c2" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Anamnesis vitae:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c8', 'c8'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c8', 'c8'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c8" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Status praesens:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c3', 'c3'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c3', 'c3'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c3" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Нафас олиш системаси:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c9', 'c9'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c9', 'c9'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c9" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Қон айланиш системаси:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c10', 'c10'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c10', 'c10'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c10" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Хазм қилиш cистемаси:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c11', 'c11'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c11', 'c11'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c11" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Сийдик-таносил системаси:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c12', 'c12'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c12', 'c12'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c12" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Нерв системаси:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c13', 'c13'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c13', 'c13'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c13" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Эндокрин системаси:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c14', 'c14'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c14', 'c14'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c14" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Қалқонсимон без:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c15', 'c15'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c15', 'c15'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c15" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Меьда ости бези:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c16', 'c16'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c16', 'c16'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c16" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Стационар даволанишдан олдинги муолажалар:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c4', 'c4'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c4', 'c4'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c4" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Тахминий ташхис: Асосий <a href="/mkb/index.s" target="_blank">МКБ 10</a>
            <f:input type="hidden" path="mkb"/>
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c5', 'c5'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c5', 'c5'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c5" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Тахминий ташхис: Хамрох
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c18', 'c18'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c18', 'c18'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c18" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Тахминий ташхис: Асорати
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c19', 'c19'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c19', 'c19'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><f:textarea path="c19" cssStyle="width: 100%" rows="8" maxlength="10000"/></td>
        </tr>
      </table>
    </div>
    <div class="panel-footer" style="display: none">
      <button id=saveBtn type="submit">Сохранить</button>
    </div>
  </f:form>
</div>