<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<div class="panel panel-info">
  <div class="panel-heading">
    <table class="w-100">
      <tr>
        <td>Реквизиты сотрудника</td>
        <td class="wpx-300 text-right">
          <button class="btn btn-icon btn-default" onclick="setPage('/emp/doctor/emps.s')"><span class="fa fa-close"></span> Назад</button>
        </td>
      </tr>
    </table>
  </div>
  <div class="panel-body">
    <table class="table table-bordered">
      <tr>
        <td class="right bold">Клиент*:</td>
        <td colspan="4">
          <input type="text" class="form-control uppercase" name="client_name" placeholder="Ф.И.О." readonly value="${emp.client.fio}"/>
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
        <td colspan="3"><input name="address" readonly type="text" class="form-control" maxlength="400"/></td>
      </tr>
      <tr>
        <td class="text-right">Описание: </td>
        <td colspan="3">
          <input type="text" readonly name="text" maxlength="250" class="form-control" value="${emp.text}"/>
        </td>
      </tr>
    </table>
  </div>
</div>

<div class="panel panel-info">
  <div class="panel-heading">
    <table class="w-100">
      <tr>
        <td>Записи</td>
        <td class="wpx-100 text-right">
          <button class="btn btn-icon btn-info" onclick="regEmpAmb()"><span class="fa fa-check"></span> Регистрация</button>
        </td>
      </tr>
    </table>
  </div>
  <div class="panel-body">
    <table class="table table-bordered">
      <thead>
        <tr>
          <th class="text-center">#</th>
          <th class="text-center">Дата и время рег</th>
          <th class="text-center">Состояние</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach items="${rows}" var="a" varStatus="loop">
          <tr class="hover hand" ondblclick="setPage('amb/reg.s?id=${a.id}')">
            <td class="p-3 text-center">${loop.index + 1}</td>
            <td class="p-3 text-center"><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${a.crOn}"/></td>
            <td class="p-3 text-center">
              <c:if test="${a.state == 'PRN'}">Регистрация</c:if>
              <c:if test="${a.state == 'CASH'}">Ожидание оплаты</c:if>
              <c:if test="${a.state == 'WORK'}">Оказания услуг</c:if>
              <c:if test="${a.state == 'DONE'}">Услуги оказаны</c:if>
              <c:if test="${a.state == 'ARCH'}">Закрыта</c:if>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<script>
  function regEmpAmb() {
    if(confirm('Вы действительно хотите зарегистрировать данного сотрудника для обследовании?'))
      $.ajax({
        url: 'emp/doctor/emp/reg.s',
        method: 'post',
        data: 'id=${emp.id}',
        dataType: 'json',
        success: function (res) {
          openMsg(res);
          if(res.success)
            setPage('amb/reg.s?id=' + res.id);
        }
      });
  }
</script>
