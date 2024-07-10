<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<script src="/res/js/jquery.maskedinput.js" type="text/javascript"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<script src="/res/js/jquery.maskedinput.js" type="text/javascript"></script>
<style>
    .kdoTable tr th {font-weight: bold; text-align: center}
</style>
<script>
  $(".chzn-select").chosen();
  $("#birthdate").mask("99.99.9999",{placeholder:"dd.mm.yyyy"});
  $("#birthdayString").mask("99.99.9999",{placeholder:"dd.mm.yyyy"});
  $('printButton').html("<button title='Печать' type='button' onclick='printPage()' class='btn btn-outline btn-primary print-button'><i class='fa fa-print'></i></button>");
  $('d').html('*').css('font-weight', 'bold').css('color', 'red');
  let rooms = [];
  <c:forEach items="${rooms}" var="rr">
    rooms.push({id:${rr.id}, dept:'${rr.dept.id}', name:'${rr.floor.name} ${rr.name}-${rr.roomType.name}'})
  </c:forEach>
  function saveForm() {
    if (checkForm($('#patient'))) {
      $.ajax({
        url: "/reg/nurse/index.s",
        method: "post",
        data: $('form[name=bf]').serialize(),
        dataType: 'json',
        success: function (json) {
          if (json.success) {
            alert("<ui:message code="successSave"/>");
            setPage('/reg/nurse/index.s?id=' + json.id);
          } else {
            alert(json.msg)
          }
        },
        error: function (data, err) {
          alert(err);
        }
      });
    } else {
      alert('Не заполнены обязательные поля');
    }
  }
  function printPage(){
    window.open("/lv/print.s");
  }
  function delPatient(){
    if(confirm('Вы действительно хотите данного пациента')) {
      $.ajax({
        url: "/reg/nurse/del.s",
        method: "post",
        data: '',
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if (res.success)
            setPage('/reg/nurse/index.s');
        }});
    }
  }
  function setCountery(dom) {
    $('#regionId').toggle(dom.value == '199').val('');
    $('#region_id').toggle(dom.value == '199').val('');
  }
  function confPatient() {
    setPage('/patients/confirm.s?id=${patient.id}');
  }
  function contract(){
    window.open('/patients/contract.s')
  }
  function setOtd(id) {
    $('#room_id').empty().append($('<option></option>'));
    rooms.forEach((dom) => {
      if(id === dom.dept)
        $('#room_id').append($('<option ' + ('${patient.room.id}' == dom.id ? 'selected ' : '') + 'value="' + dom.id + '">' + dom.name + '</option>'));
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
    $('input[name=birthdayString]').val(client.birthdate);
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
          $('input[name=birthdayString]').val(res.birthdate);
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
    $('#btn_client_view').click();
  }
  //endregion

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

<div class="panel panel-info" style="width: 800px !important; margin: auto">
  <div class="panel-heading">
    <span <c:if test="${patient.id != null}">title="${patient.id}"</c:if>>Бемор ҳақида маълумот</span>
    <ul class="pagination" style="float:right; margin-top:-5px">
      <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="saveForm()"><i title="Сохранить" class="fa fa-save"></i> Сохранить</a></li>
      <c:if test="${patient.id != null}">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="contract()"><i title="Подтвердить" class="fa fa-file"></i> Договор</a></li>
      </c:if>
      <c:if test="${patient.id != null && patient.state == 'PRN'}">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="confPatient()"><i title="Подтвердить" class="fa fa-check"></i> Подтвердить</a></li>
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="delPatient()"><i title="Удалить" class="fa fa-remove"></i> Удалить</a></li>
      </c:if>
    </ul>
  </div>
  <f:form commandName="patient" action='/reg/nurse/index.s' method="post" name='bf' target="frm">
    <f:hidden path="id"/>
    <input type="hidden" name="reg" value="${reg}"/>
    <input type="hidden" name="booking" value="${booking}"/>
    <div class="panel-body">
      <%@include file="/incs/msgs/successError.jsp"%>
      <%@include file="/incs/msgs/errors.jsp"%>
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
          <td class="right" nowrap>Тугилган сана:</td>
          <td><input type="text" name="birthdayString" class="form-control center" readonly value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${patient.birthday}" />" placeholder="dd.mm.yyyy"/></td>
          <td class="right" nowrap>Жинси:</td>
          <td><input type="text" name="sex_id" class="form-control center" readonly value="${patient.sex.name}"/></td>
        </tr>
        <tr>
          <td class="right" nowrap>Буйи:</td>
          <td><f:input path="rost" type="text" class="form-control center" placeholder="xxx" style="width:70px;" maxlength="3" /></td>
          <td class="right" nowrap>Огирлиги:</td>
          <td><f:input path="ves" type="text" class="form-control center" placeholder="xxx.x" style="width:70px;" maxlength="5" /></td>
        </tr>
        <tr>
          <td class="right" nowrap>Иш жойи:</td>
          <td><f:input path="work" type="text" class="form-control" maxlength="64"/></td>
          <td class="right" nowrap>Мансаби:</td>
          <td><f:input path="post" type="text" class="form-control" maxlength="64"/></td>
        </tr>
        <tr>
          <td class="right" nowrap>Фукоролик:</td>
          <td><input type="text" name="country" class="form-control center" readonly value="${countryName}"/></td>
          <td class="right" nowrap>Вилоят:</td>
          <td><input type="text" name="region" class="form-control center" readonly value="${regionName}"/></td>
        </tr>
        <tr>
          <td class="right" nowrap>Манзили:</td>
          <td><input type="text" name="address" class="form-control center" readonly value="${patient.address}"/></td>
          <td class="right" nowrap>Паспорт маълумотлари:</td>
          <td><input type="text" name="passport" class="form-control center" readonly value="${patient.passportInfo}"/></td>
        </tr>
        <tr>
          <td class="right" nowrap>Телефон раками:</td>
          <td><f:input path="tel" type="text" class="form-control" maxlength="400"/></td>
          <td class="right" nowrap>Амб. картаси раками:</td>
          <td><f:input path="ambNum" type="text" class="form-control center" maxlength="30"/></td>
        </tr>
        <tr>
          <td class="right" nowrap>Қон гуруҳи:</td>
          <td>
            <f:select path="bloodGroup.id" class="form-control" items="${bloodGroup}" itemValue="id" itemLabel="name"/>
          </td>
          <td class="right" nowrap>Резус мансублиги:</td>
          <td><f:input path="resus" type="text" class="form-control" maxlength="100" /></td>
        </tr>
        <tr>
          <td class="right" nowrap>Бемор қайердан юборилган:</td>
          <td><f:input path="orientedBy" type="text" class="form-control" maxlength="100" /></td>
          <td class="right" nowrap>Транспортда:</td>
          <td><f:input path="transport" type="text" class="form-control" maxlength="64"/></td>
        </tr>
        <tr>
          <td class="right" nowrap>Олиб юриш турлари:</td>
          <td><f:select path="vidPer.id" class="form-control" items="${vidPer}" itemValue="id" itemLabel="name"/></td>
          <td class="right" nowrap>Харорати:</td>
          <td><f:input path="temp" type="text" class="form-control center" placeholder="xx.x" style="width:70px;" maxlength="4" /></td>
        </tr>
        <tr>
          <td class="right" nowrap>Метка:</td>
          <td><f:select path="metka.id" class="form-control" items="${metka}" itemValue="id" itemLabel="name"/></td>
          <td class="right" nowrap>Руйхатга олинган вакт</td>
          <td><f:input path="time" type="text" class="form-control" maxlength="400"/></td>
        </tr>
        <tr>
          <td class="right" nowrap>Булим<d></d>:
          <td><f:select path="dept.id" required="true" class="form-control" onchange="setOtd(this.value)">
            <option></option>
              <f:options items="${deps}" itemValue="id" itemLabel="name"/>
            </f:select>
          <td class="right" nowrap>№ Хона<d></d>:</td>
          <td>
            <f:select path="room.id" required="true" class="form-control" id="room_id">
              <c:if test="${patient.id == null}">
                <option></option>
                <c:forEach items="${rooms}" var="room">
                  <f:option value="${room.id}"><c:out value="${room.name} ${room.floor.name} ${room.roomType.name}"/></f:option>
                </c:forEach>
              </c:if>
              <c:if test="${patient.id > 0}">
                <option value="${patient.room.id}">${patient.room.name} ${patient.room.floor.name} ${patient.room.roomType.name}</option>
              </c:if>
              <%--<f:options items="${rooms}" itemValue="id" itemLabel="name floor.name: roomType.name "/>--%>
            </f:select>
            <%--<f:input path="palata" required="true" cssStyle="text-align:center" type="text" class="form-control" maxlength="64"/>--%>
          </td>
        </tr>
        <tr>
          <td class="right" nowrap>Тениаринхоз санаси:</td>
          <td><f:input path="tarDate" class="form-control datepicker" type="text"/></td>
          <td class="right" nowrap>Кол-во койка день<d></d>:</td>
          <td><f:input path="dayCount" required="true" class="form-control center" type="number"/></td>
        </tr>
        <tr>
          <td align="right">Дориларнинг ножуя тасири:</td>
          <td colspan="3"><f:textarea path="drugEffect" type="text" class="form-control"/></td>
        </tr>
        <tr>
          <td align="right">Йулланмадаги ташхис:</td>
          <td colspan="3"><f:textarea path="diagnoz" type="text" class="form-control" maxlength="400"/></td>
        </tr>
        <c:if test="${sessionScope.ENV.roleId == 3}">
          <tr>
            <td class="right" nowrap>Йуналтирган мутахасис коди:</td>
            <td colspan="3">
              <f:select path="lvpartner.id" class="form-control">
                <f:option value=""></f:option>
                <f:options items="${lvpartners}" itemValue="id" itemLabel="code"></f:options>
              </f:select>
          </tr>
        </c:if>
      </table>
    </div>
  </f:form>
  <c:if test="${patient.id > 0}">
    <div class="panel panel-info" style="margin-left:-1px; width: 800px !important;">
      <div class="panel-heading bold">
        Дополнительное спальное место
        <ul class="pagination" style="float:right; margin-top:-5px">
          <li class="paginate_button" tabindex="0" style="width: 100px !important;">
            <a href="#" onclick="saveWatcher()"><i title="Сохранить" class="fa fa-save"></i> Сохранить</a>
          </li>
        </ul>
      </div>
      <div>
        <table class="table table-bordered">
          <tr>
            <td style="font-weight:bold; text-align: center;">Дата</td>
            <td style="font-weight:bold; text-align: center;">Тип</td>
            <td style="font-weight:bold; text-align: center;">Кол-во дней</td>
            <td style="font-weight:bold; text-align: center;">Состояние</td>
            <td>&nbsp;</td>
          </tr>
          <c:forEach items="${watchers}" var="watcher">
            <tr>
              <td align="center"><fmt:formatDate pattern="dd.MM.yyyy" value="${watcher.crOn}"/></td>
              <td align="center">${watcher.type.name}</td>
              <td align="center">
                <c:if test="${sessionScope.ENV.userId == 1}">
                  <input type="number" id="set-watcher-day-count" value="${watcher.dayCount}" onchange="setWatcherDayCount(${watcher.id}, this)" class="form-control" style="text-align:center" placeholder="xx"/>
                </c:if>
                <c:if test="${sessionScope.ENV.userId != 1}">
                  ${watcher.dayCount}
                </c:if>
              </td>
              <td align="center">
                <c:choose>
                  <c:when test="${watcher.state == 'ENT'}">Введен</c:when>
                  <c:when test="${watcher.state == 'PAID'}">Оплачена</c:when>
                </c:choose>
              </td>
              <td align="center">
                <c:choose>
                  <c:when test="${watcher.state == 'ENT'}">
                    <a class="btn btn-sm btn-danger" onclick="removeRow('watcher', ${watcher.id})" style="height:20px;padding:1px 10px" title="Удалить">
                      <i class="fa fa-minus"></i>
                    </a>
                  </c:when>
                  <c:when test="${watcher.state == 'PAID'}">&nbsp;</c:when>
                </c:choose>
              </td>
            </tr>
          </c:forEach>
          <tr>
            <td align="center">
                ${curDate}
            </td>
            <td>
              <select name="type.id" class="form-control" id="watcher_type_id">
                <c:forEach items="${watcherTypes}" var="type">
                  <option value="${type.id}">${type.name}</option>
                </c:forEach>
              </select>
            </td>
            <td>
              <input type="number" id="watcher-day-count" onchange="setWatcherTotal(this)" class="form-control" style="text-align:center" placeholder="xx"/>
            </td>
            <td align="center">Новое</td>
            <td>&nbsp;</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="panel panel-info" style="margin-left:-1px; width: 800px !important;">
      <div class="panel-heading bold">
        Обязательные услуги
        <c:if test="${patient.state == 'PRN' || patient.state == 'PRD'}">
          <ul class="pagination" style="float:right; margin-top:-5px">
            <li class="paginate_button" tabindex="0" style="width: 100px !important;">
              <a href="#" onclick="saveNecKdo()"><i title="Сохранить" class="fa fa-save"></i> Сохранить</a>
            </li>
          </ul>
        </c:if>
      </div>
      <div>
        <form id="kdoForm">
          <table class="table table-bordered kdoTable">
            <tr>
              <th>#</th>
              <th>Наименование</th>
              <th>Цена</th>
            </tr>
            <c:forEach items="${kdos}" var="kdo">
              <input type="hidden" name="id" value="${kdo.id}"/>
              <tr>
                <td class="center" style="width:30px">
                  <input type="checkbox" class="hand" name="kdo${kdo.id}" <c:if test="${fn:indexOf(planIds, kdo.shortName) != -1}">checked</c:if> value="Y">
                </td>
                <td>
                  ${kdo.name}
                </td>
                <td class="right">
                  <fmt:formatNumber value="${kdo.price}" type = "number"/>
                </td>
              </tr>
            </c:forEach>
          </table>
        </form>
      </div>
    <div>
  </c:if>
</div>

<script>
  function setWatcherDayCount(id, dom) {
    $.ajax({
      url: "/reg/nurse/watcher/day.s",
      method: "post",
      data: 'id=' + id + '&day=' + dom.value,
      dataType: 'json',
      success: function (json) {
        if (json.success) {
          alert("<ui:message code="successSave"/>");
        } else {
          alert(json.msg);
        }
      },
      error: function (data, err) {
        alert(err);
      }
    });
  }
  function sumFormat(num) {
    var nm = Math.round(num * 100) / 100;
    return nm.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')
  }
  function setWatcherTotal(dom) {
    try {
      if(parseInt('${patient.dayCount}') < parseInt(dom.value)) {
        alert('Кол-во дней не может превышать кол-во койко дней пациента');
        dom.value = '';
      }
    } catch (e) {
      dom.value = '';
      alert('Проверьте правильности ввода данных');
    }
  }
  function saveWatcher() {
    if(!document.getElementById("watcher-day-count").value) {
      alert('Заполните форму');
      return;
    }
    if (parseInt(document.getElementById("watcher-day-count").value) > 0) {
      $.ajax({
        url: "/reg/nurse/watcher.s",
        method: "post",
        data: 'id=${patient.id}&days=' + document.getElementById("watcher-day-count").value + '&type=' + document.getElementById("watcher_type_id").value,
        dataType: 'json',
        success: function (json) {
          if (json.success) {
            alert("<ui:message code="successSave"/>");
            setPage('/reg/nurse/index.s?id=${patient.id}');
          } else {
            alert(json.msg);
          }
        },
        error: function (data, err) {
          alert(err);
        }
      });
    }
  }
  function removeRow(code, id) {
    $.ajax({
      url: "/reg/stat/removeRow.s",
      method: "post",
      data: 'id=' + id + '&code=' + code,
      dataType: 'json',
      success: function (json) {
        if (json.success) {
          alert("<ui:message code="successSave"/>");
          setPage('/reg/nurse/index.s?id=${patient.id}');
        } else {
          alert(json.msg)
        }
      },
      error: function (data, err) {
        alert(err);
      }
    });
  }
  function saveNecKdo() {
    $.ajax({
      url: '/reg/nurse/kdo/save.s',
      method: 'post',
      data: $('#kdoForm').serialize(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert("<ui:message code="successSave"/>");
        } else {
          alert(res.msg);
        }
      }
    });
  }
  $(".date-format").mask("99.99.9999",{placeholder:"dd.mm.yyyy"});
</script>
