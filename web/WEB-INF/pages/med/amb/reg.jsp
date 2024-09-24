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
<link href="/res/css/styles.css" rel="stylesheet">
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
  function loadPdf() {
    //$('#pdffile').attr('src', 'http://31.135.213.158:8745/result?id=${patient.qrcode}');
    $('#pdffile').attr('src', 'http://qr:8745/result?id=${patient.qrcode}');
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

  //region Client Block
  $('input[name=client_name]').keyup( () => {
    <c:if test="${patient.id != null}">return;</c:if>
    let div = $('#client_filter'), elem = $('input[name=client_name]'), v = elem.val().toUpperCase();
    div.width(elem.width() + 12);

    if(v.length === 0) div.hide();
    if(v.length > 3) {
      if(clients.length === 0) {
        $.ajax({
          url: '/clients/search_by_letters.s',
          method: 'post',
          data: 'word=' + v,
          dataType: 'json',
          success: function (res) {
            if (res.success) {
              clients = res.clients;
              if(clients.length > 0) {
                buildClients(clients);
                div.show();
              } else openMedMsg('Данные не найдены', false);
            } else openMsg(res);
          }
        });
      } else {
        let cls = clients.filter(obj => obj.name.toUpperCase().indexOf(v) !== -1);
        buildClients(cls);
      }
    } else {
      clients = [];
    }
  });
  function buildClients(cls) {
    let table = $('#client_filter>table>tbody');
    table.html('');
    for(let client of cls) {
      let tr = $('<tr cid="' + client.id + '"></tr>');
      tr.click(()=> {
        $('#client_filter').hide();
        $('#client_buttons .btn-success').hide();
        $('#client_buttons .btn-info').show();
        $('#client_buttons .btn-danger').show();
        $('#client_buttons').width(80);
        setClient(tr.attr('cid'));
      });
      let fio = $('<td>' + client.name + '</td>');
      let bd = $('<td class="center">' + client.birthdate + '</td>');
      tr.append(fio).append(bd);
      table.append(tr);
    }
  }
  function setClient(id) {
    let client = id === 0 ? {} : clients.filter(obj => obj.id == id)[0];
    $('input[name=client_id]').val(client.id);
    $('input[name=client_name]').val(client.name).attr('readonly', id !== 0);
    $('input[name=birthday]').val(client.birthdate);
    $('input[name=sex_id]').val(client.sex);
    $('input[name=country]').val(client.country);
    $('input[name=region]').val(client.region);
    $('input[name=passport]').val(client.passport);
    $('input[name=address]').val(client.address);
    $('input[name=tel]').val(client.tel);
  }
  $('#client_buttons .btn-danger').click(()=> {
    $('#client_buttons .btn-success').show();
    $('#client_buttons .btn-info').hide();
    $('#client_buttons .btn-danger').hide();
    $('#client_buttons').width(40);
    clients = [];
    setClient(0);
  });
  function saveClient() {
    if(checkForm($('#clientForm'))) {
      $.ajax({
        url: '/clients/save.s',
        method: 'post',
        data: $('#clientForm').serialize(),
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success) {
            updateClientInfo(res.id);
          }
        }
      });
    }
  }
  function updateClientInfo(id) {
    $.ajax({
      url: '/clients/get.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        if(res.success) {
          $('input[name=client_id]').val(res.id);
          $('input[name=client_name]').val(res.fio).attr('readonly', id !== 0);
          $('input[name=birthday]').val(res.birthdate);
          $('input[name=sex_id]').val(res.sex_name);
          $('input[name=passport]').val(res.passport);
          $('input[name=country]').val(res.country_name);
          $('input[name=region]').val(res.region_name);
          $('input[name=address]').val(res.address);
          $('input[name=tel]').val(res.tel);
          getDOM('close_client_info').click();
        } else openMedMsg(res.msg, false);
      }
    });
  }
  function clientView() {
    let client_id = $('input[name=client_id]').val();
    $.ajax({
      url: '/clients/get.s',
      method: 'post',
      data: 'id=' + client_id,
      dataType: 'json',
      success: function (res) {
        if(res.success) {
          $('input[name=cl_id]').val(res.id);
          $('input[name=cl_surname]').val(res.surname);
          $('input[name=cl_name]').val(res.name);
          $('input[name=cl_middlename]').val(res.middlename);
          $('input[name=cl_birthdate]').val(res.birthdate);
          $('select[name=cl_sex_id]').val(res.sex_id);
          $('input[name=cl_doc_seria]').val(res.doc_seria);
          $('input[name=cl_doc_num]').val(res.doc_num);
          $('input[name=cl_doc_info]').val(res.doc_info);
          $('input[name=cl_tel]').val(res.tel);
          $('select[name=cl_country_id]').val(res.country_id);
          $('select[name=cl_region_id]').val(res.region_id);
          $('input[name=cl_address]').val(res.address);
          $('#btn_client_view').click();
        } else openMedMsg(res.msg, false);
      }
    });
  }
  function addClient() {
    getDOM('clientForm').reset();
    $('select[name=cl_country_id]').val('199')
    $('#btn_client_view').click();
  }
  //endregion
  $(".date-format").mask("99.99.9999",{placeholder:"dd.mm.yyyy"});
</script>
<button class="hidden" id="btn_client_view" data-toggle="modal" data-target="#client_info"></button>
<div class="modal fade" id="client_info" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog wpx-1000">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title text-danger"><b class="fa fa-user"></b> Реквизиты клиента</h4>
      </div>
      <div class="modal-body">
        <form id="clientForm" name="clientForm">
          <input type="hidden" name="cl_id"/>
          <table class="formTable w-100">
            <tr>
              <td class="right" nowrap>ФИО <req>*</req>:</td>
              <td colspan="3">
                <table class="w-100">
                  <tr>
                    <td>
                      <input name="cl_surname" title="Фамилия" placeholder="Фамилия" type="text" class="form-control w-100" required="true" maxlength="64" autocomplete="off"/>
                    </td>
                    <td>
                      <input name="cl_name" title="Исми" placeholder="Исми" type="text" class="form-control w-100" required="true"  maxlength="64" autocomplete="off"/>
                    </td>
                    <td>
                      <input name="cl_middlename" title="Шарифи" placeholder="Шарифи" class="form-control w-100" maxlength="64" autocomplete="off"/>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr>
              <td class="right" nowrap>Дата рождения <req>*</req>:</td>
              <td>
                <input name="cl_birthdate" type="text" class="form-control center date-format" placeholder="dd.mm.yyyy" style="width:100px;" maxlength="10"/>
              </td>
              <td class="right" nowrap>Пол <req>*</req>:</td>
              <td>
                <select name="cl_sex_id" class="form-control">
                  <c:forEach items="${sex}" var="sx">
                    <option value="${sx.id}">${sx.name}</option>
                  </c:forEach>
                </select>
              </td>
            </tr>
            <tr>
              <td class="right" nowrap>Серия паспорта:</td>
              <td><input name="cl_doc_seria" type="text" class="form-control text-center uppercase" maxlength="2" placeholder="XX"/></td>
              <td class="right" nowrap>Номер паспорта:</td>
              <td><input name="cl_doc_num" type="text" class="form-control text-center" maxlength="10" placeholder="XXXXXXX"/></td>
            </tr>
            <tr>
              <td class="right" nowrap>Паспортные данные:</td>
              <td><input name="cl_doc_info" type="text" class="form-control" maxlength="64"/></td>
              <td class="right" nowrap>Номер телефона:</td>
              <td><input name="cl_tel" type="text" class="form-control" maxlength="400"/></td>
            </tr>
            <tr>
              <td class="right" nowrap>Резиденство <req>*</req>:</td>
              <td>
                <select name="cl_country_id" class="form-control" onchange="$('select[name=cl_region_id]').toggle(this.value === '199').val()">
                  <c:forEach items="${countries}" var="reg">
                    <option value="${reg.id}">${reg.name}</option>
                  </c:forEach>
                </select>
              </td>
              <td class="right" nowrap>Область:</td>
              <td>
                <select name="cl_region_id" class="form-control">
                  <option value=""></option>
                  <c:forEach items="${regions}" var="reg">
                    <option value="${reg.id}">${reg.name}</option>
                  </c:forEach>
                </select>
              </td>
            </tr>
            <tr>
              <td class="right" nowrap>Адрес:</td>
              <td colspan="3"><input name="cl_address" type="text" class="form-control" maxlength="400"/></td>
            </tr>
          </table>
        </form>
      </div>
      <div class="modal-footer">
        <button class="btn btn-success btn-sm" onclick="saveClient()">
          <i class="fa fa-save"></i> Сохранить
        </button>
        <button class="btn btn-danger btn-sm" id="close_client_info" data-dismiss="modal" aria-hidden="true">
          <i class="fa fa-remove"></i> Закрыть
        </button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>

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
      <%--<c:if test="${patient.state == 'ARCH' && sessionScope.ENV.roleId == 15}">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="ambReg()"><i title="Регистрация" class="fa fa-reorder"></i> Регистрация</a></li>
      </c:if>--%>
      <c:if test="${patient.id != null && patient.state != 'ENT' && sessionScope.ENV.roleId == 15}">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="loadPdf()"><i title="Генерация PDF файла" class="fa fa-reorder"></i> Результаты PDF</a></li>
        <iframe name="pdffile" id="pdffile" src="about:blank" style="display: none"></iframe>
      </c:if>
    </ul>
  </div>
  <f:form commandName="patient" action='/amb/reg.s' method="post" id='bf' target="frm">
    <f:hidden path="id"/>
    <div class="panel-body">
      <%@include file="/incs/msgs/successError.jsp"%>
      <table class="formTable">
        <tr>
          <td class="right">Клиент <req>*</req>:</td>
          <td colspan="3">
            <table class="w-100">
              <tr>
                <td>
                  <input type="hidden" name="client_id" value="${patient.client.id}">
                  <input type="text" class="form-control uppercase" name="client_name" placeholder="Ф.И.О." value="<c:if test="${patient.id != null}">${patient.fio}</c:if>" <c:if test="${patient.id != null}">readonly</c:if>/>
                  <div id="client_filter" style="display: none; position: absolute; background:white">
                    <table class="w-100 table-bordered tablehover p-3"><tbody></tbody></table>
                  </div>
                </td>
                <td class="center" style="<c:if test="${patient.id == null}">width:40px</c:if>" id="client_buttons">
                  <c:if test="${patient.id == null}">
                    <button type="button" class="btn btn-success btn-icon" onclick="addClient()">
                      <b class="fa fa-plus"></b>
                    </button>
                    <button type="button" class="btn btn-info btn-icon display-none" onclick="clientView()">
                      <b class="fa fa-user"></b>
                    </button>
                    <button type="button" class="btn btn-danger btn-icon display-none">
                      <b class="fa fa-remove"></b>
                    </button>
                  </c:if>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td class="right" nowrap>
            <c:if test="${patient.birthday == null}">Год рождения</c:if><c:if test="${patient.birthday != null}">Дата рождения</c:if>:
          </td>
          <td><input type="text" name="birthday" class="form-control center" readonly value="<c:if test="${patient.birthday == null}">${patient.birthyear}</c:if><c:if test="${patient.birthday != null}"><fmt:formatDate pattern="dd.MM.yyyy" value="${patient.birthday}"/></c:if>" placeholder="dd.mm.yyyy"/></td>
          <td class="right" nowrap><ui:message code="sex"/>:</td>
          <td><input type="text" name="sex_id" class="form-control center" readonly value="${patient.sex.name}"/></td>
        </tr>
        <tr>
          <td class="right" nowrap><ui:message code="phone"/>:</td>
          <td><f:input path="tel" type="text" class="form-control" maxlength="400"/></td>
          <td class="right" nowrap><ui:message code="passportInfo"/>:</td>
          <td><input type="text" name="passport" class="form-control center" readonly value="${patient.passportInfo}"/></td>
        </tr>
        <tr>
          <td class="right" nowrap>Резиденство:</td>
          <td><input type="text" name="country" class="form-control center" readonly value="${countryName}"/></td>
          <td class="right" nowrap>Область:</td>
          <td><input type="text" name="region" class="form-control center" readonly value="${regionName}"/></td>
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
