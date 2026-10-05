<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/res/js/common.js" type="text/javascript"></script>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<style>
  .pay { --brand:#D7182E; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    --ok:#15803D; --ok-bg:#E8F7EE; --bad:#B91C1C; --bad-bg:#FDECEE; --info:#1D4ED8; --info-bg:#EAF1FE;
    padding:16px 20px 28px; color:var(--text); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .pay * { box-sizing:border-box; }
  .pay-status { display:flex; align-items:center; gap:12px; padding:14px 18px; border-radius:14px; border:1px solid var(--border); margin-bottom:14px; }
  .pay-status .ico { width:40px; height:40px; border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:18px; flex:none; }
  .pay-status .t { font-size:16px; font-weight:700; line-height:1.25; }
  .pay-status .s { font-size:13px; color:var(--muted); margin-top:2px; }
  .pay-status.paid { background:var(--ok-bg); border-color:#BBE5CB; }
  .pay-status.paid .ico { background:#fff; color:var(--ok); }
  .pay-status.debt { background:var(--bad-bg); border-color:#F6C4CA; }
  .pay-status.debt .ico { background:#fff; color:var(--bad); }
  .pay-status.over { background:var(--info-bg); border-color:#C6D8FA; }
  .pay-status.over .ico { background:#fff; color:var(--info); }
  .pay-cards { display:grid; grid-template-columns:repeat(3, minmax(0, 1fr)); gap:12px; margin-bottom:14px; }
  .pay-card { background:#fff; border:1px solid var(--border); border-radius:14px; padding:14px 18px; }
  .pay-card .l { font-size:11.5px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px; }
  .pay-card .v { font-size:24px; font-weight:700; margin-top:4px; white-space:nowrap; }
  .pay-card .v small { font-size:13px; font-weight:600; color:var(--muted); margin-left:3px; }
  .pay-card.paid .v { color:var(--ok); }
  .pay-card.debt .v { color:var(--bad); }
  .pay-card.over .v { color:var(--info); }
  .pay-bar { height:8px; background:#EEF0F3; border-radius:8px; overflow:hidden; margin:0 0 4px; }
  .pay-bar span { display:block; height:100%; border-radius:8px; background:var(--ok); }
  .pay-bar-note { font-size:12px; color:var(--muted); margin-bottom:14px; }
  .pay-box { background:#fff; border:1px solid var(--border); border-radius:14px; overflow:hidden; }
  .pay-box h3 { margin:0; padding:12px 18px; font-size:14px; font-weight:700; border-bottom:1px solid var(--border); background:#FAFBFC; }
  .pay-table { width:100%; border-collapse:collapse; }
  .pay-table td { padding:10px 18px; border-bottom:1px solid #F0F1F4; font-size:14px; vertical-align:middle; }
  .pay-table tr:last-child td { border-bottom:0; }
  .pay-table tr:hover td { background:#FAFBFC; }
  .pay-table .ic { width:34px; color:#9AA1AC; text-align:center; padding-right:0; }
  .pay-table .sum { text-align:right; white-space:nowrap; font-weight:600; width:150px; }
  .pay-table tfoot td { background:#FAFBFC; font-weight:700; border-top:1px solid var(--border); }
  .pay-empty { padding:22px 18px; color:var(--muted); text-align:center; }
  @media (max-width:760px) { .pay-cards { grid-template-columns:1fr; } }
</style>
<div class="pay">
  <div class="pay-status ${status}">
    <div class="ico">
      <i class="fa <c:choose><c:when test="${status == 'paid'}">fa-check</c:when><c:when test="${status == 'debt'}">fa-exclamation</c:when><c:otherwise>fa-plus</c:otherwise></c:choose>"></i>
    </div>
    <div>
      <div class="t">
        <c:choose>
          <c:when test="${status == 'paid'}">Оплачено полностью</c:when>
          <c:when test="${status == 'debt'}">Есть задолженность: <fmt:formatNumber value="${debtAbs}" type="number"/> сум</c:when>
          <c:otherwise>Переплата: <fmt:formatNumber value="${debtAbs}" type="number"/> сум</c:otherwise>
        </c:choose>
      </div>
      <div class="s">Расчёт по койке, дополнительным местам и назначенным услугам</div>
    </div>
  </div>

  <div class="pay-cards">
    <div class="pay-card">
      <div class="l">Начислено</div>
      <div class="v"><fmt:formatNumber value="${total}" type="number"/><small>сум</small></div>
    </div>
    <div class="pay-card paid">
      <div class="l">Оплачено</div>
      <div class="v"><fmt:formatNumber value="${paid}" type="number"/><small>сум</small></div>
    </div>
    <div class="pay-card ${status}">
      <div class="l"><c:choose><c:when test="${status == 'over'}">Переплата</c:when><c:otherwise>К оплате</c:otherwise></c:choose></div>
      <div class="v"><fmt:formatNumber value="${status == 'over' ? debtAbs : (status == 'paid' ? 0 : debt)}" type="number"/><small>сум</small></div>
    </div>
  </div>
  <div class="pay-bar"><span style="width:${percent}%"></span></div>
  <div class="pay-bar-note">Оплачено ${percent}% от начисленного</div>

  <div class="pay-box">
    <h3>Начисления</h3>
    <c:choose>
      <c:when test="${empty services}">
        <div class="pay-empty">Начислений пока нет</div>
      </c:when>
      <c:otherwise>
        <table class="pay-table">
          <c:forEach items="${services}" var="ser">
            <tr>
              <td class="ic">
                <i class="fa fa-fw <c:choose><c:when test="${ser.c3 == 'bed'}">fa-home</c:when><c:when test="${ser.c3 == 'watcher'}">fa-users</c:when><c:otherwise>fa-flask</c:otherwise></c:choose>"></i>
              </td>
              <td>${ser.c1}</td>
              <td class="sum"><fmt:formatNumber value="${ser.c2}" type="number"/></td>
            </tr>
          </c:forEach>
          <tfoot>
            <tr>
              <td></td>
              <td>Итого</td>
              <td class="sum"><fmt:formatNumber value="${total}" type="number"/></td>
            </tr>
          </tfoot>
        </table>
      </c:otherwise>
    </c:choose>
  </div>
</div>
