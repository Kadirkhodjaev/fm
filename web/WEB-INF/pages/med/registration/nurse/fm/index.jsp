<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<script src="/res/js/fms-time.js?v=2026101501" type="text/javascript"></script>
<script>
  // маска даты: плагин подгружается один раз (jQuery и общие скрипты уже на главной странице)
  function arMask() { if ($.fn.mask) $(".date-format").mask("99.99.9999", {placeholder: "_"}); }
  if ($.fn.mask) arMask(); else $.getScript('/res/js/jquery.maskedinput.js', arMask);
  let rooms = [];
  <c:forEach items="${rooms}" var="rr">
  rooms.push({id:${rr.id}, dept:'${rr.dept.id}', name:'${rr.floor.name} ${rr.name}-${rr.roomType.name}'})
  </c:forEach>
  function saveForm() {
    if (!$('#patient input[name=id]').val() && !$('input[name=client_id]').val()) { FmsToast.show('Выберите или добавьте клиента', 'err'); return; }
    if (arSaving) return;
    if (checkForm($('#patient'))) {
      arSaving = true;
      $.ajax({
        url: "/reg/nurse/index.s",
        method: "post",
        data: $('form[name=bf]').serialize(),
        dataType: 'json',
        success: function (json) {
          if (json.success) {
            FmsToast.show('Данные сохранены', 'ok');
            setPage('/reg/nurse/index.s?id=' + json.id);
          } else {
            FmsToast.show(json.msg, 'err')
          }
        },
        error: function (data, err) {
          FmsToast.show('Ошибка: ' + err, 'err');
        },
        complete: function () { arSaving = false; }
      });
    } else {
      FmsToast.show('Не заполнены обязательные поля', 'err');
    }
  }
  var arSaving = false;
  function printPage(){
    window.open("/lv/print.s");
  }
  function delPatient(){
    FmsConfirm('Вы действительно хотите удалить данного пациента?', function () {
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
    });
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
    div.width(elem.outerWidth());

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
        $('#client_buttons .cb-add').hide();
        $('#client_buttons .cb-view').show();
        $('#client_buttons .cb-reset').show();
        setClient(tr.attr('cid'));
      });
      let fio = $('<td>' + client.name + '</td>');
      let bd = $('<td class="cf-bd">' + client.birthdate + '</td>');
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
  $('#client_buttons .cb-reset').click(()=> {
    $('#client_buttons .cb-add').show();
    $('#client_buttons .cb-view').hide();
    $('#client_buttons .cb-reset').hide();
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
          arRegion();
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
  $(document).on('click.clientFilter', function(e){
    if (!$(e.target).closest('.client-field').length) $('#client_filter').hide();
  });
</script>

<style>
  /* ================= Общие элементы карточки ================= */
  .ar { --brand:#D7182E; --brand-dark:#A50F22; --brand-soft:#FDECEE; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    max-width: 1200px; margin: 0 auto; padding: 16px 20px 40px; color: var(--text);
    font-family: 'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .ar-card { background:#fff; border:1px solid var(--border); border-radius:14px; margin-bottom:16px; }
  .ar-card-h { display:flex; align-items:center; gap:10px; flex-wrap:wrap; padding:14px 18px; border-bottom:1px solid var(--border); }
  .ar-card-h h3 { margin:0; font-size:16px; font-weight:700; }
  .ar-card-h .sp { flex:1; }
  .ar-card-b { padding:18px; }

  /* Кнопки */
  .ab { display:inline-flex; align-items:center; gap:7px; height:36px; padding:0 14px; border-radius:9px;
    border:1.5px solid var(--border); background:#fff; color:var(--text); font-size:13.5px; font-weight:600;
    white-space:nowrap; cursor:pointer; text-decoration:none !important; transition:background .12s,border-color .12s,color .12s; }
  .ab:hover { background:var(--bg); color:var(--text); }
  .ab .fa { color:var(--muted); }
  .ab.primary { background:var(--brand); border-color:var(--brand); color:#fff; }
  .ab.primary .fa { color:#fff; }
  .ab.primary:hover { background:var(--brand-dark); border-color:var(--brand-dark); }
  .ab.danger:hover { background:var(--brand-soft); border-color:#F5C2C8; color:var(--brand); }
  .ab.danger:hover .fa { color:var(--brand); }
  .ab.sm { height:32px; padding:0 12px; font-size:13px; }
  .ab-ico { width:30px; height:30px; display:inline-flex; align-items:center; justify-content:center; border-radius:8px;
    border:0; background:transparent; color:var(--muted); cursor:pointer; }
  .ab-ico:hover { background:var(--bg); color:var(--text); }
  .ab-ico.del:hover { background:var(--brand-soft); color:var(--brand); }
  .ab-ico.rep:hover { background:#EAF1FE; color:#2563EB; }

  /* Шапка пациента */
  .ar-head { display:flex; align-items:center; flex-wrap:wrap; gap:14px; padding:16px 18px; }
  .ar-avatar { flex:none; width:48px; height:48px; border-radius:14px; background:var(--brand-soft); color:var(--brand);
    display:flex; align-items:center; justify-content:center; font-size:20px; }
  .ar-title { flex:1 1 320px; min-width:0; }
  .ar-title h2 { margin:0 0 4px; font-size:20px; font-weight:700; cursor:pointer; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
  .ar-meta { display:flex; align-items:center; gap:10px; font-size:13px; color:var(--muted); white-space:nowrap; }
  .ar-actions { margin-left:auto; display:flex; align-items:center; gap:8px; flex-wrap:wrap; justify-content:flex-end; }

  .st { display:inline-flex; align-items:center; gap:6px; padding:3px 10px; border-radius:999px; font-size:12px; font-weight:600; white-space:nowrap; }
  .st::before { content:''; width:7px; height:7px; border-radius:50%; background:currentColor; }
  .st-new  { background:#EAF1FE; color:#2563EB; }
  .st-red  { background:var(--brand-soft); color:var(--brand); }
  .st-amb  { background:#FEF3E2; color:#B45309; }
  .st-grn  { background:#E8F7EE; color:#15803D; }
  .st-gry  { background:#F1F2F4; color:#6B7280; }

  /* Сетка полей */
  .fg { display:grid; grid-template-columns:repeat(6, 1fr); gap:14px 16px; }
  .fg .f { display:flex; flex-direction:column; gap:6px; min-width:0; }
  .fg .s2 { grid-column:span 2; } .fg .s3 { grid-column:span 3; } .fg .s4 { grid-column:span 4; } .fg .s6 { grid-column:span 6; }
  .fg label { margin:0; font-size:12.5px; font-weight:600; color:var(--muted); }
  .fg label req, .ar-modal label req { color:var(--brand); }
  .fg .hint { font-size:11.5px; color:#9AA1AC; }
  .ar .form-control, .ar-modal .form-control {
    height:38px; border:1.5px solid var(--border); border-radius:9px; box-shadow:none; font-size:14px; color:var(--text);
  }
  .ar .form-control:focus, .ar-modal .form-control:focus { border-color:var(--brand); box-shadow:0 0 0 3px rgba(215,24,46,.10); }
  .ar .form-control[readonly] { background:#F8F9FA; color:#3C4250; cursor:default; }
  .ar .form-control[readonly]:focus { border-color:var(--border); box-shadow:none; }

  /* Поле клиента с подсказкой */
  .client-field { position:relative; display:flex; gap:8px; }
  .client-field .inp { flex:1; position:relative; }
  #client_buttons { display:flex; gap:6px; }
  #client_buttons .ab { height:38px; }
  #client_filter { top:calc(100% + 4px); left:0; z-index:50; max-height:280px; overflow-y:auto;
    border:1px solid var(--border); border-radius:10px; box-shadow:0 12px 30px rgba(20,25,40,.14); }
  #client_filter table { width:100%; border:0; }
  #client_filter td { padding:9px 12px; border:0; border-bottom:1px solid #F0F1F4; font-size:14px; cursor:pointer; }
  #client_filter td.cf-bd { color:var(--muted); text-align:right; white-space:nowrap; font-variant-numeric:tabular-nums; }
  #client_filter tr:hover td { background:var(--brand-soft); }

  /* Таблица услуг */
  .st-table { width:100%; border-collapse:separate; border-spacing:0; font-size:14px; }
  .st-table th { padding:10px 12px; background:#F8F9FA; border-bottom:1px solid var(--border); color:var(--muted);
    font-size:12px; font-weight:600; text-transform:uppercase; letter-spacing:.3px; text-align:left; white-space:nowrap; }
  .st-table td { padding:8px 12px; border-bottom:1px solid #F0F1F4; vertical-align:middle; }
  .st-table tr:last-child td { border-bottom:0; }
  .st-table tbody tr:hover td { background:#FAFBFC; }
  .st-table .c { text-align:center; } .st-table .r { text-align:right; font-variant-numeric:tabular-nums; }
  .st-table .n { color:#9AA1AC; font-size:13px; }
  .st-table .form-control { height:34px; font-size:13px; min-width:180px; }
  .st-table .sname { font-weight:500; }
  .st-table .sname .fa-medkit { color:#2563EB; margin-right:4px; }
  .st-table tr.unpaid .sname { color:var(--brand-dark); }
  .st-table .sale { display:inline-block; margin-left:6px; padding:1px 8px; border-radius:999px; background:#FEF3E2; color:#B45309; font-size:12px; font-weight:700; }
  .st-table tfoot td { padding:12px; background:#FAFBFC; border-top:1px solid var(--border); font-weight:700; }
  .st-table input[type=checkbox] { width:16px; height:16px; margin:0; cursor:pointer; accent-color:var(--brand); }
  .st-empty { padding:36px; text-align:center; color:#9AA1AC; }

  /* История */
  details.his { border-top:1px solid var(--border); }
  details.his:first-of-type { border-top:0; }
  details.his > summary { display:flex; align-items:center; gap:10px; padding:12px 18px; cursor:pointer; list-style:none; user-select:none; }
  details.his > summary::-webkit-details-marker { display:none; }
  details.his > summary .chev { color:#9AA1AC; transition:transform .15s; }
  details.his[open] > summary .chev { transform:rotate(90deg); }
  details.his > summary b { font-weight:600; }
  details.his > summary .cnt { color:var(--muted); font-size:13px; }
  details.his > summary .sp { flex:1; }
  details.his > summary:hover { background:#FAFBFC; }

  /* Модальные окна */
  .ar-modal .modal-content { border:0; border-radius:16px; box-shadow:0 24px 60px rgba(20,25,40,.25); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .ar-modal .modal-header { padding:16px 20px; border-bottom:1px solid #E6E8EC; }
  .ar-modal .modal-title { font-size:17px; font-weight:700; color:#1F2430; }
  .ar-modal .modal-title .fa { color:#D7182E; margin-right:6px; }
  .ar-modal .modal-body { padding:20px; }
  .ar-modal .modal-footer { padding:14px 20px; border-top:1px solid #E6E8EC; display:flex; justify-content:flex-end; gap:8px; }
  .ar-modal .fg label { color:#6B7280; }
  /* --- дополнительно для этой страницы --- */
  .ar { max-width: 1000px; }
  .fg textarea.form-control { height:auto; min-height:70px; resize:vertical; padding-top:8px; font-family:inherit; }
  .fg .req-star, .fg d { color:var(--brand); font-weight:700; }
  .unit { position:relative; }
  .unit .form-control { padding-right:40px; }
  .unit::after { content:attr(data-unit); position:absolute; right:12px; top:50%; transform:translateY(-50%);
    color:#9AA1AC; font-size:13px; pointer-events:none; }
  .ar-sec-t { grid-column:span 6; margin:6px 0 -2px; padding-top:14px; border-top:1px dashed var(--border);
    font-size:12px; font-weight:700; letter-spacing:.4px; text-transform:uppercase; color:#9AA1AC; }
  .ar-sec-t:first-child { margin-top:0; padding-top:0; border-top:0; }
  .st-table tr.new-row td { background:#FAFBFC; }
  .st-table .form-control { min-width:0; }
  .kdo-row { cursor:pointer; }
  .kdo-row td { transition:background .1s; }
  .kdo-row.on td { background:#FFF7F8; }
  .kdo-total { display:flex; align-items:center; gap:8px; font-size:13px; color:var(--muted); }
  .kdo-total b { color:var(--text); font-variant-numeric:tabular-nums; }
</style>

<!-- ================= Модальное окно: реквизиты клиента ================= -->
<button class="hidden" id="btn_client_view" data-toggle="modal" data-target="#client_info"></button>
<div class="modal fade ar-modal" id="client_info" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog" style="width:880px; max-width:95vw">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title"><i class="fa fa-user"></i> Реквизиты клиента</h4>
      </div>
      <div class="modal-body">
        <form id="clientForm" name="clientForm">
          <input type="hidden" name="cl_id"/>
          <div class="fg">
            <div class="f s2"><label>Фамилия <req>*</req></label>
              <input name="cl_surname" title="Фамилия" placeholder="Фамилия" type="text" class="form-control" required="true" maxlength="64" autocomplete="off"/></div>
            <div class="f s2"><label>Имя <req>*</req></label>
              <input name="cl_name" title="Имя" placeholder="Имя" type="text" class="form-control" required="true" maxlength="64" autocomplete="off"/></div>
            <div class="f s2"><label>Отчество</label>
              <input name="cl_middlename" title="Отчество" placeholder="Отчество" class="form-control" maxlength="64" autocomplete="off"/></div>

            <div class="f s2"><label>Дата рождения <req>*</req></label>
              <input name="cl_birthdate" type="text" class="form-control date-format" placeholder="дд.мм.гггг" maxlength="10"/></div>
            <div class="f s2"><label>Пол <req>*</req></label>
              <select name="cl_sex_id" class="form-control">
                <c:forEach items="${sex}" var="sx">
                  <option value="${sx.id}">${sx.name}</option>
                </c:forEach>
              </select></div>
            <div class="f s2"><label>Номер телефона</label>
              <input name="cl_tel" type="text" class="form-control" maxlength="400"/></div>

            <div class="f"><label>Серия паспорта</label>
              <input name="cl_doc_seria" type="text" class="form-control text-center uppercase" maxlength="2" placeholder="AA"/></div>
            <div class="f s2"><label>Номер паспорта</label>
              <input name="cl_doc_num" type="text" class="form-control" maxlength="10" placeholder="1234567"/></div>
            <div class="f s3"><label>Паспортные данные</label>
              <input name="cl_doc_info" type="text" class="form-control" maxlength="64" placeholder="Кем и когда выдан"/></div>

            <div class="f s3"><label>Резидентство <req>*</req></label>
              <select name="cl_country_id" class="form-control" onchange="arRegion()">
                <c:forEach items="${countries}" var="reg">
                  <option value="${reg.id}">${reg.name}</option>
                </c:forEach>
              </select></div>
            <div class="f s3"><label>Область</label>
              <select name="cl_region_id" class="form-control">
                <c:forEach items="${regions}" var="reg">
                  <option value="${reg.id}">${reg.name}</option>
                </c:forEach>
              </select></div>

            <div class="f s6"><label>Адрес</label>
              <input name="cl_address" type="text" class="form-control" maxlength="400"/></div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="ab" id="close_client_info" data-dismiss="modal" aria-hidden="true">Закрыть</button>
        <button type="button" class="ab primary" onclick="saveClient()"><i class="fa fa-floppy-o"></i> Сохранить</button>
      </div>
    </div>
  </div>
</div>

<div class="ar">

  <!-- ================= Шапка ================= -->
  <div class="ar-card">
    <div class="ar-head">
      <div class="ar-avatar"><i class="fa fa-hospital-o"></i></div>
      <div class="ar-title">
        <h2 <c:if test="${patient.id != null}">title="ID ${patient.id}"</c:if>>
          <c:choose>
            <c:when test="${patient.id != null}">${patient.fio}</c:when>
            <c:otherwise>Новый пациент стационара</c:otherwise>
          </c:choose>
        </h2>
        <div class="ar-meta">
          <c:choose>
            <c:when test="${patient.id == null}"><span class="st st-new">Новая регистрация</span></c:when>
            <c:when test="${patient.state == 'PRN'}"><span class="st st-new">Регистрация</span></c:when>
            <c:otherwise><span class="st st-gry">${patient.state}</span></c:otherwise>
          </c:choose>
          <c:if test="${patient.id != null}"><span>ID ${patient.id}</span></c:if>
          <span>Бемор ҳақида маълумот</span>
        </div>
      </div>
      <div class="ar-actions">
        <c:if test="${patient.id != null}">
          <a href="#" class="ab" onclick="contract(); return false;"><i class="fa fa-file-text-o"></i> Договор</a>
        </c:if>
        <c:if test="${patient.id != null && patient.state == 'PRN'}">
          <a href="#" class="ab danger" onclick="delPatient(); return false;"><i class="fa fa-trash-o"></i> Удалить</a>
          <a href="#" class="ab" onclick="confPatient(); return false;"><i class="fa fa-check"></i> Подтвердить</a>
        </c:if>
        <a href="#" class="ab primary" onclick="saveForm(); return false;"><i class="fa fa-floppy-o"></i> Сохранить</a>
      </div>
    </div>
  </div>

  <f:form commandName="patient" action='/reg/nurse/index.s' method="post" name='bf' target="frm">
    <f:hidden path="id"/>
    <input type="hidden" name="reg" value="${reg}"/>
    <input type="hidden" name="booking" value="${booking}"/>

    <div class="ar-card">
      <div class="ar-card-b">
        <%@include file="/incs/msgs/successError.jsp"%>
        <%@include file="/incs/msgs/errors.jsp"%>
        <div class="fg">

          <!-- ---------- Личные данные ---------- -->
          <div class="ar-sec-t">Личные данные</div>

          <div class="f s6">
            <label>Клиент <req>*</req></label>
            <div class="client-field">
              <div class="inp">
                <input type="hidden" name="client_id" value="${patient.client.id}">
                <input type="text" class="form-control uppercase" name="client_name" autocomplete="off"
                       placeholder="<c:if test="${patient.id == null}">Начните вводить ФИО (от 4 букв) или добавьте нового клиента</c:if>"
                       value="<c:if test="${patient.id != null}">${patient.fio}</c:if>" <c:if test="${patient.id != null}">readonly</c:if>/>
                <div id="client_filter" style="display: none; position: absolute; background:white">
                  <table class="w-100"><tbody></tbody></table>
                </div>
              </div>
              <c:if test="${patient.id == null}">
                <div id="client_buttons">
                  <button type="button" class="ab cb-add" onclick="addClient()" title="Новый клиент"><i class="fa fa-plus"></i> Новый</button>
                  <button type="button" class="ab cb-view" style="display:none" onclick="clientView()" title="Реквизиты клиента"><i class="fa fa-user"></i></button>
                  <button type="button" class="ab danger cb-reset" style="display:none" title="Сбросить клиента"><i class="fa fa-times"></i></button>
                </div>
              </c:if>
            </div>
          </div>

          <div class="f s2"><label>Тугилган сана</label>
            <input type="text" name="birthdayString" class="form-control" readonly value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${patient.birthday}" />"/></div>
          <div class="f s2"><label>Жинси</label>
            <input type="text" name="sex_id" class="form-control" readonly value="${patient.sex.name}"/></div>
          <div class="f s2"><label>Паспорт маълумотлари</label>
            <input type="text" name="passport" class="form-control" readonly value="${patient.passportInfo}"/></div>

          <div class="f s2"><label>Фукоролик</label>
            <input type="text" name="country" class="form-control" readonly value="${countryName}"/></div>
          <div class="f s2"><label>Вилоят</label>
            <input type="text" name="region" class="form-control" readonly value="${regionName}"/></div>
          <div class="f s2"><label>Телефон раками</label>
            <f:input path="tel" type="text" class="form-control" maxlength="400"/></div>

          <div class="f s6"><label>Манзили</label>
            <input type="text" name="address" class="form-control" readonly value="${patient.address}"/></div>

          <div class="f s3"><label>Иш жойи</label>
            <f:input path="work" type="text" class="form-control" maxlength="64"/></div>
          <div class="f s3"><label>Мансаби</label>
            <f:input path="post" type="text" class="form-control" maxlength="64"/></div>

          <!-- ---------- Госпитализация ---------- -->
          <div class="ar-sec-t">Госпитализация</div>

          <div class="f s3"><label>Булим <d></d></label>
            <f:select path="dept.id" required="true" class="form-control" onchange="setOtd(this.value)">
              <option></option>
              <f:options items="${deps}" itemValue="id" itemLabel="name"/>
            </f:select></div>
          <div class="f s3"><label>№ Хона <d></d></label>
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
            </f:select></div>

          <div class="f s2"><label>Кол-во койко-дней <d></d></label>
            <%-- строгое поле: по нему бронирование коек, питание и период назначений. После приёмного врача меняют только лечащий врач и админ в карточке --%>
            <c:choose>
              <c:when test="${patient.id != null && not empty patient.state && patient.state != 'PRN' && patient.state != 'PRD'}">
                <f:input path="dayCount" class="form-control" type="number" readonly="true" title="Меняют лечащий врач и администратор: карточка пациента, вкладка «Регистрация»"/>
                <div style="font-size:11.5px;color:#9AA1AC;margin-top:3px">Меняет лечащий врач в карточке → Регистрация</div>
              </c:when>
              <c:otherwise>
                <f:input path="dayCount" required="true" class="form-control" type="number" min="1" max="365" step="1"
                         oninput="this.value = this.value.replace(/[^0-9]/g, '').slice(0, 3)"/>
              </c:otherwise>
            </c:choose></div>
          <div class="f s2"><label>Руйхатга олинган вакт</label>
            <f:input path="time" type="text" class="form-control fms-time" maxlength="400" placeholder="чч:мм" autocomplete="off"/></div>
          <div class="f s2"><label>Амб. картаси раками</label>
            <f:input path="ambNum" type="text" class="form-control" maxlength="30"/></div>

          <div class="f s3"><label>Бемор қайердан юборилган</label>
            <f:input path="orientedBy" type="text" class="form-control" maxlength="100"/></div>
          <div class="f s3"><label>Транспортда</label>
            <f:input path="transport" type="text" class="form-control" maxlength="64"/></div>

          <div class="f s3"><label>Олиб юриш турлари</label>
            <f:select path="vidPer.id" class="form-control" items="${vidPer}" itemValue="id" itemLabel="name"/></div>
          <div class="f s3"><label>Метка</label>
            <f:select path="metka.id" class="form-control" items="${metka}" itemValue="id" itemLabel="name"/></div>

          <c:if test="${sessionScope.ENV.roleId == 3}">
            <div class="f s6"><label>Йуналтирган мутахасис коди</label>
              <f:select path="lvpartner.id" class="form-control">
                <f:option value=""></f:option>
                <f:options items="${lvpartners}" itemValue="id" itemLabel="code"></f:options>
              </f:select></div>
          </c:if>

          <!-- ---------- Медицинские данные ---------- -->
          <div class="ar-sec-t">Медицинские данные</div>

          <div class="f"><label>Буйи</label>
            <div class="unit" data-unit="см"><f:input path="rost" type="text" class="form-control" placeholder="170" maxlength="3"/></div></div>
          <div class="f"><label>Огирлиги</label>
            <div class="unit" data-unit="кг"><f:input path="ves" type="text" class="form-control" placeholder="70.5" maxlength="5"/></div></div>
          <div class="f"><label>Харорати</label>
            <div class="unit" data-unit="°C"><f:input path="temp" type="text" class="form-control" placeholder="36.6" maxlength="4"/></div></div>
          <div class="f"><label>Қон гуруҳи</label>
            <f:select path="bloodGroup.id" class="form-control" items="${bloodGroup}" itemValue="id" itemLabel="name"/></div>
          <div class="f s2"><label>Резус мансублиги</label>
            <f:input path="resus" type="text" class="form-control" maxlength="100"/></div>

          <div class="f s2"><label>Тениаринхоз санаси</label>
            <f:input path="tarDate" class="form-control datepicker" type="text"/></div>
          <div class="f s2"><label>Больничный лист предоставить</label>
            <f:select path="sickLeave" class="form-control">
              <f:option value="N">Нет</f:option>
              <f:option value="Y">Да</f:option>
            </f:select></div>
          <div class="f s2"></div>

          <div class="f s6"><label>Дориларнинг ножуя тасири</label>
            <f:textarea path="drugEffect" class="form-control" rows="2"/></div>
          <div class="f s6"><label>Йулланмадаги ташхис</label>
            <f:textarea path="diagnoz" class="form-control" maxlength="400" rows="2"/></div>
        </div>
      </div>
    </div>
  </f:form>

  <c:if test="${patient.id > 0}">

    <!-- ================= Дополнительное спальное место ================= -->
    <div class="ar-card">
      <div class="ar-card-h">
        <h3>Дополнительное спальное место</h3>
        <span class="sp"></span>
        <button type="button" class="ab sm primary" onclick="saveWatcher()"><i class="fa fa-plus"></i> Добавить</button>
      </div>
      <div style="overflow-x:auto">
        <table class="st-table">
          <thead>
          <tr>
            <th style="width:130px">Дата</th>
            <th>Тип</th>
            <th class="c" style="width:140px">Кол-во дней</th>
            <th style="width:130px">Состояние</th>
            <th class="c" style="width:56px"></th>
          </tr>
          </thead>
          <tbody>
          <c:forEach items="${watchers}" var="watcher">
            <tr>
              <td><fmt:formatDate pattern="dd.MM.yyyy" value="${watcher.crOn}"/></td>
              <td>${watcher.type.name}</td>
              <td class="c">
                <c:if test="${sessionScope.ENV.userId == 1}">
                  <input type="number" value="${watcher.dayCount}" onchange="setWatcherDayCount(${watcher.id}, this)" class="form-control text-center" placeholder="0"/>
                </c:if>
                <c:if test="${sessionScope.ENV.userId != 1}">${watcher.dayCount}</c:if>
              </td>
              <td>
                <c:choose>
                  <c:when test="${watcher.state == 'ENT'}"><span class="st st-red">Введён</span></c:when>
                  <c:when test="${watcher.state == 'PAID'}"><span class="st st-grn">Оплачено</span></c:when>
                </c:choose>
              </td>
              <td class="c">
                <c:if test="${watcher.state == 'ENT'}">
                  <button type="button" class="ab-ico del" onclick="FmsConfirm('Удалить запись?', function () { removeRow('watcher', ${watcher.id}); })" title="Удалить"><i class="fa fa-trash-o"></i></button>
                </c:if>
              </td>
            </tr>
          </c:forEach>
          <tr class="new-row">
            <td style="color:#6B7280">${curDate}</td>
            <td>
              <select name="type.id" class="form-control" id="watcher_type_id">
                <c:forEach items="${watcherTypes}" var="type">
                  <option value="${type.id}">${type.name}</option>
                </c:forEach>
              </select>
            </td>
            <td>
              <input type="number" id="watcher-day-count" onchange="setWatcherTotal(this)" class="form-control text-center" placeholder="0" min="1" max="${patient.dayCount}"/>
            </td>
            <td><span class="st st-new">Новое</span></td>
            <td></td>
          </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- ================= Обязательные услуги ================= -->
    <div class="ar-card">
      <div class="ar-card-h">
        <h3>Обязательные услуги</h3>
        <span class="sp"></span>
        <span class="kdo-total">Выбрано: <b id="kdoCnt">0</b> · Сумма: <b id="kdoSum">0</b></span>
        <c:if test="${patient.state == 'PRN' || patient.state == 'PRD'}">
          <button type="button" class="ab sm primary" onclick="saveNecKdo()"><i class="fa fa-floppy-o"></i> Сохранить</button>
        </c:if>
      </div>
      <form id="kdoForm">
        <table class="st-table kdoTable">
          <thead>
          <tr>
            <th class="c" style="width:48px"></th>
            <th>Наименование</th>
            <th class="r" style="width:160px">Цена</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach items="${kdos}" var="kdo">
            <tr class="kdo-row" data-price="${kdo.price}">
              <td class="c">
                <input type="hidden" name="id" value="${kdo.id}"/>
                <input type="checkbox" class="kdo-chk" name="kdo${kdo.id}" <c:if test="${fn:indexOf(planIds, kdo.shortName) != -1}">checked</c:if> value="Y">
              </td>
              <td class="sname">${kdo.name}</td>
              <td class="r"><fmt:formatNumber value="${kdo.price}" type="number"/></td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </form>
    </div>
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
          FmsToast.show('Данные сохранены', 'ok');
        } else {
          FmsToast.show(json.msg, 'err');
        }
      },
      error: function (data, err) {
        FmsToast.show('Ошибка: ' + err, 'err');
      }
    });
  }
  function sumFormat(num) {
    var nm = Math.round(num * 100) / 100;
    return nm.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')
  }
  function setWatcherTotal(dom) {
    var v = parseInt(dom.value, 10), max = parseInt('${patient.dayCount}', 10);
    if (isNaN(v) || v < 1) { dom.value = ''; return; }
    if (!isNaN(max) && v > max) { FmsToast.show('Кол-во дней не может превышать кол-во койко-дней пациента (' + max + ')', 'err'); dom.value = ''; }
  }
  function saveWatcher() {
    if(!document.getElementById("watcher-day-count").value) {
      FmsToast.show('Укажите количество дней', 'err');
      document.getElementById("watcher-day-count").focus();
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
            FmsToast.show('Данные сохранены', 'ok');
            setPage('/reg/nurse/index.s?id=${patient.id}');
          } else {
            FmsToast.show(json.msg, 'err');
          }
        },
        error: function (data, err) {
          FmsToast.show('Ошибка: ' + err, 'err');
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
          FmsToast.show('Данные сохранены', 'ok');
          setPage('/reg/nurse/index.s?id=${patient.id}');
        } else {
          FmsToast.show(json.msg, 'err')
        }
      },
      error: function (data, err) {
        FmsToast.show('Ошибка: ' + err, 'err');
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
          FmsToast.show('Данные сохранены', 'ok');
        } else {
          FmsToast.show(res.msg, 'err');
        }
      }
    });
  }

  // Обязательные услуги: клик по строке = галочка, итог по выбранным
  function kdoRecalc() {
    var cnt = 0, sum = 0;
    $('.kdo-row').each(function () {
      var on = $(this).find('.kdo-chk').prop('checked');
      $(this).toggleClass('on', on);
      if (on) { cnt++; sum += parseFloat($(this).attr('data-price')) || 0; }
    });
    $('#kdoCnt').text(cnt);
    $('#kdoSum').text(sumFormat(sum).replace(/,/g, ' '));
  }
  $('.kdo-row').on('click', function (e) {
    if (e.target.type !== 'checkbox') {
      var ch = $(this).find('.kdo-chk');
      ch.prop('checked', !ch.prop('checked'));
    }
    kdoRecalc();
  });
  kdoRecalc();

  $('d').html('*');

  // область нужна только для резидентов (Узбекистан, id 199): прячется всё поле вместе с подписью
  function arRegion() {
    $('select[name=cl_region_id]').closest('.f').toggle($('select[name=cl_country_id]').val() === '199');
  }
  // длинные списки - с поиском (FmsSelect загружен на главной странице); короткие (пол, группа крови, да/нет) остаются обычными
  if (window.FmsSelect)
    $('select[name=cl_country_id], select[name=cl_region_id], select[name="dept.id"], #room_id, select[name="vidPer.id"], select[name="metka.id"], select[name="lvpartner.id"]')
      .each(function () { FmsSelect.attach(this); });
</script>
