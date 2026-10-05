<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<link href="/res/css/styles.css" rel="stylesheet">
<script>
  var totalSum = +Number(${ndsTotal});
  function delService(id, state) {
    if (state == 'PAID') {
      if (confirm('Возврат денег?')) {
        var msg = prompt('Причина возврата денег');
        if (msg != null && msg.length > 0) {
          $.ajax({
            url: '/amb/delSer.s',
            method: 'post',
            data: 'id=' + id + '&msg=' + encodeURIComponent(msg),
            dataType: 'json',
            success: function (res) {
              if (res.success) {
                setPage('/cashbox/amb.s?id=${patient.id}');
              }
            }
          });
        }
      }
    } else {
      if (confirm('Вы действительно хотите удалить?')) {
        $.ajax({
          url: '/amb/delSer.s',
          method: 'post',
          data: 'id=' + id,
          dataType: 'json',
          success: function (res) {
            if (res.success) {
              setPage('/cashbox/amb.s?id=${patient.id}');
            }
          }
        });
      }
    }
  }
  function printCheck(id) {
    window.open('/amb/print.s?check=' + id);
  }
  function setDrugPrint() {
    window.open('/amb/print.s?drugcheck=Y');
  }
</script>

<style>
  /* ================= Общие элементы карточки ================= */
  .ar { --brand:#D7182E; --brand-dark:#A50F22; --brand-soft:#FDECEE; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    max-width: 1200px; margin: 0 auto; padding: 16px 20px 40px; color: var(--text);
    font-family: 'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .ar-card { background:#fff; border:1px solid var(--border); border-radius:14px; margin-bottom:16px; }
  .ar-card-h { display:flex; align-items:center; gap:10px; flex-wrap:wrap; padding:14px 18px; border-bottom:1px solid var(--border); }
  .ar-card-h h3 { margin:0; font-size:16px; font-weight:700; }
  .ar-card-h .sp { flex:1; }
  .ar-card-b { padding:18px; }

  /* Кнопки */
  .ab { display:inline-flex; align-items:center; gap:7px; height:36px; padding:0 14px; border-radius:9px;
    border:1.5px solid var(--border); background:#fff; color:var(--text); font-size:13.5px; font-weight:600;
    white-space:nowrap; cursor:pointer; text-decoration:none !important; transition:background .12s,border-color .12s,color .12s; }
  .ab:hover { background:var(--bg); color:var(--text); }
  .ab .fa { color:var(--muted); }
  .ab.primary { background:var(--brand); border-color:var(--brand); color:#fff; }
  .ab.primary .fa { color:#fff; }
  .ab.primary:hover { background:var(--brand-dark); border-color:var(--brand-dark); }
  .ab.danger:hover { background:var(--brand-soft); border-color:#F5C2C8; color:var(--brand); }
  .ab.danger:hover .fa { color:var(--brand); }
  .ab.sm { height:32px; padding:0 12px; font-size:13px; }
  .ab-ico { width:30px; height:30px; display:inline-flex; align-items:center; justify-content:center; border-radius:8px;
    border:0; background:transparent; color:var(--muted); cursor:pointer; }
  .ab-ico:hover { background:var(--bg); color:var(--text); }
  .ab-ico.del:hover { background:var(--brand-soft); color:var(--brand); }
  .ab-ico.rep:hover { background:#EAF1FE; color:#2563EB; }

  /* Шапка пациента */
  .ar-head { display:flex; align-items:center; flex-wrap:wrap; gap:14px; padding:16px 18px; }
  .ar-avatar { flex:none; width:48px; height:48px; border-radius:14px; background:var(--brand-soft); color:var(--brand);
    display:flex; align-items:center; justify-content:center; font-size:20px; }
  .ar-title { flex:1 1 320px; min-width:0; }
  .ar-title h2 { margin:0 0 4px; font-size:20px; font-weight:700; cursor:pointer; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
  .ar-meta { display:flex; align-items:center; gap:10px; font-size:13px; color:var(--muted); white-space:nowrap; }
  .ar-actions { margin-left:auto; display:flex; align-items:center; gap:8px; flex-wrap:wrap; justify-content:flex-end; }

  .st { display:inline-flex; align-items:center; gap:6px; padding:3px 10px; border-radius:999px; font-size:12px; font-weight:600; white-space:nowrap; }
  .st::before { content:''; width:7px; height:7px; border-radius:50%; background:currentColor; }
  .st-new  { background:#EAF1FE; color:#2563EB; }
  .st-red  { background:var(--brand-soft); color:var(--brand); }
  .st-amb  { background:#FEF3E2; color:#B45309; }
  .st-grn  { background:#E8F7EE; color:#15803D; }
  .st-gry  { background:#F1F2F4; color:#6B7280; }

  /* Сетка полей */
  .fg { display:grid; grid-template-columns:repeat(6, 1fr); gap:14px 16px; }
  .fg .f { display:flex; flex-direction:column; gap:6px; min-width:0; }
  .fg .s2 { grid-column:span 2; } .fg .s3 { grid-column:span 3; } .fg .s4 { grid-column:span 4; } .fg .s6 { grid-column:span 6; }
  .fg label { margin:0; font-size:12.5px; font-weight:600; color:var(--muted); }
  .fg label req, .ar-modal label req { color:var(--brand); }
  .fg .hint { font-size:11.5px; color:#9AA1AC; }
  .ar .form-control, .ar-modal .form-control {
    height:38px; border:1.5px solid var(--border); border-radius:9px; box-shadow:none; font-size:14px; color:var(--text);
  }
  .ar .form-control:focus, .ar-modal .form-control:focus { border-color:var(--brand); box-shadow:0 0 0 3px rgba(215,24,46,.10); }
  .ar .form-control[readonly] { background:#F8F9FA; color:#3C4250; cursor:default; }
  .ar .form-control[readonly]:focus { border-color:var(--border); box-shadow:none; }

  /* Поле клиента с подсказкой */
  .client-field { position:relative; display:flex; gap:8px; }
  .client-field .inp { flex:1; position:relative; }
  #client_buttons { display:flex; gap:6px; }
  #client_buttons .btn { width:38px; height:38px; padding:0; border-radius:9px; }
  #client_filter { top:calc(100% + 4px); left:0; z-index:50; max-height:280px; overflow-y:auto;
    border:1px solid var(--border); border-radius:10px; box-shadow:0 12px 30px rgba(20,25,40,.14); }
  #client_filter table { width:100%; border:0; }
  #client_filter td { padding:9px 12px; border:0; border-bottom:1px solid #F0F1F4; font-size:14px; cursor:pointer; }
  #client_filter td.cf-bd { color:var(--muted); text-align:right; white-space:nowrap; font-variant-numeric:tabular-nums; }
  #client_filter tr:hover td { background:var(--brand-soft); }

  /* Таблица услуг */
  .st-table { width:100%; border-collapse:separate; border-spacing:0; font-size:14px; }
  .st-table th { padding:10px 12px; background:#F8F9FA; border-bottom:1px solid var(--border); color:var(--muted);
    font-size:12px; font-weight:600; text-transform:uppercase; letter-spacing:.3px; text-align:left; white-space:nowrap; }
  .st-table td { padding:8px 12px; border-bottom:1px solid #F0F1F4; vertical-align:middle; }
  .st-table tr:last-child td { border-bottom:0; }
  .st-table tbody tr:hover td { background:#FAFBFC; }
  .st-table .c { text-align:center; } .st-table .r { text-align:right; font-variant-numeric:tabular-nums; }
  .st-table .n { color:#9AA1AC; font-size:13px; }
  .st-table .form-control { height:34px; font-size:13px; min-width:180px; }
  .st-table .sname { font-weight:500; }
  .st-table .sname .fa-medkit { color:#2563EB; margin-right:4px; }
  .st-table tr.unpaid .sname { color:var(--brand-dark); }
  .st-table .sale { display:inline-block; margin-left:6px; padding:1px 8px; border-radius:999px; background:#FEF3E2; color:#B45309; font-size:12px; font-weight:700; }
  .st-table tfoot td { padding:12px; background:#FAFBFC; border-top:1px solid var(--border); font-weight:700; }
  .st-table input[type=checkbox] { width:16px; height:16px; margin:0; cursor:pointer; accent-color:var(--brand); }
  .st-empty { padding:36px; text-align:center; color:#9AA1AC; }

  /* История */
  details.his { border-top:1px solid var(--border); }
  details.his:first-of-type { border-top:0; }
  details.his > summary { display:flex; align-items:center; gap:10px; padding:12px 18px; cursor:pointer; list-style:none; user-select:none; }
  details.his > summary::-webkit-details-marker { display:none; }
  details.his > summary .chev { color:#9AA1AC; transition:transform .15s; }
  details.his[open] > summary .chev { transform:rotate(90deg); }
  details.his > summary b { font-weight:600; }
  details.his > summary .cnt { color:var(--muted); font-size:13px; }
  details.his > summary .sp { flex:1; }
  details.his > summary:hover { background:#FAFBFC; }

  /* Модальные окна */
  .ar-modal .modal-content { border:0; border-radius:16px; box-shadow:0 24px 60px rgba(20,25,40,.25); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .ar-modal .modal-header { padding:16px 20px; border-bottom:1px solid #E6E8EC; }
  .ar-modal .modal-title { font-size:17px; font-weight:700; color:#1F2430; }
  .ar-modal .modal-title .fa { color:#D7182E; margin-right:6px; }
  .ar-modal .modal-body { padding:20px; }
  .ar-modal .modal-footer { padding:14px 20px; border-top:1px solid #E6E8EC; display:flex; justify-content:flex-end; gap:8px; }
  .ar-modal .fg label { color:#6B7280; }
  /* --- дополнительно для кассы --- */
  .ar { max-width: 1100px; }
  .ar-avatar.cash { background:#E8F7EE; color:#15803D; }

  /* Реквизиты — компактный список */
  .dl { display:grid; grid-template-columns:repeat(4, 1fr); gap:14px 20px; padding:16px 18px; }
  .dl div { min-width:0; }
  .dl dt { font-size:12px; font-weight:600; color:var(--muted); margin-bottom:3px; }
  .dl dd { margin:0; font-size:14px; font-weight:500; color:var(--text); overflow-wrap:anywhere; }
  .dl .w2 { grid-column:span 2; } .dl .w4 { grid-column:span 4; }

  .pay-btn { display:inline-flex; align-items:center; gap:5px; height:26px; padding:0 9px; border-radius:7px; border:1.5px solid var(--border);
    background:#fff; font-size:12px; font-weight:600; cursor:pointer; white-space:nowrap; }
  .pay-btn.ok  { color:#15803D; } .pay-btn.ok:hover  { background:#E8F7EE; border-color:#BFE6CD; }
  .pay-btn.ret { color:var(--brand); } .pay-btn.ret:hover { background:var(--brand-soft); border-color:#F5C2C8; }

  .sub-h { padding:10px 18px; background:#FAFBFC; border-top:1px solid var(--border); border-bottom:1px solid var(--border);
    display:flex; align-items:center; gap:10px; font-size:13px; font-weight:700; color:#3C4250; }
  .sub-h .sp { flex:1; }

  /* ---------- Блок оплаты ---------- */
  .pay-card { border-color:#F3C6CC; box-shadow:0 8px 24px rgba(215,24,46,.06); }
  .pay-due { display:flex; align-items:baseline; gap:8px; }
  .pay-due span { font-size:13px; font-weight:600; color:var(--muted); }
  .pay-due b { font-size:24px; font-weight:700; color:var(--brand); font-variant-numeric:tabular-nums; }

  .pay-tabs.nav-tabs { display:flex; gap:4px; margin:0; padding:10px 18px 0; border-bottom:1px solid var(--border); }
  .pay-tabs.nav-tabs > li { float:none; margin-bottom:-1px; }
  .pay-tabs.nav-tabs > li > a { margin:0; padding:9px 16px; border:0; border-bottom:2px solid transparent; border-radius:0;
    color:var(--muted); font-weight:600; font-size:14px; background:transparent; }
  .pay-tabs.nav-tabs > li > a:hover { color:var(--text); background:transparent; border-color:transparent; border-bottom-color:#D5D8DE; }
  .pay-tabs.nav-tabs > li.active > a, .pay-tabs.nav-tabs > li.active > a:hover, .pay-tabs.nav-tabs > li.active > a:focus {
    color:var(--brand-dark); border:0; border-bottom:2px solid var(--brand); background:transparent; }

  .pay-methods { width:100%; border-collapse:separate; border-spacing:0 8px; padding:10px 18px 4px; }
  .pay-methods td { padding:0 12px; height:58px; background:#FAFBFC; border-top:1.5px solid var(--border); border-bottom:1.5px solid var(--border); vertical-align:middle; }
  .pay-methods td:first-child { width:48px; text-align:center; border-left:1.5px solid var(--border); border-radius:12px 0 0 12px; }
  .pay-methods td:last-child { width:280px; border-right:1.5px solid var(--border); border-radius:0 12px 12px 0; }
  .pay-methods tr.m { cursor:pointer; }
  .pay-methods tr.m:hover td { background:#F5F6F8; }
  .pay-methods tr.m:has(input[type=checkbox]:checked) td { background:#FFF7F8; border-color:#F3C6CC; }
  .pay-methods .m-name { display:flex; align-items:center; gap:12px; font-size:15px; font-weight:600; }
  .pay-methods .m-ico { width:34px; height:34px; border-radius:10px; display:flex; align-items:center; justify-content:center; background:#fff; border:1px solid var(--border); color:var(--muted); }
  .pay-methods tr.m:has(input:checked) .m-ico { color:var(--brand); border-color:#F3C6CC; }
  .pay-methods input[type=checkbox] { width:18px; height:18px; margin:0; cursor:pointer; accent-color:var(--brand); }
  .pay-methods input.form-control { height:42px; font-size:18px; font-weight:600; text-align:right; font-variant-numeric:tabular-nums; }
  .pay-methods input.form-control[readonly] { background:#F1F2F4; color:#B0B5BD; cursor:pointer; }
  .pay-methods tr.total td { background:#fff; border-color:transparent; height:54px; }
  .pay-methods tr.total .m-name { justify-content:flex-end; font-size:14px; color:var(--muted); text-transform:uppercase; letter-spacing:.3px; }
  .pay-methods tr.total input.form-control { background:#fff; border:1.5px solid var(--text); color:var(--text); font-size:20px; cursor:default; }

  .pay-foot { display:flex; align-items:center; gap:8px; padding:12px 18px 16px; }
  .pay-foot .hint { flex:1; font-size:12.5px; color:#9AA1AC; }

  @media (max-width: 900px) { .dl { grid-template-columns:repeat(2, 1fr); } .dl .w4 { grid-column:span 2; } }
</style>

<div class="ar">

  <!-- ================= Шапка ================= -->
  <div class="ar-card">
    <div class="ar-head">
      <div class="ar-avatar cash"><i class="fa fa-money"></i></div>
      <div class="ar-title">
        <h2>${patient.surname} ${patient.name} ${patient.middlename}</h2>
        <div class="ar-meta">
          <span>ID ${patient.id}</span>
          <c:if test="${not empty patient.discountType.name}"><span class="st st-amb">${patient.discountType.name}</span></c:if>
        </div>
      </div>
      <div class="ar-actions">
        <c:if test="${serviceTotalSum == 0}">
          <button type="button" class="ab" onclick="printCheck(0)"><i class="fa fa-print"></i> Чек</button>
        </c:if>
      </div>
    </div>
    <dl class="dl" style="border-top:1px solid var(--border); margin:0">
      <div><dt><ui:message code="birthyear"/></dt><dd>${patient.birthyear}</dd></div>
      <div><dt><ui:message code="sex"/></dt><dd>${patient.sex.name}</dd></div>
      <div><dt><ui:message code="phone"/></dt><dd>${patient.tel}</dd></div>
      <div><dt><ui:message code="passportInfo"/></dt><dd>${patient.passportInfo}</dd></div>
      <div><dt>Резидентство</dt><dd>${country}</dd></div>
      <div><dt>Область</dt><dd>${region}</dd></div>
      <div class="w2"><dt><ui:message code="address"/></dt><dd>${patient.address}</dd></div>
    </dl>
  </div>

  <!-- ================= Услуги ================= -->
  <div class="ar-card" style="overflow:hidden">
    <div class="ar-card-h"><h3>Услуги<c:if test="${fn:length(drugs) > 0 || fn:length(ds) > 0}"> и медикаменты</c:if></h3></div>
    <div style="overflow-x:auto">
      <table class="st-table">
        <thead>
        <tr>
          <th class="c" style="width:44px">№</th>
          <th>Наименование</th>
          <th style="width:230px">Статус</th>
          <th class="r" style="width:110px">Сумма</th>
          <th class="r" style="width:110px">С НДС</th>
          <th style="width:170px">Врач</th>
          <c:if test="${patient.state != 'ARCH'}"><th class="c" style="width:50px"></th></c:if>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${services}" var="ser" varStatus="loop">
          <tr id="ser${ser.id}" class="${ser.state == 'ENT' ? 'unpaid' : ''}">
            <td class="c n">${loop.index + 1}</td>
            <td class="sname">${ser.service.name}</td>
            <td style="white-space:nowrap">
              <c:choose>
                <c:when test="${ser.state == 'ENT'}"><span class="st st-red">Не оплачено</span></c:when>
                <c:when test="${ser.state == 'PAID'}"><span class="st st-amb">Оплачено</span></c:when>
                <c:when test="${ser.state == 'DONE'}"><span class="st st-grn">Выполнено</span></c:when>
                <c:when test="${ser.state == 'DEL'}"><span class="st st-gry">Возврат</span></c:when>
                <c:when test="${ser.state == 'AUTO_DEL'}"><span class="st st-gry">Удалён</span></c:when>
              </c:choose>
              <c:if test="${ser.state == 'PAID' && ser.result.id == 0}">
                <button type="button" class="pay-btn ret" title="Сделать не оплаченным" onclick="setServicePayState('ret', ${ser.id})"><i class="fa fa-undo"></i> Снять</button>
              </c:if>
              <c:if test="${ser.state == 'ENT'}">
                <button type="button" class="pay-btn ok" title="Сделать оплаченным" onclick="setServicePayState('pay', ${ser.id})"><i class="fa fa-check"></i> Оплачено</button>
              </c:if>
            </td>
            <td class="r">${ser.price}</td>
            <td class="r">${ser.nds}</td>
            <td style="color:#3C4250">${ser.users[0].fio}</td>
            <c:if test="${patient.state != 'ARCH'}">
              <td class="c">
                <c:if test="${ser.state == 'ENT' || (ser.state != 'DEL' && ser.state != 'DONE' && ser.state != 'ARCH' && is_admin && ser.state != 'AUTO_DEL')}">
                  <button type="button" class="ab-ico del" title="${ser.state == 'PAID' ? 'Возврат денег' : 'Удалить'}" onclick="delService(${ser.id}, '${ser.state}')"><i class="fa fa-trash-o"></i></button>
                </c:if>
              </td>
            </c:if>
          </tr>
        </c:forEach>
        </tbody>
        <c:if test="${serviceTotalSum > 0}">
          <tfoot>
          <tr>
            <td colspan="3">Итого к оплате</td>
            <td class="r"><fmt:formatNumber value="${serviceTotalSum}" type="number"/></td>
            <td class="r"><fmt:formatNumber value="${ndsTotal}" type="number"/></td>
            <td colspan="${patient.state != 'ARCH' ? 2 : 1}"></td>
          </tr>
          </tfoot>
        </c:if>
      </table>
    </div>

    <!-- Медикаменты -->
    <c:if test="${fn:length(drugs) > 0}">
      <div class="sub-h">
        <i class="fa fa-medkit" style="color:#2563EB"></i> Медикаменты
        <span class="sp"></span>
        <button class="ab sm" type="button" onclick="setDrugPrint()"><i class="fa fa-print"></i> Печать</button>
      </div>
      <div style="overflow-x:auto">
        <table class="st-table">
          <thead>
          <tr>
            <th class="c" style="width:44px">№</th>
            <th>Наименование</th>
            <th class="r" style="width:90px">Кол-во</th>
            <th class="r" style="width:120px">Цена</th>
            <th class="r" style="width:130px">Сумма</th>
            <th class="r" style="width:130px">С НДС</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach items="${drugs}" var="drug" varStatus="loop">
            <tr>
              <td class="c n">${loop.index + 1}</td>
              <td class="sname">${drug.drug.drug.name}</td>
              <td class="r">${drug.rasxod}</td>
              <td class="r"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${drug.drug.price}" type="number"/></td>
              <td class="r"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${drug.rasxod * drug.drug.price}" type="number"/></td>
              <td class="r"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${drug.rasxod * (drug.drug.price + drug.drug.nds)}" type="number"/></td>
            </tr>
          </c:forEach>
          </tbody>
          <c:if test="${drugSum > 0}">
            <tfoot>
            <tr>
              <td colspan="5">Итого</td>
              <td class="r"><fmt:formatNumber value="${drugSum}" type="number"/></td>
            </tr>
            </tfoot>
          </c:if>
        </table>
      </div>
    </c:if>
  </div>

  <!-- ================= История оплат ================= -->
  <c:if test="${fn:length(pays) > 0}">
    <div class="ar-card" style="overflow:hidden">
      <div class="ar-card-h"><h3>Операции по кассе</h3></div>
      <div style="overflow-x:auto">
        <table class="st-table">
          <thead>
          <tr>
            <th style="width:100px">Тип</th>
            <th style="width:140px">Дата</th>
            <th class="r">Наличные</th>
            <th class="r">Карта</th>
            <th class="r">Онлайн</th>
            <th class="r">Перечисление</th>
            <th>Пользователь</th>
            <th class="c" style="width:90px"></th>
          </tr>
          </thead>
          <tbody>
          <c:forEach items="${pays}" var="pay">
            <tr>
              <td>
                <c:if test="${pay.payType == 'ret'}"><span class="st st-red">Возврат</span></c:if>
                <c:if test="${pay.payType != 'ret'}"><span class="st st-grn">Оплата</span></c:if>
              </td>
              <td style="white-space:nowrap; color:#6B7280"><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${pay.crOn}"/></td>
              <td class="r"><fmt:formatNumber value="${pay.cash}" type="number"/></td>
              <td class="r"><fmt:formatNumber value="${pay.card}" type="number"/></td>
              <td class="r"><fmt:formatNumber value="${pay.online}" type="number"/></td>
              <td class="r"><fmt:formatNumber value="${pay.transfer}" type="number"/></td>
              <td>${users[pay.crBy]}</td>
              <td class="c" style="white-space:nowrap">
                <button type="button" class="ab-ico" title="Печать чека" onclick="printCheck(${pay.id})"><i class="fa fa-print"></i></button>
                <button type="button" class="ab-ico del" title="Удалить оплату" onclick="delCashOper(${pay.id})"><i class="fa fa-trash-o"></i></button>
              </td>
            </tr>
          </c:forEach>
          <c:forEach items="${discounts}" var="discount">
            <tr>
              <td><span class="st st-amb">Скидка</span></td>
              <td style="white-space:nowrap"><a href="#" onclick="addEditDiscount(${discount.id}); return false;" title="Редактировать"><fmt:formatDate pattern="dd.MM.yyyy" value="${discount.crOn}"/></a></td>
              <td class="r" colspan="4"><fmt:formatNumber value="${discount.summ}" type="number"/></td>
              <td>${discount.crBy.fio}</td>
              <td class="c">
                <button type="button" class="ab-ico del" title="Удалить скидку" onclick="delDiscount(${discount.id})"><i class="fa fa-trash-o"></i></button>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </c:if>

  <!-- ================= Оплата / возврат / скидки ================= -->
  <c:if test="${serviceTotalSum > 0 || paidSum > 0}">
    <div class="ar-card pay-card">
      <div class="ar-card-h">
        <h3>Касса</h3>
        <span class="sp"></span>
        <div class="pay-due"><span>К оплате</span><b id="totalSumSpan"></b></div>
      </div>

      <input name="pay_type" value="<c:if test="${serviceTotalSum > 0}">pay</c:if><c:if test="${serviceTotalSum == 0 && paidSum > 0}">ret</c:if>" id="pay_type" type="hidden"/>
      <ul class="nav nav-tabs pay-tabs">
        <c:if test="${serviceTotalSum > 0}">
          <li class="active"><a href="#pager" onclick="setPayType('pay')" data-toggle="tab" aria-expanded="true"><i class="fa fa-credit-card"></i>&nbsp; Оплата</a></li>
        </c:if>
        <c:if test="${paidSum > 0}">
          <li class="${serviceTotalSum > 0 ? '' : 'active'}"><a href="#pager" onclick="setPayType('ret')" data-toggle="tab" aria-expanded="false"><i class="fa fa-undo"></i>&nbsp; Возврат</a></li>
        </c:if>
        <c:if test="${serviceTotalSum > 0}">
          <li class=""><a href="#discount" onclick="setPayType('discount')" data-toggle="tab" aria-expanded="false"><i class="fa fa-percent"></i>&nbsp; Скидки</a></li>
        </c:if>
      </ul>

      <div class="tab-content">
        <div class="tab-pane active fade in" id="pager">
          <table class="pay-methods">
            <tr class="m" onclick="tdClick('card')">
              <td><input type="checkbox" id="cardCheck" tabindex="-1" onchange="setPay('card', this)"/></td>
              <td><div class="m-name"><span class="m-ico"><i class="fa fa-credit-card"></i></span>Пластиковая карта</div></td>
              <td><input class="form-control" id="cardInput" onblur="calcSum(this)" type="number" value="" readonly placeholder="0"/></td>
            </tr>
            <tr class="m" onclick="tdClick('cash')">
              <td><input type="checkbox" id="cashCheck" tabindex="-1" onclick="setPay('cash', this)"/></td>
              <td><div class="m-name"><span class="m-ico"><i class="fa fa-money"></i></span>Наличные</div></td>
              <td><input class="form-control" id="cashInput" readonly onblur="calcSum(this)" type="number" placeholder="0"/></td>
            </tr>
            <tr class="m" onclick="tdClick('transfer')">
              <td><input type="checkbox" id="transferCheck" tabindex="-1" onclick="setPay('transfer', this)"/></td>
              <td><div class="m-name"><span class="m-ico"><i class="fa fa-university"></i></span>Перечисление</div></td>
              <td><input class="form-control" id="transferInput" readonly onblur="calcSum(this)" type="number" placeholder="0"/></td>
            </tr>
            <tr class="m" onclick="tdClick('online')">
              <td><input type="checkbox" id="onlineCheck" tabindex="-1" onclick="setPay('online', this)"/></td>
              <td><div class="m-name"><span class="m-ico"><i class="fa fa-mobile"></i></span>Онлайн</div></td>
              <td><input class="form-control" id="onlineInput" readonly onblur="calcSum(this)" type="number" placeholder="0"/></td>
            </tr>
            <tr class="total">
              <td></td>
              <td><div class="m-name">Итого</div></td>
              <td><input class="form-control" id="totalInput" readonly/></td>
            </tr>
          </table>
        </div>

        <div class="tab-pane fade" id="discount">
          <div style="overflow-x:auto; padding-top:6px">
            <table class="st-table">
              <thead>
              <tr>
                <th class="c" style="width:44px">№</th>
                <th style="width:110px">Дата</th>
                <th>Описание</th>
                <th class="r" style="width:130px">Сумма</th>
                <th style="width:170px">Пользователь</th>
                <th class="c" style="width:56px"></th>
              </tr>
              </thead>
              <tbody>
              <c:forEach items="${discounts}" var="discount" varStatus="loop">
                <tr style="cursor:pointer" ondblclick="addEditDiscount(${discount.id})" title="Двойной клик — редактировать">
                  <td class="c n">${loop.index + 1}</td>
                  <td><fmt:formatDate pattern="dd.MM.yyyy" value="${discount.crOn}"/></td>
                  <td>${discount.text}</td>
                  <td class="r"><fmt:formatNumber value="${discount.summ}" type="number"/></td>
                  <td style="white-space:nowrap">${discount.crBy.fio}</td>
                  <td class="c">
                    <button type="button" class="ab-ico del" title="Удалить" onclick="delDiscount(${discount.id})"><i class="fa fa-trash-o"></i></button>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
            <c:if test="${fn:length(discounts) == 0}"><div class="st-empty">Скидок нет</div></c:if>
          </div>
        </div>
      </div>

      <c:if test="${patient.state != 'ARCH'}">
        <div class="pay-foot">
          <span class="hint">Отметьте способы оплаты и введите суммы. «Рассчитать» заполнит оставшийся способ автоматически.</span>
          <button type="button" class="ab" id="discount_add" style="display:none" onclick="addEditDiscount(0); return false"><i class="fa fa-plus"></i> Добавить скидку</button>
          <button type="button" class="ab" onclick="calcTotal(); return false;"><i class="fa fa-calculator"></i> Рассчитать</button>
          <button type="button" class="ab primary" onclick="saveForm(); return false;"><i class="fa fa-save"></i> Провести</button>
        </div>
      </c:if>
    </div>
  </c:if>
</div>

<!-- ================= Модальное окно: скидка ================= -->
<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
<div class="modal fade ar-modal" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog" style="width:520px; max-width:95vw">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel"><i class="fa fa-percent"></i> Скидка</h4>
      </div>
      <div class="modal-body">
        <form id="addEditForm" name="addEditForm">
          <input type="hidden" name="id" value="" />
          <input type="hidden" name="code" value="AMB" />
          <input type="hidden" name="patient" value="${patient.id}" />
          <div class="fg">
            <div class="f s6"><label>Сумма скидки <req>*</req></label>
              <input type="number" class="form-control" maxlength="20" name="summ" style="text-align:right; font-size:18px; font-weight:600"/></div>
            <div class="f s6"><label>Описание</label>
              <textarea class="form-control" name="text" maxlength="200" rows="3" style="height:auto; font-family:inherit"></textarea></div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="ab" id="close-modal" data-dismiss="modal">Закрыть</button>
        <button type="button" class="ab primary" onclick="saveDiscount()"><i class="fa fa-save"></i> Сохранить</button>
      </div>
    </div>
  </div>
</div>

<script>
  var totalSum = Number(${ndsTotal}), paidSum = ${paidSum}, discountSumm = ${discountSum};
  $(function() {
    $('#totalSumSpan').html('<fmt:formatNumber value = "${ndsTotal}" type = "number"/>');
  });
  function setPay(type, dom) {
    var elem = document.getElementById(type + 'Input');
    if (dom.checked) {
      elem.removeAttribute("readonly");
      elem.focus();
    } else {
      dom.removeAttribute("checked");
      elem.setAttribute("readonly", "true");
      elem.value = '';
    }
    calcSum(null);
  }
  // клик по строке способа оплаты = переключить галочку (кроме клика по самой галочке и активному полю суммы)
  function tdClick(type) {
    var t = event.target;
    if (t.tagName === 'INPUT' && (t.type === 'checkbox' || !t.readOnly)) return;
    getDOM(type + 'Check').click();
  }
  function calcTotal(){
    var total = document.getElementById("totalInput"),
      card = document.getElementById('cardInput'),
      transfer = document.getElementById('transferInput'),
      online = document.getElementById('onlineInput'),
      cash = document.getElementById('cashInput');
    var sum = 0;
    var cCard = document.getElementById("cardCheck"),
      cTransfer = document.getElementById("transferCheck"),
      cOnline = document.getElementById("onlineCheck"),
      cCash = document.getElementById("cashCheck");
    var checkedCount = 0, valueCount = 0;
    if (card.value !== '') {valueCount++; sum = parseFloat(card.value);}
    if (cash.value !== '') {valueCount++; sum += parseFloat(cash.value);}
    if (transfer.value !== '') {valueCount++; sum += parseFloat(transfer.value);}
    if (online.value !== '') {valueCount++; sum += parseFloat(online.value);}
    if (cCard.checked) checkedCount++;
    if (cTransfer.checked) checkedCount++;
    if (cOnline.checked) checkedCount++;
    if (cCash.checked) checkedCount++;
    if (valueCount + 1 !== checkedCount) {
      alert('Есть не заполненные поля');
      return;
    }
    if (cCard.checked && card.value === '') card.value = totalSum - sum;
    if (cTransfer.checked && transfer.value === '') transfer.value = totalSum - sum;
    if (cOnline.checked && online.value === '') online.value = totalSum - sum;
    if (cCash.checked && cash.value === '') cash.value = totalSum - sum;
    total.value = totalSum;
  }
  function calcSum(elem) {
    try {
      var payType = $('#pay_type').val();
      var total = document.getElementById("totalInput");
      var transfer = document.getElementById('transferInput'),
        card = document.getElementById('cardInput'),
        online = document.getElementById('onlineInput'),
        cash = document.getElementById('cashInput');
      var sum = 0;
      total.style.borderColor = '';
      total.style.color = '';
      total.title = 'Сумма оплаты';
      if (card.value !== '') sum = parseFloat(card.value);
      if (cash.value !== '') sum += parseFloat(cash.value);
      if (transfer.value !== '') sum += parseFloat(transfer.value);
      if (online.value !== '') sum += parseFloat(online.value);
      //
      if(payType !== 'pay') {
        if(sum > paidSum) {
          if (elem != null) elem.value = 0;
          alert('Итоговая сумма возврата не может быть больше оплаченной!');
          return;
        }
      }
      //
      if (payType === 'pay' && sum > totalSum) {
        if (elem != null) {
          elem.value = 0;
        }
        alert('ИТОГО не может быть больше суммы к оплате');
        total.style.borderColor = '#D7182E';
        total.style.color = '#D7182E';
        total.title = 'Сумма оплаты больше ожидаемого';
      }
      document.getElementById("totalInput").value = sum;
    } catch (e) {
      alert('Проверьте правильность ввода цифр');
      document.getElementById("totalInput").value = '0';
    }
  }
  function saveForm() {
    var payType = $('#pay_type').val();
    var transfer = document.getElementById('transferInput'),
      card = document.getElementById('cardInput'),
      online = document.getElementById('onlineInput'),
      cash = document.getElementById('cashInput');
    var sum = 0, params = 'id=${patient.id}&pay_type=' + payType + '&';
    if (card.value !== '') {sum += parseFloat(card.value); params += 'card=' + card.value + '&';}
    if (cash.value !== '') {sum += parseFloat(cash.value); params += 'cash=' + cash.value + '&';}
    if (transfer.value !== '') {sum += parseFloat(transfer.value); params += 'transfer=' + transfer.value + '&';}
    if (online.value !== '') {sum += parseFloat(online.value); params += 'online=' + online.value + '&';}
    if (payType === 'pay' && totalSum !== sum) {
      alert('Сумма неверна. Проверьте итоговую сумму');
      return;
    }
    $.ajax({
      url: '/cashbox/amb.s',
      method: "post",
      data: params,
      dataType: 'json',
      success: function (json) {
        if (json.success) {
          alert("<ui:message code="successSave"/>");
          setPage('/cashbox/amb.s?id=${patient.id}');
        } else {
          alert(json.msg)
        }
      },
      error: function (data, err) {
        alert(err);
      }
    });
  }
  function setPayType(type) {
    if(type === 'discount')
      $('#discount_add').show();
    else
      $('#discount_add').hide();
    $('#pay_type').val(type)
  }
  function addEditDiscount(id) {
    addEditForm.reset();
    document.getElementById("modal_window").click();
    if(id > 0) {
      $.ajax({
        url: '/cashbox/getDiscount.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            $('#addEditForm *[name=id]').val(res.id);
            $('#addEditForm *[name=summ]').val(res.summ);
            $('#addEditForm *[name=text]').val(res.text);
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
  function saveDiscount() {
    try {
      var discountSum = parseFloat($('#addEditForm *[name=summ]').val());
      if(discountSum + discountSumm > totalSum) {
        alert('Сумма скидки не может превышать сумму к оплате');
        return;
      }
      $.ajax({
        url: '/cashbox/discount.s',
        method: "post",
        data: $('#addEditForm').serialize(),
        dataType: 'json',
        success: function (json) {
          if (json.success) {
            $('#close-modal').click();
            alert("<ui:message code="successSave"/>");
            setPage('/cashbox/amb.s?id=${patient.id}');
          } else {
            alert(json.msg)
          }
        },
        error: function (data, err) {
          alert(err);
        }
      });
    } catch (e) {
      alert('Проверьте правильность ввода');
    }
  }
  function delDiscount(id) {
    if (!confirm('Удалить скидку?')) return;
    $.ajax({
      url: '/cashbox/delDiscount.s',
      method: "post",
      data: 'id=' + id,
      dataType: 'json',
      success: function (json) {
        if (json.success) {
          alert("<ui:message code="successSave"/>");
          setPage('/cashbox/amb.s?id=${patient.id}');
        } else {
          alert(json.msg)
        }
      },
      error: function (data, err) {
        alert(err);
      }
    });
  }
  function setServicePayState(code, id) {
    $.ajax({
      url: '/cashbox/setServicePayState.s',
      method: "post",
      data: 'code=' + code + '&id=' + id,
      dataType: 'json',
      success: function (json) {
        if (json.success) {
          alert("<ui:message code="successSave"/>");
          setPage('/cashbox/amb.s?id=${patient.id}');
        } else {
          alert(json.msg)
        }
      },
      error: function (data, err) {
        alert(err);
      }
    });
  }
  function delCashOper(id) {
    if(confirm('Вы действительно хотите удалить оплату?'))
      $.ajax({
        url: '/cashbox/amb/delPay.s',
        method: "post",
        data: 'id=' + id,
        dataType: 'json',
        success: function (json) {
          if (json.success) {
            alert("<ui:message code="successSave"/>");
            setPage('/cashbox/amb.s?id=${patient.id}');
          } else {
            alert(json.msg)
          }
        },
        error: function (data, err) {
          alert(err);
        }
      });
  }
</script>
