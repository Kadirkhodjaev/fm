<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Мониторинг → Аптека: основной склад за период и склады отделений за сегодня --%>
<%@include file="/WEB-INF/pages/med/mn/mn_style.jsp"%>
<style>
  .ds-grid { display:grid; grid-template-columns:repeat(4, minmax(0, 1fr)); gap:12px; padding:14px; }
  .ds-k { padding:14px 16px; border:1px solid #E6E8EC; border-radius:14px; background:#fff; }
  .ds-k .l { display:flex; align-items:center; gap:8px; font-size:12.5px; font-weight:600; color:#6B7280; }
  .ds-k .l i { width:26px; height:26px; border-radius:8px; display:flex; align-items:center; justify-content:center; background:#EEF1F6; color:#3C4A63; }
  .ds-k.in .l i { background:#E9F7EF; color:#1E7B43; }
  .ds-k.out .l i { background:#FDECEE; color:#A50F22; }
  .ds-k .v { margin-top:8px; font-size:22px; font-weight:700; font-variant-numeric:tabular-nums; }
  .ds-sec { padding:12px 16px 0; font-size:11px; font-weight:600; color:#9AA1AC; text-transform:uppercase; letter-spacing:.4px; }
  @media (max-width:1100px) { .ds-grid { grid-template-columns:repeat(2, minmax(0, 1fr)); } }
</style>
<div class="fm-page" style="height:auto; min-height:100%">
  <div class="fm-box" style="flex:none">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-plus-square"></i></span>
        <div><h2>Аптека</h2><span class="fm-count">суммы в сумах</span></div>
      </div>
      <div class="mn-flt">
        <input id="period_start" type="text" class="fm-in datepicker" value="${period_start}" autocomplete="off"/>
        <span class="dash">—</span>
        <input id="period_end" type="text" class="fm-in datepicker" value="${period_end}" autocomplete="off"/>
        <button type="button" class="fm-btn" onclick="mnPeriod('/mn/drugstore.s')"><i class="fa fa-search"></i>Показать</button>
      </div>
    </div>
    <div class="ds-sec">Основной склад аптеки · за период</div>
    <div class="ds-grid">
      <div class="ds-k"><div class="l"><i class="fa fa-flag-o"></i>Сальдо на начало</div><div class="v"><fmt:formatNumber value="${saldo_in}" type="number" maxFractionDigits="0"/></div></div>
      <div class="ds-k in"><div class="l"><i class="fa fa-download"></i>Приход</div><div class="v"><fmt:formatNumber value="${income_sum}" type="number" maxFractionDigits="0"/></div></div>
      <div class="ds-k out"><div class="l"><i class="fa fa-upload"></i>Расход</div><div class="v"><fmt:formatNumber value="${outcome_sum}" type="number" maxFractionDigits="0"/></div></div>
      <div class="ds-k"><div class="l"><i class="fa fa-flag-checkered"></i>Сальдо на конец</div><div class="v"><fmt:formatNumber value="${saldo_out}" type="number" maxFractionDigits="0"/></div></div>
    </div>
    <div class="ds-sec" style="border-top:1px solid #E6E8EC; padding-top:14px">Склады отделений · за сегодня</div>
    <div class="ds-grid">
      <div class="ds-k"><div class="l"><i class="fa fa-flag-o"></i>Сальдо на начало дня</div><div class="v"><fmt:formatNumber value="${hn_saldo_in}" type="number" maxFractionDigits="0"/></div></div>
      <div class="ds-k in"><div class="l"><i class="fa fa-download"></i>Приход сегодня</div><div class="v"><fmt:formatNumber value="${hn_day_in}" type="number" maxFractionDigits="0"/></div></div>
      <div class="ds-k out"><div class="l"><i class="fa fa-upload"></i>Расход сегодня</div><div class="v"><fmt:formatNumber value="${hn_day_out}" type="number" maxFractionDigits="0"/></div></div>
      <div class="ds-k"><div class="l"><i class="fa fa-flag-checkered"></i>Остаток сейчас</div><div class="v"><fmt:formatNumber value="${hn_saldo_out}" type="number" maxFractionDigits="0"/></div></div>
    </div>
  </div>
</div>
