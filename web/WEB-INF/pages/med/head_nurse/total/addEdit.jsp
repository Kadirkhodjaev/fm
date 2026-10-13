<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Склады → Общий расход: итог препаратов по пациенту за пребывание, подтверждение для бухгалтерии --%>
<%@include file="/WEB-INF/pages/med/head_nurse/hn_style.jsp"%>
<style>
  .tp-info { display:grid; grid-template-columns:repeat(4, 1fr); gap:12px; }
  .tp-info .v { font-size:14px; font-weight:600; color:#1F2430; margin-top:2px; }
  .tp-info .k { font-size:12px; color:#6B7280; }
</style>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-user"></i></span>
        <div>
          <h2 title="ID ${obj.id}">${obj.surname} ${obj.name} ${obj.middlename}</h2>
          <span class="fm-count">ИБ №<b>${obj.yearNum}</b> · общий расход препаратов</span>
        </div>
      </div>
      <c:choose>
        <c:when test="${parent == null}"><span class="hn-st ent">Не подтверждён</span></c:when>
        <c:when test="${parent.closed == 'N'}"><span class="hn-st snd">Подтверждён</span></c:when>
        <c:otherwise><span class="hn-st con">Закрыт бухгалтерией</span></c:otherwise>
      </c:choose>
      <span class="fm-spacer"></span>
      <c:if test="${parent != null && parent.closed == 'N'}">
        <button type="button" class="fm-btn" id="tpUpdBtn" onclick="updateDrugs()"><i class="fa fa-refresh"></i>Пересчитать</button>
      </c:if>
      <c:if test="${parent == null}">
        <button type="button" class="fm-btn primary" id="tpConfBtn" onclick="confirmPatient()"><i class="fa fa-check"></i>Подтвердить</button>
      </c:if>
      <button type="button" class="fm-btn" onclick="setPage('/head_nurse/total/patients.s')"><i class="fa fa-arrow-left"></i>Назад</button>
    </div>
    <div class="fm-table-wrap" style="background:#F5F6F8">
      <div class="hn-doc" style="padding:12px 0">
        <div class="hn-card">
          <div class="hn-card-b">
            <div class="tp-info">
              <div><div class="k">Год рождения</div><div class="v">${obj.birthyear}</div></div>
              <div><div class="k">Поступление</div><div class="v"><fmt:formatDate pattern="dd.MM.yyyy" value="${obj.dateBegin}"/></div></div>
              <div><div class="k">Выписка</div><div class="v"><c:choose><c:when test="${empty obj.dateEnd}">—</c:when><c:otherwise><fmt:formatDate pattern="dd.MM.yyyy" value="${obj.dateEnd}"/></c:otherwise></c:choose></div></div>
              <div><div class="k">Палата</div><div class="v">${empty obj.room.name ? '—' : obj.room.name}</div></div>
            </div>
          </div>
        </div>

        <div class="hn-card">
          <div class="hn-card-h"><h3 style="flex:1">Дни списания</h3><span class="fm-count">${fn:length(dates)}</span></div>
          <table class="fm-grid">
            <thead><tr><th style="width:50px">№</th><th>Склад</th><th style="width:120px">Дата</th><th style="width:140px">Состояние</th></tr></thead>
            <tbody>
            <c:forEach items="${dates}" var="d" varStatus="lp">
              <tr class="go" onclick="setPage('/head_nurse/out/patient/save.s?id=${d.c1}')" title="Открыть день списания">
                <td class="mut">${lp.index + 1}</td>
                <td>${d.c2}</td>
                <td class="nw">${d.c3}</td>
                <td><span class="hn-st ${d.c4 == 'ENT' ? 'ent' : 'con'}">${d.c4 == 'ENT' ? 'Черновик' : 'Подтверждено'}</span></td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
          <c:if test="${empty dates}"><div class="fm-empty" style="display:block"><i class="fa fa-calendar"></i>Дней списания нет</div></c:if>
        </div>

        <div class="hn-card">
          <div class="hn-card-h">
            <h3 style="flex:1">Препараты</h3>
            <span class="fm-count">${parent == null ? 'по подтверждённым дням' : 'переданы бухгалтерии'}</span>
          </div>
          <table class="fm-grid">
            <thead><tr><th style="width:50px">№</th><th>Препарат</th><th class="r" style="width:130px">Расход</th><th style="width:110px">Ед. изм.</th></tr></thead>
            <tbody>
            <c:forEach items="${rows}" var="d" varStatus="lp">
              <tr>
                <td class="mut">${lp.index + 1}</td>
                <td>${d.c1}</td>
                <td class="r"><b>${d.c2}</b></td>
                <td class="mut">${d.c3}</td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
          <c:if test="${empty rows}"><div class="fm-empty" style="display:block"><i class="fa fa-medkit"></i>Препаратов нет</div></c:if>
        </div>
      </div>
    </div>
  </div>
</div>
<script>
  function confirmPatient() {
    FmsConfirm('Подтвердить общий расход? Препараты по подтверждённым дням будут переданы бухгалтерии.', function () {
      $('#tpConfBtn').prop('disabled', true);
      $.ajax({
        url: '/head_nurse/total/patients/confirm.s', data: 'id=${obj.id}', method: 'post', dataType: 'json',
        success: function (res) {
          if (res.success) { FmsToast.show('Расход подтверждён', 'ok'); setPage('/head_nurse/total/patients/info.s?id=${obj.id}'); }
          else { FmsToast.show(res.msg, 'err'); $('#tpConfBtn').prop('disabled', false); }
        },
        error: function () { $('#tpConfBtn').prop('disabled', false); }
      });
    }, {ok: 'Подтвердить'});
  }
  function updateDrugs() {
    FmsConfirm('Пересчитать препараты для бухгалтерии по подтверждённым дням?', function () {
      $('#tpUpdBtn').prop('disabled', true);
      $.ajax({
        url: '/head_nurse/total/patients/update.s', data: 'id=${parent.id}', method: 'post', dataType: 'json',
        success: function (res) {
          if (res.success) { FmsToast.show('Препараты пересчитаны', 'ok'); setPage('/head_nurse/total/patients/info.s?id=${obj.id}'); }
          else FmsToast.show(res.msg, 'err');
        },
        complete: function () { $('#tpUpdBtn').prop('disabled', false); }
      });
    }, {ok: 'Пересчитать'});
  }
</script>
