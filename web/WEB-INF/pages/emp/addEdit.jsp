<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Сотрудники → карточка сотрудника: клиент (поиск по реестру или новый), описание, активность, ответственные врачи, услуги сотрудника --%>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<%@include file="/WEB-INF/pages/core/forms/modal_style.jsp"%>
<style>
  .em-wrap { display:grid; grid-template-columns:minmax(0, 1fr) 380px; gap:14px; padding:14px; background:#F7F8FA; align-items:start; min-height:100%; }
  .em-card { background:#fff; border:1px solid #E6E8EC; border-radius:14px; }
  .em-h { display:flex; align-items:center; gap:8px; padding:12px 16px; border-bottom:1px solid #F0F1F4; font-size:12px; font-weight:700; color:#6B7280; text-transform:uppercase; letter-spacing:.4px; }
  .em-b { padding:14px 16px; display:flex; flex-direction:column; gap:12px; }
  .em-b .fm-in[readonly] { background:#F5F6F8; }
  .em-client { display:flex; gap:6px; align-items:center; position:relative; }
  .em-client .fm-in { flex:1; text-transform:uppercase; }
  #client_buttons { flex:none; display:flex; gap:4px; }
  #client_buttons .btn { width:34px; height:34px; padding:0; border-radius:9px; border:1px solid #E6E8EC; background:#fff; color:#6B7280; }
  #client_buttons .btn:hover { background:#F5F6F8; color:#1F2430; }
  #client_buttons .btn-success { background:#1F2430; border-color:#1F2430; color:#fff; }
  #client_buttons .btn-danger:hover { background:#FDECEE; border-color:#F5C6CC; color:#A50F22; }
  #client_buttons .display-none { display:none; }
  #client_filter { position:absolute !important; left:0; top:calc(100% + 4px); z-index:20; max-height:300px; overflow:auto; background:#fff !important; border:1px solid #E6E8EC; border-radius:10px; box-shadow:0 12px 32px rgba(20,25,40,.14); }
  #client_filter td { padding:7px 10px; border-bottom:1px solid #F0F1F4; cursor:pointer; font-size:13px; }
  #client_filter tr:hover td { background:#F5F6F8; }
  .em-chip { display:inline-flex; align-items:center; gap:6px; height:30px; margin:2px 6px 2px 0; padding:0 4px 0 12px; border-radius:15px; background:#EEF1F6; color:#1F2430; font-size:13px; font-weight:500; }
  .em-chip button { width:22px; height:22px; padding:0; border:0; border-radius:11px; background:none; color:#9AA1AC; font-size:11px; cursor:pointer; }
  .em-chip button:hover { background:#FDECEE; color:#A50F22; }
  .em-dot { display:inline-block; width:9px; height:9px; border-radius:50%; background:#E5484D; }
  .em-dot.ok { background:#30A46C; }
  #emRows tr { cursor:pointer; }
  @media (max-width: 1100px) { .em-wrap { grid-template-columns:1fr; } }
</style>
<button class="hidden" id="btn_client_view" data-toggle="modal" data-target="#client_info"></button>
<div class="modal fade mdn" id="client_info" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog" style="width:820px; max-width:96vw">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title"><i class="fa fa-user" style="color:#9AA1AC"></i> Реквизиты клиента</h4>
      </div>
      <div class="modal-body">
        <form id="clientForm" name="clientForm" style="display:flex; flex-direction:column; gap:12px" autocomplete="off">
          <input type="hidden" name="cl_id"/>
          <input type="hidden" name="emp_id" value="${emp.id}"/>
          <div class="fm-row" style="grid-template-columns:1fr 1fr 1fr">
            <div><label class="fm-l">Фамилия *</label><input name="cl_surname" type="text" class="fm-in" required maxlength="64"/></div>
            <div><label class="fm-l">Имя *</label><input name="cl_name" type="text" class="fm-in" required maxlength="64"/></div>
            <div><label class="fm-l">Отчество</label><input name="cl_middlename" class="fm-in" maxlength="64"/></div>
          </div>
          <div class="fm-row" style="grid-template-columns:140px 1fr 90px 1fr">
            <div><label class="fm-l">Дата рождения *</label><input name="cl_birthdate" type="text" class="fm-in date-format" style="text-align:center" placeholder="dd.mm.yyyy" maxlength="10"/></div>
            <div>
              <label class="fm-l">Пол *</label>
              <select name="cl_sex_id" class="fm-in"><c:forEach items="${sex}" var="sx"><option value="${sx.id}">${sx.name}</option></c:forEach></select>
            </div>
            <div><label class="fm-l">Серия</label><input name="cl_doc_seria" type="text" class="fm-in" style="text-align:center; text-transform:uppercase" maxlength="2" placeholder="XX"/></div>
            <div><label class="fm-l">Номер паспорта</label><input name="cl_doc_num" type="text" class="fm-in" style="text-align:center" maxlength="10"/></div>
          </div>
          <div class="fm-row" style="grid-template-columns:1fr 1fr">
            <div><label class="fm-l">Кем и когда выдан</label><input name="cl_doc_info" type="text" class="fm-in" maxlength="64"/></div>
            <div><label class="fm-l">Телефон</label><input name="cl_tel" type="text" class="fm-in" maxlength="400"/></div>
          </div>
          <div class="fm-row" style="grid-template-columns:1fr 1fr">
            <div>
              <label class="fm-l">Резидентство *</label>
              <select name="cl_country_id" class="fm-in" onchange="$('select[name=cl_region_id]').toggle(this.value === '199')">
                <c:forEach items="${countries}" var="reg"><option value="${reg.id}">${reg.name}</option></c:forEach>
              </select>
            </div>
            <div>
              <label class="fm-l">Область</label>
              <select name="cl_region_id" class="fm-in"><option value=""></option><c:forEach items="${regions}" var="reg"><option value="${reg.id}">${reg.name}</option></c:forEach></select>
            </div>
          </div>
          <div><label class="fm-l">Адрес</label><input name="cl_address" type="text" class="fm-in" maxlength="400"/></div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="mdn-btn" id="close_client_info" data-dismiss="modal" aria-hidden="true">Закрыть</button>
        <button type="button" class="mdn-btn primary" onclick="saveClient()"><i class="fa fa-floppy-o"></i> Сохранить</button>
      </div>
    </div>
  </div>
</div>

<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-id-card"></i></span>
        <div>
          <h2>${emp.id > 0 ? fn:escapeXml(emp.client.fio) : 'Новый сотрудник'}</h2>
          <span class="fm-count">сотрудник<c:if test="${emp.id > 0}"> · ${emp.state == 'A' ? 'активный' : 'неактивный'}</c:if></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <c:if test="${emp.id > 0}">
        <button type="button" class="fm-btn danger" onclick="delEmp()" title="Удалить сотрудника"><i class="fa fa-trash-o"></i>Удалить</button>
      </c:if>
      <button type="button" class="fm-btn primary" onclick="saveEmp()"><i class="fa fa-floppy-o"></i>Сохранить</button>
      <button type="button" class="fm-btn" onclick="setPage('/emp/index.s')"><i class="fa fa-arrow-left"></i>Назад</button>
    </div>
    <div class="fm-table-wrap" style="padding:0">
      <div class="em-wrap">
        <div class="em-card">
          <div class="em-h"><i class="fa fa-user"></i> Сотрудник</div>
          <form id="addEditForm" name="addEditForm" class="em-b" onsubmit="saveEmp(); return false" autocomplete="off">
            <input type="hidden" name="id" value="${emp.id}" />
            <div>
              <label class="fm-l">Клиент * <span style="font-weight:400">— поиск по фамилии (от 4 букв) или новый</span></label>
              <div class="em-client">
                <input type="hidden" name="client_id" value="${emp.client.id}">
                <input type="text" class="fm-in" name="client_name" placeholder="Ф.И.О." value="<c:if test="${emp.id != null}">${fn:escapeXml(emp.client.fio)}</c:if>" <c:if test="${emp.id != null}">readonly</c:if>/>
                <div id="client_filter" style="display:none"><table class="w-100"><tbody></tbody></table></div>
                <span id="client_buttons">
                  <c:if test="${emp.id == null}">
                    <button type="button" class="btn btn-success" onclick="addClient()" title="Новый клиент"><i class="fa fa-plus"></i></button>
                    <button type="button" class="btn btn-info display-none" onclick="clientView()" title="Реквизиты клиента"><i class="fa fa-user"></i></button>
                    <button type="button" class="btn btn-danger display-none" title="Сбросить клиента"><i class="fa fa-times"></i></button>
                  </c:if>
                </span>
              </div>
            </div>
            <div class="fm-row" style="grid-template-columns:1fr 1fr">
              <div><label class="fm-l">Дата рождения</label><input type="text" name="birthday" class="fm-in" readonly value="<fmt:formatDate pattern="dd.MM.yyyy" value="${emp.client.birthdate}"/>"/></div>
              <div><label class="fm-l">Пол</label><input type="text" name="sex_id" class="fm-in" readonly value="${emp.client.sex.name}"/></div>
              <div><label class="fm-l">Телефон</label><input name="tel" type="text" class="fm-in" maxlength="400" value="${fn:escapeXml(emp.client.tel)}"/></div>
              <div><label class="fm-l">Паспорт</label><input type="text" name="passport" class="fm-in" readonly value="${fn:escapeXml(emp.client.docSeria)} ${fn:escapeXml(emp.client.docNum)}"/></div>
              <div><label class="fm-l">Резидентство</label><input type="text" name="country" class="fm-in" readonly value="${emp.client.country.name}"/></div>
              <div><label class="fm-l">Область</label><input type="text" name="region" class="fm-in" readonly value="${emp.client.region.name}"/></div>
            </div>
            <div><label class="fm-l">Адрес</label><input name="address" type="text" class="fm-in" maxlength="400" value="${fn:escapeXml(emp.client.address)}"/></div>
            <div><label class="fm-l">Описание</label><input type="text" name="text" maxlength="250" class="fm-in" value="${fn:escapeXml(emp.text)}"/></div>
            <div class="fm-tgls"><label class="fm-tgl"><input type="checkbox" <c:if test="${emp.state == 'A'}">checked</c:if> name="state" value="Y"/><span>Активный</span></label></div>
          </form>
        </div>
        <div style="display:flex; flex-direction:column; gap:14px">
          <c:if test="${emp.id > 0}">
            <div class="em-card">
              <div class="em-h"><i class="fa fa-user-md"></i> Ответственные врачи</div>
              <div class="em-b">
                <div>
                  <c:forEach items="${emp_lvs}" var="a">
                    <span class="em-chip">${a.doctor.fio}<button type="button" title="Открепить врача" onclick="delEmpDoctor(${a.id})"><i class="fa fa-times"></i></button></span>
                  </c:forEach>
                  <c:if test="${empty emp_lvs}"><span class="fm-hint">Врачи не прикреплены</span></c:if>
                </div>
                <form id="addEditDoctor" onsubmit="saveDoctor(); return false" style="display:flex; gap:6px">
                  <input type="hidden" name="id" value="${emp.id}" />
                  <select class="fm-in" name="doctor"><c:forEach items="${lvs}" var="a"><option value="${a.id}">${a.fio}</option></c:forEach></select>
                  <button type="submit" class="fm-btn" style="flex:none"><i class="fa fa-plus"></i>Прикрепить</button>
                </form>
              </div>
            </div>
            <div class="em-card">
              <div class="em-h"><i class="fa fa-stethoscope"></i> Услуги сотрудника <span style="font-weight:400; text-transform:none; letter-spacing:0">· ${fn:length(rows)}</span></div>
              <c:if test="${empty rows}"><div class="fm-empty" style="display:block; padding:24px"><i class="fa fa-stethoscope"></i>Услуг ещё не было</div></c:if>
              <c:if test="${not empty rows}">
                <table class="fm-grid">
                  <thead><tr><th style="width:30px"></th><th>Услуга</th><th style="width:110px">Записан</th></tr></thead>
                  <tbody id="emRows">
                  <c:forEach items="${rows}" var="a">
                    <tr onclick="showService(${a.patient}, ${a.id})" title="${a.state == 'DONE' ? 'Выполнено' : 'Не выполнено'} · открыть результат">
                      <td><span class="em-dot ${a.state == 'DONE' ? 'ok' : ''}"></span></td>
                      <td><span class="nm">${a.service.name}</span><c:if test="${not empty a.confDate}"><div class="fm-hint">выполнено <fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${a.confDate}"/></div></c:if></td>
                      <td class="mut"><fmt:formatDate pattern="dd.MM.yyyy" value="${a.crOn}"/></td>
                    </tr>
                  </c:forEach>
                  </tbody>
                </table>
              </c:if>
            </div>
          </c:if>
          <c:if test="${!(emp.id > 0)}">
            <div class="em-card"><div class="em-b fm-hint">Ответственных врачей можно прикрепить после сохранения сотрудника.</div></div>
          </c:if>
        </div>
      </div>
    </div>
  </div>
</div>
<script src="/res/js/jquery.maskedinput.js" type="text/javascript"></script>
<script>
  var clients = [];
  function emRes(res, okText) { if (res.success) FmsToast.show(okText || 'Сохранено', 'ok'); else FmsToast.show(res.msg || 'Не удалось сохранить', 'err'); }
  function showService(patient, id) {
    window.open('/amb/print.s?patient=' + patient + '&ids=' + id);
  }
  function delEmp() {
    FmsConfirm('Удалить сотрудника?', function () { $.ajax({
        url: '/emp/del.s',
        method: 'post',
        data: 'id=${emp.id}',
        dataType: 'json',
        success: function (res) {
          emRes(res, 'Сотрудник удалён');
          if(res.success)
            setPage('/emp/index.s');
        }
      }); });
  }
  function delEmpDoctor(id) {
    FmsConfirm('Открепить врача от сотрудника?', function () { $.ajax({
        url: '/emp/doctor/del.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          emRes(res);
          if(res.success)
            setPage('/emp/addEdit.s?id=${emp.id}');
        }
      }); });
  }
  function saveDoctor() {
    $.ajax({
      url: '/emp/doctor/save.s',
      method: 'post',
      data: $('#addEditDoctor').serialize(),
      dataType: 'json',
      success: function (res) {
        emRes(res);
        if(res.success)
          setPage('/emp/addEdit.s?id=${emp.id}');
      }
    });
  }
  function saveEmp() {
    $.ajax({
      url: '/emp/addEdit.s',
      method: 'post',
      data: $('#addEditForm').serialize(),
      dataType: 'json',
      success: function (res) {
        emRes(res);
        if(res.success) {
          setPage('/emp/addEdit.s?id=' + res.id);
        }
      }
    });
  }
  //region Client Block
  $('input[name=client_name]').keyup( () => {
    <c:if test="${emp.id != null}">return;</c:if>
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
              } else FmsToast.show('Клиент не найден: добавьте нового кнопкой +', 'info');
            } else emRes(res);
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
          emRes(res);
          if(res.dublicate) {
            getDOM('close_client_info').click();
            $('#client_list_content').load('/clients/exists_list.s?amb_id=${emp.id}', () => {
              getDOM('btn_client_list').click();
            });
          } else {
            if (res.success) {
              updateClientInfo(res.id);
            }
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
        } else FmsToast.show(res.msg || 'Ошибка', 'err');
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
        } else FmsToast.show(res.msg || 'Ошибка', 'err');
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
