<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/js/jquery.maskedinput.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<script src="/res/js/common.js?v=2026101501"></script>
<script src="/res/js/fms-calendar.js?v=2" type="text/javascript" charset="UTF-8"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<style>
  .abk { --brand:#D7182E; --brand-dark:#A50F22; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    padding:16px 20px 32px; color:var(--text); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .abk * { box-sizing:border-box; }
  .abk-card { background:#fff; border:1px solid var(--border); border-radius:14px; margin-bottom:14px; }

  /* ---------- Кнопки ---------- */
  .abk .ab, .abk-modal .ab { display:inline-flex; align-items:center; gap:7px; height:36px; padding:0 14px; border-radius:9px; border:1px solid var(--border, #E6E8EC);
    background:#fff; color:#1F2430; font-size:13.5px; font-weight:600; font-family:inherit; cursor:pointer; white-space:nowrap;
    text-decoration:none; transition:background .12s, border-color .12s; }
  .abk .ab:hover, .abk-modal .ab:hover { background:#F5F6F8; border-color:#D5D8DD; color:#1F2430; text-decoration:none; }
  .abk .ab.sm { height:32px; padding:0 11px; font-size:13px; }
  .abk .ab.main, .abk-modal .ab.main { background:#D7182E; border-color:#D7182E; color:#fff; }
  .abk .ab.main:hover, .abk-modal .ab.main:hover { background:#A50F22; border-color:#A50F22; color:#fff; }
  .abk .ab.dark { background:var(--text); border-color:var(--text); color:#fff; }
  .abk .ab.dark:hover { background:#000; color:#fff; }
  .abk .ib { width:30px; height:30px; display:inline-flex; align-items:center; justify-content:center; border:0; border-radius:8px;
    background:none; color:#9AA1AC; cursor:pointer; font-size:14px; }
  .abk .ib:hover { background:#FDECEE; color:var(--brand); }

  /* ---------- Шапка ---------- */
  .abk-head { display:flex; align-items:center; gap:14px; padding:14px 18px; flex-wrap:wrap; }
  .abk-ic { flex:none; width:40px; height:40px; border-radius:10px; background:var(--bg); color:var(--muted); display:flex; align-items:center; justify-content:center; font-size:17px; }
  .abk-who { flex:1; min-width:240px; }
  .abk-who h2 { margin:0; font-size:19px; font-weight:700; line-height:1.25; cursor:pointer; }
  .abk-who .meta { margin-top:3px; font-size:13px; color:var(--muted); display:flex; gap:12px; flex-wrap:wrap; align-items:center; }
  .abk-badge { display:inline-block; padding:2px 9px; border-radius:10px; font-size:12px; font-weight:600; background:#EAF1FE; color:#2563EB; }
  .abk-badge.arch { background:#F1F2F4; color:var(--muted); }
  .abk-btns { display:flex; gap:8px; flex-wrap:wrap; }
  .abk .ab.back { margin-left:8px; }

  /* ---------- Реквизиты ---------- */
  .abk-body { padding:16px 18px 20px; border-top:1px solid var(--border); }
  .abk-sec { margin:0 0 10px; font-size:11.5px; font-weight:700; text-transform:uppercase; letter-spacing:.4px; color:#9AA1AC; }
  .abk-grid { display:grid; grid-template-columns:repeat(6, minmax(0, 1fr)); gap:12px 14px; margin-bottom:20px; }
  .abk-grid:last-child { margin-bottom:0; }
  .abk-grid .s2 { grid-column:span 2; } .abk-grid .s3 { grid-column:span 3; } .abk-grid .s4 { grid-column:span 4; } .abk-grid .s6 { grid-column:span 6; }
  .abk .fg { min-width:0; }
  .abk .fg label { display:block; margin:0 0 5px; font-size:12px; font-weight:600; color:var(--muted); }
  .abk .fg label i { font-style:normal; color:var(--brand); }
  .abk .fg .form-control { width:100%; height:38px; padding:0 10px; border:1px solid var(--border); border-radius:9px; font-size:14px; font-family:inherit;
    color:var(--text); background-color:#fff; box-shadow:none; transition:border-color .15s, box-shadow .15s; }
  .abk .fg .form-control:focus { border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .abk .fg .form-control[readonly] { background-color:#F8F9FA; color:var(--muted); }
  .abk .fg .form-control.center { text-align:center; }
  .abk .fg .form-control.fms-cal { min-width:160px; }
  .abk .uppercase { text-transform:uppercase; }

  /* поле клиента с поиском и кнопками */
  .abk-client { display:flex; gap:8px; align-items:flex-start; }
  .abk-client .wrap { position:relative; flex:1; min-width:0; }
  .abk-client .wrap .fa-search { position:absolute; left:12px; top:12px; color:#9AA1AC; font-size:13px; pointer-events:none; }
  .abk-client .wrap .form-control { padding-left:34px; font-weight:600; }
  .abk-client .wrap .form-control[readonly] { color:var(--text); }
  #client_buttons { flex:none; display:flex; gap:4px; }
  #client_buttons:empty { display:none; }
  #client_buttons .btn { width:38px; height:38px; padding:0; border-radius:9px; border:1px solid var(--border); background:#fff; color:var(--muted);
    font-size:14px; line-height:36px; text-align:center; box-shadow:none; }
  #client_buttons .btn:hover { background:var(--bg); color:var(--text); }
  #client_buttons .btn-success { background:var(--text); border-color:var(--text); color:#fff; }
  #client_buttons .btn-success:hover { background:#000; color:#fff; }
  #client_buttons .btn-danger:hover { background:#FDECEE; border-color:#F5C6CC; color:var(--brand); }
  #client_filter { z-index:20; top:42px; left:0; max-height:320px; overflow:auto; border:1px solid var(--border); border-radius:12px;
    box-shadow:0 12px 32px rgba(20,25,40,.14); }
  #client_filter table { width:100%; border-collapse:collapse; font-size:13.5px; }
  #client_filter td { padding:9px 12px; border:0; border-bottom:1px solid #F0F1F4; cursor:pointer; }
  #client_filter td.center { width:120px; text-align:center; color:var(--muted); font-variant-numeric:tabular-nums; }
  #client_filter tr:last-child td { border-bottom:0; }
  #client_filter tr:hover td { background:#F7F8FA; }

  /* ---------- Услуги ---------- */
  .sec-h { display:flex; align-items:center; gap:10px; padding:12px 16px; border-bottom:1px solid var(--border); flex-wrap:wrap; }
  .sec-h h3 { margin:0; font-size:15px; font-weight:700; }
  .sec-h .cnt { display:inline-block; min-width:22px; padding:1px 7px; border-radius:10px; background:#F1F2F4; color:var(--muted); font-size:12px; font-weight:700; text-align:center; }
  .sec-h .sp { flex:1; }
  .sec-wrap { overflow-x:auto; border-radius:0 0 14px 14px; }
  .abk .st { width:100%; border-collapse:separate; border-spacing:0; font-size:13.5px; margin:0; }
  .abk .st th { padding:9px 12px; background:#F8F9FA; border-bottom:1px solid var(--border); color:var(--muted); font-size:11.5px; font-weight:600;
    text-transform:uppercase; letter-spacing:.3px; text-align:left; white-space:nowrap; }
  .abk .st td { padding:7px 12px; border-bottom:1px solid #F0F1F4; vertical-align:middle; }
  .abk .st th.r, .abk .st td.r { text-align:right; font-variant-numeric:tabular-nums; }
  .abk .st th.c, .abk .st td.c { text-align:center; }
  .abk .st td.num { color:#9AA1AC; width:44px; }
  .abk .st td.nm { font-weight:500; min-width:220px; }
  .abk .st tbody tr:hover td { background:#FAFBFC; }
  .abk .st select.form-control { height:34px; min-width:200px; padding:0 8px; border:1px solid var(--border); border-radius:8px; font-size:13.5px;
    box-shadow:none; background-color:#fff; font-family:inherit; }
  .abk .st select.form-control:focus { border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .abk .st tr.total td { background:#F8F9FA; border-bottom:0; border-top:1px solid var(--border); font-weight:700; font-size:14.5px; }
  .abk .st tr.empty td { padding:30px 12px; text-align:center; color:#9AA1AC; }
  .abk .st tr.empty .fa { display:block; font-size:24px; margin-bottom:8px; color:#C3C7CE; }

  /* ---------- Модалки ---------- */
  .abk-modal .modal-dialog { width:100%; max-width:820px; }
  .abk-modal .modal-content { border:0; border-radius:16px; box-shadow:0 24px 60px rgba(20,25,40,.25); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:#1F2430; }
  .abk-modal .modal-header { padding:16px 20px; border-bottom:1px solid #E6E8EC; }
  .abk-modal .modal-title { font-size:17px; font-weight:700; }
  .abk-modal .modal-title .fa { color:#6B7280; margin-right:6px; }
  .abk-modal .modal-body { padding:18px 20px 20px; }
  .abk-modal .modal-footer { padding:14px 20px; border-top:1px solid #E6E8EC; display:flex; justify-content:flex-end; gap:8px; }
  .abk-modal .fgrid { display:grid; grid-template-columns:repeat(6, 1fr); gap:12px 14px; }
  .abk-modal .f { display:flex; flex-direction:column; gap:6px; min-width:0; }
  .abk-modal .s2 { grid-column:span 2; } .abk-modal .s3 { grid-column:span 3; } .abk-modal .s6 { grid-column:span 6; }
  .abk-modal label { margin:0; font-size:12.5px; font-weight:600; color:#6B7280; }
  .abk-modal label i { font-style:normal; color:#D7182E; }
  .abk-modal .form-control { height:38px; border:1px solid #E6E8EC; border-radius:9px; box-shadow:none; font-size:14px; color:#1F2430; background-color:#fff; }
  .abk-modal .form-control:focus { border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .abk-modal .uppercase { text-transform:uppercase; }

  @media (max-width: 1100px) { .abk-grid { grid-template-columns:repeat(2, minmax(0, 1fr)); } .abk-grid .s3, .abk-grid .s4, .abk-grid .s6 { grid-column:span 2; } .abk-grid .s2 { grid-column:span 1; } }
  @media (max-width: 700px)  { .abk-modal .s2, .abk-modal .s3 { grid-column:span 6; } }
</style>
<script>
  //region CLIENT_BLOCK
  $('input[name=client_name]').keyup( () => {
    <c:if test="${booking.id != 0}">return;</c:if>
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
          openMsg(res);
          if(res.dublicate) {
            getDOM('close_client_info').click();
            $('#client_list_content').load('/clients/exists_list.s?amb_id=${booking.id}', () => {
              getDOM('btn_client_list').click();
            });
          } else {
            if (res.success) {
              if('${booking.state}' === 'ARCH') {
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
  $(".date-format").mask("99.99.9999",{placeholder:"dd.mm.yyyy"});
  $("#reg_time").mask("99:99",{placeholder:"HH:mm"});
  function saveBooking() {
    $.ajax({
      url: '/amb/booking.s',
      method: 'post',
      data: $('#booking_form').serialize(),
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if(res.success) setPage('/amb/booking.s?id=' + res.id);
      }
    });
  }
  function regBooking() {
    FmsConfirm('Вы действительно хотите зарегистрировать брон?', function () { $.ajax({
        url: '/amb/booking/reg.s',
        method: 'post',
        data: 'id=${booking.id}',
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success) setPage('/amb/reg.s?id=' + res.id);
        }
      }); });
  }
  function setServiceUser(ser, user) {
    $.ajax({
      url: '/amb/booking/service/user.s',
      method: 'post',
      data: 'ser=' + ser + '&user=' + user,
      dataType: 'json',
      success: function (res) {
        openMsg(res);
      }
    });
  }
  function delService(id) {
    FmsConfirm('Вы действительно хотите удалить выбранную запись?', function () { $.ajax({
        url: '/amb/booking/service/del.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success) setPage('/amb/booking.s?id=${booking.id}');
        }
      }); });
  }
</script>

<!-- ================= Модалка: реквизиты клиента ================= -->
<button class="hidden" id="btn_client_view" data-toggle="modal" data-target="#client_info"></button>
<div class="modal fade abk-modal" id="client_info" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title"><b class="fa fa-user"></b> Реквизиты клиента</h4>
      </div>
      <div class="modal-body">
        <form id="clientForm" name="clientForm">
          <input type="hidden" name="cl_id"/>
          <input type="hidden" name="amb_id" value="${booking.id}"/>
          <div class="fgrid">
            <div class="f s2">
              <label>Фамилия <i>*</i></label>
              <input name="cl_surname" title="Фамилия" placeholder="Фамилия" type="text" class="form-control" required maxlength="64" autocomplete="off"/>
            </div>
            <div class="f s2">
              <label>Исми <i>*</i></label>
              <input name="cl_name" title="Исми" placeholder="Исми" type="text" class="form-control" required  maxlength="64" autocomplete="off"/>
            </div>
            <div class="f s2">
              <label>Шарифи</label>
              <input name="cl_middlename" title="Шарифи" placeholder="Шарифи" class="form-control" maxlength="64" autocomplete="off"/>
            </div>
            <div class="f s3">
              <label>Дата рождения <i>*</i></label>
              <input name="cl_birthdate" type="text" class="form-control center date-format" placeholder="dd.mm.yyyy" maxlength="10"/>
            </div>
            <div class="f s3">
              <label>Пол <i>*</i></label>
              <select name="cl_sex_id" class="form-control">
                <c:forEach items="${sex}" var="sx">
                  <option value="${sx.id}">${sx.name}</option>
                </c:forEach>
              </select>
            </div>
            <div class="f s2">
              <label>Серия паспорта</label>
              <input name="cl_doc_seria" type="text" class="form-control text-center uppercase" maxlength="2" placeholder="XX"/>
            </div>
            <div class="f s2">
              <label>Номер паспорта</label>
              <input name="cl_doc_num" type="text" class="form-control text-center" maxlength="10" placeholder="XXXXXXX"/>
            </div>
            <div class="f s2">
              <label>Номер телефона</label>
              <input name="cl_tel" type="text" class="form-control" maxlength="400"/>
            </div>
            <div class="f s6">
              <label>Паспортные данные</label>
              <input name="cl_doc_info" type="text" class="form-control" maxlength="64"/>
            </div>
            <div class="f s3">
              <label>Резидентство <i>*</i></label>
              <select name="cl_country_id" class="form-control" onchange="$('select[name=cl_region_id]').toggle(this.value === '199').val()">
                <c:forEach items="${countries}" var="reg">
                  <option value="${reg.id}">${reg.name}</option>
                </c:forEach>
              </select>
            </div>
            <div class="f s3">
              <label>Область</label>
              <select name="cl_region_id" class="form-control">
                <option value=""></option>
                <c:forEach items="${regions}" var="reg">
                  <option value="${reg.id}">${reg.name}</option>
                </c:forEach>
              </select>
            </div>
            <div class="f s6">
              <label>Адрес</label>
              <input name="cl_address" type="text" class="form-control" maxlength="400"/>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="ab" id="close_client_info" data-dismiss="modal" aria-hidden="true">Закрыть</button>
        <button type="button" class="ab main" onclick="saveClient()"><i class="fa fa-floppy-o"></i> Сохранить</button>
      </div>
    </div>
  </div>
</div>

<!-- ================= Модалка: список похожих клиентов ================= -->
<button class="hidden" id="btn_client_list" data-toggle="modal" data-target="#client_list"></button>
<div class="modal fade abk-modal" id="client_list" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" id="client_list_close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title"><b class="fa fa-list"></b> Список клиентов</h4>
      </div>
      <div class="modal-body" id="client_list_content"></div>
    </div>
  </div>
</div>

<div class="abk">

  <!-- ================= Шапка и реквизиты брона ================= -->
  <div class="abk-card">
    <div class="abk-head">
      <span class="abk-ic"><i class="fa fa-calendar-check-o"></i></span>
      <div class="abk-who">
        <h2 title="${booking.id}" onclick="setPage('/amb/booking.s?id=${booking.id}')">
          <c:choose>
            <c:when test="${booking.id == 0}">Новый брон</c:when>
            <c:otherwise>Реквизиты брона</c:otherwise>
          </c:choose>
        </h2>
        <div class="meta">
          <c:if test="${booking.id > 0}">
            <span>№ ${booking.id}</span>
            <c:if test="${booking.regDate != null}">
              <span><i class="fa fa-clock-o"></i> <fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${booking.regDate}"/></span>
            </c:if>
          </c:if>
          <c:if test="${booking.id == 0}"><span>Найдите клиента или добавьте нового, затем укажите дату и время</span></c:if>
          <c:if test="${booking.state == 'ENT'}"><span class="abk-badge">Новый</span></c:if>
          <c:if test="${booking.state == 'ARCH'}"><span class="abk-badge arch">Архив</span></c:if>
        </div>
      </div>
      <div class="abk-btns">
        <c:if test="${booking.state == 'ENT' && fn:length(services) > 0}">
          <button type="button" class="ab dark" onclick="regBooking()"><i class="fa fa-user"></i> Регистрация</button>
        </c:if>
        <c:if test="${booking.state == 'ENT' || booking.id == 0}">
          <button type="button" class="ab main" onclick="saveBooking()"><i class="fa fa-floppy-o"></i> Сохранить</button>
        </c:if>
        <button type="button" class="ab back" onclick="setPage('/amb/bookings.s'); return false" title="Назад к списку"><i class="fa fa-arrow-left"></i> Назад</button>
      </div>
    </div>

    <div class="abk-body">
      <form id="booking_form" onsubmit="return false;">
        <input type="hidden" name="id" value="${booking.id}"/>

        <div class="abk-sec">Клиент</div>
        <div class="abk-grid">
          <div class="fg s6">
            <label>Ф.И.О. <i>*</i></label>
            <div class="abk-client">
              <div class="wrap">
                <i class="fa fa-search"></i>
                <input type="hidden" name="client_id" value="${booking.client.id}">
                <input type="text" class="form-control uppercase" name="client_name" autocomplete="off" placeholder="Начните вводить фамилию (от 4 букв)" value="<c:if test="${booking.id != 0}">${booking.fio}</c:if>" <c:if test="${booking.id != 0}">readonly</c:if>/>
                <div id="client_filter" style="display: none; position: absolute; background:white">
                  <table class="w-100 tablehover"><tbody></tbody></table>
                </div>
              </div>
              <div style="<c:if test="${booking.id == 0 || (booking.id > 0 && booking.state == 'ARCH' && booking.client == null)}">width:40px</c:if>" id="client_buttons"><c:if test="${booking.id == 0}">
                <button type="button" class="btn btn-success btn-icon" onclick="addClient()" title="Новый клиент">
                  <b class="fa fa-plus"></b>
                </button>
                <button type="button" class="btn btn-info btn-icon display-none" onclick="clientView()" title="Реквизиты клиента">
                  <b class="fa fa-user"></b>
                </button>
                <button type="button" class="btn btn-danger btn-icon display-none" title="Сбросить клиента">
                  <b class="fa fa-remove"></b>
                </button>
              </c:if><c:if test="${booking.id > 0 && booking.state == 'ARCH' && booking.client == null}">
                <button type="button" class="btn btn-success btn-icon" id="add_arch_client" onclick="addArchClient(${booking.id})" title="Сохранить клиента">
                  <b class="fa fa-save"></b>
                </button>
              </c:if></div>
            </div>
          </div>
          <div class="fg s2">
            <label>Дата рождения</label>
            <input type="text" name="birthday" class="form-control center" readonly value="<fmt:formatDate pattern="dd.MM.yyyy" value="${booking.birthday}"/>" placeholder="dd.mm.yyyy"/>
          </div>
          <div class="fg s2">
            <label>Пол</label>
            <input type="text" name="sex_id" class="form-control center" readonly value="${booking.sex.name}"/>
          </div>
          <div class="fg s2">
            <label>Паспортные данные</label>
            <input type="text" name="passport" class="form-control center" readonly value="${booking.passportInfo}"/>
          </div>
          <div class="fg s3">
            <label>Резидентство</label>
            <input type="text" name="country" class="form-control center" readonly value="${booking.country.name}"/>
          </div>
          <div class="fg s3">
            <label>Область</label>
            <input type="text" name="region" class="form-control center" readonly value="${booking.region.name}"/>
          </div>
        </div>

        <div class="abk-sec">Контакты</div>
        <div class="abk-grid">
          <div class="fg s2">
            <label>Телефон</label>
            <input name="tel" type="text" class="form-control" maxlength="400" value="${booking.tel}"/>
          </div>
          <div class="fg s4">
            <label>Адрес</label>
            <input name="address" type="text" class="form-control" maxlength="400" value="${booking.address}"/>
          </div>
        </div>

        <div class="abk-sec">Брон</div>
        <div class="abk-grid">
          <div class="fg s2">
            <label for="reg_date">Дата брона</label>
            <input name="reg_date" id="reg_date" type="text" class="form-control fms-cal" autocomplete="off" placeholder="дд.мм.гггг" value="<fmt:formatDate pattern="dd.MM.yyyy" value="${booking.regDate}"/>"/>
          </div>
          <div class="fg s1">
            <label for="reg_time">Время брона</label>
            <input name="reg_time" id="reg_time" placeholder="HH:mm" type="text" class="form-control center" autocomplete="off" value="<fmt:formatDate pattern="HH:mm" value="${booking.regDate}"/>"/>
          </div>
          <div class="fg s3">
            <label>Комментарий</label>
            <input name="text" type="text" class="form-control" maxlength="400" value="${booking.text}"/>
          </div>
        </div>
      </form>
    </div>
  </div>

  <!-- ================= Услуги ================= -->
  <c:if test="${booking.id > 0}">
    <div class="abk-card">
      <div class="sec-h">
        <h3>Услуги</h3>
        <span class="cnt">${fn:length(services)}</span>
        <span class="sp"></span>
        <c:if test="${booking.state == 'ENT'}">
          <button class="ab sm" type="button" onclick="setPage('/amb/booking/services.s?id=${booking.id}')"><i class="fa fa-plus"></i> Услуги</button>
        </c:if>
      </div>
      <div class="sec-wrap">
        <table class="st">
          <thead>
          <tr>
            <th style="width:44px">№</th>
            <th>Наименование</th>
            <th class="r" style="width:140px">Сумма</th>
            <th class="r" style="width:140px">С НДС</th>
            <th style="width:280px">Врач</th>
            <c:if test="${booking.state == 'ENT'}">
              <th class="c" style="width:50px"></th>
            </c:if>
          </tr>
          </thead>
          <tbody>
          <c:forEach items="${services}" var="ser" varStatus="loop">
            <tr id="ser${ser.id}">
              <td class="num">${loop.index + 1}</td>
              <td class="nm">${ser.service.name}</td>
              <td class="r">${ser.price}</td>
              <td class="r">${ser.nds}</td>
              <td>
                <c:if test="${booking.state == 'ENT'}">
                  <select name="user" class="form-control" onchange="setServiceUser(${ser.id}, this.value)">
                    <option></option>
                    <c:forEach items="${ser.users}" var="u">
                      <option <c:if test="${ser.worker.id == u.id}">selected</c:if> value="${u.id}">${u.fio}</option>
                    </c:forEach>
                  </select>
                </c:if>
                <c:if test="${booking.state != 'ENT' && ser.worker != null}">
                  ${ser.worker.fio}
                </c:if>
              </td>
              <c:if test="${booking.state == 'ENT'}">
                <td class="c">
                  <button type="button" class="ib" title="Удалить" onclick="delService(${ser.id})"><i class="fa fa-trash-o"></i></button>
                </td>
              </c:if>
            </tr>
          </c:forEach>
          <c:if test="${fn:length(services) == 0}">
            <tr class="empty"><td colspan="${booking.state == 'ENT' ? 6 : 5}"><i class="fa fa-stethoscope"></i>Услуги не добавлены<c:if test="${booking.state == 'ENT'}"> — нажмите «Услуги», чтобы выбрать</c:if></td></tr>
          </c:if>
          <c:if test="${serviceTotal > 0}">
            <tr class="total">
              <td>&nbsp;</td>
              <td>Итого к оплате</td>
              <td class="r">
                <fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value = "${serviceTotal}" type = "number"/>
              </td>
              <td class="r">
                <fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value = "${ndsTotal}" type = "number"/>
              </td>
              <td colspan="${booking.state == 'ENT' ? 2 : 1}">&nbsp;</td>
            </tr>
          </c:if>
          </tbody>
        </table>
      </div>
    </div>
  </c:if>

</div>
