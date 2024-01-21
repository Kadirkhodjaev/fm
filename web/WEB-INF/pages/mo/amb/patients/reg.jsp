<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

<script>
  let clients = [], services = [], selected_services = [];
  $('input[name=client_name]').keyup( () => {
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
    $('#client_buttons .btn-danger').hide();
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
        $('#client_buttons .btn-danger').show();
        setClient(tr.attr('cid'));
      });
      let fio = $('<td>' + client.name + '</td>');
      let bd = $('<td class="center">' + client.birthdate + '</td>');
      tr.append(fio).append(bd);
      table.append(tr);
    }
  }
  function setClient(id){
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
            setPage('/ambs/patients.s');
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
  $(function(){
    $('#service-model-content').height($(document).height() - 100);
    $('.amb-service-list').height($(document).height() - 200);
    $('.amb-group-list').height($(document).height() - 300);
  })
</script>
<div class="panel panel-info wpx-1200 margin-auto">
  <div class="panel-heading">
    <c:if test="${patient.id == null}">
      <span class="fa fa-pencil"></span> Регистрация нового пациента
    </c:if>
    <c:if test="${patient.id != null}">
      <span class="fa fa-user"></span> Реквизиты пациента
    </c:if>
    <ul class="pagination" style="float:right; margin-top:-5px">
      <li class="paginate_button" tabindex="0"><a href="#" id="btn-save"><i title="Сохранить" class="fa fa-save"></i> Сохранить</a></li>
      <li class="paginate_button" tabindex="0"><a href="#" id="btn-del"><i title="Удалить запись" class="fa fa-remove"></i> Удалить</a></li>
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
                <td class="center" style="width:40px" id="client_buttons">
                  <c:if test="${patient.id == null}">
                    <button type="button" class="btn btn-success btn-icon">
                      <b class="fa fa-plus"></b>
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
      <span class="fa fa-list"></span> Услуги
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
          <td class="center bold">
            <input type="checkbox">
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
            <td class="center">
              <input type="checkbox">
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
            <td>
              <select class="form-control">
                <c:forEach items="${s.users}" var="u">
                  <option value="${u.id}">${u.fio}</option>
                </c:forEach>
              </select>
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
