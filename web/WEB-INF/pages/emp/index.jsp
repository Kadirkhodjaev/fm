<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="panel panel-info">
  <div class="panel-heading">
    <table class="w-100">
      <tr>
        <td>Сотрудники</td>
        <td class="wpx-100 text-right">
          <button class="btn btn-icon btn-success" onclick="setPage('/emp/addEdit.s?id=0')">
            <span class="fa fa-plus"></span>
            Добавить
          </button>
        </td>
      </tr>
    </table>
  </div>
  <div class="panel-body">
    <table>
      <c:forEach items="${rows}" var="a">
        <a href="#" onclick="setPage('emp/addEdit.s?id=${a.id}')">${a.client.fio}</a>
      </c:forEach>
    </table>
  </div>
</div>
