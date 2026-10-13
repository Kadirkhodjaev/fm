<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%-- jQuery, bootstrap и common.js уже подключены на главной странице: повторное подключение сбрасывало плагины и общие уведомления --%>
<script>
  // маска даты: плагин подгружается один раз
  function arMask() { if ($.fn.mask) $(".date-format").mask("99.99.9999", {placeholder: "_"}); }
  if ($.fn.mask) arMask(); else $.getScript('/res/js/jquery.maskedinput.js', arMask);
  var arSaving = false;
  function doSave() {
    if (arSaving) return;
    if (!$.trim($('input[name=client_id]').val()) && !$('#bf input[name=id]').val()) { FmsToast.show('Выберите или добавьте клиента', 'err'); return; }
    if (checkForm($('#bf'))) {
      arSaving = true;
      $.ajax({
        url: '/amb/reg.s',
        method: 'post',
        data: $('#bf').serialize(),
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            openMsg(res);
            setPage('/amb/reg.s?id=' + res.id);
          } else FmsToast.show(res.msg || 'Не удалось сохранить', 'err');
        },
        complete: function () { arSaving = false; }
      });
    }
  }
  function delPatient(){
    FmsConfirm('Вы действительно хотите удалить данного пациента?', function () {
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
    });
  }
  function setCountery(dom) {
    $('#regionId').toggle(dom.value == '199').val('');
    $('#region_id').toggle(dom.value == '199').val('');
  }
  function delService(id) {
    FmsConfirm('Вы действительно хотите удалить?', function () {
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
    });
  }
  function patientConfirm() {
    FmsConfirm('Отправить к оплате?', function () {
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
    });
  }
  function archiveIt() {
    FmsConfirm('Отправить в архив?', function () {
      $.ajax({
        url: '/amb/confirm.s',
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/amb/home.s');
          } else FmsToast.show(res.msg, 'err');
        }
      });
    });
  }
  function printService(id) {
    var ids='';
    $('input[name="sers' + (id == null ? '' : id) + '"]').each(function() {
      if($(this).prop('checked')) {
        ids += $(this).val() + '_';
      }
    });
    if (ids.length == 0) {
      FmsToast.show('Выберите выполненные услуги для печати', 'info');
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
    FmsConfirm('Назначить физиотерапию?', function () {
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
    });
  }
  function fizioterapiaPrint() {
    window.open('/amb/print.s?fizio=Y');
  }
  function reiterativeConsul(id) {
    FmsConfirm('Повторная консультация в течение 5 дней?', function () {
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
    });
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
    $('input[name=birthday]').val(client.birthdate);
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
          if(res.dublicate) {
            getDOM('close_client_info').click();
            $('#client_list_content').load('/clients/exists_list.s?amb_id=${patient.id}', () => {
              getDOM('btn_client_list').click();
            });
          } else {
            if (res.success) {
              if('${patient.state}' === 'ARCH') {
                getDOM('close_client_info').click();
                getDOM('add_arch_client').style.display = 'none';
              } else {
                updateClientInfo(res.id);
              }
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
  function addArchClient(id) {
    $.ajax({
      url: '/amb/patient/get.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        if(res.success) {
          $('input[name=cl_surname]').val(res.surname);
          $('input[name=cl_name]').val(res.name);
          $('input[name=cl_middlename]').val(res.middlename);
          $('input[name=cl_birthdate]').val(res.birthdate);
          $('select[name=cl_sex_id]').val(res.sex_id);
          $('input[name=cl_tel]').val(res.tel);
          $('select[name=cl_country_id]').val(res.country_id);
          $('select[name=cl_region_id]').val(res.region_id);
          $('input[name=cl_address]').val(res.address);
          $('#btn_client_view').click();
        } else
          openMsg(res);
      }
    });
  }
  function chooseClient(id) {
    $.ajax({
      url: '/clients/get.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if(res.success) {
          getDOM('client_list_close').click();
          $('input[name=cl_id]').val(res.id);
          $('input[name=cl_surname]').val(res.surname);
          $('input[name=cl_name]').val(res.name);
          $('input[name=cl_middlename]').val(res.middlename);
          $('input[name=cl_birthdate]').val(res.birthdate);
          $('select[name=cl_sex_id]').val(res.sex_id);
          $('input[name=cl_doc_seria]').val(res.doc_seria);
          $('input[name=cl_doc_num]').val(res.doc_num);
          $('input[name=cl_doc_info]').val(res.passport);
          $('input[name=cl_tel]').val(res.tel);
          $('select[name=cl_country_id]').val(res.country_id);
          $('select[name=cl_region_id]').val(res.region_id);
          $('input[name=cl_address]').val(res.address);
          $('#btn_client_view').click();
        }
      }
    });
  }
  function podCash() {
    setPage("/cashbox/amb.s?id=${patient.id}");
  }
  // закрыть подсказку клиентов при клике мимо
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
  .ar-head { display:flex; align-items:center; gap:14px; padding:16px 18px; flex-wrap:wrap; }
  .ar-avatar { flex:none; width:48px; height:48px; border-radius:14px; background:var(--brand-soft); color:var(--brand);
    display:flex; align-items:center; justify-content:center; font-size:20px; }
  .ar-title { min-width:0; flex:1 1 360px; }
  .ar-title h2 { margin:0 0 4px; font-size:20px; font-weight:700; cursor:pointer; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
  .ar-meta { display:flex; align-items:center; gap:6px 10px; flex-wrap:wrap; font-size:13px; color:var(--muted); }
  .ar-meta > * { white-space:nowrap; }
  .st.ni::before { display:none; }
  .ar-actions { margin-left:auto; display:flex; align-items:center; gap:6px; flex-wrap:wrap; justify-content:flex-end; }
  .ar-actions .ab { height:34px; padding:0 11px; gap:6px; font-size:13px; white-space:nowrap; }

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
          <input type="hidden" name="amb_id" value="${patient.id}"/>
          <div class="fg">
            <div class="f s2"><label>Фамилия <req>*</req></label>
              <input name="cl_surname" title="Фамилия" placeholder="Фамилия" type="text" class="form-control" required maxlength="64" autocomplete="off"/></div>
            <div class="f s2"><label>Имя <req>*</req></label>
              <input name="cl_name" title="Имя" placeholder="Имя" type="text" class="form-control" required maxlength="64" autocomplete="off"/></div>
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
              <select name="cl_country_id" class="form-control" onchange="$('select[name=cl_region_id]').toggle(this.value === '199').val()">
                <c:forEach items="${countries}" var="reg">
                  <option value="${reg.id}">${reg.name}</option>
                </c:forEach>
              </select></div>
            <div class="f s3"><label>Область</label>
              <select name="cl_region_id" class="form-control">
                <option value=""></option>
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

<!-- ================= Модальное окно: список совпавших клиентов ================= -->
<button class="hidden" id="btn_client_list" data-toggle="modal" data-target="#client_list"></button>
<div class="modal fade ar-modal" id="client_list" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog" style="width:880px; max-width:95vw">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" id="client_list_close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title"><i class="fa fa-users"></i> Похожие клиенты</h4>
      </div>
      <div class="modal-body" id="client_list_content"></div>
    </div>
  </div>
</div>

<iframe id="frmDiv" name="frm" class="hidden"></iframe>

<div class="ar">

  <!-- ================= Шапка пациента ================= -->
  <div class="ar-card">
    <div class="ar-head">
      <div class="ar-avatar"><i class="fa fa-user"></i></div>
      <div class="ar-title">
        <h2 title="ID ${patient.id}">
          <c:choose>
            <c:when test="${patient.id != null}">${patient.fio}</c:when>
            <c:otherwise>Новый пациент</c:otherwise>
          </c:choose>
        </h2>
        <div class="ar-meta">
          <c:choose>
            <c:when test="${patient.id == null}"><span class="st st-new">Новая регистрация</span></c:when>
            <c:when test="${patient.state == 'PRN'}"><span class="st st-new">Регистрация</span></c:when>
            <c:when test="${patient.state == 'CASH'}"><span class="st st-amb">Ожидание оплаты</span></c:when>
            <c:when test="${patient.state == 'WORK'}"><span class="st st-amb">Оказание услуг</span></c:when>
            <c:when test="${patient.state == 'DONE'}"><span class="st st-grn">Услуги оказаны</span></c:when>
            <c:when test="${patient.state == 'ARCH'}"><span class="st st-gry">Закрыта</span></c:when>
            <c:otherwise><span class="st st-gry">${patient.state}</span></c:otherwise>
          </c:choose>
          <c:if test="${patient.id != null}"><span>ID ${patient.id}</span></c:if>
          <%-- результаты отправлены пациенту: PDF в Telegram и/или открыты в приложении --%>
          <c:if test="${not empty resSent.sent}"><span class="st st-grn ni" title="PDF результатов отправлен в Telegram, раз: ${resSent.sentCount}${resSent.byRegistry ? ' (в том числе регистратурой)' : ''}"><i class="fa fa-paper-plane"></i> Результаты отправлены ${resSent.sent}</span></c:if>
          <c:if test="${not empty resSent.opened}"><span class="st st-grn ni" title="Пациент открыл файл результатов в приложении (раз: ${resSent.openCount})"><i class="fa fa-mobile"></i> Открыты в приложении ${resSent.opened}</span></c:if>
        </div>
      </div>

      <div class="ar-actions">
        <c:if test="${pat != null}">
          <a href="#" class="ab" onclick="openMainPage('/${pat.state == 'ARCH' ? 'view' : 'lv'}/index.s?id=${pat.id}', false); return false"><i class="fa fa-folder-open-o"></i> ИБ №${pat.yearNum}</a>
        </c:if>
        <c:if test="${patient.id != null && not empty patient.client}">
          <%-- Telegram: кнопка появляется после проверки, зарегистрирован ли клиент в боте с номером из карточки --%>
          <span id="tgAmbBtn" style="display:none"></span>
          <script>
            (function () {
              var done = ${patient.state == 'DONE' || patient.state == 'ARCH'};
              $.ajax({
                url: '/clients/tg/status.s', method: 'post', dataType: 'json', data: {id: ${patient.client.id}, amb: ${patient.id}},
                success: function (st) {
                  if (!st.success || !st.enabled) return;
                  var a = $('<a href="#" class="ab"></a>');
                  if (st.linked) {
                    a.html('<i class="fa fa-paper-plane" style="color:#229ED9"></i> Отправить результаты')
                      .attr('title', 'Клиент зарегистрирован в Telegram (' + st.phone + '). Отправить PDF результатов этого визита');
                    if (!done) a.css('opacity', .5).attr('title', 'Результаты можно отправить, когда услуги оказаны');
                    a.on('click', function () {
                      if (!done) return false;
                      FmsConfirm('Отправить клиенту PDF результатов этого визита в Telegram?', function () {
                        $.post('/clients/tg/result.s', {amb: ${patient.id}}, function (r) { openMedMsg(r.msg || (r.success ? 'Отправлено' : 'Не удалось отправить'), !!r.success); }, 'json');
                      });
                      return false;
                    });
                  } else if (st.invite) {
                    a.html('<i class="fa fa-paper-plane" style="color:#229ED9"></i> Отправить ссылку в Telegram')
                      .attr('title', st.noPhone ? 'В карточке неполный номер телефона' : 'Клиент ещё не зарегистрирован в боте: отправить ему ссылку с номера клиники');
                    if (st.noPhone) a.css('opacity', .5);
                    a.on('click', function () {
                      if (st.noPhone) { FmsToast.show('В карточке неполный номер телефона. Исправьте номер и сохраните.', 'err'); return false; }
                      FmsConfirm('Отправить клиенту ссылку на бот клиники в Telegram?', function () {
                        $.post('/clients/tg/invite.s', {id: ${patient.client.id}}, function (r) { openMedMsg(r.msg || (r.success ? 'Отправлено' : 'Не удалось отправить'), !!r.success); }, 'json');
                      });
                      return false;
                    });
                  } else return;
                  $('#tgAmbBtn').append(a).show();
                }
              });
            })();
          </script>
        </c:if>
        <c:if test="${patient.id != null && patient.state != 'ENT' && sessionScope.ENV.roleId == 15}">
          <a href="#" class="ab" onclick="loadPdf(); return false;" title="Генерация PDF файла"><i class="fa fa-file-pdf-o"></i> Результаты PDF</a>
          <iframe name="pdffile" id="pdffile" src="about:blank" style="display: none"></iframe>
        </c:if>
        <c:if test="${patient.state != 'ARCH'}">
          <c:if test="${patient.fizio != 'Y' && patient.id != null}">
            <a href="#" class="ab" onclick="fizioterapia(); return false;"><i class="fa fa-medkit"></i> Физиотерапия</a>
          </c:if>
          <c:if test="${patient.fizio == 'Y' && patient.id != null && fizio_user}">
            <a href="#" class="ab" onclick="fizioterapiaPrint(); return false;"><i class="fa fa-print"></i> Физиотерапия</a>
          </c:if>
          <c:if test="${drug_exist}">
            <a href="#" class="ab" onclick="openDrug(); return false;"><i class="fa fa-list-alt"></i> Лист назначений</a>
          </c:if>
          <c:if test="${fn:length(services) > 0 && (patient.state == 'CASH' || patient.state == 'WORK') && (sessionScope.ENV.userId == 1 || sessionScope.ENV.userId == 99)}">
            <a href="#" class="ab" onclick="podCash(); return false;"><i class="fa fa-money"></i> Касса</a>
          </c:if>
        </c:if>
        <c:if test="${patient.id != null && patient.state == 'PRN'}">
          <a href="#" class="ab danger" onclick="delPatient(); return false;"><i class="fa fa-trash-o"></i> Удалить</a>
        </c:if>
        <c:if test="${done}">
          <a href="#" class="ab" onclick="archiveIt(); return false;"><i class="fa fa-archive"></i> В архив</a>
        </c:if>
        <c:if test="${patient.id != null && patient.state == 'PRN' && fn:length(services) > 0}">
          <a href="#" class="ab" onclick="patientConfirm(); return false;"><i class="fa fa-check"></i> К оплате</a>
        </c:if>
        <c:if test="${patient.state != 'ARCH'}">
          <a href="#" class="ab primary" onclick="doSave(); return false;"><i class="fa fa-floppy-o"></i> Сохранить</a>
        </c:if>
      </div>
    </div>
  </div>

  <f:form commandName="patient" action='/amb/reg.s' method="post" id='bf' target="frm">
    <f:hidden path="id"/>

    <!-- ================= Реквизиты ================= -->
    <div class="ar-card">
      <div class="ar-card-h"><h3>Реквизиты пациента</h3></div>
      <div class="ar-card-b panel-body" style="padding:18px">
        <%@include file="/incs/msgs/successError.jsp"%>
        <div class="fg">

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
              <c:if test="${patient.id == null || (patient.id > 0 && patient.state == 'ARCH' && patient.client == null)}">
                <div id="client_buttons">
                  <c:if test="${patient.id == null}">
                    <button type="button" class="ab cb-add" onclick="addClient()" title="Новый клиент"><i class="fa fa-plus"></i> Новый</button>
                    <button type="button" class="ab cb-view" style="display:none" onclick="clientView()" title="Реквизиты клиента"><i class="fa fa-user"></i></button>
                    <button type="button" class="ab danger cb-reset" style="display:none" title="Сбросить клиента"><i class="fa fa-times"></i></button>
                  </c:if>
                  <c:if test="${patient.id > 0 && patient.state == 'ARCH' && patient.client == null}">
                    <button type="button" class="ab" id="add_arch_client" onclick="addArchClient(${patient.id})" title="Привязать клиента"><i class="fa fa-link"></i> Привязать клиента</button>
                  </c:if>
                </div>
              </c:if>
            </div>
          </div>

          <div class="f s2">
            <label><c:if test="${patient.birthday == null}">Год рождения</c:if><c:if test="${patient.birthday != null}">Дата рождения</c:if></label>
            <input type="text" name="birthday" class="form-control" readonly value="<c:if test="${patient.birthday == null}">${patient.birthyear}</c:if><c:if test="${patient.birthday != null}"><fmt:formatDate pattern="dd.MM.yyyy" value="${patient.birthday}"/></c:if>"/>
          </div>
          <div class="f s2">
            <label><ui:message code="sex"/></label>
            <input type="text" name="sex_id" class="form-control" readonly value="${patient.sex.name}"/>
          </div>
          <div class="f s2">
            <label><ui:message code="phone"/></label>
            <f:input path="tel" type="text" class="form-control" maxlength="400"/>
          </div>

          <div class="f s2">
            <label><ui:message code="passportInfo"/></label>
            <input type="text" name="passport" class="form-control" readonly value="${patient.passportInfo}"/>
          </div>
          <div class="f s2">
            <label>Резидентство</label>
            <input type="text" name="country" class="form-control" readonly value="${countryName}"/>
          </div>
          <div class="f s2">
            <label>Область</label>
            <input type="text" name="region" class="form-control" readonly value="${regionName}"/>
          </div>

          <div class="f s6">
            <label><ui:message code="address"/></label>
            <f:input path="address" type="text" class="form-control" maxlength="400"/>
          </div>

          <c:if test="${sessionScope.ENV.roleId == 15}">
            <div class="f s2">
              <label>Код отправителя (лечащего врача)</label>
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
            </div>
          </c:if>
          <%-- Поле "Мобильный (Telegram и SMS)" скрыто: Telegram теперь работает по полю "Телефон". Значение сохраняется как было --%>
          <f:hidden path="tgNumber"/>
          <div class="f s2">
            <label>Тип скидки</label>
            <select class="form-control" name="discount_type">
              <c:forEach items="${discount_type}" var="a">
                <option <c:if test="${patient.discountType.id == a.id}">selected</c:if> value="${a.id}">${a.name}</option>
              </c:forEach>
            </select>
          </div>
        </div>
      </div>
    </div>

    <!-- ================= Услуги ================= -->
    <c:if test="${patient.id != null}">
      <div class="ar-card">
        <div class="ar-card-h">
          <h3>Услуги</h3>
          <span class="sp"></span>
          <button class="ab sm" type="button" onclick="printService(null)"><i class="fa fa-print"></i> Печать</button>
          <c:if test="${patient.state != 'ARCH' && packs > 0 && sessionScope.ENV.roleId == 15}">
            <button class="ab sm" type="button" onclick="openMainPage('/amb/packs.s')"><i class="fa fa-plus"></i> Пакеты</button>
          </c:if>
          <c:if test="${patient.state != 'ARCH'}">
            <button class="ab sm primary" type="button" onclick="openMainPage('/amb/services.s')"><i class="fa fa-plus"></i> Услуги</button>
          </c:if>
        </div>

        <c:choose>
          <c:when test="${fn:length(services) == 0}">
            <div class="st-empty">Услуги ещё не добавлены</div>
          </c:when>
          <c:otherwise>
            <div style="overflow-x:auto">
              <table class="st-table">
                <thead>
                <tr>
                  <th class="c" style="width:44px">№</th>
                  <th class="c" style="width:40px"><input type="checkbox" onclick="setAllCheck(this, null)" title="Выбрать все для печати"></th>
                  <th>Наименование</th>
                  <th style="width:130px">Статус</th>
                  <th class="r" style="width:110px">Сумма</th>
                  <th class="r" style="width:110px">С НДС</th>
                  <th style="width:140px">Подтверждено</th>
                  <th style="width:210px">Врач</th>
                  <th class="c" style="width:76px"></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${services}" var="ser" varStatus="loop">
                  <tr id="ser${ser.id}" class="${ser.state == 'ENT' ? 'unpaid' : ''}" <c:if test="${ser.pack != '' && ser.pack != null}">title="Услуга пакета: ${ser.pack}"</c:if>>
                    <td class="c n">${loop.index + 1}</td>
                    <td class="c" title="Печать">
                      <c:if test="${ser.state == 'DONE'}"><input type="checkbox" name="sers" value="${ser.id}"/></c:if>
                    </td>
                    <td class="sname">
                      <c:if test="${ser.pack != '' && ser.pack != null}"><i class="fa fa-medkit" title="Пакет: ${ser.pack}"></i></c:if>
                        ${ser.service.name}
                      <c:if test="${ser.saleProc > 0}"><span class="sale">−${ser.saleProc}%</span></c:if>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${ser.state == 'ENT'}"><span class="st st-red">Не оплачено</span></c:when>
                        <c:when test="${ser.state == 'PAID'}"><span class="st st-amb">Оплачено</span></c:when>
                        <c:when test="${ser.state == 'DONE'}"><span class="st st-grn">Выполнено</span></c:when>
                        <c:when test="${ser.state == 'DEL'}"><span class="st st-gry">Возврат</span></c:when>
                        <c:when test="${ser.state == 'AUTO_DEL'}"><span class="st st-gry">Удалён</span></c:when>
                      </c:choose>
                    </td>
                    <td class="r">${ser.price}</td>
                    <td class="r">${ser.nds}</td>
                    <td style="white-space:nowrap; color:#6B7280"><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${ser.confDate}"/></td>
                    <td>
                      <input type="hidden" name="service" value="${ser.id}"/>
                      <select name="user" class="form-control">
                        <c:forEach items="${ser.users}" var="u">
                          <option <c:if test="${ser.worker.id == u.id}">selected</c:if> value="${u.id}">${u.fio}</option>
                        </c:forEach>
                      </select>
                    </td>
                    <td class="c" style="white-space:nowrap">
                      <c:if test="${ser.repeat}">
                        <button type="button" class="ab-ico rep" title="Повторная консультация" onclick="reiterativeConsul(${ser.id})"><i class="fa fa-repeat"></i></button>
                      </c:if>
                      <c:if test="${patient.state != 'ARCH' && (ser.state == 'ENT' || (ser.state == 'PAID' && ser.resultId == 0 && patient.emp != 0 && ser.crBy == sessionScope.ENV.userId))}">
                        <button type="button" class="ab-ico del" title="Удалить" onclick="delService(${ser.id})"><i class="fa fa-trash-o"></i></button>
                      </c:if>
                    </td>
                  </tr>
                </c:forEach>
                </tbody>
                <c:if test="${serviceTotal > 0}">
                  <tfoot>
                  <tr>
                    <td colspan="4">Итого не оплачено</td>
                    <td class="r"><fmt:formatNumber value="${serviceTotal}" type="number"/></td>
                    <td class="r"><fmt:formatNumber value="${ndsTotal}" type="number"/></td>
                    <td colspan="3"></td>
                  </tr>
                  </tfoot>
                </c:if>
              </table>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </c:if>
  </f:form>

  <!-- ================= История ================= -->
  <c:if test="${patient.id != null && fn:length(histories) > 0}">
    <div class="ar-card">
      <div class="ar-card-h"><h3>История обращений</h3><span class="sp"></span><span style="color:#6B7280;font-size:13px">${fn:length(histories)}</span></div>
      <c:forEach items="${histories}" var="his">
        <details class="his">
          <summary>
            <i class="fa fa-angle-right chev"></i>
            <b><fmt:formatDate pattern="dd.MM.yyyy" value="${his.regDate}"/></b>
            <span class="cnt">· услуг: ${fn:length(his.services)}</span>
            <span class="sp"></span>
            <button class="ab sm" type="button" onclick="event.preventDefault(); printService(${his.id})"><i class="fa fa-print"></i> Печать</button>
          </summary>
          <div style="overflow-x:auto; border-top:1px solid #F0F1F4">
            <table class="st-table">
              <thead>
              <tr>
                <th class="c" style="width:44px">№</th>
                <th class="c" style="width:40px"><input type="checkbox" onclick="setAllCheck(this, ${his.id})"></th>
                <th>Наименование</th>
                <th class="r" style="width:130px">Сумма</th>
                <th class="r" style="width:130px">С НДС</th>
              </tr>
              </thead>
              <tbody>
              <c:forEach items="${his.services}" var="ser" varStatus="loop">
                <tr id="ser${ser.id}" class="${ser.state == 'ENT' ? 'unpaid' : ''}">
                  <td class="c n">${loop.index + 1}</td>
                  <td class="c" title="Печать">
                    <c:if test="${ser.state == 'DONE'}"><input type="checkbox" name="sers${his.id}" value="${ser.id}"/></c:if>
                  </td>
                  <td class="sname">${ser.service.name}</td>
                  <td class="r">${ser.price}</td>
                  <td class="r">${ser.nds}</td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </details>
      </c:forEach>
    </div>
  </c:if>
</div>

<!-- ================= Модальное окно: лист назначений ================= -->
<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
<div class="modal fade ar-modal" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog" style="width:96%; max-width:1400px">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel"><i class="fa fa-list-alt"></i> Лист назначений</h4>
      </div>
      <div class="modal-body" id="amb_drug"></div>
    </div>
  </div>
</div>
