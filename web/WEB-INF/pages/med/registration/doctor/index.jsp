<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://www.springframework.org/tags/form" %>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<script>
  var tab = 1;
  function doSave() {
    try {
      var res = frm.document.getElementById('palata').value;
      $('#mainWindow').html($('#frmDiv').contents().find('html').html());
    } catch(e){}
  }
  function nursePage(){
    tab = 0;
    $('#home').load('/reg/nurse/print.s?id=${patient.id}');
  }
  function printPage(){
    if(tab == 0)
      window.open('/lv/print.s');
    else
      window.open('/lv/print.s?page=' + tab);
  }
  function setTab(id) {
    tab = id;
  }
  function setOtd(id){
    $.ajax({
      url: "/reg/doctor/getIbNum.s?otdNum=" + id,
      method: "post",
      dataType : "json",
      success : function(data){
        $('input[name=yearNum]').val(data.y);
      },
      error : function(data, err){
        alert(err);
      }
    });
  }
</script>
<div class="panel panel-info">
  <div class="panel-heading">
    Пациент - <b>${fio}</b>
    <ul class="pagination" style="float:right; margin-top:-4px;">
      <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="printPage()"><i title="Печать" class="fa fa-print"></i> Печать</a></li>
      <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="document.getElementById('saveBtn').click()"><i title="Сохранить" class="fa fa-print"></i> Сохранить</a></li>
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
    <!-- Tab panes -->
    <f:form commandName="patient" action='/reg/doctor/index.s' method="post" name='bf' target="frm">
      <f:hidden path="id"/>
      <f:hidden path="surname"/>
      <f:hidden path="name"/>
      <div class="tab-content">
        <div class="tab-pane fade" id="home"></div>
        <div class="tab-pane active fade in" id="profile">
          <div class="panel-body">
            <%@include file="/incs/msgs/successError.jsp"%>
            <%@include file="/incs/msgs/errors.jsp"%>
            <table class="formTable" width="700px">
              <tr>
                <td class="right" nowrap>Дата поступления<d></d>:
                <td><input name="date_Begin" id="date_Begin" type="text" class="form-control datepicker" value="${date_Begin}"/>
                <td class="right" nowrap>Дата выписки:
                <td>${Date_End}
              <tr>
                <td class="right" nowrap>Отделение<d></d>:
                <td><f:select path="dept.id" class="form-control" onchange="setOtd(this.value)">
                      <option></option>
                      <f:options items="${deps}" itemValue="id" itemLabel="name"/>
                    </f:select>
                <td class="right" nowrap>Дата(Диагноз):
                <td><input name="diagnos_Date" id="diagnos_Date" type="text" class="form-control datepicker" value="${diagnos_Date}"/>
              <tr>
                <td class="right">Номер история болезни</td>
                <td colspan="3" class="left">
                  <f:input cssClass="form-control center" maxlength="8" type="number" path="yearNum" cssStyle="display:inline; width:100px"/>
                </td>
              </tr>
              <tr>
                <td class="right" nowrap>№ палаты<d></d>:
                <td><f:input path="palata" type="text" class="form-control center" maxlength="8" cssStyle="width: 100px"/>
                <td class="right" nowrap>Лечащий врач<d></d>:
                <td><f:select path="lv_id" class="form-control">
                      <option></option>
                      <f:options items="${lvs}" itemValue="id" itemLabel="fio"/>
                    </f:select>
              <tr>
                <td class="right">Диагноз при поступлении:
                <td colspan="3"><f:textarea path="startDiagnoz" type="text" cssClass="form-control" maxlength="4000"/>
              <tr>
                <td class="right">Сопутствующие болезни:
                <td colspan="3"><f:textarea path="sopustDBolez" type="text" cssClass="form-control" maxlength="4000"/>
              <tr>
                <td class="right">Осложнение:
                <td colspan="3"><f:textarea path="oslojn" type="text" cssClass="form-control" maxlength="4000"/>
              <tr>
                <td colspan="4">
                <p class="center"><b>СХЕМА<br>Сбора эпидемиологического анамнеза</b></p>
                <p>Имел(а) ли контакт с инфекционными больными (брюшным тифом, паратифами, др салмонеллёзами, дизентерией, прочим ОКИ,
                   вирусными гепатитами, туберкулезом, венерическими заболеваниями) по месту жительства или прописки, работы, учебы на
                   протяжении максимального срока инкубации для каждого заболевания</p>
              <tr>
                <td colspan="4"><f:input path="no1" type="text" cssClass="form-control" maxlength="60"/>
              <tr>
                <td colspan="4">Выезжал(а) ли пределы населенного пункта за неделю, -2 месяца до настоящего заболевания. Место пребывания и дата возвращения (вписать с какого по какое время)
              <tr>
                <td colspan="4"><f:input path="no2" type="text" cssClass="form-control" maxlength="60"/>
              <tr>
                <td colspan="4">Какие инфеционные заболевания перенёс(ла)?
              <tr>
                <td colspan="4"><f:input path="no3" type="text" cssClass="form-control" maxlength="60"/>
              <tr>
                <td colspan="4">Находился (лась) ли на стационарном лечении, получал(а) ли гемотрансфузии (кровь и ее компоненты), подвергалась ли оперативным и массивным вмешательствам за последние 6 месяцев
              <tr>
                <td colspan="4"><f:input path="no4" type="text" cssClass="form-control" maxlength="60"/>
            </table>
          </div>
        </div>
        <div class="tab-pane fade" id="messages">
          <div class="panel-body">
            <table class="formTable" width="700px">
              <tr>
                <td class="right" nowrap>Жалобы:
                <td colspan="3"><f:textarea path="jaloby" rows="5" class="form-control" maxlength="1500"/>
              <tr>
                <td class="right" nowrap>Анамнез:
                <td colspan="3"><f:textarea path="anamnez" rows="5" class="form-control" maxlength="1500"/>
              <tr>
                <td colspan="4" class="bold">Status praesens
              <tr>
                <td class="right" nowrap>Общее состояние:
                <td><f:input path="c1" class="form-control" maxlength="200"/>
                <td class="right" nowrap>Сознание:
                <td><f:input path="c2" class="form-control" maxlength="200"/>
              <tr>
                <td class="right" nowrap>Положение:
                <td><f:input path="c3" class="form-control" maxlength="200"/>
                <td class="right" nowrap>Телосложение:
                <td><f:input path="c4" class="form-control" maxlength="200"/>
              <tr>
                <td class="right" nowrap>Клечатка:
                <td><f:input path="c5" class="form-control" maxlength="200"/>
                <td class="right" nowrap>Костно-мышечная сис.:
                <td><f:input path="c6" class="form-control" maxlength="200"/>
              <tr>
                <td class="right" nowrap>Суставы:
                <td><f:input path="c7" class="form-control" maxlength="200"/>
                <td class="right" nowrap>Лимфатические узлы:
                <td><f:input path="c8" class="form-control" maxlength="200"/>
              <tr>
                <td class="right" nowrap>Грудная клетка:
                <td><f:input path="c9" class="form-control" maxlength="200"/>
                <td class="right" nowrap>Число дыхания:
                <td><f:input path="c10" class="form-control" maxlength="200"/>
              <tr>
                <td class="right" nowrap>Перкуссия грудной клетки:
                <td><f:input path="c11" class="form-control" maxlength="200"/>
                <td class="right" nowrap>Аускультация легких:
                <td><f:input path="c12" class="form-control" maxlength="200"/>
              <tr>
                <td class="right" nowrap>Осмотр сердечной области:
                <td colspan="4"><f:input path="c13" class="form-control" maxlength="200"/>
              <tr>
                <td colspan="4" class="bold">Перкуссия границы сердца
              <tr>
                <td class="right" nowrap>Правая:
                <td><f:input path="c14" class="form-control" maxlength="200"/>
                <td class="right" nowrap>Левая:
                <td><f:input path="c15" class="form-control" maxlength="200"/>
              <tr>
                <td class="right" nowrap>Верхняя:
                <td><f:input path="c16" class="form-control" maxlength="200"/>
                <td>&nbsp;
                <td>&nbsp;
              <tr>
                <td class="right bold" nowrap>Аускультация сердца:
                <td><f:input path="c17" class="form-control" maxlength="200"/>
                <td class="right" nowrap>на аорте:
                <td><f:input path="c18" class="form-control" maxlength="200"/>
              <tr>
                <td class="right" nowrap>на легочной артерии:
                <td><f:input path="c19" class="form-control" maxlength="200"/>
                <td>&nbsp;
                <td>&nbsp;
              <tr>
                <td class="right" nowrap>Пульс: Частота:
                <td><f:input path="c20" class="form-control" maxlength="200"/>
                <td class="right" nowrap>ритм:
                <td><f:input path="c21" class="form-control" maxlength="200"/>
              <tr>
                <td class="right" nowrap>наполнение:
                <td><f:input path="c22" class="form-control" maxlength="200"/>
                <td class="right" nowrap>напряжение:
                <td><f:input path="c23" class="form-control" maxlength="200"/>
              <tr>
                <td class="right" nowrap>дефицит пульса:
                <td><f:input path="c24" class="form-control" maxlength="200"/>
                <td>&nbsp;
                <td>&nbsp;
              <tr>
                <td class="right" nowrap>Артериальное давление:
                <td><f:input path="c25" class="form-control" maxlength="200"/>
                <td>&nbsp;
                <td>&nbsp;
              <tr>
                <td class="right" nowrap>Язык:
                <td><f:input path="c26" class="form-control" maxlength="200"/>
                <td class="right" nowrap>Живот:
                <td><f:input path="c27" class="form-control" maxlength="200"/>
              <tr>
                <td class="right" nowrap>Печень:
                <td><f:input path="c28" class="form-control" maxlength="200"/>
                <td class="right" nowrap>Селезенка:
                <td><f:input path="c29" class="form-control" maxlength="200"/>
              <tr>
                <td class="right" nowrap>Стул:
                <td><f:input path="c30" class="form-control" maxlength="200"/>
                <td class="right" nowrap>Мочеиспускание:
                <td><f:input path="c31" class="form-control" maxlength="200"/>
              <tr>
                <td class="right" nowrap>Боли в области почек:
                <td colspan="4"><f:input path="c32" class="form-control" maxlength="200"/>
              <tr>
                <td class="right" nowrap>Симптом Пастернацкого:
                <td colspan="4"><f:input path="c33" class="form-control" maxlength="200"/>
              <tr>
                <td class="right" nowrap>Периферические отеки:
                <td colspan="4"><f:input path="c34" class="form-control" maxlength="200"/>
              <tr>
                <td class="right" nowrap>Время поступления:
                <td colspan="4"><f:input path="c35" class="form-control" maxlength="200"/>
            </table>
          </div>
          <div class="panel-footer center" style="display:none !important">
            <button class="btn btn-success" id="saveBtn" type="submit" title="<ui:message code="save"/>"><ui:message code="save"/></button>
          </div>
        </div>
      </div>
    </f:form>
  </div>
  <!-- /.panel-body -->
</div>
<iframe id="frmDiv" name="frm" onload="doSave()" class="hidden"></iframe>