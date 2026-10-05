<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/res/js/common.js" type="text/javascript"></script>
<script src="/res/js/fms-calendar.js" type="text/javascript"></script>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<style>
  .pl { --brand:#D7182E; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --ok:#15803D; --ok-bg:#E8F7EE; --wait:#B45309; --wait-bg:#FEF3C7;
    padding:16px 20px 28px; color:var(--text); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .pl * { box-sizing:border-box; }
  .pl-title { display:flex; align-items:baseline; gap:14px; flex-wrap:wrap; margin-bottom:12px; }
  .pl-title h2 { margin:0; font-size:19px; font-weight:700; }
  .pl-title .who { color:var(--muted); font-size:13.5px; }
  .pl-card { background:#fff; border:1px solid var(--border); border-radius:14px; overflow:hidden; }
  .pl-scroll { overflow-x:auto; }
  .pl-table { border-collapse:collapse; width:100%; }
  .pl-table th { padding:9px 12px; font-size:11.5px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px; background:#F8F9FA;
    border-bottom:1px solid var(--border); text-align:left; white-space:nowrap; }
  .pl-table th a { color:var(--brand); text-transform:none; letter-spacing:0; }
  .pl-table td { padding:9px 12px; border-bottom:1px solid #F0F1F4; font-size:14px; vertical-align:middle; }
  .pl-table tr:last-child td { border-bottom:0; }
  .pl-table tr:hover td { background:#FAFBFC; }
  .pl-table .n { width:36px; text-align:center; color:var(--muted); }
  .pl-table .chk { width:46px; text-align:center; }
  .pl-table .name a { cursor:pointer; font-weight:600; }
  .pl-table .date { white-space:nowrap; }
  .pl-table .date .form-control { display:inline; width:130px; height:34px; }
  .pl-table .form-control { height:34px; }
  .pl-table .act { width:46px; text-align:center; }
  .pl-table .act button { border:0; background:none; color:#B0B6BF; padding:4px 8px; border-radius:8px; cursor:pointer; }
  .pl-table .act button:hover { background:#FDECEE; color:var(--brand); }
  .pl-chip { display:inline-block; margin-left:8px; padding:1px 9px; border-radius:10px; font-size:11.5px; font-weight:600; background:var(--wait-bg); color:var(--wait); vertical-align:middle; }
  .pl-chip.done { background:var(--ok-bg); color:var(--ok); }
  .pl-empty { padding:24px 18px; text-align:center; color:var(--muted); }
</style>
<script type="text/javascript">
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
  function setConfUser(plan, user) {
    if(confirm('Вы действительно хотите изменить данные?'))
      $.ajax({
        url: '/lv/plan/change/confuser.s',
        method: 'post',
        data: 'plan=' + plan + '&user=' + user,
        dataType: 'json',
        success: function (res) {
          openMsg(res);
        }
      });
  }
</script>
<iframe src="about:blank" id="frmDiv" name="frm" style="display: none"></iframe>
<button data-toggle="modal" data-target="#myModal" style="display: none" id="modalBtn"></button>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" style="display: none;"></div>
<f:form method="post">
  <div class="pl">
    <div class="pl-title">
      <h2>План обследования</h2>
      <span class="who"><b>${fio}</b> &nbsp;·&nbsp; Год рождения: ${birthyear}</span>
    </div>
    <%@include file="/incs/msgs/successError.jsp"%>
    <div>
      <button class="hidden" id="planResult" type="button" onclick="setLocation('/lv/plan.s')" title="Результаты всех обследования"><i class="fa fa-flask"></i> Результаты</button>
      <button class="hidden" type="button" onclick="setLocation('/lv/plan/kdos.s')" title="Добавить новое обследование"><i class="fa fa-plus"></i> Добавить</button>
      <button class="hidden" id="saveBtn" type="submit"><i class="fa fa-check"></i> Сохранить</button>
    </div>

    <div class="pl-card">
      <c:if test="${empty plans}">
        <div class="pl-empty">Обследования не назначены</div>
      </c:if>
      <c:if test="${not empty plans}">
        <div class="pl-scroll">
          <table class="pl-table">
            <tr>
              <th>№</th>
              <th style="text-align:center"><a href="#" onclick="printPlans(); return false;" title="Напечатать отмеченные результаты"><i class="fa fa-print"></i> Печать</a></th>
              <th>Наименование</th>
              <th style="width:150px">Дата</th>
              <th>Примечание</th>
              <th>Врач</th>
              <th>Назначил</th>
              <th></th>
            </tr>
            <c:forEach items="${plans}" var="p" varStatus="loop">
              <tr>
                <td class="n">${loop.index + 1}</td>
                <td class="chk">
                  <c:if test="${p.c7 == 'Y'}">
                    <input type="checkbox" name="plans" value="${p.c1}" checked>
                  </c:if>
                </td>
                <td class="name">
                  <c:if test="${p.c7 == 'N' && p.c3 == '153'}">
                    <a onclick="bioCheck('${p.c1}')">${p.c4}</a>
                  </c:if>
                  <c:if test="${p.c7 == 'N' && p.c3 == '120'}">
                    <a onclick="garmonCheck('${p.c1}')">${p.c4}</a>
                  </c:if>
                  <c:if test="${p.c7 == 'N' && p.c3 == '56'}">
                    <a onclick="coulCheck('${p.c1}')">${p.c4}</a>
                  </c:if>
                  <c:if test="${p.c7 == 'N' && p.c3 == '121'}">
                    <a onclick="torchCheck('${p.c1}')">${p.c4}</a>
                  </c:if>
                  <c:if test="${p.c7 == 'Y'}">
                    <a onclick="printPlan('${p.c1}')" title="Распечатать результат">${p.c4}</a>
                  </c:if>
                  <c:if test="${p.c7 == 'N' && p.c3 != '153' && p.c3 != '120' && p.c3 != '121' && p.c3 != '56'}">
                    ${p.c4}
                  </c:if>
                  <c:if test="${p.c7 == 'Y'}"><span class="pl-chip done">Выполнено</span></c:if>
                  <c:if test="${p.c7 != 'Y'}"><span class="pl-chip">Ожидает</span></c:if>
                  <c:if test="${p.c7 == 'N' && ((sessionScope.ENV.roleId == 7 && p.c10 == sessionScope.ENV.userId) || sessionScope.ENV.roleId != 7)}">
                    <input type="hidden" name="ids" value="${p.c1}"/>
                  </c:if>
                </td>
                <td class="date">
                  <c:if test="${p.c7 == 'N' && ((sessionScope.ENV.roleId == 7 && p.c10 == sessionScope.ENV.userId) || sessionScope.ENV.roleId != 7)}">
                    <input value="${p.c5}" name="dates" class="form-control fms-cal" autocomplete="off" type="text" id="c${p.c1}" onchange="fillEmpties(this.value)" maxlength="10"/>
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
                <td nowrap>
                  <c:if test="${p.c15 == 'Y'}">
                    <select class="form-control" onchange="setConfUser(${p.c1}, this.value)">
                      <c:forEach items="${p.list}" var="u">
                        <option value="${u.id}" <c:if test="${u.id == p.c13}">selected</c:if>>${u.c1}</option>
                      </c:forEach>
                    </select>
                  </c:if>
                  <c:if test="${p.c15 != 'Y'}">
                    ${p.c12}
                  </c:if>
                </td>
                <td nowrap>${p.c9}</td>
                <td class="act">
                  <c:if test="${p.c7 == 'N' && ((sessionScope.ENV.roleId == 7 && p.c10 == sessionScope.ENV.userId) || sessionScope.ENV.roleId != 7)}">
                    <button type="button" onclick="delPlan('${p.c1}')" title="Удалить"><i class="fa fa-trash-o"></i></button>
                  </c:if>
                </td>
              </tr>
            </c:forEach>
          </table>
        </div>
      </c:if>
    </div>
  </div>
</f:form>
