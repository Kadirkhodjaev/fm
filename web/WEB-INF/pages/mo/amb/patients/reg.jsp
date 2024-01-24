<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<script src="/res/js/common.js"></script>
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<script src="/res/js/jquery.maskedinput.js" type="text/javascript"></script>
<div class="panel panel-info wpx-1200 margin-auto">
  <div class="panel-heading">
    <c:if test="${patient.id == null}">
      <span class="fa fa-pencil"></span> Регистрация нового пациента
    </c:if>
    <c:if test="${patient.id != null}">
      <span class="fa fa-user"></span> Реквизиты пациента
    </c:if>
    <ul class="pagination" style="float:right; margin-top:-5px">
      <c:if test="${isReg && (patient.state == 'ENT' || patient.id == null)}">
        <li class="paginate_button" tabindex="0"><a href="#" id="btn-save"><i title="Сохранить" class="fa fa-save"></i> Сохранить</a></li>
      </c:if>
      <c:if test="${patient.id != null && fn:length(patient_services) == 0 && isReg}">
        <li class="paginate_button" tabindex="0"><a href="#" id="btn-del"><i title="Удалить запись" class="fa fa-remove"></i> Удалить</a></li>
      </c:if>
      <c:if test="${patient.id != null && patient.state == 'PRN' && isReg && fn:length(patient_services) > 0}">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="patientConfirm(true)"><i title="Подтвердить" class="fa fa-check"></i> Подтвердить</a></li>
      </c:if>
      <c:if test="${patient.state == 'DONE' && fn:length(patient_services) > 0 && isReg}">
        <li class="paginate_button wpx-100" tabindex="0"><a href="#" onclick="patientConfirm(false)"><i title="Отправить в архив" class="fa fa-archive"></i> Архивация</a></li>
      </c:if>
      <li class="paginate_button" tabindex="0"><a href="#" onclick="setPage('/ambs/patients.s');return false;"><i class="fa fa-backward"></i> Назад</a></li>
    </ul>
  </div>
  <form id="form-data">
    <input type="hidden" name="id" value="${patient.id}"/>
    <table class="w-100 table-bordered p-5">
      <tbody>
        <tr>
          <td class="right">Клиент <req>*</req>:</td>
          <td colspan="3">
            <table class="w-100">
              <tr>
                <td>
                  <input type="hidden" name="client_id" value="${patient.client.id}">
                  <input type="text" class="form-control uppercase" name="client_name" placeholder="Ф.И.О." value="${patient.fio}" <c:if test="${patient.id != null}">readonly</c:if>/>
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
        <tr>
          <td class="right" nowrap>
            <c:if test="${patient.client.birthdate != null}">
              Дата рождения:
            </c:if>
            <c:if test="${patient.client.birthdate == null}">
              Год рождения:
            </c:if>
          </td>
          <td>
            <c:if test="${patient.client.birthdate != null}">
              <input type="text" class="form-control center wpx-100" readonly name="birthdate" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${patient.client.birthdate}" />"/>
            </c:if>
            <c:if test="${patient.client.birthdate == null}">
              <input type="text" class="form-control center wpx-100" readonly name="birthdate" value="${patient.client.birthyear}"/>
            </c:if>
          </td>
          <td class="right" nowrap>Пол:</td>
          <td>
            <input type="text" class="form-control center wpx-100" readonly name="sex" value="${patient.sex.name}">
          </td>
        </tr>
        <tr>
          <td class="right" nowrap>Паспортные данные:</td>
          <td colspan="3">
            <input type="text" class="form-control" name="passport" value="${patient.passportInfo}"/>
          </td>
        </tr>
        <tr>
          <td class="right" nowrap>Резидентство:</td>
          <td>
            <input type="text" class="form-control center" readonly name="country" value="${patient.client.country.name}"/>
          </td>
          <td class="right" nowrap>Область:</td>
          <td>
            <input type="text" class="form-control center" readonly name="region" value="${patient.client.region.name}"/>
          </td>
        </tr>
        <tr>
          <td class="right" nowrap>Адрес:</td>
          <td colspan="3">
            <input type="text" class="form-control" name="address"  value="${patient.address}"/>
          </td>
        </tr>
        <tr>
          <td class="right" nowrap>Телефон:</td>
          <td colspan="3">
            <input type="text" class="form-control" name="tel"  value="${patient.tel}"/>
          </td>
        </tr>
        <tr>
          <td class="right" nowrap>Код отправителя:</td>
          <td colspan="3">
            <select class="form-control" name="lvpartner">
              <option></option>
              <c:forEach items="${lvpartners}" var="p">
                <option <c:if test="${patient.lvpartner.id == p.id}">selected</c:if> value="${p.id}">${p.code}</option>
              </c:forEach>
            </select>
          </td>
        </tr>
      </tbody>
    </table>
  </form>
</div>
<c:if test="${patient.id > 0}">
  <div class="panel panel-info wpx-1200 margin-auto">
    <div class="panel-heading">
      <table class="w-100">
        <tr>
          <td>
            <span class="fa fa-list"></span> Услуги
          </td>
          <td class="right text-danger" style="font-size: 15px">
            <c:if test="${ent_sum > 0}">К оплате: <b><fmt:formatNumber value = "${ent_sum}" type = "number"/> сум</b></c:if> <c:if test="${paid_sum > 0 && ent_sum > 0}">/</c:if> <c:if test="${paid_sum > 0}">Оплачена: <b><fmt:formatNumber value = "${paid_sum}" type = "number"/> сум</b></c:if>
          </td>
        </tr>
      </table>
    </div>
    <div class="text-danger text-center border-bottom-1 p-4" style="font-size: 15px">
      <span class="fa fa-plus-square"></span> Новая услуга
    </div>
    <table class="w-100 table-bordered">
      <tr>
        <td class="p-4">
          <input type="text" class="form-control" id="service_name" placeholder="Наименование услуги"/>
          <div id="service_filter" style="display: none; position: absolute; background:white">
            <table class="w-100 table-bordered tablehover p-3"><tbody></tbody></table>
          </div>
        </td>
        <td class="center" style="width:40px" id="service_buttons">
          <button type="button" class="btn btn-info btn-icon" id="add-service" data-toggle="modal" data-target="#service_list">
            <b class="fa fa-list"></b>
          </button>
        </td>
      </tr>
    </table>
    <c:if test="${fn:length(patient_services) > 0}">
      <div class="text-danger text-center border-bottom-1 p-4" style="font-size: 15px">
        <span class="fa fa-list"></span> Добавленные услуги
      </div>
      <table class="w-100 table-bordered p-5">
        <tr class="text-info">
          <td class="center bold">№</td>
          <td class="center bold" title="Выбор для распечатке">
            <c:if test="${fn:length(patient_services) > 1}">
              <input type="checkbox" class="hand">
            </c:if>
          </td>
          <td class="center bold" title="Состояние"><b class="fa fa-certificate"></b></td>
          <td class="center bold">Наименование</td>
          <td class="center bold">Сумма</td>
          <td class="center bold" title="Дата и время подтверждение со стороны врача">Подтверждение</td>
          <td class="center bold">Врач</td>
          <td title="Удалить услугу" class="center bold text-danger"><span class="fa fa-trash"></span></td>
          <td title="Повторная консультация" class="bold center"><span class="fa fa-repeat"></span></td>
        </tr>
        <c:forEach items="${patient_services}" var="s" varStatus="loop">
          <tr>
            <td class="center">${loop.index + 1}</td>
            <td class="center wpx-40">
              <c:if test="${fn:length(patient_services) > 1}">
                <c:if test="${s.state == 'DONE'}">
                  <input type="checkbox" class="hand">
                </c:if>
              </c:if>
              <c:if test="${fn:length(patient_services) == 1 && s.state == 'DONE'}">
                <button class="btn btn-info btn-icon"><i class="fa fa-print"></i></button>
              </c:if>
            </td>
            <td class="center">
              <c:if test="${s.state == 'DEL'}"><span style="color:red;font-weight:bold">Возврат</span></c:if>
              <c:if test="${s.state == 'AUTO_DEL'}"><span style="color:red;font-weight:bold">Удален</span></c:if>
              <c:if test="${s.state == 'ENT'}"><img title="Введен" src='/res/imgs/red.gif'/></c:if>
              <c:if test="${s.state == 'PAID'}"><img title="Оплачена" src='/res/imgs/yellow.gif'/></c:if>
              <c:if test="${s.state == 'DONE'}"><img title="Выполнена" src='/res/imgs/green.gif'/></c:if>
            </td>
            <td>${s.service.name}</td>
            <td class="right">${s.price}</td>
            <td class="center">
              <fmt:formatDate pattern = "dd.MM.yyyy HH:mm" value = "${s.confDate}" />
            </td>
            <td class="center">
              <c:if test="${s.closed || fn:length(s.users) == 1 || s.result == null}">
                ${s.worker.fio}
              </c:if>
              <c:if test="${!s.closed && fn:length(s.users) > 1 && s.result != null}">
                <select class="form-control" onchange="setLv(${s.id}, this.value)">
                  <c:forEach items="${s.users}" var="u">
                    <option <c:if test="${s.worker.id == u.id}">selected</c:if> value="${u.id}">${u.fio}</option>
                  </c:forEach>
                </select>
              </c:if>
            </td>
            <td style="width:40px" class="center">
              <c:if test="${s.state == 'ENT'}">
                <button type="button" class="btn btn-danger btn-icon" onclick="delService(${s.id})">
                  <b class="fa fa-remove"></b>
                </button>
              </c:if>
            </td>
            <td style="width:40px" class="center">
              <c:if test="${s.repeat}">
                <button type="button" class="btn btn-info btn-icon" onclick="setRepeat(${s.id})">
                  <b class="fa fa-repeat"></b>
                </button>
              </c:if>
            </td>
          </tr>
        </c:forEach>
      </table>
    </c:if>
  </div>

  <div class="modal fade" id="service_list" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog w-100">
      <div class="modal-content" id="service-model-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="clearAddingService()">×</button>
          <h4 class="modal-title text-danger"><b class="fa fa-list"></b> Услуги</h4>
        </div>
        <div class="modal-body">
          <table class="w-100">
            <tr>
              <td class="service-groups-menu">
                <div class="shadow-block amb-group-list">
                  <c:forEach items="${services}" var="s" varStatus="loop">
                    <div class="service-groups text-info <c:if test="${loop.index == 0}">active</c:if>" onclick="selectGroup(this, ${s.group.id})">
                      <table class="w-100">
                        <tr>
                          <td style="padding:3px">${s.group.name}</td>
                          <td style="width:30px" class="center">
                            <div class="display-none band-counter-2" id="group-counter-${s.group.id}"></div>
                          </td>
                        </tr>
                      </table>
                    </div>
                  </c:forEach>
                </div>
                <div class="shadow-block" style="height:95px; margin-top:5px">
                  <div class="text-danger center">
                    <h3 id="add-service-total">0 сум</h3>
                  </div>
                  <div class="center">
                    <button class="btn btn-success btn-icon" onclick="saveAllServices()">
                      <b class="fa fa-save"></b>
                      Сохранить
                    </button>
                    <button class="btn btn-danger btn-icon" data-dismiss="modal" id="close_btn" onclick="clearAddingService()">
                      <b class="fa fa-close"></b>
                      Закрыть
                    </button>
                  </div>
                </div>
              </td>
              <td style="vertical-align:top;padding:5px;">
                <div class="shadow-block amb-service-list">
                  <c:forEach items="${services}" var="g" varStatus="loop">
                    <table id="service-${g.group.id}" class="w-100 table-bordered p-5 amb-services <c:if test="${loop.index > 0}">display-none</c:if>" style="position: relative;">
                      <tr class="table-header table-header-stikcy text-info">
                        <td title="Добавить услугу"><b class="fa fa-plus"></b></td>
                        <td title="Удалить услугу услугу"><b class="fa fa-minus"></b></td>
                        <td>№</td>
                        <td>Наименование</td>
                        <td>Стоимость</td>
                      </tr>
                      <c:forEach items="${g.services}" var="s" varStatus="loop">
                        <tr class="hover hand noselect">
                          <td class="center" style="width:40px">
                            <button type="button" onclick="setAddingService(${g.group.id}, ${s.id}, ${patient.resident ? s.price : s.for_price}, true)" class="btn btn-success btn-icon"><b class="fa fa-plus"></b></button>
                          </td>
                          <td class="center" style="width:40px">
                            <button type="button" onclick="setAddingService(${g.group.id}, ${s.id}, ${patient.resident ? s.price : s.for_price},false)" class="btn btn-danger btn-icon display-none minus-service" id="minus-service-${s.id}"><b class="fa fa-minus"></b></button>
                          </td>
                          <td class="center" style="width:50px">${loop.index + 1}</td>
                          <td>
                            <table class="w-100">
                              <tr>
                                <td>${s.name}</td>
                                <td style="width:30px;padding:0!important;" class="center">
                                  <div class="display-none band-counter-2" id="service-counter-${s.id}"></div>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td class="right" style="width:200px"><fmt:formatNumber value = "${patient.resident ? s.price : s.for_price}" type = "number"/></td>
                        </tr>
                      </c:forEach>
                    </table>
                  </c:forEach>
                </div>
              </td>
            </tr>
          </table>
        </div>
      </div>
      <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
  </div>
</c:if>

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
                  <c:forEach items="${counteries}" var="reg">
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
        <button class="btn btn-danger btn-sm" data-dismiss="modal" aria-hidden="true">
          <i class="fa fa-remove"></i> Закрыть
        </button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>

<script>
  let clients = [], services = [], selected_services = [];
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
  $('#client_buttons .btn-danger').click(()=> {
    $('#client_buttons .btn-success').show();
    $('#client_buttons .btn-info').hide();
    $('#client_buttons .btn-danger').hide();
    $('#client_buttons').width(40);
    clients = [];
    setClient(0);
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
    $('input[name=birthdate]').val(client.birthdate);
    $('input[name=sex]').val(client.sex);
    $('input[name=passport]').val(client.passport);
    $('input[name=country]').val(client.country);
    $('input[name=region]').val(client.region);
    $('input[name=address]').val(client.address);
    $('input[name=tel]').val(client.tel);
  }
  $('#btn-save').click(()=> {
    $.ajax({
      url: '/ambs/reg.s',
      method: 'post',
      data: $('#form-data').serialize(),
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if(res.success) {
          setPage('/ambs/reg.s?id=' + res.id);
        }
      }
    });
  });
  $('#btn-del').click(() => {
    if(confirm('Вы действительно хотите удалить запись?'))
      $.ajax({
        url: '/ambs/del.s',
        method: 'post',
        data: '',
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success)
            setPage('/ambs/reg.s');
        }
      });
  });
  $('#service_name').keyup( () => {
    let div = $('#service_filter'), elem = $('#service_name'), v = elem.val().toUpperCase();
    div.width(elem.width() + 12);
    if(v.length === 0) div.hide();
    if(v.length > 3) {
      if(services.length === 0) {
        $.ajax({
          url: '/ambs/service-search.s',
          method: 'post',
          data: 'word=' + v,
          dataType: 'json',
          success: function (res) {
            if (res.success) {
              services = res.services;
              if(services.length > 0) {
                buildServices(services);
                div.show();
              } else openMedMsg('Данные не найдены', false);
            } else openMsg(res);
          }
        });
      } else {
        let cls = services.filter(obj => obj.name.toUpperCase().indexOf(v) !== -1);
        buildServices(cls);
      }
    } else {
      services = [];
    }
  });
  function buildServices(cls) {
    let table = $('#service_filter>table>tbody');
    table.html('');
    for(let ser of cls) {
      let tr = $('<tr cid="' + ser.id + '"></tr>');
      tr.click(()=> {
        $('#service_filter').hide();
        addService(tr.attr('cid'));
      });
      let name = $('<td>' + ser.name + '</td>');
      let price = $('<td class="center">' + ser.price + '</td>');
      tr.append(name).append(price);
      table.append(tr);
    }
  }
  function addService(id) {
    $.ajax({
      url: '/ambs/patient/add-service.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if(res.success) {
          setPage('/ambs/reg.s?id=${patient.id}');
        }
      }
    });
  }
  function delService(id) {
    if(confirm('Вы действительно хотите удалить запись?'))
      $.ajax({
        url: '/ambs/patient/del-service.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success) setPage('/ambs/reg.s?id=${patient.id}');
        }
      });
  }
  function setRepeat(id) {
    if(confirm('Вы действительно хотите включить повторную консультацию?'))
      $.ajax({
        url: '/ambs/patient/repeat-service.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success) setPage('/ambs/reg.s?id=${patient.id}');
        }
      });
  }
  function selectGroup(dom, id){
    $('.service-groups').removeClass('active');
    $(dom).addClass('active');
    $('.amb-services').addClass('display-none');
    $('#service-' + id).removeClass('display-none');
  }
  function setAddingService(group, service, price, add) {
    if(add) {
      selected_services.push({group: group, service: service, price: price});
      $('#minus-service-' + service).removeClass('display-none');
    } else {
      for(let i=0;i<selected_services.length;i++){
        if(selected_services[i].service === service) {
          selected_services.splice(i, 1);
          break;
        }
      }
    }
    updateCounter();
  }
  function updateCounter() {
    $('.band-counter-2').addClass('display-none');
    $('.minus-service').addClass('display-none');
    for(let g of selected_services) {
      $('#group-counter-' + g.group).removeClass('display-none').html(selected_services.filter(obj => obj.group === g.group).length);
    }
    let sum = 0;
    for(let g of selected_services) {
      $('#service-counter-' + g.service).removeClass('display-none').html(selected_services.filter(obj => obj.service === g.service).length);
      $('#minus-service-' + g.service).removeClass('display-none');
      sum += g.price;
    }
    const formattedNumber = sum.toLocaleString('en-US', {style: 'currency', currency: 'UZS'});
    $('#add-service-total').html(formattedNumber.replace('UZS', '') + ' сум');
  }
  function clearAddingService() {
    selected_services = [];
    updateCounter();
  }
  function saveAllServices() {
    if(selected_services.length == 0) {
      openMedMsg('Услуги не выбраны', false);
      return;
    }
    let ids = '';
    for(let s of selected_services) ids += 'id=' + s.service + '&';
    $.ajax({
      url: '/ambs/patient/add-services.s',
      method: 'post',
      data: ids,
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if(res.success) {
          getDOM('close_btn').click();
          clearAddingService();
          setTimeout(() => {
            setPage('/ambs/reg.s?id=${patient.id}');
          }, 1000);
        }
      }
    });
  }
  function patientConfirm(isConfirm) {
    if (confirm(isConfirm ? 'Вы действительно хотите отправить пациента к оплате?' : 'Вы действительно хотите архивировать данные?')) {
      $.ajax({
        url: '/ambs/confirm.s',
        method: 'post',
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if (res.success) setPage('/ambs/reg.s');
        }
      });
    }
  }
  function setLv(service, lv) {
    $.ajax({
      url: '/ambs/set-service-lv.s',
      method: 'post',
      data: 'service=' + service + '&lv=' + lv,
      dataType: 'json',
      success: function (res) {
        openMsg(res);
      }
    });
  }
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
          $('input[name=birthdate]').val(res.birthdate);
          $('input[name=sex]').val(res.sex_name);
          $('input[name=passport]').val(res.doc_info);
          $('input[name=country]').val(res.country_name);
          $('input[name=region]').val(res.region_name);
          $('input[name=address]').val(res.address);
          $('input[name=tel]').val(res.tel);
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
  $(function(){
    $('#service-model-content').height($(document).height() - 100);
    $('.amb-service-list').height($(document).height() - 200);
    $('.amb-group-list').height($(document).height() - 300);
    $(".date-format").mask("99.99.9999",{placeholder:"dd.mm.yyyy"});
  });
</script>

