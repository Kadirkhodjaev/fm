<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<script>
  $('printButton').html("<button title='Печать' type='button' onclick='printPage()' class='btn btn-outline btn-primary print-button'><i class='fa fa-print'></i></button>");
  $('d').html('*').css('font-weight', 'bold').css('color', 'red');
  <c:if test="${authErr}">
    alert('Время вашей сессий истекло. Авторизуйтесь еще раз!');
    document.location = 'login.s';
  </c:if>
  function keyDown(e){
    if(e.keyCode == 113){
      $('button[type=submit]').click();
    }
  }
  function doSave() {
    try {
      var res = frm.document.getElementById('surname').value;
      $('#mainWindow').html($('#frmDiv').contents().find('html').html());
    } catch(e){}
  }
  function printPage(){
    window.open("/lv/print.s");
  }
  function delPatient(){
    openMainPage('/reg/nurse/del.s');
  }
  function setCountery(dom) {
    $('#regionId').toggle(dom.value == '199').val('');
  }
</script>
<iframe id="frmDiv" name="frm" onload="try {doSave()} catch(e){}" class="hidden"></iframe>
<div class="panel panel-info" style="width: 800px !important; margin: auto">
  <div class="panel-heading">
    Реквизиты пациента
    <ul class="pagination" style="float:right; margin-top:-5px">
      <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="document.getElementById('saveBtn').click()"><i title="Сохранить" class="fa fa-save"></i> Сохранить</a></li>
      <c:if test="${patient.id != null && patient.state == 'PRN'}">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="delPatient()"><i title="Удалить" class="fa fa-remove"></i> Удалить</a></li>
      </c:if>
      <c:if test="${patient.id != null}">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="printPage()"><i title="Печать" class="fa fa-print"></i> Печать</a></li>
      </c:if>
    </ul>
  </div>
  <f:form commandName="patient" action='/reg/nurse/index.s' method="post" name='bf' target="frm">
    <f:hidden path="id"/>
    <input type="hidden" name="reg" value="${reg}"/>
    <div class="panel-body">
      <%@include file="/incs/msgs/successError.jsp"%>
      <table class="formTable">
        <tr>
          <td class="right" nowrap><ui:message code="surname"/><d></d>:</td>
          <td><f:input path="surname" type="text" class="form-control" required="true" maxlength="64" autofocus="1" autocomplete="off"/></td>
          <td class="right" nowrap><ui:message code="category"/>:</td>
          <td><f:select path="cat.id" class="form-control"  items="${cat}" itemValue="id" itemLabel="name"/></td>
        </tr>
        <tr>
          <td class="right" nowrap><ui:message code="first_name"/><d></d>:</td>
          <td><f:input path="name" type="text" class="form-control" required="true" maxlength="64" autocomplete="off"/></td>
          <td class="right" nowrap><ui:message code="terBeseda"/>:</td>
          <td><f:input path="tarDate" class="form-control datepicker" type="text"/></td>
        </tr>
        <tr>
          <td class="right" nowrap><ui:message code="middle_name"/>:</td>
          <td><f:input path="middlename" type="text" class="form-control" maxlength="64" autocomplete="off"/></td>
          <td class="right" nowrap><ui:message code="temperature"/>:</td>
          <td><f:input path="temp" type="text" class="form-control center" placeholder="xx.x" style="width:70px;" maxlength="4" /></td>
        </tr>
        <tr>
          <td class="right" nowrap><ui:message code="birthyear"/>:</td>
          <td><f:input path="birthyear" type="number" class="form-control center" placeholder="xxxx" style="width:100px;" maxlength="4" /></td>
          <td class="right" nowrap><ui:message code="rost"/>:</td>
          <td><f:input path="rost" type="text" class="form-control center" placeholder="xxx" style="width:70px;" maxlength="3" /></td>
        </tr>
        <tr>
          <td class="right" nowrap><ui:message code="post"/>:</td>
          <td><f:input path="post" type="text" class="form-control" maxlength="64"/></td>
          <td class="right" nowrap><ui:message code="ves"/>:</td>
          <td><f:input path="ves" type="text" class="form-control center" placeholder="xxx.x" style="width:70px;" maxlength="5" /></td>
        </tr>
        <tr>
          <td class="right" nowrap><ui:message code="phone"/>:</td>
          <td><f:input path="tel" type="text" class="form-control" maxlength="400"/></td>
          <td class="right" nowrap><ui:message code="ambNomer"/>:</td>
          <td><f:input path="ambNum" type="text" class="form-control center" maxlength="30"/></td>
        </tr>
        <tr>
          <td class="right" nowrap><ui:message code="workPlace"/>:</td>
          <td><f:input path="work" type="text" class="form-control" maxlength="64"/></td>
          <td class="right" nowrap><ui:message code="pitanie"/>:</td>
          <td><f:select path="pitanie.id" class="form-control" items="${pitanie}" itemValue="id" itemLabel="name" /></td>
        </tr>
        <tr>
          <td class="right" nowrap><ui:message code="passportInfo"/>:</td>
          <td><f:input path="passportInfo" type="text" class="form-control" maxlength="64"/></td>
          <td class="right" nowrap><ui:message code="lgotaType"/>:</td>
          <td><f:select path="lgotaType.id" class="form-control" items="${lgotaType}" itemValue="id" itemLabel="name" /></td>
        </tr>
        <tr>
          <td class="right" nowrap>Резиденство:</td>
          <td><f:select path="counteryId" items="${counteries}" onchange="setCountery(this)" itemValue="id" itemLabel="name" class="form-control" /></td>
          <td class="right" nowrap>Область:</td>
          <td>
            <f:select path="regionId" class="form-control">
              <f:option value=""></f:option>
              <f:options items="${regions}" itemValue="id" itemLabel="name"></f:options>
            </f:select>
          </td>
        </tr>
        <tr>
          <td class="right" nowrap><ui:message code="livePlace"/>:</td>
          <td><f:input path="address" type="text" class="form-control" maxlength="400"/></td>
          <td class="right" nowrap><ui:message code="patientRedirect"/>:</td>
          <td><f:select path="redirect.id" class="form-control" items="${redirect}" itemValue="id" itemLabel="name"/></td>
        </tr>
        <tr>
          <td class="right" nowrap><ui:message code="sex"/>:</td>
          <td><f:select path="sex.id" cssClass="form-control" items="${sex}" itemValue="id" itemLabel="name"/></td>
          <td class="right" nowrap><ui:message code="vidPerevoz"/>:</td>
          <td><f:select path="vidPer.id" class="form-control" items="${vidPer}" itemValue="id" itemLabel="name"/></td>
        </tr>
        <tr>
          <td class="right" nowrap><ui:message code="metka"/>:</td>
          <td><f:select path="metka.id" class="form-control" items="${metka}" itemValue="id" itemLabel="name"/></td>
          <td class="right" nowrap>Время регистраций</td>
          <td><f:input path="time" type="text" class="form-control" maxlength="400"/></td>
        </tr>
        <tr>
          <td align="right"><ui:message code="diagnozOrg"/>:</td>
          <td colspan="3"><f:textarea path="diagnoz" type="text" class="form-control" maxlength="400"/></td>
        </tr>
      </table>
    </div>
    <div class="panel-footer" style="display: none">
      <button class="btn btn-success" id="saveBtn" type="submit" title="<ui:message code="save"/>"><ui:message code="save"/></button>
    </div>
  </f:form>
</div>