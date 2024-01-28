<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
  <c:if test="${patient.state != 'ARCH'}">
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
            <b class="fa fa-plus"></b>
          </button>
        </td>
      </tr>
    </table>
  </c:if>
  <c:if test="${fn:length(patient_services) > 0}">
    <c:if test="${patient.state != 'ARCH'}">
      <div class="text-danger text-center border-bottom-1 p-4" style="font-size: 15px">
        <span class="fa fa-list"></span> Добавленные услуги
      </div>
    </c:if>
    <table class="w-100 table-bordered p-5">
      <tr class="text-info">
        <td class="center bold">№</td>
        <td class="center bold" title="Выбор для распечатке">
          <c:if test="${fn:length(patient_services) > 1}">
            <button class="btn btn-info btn-icon" id="print_checked"><b class="fa fa-print"></b></button>
          </c:if>
        </td>
        <td class="center bold" title="Состояние"><b class="fa fa-certificate"></b></td>
        <td class="center bold">Наименование</td>
        <td class="center bold">Сумма</td>
        <td class="center bold" title="Дата и время подтверждение со стороны врача">Подтверждение</td>
        <td class="center bold">Врач</td>
        <c:if test="${patient.state != 'ARCH'}">
          <td title="Удалить услугу" class="center bold text-danger"><span class="fa fa-trash"></span></td>
        </c:if>
        <td title="Повторная консультация" class="bold center"><span class="fa fa-repeat"></span></td>
      </tr>
      <c:forEach items="${patient_services}" var="s" varStatus="loop">
        <tr>
          <td class="center wpx-40">${loop.index + 1}</td>
          <td class="center wpx-40">
            <c:if test="${fn:length(patient_services) > 1}">
              <c:if test="${s.state == 'DONE'}">
                <input type="checkbox" class="hand" checked>
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
            <c:if test="${s.closed || fn:length(s.users) == 1 || s.result != null}">
              ${s.worker.fio}
            </c:if>
            <c:if test="${!s.closed && fn:length(s.users) > 1 && s.result == null}">
              <select class="form-control" onchange="setLv(${s.id}, this.value)">
                <c:forEach items="${s.users}" var="u">
                  <option <c:if test="${s.worker.id == u.id}">selected</c:if> value="${u.id}">${u.fio}</option>
                </c:forEach>
              </select>
            </c:if>
          </td>
          <c:if test="${patient.state != 'ARCH'}">
            <td style="width:40px" class="center">
              <c:if test="${s.canDelete}">
                <button type="button" class="btn btn-danger btn-icon" onclick="delService(${s.id})">
                  <b class="fa fa-remove"></b>
                </button>
              </c:if>
            </td>
          </c:if>
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
                      <th title="Добавить услугу"><b class="fa fa-plus"></b></th>
                      <th title="Удалить услугу услугу"><b class="fa fa-minus"></b></th>
                      <th>№</th>
                      <th>Наименование</th>
                      <th>Стоимость</th>
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

<script>
  let services = [], selected_services = []
  $('#service_name').keyup( () => {
    let div = $('#service_filter'), elem = $('#service_name'), v = elem.val().toUpperCase();
    div.width(elem.width() + 12);
    if(v.length === 0) div.hide();
    if(v.length > 3) {
      if(services.length === 0) {
        $.ajax({
          url: '/ambs/patient/service-search.s',
          method: 'post',
          data: 'patient=${patient.id}&word=' + encodeURIComponent(v),
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
      data: 'patient=${patient.id}&id=' + id,
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if(res.success) {
          $('#patient_services').load('/ambs/patient/services.s?id=${patient.id}');
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
          if(res.success) $('#patient_services').load('/ambs/patient/services.s?id=${patient.id}');
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
          if(res.success) $('#patient_services').load('/ambs/patient/services.s?id=${patient.id}');
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
      data: ids + 'patient=${patient.id}',
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if(res.success) {
          getDOM('close_btn').click();
          clearAddingService();
          setTimeout(() => {
            $('#patient_services').load('/ambs/patient/services.s?id=${patient.id}');
          }, 1000);
        }
      }
    });
  }
  function setLv(service, lv) {
    $.ajax({
      url: '/ambs/patient/set-service-lv.s',
      method: 'post',
      data: 'patient=${patient.id}&service=' + service + '&lv=' + lv,
      dataType: 'json',
      success: function (res) {
        openMsg(res);
      }
    });
  }
  $('#print_checked').click(() => {

  })
  $(()=> {
    $('#service-model-content').height($(document).height() - 100);
    $('.amb-service-list').height($(document).height() - 200);
    $('.amb-group-list').height($(document).height() - 300);
  })
</script>
