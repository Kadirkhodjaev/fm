<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<script src="/res/js/common.js"></script>
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<script src="/res/js/jquery.maskedinput.js" type="text/javascript"></script>
<script>
  $(".chzn-select").chosen();
  $("#birthdate").mask("99.99.9999",{placeholder:"dd.mm.yyyy"});
  function doSave() {
    if (checkForm($('#bf'))) {
      $.ajax({
        url: '/amb/reg.s',
        method: 'post',
        data: $('#bf').serialize(),
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            setPage('/amb/reg.s?id=' + res.id);
          }
        }
      });
    }
  }
  function delPatient(){
    if (confirm('Вы действительно хотите удалить данного пациента?')) {
      $.ajax({
        url: '/amb/del.s',
        method: 'post',
        data: 'id=${patient.id}',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/amb/reg.s');
          }
        }
      });
    }
  }
  function setCountery(dom) {
    $('#regionId').toggle(dom.value == '199').val('');
    $('#region_id').toggle(dom.value == '199').val('');
  }
  function delService(id) {
    if (confirm('Вы действительно хотите удалить?')) {
      $.ajax({
        url: '/amb/delSer.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/amb/reg.s?id=${patient.id}');
          }
        }
      });
    }
  }
  function patientConfirm() {
    if (confirm('Отправить к оплате?')) {
      $.ajax({
        url: '/amb/confirm.s',
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/amb/reg.s');
          }
        }
      });
    }
  }
  function archiveIt() {
    if (confirm('Отправить в архив?')) {
      $.ajax({
        url: '/amb/confirm.s',
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/amb/home.s');
          } else alert(res.msg);
        }
      });
    }
  }
  function printService(id) {
    var ids='';
    $('input[name="sers' + (id == null ? '' : id) + '"]').each(function() {
      if($(this).prop('checked')) {
        ids += $(this).val() + '_';
      }
    });
    if (ids.length == 0) {
      alert('Выберите услугу для печати');
      return;
    }
    window.open('/amb/print.s?ids=' + ids);
  }
  function ambReg() {
    setPage('/amb/reg.s?reg=${patient.id}');
  }
  function setAllCheck(dom, id) {
    var els = document.getElementsByName("sers" + (id == null ? '' : id));
    for (var i=0;i<els.length;i++) {
      els[i].checked = dom.checked
    }
  }
  function fizioterapia() {
    if (confirm('Назначить физиотерапию?')) {
      $.ajax({
        url: '/amb/fizio.s',
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/amb/reg.s?id=${patient.id}');
          }
        }
      });
    }
  }
  function fizioterapiaPrint() {
    window.open('/amb/print.s?fizio=Y');
  }
  function reiterativeConsul(id) {
    if (confirm('Повторная консультация в течении 5 дней?')) {
      $.ajax({
        url: '/amb/reiterativeConsul.s',
        data: 'id=' + id,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/amb/reg.s?id=${patient.id}');
          }
        }
      });
    }
  }
  function openDrug() {
    $('#amb_drug').load('/amb/drug/view.s', () => {
      $('#modal_window').click();
    });
  }
  function setClient(id) {
    $.ajax({
      url: '/client/get.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          $('#surname').val(res.surname);
          $('#name').val(res.name);
          $('#middlename').val(res.middlename);
          $('#birthyear').val(res.birthdate.substr(6, 4));
          $('#sex_id').val(res.sex_id);
          $('#passportInfo').val(res.doc_seria + ' ' +  res.doc_num + ' ' + res.doc_info);
          $('#tel').val(res.tel);
          $('#counteryId').val(res.country_id);
          $('#regionId').val(res.region_id);
          $('#address').val(res.address);
        } else {
          alert(res.msg)
        }
      }
    });
  }
  function addClient(){
    if (checkForm($('#clientForm'))) {
      $.ajax({
        url: '/client/save.s',
        method: 'post',
        data: $('#clientForm').serialize(),
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("Данные успешно сохранены");
            $('#close-modal').click();
            $('#client-selector').each(function (elem, dom) {
              dom.options[dom.options.length] = new Option(res.fio, res.id);
              $(this).trigger('liszt:updated');
            });
            $("#client-selector").val(res.id).trigger("liszt:updated");
            setClient(res.id);
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
  function loadPdf() {
    $('#pdffile').attr('src', 'http://31.135.213.158:8745/result?id=${patient.qrcode}');
  }
  function setArchPartner(id) {
    $.ajax({
      url: '/amb/setPartner.s',
      method: 'post',
      data: 'id=${patient.id}&partner=' + id,
      dataType: 'json',
      success: function (res) {
        openMsg(res);
      }
    });
  }
</script>
<iframe id="frmDiv" name="frm" class="hidden"></iframe>
<div class="panel panel-info" style="width: 900px !important; margin: auto">
  <div class="panel-heading">
    <span title="${patient.id}" onclick="setPage('/ambs/reg.s?id=${patient.id}')">Реквизиты пациента</span>
    <ul class="pagination" style="float:right; margin-top:-5px">
      <c:if test="${patient.state != 'ARCH'}">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="doSave()"><i title="Сохранить" class="fa fa-save"></i> Сохранить</a></li>
        <c:if test="${patient.fizio != 'Y' && patient.id != null}">
          <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="fizioterapia()"><i title="Физиотерапия" class="fa fa-file-sound-o"></i> Физиотерапия</a></li>
        </c:if>
        <c:if test="${drug_exist}">
          <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="openDrug()"><i title="Физиотерапия" class="fa fa-list"></i> Лист назначение</a></li>
        </c:if>
        <c:if test="${patient.fizio == 'Y' && patient.id != null && fizio_user}">
          <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="fizioterapiaPrint()"><i title="Физиотерапия печать" class="fa fa-print"></i> Физиотерапия печать</a></li>
        </c:if>
      </c:if>
      <c:if test="${patient.id != null && patient.state == 'PRN'}">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="delPatient()"><i title="Удалить" class="fa fa-remove"></i> Удалить</a></li>
        <c:if test="${fn:length(services) > 0}">
          <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="patientConfirm()"><i title="Подтвердить" class="fa fa-check"></i> Подтвердить</a></li>
        </c:if>
      </c:if>
      <c:if test="${done}">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="archiveIt()"><i title="Отправить в архив" class="fa fa-arrow-right"></i> Архивация</a></li>
      </c:if>
      <c:if test="${patient.state == 'ARCH' && sessionScope.ENV.roleId == 15}">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="ambReg()"><i title="Регистрация" class="fa fa-reorder"></i> Регистрация</a></li>
      </c:if>
      <c:if test="${patient.state != 'ENT' && sessionScope.ENV.roleId == 15}">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="loadPdf()"><i title="Генерация PDF файла" class="fa fa-reorder"></i> Результаты PDF</a></li>
        <iframe name="pdffile" id="pdffile" src="about:blank" style="display: none"></iframe>
      </c:if>
    </ul>
  </div>
  <f:form commandName="patient" action='/amb/reg.s' method="post" id='bf' target="frm">
    <f:hidden path="id"/>
    <input type="hidden" name="regId" value="${regId}"/>
    <div class="panel-body">
      <%@include file="/incs/msgs/successError.jsp"%>
      <table class="formTable">
        <c:if test="${patient.id == null}">
          <tr>
            <td class="right" nowrap>Клиент<d></d>:</td>
            <td colspan="3">
                <table width="100%">
                  <tr>
                    <td style="width:90%">
                      <select id="client-selector" data-placeholder="Выбрать клиента" name="client" class="form-control chzn-select" onchange="setClient(this.value)">
                        <option></option>
                        <c:forEach items="${clients}" var="client">
                          <option value="${client.id}">${client.surname} ${client.name} ${client.middlename}</option>
                        </c:forEach>
                      </select>
                    </td>
                    <td style="width:9%" class="text-center">
                      <button type="button" class="btn btn-success" onclick="$('#clientForm').trigger('reset');$('#client_window').click()" style="height:20px;padding:0px 8px">
                        <b class="fa fa-plus"></b>
                      </button>
                    </td>
                  </tr>
                </table>
            </td>
          </tr>
        </c:if>
        <tr>
          <td class="right" nowrap>ФИО<d></d>:</td>
          <td colspan="3">
            <f:input path="surname" title="Фамилия" placeholder="Фамилия" cssStyle="width:167px; display:inline;margin-right:10px" type="text" class="form-control" required="true" maxlength="64" autofocus="1" autocomplete="off"/>
            <f:input path="name" title="Исми" placeholder="Исми" cssStyle="width:167px; display:inline;margin-right:10px" type="text" class="form-control" required="true"  maxlength="64" autocomplete="off"/>
            <f:input path="middlename" title="Шарифи" placeholder="Шарифи" cssStyle="width:167px; float: right" type="text" class="form-control" maxlength="64" autocomplete="off"/>
          </td>
        </tr>
        <tr>
          <td class="right" nowrap><ui:message code="birthyear"/>:</td>
          <td><f:input path="birthyear" type="number" class="form-control center" placeholder="xxxx" style="width:100px;" maxlength="4" /></td>
          <td class="right" nowrap><ui:message code="sex"/>:</td>
          <td>
            <f:select path="sex.id" id="sex_id" class="form-control">
              <f:options items="${sex}" itemValue="id" itemLabel="name"></f:options>
            </f:select>
        </tr>
        <tr>
          <td class="right" nowrap><ui:message code="phone"/>:</td>
          <td><f:input path="tel" type="text" class="form-control" maxlength="400"/></td>
          <td class="right" nowrap><ui:message code="passportInfo"/>:</td>
          <td><f:input path="passportInfo" type="text" class="form-control" maxlength="64"/></td>
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
          <td class="right" nowrap><ui:message code="address"/>:</td>
          <td colspan="3"><f:input path="address" type="text" class="form-control" maxlength="400"/></td>
        </tr>
        <c:if test="${sessionScope.ENV.roleId == 15}">
          <tr>
            <td class="right" nowrap colspan="2">Код отправителя (Лечащего врача):</td>
            <td colspan="2">
              <c:if test="${sessionScope.ENV.userId == 1 && patient.state == 'ARCH'}">
                <select class="form-control" onchange="setArchPartner(this.value)">
                  <option value=""></option>
                  <c:forEach items="${lvpartners}" var="partner">
                    <option value="${partner.id}" <c:if test="${partner.id == patient.lvpartner.id}">selected</c:if>>${partner.code}</option>
                  </c:forEach>
                </select>
              </c:if>
              <c:if test="${!(sessionScope.ENV.userId == 1 && patient.state == 'ARCH')}">
                <f:select path="lvpartner.id" class="form-control">
                  <f:option value=""></f:option>
                  <f:options items="${lvpartners}" itemValue="id" itemLabel="code"></f:options>
                </f:select>
              </c:if>
            </td>
          </tr>
        </c:if>
        <tr>
        <tr>
          <td class="right" nowrap colspan="2">Мобильный номер (Телеграм и СМС):</td>
          <td colspan="2"><f:input path="tgNumber" type="number" class="form-control" maxlength="15"/></td>
        </tr>
        <tr>
          <td class="right" nowrap colspan="2">&nbsp;</td>
          <td class="right" nowrap colspan="2" style="font-size: 10px">Номер телефона пищется без символа "+" и без пробелов с кодом страны</td>
        </tr>
      </table>
    </div>
    <c:if test="${patient.id != null}">
      <div class="panel panel-info" style="margin-left:-1px; width: 100% !important;">
        <div class="panel-heading">
          Услуги
          <div style="float:right">
            <button class="btn btn-sm" type="button" onclick="printService(null)" style="margin-top: -5px"><span class="fa fa-print"></span> Печать</button>
            <c:if test="${patient.state != 'ARCH'}">
              <button class="btn btn-sm btn-success" type="button" onclick="openMainPage('/amb/services.s')" style="margin-top: -5px"><i class="fa fa-plus"></i> Услуги</button>
            </c:if>
          </div>
        </div>
        <div>
          <table class="table table-bordered">
            <tr>
              <td class="center bold">№</td>
              <td class="center bold"><input type="checkbox" onclick="setAllCheck(this, null)"></td>
              <td class="center bold">&nbsp;</td>
              <td class="center bold">Наименование</td>
              <td class="center bold">Сумма</td>
              <td class="center bold">С НДС</td>
              <td class="center bold">Подтверждение</td>
              <td class="center bold">Врач</td>
              <c:if test="${patient.state != 'ARCH'}">
                <td class="center bold" style="width: 30px">Уд.</td>
              </c:if>
              <td class="center bold" style="width: 30px">Пов.</td>
            </tr>
            <c:forEach items="${services}" var="ser" varStatus="loop">
              <tr id="ser${ser.id}">
                <td class="center">${loop.index + 1}</td>
                <td class="center hand" title="Печать">
                  <c:if test="${ser.state == 'DONE'}">
                    <input type="checkbox" name="sers" value="${ser.id}"/>
                  </c:if>
                </td>
                <td class="center">
                  <c:if test="${ser.state == 'DEL'}"><span style="color:red;font-weight:bold">Возврат</span></c:if>
                  <c:if test="${ser.state == 'AUTO_DEL'}"><span style="color:red;font-weight:bold">Удален</span></c:if>
                  <c:if test="${ser.state == 'ENT'}"><img src='/res/imgs/red.gif'/></c:if>
                  <c:if test="${ser.state == 'PAID'}"><img src='/res/imgs/yellow.gif'/></c:if>
                  <c:if test="${ser.state == 'DONE'}"><img src='/res/imgs/green.gif'/></c:if>
                </td>
                <td <c:if test="${ser.state == 'ENT'}">style="color:red"</c:if>>
                  ${ser.service.name}
                </td>
                <td class="right" style="padding-right:7px">${ser.price}</td>
                <td class="right" style="padding-right:7px">${ser.nds}</td>
                <td class="center" nowrap style="padding-right:7px"><fmt:formatDate pattern = "dd.MM.yyyy HH:mm" value = "${ser.confDate}" /></td>
                <td class="center">
                  <input type="hidden" name="service" value="${ser.id}"/>
                  <select name="user" class="form-control">
                    <c:forEach items="${ser.users}" var="u">
                      <option <c:if test="${ser.worker.id == u.id}">selected</c:if> value="${u.id}">${u.fio}</option>
                    </c:forEach>
                  </select>
                </td>
                <c:if test="${patient.state != 'ARCH'}">
                  <td class="center">
                    <c:if test="${ser.state == 'ENT'}">
                      <button class="btn btn-danger btn-sm" style="height:20px;padding:1px 10px" title="Удалить" onclick="delService(${ser.id})"><span class="fa fa-minus"></span></button>
                    </c:if>
                  </td>
                </c:if>
                <td class="center">
                  <c:if test="${ser.repeat}">
                    <button class="btn btn-primary btn-sm" style="height:20px;padding:1px 10px" title="Повторная консультация" onclick="reiterativeConsul(${ser.id})"><span class="fa fa-repeat"></span></button>
                  </c:if>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${serviceTotal > 0}">
              <tr style="font-weight: bold">
                <td class="center">&nbsp;</td>
                <td class="center">&nbsp;</td>
                <td class="center">&nbsp;</td>
                <td>ИТОГО не оплаченных</td>
                <td class="right" style="padding-right:7px">
                  <fmt:formatNumber value = "${serviceTotal}" type = "number"/>
                </td>
                <td class="right" style="padding-right:7px">
                  <fmt:formatNumber value = "${ndsTotal}" type = "number"/>
                </td>
                <td class="center">&nbsp;</td>
                <td class="center">&nbsp;</td>
                <td class="center">&nbsp;</td>
              </tr>
            </c:if>
          </table>
        </div>
      </div>
    </c:if>
  </f:form>
  <c:if test="${patient.id != null}">
    <c:forEach items="${histories}" var="his" varStatus="loop">
      <div class="panel panel-info" style="margin-left:-1px; width: 100% !important;">
        <div class="panel-heading">
          История - <fmt:formatDate pattern = "dd.MM.yyyy" value = "${his.regDate}" />
          <div style="float:right">
            <button class="btn btn-sm" type="button" onclick="printService(${his.id})" style="margin-top: -5px"><span class="fa fa-print"></span> Печать</button>
          </div>
        </div>
        <div>
          <table class="table table-bordered">
            <tr>
              <td class="center bold">№</td>
              <td class="center bold"><input type="checkbox" onclick="setAllCheck(this, ${his.id})"></td>
              <td class="center bold">Наименование</td>
              <td class="center bold">Сумма</td>
              <td class="center bold">C НДС</td>
            </tr>
            <c:forEach items="${his.services}" var="ser" varStatus="loop">
              <tr id="ser${ser.id}">
                <td class="center">${loop.index + 1}</td>
                <td class="center hand" title="Печать">
                  <c:if test="${ser.state == 'DONE'}">
                    <input type="checkbox" name="sers${his.id}" value="${ser.id}"/>
                  </c:if>
                </td>
                <td <c:if test="${ser.state == 'ENT'}">style="color:red"</c:if>>
                    ${ser.service.name}
                </td>
                <td class="right" style="padding-right:7px">${ser.price}</td>
                <td class="right" style="padding-right:7px">${ser.nds}</td>
              </tr>
            </c:forEach>
          </table>
        </div>
      </div>
    </c:forEach>
  </c:if>
</div>

<a href="#" data-toggle="modal" data-target="#myModal" id="client_window" class="hidden"></a>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog" style="width:800px">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="clientModalLabel">Реквизиты клиента</h4>
      </div>
      <div class="modal-body">
        <form id="clientForm" name="clientForm">
          <table class="formTable">
            <tr>
              <td class="right" nowrap>ФИО<d></d>:</td>
              <td colspan="3">
                <input name="surname" title="Фамилия" placeholder="Фамилия" style="width:167px; display:inline;margin-right:10px" type="text" class="form-control" required="true" maxlength="64" autocomplete="off"/>
                <input name="name" title="Исми" placeholder="Исми" style="width:167px; display:inline;margin-right:10px" type="text" class="form-control" required="true"  maxlength="64" autocomplete="off"/>
                <input name="middlename" title="Шарифи" placeholder="Шарифи" style="width:167px; float: right" type="text" class="form-control" maxlength="64" autocomplete="off"/>
              </td>
            </tr>
            <tr>
              <td class="right" nowrap>Дата рождения:</td>
              <td>
                <input name="birthdate" id="birthdate" type="text" class="form-control center" placeholder="dd.mm.yyyy" style="width:100px;" maxlength="10"/>
              </td>
              <td class="right" nowrap><ui:message code="sex"/>:</td>
              <td>
                <select name="sex_id" class="form-control">
                  <c:forEach items="${sex}" var="sx">
                    <option value="${sx.id}">${sx.name}</option>
                  </c:forEach>
                </select>
              </td>
            </tr>
            <tr>
              <td class="right" nowrap>Серия паспорта:</td>
              <td><input name="doc_seria" type="text" class="form-control text-center" maxlength="2" placeholder="XX"/></td>
              <td class="right" nowrap>Номер паспорта:</td>
              <td><input name="doc_num" type="text" class="form-control text-center" maxlength="10" placeholder="XXXXXXX"/></td>
            </tr>
            <tr>
              <td class="right" nowrap><ui:message code="passportInfo"/>:</td>
              <td><input name="doc_info" type="text" class="form-control" maxlength="64"/></td>
              <td class="right" nowrap><ui:message code="phone"/>:</td>
              <td><input name="tel" type="number" class="form-control"/></td>
            </tr>
            <tr>
              <td class="right" nowrap>Резиденство:</td>
              <td>
                <select name="country_id" class="form-control" onchange="setCountery(this)">
                  <c:forEach items="${counteries}" var="ss">
                    <option value="${ss.id}">${ss.name}</option>
                  </c:forEach>
                </select>
              </td>
              <td class="right" nowrap>Область:</td>
              <td>
                <select name="region_id" id="region_id" class="form-control">
                  <c:forEach items="${regions}" var="reg">
                    <option value="${reg.id}">${reg.name}</option>
                  </c:forEach>
                </select>
              </td>
            </tr>
            <tr>
              <td class="right" nowrap><ui:message code="address"/>:</td>
              <td colspan="3"><input name="address" type="text" class="form-control" maxlength="400"/></td>
            </tr>
          </table>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" onclick="addClient()">Сохранить</button>
        <button type="button" class="btn btn-default" id="close-modal" data-dismiss="modal">Закрыть</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>

<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog" style="width:100%">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel">Лист назначение</h4>
      </div>
      <div class="modal-body" id="amb_drug"></div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
