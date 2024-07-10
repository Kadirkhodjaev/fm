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
<div class="panel panel-info wpx-1400 margin-auto">
  <div class="panel-heading">
    <c:if test="${patient.id == null}">
      <span class="fa fa-pencil"></span> Регистрация нового пациента
    </c:if>
    <c:if test="${patient.id != null}">
      <span class="fa fa-user"></span> Реквизиты пациента
    </c:if>
    <ul class="pagination" style="float:right; margin-top:-5px">
      <c:if test="${isReg && patient.id != null && patient.treatment != 'Y'}">
        <li class="paginate_button" tabindex="0"><a href="#" id="btn-treatment"><i title="Амбулатовное лечение" class="fa fa-medkit"></i> Лечение</a></li>
      </c:if>
      <c:if test="${isReg && patient.fizio != 'Y' && (patient.id != null || patient.state == 'PRN' || patient.state == 'WORK' || patient.state == 'DONE')}">
        <li class="paginate_button" tabindex="0"><a href="#" id="btn-fizio"><i title="Физиотерапия" class="fa fa-check"></i> Физиотерапия</a></li>
      </c:if>
      <c:if test="${isReg && (patient.state == 'PRN' || patient.id == null)}">
        <li class="paginate_button" tabindex="0"><a href="#" id="btn-save"><i title="Сохранить" class="fa fa-save"></i> Сохранить</a></li>
      </c:if>
      <c:if test="${patient.id != null && fn:length(patient_services) == 0 && isReg}">
        <li class="paginate_button" tabindex="0"><a href="#" id="btn-del"><i title="Удалить запись" class="fa fa-remove"></i> Удалить</a></li>
      </c:if>
      <c:if test="${patient.id != null && patient.state == 'PRN' && isReg && fn:length(patient_services) > 0}">
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="patientConfirm(true)" id="btn-confirm"><i title="Подтвердить" class="fa fa-check"></i> Подтвердить</a></li>
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
          <td>
            <input type="text" class="form-control" name="tel"  value="${patient.tel}"/>
          </td>
          <td class="right" nowrap>Физиотерапия:</td>
          <td>
            <c:if test="${patient.fizio == 'Y'}">Да</c:if>
            <c:if test="${patient.fizio != 'Y'}">Нет</c:if>
          </td>
        </tr>
        <tr>
          <td class="right" nowrap>Код отправителя:</td>
          <td>
            <select class="form-control" name="lvpartner">
              <option></option>
              <c:forEach items="${lvpartners}" var="p">
                <option <c:if test="${patient.lvpartner.id == p.id}">selected</c:if> value="${p.id}">${p.code}</option>
              </c:forEach>
            </select>
          </td>
          <td class="right" nowrap>Амбулаторное лечение:</td>
          <td>
            <c:if test="${patient.treatment == 'Y'}">Да</c:if>
            <c:if test="${patient.treatment != 'Y'}">Нет</c:if>
          </td>
        </tr>
      </tbody>
    </table>
  </form>
</div>
<c:if test="${patient.id > 0}">
  <div id="patient_treatments"></div>
  <div id="patient_services"></div>
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
        <button class="btn btn-danger btn-sm" id="close_client_info" data-dismiss="modal" aria-hidden="true">
          <i class="fa fa-remove"></i> Закрыть
        </button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>

<script>
  let clients = [];
  // Patient_Block
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
  $('#btn-fizio').click(() => {
    if(confirm('Вы действительно хотите отправить на физиотерапию?'))
      $.ajax({
        url: '/ambs/fizio.s',
        method: 'post',
        data: '',
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success)
            setPage('/ambs/reg.s?id=${patient.id}');
        }
      });
  });
  $('#btn-treatment').click(() => {
    if(confirm('Вы действительно хотите назначить Амбулатовное лечение?'))
      $.ajax({
        url: '/ambs/treatment.s',
        method: 'post',
        data: '',
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success)
            setPage('/ambs/reg.s?id=${patient.id}');
        }
      });
  });
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
  //region Client Block
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
    $('#btn_client_view').click();
  }
  //endregion

  $(function(){
    $('#patient_services').load('/ambs/patient/services.s?id=${patient.id}');
    <c:if test="${patient.treatment == 'Y'}">
      $('#patient_treatments').load('/ambs/patient/treatments.s?id=${patient.id}');
    </c:if>
    $(".date-format").mask("99.99.9999",{placeholder:"dd.mm.yyyy"});
  });
</script>

