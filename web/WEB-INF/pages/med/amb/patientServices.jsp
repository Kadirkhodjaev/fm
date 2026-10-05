<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  .kdo { font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:#1F2430; }
  .kdo-h { position:sticky; top:0; z-index:3; display:flex; align-items:center; gap:10px; padding:12px 16px; background:#fff; border-bottom:1px solid #E6E8EC; }
  .kdo-h .ico { width:30px; height:30px; border-radius:9px; background:#FDECEE; color:#D7182E; display:flex; align-items:center; justify-content:center; font-size:14px; }
  .kdo-h .lbl { font-size:12px; font-weight:600; color:#6B7280; }
  .kdo-h .name { font-size:15px; font-weight:700; }
  .kdo-h .sp { flex:1; }
  .kdo-h .cnt { font-size:12.5px; color:#6B7280; }
  .kdo-h .cnt b { color:#1F2430; }

  .kdo-t { width:100%; border-collapse:separate; border-spacing:0; font-size:14px; }
  .kdo-t th { position:sticky; top:55px; z-index:2; padding:9px 14px; background:#F8F9FA; border-bottom:1px solid #E6E8EC; color:#6B7280;
    font-size:12px; font-weight:600; text-transform:uppercase; letter-spacing:.3px; text-align:left; white-space:nowrap; }
  .kdo-t td { padding:10px 14px; border-bottom:1px solid #F0F1F4; vertical-align:middle; font-variant-numeric:tabular-nums; }
  .kdo-t tbody tr { cursor:pointer; }
  .kdo-t tbody tr:hover td { background:#FAFBFC; }
  .kdo-t tr.mine td:first-child { box-shadow:inset 3px 0 0 #D7182E; }
  .kdo-t tr.other td { color:#9AA1AC; }
  .kdo-t .sname { color:#1F2430; font-weight:600; text-decoration:none; }
  .kdo-t .sname:hover { color:#D7182E; text-decoration:none; }
  .kdo-t tr.other .sname { color:#6B7280; font-weight:500; }
  .kdo-t .muted { color:#6B7280; white-space:nowrap; }

  .kdo .st { display:inline-flex; align-items:center; gap:6px; padding:3px 10px; border-radius:999px; font-size:12px; font-weight:600; white-space:nowrap; }
  .kdo .st::before { content:''; width:7px; height:7px; border-radius:50%; background:currentColor; }
  .kdo .st-todo { background:#FDECEE; color:#D7182E; }
  .kdo .st-done { background:#E8F7EE; color:#15803D; }
  .kdo-empty { padding:30px; text-align:center; color:#9AA1AC; }
</style>

<c:set var="myTodo" value="0"/>
<c:forEach items="${services}" var="p">
  <c:if test="${p.state == 'PAID' && p.worker.id == curUser}"><c:set var="myTodo" value="${myTodo + 1}"/></c:if>
</c:forEach>

<div class="kdo">
  <div class="kdo-h">
    <span class="ico"><i class="fa fa-user"></i></span>
    <div>
      <div class="lbl">Пациент</div>
      <div class="name">${patient.surname} ${patient.name} ${patient.middlename}</div>
    </div>
    <span class="sp"></span>
    <span class="cnt">Услуг: <b>${fn:length(services)}</b><c:if test="${myTodo > 0}"> · ждут вас: <b style="color:#D7182E">${myTodo}</b></c:if></span>
  </div>

  <c:choose>
    <c:when test="${empty services}">
      <div class="kdo-empty">У пациента нет услуг</div>
    </c:when>
    <c:otherwise>
      <table class="kdo-t">
        <thead>
        <tr>
          <th style="width:140px">Статус</th>
          <th>Наименование</th>
          <th style="width:110px">Дата</th>
          <th style="width:150px">Подтверждение</th>
          <th style="width:200px">Врач</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${services}" var="p">
          <c:set var="isMine" value="${p.worker.id == curUser}"/>
          <tr class="${isMine ? 'mine' : 'other'}" onclick="setPage('/amb/work.s?id=${p.id}')">
            <td>
              <c:if test="${isMine && p.state == 'PAID'}"><span class="st st-todo">К выполнению</span></c:if>
              <c:if test="${isMine && p.state == 'DONE'}"><span class="st st-done">Выполнено</span></c:if>
            </td>
            <td><a href="#" class="sname" onclick="event.stopPropagation(); setPage('/amb/work.s?id=${p.id}'); return false;">${p.service.name}</a></td>
            <td class="muted"><fmt:formatDate pattern="dd.MM.yyyy" value="${patient.regDate}"/></td>
            <td class="muted"><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${p.confDate}"/></td>
            <td>${p.worker.fio}</td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </c:otherwise>
  </c:choose>
</div>
