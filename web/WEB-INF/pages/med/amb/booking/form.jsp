<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/js/jquery.maskedinput.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<script src="/res/js/common.js"></script>
<link href="/res/css/styles.css" rel="stylesheet">
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
    if(confirm('Вы действительно хотите зарегистрировать брон'))
      $.ajax({
        url: '/amb/booking/reg.s',
        method: 'post',
        data: 'id=${booking.id}',
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success) setPage('/amb/reg.s?id=' + res.id);
        }
      });
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
    if(confirm('Вы действительно хотите удалить выбрунную запись?'))
      $.ajax({
        url: '/amb/booking/service/del.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success) setPage('/amb/booking.s?id=${booking.id}');
        }
      });
  }
</script>
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
          <input type="hidden" name="amb_id" value="${booking.id}"/>
          <table class="formTable w-100">
            <tr>
              <td class="right" nowrap>ФИО <req>*</req>:</td>
              <td colspan="3">
                <table class="w-100">
                  <tr>
                    <td>
                      <input name="cl_surname" title="Фамилия" placeholder="Фамилия" type="text" class="form-control w-100" required maxlength="64" autocomplete="off"/>
                    </td>
                    <td>
                      <input name="cl_name" title="Исми" placeholder="Исми" type="text" class="form-control w-100" required  maxlength="64" autocomplete="off"/>
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
                  <c:forEach items="${countries}" var="reg">
                    <option value="${reg.id}">${reg.name}</option>
                  </c:forEach>
                </select>
              </td>
              <td class="right" nowrap>Область:</td>
              <td>
                <select name="cl_region_id" class="form-control">
                  <option value=""></option>
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
        <button class="btn btn-danger btn-sm" id="close_client_info" data-dismiss="modal" aria-hidden="true">
          <i class="fa fa-remove"></i> Закрыть
        </button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>

<button class="hidden" id="btn_client_list" data-toggle="modal" data-target="#client_list"></button>
<div class="modal fade" id="client_list" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog wpx-1000">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" id="client_list_close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title text-danger"><b class="fa fa-list"></b> Список клиентов</h4>
      </div>
      <div class="modal-body" id="client_list_content"></div>
    </div>
  </div>
</div>

<div class="panel panel-info w-100">
  <div class="panel-heading">
    <span title="${booking.id}" onclick="setPage('/amb/booking.s?id=${booking.id}')">Реквизиты брона</span>
    <ul class="pagination" style="float:right; margin-top:-5px">
      <c:if test="${booking.state == 'ENT' || booking.id == 0}">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="saveBooking()"><i title="Сохранить" class="fa fa-save"></i> Сохранить</a></li>
      </c:if>
      <c:if test="${booking.state == 'ENT' && fn:length(services) > 0}">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="regBooking()"><i title="Сохранить" class="fa fa-user"></i> Регистрация</a></li>
      </c:if>
      <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="setPage('/amb/bookings.s'); return false"><i title="Назад" class="fa fa-backward"></i> Назад</a></li>
    </ul>
  </div>
  <div class="panel-body">
    <form id="booking_form">
      <input type="hidden" name="id" value="${booking.id}"/>
      <table class="w-70 margin-auto formTable">
        <tr>
          <td class="right">Клиент <req>*</req>:</td>
          <td colspan="3">
            <table class="w-100">
              <tr>
                <td>
                  <input type="hidden" name="client_id" value="${booking.client.id}">
                  <input type="text" class="form-control uppercase" name="client_name" placeholder="Ф.И.О." value="<c:if test="${booking.id != 0}">${booking.fio}</c:if>" <c:if test="${booking.id != 0}">readonly</c:if>/>
                  <div id="client_filter" style="display: none; position: absolute; background:white">
                    <table class="w-100 table-bordered tablehover p-3"><tbody></tbody></table>
                  </div>
                </td>
                <td class="center" style="<c:if test="${booking.id == 0 || (booking.id > 0 && booking.state == 'ARCH' && booking.client == null)}">width:40px</c:if>" id="client_buttons">
                  <c:if test="${booking.id == 0}">
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
                  <c:if test="${booking.id > 0 && booking.state == 'ARCH' && booking.client == null}">
                    <button type="button" class="btn btn-success btn-icon" id="add_arch_client" onclick="addArchClient(${booking.id})">
                      <b class="fa fa-save"></b>
                    </button>
                  </c:if>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td class="right" nowrap>Дата рождения:</td>
          <td><input type="text" name="birthday" class="form-control center" readonly value="<fmt:formatDate pattern="dd.MM.yyyy" value="${booking.birthday}"/>" placeholder="dd.mm.yyyy"/></td>
          <td class="right" nowrap>Пол:</td>
          <td><input type="text" name="sex_id" class="form-control center" readonly value="${booking.sex.name}"/></td>
        </tr>
        <tr>
          <td class="right" nowrap>Телефон:</td>
          <td><input name="tel" type="text" class="form-control" maxlength="400" value="${booking.tel}"/></td>
          <td class="right" nowrap>Паспортные данные:</td>
          <td><input type="text" name="passport" class="form-control center" readonly value="${booking.passportInfo}"/></td>
        </tr>
        <tr>
          <td class="right" nowrap>Резиденство:</td>
          <td><input type="text" name="country" class="form-control center" readonly value="${booking.country.name}"/></td>
          <td class="right" nowrap>Область:</td>
          <td><input type="text" name="region" class="form-control center" readonly value="${booking.region.name}"/></td>
        </tr>
        <tr>
          <td class="right" nowrap>Адрес:</td>
          <td colspan="3"><input name="address" type="text" class="form-control" maxlength="400" value="${booking.address}"/></td>
        </tr>
        <tr>
          <td class="right" nowrap>Комментария:</td>
          <td colspan="3"><input name="text" type="text" class="form-control" maxlength="400" value="${booking.text}"/></td>
        </tr>
        <tr>
          <td class="right">Дата брона:</td>
          <td>
            <input name="reg_date" id="reg_date" type="text" class="form-control datepicker" value="<fmt:formatDate pattern="dd.MM.yyyy" value="${booking.regDate}"/>"/>
          </td>
          <td class="right">Время брона:</td>
          <td>
            <input name="reg_time" id="reg_time" placeholder="HH:mm" type="text" class="form-control center" value="<fmt:formatDate pattern="HH:mm" value="${booking.regDate}"/>"/>
          </td>
        </tr>
      </table>
    </form>
  </div>
</div>

<c:if test="${booking.id > 0}">
  <div class="panel panel-info">
    <div class="panel-heading">
      Услуги
      <div style="float:right">
        <c:if test="${booking.state == 'ENT'}">
          <button class="btn btn-sm btn-success" type="button" onclick="setPage('/amb/booking/services.s?id=${booking.id}')" style="margin-top: -5px"><i class="fa fa-plus"></i> Услуги</button>
        </c:if>
      </div>
    </div>
    <div>
      <table class="table table-bordered">
        <tr>
          <td class="center bold">№</td>
          <td class="center bold">Наименование</td>
          <td class="center bold">Сумма</td>
          <td class="center bold">С НДС</td>
          <td class="center bold">Врач</td>
          <c:if test="${booking.state == 'ENT'}">
            <td class="center bold" style="width: 30px">Уд.</td>
          </c:if>
        </tr>
        <c:forEach items="${services}" var="ser" varStatus="loop">
          <tr id="ser${ser.id}">
            <td class="center">${loop.index + 1}</td>
            <td>${ser.service.name}</td>
            <td class="right" style="padding-right:7px">${ser.price}</td>
            <td class="right" style="padding-right:7px">${ser.nds}</td>
            <td class="center">
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
              <td class="center">
                <button class="btn btn-danger btn-icon" title="Удалить" onclick="delService(${ser.id})"><span class="fa fa-minus"></span></button>
              </td>
            </c:if>
          </tr>
        </c:forEach>
        <c:if test="${serviceTotal > 0}">
          <tr style="font-weight: bold">
            <td class="center">&nbsp;</td>
            <td>ИТОГО к оплате</td>
            <td class="right" style="padding-right:7px">
              <fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value = "${serviceTotal}" type = "number"/>
            </td>
            <td class="right" style="padding-right:7px">
              <fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value = "${ndsTotal}" type = "number"/>
            </td>
            <td class="center" colspan="2">&nbsp;</td>
          </tr>
        </c:if>
      </table>
    </div>
  </div>
</c:if>
