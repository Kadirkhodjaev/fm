<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="/res/js/jquery.mask.js"></script>
<div class="panel panel-info" style="width: 100%; margin: auto">
  <div class="panel-heading">
    <table class="w-100">
      <tr>
        <td>Заявки</td>
        <td>
          <select class="form-control" onchange="d(this.value)">
            <option <c:if test="${deep_ana == '0'}">selected</c:if> value="0">Все</option>
            <option <c:if test="${deep_ana == '1'}">selected</c:if> value="1">Заказать</option>
            <option <c:if test="${deep_ana == '2'}">selected</c:if> value="2">Остаток</option>
          </select>
        </td>
        <td>
          <input type="text" class="form-control wpx-100 text-center float-right" id="deep_ana" value="${deep_size}" onkeydown="setDeepSize(this.value)">
        </td>
      </tr>
    </table>
  </div>
  <div class="panel-body">
    <table class="table-grid">
      <tr>
        <th>#</th>
        <th>Наименование</th>
        <th>Расход за день</th>
        <th>Норма</th>
        <th>Сальдо в складах</th>
        <th>Сальдо в аптеке</th>
        <th>Разница</th>
      </tr>
      <c:forEach var="a" items="${rows}" varStatus="loop">
        <tr>
          <td class="wpx-40 text-center">${loop.index + 1}</td>
          <td>${a.c1}</td>
          <td class="text-right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${a.c2}"/></td>
          <td class="text-right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${a.c3}"/></td>
          <td class="text-right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${a.c4}"/></td>
          <td class="text-right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${a.c5}"/></td>
          <td class="text-right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${a.c6}"/></td>
        </tr>
      </c:forEach>
    </table>
  </div>
</div>
<script>
  $('#deep_ana').mask("00", {reverse: true});
  function d(val) {
    setPage("/drugs/out/drug/claim.s?deep_ana=" + val);
  }
  function setDeepSize(a) {
    if(event.keyCode == 13)
      setPage("/drugs/out/drug/claim.s?deep_size=" + a);
  }
</script>
