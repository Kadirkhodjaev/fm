<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Постовая → палата → назначения пациента на дату и время: инъекции (отметка «Сделано», расходники), таблетки (сколько выдано).
     Грузится в #home страницы палаты (proc/palata.jsp) --%>
<style>
  .pd-sec { margin:4px 0 14px; }
  .pd-h { display:flex; align-items:center; gap:10px; margin:0 0 8px; font-size:12px; font-weight:700; color:#6B7280; text-transform:uppercase; letter-spacing:.4px; }
  .pd-h .sp { flex:1; }
  .pd-h .day { text-transform:none; letter-spacing:0; font-weight:600; color:#1F2430; }
  .pd-row { display:flex; align-items:center; gap:12px; padding:10px 12px; border:1px solid #E6E8EC; border-radius:12px; margin-bottom:8px; background:#fff; }
  .pd-row.done { background:#F3FBF6; border-color:#CDEBD8; }
  .pd-n { flex:none; width:26px; height:26px; border-radius:8px; background:#F1F2F4; color:#6B7280; font-size:12.5px; font-weight:700; display:flex; align-items:center; justify-content:center; }
  .pd-name { flex:1; min-width:0; font-size:15px; font-weight:600; color:#1F2430; line-height:1.35; }
  .pd-name .own { display:inline-block; margin-left:4px; padding:0 7px; border-radius:6px; background:#FEF6D6; color:#8A6100; font-size:11.5px; font-weight:700; }
  .pd-name .note { display:block; font-size:13px; font-weight:400; color:#6B7280; }
  .pd-done { flex:none; display:inline-flex; align-items:center; gap:8px; height:44px; padding:0 18px; border:0; border-radius:11px; background:#2E9E62; color:#fff;
    font-size:15px; font-weight:700; font-family:inherit; cursor:pointer; }
  .pd-done:active { transform:scale(.97); }
  .pd-who { flex:none; text-align:right; font-size:12.5px; color:#1E7A4C; }
  .pd-who b { display:block; font-size:14px; }
  .pd-step { flex:none; display:inline-flex; align-items:center; border:1px solid #E6E8EC; border-radius:11px; overflow:hidden; }
  .pd-step button { width:44px; height:42px; border:0; background:#F5F6F8; color:#1F2430; font-size:20px; font-weight:700; cursor:pointer; }
  .pd-step button:active { background:#E6E8EC; }
  .pd-step input { width:52px; height:42px; border:0; text-align:center; font-size:16px; font-weight:700; font-family:inherit; background:#fff; }
  .pd-cons { display:grid; grid-template-columns:repeat(auto-fill, minmax(230px, 1fr)); gap:8px; }
  .pd-cons .pd-row { margin:0; }
  .pd-empty { padding:24px; text-align:center; color:#9AA1AC; font-size:14px; }
</style>
<script>
  function setIterator(type, pm) {
    var cur = Number($('#' + type).val());
    if (cur === 0 && pm < 0) return;
    $('#' + type).val(cur + pm);
    $.ajax({
      url: '/proc/patient/drug/exp.s', method: 'post', dataType: 'json',
      data: 'patient=${pat.id}&time=${time}&oper_day=${oper_day}&code=' + type + '&val=' + (cur + pm),
      success: function (res) { if (!res.success) FmsToast.show(res.msg || 'Не удалось сохранить', 'err'); }
    });
  }
  function setDrugState(id) {
    $.ajax({
      url: '/proc/patient/drug/done.s', method: 'post', dataType: 'json', data: 'id=' + id + '&time=${time}',
      success: function (res) {
        if (!res.success) { FmsToast.show(res.msg || 'Не удалось отметить', 'err'); return; }
        FmsToast.show('Отмечено', 'ok');
        $('#home').load('/proc/patient/drugs.s?id=${pat.id}&oper_day=' + $('#oper_day').val() + '&time=${time}');
      }
    });
  }
</script>

<div class="pd-sec">
  <div class="pd-h"><i class="fa fa-eyedropper"></i> Инъекции <span class="sp"></span><span class="day">${oper_day}</span></div>
  <c:if test="${empty ines}"><div class="pd-empty">Инъекций на это время нет</div></c:if>
  <c:forEach items="${ines}" var="drug" varStatus="loop">
    <div class="pd-row ${drug.timeDone ? 'done' : ''}">
      <span class="pd-n">${loop.index + 1}</span>
      <div class="pd-name">
        <c:forEach items="${drug.rows}" var="row" varStatus="rl">${row.name}<c:if test="${row.source == 'own'}"><span class="own" title="Препарат пациента">свой</span></c:if><c:if test="${rl.index + 1 < fn:length(drug.rows)}"> + </c:if></c:forEach>
        <span class="note">${drug.note}<c:if test="${drug.injectionType != null}"> · ${drug.injectionType.name}</c:if></span>
      </div>
      <c:if test="${!drug.timeDone}">
        <button type="button" class="pd-done" onclick="setDrugState(${drug.dateId})"><i class="fa fa-check"></i> Сделано</button>
      </c:if>
      <c:if test="${drug.timeDone}">
        <div class="pd-who"><b><i class="fa fa-check"></i> <fmt:formatDate pattern="HH:mm" value="${drug.timeDoneOn}"/></b>${drug.timeDoneBy}</div>
      </c:if>
    </div>
  </c:forEach>
</div>

<c:if test="${not empty ines}">
  <div class="pd-sec">
    <div class="pd-h"><i class="fa fa-medkit"></i> Расходные материалы</div>
    <div class="pd-cons">
      <c:forEach items="${fn:split('spirt:Спирт 70%:0.5,vata:Вата:0.5,spric:Шприц:1,sistema:Система:1,perchatka:Перчатка:1', ',')}" var="it">
        <c:set var="ip" value="${fn:split(it, ':')}"/>
        <div class="pd-row">
          <div class="pd-name">${ip[1]}</div>
          <div class="pd-step">
            <button type="button" onclick="setIterator('${ip[0]}', -${ip[2]})">−</button>
            <input type="text" readonly id="${ip[0]}" value="${exps.get(ip[0]) == null ? 0 : exps.get(ip[0])}"/>
            <button type="button" onclick="setIterator('${ip[0]}', ${ip[2]})">+</button>
          </div>
        </div>
      </c:forEach>
    </div>
  </div>
</c:if>

<div class="pd-sec">
  <div class="pd-h"><i class="fa fa-circle-o"></i> Таблетки <span class="sp"></span><span class="day">${oper_day}</span></div>
  <c:if test="${empty tabs}"><div class="pd-empty">Таблеток на это время нет</div></c:if>
  <c:forEach items="${tabs}" var="drug" varStatus="loop">
    <div class="pd-row">
      <span class="pd-n">${loop.index + 1}</span>
      <div class="pd-name">
        <c:forEach items="${drug.rows}" var="row" varStatus="rl">${row.name}<c:if test="${row.source == 'own'}"><span class="own" title="Препарат пациента">свой</span></c:if><c:if test="${rl.index + 1 < fn:length(drug.rows)}"> + </c:if></c:forEach>
        <span class="note">${drug.note}</span>
      </div>
      <div class="pd-step" title="Сколько выдано">
        <button type="button" onclick="setIterator('tab_${drug.id}', -1)">−</button>
        <input type="text" readonly id="tab_${drug.id}" value="${tab_exps.get(drug.id) == null ? 0 : tab_exps.get(drug.id)}"/>
        <button type="button" onclick="setIterator('tab_${drug.id}', 1)">+</button>
      </div>
    </div>
  </c:forEach>
</div>
