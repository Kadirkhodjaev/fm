<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<jsp:useBean id="now" class="java.util.Date" />
<script>
  let order = '${order}';
  let direction = '${direction}';
  function setOrder(code, dir){
    order = code == null ? order : code;
    direction = dir == null ? direction : dir;
    setPage('/mn/drug_downtime.s?order=' + order + '&direction=' + direction);
  }
  function changeDowntime(id, date) {
    $.ajax({
      url: '/mn/downtime.s',
      method: 'post',
      data: 'id=' + id + '&date=' + date,
      dataType: 'json',
      success: function (res) {
        openMsg(res);
      }
    });
  }
</script>
<div class="panel panel-info" style="width: 100%; margin-top:10px">
  <div class="panel-heading">
    <table style="width:100%">
      <tr>
        <td>Простой медикаментов</td>
        <td>
          <select class="form-control" onchange="setOrder(null, this.value)">
            <option value="0">Все</option>
            <c:forEach items="${directions}" var="d">
              <option <c:if test="${direction == d.id}">selected</c:if> value="${d.id}">${d.name}</option>
            </c:forEach>
          </select>
        </td>
        <td style="text-align: right">
          <button onclick="setOrder('end', null)" class="btn btn-default btn-sm <c:if test="${order == 'end'}">btn-success</c:if>">Срок годности</button>
          <button onclick="setOrder('income', null)" class="btn btn-default btn-sm <c:if test="${order == 'income'}">btn-success</c:if>">Приход</button>
        </td>
      </tr>
    </table>
  </div>
  <div class="panel-body">
    <table class="table table-bordered">
      <tr>
        <th class="center">Склад</th>
        <th class="center">Медикамент</th>
        <th class="center">Дата прихода</th>
        <th class="center">Срок годности</th>
        <th class="center">Кол-во</th>
        <th class="center">Расход</th>
        <th class="center">Остаток</th>
      </tr>
      <c:forEach items="${rows}" var="p">
        <tr style="<c:if test="${p.dd < now}">color:red;font-weight:bold;</c:if>">
          <td>${p.c1}</td>
          <td>${p.c2}</td>
          <td style="text-align: center">${p.c3}</td>
          <td style="text-align: center; width:130px">
            <c:if test="${sessionScope.ENV.userId == 1}">
              <input name="period_start" id="period_start${p.id}" type="text" readonly onchange="changeDowntime(${p.id}, this.value)" class="form-control datepicker" value="${p.c7}"/>
            </c:if>
            <c:if test="${sessionScope.ENV.userId != 1}">
              ${p.c7}
            </c:if>
          </td>
          <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${p.c4}"/></td>
          <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${p.c5}"/></td>
          <td class="right"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${p.c6}"/></td>
        </tr>
      </c:forEach>
    </table>
  </div>
</div>
<iframe style="display: none" name="drug_excel"></iframe>
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/js/common.js"></script>
