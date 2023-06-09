<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script src="/res/js/common.js" type="text/javascript"></script>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
  initDates();
  function delPlan(id){
    if(confirm('Вы действительно хотите удалить?'))
      setLocation('?delPlan=Y&id='+id);
  }
  function printPlan(id){
    window.open('/kdo/print.s?id=' + id);
  }
  function bioCheck(id) {
    $('#myModal').load('/lv/plan/selBioFields.s?planId=' + id);
    $('#modalBtn').click();
  }
  function torchCheck(id) {
    $('#myModal').load('/lv/plan/setTorchFields.s?planId=' + id);
    $('#modalBtn').click();
  }
  function coulCheck(id) {
    $('#myModal').load('/lv/plan/setCoulFields.s?planId=' + id);
    $('#modalBtn').click();
  }
  function garmonCheck(id) {
    $('#myModal').load('/lv/plan/setGarmonFields.s?planId=' + id);
    $('#modalBtn').click();
  }
  function fillEmpties(date){
    var d = $("input[name=dates]");
    for(var i=0;i<d.length;i++){
      if(d[i].value == '')
        d[i].value = date;
    }
  }
  function printPlans() {
    var es = document.getElementsByName("plans"), params = '';
    for (var i=0;i<es.length;i++) {
      if (es[i].checked)
        params += 'id=' + es[i].value + '&';
    }
    if (es.length > 0)
      window.open('/kdo/printPlans.s?' + params);
  }
</script>
<iframe src="about:blank" id="frmDiv" name="frm" style="display: none"></iframe>
<button data-toggle="modal" data-target="#myModal" style="display: none" id="modalBtn"></button>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" style="display: none;"></div>
<f:form method="post">
  <div class="panel panel-info" style="width: 1100px !important; margin: auto">
    <%@include file="/incs/msgs/successError.jsp"%>
    <div class="panel-heading">
      План обследования
      <div style="float:right">
        <button class="hidden" id="planResult" type="button" onclick="setLocation('/lv/plan.s')" title="Результаты всех обследования" style="margin-top: -5px"><i class="fa fa-flask"></i> Результаты</button>
        <button class="hidden" type="button" onclick="setLocation('/lv/plan/kdos.s')" title="Добавить новое обследование" style="margin-top: -5px"><i class="fa fa-plus"></i> Добавить</button>
        <button class="hidden" id="saveBtn" type="submit"><i class="fa fa-check"></i> Сохранить</button>
      </div>
    </div>
    <table class="formTable" style="width:100%">
      <tr>
        <td colspan="3"><b>Пациент(ка):</b> ${fio}</td>
        <td nowrap colspan="2"><b>Год рождения:</b>${birthyear}</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td align="center" width="30"><b><a href="#" onclick="printPlans()">Печать</a></b></td>
        <td align="center" width="300"><b>Наименование</b></td>
        <td align="center" width="140"><b>Дата</b></td>
        <td align="center"><b>Примечание</b></td>
        <td align="center"><b>Назначил</b></td>
        <td align="center" width="30">&nbsp;</td>
      </tr>
      <c:forEach items="${plans}" var="p" varStatus="loop">
        <tr>
          <td align="center">${loop.index + 1}</td>
          <td align="center">
            <c:if test="${p.c7 == 'Y'}">
              <input type="checkbox" name="plans" value="${p.c1}" checked>
            </c:if>
          </td>
          <td width="300">
            <c:if test="${p.c7 == 'N' && p.c3 == '153'}">
              <a style="cursor: pointer" onclick="bioCheck('${p.c1}')">${p.c4}</a>
            </c:if>
            <c:if test="${p.c7 == 'N' && p.c3 == '120'}">
              <a style="cursor: pointer" onclick="garmonCheck('${p.c1}')">${p.c4}</a>
            </c:if>
            <c:if test="${p.c7 == 'N' && p.c3 == '56'}">
              <a style="cursor: pointer" onclick="coulCheck('${p.c1}')">${p.c4}</a>
            </c:if>
            <c:if test="${p.c7 == 'N' && p.c3 == '121'}">
              <a style="cursor: pointer" onclick="torchCheck('${p.c1}')">${p.c4}</a>
            </c:if>
            <c:if test="${p.c7 == 'Y'}">
              <a style="cursor: pointer" onclick="printPlan('${p.c1}')">${p.c4}</a>
            </c:if>
            <c:if test="${p.c7 == 'N' && p.c3 != '153' && p.c3 != '120' && p.c3 != '121' && p.c3 != '56'}">
              ${p.c4}
            </c:if>
            <c:if test="${p.c7 == 'N' && ((sessionScope.ENV.roleId == 7 && p.c10 == sessionScope.ENV.userId) || sessionScope.ENV.roleId != 7)}">
              <input type="hidden" name="ids" value="${p.c1}"/>
            </c:if>
          </td>
          <td align="center" nowrap>
            <c:if test="${p.c7 == 'N' && ((sessionScope.ENV.roleId == 7 && p.c10 == sessionScope.ENV.userId) || sessionScope.ENV.roleId != 7)}">
              <input value="${p.c5}" name="dates" class="form-control datepicker" style="display: inline; width:100px" type="text" id="c${p.c1}" onclick="getCalendar(this, 'ddMMyyyy', 'arrow');" onchange="fillEmpties(this.value)" maxlength="10"/>
            </c:if>
            <c:if test="${p.c7 == 'Y'}">
              ${p.c5}
            </c:if>
          </td>
          <td>
            <c:if test="${p.c7 == 'Y'}">
              ${p.c6}
            </c:if>
            <c:if test="${p.c7 == 'N' && p.c10 != sessionScope.ENV.userId}">
              <input type="hidden" name="comments" value="${p.c6}"/>
              ${p.c6}
            </c:if>
            <c:if test="${p.c7 == 'N' && p.c10 == sessionScope.ENV.userId}">
              <input type=text class="form-control" name="comments" value="${p.c6}"/>
            </c:if>
          </td>
          <td>
              ${p.c9}
          </td>
          <td align="center">
            <c:if test="${p.c7 == 'N' && ((sessionScope.ENV.roleId == 7 && p.c10 == sessionScope.ENV.userId) || sessionScope.ENV.roleId != 7)}">
              <button class="btn btn-danger btn-xs" type="button" onclick="delPlan('${p.c1}')"><i class="fa fa-minus"></i></button>
            </c:if>
          </td>
        </tr>
      </c:forEach>
    </table>
  </div>
</f:form>
