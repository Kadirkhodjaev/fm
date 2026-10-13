<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  .kp { --brand:#D7182E; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; padding:4px 2px 12px; color:var(--text);
    font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .kp * { box-sizing:border-box; }
  .kp-head { display:flex; align-items:center; gap:12px; flex-wrap:wrap; margin:0 0 10px; padding:0 4px; }
  .kp-head .lab { font-size:12px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px; }
  .kp-head .fio { font-size:17px; font-weight:700; }
  .kp-head .cnt { margin-left:auto; padding:2px 11px; border-radius:10px; background:#F1F2F4; color:#4B5563; font-size:12.5px; font-weight:600; }
  .kp-card { background:#fff; border:1px solid var(--border); border-radius:14px; overflow:hidden; }
  .kp-table { width:100%; border-collapse:collapse; }
  .kp-table th { padding:9px 14px; font-size:11.5px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px; text-align:left;
    background:#F8F9FA; border-bottom:1px solid var(--border); white-space:nowrap; }
  .kp-table td { padding:10px 14px; border-bottom:1px solid #F0F1F4; font-size:14px; vertical-align:middle; }
  .kp-table tr:last-child td { border-bottom:0; }
  .kp-table tbody tr { cursor:pointer; }
  .kp-table tbody tr:hover td { background:#FAFBFC; }
  .kp-table .n { width:44px; text-align:center; color:var(--muted); }
  .kp-table .st { width:44px; text-align:center; }
  .kp-table .nm a { color:var(--text); font-weight:600; text-decoration:none; }
  .kp-table .nm a:hover { color:var(--brand); }
  .kp-table .dt { width:130px; white-space:nowrap; }
  .kp-date { display:inline-block; padding:2px 10px; border-radius:8px; background:#F1F2F4; color:#374151; font-size:13px; font-variant-numeric:tabular-nums; }
  .kp-table .note { color:#3C4250; }
  .kp-dot { display:inline-block; width:12px; height:12px; border-radius:50%; background:#C3C7CE; box-shadow:0 0 0 3px #F1F2F4; vertical-align:middle; }
  .kp-dot.red { background:#E5484D; box-shadow:0 0 0 3px #FDECEE; }
  .kp-dot.yellow { background:#F5B800; box-shadow:0 0 0 3px #FEF6D6; }
  .kp-dot.green { background:#30A46C; box-shadow:0 0 0 3px #E3F6EC; }
  .kp-batch { display:inline-flex; align-items:center; gap:7px; height:32px; padding:0 13px; border:1px solid #1F2430; border-radius:9px; background:#1F2430;
    color:#fff; font-size:13px; font-weight:600; font-family:inherit; cursor:pointer; }
  .kp-batch:hover { background:#353B4A; }
  .kp-batch b { padding:0 7px; border-radius:8px; background:rgba(255,255,255,.18); font-weight:600; }
  .kp-empty { padding:26px 18px; text-align:center; color:var(--muted); }
</style>
<div class="kp">
  <div class="kp-head">
    <span class="lab">Пациент</span>
    <span class="fio">${p.surname} ${p.name} ${p.middlename}</span>
    <span class="cnt">Обследований: ${fn:length(plans)}</span>
    <c:set var="kpSingle" value="0"/>
    <c:forEach items="${plans}" var="x"><c:if test="${x.c2 != '999' && x.c2 != '889'}"><c:set var="kpSingle" value="${kpSingle + 1}"/></c:if></c:forEach>
    <c:if test="${kpSingle > 0}">
      <button type="button" class="kp-batch" onclick="setPage('/kdo/batch.s?id=${p.id}')" title="Ввести результаты всех анализов пациента на одной странице">
        <i class="fa fa-list-ol"></i> Пакетный ввод <b>${kpSingle}</b>
      </button>
    </c:if>
  </div>
  <div class="kp-card">
    <c:if test="${empty plans}">
      <div class="kp-empty">Назначенных обследований нет</div>
    </c:if>
    <c:if test="${not empty plans}">
      <table class="kp-table">
        <thead>
        <tr>
          <th style="text-align:center">№</th>
          <th style="text-align:center"></th>
          <th>Наименование</th>
          <th>Дата</th>
          <th>Примечание</th>
        </tr>
        </thead>
        <tbody>
          <c:forEach items="${plans}" var="p" varStatus="loop">
            <tr ondblclick="setPage('/kdo/f${p.c2}.s?id=${p.c1}')" title="Двойной клик — открыть бланк">
              <td class="n">${loop.index + 1}</td>
              <td class="st"><span class="kp-dot ${p.c6}"></span></td>
              <td class="nm"><a href="#" onclick="setPage('/kdo/kdo.s?id=${p.c1}&kdo=${p.c2}'); return false;">${p.c3}</a></td>
              <td class="dt"><span class="kp-date">${p.c4}</span></td>
              <td class="note">${p.c5}</td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:if>
  </div>
</div>
