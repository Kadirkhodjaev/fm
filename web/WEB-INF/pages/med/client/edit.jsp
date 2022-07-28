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
  function setCountery(dom) {
    $('#region_id').toggle(dom.value == '199').val();
  }
  function saveClient() {
    if(checkForm($('#clientForm'))) {
      $.ajax({
        url: '/client/save.s',
        method: 'post',
        data: $('#clientForm').serialize(),
        dataType: 'json',
        success: function (res) {
          if(res.success)
            alert('Данные успешно сохранены');
          else
            alert(res.msg);
        }
      });
    }
  }
  $(function(){
    $("#birthdate").mask("99.99.9999",{placeholder:"dd.mm.yyyy"});
  })
</script>
<div class="panel panel-info" style="width: 800px !important; margin: auto">
  <div class="panel-heading">
    Реквизиты клиента (ID: ${client.id})
    <button class="btn btn-success btn-xs" onclick="saveClient()" style="float:right">Сохранить</button>
  </div>
  <form id="clientForm" name="clientForm">
    <input type="hidden" value="${client.id}" name="id"/>
    <table class="formTable">
      <tr>
        <td class="right" nowrap>ФИО<d></d>:</td>
        <td colspan="3">
          <input name="surname" title="Фамилия" placeholder="Фамилия" style="width:167px; display:inline;margin-right:10px" type="text" class="form-control" required="true" maxlength="64" autocomplete="off" value="${client.surname}"/>
          <input name="name" title="Исми" placeholder="Исми" style="width:167px; display:inline;margin-right:10px" type="text" class="form-control" required="true"  maxlength="64" autocomplete="off" value="${client.name}"/>
          <input name="middlename" title="Шарифи" placeholder="Шарифи" style="width:167px; float: right" type="text" class="form-control" maxlength="64" autocomplete="off" value="${client.middlename}"/>
        </td>
      </tr>
      <tr>
        <td class="right" nowrap>Дата рождения:</td>
        <td>
          <input name="birthdate" id="birthdate" type="text" class="form-control center" placeholder="dd.mm.yyyy" style="width:100px;" maxlength="10" value=""/>
        </td>
        <td class="right" nowrap><ui:message code="sex"/>:</td>
        <td>
          <select name="sex_id" class="form-control">
            <c:forEach items="${sex}" var="sx">
              <option <c:if test="${client.sex.id == sx.id}">selected</c:if> value="${sx.id}">${sx.name}</option>
            </c:forEach>
          </select>
        </td>
      </tr>
      <tr>
        <td class="right" nowrap>Серия паспорта:</td>
        <td><input name="doc_seria" type="text" class="form-control text-center" maxlength="2" placeholder="XX" value="${client.docSeria}"/></td>
        <td class="right" nowrap>Номер паспорта:</td>
        <td><input name="doc_num" type="text" class="form-control text-center" maxlength="10" placeholder="XXXXXXX" value="${client.docNum}"/></td>
      </tr>
      <tr>
        <td class="right" nowrap><ui:message code="passportInfo"/>:</td>
        <td><input name="doc_info" type="text" class="form-control" maxlength="64" value="${client.docInfo}"/></td>
        <td class="right" nowrap><ui:message code="phone"/>:</td>
        <td><input name="tel" type="text" class="form-control" maxlength="400" value="${client.tel}"/></td>
      </tr>
      <tr>
        <td class="right" nowrap>Резиденство:</td>
        <td>
          <select name="country_id" class="form-control" onchange="setCountery(this)">
            <c:forEach items="${counteries}" var="reg">
              <option <c:if test="${client.country.id == reg.id}">selected</c:if> value="${reg.id}">${reg.name}</option>
            </c:forEach>
          </select>
        </td>
        <td class="right" nowrap>Область:</td>
        <td>
          <select name="region_id" id="region_id" class="form-control">
            <c:forEach items="${regions}" var="reg">
              <option <c:if test="${client.region.id == reg.id}">selected</c:if> value="${reg.id}">${reg.name}</option>
            </c:forEach>
          </select>
        </td>
      </tr>
      <tr>
        <td class="right" nowrap><ui:message code="address"/>:</td>
        <td colspan="3"><input name="address" type="text" class="form-control" maxlength="400" value="${client.address}"/></td>
      </tr>
    </table>
  </form>
</div>
<c:if test="${fn:length(cur_ambs) > 0}">
  <div class="panel panel-info" style="width: 800px !important; margin: auto">
    <div class="panel-heading">
      Записи по клиету (Текущие - Амбулатория)
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
      <c:forEach items="${cur_ambs}" var="rw" varStatus="loop">
        <tr ondblclick="setPage('/amb/reg.s?id=${rw.id}')" class="cursor-pointer hover">
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
<c:if test="${fn:length(arch_ambs) > 0}">
  <div class="panel panel-info" style="width: 800px !important; margin: auto">
    <div class="panel-heading">
      Записи по клиету (Архивные - Амбулатория)
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
      <c:forEach items="${arch_ambs}" var="rw" varStatus="loop">
        <tr ondblclick="setPage('/amb/reg.s?id=${rw.id}')" class="cursor-pointer hover">
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
