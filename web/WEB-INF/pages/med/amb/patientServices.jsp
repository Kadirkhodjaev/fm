<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div style="background-color:#e8e8e8; padding:5px; margin-bottom:5px">
  Пациент: <b>${patient.surname} ${patient.name} ${patient.middlename}</b>
</div>
<table class="table table-striped table-bordered table-hover grid dataTable hand" style="width: 700px; margin: auto;">
  <thead>
  <tr>
    <th>&nbsp;</th>
    <th>Наименование</th>
    <th>Дата</th>
    <th>Подтверждение</th>
    <th>Врач</th>
  </tr>
  </thead>
  <tbody>
    <c:forEach items="${services}" var="p">
      <tr>
        <td class="center">
          <c:if test="${p.state == 'PAID' && p.worker.id == curUser}"><img src='/res/imgs/red.gif'/></c:if>
          <c:if test="${p.state == 'DONE' && p.worker.id == curUser}"><img src='/res/imgs/green.gif'/></c:if>
        </td>
        <td>
          <a href="#" onclick="setPage('/amb/work.s?id=${p.id}')">${p.service.name}</a>
        </td>
        <td align=center>
          <fmt:formatDate pattern = "dd.MM.yyyy" value = "${patient.regDate}" />
        </td>
        <td align=center>
          <fmt:formatDate pattern = "dd.MM.yyyy HH:mm" value = "${p.confDate}" />
        </td>
        <td class="center">
          ${p.worker.fio}
        </td>
      </tr>
    </c:forEach>
  </tbody>
</table>