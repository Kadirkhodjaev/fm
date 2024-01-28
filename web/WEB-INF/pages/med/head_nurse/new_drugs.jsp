<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div class="panel panel-info" style="width: 100%; margin: auto;">
  <div class="panel-heading">
    Лист назначения
  </div>
  <div class="panel-body">
    <table style="width:100%; font-size:13px" class="table table-bordered miniGrid">
      <thead>
      <tr>
        <th class="bold center">Пациент</th>
        <th class="bold center">Наименование</th>
        <th class="bold center">Описание</th>
        <th class="bold center">Дата и время</th>
      </tr>
      </thead>
      <c:forEach items="${list}" var="d" varStatus="lp">
        <tr id="patient-drug-${d.id}">
          <td style="vertical-align: middle">
            ${d.patient.surname} ${d.patient.name} ${d.patient.middlename} (ИБ №${d.patient.yearNum})
          </td>
          <td style="vertical-align: middle">
            <c:forEach items="${d.rows}" var="row" varStatus="loop">
              ${row.name}  <c:if test="${loop.index + 1 < fn:length(d.rows)}"> + </c:if>
            </c:forEach>
          </td>
          <td style="vertical-align: middle; width:300px">${d.note}</td>
          <td style="width:120px" class="center">
            <fmt:formatDate pattern = "dd.MM.yyyy HH:mm" value = "${d.crOn}"/>
          </td>
        </tr>
      </c:forEach>
    </table>
  </div>
</div>
