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
    openMainPage('/reg/nurse/del.s');
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
          $('#birthdayString').val(res.birthdate);
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
  function setOtd(id) {
    $('#room_id').empty().append($('<option></option>'));
    rooms.forEach((dom) => {
      if(id === dom.dept)
        $('#room_id').append($('<option ' + ('${patient.room.id}' == dom.id ? 'selected ' : '') + 'value="' + dom.id + '">' + dom.name + '</option>'));
    });
  }
</script>
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
        <c:if test="${patient.id == null}">
          <tr>
            <td class="right" nowrap>Клиент<d></d>:</td>
            <td colspan="3">
              <table width="100%">
                <tr>
                  <td style="width:90%">
                    <select id="client-selector" name="client" class="form-control chzn-select" onchange="setClient(this.value)">
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
            <f:input path="surname" title="Фамилия" placeholder="Фамилия" cssStyle="width:167px; display:inline;margin-right:10px;text-transform: uppercase;" type="text" class="form-control" required="true" maxlength="64" autofocus="1" autocomplete="off"/>
            <f:input path="name" title="Исми" placeholder="Исми" cssStyle="width:167px; display:inline;margin-right:10px;text-transform: uppercase;" type="text" class="form-control" required="true"  maxlength="64" autocomplete="off"/>
            <f:input path="middlename" title="Шарифи" placeholder="Шарифи" cssStyle="width:167px; float: right;text-transform: uppercase;" type="text" class="form-control" maxlength="64" autocomplete="off"/>
          </td>
        </tr>
        <tr>
          <td class="right" nowrap>Тугилган сана:</td>
          <td><f:input path="birthdayString" class="form-control center" type="text" maxlength="10" placeholder="dd.mm.yyyy"/></td>
          <td class="right" nowrap>Жинси:</td>
          <td><f:select path="sex.id" id="sex_id" cssClass="form-control" items="${sex}" itemValue="id" itemLabel="name"/></td>
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
          <td><f:select path="counteryId" items="${counteries}" onchange="setCountery(this)" itemValue="id" itemLabel="name" class="form-control" /></td>
          <td class="right" nowrap>Вилоят:</td>
          <td>
            <f:select path="regionId" class="form-control">
              <f:option value=""></f:option>
              <f:options items="${regions}" itemValue="id" itemLabel="name"></f:options>
            </f:select>
          </td>
        </tr>
        <tr>
          <td class="right" nowrap>Манзили:</td>
          <td><f:input path="address" type="text" class="form-control" maxlength="400"/></td>
          <td class="right" nowrap>Паспорт маълумотлари:</td>
          <td><f:input path="passportInfo" type="text" class="form-control" maxlength="64"/></td>
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
                      <input name="surname" title="Фамилия" placeholder="Фамилия" style="width:167px; display:inline;margin-right:10px;text-transform: uppercase;" type="text" class="form-control" required="true" maxlength="64" autocomplete="off"/>
                      <input name="name" title="Исми" placeholder="Исми" style="width:167px; display:inline;margin-right:10px;text-transform: uppercase;" type="text" class="form-control" required="true"  maxlength="64" autocomplete="off"/>
                      <input name="middlename" title="Шарифи" placeholder="Шарифи" style="width:167px; float: right;text-transform: uppercase;" type="text" class="form-control" maxlength="64" autocomplete="off"/>
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
                    <td><input name="doc_seria" type="text" class="form-control text-center" style="text-transform: uppercase;" maxlength="2" placeholder="XX"/></td>
                    <td class="right" nowrap>Номер паспорта:</td>
                    <td><input name="doc_num" type="text" class="form-control text-center" style="text-transform: uppercase;" maxlength="10" placeholder="XXXXXXX"/></td>
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
</script>
