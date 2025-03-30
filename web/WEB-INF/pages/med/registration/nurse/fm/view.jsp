<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/js/common.js" type="text/javascript"></script>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<script>
  function saveLv() {
    $.ajax({
      url: "/reg/lvConf.s",
      method: "post",
      data: ($('#lv').val() != '' && $('#lv').val() != undefined ? 'lv=' + $('#lv').val(): '') + '&zavlv=' + $('#zavlv').val(),
      dataType: 'json',
      success: function (data) {
        openMsg(data);
        if (data.success) {
          parent.openMainPage('/patients/list.s?curPat=Y');
        }
      }
    });
  }
  function setLvPartner(lvpartner) {
    $.ajax({
      url: "/reg/lvpartner.s",
      method: "post",
      data: 'id=${pat.id}&lvpartner=' + lvpartner,
      dataType: 'json',
      success: function (data) {
        openMsg(data);
      }
    });
  }
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
            $('#client_list_content').load('/clients/exists_list.s?stat_id=${pat.id}', () => {
              getDOM('btn_client_list').click();
            });
          } else {
            if (res.success) setLocation('reg.s');
          }
        }
      });
    }
  }
  function addArchClient(id) {
    $.ajax({
      url: '/patients/stat/get.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        if(res.success) {
          $('input[name=arch_cl_id]').val(res.id);
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
        if(res.success) {
          getDOM('client_list_close').click();
          $('input[name=cl_id]').val(res.id);
          $('input[name=cl_surname]').val(res.surname);
          $('input[name=cl_name]').val(res.name);
          $('input[name=cl_middlename]').val(res.middlename);
          $('input[name=cl_birthdate]').val(res.birthdate);
          $('select[name=cl_sex_id]').val(res.sex_id);
          $('input[name=cl_birthdate]').val(res.birthdate);
          $('input[name=cl_doc_seria]').val(res.doc_seria);
          $('input[name=cl_doc_num]').val(res.doc_num);
          $('input[name=cl_doc_info]').val(res.passport);
          $('input[name=cl_tel]').val(res.tel);
          $('select[name=cl_country_id]').val(res.country_id);
          $('select[name=cl_region_id]').val(res.region_id);
          $('input[name=cl_address]').val(res.address);
          $('#btn_client_view').click();
        } else {
          openMsg(res);
        }
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
          <input type="hidden" name="stat_id" value="${pat.id}"/>
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

<div style="display: none">
  <button onclick="saveLv()" id="saveBtn"></button>
</div>
<div class="panel panel-info" style="width: 700px !important; margin: auto">
  <table class="formTable">
    <tr>
      <td class="right bold" nowrap>ФИО:</td>
      <td colspan="2"> ${pat.surname} ${pat.name} ${pat.middlename}</td>
      <td class="text-center">
        <c:if test="${pat.id > 0 && pat.state == 'ARCH' && pat.client == null}">
          <button type="button" class="btn btn-success btn-icon" onclick="addArchClient(${pat.id})">
            <b class="fa fa-save"></b>
          </button>
        </c:if>
      </td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Тугилган сана:</td>
      <td><fmt:formatDate pattern = "dd.MM.yyyy" value = "${pat.birthday}" /></td>
      <td class="right bold" nowrap>Жинси:</td>
      <td>${pat.sex.name}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Буйи:</td>
      <td>${pat.rost}</td>
      <td class="right bold" nowrap>Огирлиги:</td>
      <td>${pat.ves}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Иш жойи:</td>
      <td>${pat.work}</td>
      <td class="right bold" nowrap>Мансаби:</td>
      <td>${pat.post}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Фукоролик:</td>
      <td>${country}</td>
      <td class="right bold" nowrap>Вилоят:</td>
      <td>${region}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Манзили:</td>
      <td>${pat.address}</td>
      <td class="right bold" nowrap>Паспорт маълумотлари:</td>
      <td>${pat.passportInfo}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Телефон раками:</td>
      <td>${pat.tel}</td>
      <td class="right bold" nowrap>Амб. картаси раками:</td>
      <td>${pat.ambNum}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Қон гуруҳи:</td>
      <td>${pat.bloodGroup.name}</td>
      <td class="right bold" nowrap>Резус мансублиги:</td>
      <td>${pat.resus}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Бемор қайердан юборилган:</td>
      <td>${pat.orientedBy}</td>
      <td class="right bold" nowrap>Транспортда:</td>
      <td>${pat.transport}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Олиб юриш турлари:</td>
      <td>${pat.vidPer.name}</td>
      <td class="right bold" nowrap>Харорати:</td>
      <td>${pat.temp}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Метка:</td>
      <td>${pat.metka.name}</td>
      <td class="right bold" nowrap>Руйхатга олинган вакт</td>
      <td>${pat.time}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Даволовчи шифокор:
      <td>
        <c:choose>
          <c:when test="${pat.state == 'CZG' && sessionScope.ENV.roleId == 6}">
            <select id="lv" class="form-control">
              <option value=""></option>
              <c:forEach items="${lvs}" var="f">
                <option <c:if test="${lv.id == f.id}">selected</c:if> value="${f.id}">${f.fio}</option>
              </c:forEach>
            </select>
          </c:when>
          <c:otherwise>${lv.fio}</c:otherwise>
        </c:choose>
      </td>
      <td class="right bold" nowrap>Тениаринхоз санаси:</td>
      <td>${pat.tarDate}</td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Булим бошлиги:
      <td colspan="3">
        <c:choose>
          <c:when test="${sessionScope.ENV.roleId == 6}">
            <select id="zavlv" class="form-control">
              <option value=""></option>
              <c:forEach items="${zavs}" var="f">
                <option <c:if test="${pat.zavlv.id == f.id}">selected</c:if> value="${f.id}">${f.fio}</option>
              </c:forEach>
            </select>
          </c:when>
          <c:otherwise>${pat.zavlv.fio}</c:otherwise>
        </c:choose>
      </td>
    </tr>
    <tr>
      <td class="right bold" nowrap>Булим:
      <td>${pat.dept.name}
      <td class="right bold" nowrap>№ Хона:</td>
      <td>${pat.room.name} - ${pat.room.roomType.name}</td>
    </tr>
    <tr>
      <td class="right bold">Дориларнинг ножуя тасири:</td>
      <td colspan="3">${pat.drugEffect}</td>
    </tr>
    <tr>
      <td class="right bold">Йулланмадаги ташхис:</td>
      <td colspan="3">${pat.diagnoz}</td>
    </tr>
    <c:if test="${sessionScope.ENV.userId == 1}">
      <tr>
        <td class="right bold" nowrap>Йуналтирган мутахасис коди:</td>
        <td colspan="3">
          <select name="lvpartner_id" class="form-control" onchange="setLvPartner(this.value)">
            <option value=""></option>
            <c:forEach items="${lvpartners}" var="lvp">
              <option <c:if test="${pat.lvpartner.id == lvp.id}">selected</c:if> value="${lvp.id}">${lvp.code}</option>
            </c:forEach>
          </select>
      </tr>
    </c:if>
  </table>
</div>
