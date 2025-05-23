<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<div class="panel panel-info">
  <div class="panel-heading">
    <table class="w-100">
      <tr>
        <td>Сотрудники</td>
        <td class="wpx-100 text-right">
        </td>
      </tr>
    </table>
  </div>
  <div class="panel-body">
    <table class="table table-bordered">
      <thead>
        <tr>
          <th class="text-center">#</th>
          <th class="text-center">ФИО</th>
          <th class="text-center">Описание</th>
          <th class="text-center">Дата создания</th>
          <th class="text-center">Состояние</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach items="${rows}" var="a" varStatus="loop">
          <tr class="hand hover" ondblclick="setPage('emp/doctor/emp.s?id=${a.id}')">
            <td class="p-3 text-center">${loop.index + 1}</td>
            <td class="p-3">${a.client.fio}</td>
            <td class="p-3">${a.text}</td>
            <td class="p-3 text-center"><fmt:formatDate pattern="dd.MM.yyyy" value = "${a.crOn}" /></td>
            <td class="p-3 text-center">
              <c:if test="${a.state == 'A'}">Активный</c:if>
              <c:if test="${a.state == 'P'}">Пассивный</c:if>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>
