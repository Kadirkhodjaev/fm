<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<style>
  #user-drug-temps table tr td {padding:2px; font-size: 12px!important;}
  .miniGrid tr th {text-align: center; background: #e8e8e8}
  .miniGrid tbody tr:hover {background: #f5f5f5; cursor: pointer}
</style>

<table class="table table-bordered miniGrid" id="user-drug-temps" style="font-size:12px!important;">
  <tr>
    <th class="bold">Наименование</th>
    <th class="bold">Тип</th>
    <th class="bold">Цель</th>
    <th class="bold">Описание</th>
    <th class="bold" style="width:30px">Удалить</th>
  </tr>
  <c:forEach items="${rows}" var="d" varStatus="lp">
    <tr id="drug-row-temp-${d.id}" ondblclick="setLocation('drugs.s?temp=${d.id}')">
      <td style="vertical-align: middle">
        <c:forEach items="${d.rows}" var="row" varStatus="loop">
          ${row.name}  <c:if test="${loop.index + 1 < fn:length(d.rows)}"> + </c:if>
        </c:forEach>
      </td>
      <td style="vertical-align: middle; width:200px; text-align: center">
          ${d.drugType.name}<c:if test="${d.drugType.id == 8}"> - ${d.injectionType.name}</c:if>
      </td>
      <td style="vertical-align: middle">
          ${d.goal.name}
      </td>
      <td style="vertical-align: middle; width:200px">${d.note}</td>
      <td style="vertical-align: middle; width:20px" class="hand text-center">
        <button class="btn btn-sm btn-danger" title="Удалить шаблон" style="padding:1px 10px!important;" type="button" onclick="removeDrugTemp(${d.id})">
          <span class="fa fa-minus"></span>
        </button>
      </td>
    </tr>
  </c:forEach>
</table>
