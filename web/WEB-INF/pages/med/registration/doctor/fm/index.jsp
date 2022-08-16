<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<script>
  var tab = 1;
  function saveForm() {
    if (checkForm($('form'))) {
      $('form').submit();
    }
  }
  function saveData(){
    try {
      var res = jQuery.parseJSON(frm.document.body.getElementsByTagName("pre")[0].innerText);
      if(res.success) {
        alert('<ui:message code="successSave"/>');
        setPage('/reg/doctor/index.s?id=' + res.id);
      } else {
        alert(res.msg);
      }
    } catch (e) {}
  }
  function nursePage(){
    tab = 0;
    $('#home').load('/reg/nurse/view.s');
  }
  function printPage(){
    window.open('/lv/print.s');
  }
  function setTab(id) {
    tab = id;
  }
  function confPatient() {
    setPage('/patients/confirm.s?id=${patient.id}');
  }
  function savePPTemplate(field, fieldId) {
    if (confirm('Вы действительно хотите сохранить значения данного поля как шаблон')) {
      var name = prompt('Наименование шаблона');
      if (name != '') {
        $.ajax({
          url: '/templates/lv/save.s',
          data: 'field=' + field + '&name=' + name + '&template=' + encodeURIComponent($('#' + fieldId).val()),
          method: 'post',
          dataType: 'json',
          success: function (res) {
            alert(res.msg);
          }
        });
      }
    }
  }

  function getPPTemplate(field, id) {
    var res = window.open('/templates/lv/get.s?kdo=1&field=' + field + '&id=' + id);
  }
  function setText(dom, id) {
    $('#' + id).val(dom.innerHTML);
  }
  function setMkb(text, id) {
    var dom = document.getElementById('startDiagnoz');
    $('#mkb').val(id);
    dom.value = dom.value.length > 0 ? dom.value + ', ' + text : text;
    document.getElementById("mkb_id").value = id;
    document.getElementById("mkb").value = text;
  }
  function ekg() {
    window.open('/reg/ekg.s?id=${patient.id}');
  }
  function rejectPatient() {
    if(confirm('Вы действительно хотите отправть данного пациента в Архив')) {

    }
  }
</script>
<iframe name="frm" onload="try {saveData()} catch(e){}" class="hidden"></iframe>
<div class="panel panel-info">
  <div class="panel-heading">
    Пациент - <b>${fio}</b>
    <ul class="pagination" style="float:right; margin-top:-4px;">
      <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="printPage()"><i title="Печать" class="fa fa-print"></i> Печать</a></li>
      <c:if test="${date_Begin != '' && patient.state == 'PRD'}">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="confPatient()"><i title="Подтвердить" class="fa fa-check"></i> Подтвердить</a></li>
      </c:if>
      <c:if test="${false && date_Begin != '' && patient.state == 'PRD'}">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="rejectPatient()"><i title="Отказ" class="fa fa-check"></i> Отказ</a></li>
      </c:if>
      <c:if test="${date_Begin == '' && patient.state == 'PRD'}">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="ekg()"><i title="Подтвердить" class="fa fa-check"></i> ЭКГ</a></li>
      </c:if>
      <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="saveForm()"><i title="Сохранить" class="fa fa-print"></i> Сохранить</a></li>
    </ul>
  </div>
  <!-- /.panel-heading -->
  <div class="panel-body">
    <!-- Nav tabs -->
    <ul class="nav nav-tabs">
      <li class=""><a href="#home" onclick="nursePage()" data-toggle="tab" aria-expanded="true">Регистрационные данные</a></li>
      <li class="active"><a href="#profile" onclick="setTab(1)" data-toggle="tab" aria-expanded="false">Основные данные</a></li>
      <li class=""><a href="#messages" onclick="setTab(2)" data-toggle="tab" aria-expanded="false">Дополнительные данные</a></li>
    </ul>
    <%@include file="/incs/msgs/successError.jsp"%>
    <!-- Tab panes -->
    <f:form commandName="patient" action='/reg/doctor/index.s' method="post" name='bf' target="frm">
      <f:hidden path="id"/>
      <f:hidden path="surname"/>
      <f:hidden path="name"/>
      <div class="tab-content">
        <div class="tab-pane fade" id="home"></div>
        <div class="tab-pane active fade in" id="profile">
          <div class="panel-body">
            <%@include file="/incs/msgs/errors.jsp"%>
            <table class="formTable" width="1000px">
              <tr>
                <td style="width:350px" class="right" nowrap>Дата поступления<d></d>:
                <td colspan="3"><input name="date_Begin" id="date_Begin" type="text" class="form-control datepicker" value="${date_Begin}"/>
              <tr>
                <td class="right">${messageCode}Номер история болезни</td>
                <td class="left" colspan="3">
                  <f:input cssClass="form-control center" maxlength="8" type="number" path="yearNum" cssStyle="display:inline; width:100px"/>
                </td>
              </tr>
              <c:if test="${bioCount == 0}">
                <tr>
                  <td class="right" nowrap>Отправить на анализ "Гликогемоглобин":</td>
                  <td colspan="3" align="left"><input name="glikoFlag" value="Y" type="checkbox"/></td>
                </tr>
              </c:if>
              <%--<tr>
                <td class="right">
                  <a href="#" onclick="window.open('/mkb/index.s', '_blank')">Диагноз при поступлении по МКБ 10:</a>
                  <f:input type="hidden" path="mkb_id"/>
                </td>
                <td colspan="3"><f:input type="text" cssClass="form-control" readonly="true" path="mkb"/>
              </tr>--%>
              <tr>
                <td class="right">
                  Диагноз при поступлении:
                  <f:input type="hidden" path="mkb"/>
                  <a title="Сохранить как шаблон" style="float:right;padding:1px 5px" class="btn btn-xs btn-default" onclick="savePPTemplate('pp_startDiagnoz', 'startDiagnoz'); return false;">
                    <span class="fa fa-save"></span>
                  </a>
                  <a title="Из шаблона" style="float: right;padding:1px 5px" class="btn btn-xs btn-default" onclick="getPPTemplate('pp_startDiagnoz', 'startDiagnoz'); return false;">
                    <span class="fa fa-plus"></span>
                  </a>
                </td>
                <td colspan="3"><f:textarea path="startDiagnoz" type="text" cssClass="form-control" maxlength="4000"/>
              <tr>
                <td class="right">
                  Сопутствующие болезни:
                  <a title="Сохранить как шаблон" style="float:right;padding:1px 5px" class="btn btn-xs btn-default" onclick="savePPTemplate('pp_sopustDBolez', 'sopustDBolez'); return false;">
                    <span class="fa fa-save"></span>
                  </a>
                  <a title="Из шаблона" style="float: right;padding:1px 5px" class="btn btn-xs btn-default" onclick="getPPTemplate('pp_sopustDBolez', 'sopustDBolez'); return false;">
                    <span class="fa fa-plus"></span>
                  </a>
                </td>
                <td colspan="3"><f:textarea path="sopustDBolez" type="text" cssClass="form-control" maxlength="4000"/>
              <tr>
                <td class="right">Осложнение:
                  <a title="Сохранить как шаблон" style="float:right;padding:1px 5px" class="btn btn-xs btn-default" onclick="savePPTemplate('pp_oslojn', 'oslojn'); return false;">
                    <span class="fa fa-save"></span>
                  </a>
                  <a title="Из шаблона" style="float: right;padding:1px 5px" class="btn btn-xs btn-default" onclick="getPPTemplate('pp_oslojn', 'oslojn'); return false;">
                    <span class="fa fa-plus"></span>
                  </a>
                </td>
                <td colspan="3"><f:textarea path="oslojn" type="text" cssClass="form-control" maxlength="4000"/>
              <tr>
                <td colspan="4">
                <p class="center"><b>СХЕМА<br>Сбора эпидемиологического анамнеза</b></p>
                <p>Имел(а) ли контакт с инфекционными больными (брюшным тифом, паратифами, др салмонеллёзами, дизентерией, прочим ОКИ,
                   вирусными гепатитами, туберкулезом, венерическими заболеваниями) по месту жительства или прописки, работы, учебы на
                   протяжении максимального срока инкубации для каждого заболевания</p>
              <tr>
                <td colspan="4"><f:input path="no1" type="text" cssClass="form-control" maxlength="60" autocomplete="on"/>
              <tr>
                <td colspan="4">Выезжал(а) ли пределы населенного пункта за неделю, -2 месяца до настоящего заболевания. Место пребывания и дата возвращения (вписать с какого по какое время)
              <tr>
                <td colspan="4"><f:input path="no2" type="text" cssClass="form-control" maxlength="60" autocomplete="on"/>
              <tr>
                <td colspan="4">Какие инфеционные заболевания перенёс(ла)?
              <tr>
                <td colspan="4"><f:input path="no3" type="text" cssClass="form-control" maxlength="60" autocomplete="on"/>
              <tr>
                <td colspan="4">Находился (лась) ли на стационарном лечении, получал(а) ли гемотрансфузии (кровь и ее компоненты), подвергалась ли оперативным и массивным вмешательствам за последние 6 месяцев
              <tr>
                <td colspan="4"><f:input path="no4" type="text" cssClass="form-control" maxlength="60" autocomplete="on"/>
            </table>
          </div>
        </div>
        <div class="tab-pane fade" id="messages">
          <div class="panel-body">
            <table class="formTable" width="700px">
              <tr>
                <td class="right" nowrap>Жалобы:
                  <a title="Сохранить как шаблон" style="float:right;padding:1px 5px" class="btn btn-xs btn-default" onclick="savePPTemplate('pp_jaloby', 'jaloby'); return false;">
                    <span class="fa fa-save"></span>
                  </a>
                  <a title="Из шаблона" style="float: right;padding:1px 5px" class="btn btn-xs btn-default" onclick="getPPTemplate('pp_jaloby', 'jaloby'); return false;">
                    <span class="fa fa-plus"></span>
                  </a>
                </td>
                <td colspan="3"><f:textarea path="jaloby" rows="5" class="form-control" maxlength="1500"/>
              <tr>
                <td class="right" nowrap>Анамнез:
                  <a title="Сохранить как шаблон" style="float:right;padding:1px 5px" class="btn btn-xs btn-default" onclick="savePPTemplate('pp_anamnez', 'anamnez'); return false;">
                    <span class="fa fa-save"></span>
                  </a>
                  <a title="Из шаблона" style="float: right;padding:1px 5px" class="btn btn-xs btn-default" onclick="getPPTemplate('pp_anamnez', 'anamnez'); return false;">
                    <span class="fa fa-plus"></span>
                  </a>
                </td>
                <td colspan="3"><f:textarea path="anamnez" rows="5" class="form-control" maxlength="1500"/>
              <tr>
                <td colspan="4" class="bold">Status praesens
              <tr>
                <td class="right" nowrap>Общее состояние:
                <td><f:input path="c1" class="form-control" maxlength="200" autocomplete="on"/>
                <td class="right" nowrap>Сознание:
                <td><f:input path="c2" class="form-control" maxlength="200" autocomplete="on"/>
              <tr>
                <td class="right" nowrap>Положение:
                <td><f:input path="c3" class="form-control" maxlength="200" autocomplete="on"/>
                <td class="right" nowrap>Телосложение:
                <td><f:input path="c4" class="form-control" maxlength="200" autocomplete="on"/>
              <tr>
                <td class="right" nowrap>Кожные покровы:
                <td colspan="4"><f:input path="c36" class="form-control" maxlength="200"/>
              <tr>
                <td class="right" nowrap>Клечатка:
                <td><f:input path="c5" class="form-control" maxlength="200" autocomplete="on"/>
                <td class="right" nowrap>Костно-мышечная сис.:
                <td><f:input path="c6" class="form-control" maxlength="200" autocomplete="on"/>
              <tr>
                <td class="right" nowrap>Суставы:
                <td><f:input path="c7" class="form-control" maxlength="200" autocomplete="on"/>
                <td class="right" nowrap>Лимфатические узлы:
                <td><f:input path="c8" class="form-control" maxlength="200" autocomplete="on"/>
              <tr>
              <td class="right" nowrap>Аускультация легких:
              <td><f:input path="c12" class="form-control" maxlength="200" autocomplete="on"/>
                <td class="right" nowrap>Число дыхания:
                <td><f:input path="c10" class="form-control" maxlength="200" autocomplete="on"/>
              <tr>
                <td class="right bold" nowrap>Аускультация сердца:
                <td><f:input path="c17" class="form-control" maxlength="200" autocomplete="on"/>
                <td class="right" nowrap>на аорте:
                <td><f:input path="c18" class="form-control" maxlength="200" autocomplete="on"/>
              <tr>
                <td class="right bold" nowrap>Шумы в сердце:
                <td colspan="3"><f:input path="c37" class="form-control" maxlength="200" autocomplete="on"/>
              <tr>
                <td class="right" nowrap>Пульс: Частота:
                <td><f:input path="c20" class="form-control" maxlength="200" autocomplete="on"/>
                <td class="right" nowrap>ритм:
                <td><f:input path="c21" class="form-control" maxlength="200" autocomplete="on"/>
              <tr>
                <td class="right" nowrap>Артериальное давление:
                <td colspan="3"><f:input path="c25" class="form-control" maxlength="200" autocomplete="on"/>
              <tr>
                <td class="right" nowrap>Язык:
                <td><f:input path="c26" class="form-control" maxlength="200" autocomplete="on"/>
                <td class="right" nowrap>Живот:
                <td><f:input path="c27" class="form-control" maxlength="200" autocomplete="on"/>
              <tr>
                <td class="right" nowrap>Печень:
                <td><f:input path="c28" class="form-control" maxlength="200" autocomplete="on"/>
                <td class="right" nowrap>Селезенка:
                <td><f:input path="c29" class="form-control" maxlength="200" autocomplete="on"/>
              <tr>
                <td class="right" nowrap>Стул:
                <td><f:input path="c30" class="form-control" maxlength="200" autocomplete="on"/>
                <td class="right" nowrap>Мочеиспускание:
                <td><f:input path="c31" class="form-control" maxlength="200" autocomplete="on"/>
              <tr>
                <td class="right" nowrap>Симптом Пастернацкого:
                <td colspan="4"><f:input path="c33" class="form-control" maxlength="200" autocomplete="on"/>
              <tr>
                <td class="right" nowrap>Периферические отеки:
                <td colspan="4"><f:input path="c34" class="form-control" maxlength="200" autocomplete="on"/>
            </table>
          </div>
          <div class="panel-footer center" style="display:none !important">
            <button class="btn btn-success" id="saveBtn" type="button" onclick="saveForm())" title="<ui:message code="save"/>"><ui:message code="save"/></button>
          </div>
        </div>
      </div>
    </f:form>
  </div>
  <!-- /.panel-body -->
</div>
