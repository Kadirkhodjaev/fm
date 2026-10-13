<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Приходы препарата (окно «Детализация» на вкладке «Препараты») --%>
<table class="fm-grid">
  <thead>
  <tr>
    <th style="width:50px">№</th>
    <th>Поставщик</th>
    <th style="width:110px" class="nw">Дата</th>
    <th style="width:120px" class="r">Цена</th>
    <th style="width:100px" class="r">Кол-во</th>
  </tr>
  </thead>
  <tbody>
  <c:forEach items="${rows}" var="d" varStatus="row">
    <tr>
      <td class="mut">${row.index + 1}</td>
      <td><span class="nm">${d.act.contract.partner.name}</span></td>
      <td class="nw"><fmt:formatDate pattern="dd.MM.yyyy" value="${d.act.regDate}"/></td>
      <td class="r"><fmt:formatNumber value="${d.price}" type="number" maxFractionDigits="2"/></td>
      <td class="r">${d.blockCount}</td>
    </tr>
  </c:forEach>
  </tbody>
</table>
<c:if test="${empty rows}"><div class="fm-empty"><i class="fa fa-inbox"></i>Приходов нет</div></c:if>
