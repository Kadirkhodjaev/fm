<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="panel panel-info wpx-1400 margin-auto">
  <div class="panel-heading">
    <span class="fa fa-list"></span> Амбулаторное лечение
    <ul class="pagination" style="float:right; margin-top:-5px">
      <c:if test="${patient.current}">
        <li class="paginate_button" tabindex="0"><a href="#" id="btn-treatment-save"><i title="Сохранить" class="fa fa-save"></i> Сохранить</a></li>
      </c:if>
    </ul>
  </div>
  <c:if test="${patient.current}">
    <div class="text-danger text-center border-bottom-1 p-4" style="font-size: 15px">
      <span class="fa fa-plus-square"></span> Новая услуга
    </div>
    <table class="w-100 table-bordered">
      <tr>
        <td class="p-4">
          <input type="text" class="form-control" id="treatment_name" placeholder="Наименование услуги"/>
          <div id="treatment_filter" style="display: none; position: absolute; background:white">
            <table class="w-100 table-bordered tablehover p-3"><tbody></tbody></table>
          </div>
        </td>
        <td class="center" style="width:40px" id="treatment_buttons">
          <button type="button" class="btn btn-info btn-icon" id="add-treatment" data-toggle="modal" data-target="#treatment_list">
            <b class="fa fa-plus"></b>
          </button>
        </td>
      </tr>
    </table>
  </c:if>
  <c:if test="${fn:length(patient_treatments) > 0}">
    <c:if test="${patient.current}">
      <div class="text-danger text-center border-bottom-1 p-4" style="font-size: 15px">
        <span class="fa fa-list"></span> Добавленные услуги
      </div>
    </c:if>
    <form id="treatment-form">
      <table class="w-100 table-bordered p-5">
      <tr class="text-info">
        <td class="center bold">№</td>
        <td class="center bold" title="Состояние"><b class="fa fa-certificate"></b></td>
        <td class="center bold" style="height:48px">Наименование</td>
        <c:forEach items="${dates}" var="d">
          <td style="position:relative;width:30px" class="bold">
            <div style="position: absolute; top:15px; left:-4px; -webkit-transform: rotate(270deg);">
              <fmt:formatDate pattern="dd.MM" value="${d.date}"/>
            </div>
          </td>
        </c:forEach>
        <td class="center bold">Врач</td>
        <c:if test="${patient.current}">
          <td title="Удалить услугу" class="center bold text-danger wpx-40"><span class="fa fa-trash"></span></td>
        </c:if>
      </tr>
      <c:forEach items="${patient_treatments}" var="s" varStatus="loop">
        <tr>
          <td class="center wpx-40">${loop.index + 1}</td>
          <td class="center wpx-40">
            <c:if test="${s.saved != 'Y'}"><img title="Не сохранен" src='/res/imgs/red.gif' alt=""/></c:if>
            <c:if test="${s.saved == 'Y'}"><img title="Услуги сохданы" src='/res/imgs/green.gif' alt=""/></c:if>
          </td>
          <td>
            <input type="hidden" name="id" value="${s.id}">
            ${s.name}
          </td>
          <c:forEach items="${s.dates}" var="d">
          <td <c:if test="${d.paid == 'Y'}">title="Услуга оплачена <c:if test="${d.psState == 'DONE'}">и Выполнена</c:if>"</c:if> onclick="setCheck(event, ${s.id}, '<fmt:formatDate pattern="dd.MM.yyyy" value="${d.date}"/>')" class="hand hover" style="vertical-align: middle; text-align: center">
            <input type="hidden" name="date_${s.id}" value="<fmt:formatDate pattern="dd.MM.yyyy" value="${d.date}"/>"/>
            <c:if test="${d.psState != 'DONE'}">
              <input class="hand" type="checkbox" <c:if test="${d.state == 'Y'}">checked</c:if> <c:if test="${d.paid == 'Y'}">disabled</c:if> name="treatment_${s.id}_<fmt:formatDate pattern="dd.MM.yyyy" value="${d.date}"/>" id="treatment_${s.id}_<fmt:formatDate pattern="dd.MM.yyyy" value="${d.date}"/>" value="Y"/>
            </c:if>
            <c:if test="${d.paid == 'Y'}">
              <input type="hidden" name="treatment_${s.id}_<fmt:formatDate pattern="dd.MM.yyyy" value="${d.date}"/>" value="Y">
            </c:if>
            <c:if test="${d.psState == 'DONE'}">
              <i class="fa fa-check text-success bold"></i>
            </c:if>
          </td>
          </c:forEach>
          <td class="center wpx-200">
            <c:if test="${s.saved == 'Y' || fn:length(s.users) == 1}">
              ${s.workerFio}
            </c:if>
            <c:if test="${s.saved != 'Y' && fn:length(s.users) > 1}">
              <select class="form-control" onchange="setTreatmentLv(${s.id}, this.value)">
                <c:forEach items="${s.users}" var="u">
                  <option <c:if test="${s.worker == u.id}">selected</c:if> value="${u.id}">${u.fio}</option>
                </c:forEach>
              </select>
            </c:if>
          </td>
          <c:if test="${patient.current}">
            <td class="center wpx-40">
              <c:if test="${s.saved != 'Y'}">
                <button type="button" class="btn btn-danger btn-icon" onclick="delTreatment(${s.id})">
                  <b class="fa fa-remove"></b>
                </button>
              </c:if>
            </td>
          </c:if>
      </c:forEach>
    </table>
    </form>
  </c:if>
</div>

<div class="modal fade" id="treatment_list" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog w-100">
    <div class="modal-content" id="treatment-model-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="clearAddingTreatment()">×</button>
        <h4 class="modal-title text-danger"><b class="fa fa-list"></b> Услуги</h4>
      </div>
      <div class="modal-body">
        <table class="w-100">
          <tr>
            <td class="service-groups-menu">
              <div class="shadow-block amb-group-list">
                <c:forEach items="${treatments}" var="s" varStatus="loop">
                  <div class="service-groups text-info <c:if test="${loop.index == 0}">active</c:if>" onclick="selectTreatmentGroup(this, ${s.group.id})">
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
                  <h3 id="add-treatment-total">0 сум</h3>
                </div>
                <div class="center">
                  <button class="btn btn-success btn-icon" onclick="saveAllTreatments()">
                    <b class="fa fa-save"></b>
                    Сохранить
                  </button>
                  <button class="btn btn-danger btn-icon" data-dismiss="modal" id="close_btn" onclick="clearAddingTreatment()">
                    <b class="fa fa-close"></b>
                    Закрыть
                  </button>
                </div>
              </div>
            </td>
            <td style="vertical-align:top;padding:5px;">
              <div class="shadow-block amb-service-list">
                <c:forEach items="${treatments}" var="g" varStatus="loop">
                  <table id="treatment-${g.group.id}" class="w-100 table-bordered p-5 amb-services <c:if test="${loop.index > 0}">display-none</c:if>" style="position: relative;">
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
                          <button type="button" onclick="setAddingTreatment(${g.group.id}, ${s.id}, ${patient.resident ? s.price : s.for_price}, true)" class="btn btn-success btn-icon"><b class="fa fa-plus"></b></button>
                        </td>
                        <td class="center" style="width:40px">
                          <button type="button" onclick="setAddingTreatment(${g.group.id}, ${s.id}, ${patient.resident ? s.price : s.for_price}, false)" class="btn btn-danger btn-icon display-none minus-treatment" id="minus-treatment-${s.id}"><b class="fa fa-minus"></b></button>
                        </td>
                        <td class="center" style="width:50px">${loop.index + 1}</td>
                        <td>
                          <table class="w-100">
                            <tr>
                              <td>${s.name}</td>
                              <td style="width:30px;padding:0!important;" class="center">
                                <div class="display-none band-counter-2" id="treatment-counter-${s.id}"></div>
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
  let treatments = [], selected_treatments = []
  function reloadTreatmentBlock() {
    $('#patient_treatments').load('/ambs/patient/treatments.s?id=${patient.id}');
  }
  $('#treatment_name').keyup( () => {
    let div = $('#treatment_filter'), elem = $('#treatment_name'), v = elem.val().toUpperCase();
    div.width(elem.width() + 12);
    if(v.length === 0) div.hide();
    if(v.length > 3) {
      if(treatments.length === 0) {
        $.ajax({
          url: '/ambs/patient/treatment-search.s',
          method: 'post',
          data: 'patient=${patient.id}&word=' + encodeURIComponent(v),
          dataType: 'json',
          success: function (res) {
            if (res.success) {
              treatments = res.treatments;
              if(treatments.length > 0) {
                buildTreatments(treatments);
                div.show();
              } else openMedMsg('Данные не найдены', false);
            } else openMsg(res);
          }
        });
      } else {
        let cls = treatments.filter(obj => obj.name.toUpperCase().indexOf(v) !== -1);
        buildTreatments(cls);
      }
    } else {
      treatments = [];
    }
  });
  function buildTreatments(cls) {
    let table = $('#treatment_filter>table>tbody');
    table.html('');
    for(let ser of cls) {
      let tr = $('<tr cid="' + ser.id + '"></tr>');
      tr.click(()=> {
        $('#treatment_filter').hide();
        addTreatment(tr.attr('cid'));
      });
      let name = $('<td>' + ser.name + '</td>');
      let price = $('<td class="center">' + ser.price + '</td>');
      tr.append(name).append(price);
      table.append(tr);
    }
  }
  function addTreatment(id) {
    $.ajax({
      url: '/ambs/patient/add-treatment.s',
      method: 'post',
      data: 'patient=${patient.id}&id=' + id,
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if(res.success)
          reloadTreatmentBlock();
      }
    });
  }

  function delTreatment(id) {
    if(confirm('Вы действительно хотите удалить запись?'))
      $.ajax({
        url: '/ambs/patient/del-treatment.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success) reloadTreatmentBlock();
        }
      });
  }

  function selectTreatmentGroup(dom, id){
    $('.service-groups').removeClass('active');
    $(dom).addClass('active');
    $('.amb-services').addClass('display-none');
    $('#treatment-' + id).removeClass('display-none');
  }
  function setAddingTreatment(group, treatment, price, add) {
    if(add) {
      selected_treatments.push({group: group, treatment: treatment, price: price});
      $('#minus-treatment-' + treatment).removeClass('display-none');
    } else {
      for(let i=0;i<selected_treatments.length;i++){
        if(selected_treatments[i].treatment === treatment) {
          selected_treatments.splice(i, 1);
          break;
        }
      }
    }
    updateTreatmentCounter();
  }
  function updateTreatmentCounter() {
    $('.band-counter-2').addClass('display-none');
    $('.minus-treatment').addClass('display-none');
    for(let g of selected_treatments) {
      $('#group-counter-' + g.group).removeClass('display-none').html(selected_treatments.filter(obj => obj.group === g.group).length);
    }
    let sum = 0;
    for(let g of selected_treatments) {
      $('#treatment-counter-' + g.treatment).removeClass('display-none').html(selected_treatments.filter(obj => obj.treatment === g.treatment).length);
      $('#minus-treatment-' + g.treatment).removeClass('display-none');
      sum += g.price;
    }
    const formattedNumber = sum.toLocaleString('en-US', {style: 'currency', currency: 'UZS'});
    $('#add-treatment-total').html(formattedNumber.replace('UZS', '') + ' сум');
  }
  function clearAddingTreatment() {
    selected_treatments = [];
    updateCounter();
  }
  function saveAllTreatments() {
    if(selected_treatments.length === 0) {
      openMedMsg('Услуги не выбраны', false);
      return;
    }
    let ids = '';
    for(let s of selected_treatments) ids += 'id=' + s.treatment + '&';
    $.ajax({
      url: '/ambs/patient/add-treatments.s',
      method: 'post',
      data: ids + 'patient=${patient.id}',
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if(res.success) {
          getDOM('close_btn').click();
          clearAddingTreatment();
          setTimeout(() => {
            reloadTreatmentBlock();
          }, 1000);
        }
      }
    });
  }
  function setTreatmentLv(treatment, lv) {
    $.ajax({
      url: '/ambs/patient/set-treatment-lv.s',
      method: 'post',
      data: 'patient=${patient.id}&treatment=' + treatment + '&lv=' + lv,
      dataType: 'json',
      success: function (res) {
        openMsg(res);
      }
    });
  }
  function setCheck(evt, id, d) {
    if(evt.target.tagName != 'INPUT') {
      if(!document.getElementById("treatment_" + id + "_" + d).disabled)
        document.getElementById("treatment_" + id + "_" + d).checked = !document.getElementById("treatment_" + id + "_" + d).checked;
    }
  }
  $('#btn-treatment-save').click(() => {
    $.ajax({
      url: '/ambs/patient/save-treatment.s',
      method: 'post',
      data: $('#treatment-form').serialize(),
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if(res.success) setPage('/ambs/reg.s?id=${patient.id}')
      }
    });
  });
  $(()=> {
    $('#treatment-model-content').height($(document).height() - 100);
    $('.amb-treatment-list').height($(document).height() - 200);
    $('.amb-group-list').height($(document).height() - 300);
  })
</script>
