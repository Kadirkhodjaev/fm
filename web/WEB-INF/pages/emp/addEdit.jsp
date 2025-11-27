<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
          <input type="hidden" name="emp_id" value="${emp.id}"/>
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
<div class="panel panel-info">
  <div class="panel-heading">
    <table class="w-100">
      <tr>
        <td>Реквизиты сотрудника</td>
        <td class="wpx-300 text-right">
          <button class="btn btn-icon btn-success" onclick="saveEmp()"><span class="fa fa-save"></span> Сохранить</button>
          <button class="btn btn-icon btn-danger" onclick="delEmp()"><span class="fa fa-remove"></span> Удалить</button>
          <button class="btn btn-icon btn-default" onclick="setPage('/emp/index.s')"><span class="fa fa-close"></span> Назад</button>
        </td>
      </tr>
    </table>
  </div>
  <div class="panel-body">
    <form id="addEditForm" name="addEditForm">
      <input type="hidden" name="id" value="${emp.id}" />
      <table class="table table-bordered">
        <tr>
          <td class="right bold">Клиент*:</td>
          <td colspan="4">
            <table class="w-100">
              <tr>
                <td>
                  <input type="hidden" name="client_id" value="${emp.client.id}">
                  <input type="text" class="form-control uppercase" name="client_name" placeholder="Ф.И.О." value="<c:if test="${emp.id != null}">${emp.client.fio}</c:if>" <c:if test="${emp.id != null}">readonly</c:if>/>
                  <div id="client_filter" style="display: none; position: absolute; background:white">
                    <table class="w-100 table-bordered tablehover p-3"><tbody></tbody></table>
                  </div>
                </td>
                <td class="center" style="<c:if test="${emp.id == null || (emp.id > 0)}">width:40px</c:if>" id="client_buttons">
                  <c:if test="${emp.id == null}">
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
          <td class="right" nowrap>
            Дата рождения:
          </td>
          <td><input type="text" name="birthday" class="form-control center" readonly value="<fmt:formatDate pattern="dd.MM.yyyy" value = "${emp.client.birthdate}" />"/></td>
          <td class="right" nowrap>Пол :</td>
          <td><input type="text" name="sex_id" class="form-control center" readonly value="${emp.client.sex.name}"/></td>
        </tr>
        <tr>
          <td class="right" nowrap>Телефон :</td>
          <td><input name="tel" type="text" class="form-control" maxlength="400" value="${emp.client.tel}"/></td>
          <td class="right" nowrap>Паспортные данные:</td>
          <td><input type="text" name="passport" class="form-control center" readonly value="${emp.client.docSeria} от ${emp.client.docNum} "/></td>
        </tr>
        <tr>
          <td class="right" nowrap>Резиденство:</td>
          <td><input type="text" name="country" class="form-control center" readonly value="${emp.client.country.name}"/></td>
          <td class="right" nowrap>Область:</td>
          <td><input type="text" name="region" class="form-control center" readonly value="${emp.client.region.name}"/></td>
        </tr>
        <tr>
          <td class="right" nowrap>Адрес:</td>
          <td colspan="3"><input name="address" type="text" class="form-control" maxlength="400"/></td>
        </tr>
        <tr>
          <td class="text-right">Описание: </td>
          <td colspan="3">
            <input type="text" name="text" maxlength="250" class="form-control" value="${emp.text}"/>
          </td>
        </tr>
        <tr>
          <td class="right">Активный?:</td>
          <td class="left">
            <input type="checkbox" <c:if test="${emp.state == 'A'}">checked</c:if> name="state" value="Y"/>
          </td>
        </tr>
        <tr>
          <td class="text-right">Прикрепленные врачи:</td>
          <td colspan="3" style="padding:10px">
            <c:forEach items="${emp_lvs}" var="a">
              <div style="border:1px solid #ababab; padding:5px;display: inline; margin-right:5px; border-radius: 3px">
                  ${a.doctor.fio}
                    <button type="button" class="btn btn-danger btn-icon" style="margin-top:-4px" onclick="delEmpDoctor(${a.id})"><span class="fa fa-close"></span></button>
              </div>
            </c:forEach>
          </td>
        </tr>
      </table>
    </form>
  </div>
</div>
<c:if test="${emp.id > 0}">
  <div class="panel panel-info">
    <div class="panel-heading">
      <table class="w-100">
        <tr>
          <td>Прикрепить ответветственного врача</td>
          <td class="wpx-200 text-right">
            <button class="btn btn-icon btn-success" onclick="saveDoctor()"><span class="fa fa-save"></span> Сохранить</button>
          </td>
        </tr>
      </table>
    </div>
    <div class="panel-body">
      <form id="addEditDoctor">
        <input type="hidden" name="id" value="${emp.id}" />
        <table class="table table-bordered">
          <tr>
            <td class="right bold">Врач*:</td>
            <td colspan="4">
              <select class="form-control" name="doctor">
                <c:forEach items="${lvs}" var="a">
                  <option value="${a.id}">${a.fio}</option>
                </c:forEach>
              </select>
            </td>
          </tr>
        </table>
      </form>
    </div>
  </div>
  <c:if test="${fn:length(rows) > 0}">
    <div class="panel panel-info">
      <div class="panel-heading">
        <table class="w-100">
          <tr>
            <td>Записи по сотруднику</td>
          </tr>
        </table>
      </div>
      <div class="panel-body">
        <table class="table-grid">
          <tr>
            <th>#</th>
            <th>Наименование</th>
            <th>Время записи</th>
            <th>Время подтверждение</th>
          </tr>
          <c:forEach items="${rows}" var="a">
            <tr ondblclick="showService(${a.patient}, ${a.id})">
              <td class="center wpx-40">
                <c:if test="${a.state != 'DONE'}"><img src='/res/imgs/red.gif'/></c:if>
                <c:if test="${a.state == 'DONE'}"><img src='/res/imgs/green.gif'/></c:if>
              </td>
              <td>${a.service.name}</td>
              <td class="text-center"><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${a.crOn}"/></td>
              <td class="text-center"><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${a.confDate}"/></td>
            </tr>
          </c:forEach>
        </table>
      </div>
    </div>
  </c:if>
</c:if>
<script src="/res/js/jquery.maskedinput.js" type="text/javascript"></script>
<script>
  function showService(patient, id) {
    window.open('/amb/print.s?patient=' + patient + '&ids=' + id);
  }
  function delEmp() {
    if(confirm('Вы действительно хотите удалить данного сотрудника?'))
      $.ajax({
        url: 'emp/del.s',
        method: 'post',
        data: 'id=${emp.id}',
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success)
            setPage('emp/index.s');
        }
      });
  }
  function delEmpDoctor(id) {
    if(confirm('Вы действительно хотите удалить выбранную запись?'))
      $.ajax({
        url: 'emp/doctor/del.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success)
            setPage('emp/addEdit.s?id=${emp.id}');
        }
      });
  }
  function saveDoctor() {
    $.ajax({
      url: 'emp/doctor/save.s',
      method: 'post',
      data: $('#addEditDoctor').serialize(),
      dataType: 'json',
      success: function (res) {
        openMsg(res);
        if(res.success)
          setPage('emp/addEdit.s?id=${emp.id}');
      }
    });
  }
  function saveEmp() {
    $.ajax({
      url: 'emp/addEdit.s',
      method: 'post',
      data: $('#addEditForm').serialize(),
      dataType: 'json',
      success: function (res) {
        openMsg(res);
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
</script>
