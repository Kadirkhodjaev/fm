<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<script src="/res/js/common.js?v=2026101309" type="text/javascript"></script>
<style>
  .fz { --brand:#D7182E; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --ok:#15803D; --ok-bg:#E8F7EE; --bad:#B91C1C; --bad-bg:#FDECEE;
    padding:16px 20px 28px; color:var(--text); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .fz * { box-sizing:border-box; }
  .fz-head { display:flex; align-items:center; gap:12px; flex-wrap:wrap; margin-bottom:12px; }
  .fz-head h2 { margin:0; font-size:19px; font-weight:700; }
  .fz-badge { display:inline-block; padding:3px 11px; border-radius:10px; font-size:12.5px; font-weight:600; }
  .fz-badge.on { background:var(--ok-bg); color:var(--ok); }
  .fz-badge.off { background:var(--bad-bg); color:var(--bad); }
  .fz-head .act { margin-left:auto; }
  .fz-btn { display:inline-flex; align-items:center; gap:7px; height:36px; padding:0 14px; border-radius:9px; border:1px solid var(--border); background:#fff;
    color:var(--text); font-size:13.5px; font-weight:600; cursor:pointer; }
  .fz-btn.ok { background:var(--ok); border-color:var(--ok); color:#fff; }
  .fz-btn.ok:hover { background:#116B32; }
  .fz-btn.bad { color:var(--bad); border-color:#F6C4CA; background:var(--bad-bg); }
  .fz-btn.bad:hover { background:#FBDDE1; }
  .fz-card { background:#fff; border:1px solid var(--border); border-radius:14px; overflow:hidden; }
  .fz-scroll { overflow-x:auto; }
  .fz-table { border-collapse:collapse; width:100%; }
  .fz-table th { padding:8px 10px; font-size:11.5px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px; background:#F8F9FA;
    border-bottom:1px solid var(--border); white-space:nowrap; text-align:center; }
  .fz-table td { padding:9px 10px; border-bottom:1px solid #F0F1F4; font-size:14px; vertical-align:middle; }
  .fz-table tr:last-child td { border-bottom:0; }
  .fz-table tr:hover td { background:#FAFBFC; }
  .fz-table .n { width:36px; text-align:center; color:var(--muted); }
  .fz-table .name { min-width:220px; }
  .fz-table .name .t { font-weight:600; }
  .fz-table .name .s { font-size:12.5px; color:var(--muted); margin-top:2px; }
  .fz-table .d { width:50px; text-align:center; }
  .fz-table .d .mark { display:inline-flex; width:24px; height:24px; border-radius:50%; background:var(--ok-bg); color:var(--ok); align-items:center; justify-content:center; font-size:12px; }
  .fz-table .cnt { text-align:center; white-space:nowrap; font-weight:600; }
  .fz-table .cnt small { color:var(--muted); font-weight:500; }
  .fz-empty { padding:24px 18px; text-align:center; color:var(--muted); }
  .fz-legend { padding:10px 18px; border-top:1px solid var(--border); background:#FAFBFC; font-size:12.5px; color:var(--muted); }
  .fz-legend .mark { display:inline-flex; width:18px; height:18px; border-radius:50%; background:var(--ok-bg); color:var(--ok); align-items:center; justify-content:center; font-size:10px; margin-right:5px; vertical-align:middle; }
</style>
<script>
  function setFizio(){
    $.ajax({
      url:'/lv/fizio/set.s',
      dataType:'json',
      success:function (res) {
        showMsg(res.msg, true);
        setTimeout(function () { document.location = '/lv/fizio/index.s'; }, 700);
      }
    });
  }
</script>
<div class="fz">
  <%@include file="/incs/msgs/successError.jsp"%>
  <div class="fz-head">
    <h2>Физиотерапия</h2>
    <c:if test="${pat.state != 'ARCH'}">
      <c:if test="${pat.fizio && pat.paid != 'CLOSED'}">
        <span class="fz-badge on">Назначено</span>
        <c:if test="${fn:length(fizios) == 0}">
          <span class="act">
            <button class="fz-btn bad" onclick="setFizio()" type="button"><i class="fa fa-times"></i> Отменить</button>
          </span>
        </c:if>
      </c:if>
      <c:if test="${!pat.fizio && pat.paid != 'CLOSED'}">
        <span class="fz-badge off">Не назначено</span>
        <span class="act">
          <button class="fz-btn ok" onclick="setFizio()" type="button"><i class="fa fa-check"></i> Назначить</button>
        </span>
      </c:if>
    </c:if>
  </div>

  <div class="fz-card">
    <c:choose>
      <c:when test="${empty fizios}">
        <div class="fz-empty">Процедуры не назначены</div>
      </c:when>
      <c:otherwise>
        <div class="fz-scroll">
          <table class="fz-table">
            <tr>
              <th>№</th>
              <th style="text-align:left">Процедура</th>
              <c:forEach items="${dates}" var="d">
                <th class="d"><fmt:formatDate pattern="dd.MM" value="${d.date}"/></th>
              </c:forEach>
              <th>Дней</th>
            </tr>
            <c:forEach items="${fizios}" var="fizio" varStatus="loop">
              <c:set var="done" value="0"/>
              <c:forEach items="${ds[fizio.id]}" var="d">
                <c:if test="${d.state == 'Y'}"><c:set var="done" value="${done + 1}"/></c:if>
              </c:forEach>
              <tr id="fizio${fizio.id}">
                <td class="n">${loop.index + 1}</td>
                <td class="name">
                  <div class="t">${fizio.kdo.name}</div>
                  <c:if test="${not empty fizio.oblast or not empty fizio.comment}">
                    <div class="s">${fizio.oblast}<c:if test="${not empty fizio.oblast and not empty fizio.comment}"> · </c:if>${fizio.comment}</div>
                  </c:if>
                </td>
                <c:forEach items="${ds[fizio.id]}" var="d">
                  <td class="d"><c:if test="${d.state == 'Y'}"><span class="mark"><i class="fa fa-check"></i></span></c:if></td>
                </c:forEach>
                <td class="cnt">${done}</td>
              </tr>
            </c:forEach>
          </table>
        </div>
        <div class="fz-legend"><span class="mark"><i class="fa fa-check"></i></span> процедура на эту дату назначена</div>
      </c:otherwise>
    </c:choose>
  </div>
</div>
