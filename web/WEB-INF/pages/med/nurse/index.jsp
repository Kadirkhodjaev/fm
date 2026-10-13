<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../proc/nurse_style.jsp"%>
<style>
  .nw-wrap { overflow:auto; max-height:calc(100vh - 170px); border-top:1px solid var(--border); border-radius:0 0 16px 16px; }
  table.nw { width:100%; border-collapse:separate; border-spacing:0; font-size:14.5px; }
  table.nw th { position:sticky; top:0; z-index:2; height:40px; padding:0 10px; background:#F8F9FA; border-bottom:1px solid var(--border);
    color:var(--muted); font-size:12px; font-weight:600; text-transform:uppercase; letter-spacing:.3px; text-align:left; white-space:nowrap; }
  table.nw td { padding:10px; border-bottom:1px solid #F0F1F4; vertical-align:top; }
  table.nw tr:hover td { background:#F8F9FB; }
  table.nw td.num { color:#B0B5BD; text-align:center; width:44px; vertical-align:middle; }
  table.nw .fio { font-weight:700; font-size:15px; }
  table.nw .meta { display:block; margin-top:3px; font-size:12.5px; color:var(--muted); }
  table.nw .meta b { color:var(--text); font-weight:600; }
  table.nw .svc { white-space:nowrap; line-height:1.6; }
  .np-sel { height:44px; padding:0 12px; border:1px solid var(--border); border-radius:12px; background:#fff; font-size:15px; font-family:inherit; color:var(--text); min-width:220px; }
</style>
<div class="np">
  <div class="np-head">
    <div class="np-title">
      <span class="ic"><i class="fa fa-medkit"></i></span>
      <div>
        <h2>Услуги пациентов</h2>
        <span class="sub"><b>${fn:length(rows)}</b> пациентов на лечении</span>
      </div>
    </div>
    <span class="np-spacer"></span>
    <select id="dep_id" class="np-sel" onchange="setPostFilter()">
      <c:forEach items="${depts}" var="dp">
        <option <c:if test="${dp.id == dep}">selected</c:if> value="${dp.id}">${dp.name}</option>
      </c:forEach>
    </select>
  </div>

  <div class="np-card">
    <div class="nw-wrap">
      <table class="nw">
        <thead>
        <tr>
          <th style="text-align:center">№</th>
          <th>Пациент</th>
          <c:forEach items="${types}" var="key">
            <c:if test="${is1 && key.id == 1}"><th>Лаборатория</th></c:if>
            <c:if test="${is3 && key.id == 3}"><th>${key.name}</th></c:if>
            <c:if test="${is4 && key.id == 4}"><th>${key.name}</th></c:if>
            <c:if test="${is6 && key.id == 6}"><th>${key.name}</th></c:if>
            <c:if test="${is10 && key.id == 10}"><th>${key.name}</th></c:if>
            <c:if test="${is11 && key.id == 11}"><th>${key.name}</th></c:if>
            <c:if test="${is12 && key.id == 12}"><th>${key.name}</th></c:if>
            <c:if test="${is13 && key.id == 13}"><th>${key.name}</th></c:if>
            <c:if test="${is14 && key.id == 14}"><th>${key.name}</th></c:if>
            <c:if test="${is17 && key.id == 17}"><th>${key.name}</th></c:if>
            <c:if test="${is22 && key.id == 22}"><th>${key.name}</th></c:if>
          </c:forEach>
          <c:if test="${is15}"><th>Консультация</th></c:if>
          <c:if test="${is16}"><th>Физиотерапия</th></c:if>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${rows}" var="rw" varStatus="loop">
          <tr>
            <td class="num">${loop.index + 1}</td>
            <td>
              <span class="fio">${rw.c1}</span>
              <span class="meta"><b>ИБ №</b> ${rw.c4} · <b>палата</b> ${rw.c30} · ${rw.c2} г.р. · поступил ${rw.c3}</span>
            </td>
            <c:if test="${is1}"><td class="svc">${rw.c11}</td></c:if>
            <c:if test="${is3}"><td class="svc">${rw.c13}</td></c:if>
            <c:if test="${is4}"><td class="svc">${rw.c14}</td></c:if>
            <c:if test="${is6}"><td class="svc">${rw.c16}</td></c:if>
            <c:if test="${is10}"><td class="svc">${rw.c20}</td></c:if>
            <c:if test="${is11}"><td class="svc">${rw.c21}</td></c:if>
            <c:if test="${is12}"><td class="svc">${rw.c22}</td></c:if>
            <c:if test="${is13}"><td class="svc">${rw.c23}</td></c:if>
            <c:if test="${is14}"><td class="svc">${rw.c24}</td></c:if>
            <c:if test="${is17}"><td class="svc">${rw.c27}</td></c:if>
            <c:if test="${is22}"><td class="svc">${rw.c25}</td></c:if>
            <c:if test="${is15}"><td class="svc">${rw.c18}</td></c:if>
            <c:if test="${is16}"><td class="svc">${rw.c26}</td></c:if>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <c:if test="${empty rows}">
        <div class="np-empty"><i class="fa fa-medkit"></i>Нет пациентов с услугами</div>
      </c:if>
    </div>
  </div>
</div>
<script>
  function setPostFilter() {
    setPage('/nurses/work.s?dep=' + $('#dep_id').val());
  }
</script>
