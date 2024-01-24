<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/js/common.js"></script>
<script src="/res/datepicker/datetimepicker_css.js"></script>
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<script src="/res/js/jquery.maskedinput.js" type="text/javascript"></script>
<script>
  function saveClient() {
    if(checkForm($('#clientForm'))) {
      $.ajax({
        url: '/clients/save.s',
        method: 'post',
        data: $('#clientForm').serialize(),
        dataType: 'json',
        success: function (res) {
          openMsg(res);
        }
      });
    }
  }
  function delClient() {
    if(confirm('Вы действительно хотите удалить клиенты?'))
      $.ajax({
        url: '/clients/del.s',
        method: 'post',
        data: 'id=${client.id}',
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success) setPage('/clients/list.s');
        }
      });
  }
  function combineClient(old, cur) {
    if(confirm('Вы действительно хотите объединить клиенты?'))
      $.ajax({
        url: '/clients/combine.s',
        method: 'post',
        data: 'old=' + old + '&cur=' + cur,
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success) {
            $('#client_' + old).remove();
          }
        }
      });
  }
  $(function(){
    $("#birthdate").mask("99.99.9999",{placeholder:"dd.mm.yyyy"});
  })
</script>
<div class="panel panel-info  wpx-1000 margin-auto">
  <div class="panel-heading">
    <span class="fa fa-user"></span> Реквизиты клиента (ID: ${client.id})
    <ul class="pagination" style="float:right; margin-top:-5px">
      <li class="paginate_button" tabindex="0"><a href="#" onclick="saveClient()" title="Сохранить данные"><i class="fa fa-save"></i> Сохранить</a></li>
      <c:if test="${fn:length(ambs) == 0 && fn:length(stats) == 0}">
        <li class="paginate_button" tabindex="0"><a href="#" onclick="delClient()" title="Удалить запись"><i class="fa fa-remove"></i> Удалить</a></li>
      </c:if>
      <li class="paginate_button" tabindex="0"><a href="#" onclick="setPage('/clients/list.s')" title="Назад"><i class="fa fa-backward"></i> Назад</a></li>
    </ul>
  </div>
  <form id="clientForm" name="clientForm">
    <input type="hidden" value="${client.id}" name="cl_id"/>
    <table class="formTable w-100">
      <tr>
        <td class="right" nowrap>ФИО <req>*</req>:</td>
        <td colspan="3">
          <table class="w-100">
            <tr>
              <td>
                <input name="cl_surname" title="Фамилия" placeholder="Фамилия" type="text" class="form-control w-100" required="true" maxlength="64" autocomplete="off" value="${client.surname}"/>
              </td>
              <td>
                <input name="cl_name" title="Исми" placeholder="Исми" type="text" class="form-control w-100" required="true"  maxlength="64" autocomplete="off" value="${client.name}"/>
              </td>
              <td>
                <input name="cl_middlename" title="Шарифи" placeholder="Шарифи" class="form-control w-100" maxlength="64" autocomplete="off" value="${client.middlename}"/>
              </td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td class="right" nowrap>Дата рождения <req>*</req>:</td>
        <td>
          <input name="cl_birthdate" id="birthdate" type="text" class="form-control center" placeholder="dd.mm.yyyy" style="width:100px;" maxlength="10" value="<fmt:formatDate pattern="dd.MM.yyyy" value="${client.birthdate}" />"/>
        </td>
        <td class="right" nowrap><ui:message code="sex"/> <req>*</req>:</td>
        <td>
          <select name="cl_sex_id" class="form-control">
            <c:forEach items="${sex}" var="sx">
              <option <c:if test="${client.sex.id == sx.id}">selected</c:if> value="${sx.id}">${sx.name}</option>
            </c:forEach>
          </select>
        </td>
      </tr>
      <tr>
        <td class="right" nowrap>Серия паспорта:</td>
        <td><input name="cl_doc_seria" type="text" class="form-control text-center uppercase" maxlength="2" placeholder="XX" value="${client.docSeria}"/></td>
        <td class="right" nowrap>Номер паспорта:</td>
        <td><input name="cl_doc_num" type="text" class="form-control text-center" maxlength="10" placeholder="XXXXXXX" value="${client.docNum}"/></td>
      </tr>
      <tr>
        <td class="right" nowrap><ui:message code="passportInfo"/>:</td>
        <td><input name="cl_doc_info" type="text" class="form-control" maxlength="64" value="${client.docInfo}"/></td>
        <td class="right" nowrap><ui:message code="phone"/>:</td>
        <td><input name="cl_tel" type="text" class="form-control" maxlength="400" value="${client.tel}"/></td>
      </tr>
      <tr>
        <td class="right" nowrap>Резиденство:</td>
        <td>
          <select name="cl_country_id" class="form-control" onchange="$('#region_id').toggle(this.value === '199').val()">
            <c:forEach items="${counteries}" var="reg">
              <option <c:if test="${client.country.id == reg.id}">selected</c:if> value="${reg.id}">${reg.name}</option>
            </c:forEach>
          </select>
        </td>
        <td class="right" nowrap>Область:</td>
        <td>
          <select name="cl_region_id" id="region_id" class="form-control">
            <c:forEach items="${regions}" var="reg">
              <option <c:if test="${client.region.id == reg.id}">selected</c:if> value="${reg.id}">${reg.name}</option>
            </c:forEach>
          </select>
        </td>
      </tr>
      <tr>
        <td class="right" nowrap><ui:message code="address"/>:</td>
        <td colspan="3"><input name="cl_address" type="text" class="form-control" maxlength="400" value="${client.address}"/></td>
      </tr>
    </table>
  </form>
</div>
<c:if test="${fn:length(dublicates) > 0}">
  <div class="panel panel-info wpx-1000 margin-auto">
    <div class="panel-heading">
      <span class="fa fa-list"></span> Дубликаты по реквизитам
    </div>
    <table class="table table-bordered table-hover">
      <thead>
      <tr>
        <th class="text-center">#</th>
        <th class="text-center">ФИО</th>
        <th class="text-center wpx-150">Кол-во амб.</th>
        <th class="text-center wpx-150">Кол-во стац.</th>
        <th class="text-center wpx-100">Объединить</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach items="${dublicates}" var="d" varStatus="loop">
        <tr id="client_${d.id}">
          <td class="center wpx-100">${loop.index + 1}</td>
          <td>${d.fio}</td>
          <td class="text-center">${d.ambCount}</td>
          <td class="text-center">${d.statCount}</td>
          <td class="text-center">
            <button type="button" class="btn btn-info btn-icon" title="Объединить с текушим клиентом" onclick="combineClient(${d.id}, ${client.id})">
              <b class="fa fa-check"></b>
            </button>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
</c:if>
<c:if test="${fn:length(ambs) > 0}">
  <div class="panel panel-info margin-auto wpx-1000">
    <div class="panel-heading">
      <span class="fa fa-list"></span> Записи по клиету - Амбулатория
    </div>
    <table class="table table-bordered table-hover">
      <thead>
      <tr>
        <th class="text-center" style="width:30px">#</th>
        <th class="text-center">Дата рег</th>
        <th class="text-center">Состояние</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach items="${ambs}" var="rw" varStatus="loop">
        <tr ondblclick="setPage('/ambs/reg.s?id=${rw.id}')" class="hand hover">
          <td class="text-center">${loop.index + 1}</td>
          <td class="text-center">
            <fmt:formatDate pattern = "dd.MM.yyyy hh:MM" value = "${rw.crOn}" />
          </td>
          <td class="text-center">
            <c:if test="${rw.state == 'PRN'}">Регистрация</c:if>
            <c:if test="${rw.state == 'CASH'}">Ожидание оплаты</c:if>
            <c:if test="${rw.state == 'WORK'}">Оказания услуг</c:if>
            <c:if test="${rw.state == 'DONE'}">Услуги оказаны</c:if>
            <c:if test="${rw.state == 'ARCH'}">Закрыта</c:if>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
</c:if>
<c:if test="${fn:length(stats) > 0}">
  <div class="panel panel-info margin-auto wpx-1000">
    <div class="panel-heading">
      <span class="fa fa-list"></span> Записи по клиету - Стационар
    </div>
    <table class="table table-bordered table-hover">
      <thead>
      <tr>
        <th class="text-center" style="width:30px">#</th>
        <th class="text-center">Дата рег</th>
        <th class="text-center">Дата выписки</th>
        <th class="text-center">Состояние</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach items="${stats}" var="rw" varStatus="loop">
        <tr class="hand hover">
          <td class="text-center">${loop.index + 1}</td>
          <td class="text-center">
            <fmt:formatDate pattern = "dd.MM.yyyy" value = "${rw.dateBegin}" />
          </td>
          <td class="text-center">
            <fmt:formatDate pattern = "dd.MM.yyyy" value = "${rw.dateEnd}" />
          </td>
          <td class="text-center">
            <c:if test="${rw.state == 'PRN'}">Регистрация</c:if>
            <c:if test="${rw.state == 'PRD'}">Приемное отделение</c:if>
            <c:if test="${rw.state == 'LV'}">Текущий пациент</c:if>
            <c:if test="${rw.state == 'CZG'}">Отправлен на утверждения</c:if>
            <c:if test="${rw.state == 'ZGV'}">Подтвержден</c:if>
            <c:if test="${rw.state == 'ARCH'}">Закрыта</c:if>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
</c:if>
