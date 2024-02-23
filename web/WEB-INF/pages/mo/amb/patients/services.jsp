<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="/res/js/common.js"></script>
<div style="margin-top:10px"></div>
<div class="shadow-block w-80 margin-auto" style="border:1px solid #ababab">
  <div style="padding:5px;">
    <table class="w-100">
      <tr>
        <td>
          <span class="fa fa-list"></span> Услуги - ${patient.fio} (<c:if test="${ent_sum > 0}">К оплате: <b><fmt:formatNumber value = "${ent_sum}" type = "number"/> сум</b></c:if><c:if test="${paid_sum > 0 && ent_sum > 0}"> / </c:if><c:if test="${paid_sum > 0}">Оплачена: <b><fmt:formatNumber value = "${paid_sum}" type = "number"/> сум</b></c:if>)
        </td>
        <td class="right text-danger" style="font-size: 15px">
          <c:if test="${patient.current}">
            <button type="button" class="btn btn-info btn-icon" id="add-service" data-toggle="modal" data-target="#service_list">
              <b class="fa fa-list"></b>
            </button>
          </c:if>
        </td>
      </tr>
    </table>
  </div>

  <c:if test="${fn:length(patient_services) > 0}">
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
        <td class="center bold">Дата окз. услуги</td>
        <td class="center bold">Сумма</td>
        <td class="center bold" title="Дата и время подтверждение со стороны врача">Подтверждение</td>
        <td class="center bold">Врач</td>
        <c:if test="${patient.current}">
          <td title="Удалить услугу" class="center bold text-danger"><span class="fa fa-trash"></span></td>
        </c:if>
        <c:if test="${patient.current && patient.treatment == 'Y'}">
          <td title="Подтвердить услугу" class="center bold text-success"><span class="fa fa-check"></span></td>
        </c:if>
      </tr>
      <c:forEach items="${patient_services}" var="s" varStatus="loop">
        <tr>
          <td class="center wpx-40">${loop.index + 1}</td>
          <td class="center wpx-40">
            <c:if test="${fn:length(patient_services) > 1}">
              <c:if test="${s.state == 'DONE' && !s.treatment}">
                <input type="checkbox" class="hand amb-print-checkbox" checked value="${s.id}">
              </c:if>
            </c:if>
            <c:if test="${fn:length(patient_services) == 1 && s.state == 'DONE' && !s.treatment}">
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
          <td>
            <c:if test="${s.state == 'DONE' || (s.state == 'PAID' && sessionScope.ENV.userId == s.worker.id)}">
              <a href="#" onclick="setPage('/ambs/doctor/service.s?patient=${patient.id}&id=${s.id}')">${s.service.name}</a>
            </c:if>
            <c:if test="${!(s.state == 'DONE' || (s.state == 'PAID' && sessionScope.ENV.userId == s.worker.id))}">
              ${s.service.name}
            </c:if>
          </td>
          <td class="center <c:if test="${s.today}">text-danger bold</c:if>">
            <fmt:formatDate pattern = "dd.MM.yyyy" value = "${s.planDate}" />
          </td>
          <td class="right">${s.price}</td>
          <td class="center">
            <fmt:formatDate pattern = "dd.MM.yyyy HH:mm" value = "${s.confDate}" />
          </td>
          <td class="center">
            <c:if test="${s.closed || fn:length(s.users) == 1 || s.result != null && patient.state == 'ARCH'}">
              ${s.worker.fio}
            </c:if>
            <c:if test="${!s.closed && fn:length(s.users) > 1 && s.result == null && patient.current}">
              <select class="form-control" onchange="setLv(${s.id}, this.value)">
                <c:forEach items="${s.users}" var="u">
                  <option <c:if test="${s.worker.id == u.id}">selected</c:if> value="${u.id}">${u.fio}</option>
                </c:forEach>
              </select>
            </c:if>
          </td>
          <c:if test="${patient.current}">
            <td style="width:40px" class="center">
              <c:if test="${s.state == 'ENT'}">
                <button type="button" class="btn btn-danger btn-icon" onclick="delService(${s.id})">
                  <b class="fa fa-remove"></b>
                </button>
              </c:if>
            </td>
          </c:if>
          <c:if test="${patient.current && patient.treatment == 'Y'}">
            <td style="width:40px" class="center">
              <c:if test="${s.state == 'PAID' && s.treatment}">
                <button type="button" class="btn btn-success btn-icon" onclick="confirmPatientService(${s.id})">
                  <b class="fa fa-check"></b>
                </button>
              </c:if>
            </td>
          </c:if>
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
  let selected_services = []
  function delService(id) {
    if(confirm('Вы действительно хотите удалить запись?'))
      $.ajax({
        url: '/ambs/patient/del-service.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success) setPage('${sessionScope.ENV.curUrl}');
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
    if(selected_services.length === 0) {
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
            setPage('${sessionScope.ENV.curUrl}');
            //$('#service_block').html('').load('/ambs/patient/services.s?grid=1&id=${patient.id}');
          }, 1000);
        }
      }
    });
  }
  function setLv(service, lv) {
    $.ajax({
      url: '/ambs/patient/set-service-lv.s',
      method: 'post',
      data: 'service=' + service + '&lv=' + lv,
      dataType: 'json',
      success: function (res) {
        openMsg(res);
      }
    });
  }
  function confirmPatientService(id) {
    if(confirm('Вы действительно хотите подтвердить выполнения данной услуги?'))
      $.ajax({
        url: '/ambs/doctor/treatment/confirm.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success) $('#service_block').html('').load('/ambs/patient/services.s?grid=1&id=${patient.id}');
        }
      });
  }
  $('#print_checked').click(() => {
    let p = 'patient=${patient.id}&';
    let s = '';
    $('.amb-print-checkbox').each((idx, dom) => {
      if($(dom).is(':checked')) {
        s += 'service=' + dom.value + '&';
      }
    })
    if(s === '') {
      openMedMsg('Нет выбранных форм для распечатки!', false);
      return;
    }
    moPrintPage(2, p + s);
  })
  $(()=> {
    $('#service-model-content').height($(document).height() - 100);
    $('.amb-service-list').height($(document).height() - 200);
    $('.amb-group-list').height($(document).height() - 300);
  })
</script>
