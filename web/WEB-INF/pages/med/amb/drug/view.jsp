<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<div class="panel panel-info" style="width: 100%; margin: auto;">
  <div class="panel-heading">
    Лист назначения
  </div>
  <div class="panel-body">
    <table style="width:100%; font-size:13px" class="table table-bordered miniGrid">
      <thead>
      <tr>
        <th class="bold center">Наименование</th>
        <th class="bold center">Описание</th>
        <c:forEach items="${dates}" var="date">
          <th class="center">${date}</th>
        </c:forEach>
      </tr>
      </thead>
      <c:forEach items="${rows}" var="d" varStatus="lp">
        <tr id="patient-drug-${d.id}">
          <td style="vertical-align: middle">
            <c:forEach items="${d.rows}" var="row" varStatus="loop">
              ${row.name}  <c:if test="${loop.index + 1 < fn:length(d.rows)}"> + </c:if>
            </c:forEach>
          </td>
          <td style="vertical-align: middle; width:300px">${d.drugType.name}<c:if test="${d.drugType.id == 16}"> - ${d.injectionType.name}</c:if>; ${d.note}</td>
          <c:forEach var="i" begin="1" end="${fn:length(dates)}" step="1" varStatus="loop">
            <td style="vertical-align:middle; text-align:center">&nbsp;<c:forEach items="${d.dates}" var="date"><c:if test="${date.dateMonth == dates[i-1] && date.checked}"><b class="fa fa-plus"></b></c:if></c:forEach>&nbsp;</td>
          </c:forEach>
        </tr>
      </c:forEach>
    </table>
  </div>
</div>
