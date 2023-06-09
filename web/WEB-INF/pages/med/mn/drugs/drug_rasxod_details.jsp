<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:if test="${code == 'drug'}">
  <div style="padding:10px; font-weight: bold; text-align: center">
      ${main.drug.name}
  </div>
  <table class="table table-striped table-bordered table-hover grid dataTable hand">
    <tr>
      <td class="center bold">Приход</td>
      <td class="center bold">Расход</td>
      <td class="center bold">Факт Расход</td>
      <td class="center bold">Разница</td>
    </tr>
    <tr>
      <td class="center">${main.drugCount}</td>
      <td class="center">${main.rasxod}</td>
      <td class="center">${main.price}</td>
      <td class="center">${main.rasxod - main.price}</td>
    </tr>
  </table>
  <div>Детализация по документам</div>
  <table class="table table-striped table-bordered table-hover grid dataTable hand">
    <tr>
      <td class="center bold">#</td>
      <td class="center bold">Документ</td>
      <td class="center bold">Расход</td>
    </tr>
    <c:set var = "rasxod" scope = "page" value = "${0}"/>
    <c:forEach items="${drugs}" var="drug" varStatus="loop">
      <c:set var = "rasxod" scope = "page" value = "${rasxod + drug.drugCount}"/>
      <tr>
        <td class="center">${loop.index + 1}</td>
        <td class="center">№${drug.income.act.regNum} от <fmt:formatDate pattern = "dd.MM.yyyy" value = "${drug.income.act.regDate}" /></td>
        <td class="center">${drug.drugCount}</td>
      </tr>
    </c:forEach>
    <tr>
      <td colspan="2" class="bold right">Итого</td>
      <td class="center bold"><c:out value="${rasxod}"/></td>
    </tr>
  </table>
</c:if>
<c:if test="${code == 'hn'}">
  <div style="padding:10px; font-weight: bold; text-align: center">
      ${main.drug.name} (Приход: №${main.outRow.doc.regNum} от <fmt:formatDate pattern = "dd.MM.yyyy" value = "${main.outRow.doc.regDate}" />)
  </div>
  <table class="table table-striped table-bordered table-hover grid dataTable hand">
    <tr>
      <td class="center bold">Приход</td>
      <td class="center bold">Расход</td>
      <td class="center bold">Факт Расход</td>
      <td class="center bold">Разница</td>
    </tr>
    <tr>
      <td class="center">${main.drugCount}</td>
      <td class="center">${main.rasxod}</td>
      <td class="center" id="fact_rasxod">${main.price}</td>
      <td class="center">${main.rasxod - main.price}</td>
    </tr>
  </table>
  <c:if test="${fn:length(dateRows) > 0}">
    <div>Расход</div>
    <table class="table table-striped table-bordered table-hover grid dataTable hand">
      <tr>
        <td class="center bold">#</td>
        <td class="center bold">ID</td>
        <td class="center bold">Документ</td>
        <td class="center bold">Расход</td>
        <td class="center bold">#</td>
      </tr>
      <c:set var = "rasxod" scope = "page" value = "${0}"/>
      <c:forEach items="${dateRows}" var="drug" varStatus="loop">
        <c:set var = "rasxod" scope = "page" value = "${rasxod + drug.rasxod}"/>
        <tr>
          <td class="center">${loop.index + 1}</td>
          <td class="center">${drug.id}</td>
          <td class="center"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${drug.doc.date}" /></td>
          <td class="center">${drug.rasxod}</td>
          <td class="center"><button class="btn btn-danger btn-sm" onclick="deleteRow('date', ${drug.id}, ${main.id})"><b class="fa fa-minus"></b></button></td>
        </tr>
      </c:forEach>
      <tr>
        <td colspan="3" class="bold right">Итого</td>
        <td class="center bold"><c:out value="${rasxod}"/></td>
      </tr>
    </table>
  </c:if>
  <c:if test="${fn:length(transfers) > 0}">
    <div>Перевод</div>
    <table class="table table-striped table-bordered table-hover grid dataTable hand">
      <tr>
        <td class="center bold">#</td>
        <td class="center bold">ID</td>
        <td class="center bold">Документ</td>
        <td class="center bold">Расход</td>
      </tr>
      <c:set var = "rasxod" scope = "page" value = "${0}"/>
      <c:forEach items="${transfers}" var="drug" varStatus="loop">
        <c:set var = "rasxod" scope = "page" value = "${rasxod + drug.drugCount}"/>
        <tr>
          <td class="center">${loop.index + 1}</td>
          <td class="center">${drug.id}</td>
          <td class="center">${drug.transfer}</td>
          <td class="center">${drug.drugCount}</td>
        </tr>
      </c:forEach>
      <tr>
        <td colspan="3" class="bold right">Итого</td>
        <td class="center bold"><c:out value="${rasxod}"/></td>
      </tr>
    </table>
  </c:if>
  <c:if test="${fn:length(datePatientRows) > 0}">
    <div>Стационар</div>
    <table class="table table-striped table-bordered table-hover grid dataTable hand">
      <tr>
        <td class="center bold">#</td>
        <td class="center bold">ID</td>
        <td class="center bold">Документ</td>
        <td class="center bold">Пациент</td>
        <td class="center bold">Расход</td>
        <td class="center bold">#</td>
      </tr>
      <c:set var = "rasxod" scope = "page" value = "${0}"/>
      <c:forEach items="${datePatientRows}" var="drug" varStatus="loop">
        <c:set var = "rasxod" scope = "page" value = "${rasxod + drug.rasxod}"/>
        <tr>
          <td class="center">${loop.index + 1}</td>
          <td class="center">${drug.id}</td>
          <td class="center"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${drug.doc.date}" /></td>
          <td>${drug.patient.surname} ${drug.patient.name} ${drug.patient.middlename}</td>
          <td class="center">${drug.rasxod}</td>
          <td class="center"><button class="btn btn-danger btn-sm" onclick="deleteRow('patient', ${drug.id}, ${main.id})"><b class="fa fa-minus"></b></button></td>
        </tr>
      </c:forEach>
      <tr>
        <td colspan="4" class="bold right">Итого</td>
        <td class="center bold"><c:out value="${rasxod}"/></td>
      </tr>
    </table>
    </c:if>
</c:if>
