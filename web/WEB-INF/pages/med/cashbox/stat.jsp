<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script>
  function closeIB(){
    FmsConfirm('Осторожно!!! Вы действительно хотите закрыть ИБ? Все действия закроются!', function () {
      $.ajax({
        url: '/cashbox/closeib.s',
        method: 'post',
        data: 'id=${pat.id}',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            FmsToast.show('Данные сохранены', 'ok');
            setPage('/cashbox/stat.s?id=${pat.id}');
          } else {
            FmsToast.show(res.msg, 'err');
          }
        }
      });
    });
  }
  function saveKoyko(){
    $.ajax({
      url: '/cashbox/setKoyko.s',
      method: 'post',
      data: 'id=${pat.id}&koyko=' + $('#koyko-days').val(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          FmsToast.show('Данные сохранены', 'ok');
          setPage('/cashbox/stat.s?id=${pat.id}');
        } else {
          FmsToast.show(res.msg, 'err');
        }
      }
    });
  }
  function setDisPerc() {
    $.ajax({
      url: '/cashbox/stat/setDisPerc.s',
      method: 'post',
      data: 'id=${pat.id}&perc=' + $('#diss_perc').val(),
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          FmsToast.show('Данные сохранены', 'ok');
          setPage('/cashbox/stat.s?id=${pat.id}');
        } else {
          FmsToast.show(res.msg, 'err');
        }
      }
    });
  }
</script>
<%-- ================= Касса стационара: новый вид =================
     Без акта левая карточка «Начисления» строится из прежних данных страницы (koykoTotal, epics, plans, fizios, planDetails, services, watchers).
     Кроме уже существующих атрибутов (pat, lv, serviceTotal, paidSum, discountSum, pays, discounts, operDay)
     контроллеру /cashbox/stat.s при actExist нужно положить данные акта:
       act         — сам акт (hn_patients): суммы берутся прямо из него — koykoSum, eatSum, drugSum, labSum, consulSum, kdoSum,
                     watcherSum, disSum, totalSum, paySum; плюс actNum, dateEnd, dayCount, koykoPrice, eatPrice
     Детализация строк акта на странице кассы не показывается, списки не нужны. --%>
<%-- В оплате по акту сумма к оплате и скидка берутся из акта (как на /act/info.s), иначе из прежнего расчёта кассы --%>
<c:set var="due" value="${serviceTotal}"/>
<c:set var="disShow" value="${actExist ? act.disSum : 0}"/>
<c:set var="isClosed" value="${pat.paid == 'CLOSED'}"/>

<style>
  .ca { --brand:#D7182E; --brand-dark:#A50F22; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    padding:16px 20px 32px; color:var(--text); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; font-size:14px; }
  .ca * { box-sizing:border-box; }
  .ca .card { background:#fff; border:1px solid var(--border); border-radius:14px; margin-bottom:14px; }
  .ca .num { font-variant-numeric:tabular-nums; white-space:nowrap; }

  /* Кнопки */
  .ca .ab { display:inline-flex; align-items:center; justify-content:center; gap:7px; height:36px; padding:0 14px; border-radius:9px; border:1px solid var(--border);
    background:#fff; color:var(--text); font-size:13.5px; font-weight:600; font-family:inherit; cursor:pointer; white-space:nowrap; text-decoration:none; }
  .ca .ab:hover { background:var(--bg); border-color:#D5D8DD; }
  .ca .ab.main { background:var(--brand); border-color:var(--brand); color:#fff; }
  .ca .ab.main:hover { background:var(--brand-dark); border-color:var(--brand-dark); }
  .ca .ab.sm { height:30px; padding:0 10px; font-size:12.5px; }
  .ca .ib { width:28px; height:28px; display:inline-flex; align-items:center; justify-content:center; border:0; border-radius:8px;
    background:none; color:#9AA1AC; cursor:pointer; font-size:14px; }
  .ca .ib:hover { background:#FDECEE; color:var(--brand); }

  /* Шапка */
  .ca-head { display:flex; align-items:center; gap:14px; padding:14px 18px; flex-wrap:wrap; }
  .ca-who { flex:1; min-width:260px; }
  .ca-who h2 { margin:0; font-size:19px; font-weight:700; line-height:1.25; }
  .ca-who .meta { margin-top:4px; font-size:13px; color:var(--muted); display:flex; gap:6px 14px; flex-wrap:wrap; align-items:center; }
  .ca .bdg { display:inline-block; padding:2px 9px; border-radius:10px; font-size:12px; font-weight:600; background:#F1F2F4; color:var(--muted); }
  .ca .bdg.act { background:#FEF3E2; color:#B45309; }
  .ca .bdg.ok { background:#E8F7EE; color:#15803D; }
  .ca-btns { display:flex; gap:8px; flex-wrap:wrap; }

  /* Реквизиты пациента */
  .ca-info { display:grid; grid-template-columns:repeat(auto-fill, minmax(170px, 1fr)); gap:12px 18px; padding:14px 18px 16px; border-top:1px solid var(--border); }
  .ca-info .f .l { font-size:11.5px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px; margin-bottom:3px; }
  .ca-info .f .v { font-size:14px; line-height:1.35; word-break:break-word; }
  .ca-info .f.wide { grid-column:span 2; }
  .ca-info .f .v.empty { color:#B5BAC2; }

  /* Две колонки */
  .ca-grid { display:grid; grid-template-columns:minmax(0, 1fr) 380px; gap:14px; align-items:start; }

  /* Состав акта */
  .ca-sec-h { display:flex; align-items:center; gap:10px; padding:14px 18px; border-bottom:1px solid var(--border); }
  .ca-sec-h h3 { margin:0; font-size:15px; font-weight:700; }
  .ca-sec-h .sp { flex:1; }
  .ca-sec-h .hint { font-size:12.5px; color:var(--muted); }
  .ca-stay { display:flex; gap:0; border-bottom:1px solid var(--border); }
  .ca-stay > div { flex:1; padding:12px 18px; border-left:1px solid var(--border); }
  .ca-stay > div:first-child { border-left:0; }
  .ca-stay .l { font-size:11.5px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px; }
  .ca-stay .v { margin-top:3px; font-size:16px; font-weight:700; }

  .ca-stay .v .u { font-size:13px; font-weight:500; color:var(--muted); }
  .ca .kd { display:flex; gap:6px; margin-top:3px; }
  .ca .kd-in { width:80px; height:30px; padding:0 8px; border:1px solid var(--border); border-radius:8px; font-size:15px; font-weight:700; font-family:inherit;
    text-align:center; color:var(--text); background-color:#fff; outline:none; box-shadow:none; }
  .ca .kd-in:focus { border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .ca .ln { display:flex; align-items:center; gap:10px; padding:12px 18px; border-bottom:1px solid var(--border); }
  .ca .ln .nm { font-weight:600; }
  .ca .ln .dots { flex:1; border-bottom:1px dotted #D5D8DD; margin:0 4px; transform:translateY(-3px); }
  .ca .ln .sum { font-weight:700; font-size:14.5px; }
  .ca .ln.zero, .ca .ln.zero .sum { color:#9AA1AC; font-weight:600; }
  .ca .card > .ca-total:not(:last-child) { border-radius:0; }
  .ca-total.disc-line { background:#E8F7EE; color:#15803D; border-top:1px solid #CDEBD8; }
  .ca-total.disc-line .v { font-size:16px; }
  .ca-due .disc-badge { display:inline-flex; align-items:center; gap:6px; margin-top:8px; padding:4px 10px; border-radius:8px; background:#E8F7EE; color:#15803D; font-size:13px; font-weight:600; }
  .ca-due .disc-badge b { font-weight:800; font-variant-numeric:tabular-nums; }
  .ca-due .rows .disc-k, .ca-due .rows .disc-v { color:#15803D; font-weight:700; }
  .ca details { border-bottom:1px solid var(--border); }
  .ca details:last-of-type { border-bottom:0; }
  .ca summary { list-style:none; display:flex; align-items:center; gap:10px; padding:12px 18px; cursor:pointer; user-select:none; }
  .ca summary::-webkit-details-marker { display:none; }
  .ca summary:hover { background:#FAFAFB; }
  .ca summary .chev { width:16px; color:#9AA1AC; font-size:12px; transition:transform .15s; text-align:center; }
  .ca details[open] summary .chev { transform:rotate(90deg); }
  .ca summary .nm { font-weight:600; }
  .ca summary .cnt { font-size:12px; color:var(--muted); background:#F1F2F4; border-radius:10px; padding:1px 8px; font-weight:600; }
  .ca summary .dots { flex:1; border-bottom:1px dotted #D5D8DD; margin:0 4px; transform:translateY(-3px); }
  .ca summary .sum { font-weight:700; font-size:14.5px; min-width:120px; text-align:right; }
  .ca summary .nds { font-size:12.5px; color:var(--muted); }
  .ca details.zero summary { cursor:default; color:#9AA1AC; }
  .ca details.flat summary { cursor:default; }
  .ca details.flat summary:hover { background:none; }
  .ca details.flat summary .chev { visibility:hidden; }
  .ca details.zero summary .sum { color:#9AA1AC; font-weight:600; }

  .ca table.lt { width:100%; border-collapse:collapse; margin:0 0 8px; }
  .ca table.lt th { padding:7px 18px; font-size:11.5px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px;
    text-align:right; background:#FAFAFB; border-top:1px solid var(--border); border-bottom:1px solid var(--border); white-space:nowrap; }
  .ca table.lt td { padding:8px 18px; border-bottom:1px solid #F0F1F3; text-align:right; font-variant-numeric:tabular-nums; white-space:nowrap; }
  .ca table.lt tr:last-child td { border-bottom:0; }
  .ca table.lt th:first-child, .ca table.lt td:first-child { text-align:left; white-space:normal; padding-left:44px; }
  .ca table.lt td.c, .ca table.lt th.c { text-align:center; }
  .ca table.lt td.b { font-weight:600; }
  .ca table.lt td.m { color:var(--muted); }

  .ca-total { display:flex; align-items:center; gap:10px; padding:14px 18px; border-top:1px solid var(--border); background:#FAFAFB; border-radius:0 0 14px 14px; }
  .ca-total .l { font-weight:700; }
  .ca-total .sp { flex:1; }
  .ca-total .v { font-size:18px; font-weight:800; }

  /* История операций */
  .ca table.ops { width:100%; border-collapse:collapse; }
  .ca table.ops th { padding:8px 14px; font-size:11.5px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px;
    text-align:right; background:#FAFAFB; border-bottom:1px solid var(--border); white-space:nowrap; }
  .ca table.ops td { padding:9px 14px; border-bottom:1px solid #F0F1F3; text-align:right; font-variant-numeric:tabular-nums; white-space:nowrap; }
  .ca table.ops tr:last-child td { border-bottom:0; }
  .ca table.ops th:first-child, .ca table.ops td:first-child { text-align:left; }
  .ca table.ops .c { text-align:center; }
  .ca table.ops td.z { color:#C3C7CE; }
  .ca table.ops a { color:inherit; text-decoration:underline dotted; }
  .ca .tp { display:inline-block; padding:2px 8px; border-radius:10px; font-size:12px; font-weight:600; }
  .ca .tp.pay { background:#E8F7EE; color:#15803D; }
  .ca .tp.ret { background:#FDECEE; color:var(--brand); }
  .ca .tp.dis { background:#F1F2F4; color:var(--muted); }
  .ca .empty-row { padding:22px; text-align:center; color:var(--muted); font-size:13.5px; }

  /* Касса (правая колонка) */
  .ca-pay { position:sticky; top:10px; }
  .ca-due { padding:16px 18px 14px; }
  .ca-due .l { font-size:12px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px; }
  .ca-due .big { margin-top:4px; font-size:30px; font-weight:800; line-height:1.1; }
  .ca-due .big.ret { color:var(--brand); }
  .ca-due .big.done { color:#15803D; }
  .ca-due .rows { margin-top:12px; display:grid; grid-template-columns:1fr auto; gap:6px 12px; font-size:13.5px; }
  .ca-due .rows .k { color:var(--muted); }
  .ca-due .rows .v { text-align:right; font-weight:600; font-variant-numeric:tabular-nums; }
  .ca-due .rows .line { grid-column:1 / -1; border-top:1px solid var(--border); margin:2px 0; }
  .ca-due .disc { margin-top:12px; display:flex; align-items:center; gap:10px; font-size:13px; color:var(--muted); }
  .ca-due .disc select { flex:1; height:34px; border:1px solid var(--border); border-radius:9px; padding:0 8px; font-family:inherit; font-size:13.5px; color:var(--text); background-color:#fff; }

  .ca-form { border-top:1px solid var(--border); padding:14px 18px 16px; }
  .ca .nav-tabs.seg { list-style:none; display:flex; border:0; background:#F1F2F4; border-radius:10px; padding:3px; margin:0 0 12px; }
  .ca .nav-tabs.seg > li { flex:1; float:none; margin:0; }
  .ca .nav-tabs.seg > li > a { display:block; margin:0; padding:7px 6px; border:0 !important; border-radius:8px; text-align:center;
    color:var(--muted); font-size:13px; font-weight:600; background:none; line-height:1.2; text-decoration:none; }
  .ca .nav-tabs.seg > li.active > a, .ca .nav-tabs.seg > li.active > a:hover, .ca .nav-tabs.seg > li.active > a:focus { background:#fff; color:var(--text); box-shadow:0 1px 2px rgba(20,25,40,.08); }
  .ca .tab-content > .tab-pane { display:none; }
  .ca .tab-content > .active { display:block; }

  .ca .pm { display:flex; align-items:center; gap:10px; padding:6px 0; }
  .ca .pm label { flex:none; width:128px; display:flex; align-items:center; gap:8px; margin:0; font-weight:600; font-size:13.5px; cursor:pointer; }
  .ca .pm label input { width:16px; height:16px; margin:0; accent-color:#1F2430; }
  .ca .pm input.in { flex:1; min-width:0; height:40px; padding:0 12px; border:1px solid var(--border); border-radius:9px; font-size:17px; font-weight:600;
    font-family:inherit; text-align:right; color:var(--text); background-color:#fff; outline:none; box-shadow:none; font-variant-numeric:tabular-nums; }
  .ca .pm input.in:focus { border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .ca .pm input.in[readonly] { background-color:#F8F9FA; color:#9AA1AC; }
  .ca .pm.tot { margin-top:6px; padding-top:10px; border-top:1px dashed var(--border); }
  .ca .pm.tot label { cursor:default; }
  .ca .pm.tot input.in, .ca .pm.tot input.in[readonly] { background-color:#fff; color:var(--text); font-size:20px; font-weight:800; border-color:transparent; }
  .ca-actions { display:flex; gap:8px; margin-top:12px; }
  .ca-actions .ab { flex:1; height:40px; }
  .ca .disc-list { margin:0 -18px; }
  .ca .disc-list table.ops td, .ca .disc-list table.ops th { padding-left:18px; padding-right:18px; }
  .ca .disc-list td.t { white-space:normal; text-align:left; color:var(--muted); font-size:13px; }
  .ca .ca-note { padding:14px 18px; border-top:1px solid var(--border); font-size:13.5px; color:var(--muted); display:flex; gap:8px; align-items:center; }

  @media (max-width: 1100px) { .ca-grid { grid-template-columns:1fr; } .ca-pay { position:static; } }
</style>

<div class="ca">
  <!-- ================= Шапка и реквизиты пациента ================= -->
  <div class="card">
    <div class="ca-head">
      <div class="ca-who">
        <h2>${pat.surname} ${pat.name} ${pat.middlename}</h2>
        <div class="meta">
          <span>ИБ № ${pat.yearNum}</span>
          <span>ID ${pat.id}</span>
          <c:if test="${actExist}"><span class="bdg act">Оплата по акту</span></c:if>
          <c:if test="${actExist && not empty act.actNum}"><span>Акт № ${act.actNum}</span></c:if>
          <c:if test="${actExist && not empty act.dateEnd}"><span>выписка <fmt:formatDate pattern="dd.MM.yyyy" value="${act.dateEnd}"/></span></c:if>
          <c:if test="${isClosed}"><span class="bdg">ИБ закрыта</span></c:if>
        </div>
      </div>
      <div class="ca-btns">
        <c:if test="${pat.paid != 'CLOSED' && due <= 1}">
          <button type="button" class="ab" onclick="closeIB()" title="Закрыть историю болезни"><i class="fa fa-lock"></i> Закрыть ИБ</button>
        </c:if>
        <button type="button" class="ab" onclick="setPage('/patients/list.s')"><i class="fa fa-times"></i> Закрыть</button>
      </div>
    </div>
    <div class="ca-info">
      <div class="f"><div class="l">Год рождения</div><div class="v">${pat.birthyear}</div></div>
      <div class="f"><div class="l">Пол</div><div class="v">${pat.sex.name}</div></div>
      <div class="f"><div class="l">Телефон</div><div class="v num">${pat.tel}</div></div>
      <div class="f"><div class="l">Гражданство</div><div class="v">${country}</div></div>
      <div class="f"><div class="l">Отделение</div><div class="v">${pat.dept.name}</div></div>
      <div class="f"><div class="l">Палата</div><div class="v">${pat.room.name}<c:if test="${not empty pat.room.roomType.name}"> · ${pat.room.roomType.name}</c:if></div></div>
      <div class="f"><div class="l">Лечащий врач</div><div class="v">${lv.fio}</div></div>
      <div class="f"><div class="l">Способ оплаты</div><div class="v">${pat.pay_type}</div></div>
      <div class="f wide"><div class="l">Диагноз при поступлении</div><div class="v">${pat.diagnoz}</div></div>
    </div>
  </div>

  <div class="ca-grid">
    <!-- ================= Левая колонка: состав (акт или начисления) и история ================= -->
    <div>
      <c:choose>
        <c:when test="${actExist}">
          <div class="card">
            <div class="ca-sec-h"><h3>Состав акта</h3></div>
            <div class="ca-stay">
              <div><div class="l">Койко-дней</div><div class="v num">${act.dayCount}</div></div>
              <div><div class="l">Койка в сутки</div><div class="v num"><fmt:formatNumber value="${act.koykoPrice}" type="number"/></div></div>
              <div><div class="l">Питание в сутки</div><div class="v num"><fmt:formatNumber value="${act.eatPrice}" type="number"/></div></div>
              <div><div class="l">Стоимость койки</div><div class="v num"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${act.koykoSum}" type="number"/></div></div>
            </div>
            <c:if test="${act.eatSum > 0}">
              <div class="ln<c:if test="${empty act.eatSum || act.eatSum == 0}"> zero</c:if>"><span class="nm">Питание</span><span class="dots"></span><span class="sum num"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${act.eatSum}" type="number"/></span></div>
            </c:if>
            <div class="ln<c:if test="${empty act.drugSum || act.drugSum == 0}"> zero</c:if>"><span class="nm">Медикаменты</span><span class="dots"></span><span class="sum num"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${act.drugSum}" type="number"/></span></div>
            <div class="ln<c:if test="${empty act.labSum || act.labSum == 0}"> zero</c:if>"><span class="nm">Лабораторные исследования</span><span class="dots"></span><span class="sum num"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${act.labSum}" type="number"/></span></div>
            <div class="ln<c:if test="${empty act.consulSum || act.consulSum == 0}"> zero</c:if>"><span class="nm">Узкие специалисты</span><span class="dots"></span><span class="sum num"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${act.consulSum}" type="number"/></span></div>
            <div class="ln<c:if test="${empty act.kdoSum || act.kdoSum == 0}"> zero</c:if>"><span class="nm">Медицинские услуги</span><span class="dots"></span><span class="sum num"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${act.kdoSum}" type="number"/></span></div>
            <c:if test="${act.watcherSum > 0}">
              <div class="ln<c:if test="${empty act.watcherSum || act.watcherSum == 0}"> zero</c:if>"><span class="nm">Дополнительное спальное место</span><span class="dots"></span><span class="sum num"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${act.watcherSum}" type="number"/></span></div>
            </c:if>
            <div class="ca-total">
              <span class="l">Сумма по акту</span><span class="sp"></span>
              <span class="v num"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${act.totalSum}" type="number"/></span>
            </div>
            <c:if test="${act.disSum > 0}">
              <div class="ca-total disc-line">
                <span class="l"><i class="fa fa-tag"></i> Скидка<c:if test="${pat.dis_perc > 0}"> <span style="font-weight:500">(в т.ч. ${pat.dis_perc}% от койки)</span></c:if></span><span class="sp"></span>
                <span class="v num">− <fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${act.disSum}" type="number"/></span>
              </div>
            </c:if>
          </div>
        </c:when>
        <c:otherwise>
          <%-- Обычная оплата (без акта): начисления из данных страницы --%>
          <c:set var="sSvc" value="${0}"/><c:forEach items="${services}" var="r"><c:set var="sSvc" value="${sSvc + r.total}"/></c:forEach>
          <c:set var="sWatchOld" value="${0}"/><c:forEach items="${watchers}" var="r"><c:set var="sWatchOld" value="${sWatchOld + r.total}"/></c:forEach>
          <c:set var="sEpicOld" value="${0}"/><c:forEach items="${epics}" var="r"><c:set var="sEpicOld" value="${sEpicOld + r.c3}"/></c:forEach>
          <c:set var="sOther" value="${0}"/><c:set var="nOther" value="${0}"/>
          <c:forEach items="${plans}" var="r"><c:if test="${r.price > 0}"><c:set var="sOther" value="${sOther + r.price}"/><c:set var="nOther" value="${nOther + 1}"/></c:if></c:forEach>
          <c:forEach items="${fizios}" var="r"><c:if test="${r.price * (r.counter == null ? 0 : r.counter) > 0}"><c:set var="sOther" value="${sOther + r.price * r.counter}"/><c:set var="nOther" value="${nOther + 1}"/></c:if></c:forEach>
          <c:forEach items="${planDetails}" var="r"><c:if test="${r.price > 0}"><c:set var="sOther" value="${sOther + r.price}"/><c:set var="nOther" value="${nOther + 1}"/></c:if></c:forEach>
          <div class="card">
            <div class="ca-sec-h">
              <h3>Начисления</h3>
              <span class="sp"></span>
              <span class="hint">нажмите на строку, чтобы раскрыть</span>
            </div>
            <div class="ca-stay">
              <div>
                <div class="l">Койко-дней</div>
                <c:choose>
                  <c:when test="${pat.paid != 'CLOSED'}">
                    <div class="kd">
                      <input type="number" class="kd-in" id="koyko-days" value="${pat.dayCount}">
                      <button type="button" class="ab sm" onclick="saveKoyko()" title="Сохранить количество койко-дней">Сохранить</button>
                    </div>
                  </c:when>
                  <c:otherwise><div class="v num">${pat.dayCount}</div></c:otherwise>
                </c:choose>
              </div>
              <div><div class="l">К оплате за койку</div><div class="v num">${pat.dayCount - minusDays}<span class="u"> дн. · ${pat.room.roomType.name}</span></div></div>
              <div><div class="l">Сумма за койку</div><div class="v num"><fmt:formatNumber value="${koykoTotal}" type="number"/></div></div>
            </div>

            <c:if test="${fn:length(epics) > 0}">
              <details>
                <summary><i class="fa fa-chevron-right chev"></i><span class="nm">Койко-дни по отделениям</span><span class="cnt">${fn:length(epics)}</span><span class="dots"></span>
                  <span class="sum num"><fmt:formatNumber value="${sEpicOld}" type="number"/></span></summary>
                <table class="lt">
                  <tr><th>Койко-дней</th><th>Сумма</th></tr>
                  <c:forEach items="${epics}" var="epic">
                    <tr><td>${epic.c1} ${epic.c2}</td><td class="b"><fmt:formatNumber value="${epic.c3}" type="number"/></td></tr>
                  </c:forEach>
                </table>
              </details>
            </c:if>

            <c:if test="${nOther > 0}">
              <details>
                <summary><i class="fa fa-chevron-right chev"></i><span class="nm">Обследования и процедуры</span><span class="cnt">${nOther}</span><span class="dots"></span>
                  <span class="sum num"><fmt:formatNumber value="${sOther}" type="number"/></span></summary>
                <table class="lt">
                  <tr><th>Наименование</th><th class="c">Дата</th><th>Цена</th></tr>
                  <c:forEach items="${plans}" var="plan">
                    <c:if test="${plan.price > 0}">
                      <tr><td>${plan.kdo.name}</td><td class="c m"><fmt:formatDate pattern="dd.MM.yyyy" value="${plan.actDate}"/></td>
                        <td class="b"><fmt:formatNumber value="${plan.price}" type="number"/></td></tr>
                    </c:if>
                  </c:forEach>
                  <c:forEach items="${fizios}" var="fizio">
                    <c:if test="${fizio.price * (fizio.counter == null ? 0 : fizio.counter) > 0}">
                      <tr><td>${fizio.c1} <span class="m">× ${fizio.counter == null ? 0 : fizio.counter}</span></td><td class="c m">${fizio.c2}</td>
                        <td class="b"><fmt:formatNumber value="${fizio.price * (fizio.counter == null ? 0 : fizio.counter)}" type="number"/></td></tr>
                    </c:if>
                  </c:forEach>
                  <c:forEach items="${planDetails}" var="det">
                    <c:if test="${det.price > 0}">
                      <tr><td>${det.c1}</td><td class="c m">${det.date}</td>
                        <td class="b"><fmt:formatNumber value="${det.price}" type="number"/></td></tr>
                    </c:if>
                  </c:forEach>
                </table>
              </details>
            </c:if>

            <c:if test="${fn:length(services) > 0}">
              <details>
                <summary><i class="fa fa-chevron-right chev"></i><span class="nm">Услуги</span><span class="cnt">${fn:length(services)}</span><span class="dots"></span>
                  <span class="sum num"><fmt:formatNumber value="${sSvc}" type="number"/></span></summary>
                <table class="lt">
                  <tr><th>Услуга</th><th class="c">Кол-во</th><th>Сумма</th></tr>
                  <c:forEach items="${services}" var="service">
                    <tr><td>${service.kdo.name}</td><td class="c">${service.count}</td>
                      <td class="b"><fmt:formatNumber value="${service.total}" type="number"/></td></tr>
                  </c:forEach>
                </table>
              </details>
            </c:if>

            <c:if test="${fn:length(watchers) > 0}">
              <details>
                <summary><i class="fa fa-chevron-right chev"></i><span class="nm">Дополнительное спальное место</span><span class="cnt">${fn:length(watchers)}</span><span class="dots"></span>
                  <span class="sum num"><fmt:formatNumber value="${sWatchOld}" type="number"/></span></summary>
                <table class="lt">
                  <tr><th>Место</th><th class="c">Дней</th><th>Сумма</th><th class="c" style="width:50px"></th></tr>
                  <c:forEach items="${watchers}" var="watcher" varStatus="loop">
                    <tr><td>Место ${loop.index + 1}</td><td class="c">${watcher.dayCount}</td>
                      <td class="b"><fmt:formatNumber value="${watcher.total}" type="number"/></td>
                      <td class="c"><c:if test="${pat.paid != 'CLOSED'}"><button type="button" class="ib" title="Удалить" onclick="delWatcher(${watcher.id})"><i class="fa fa-trash-o"></i></button></c:if></td></tr>
                  </c:forEach>
                </table>
              </details>
            </c:if>

            <div class="ca-total">
              <span class="l">Осталось к оплате</span><span class="sp"></span>
              <span class="v num"><fmt:formatNumber value="${serviceTotal}" type="number"/></span>
            </div>
          </div>
        </c:otherwise>
      </c:choose>

      <!-- История оплат, возвратов и скидок -->
      <div class="card">
        <div class="ca-sec-h"><h3>Операции по кассе</h3></div>
        <c:choose>
          <c:when test="${fn:length(pays) > 0 || fn:length(discounts) > 0}">
            <table class="ops">
              <tr><th>Тип</th><th class="c">Дата</th><th>Наличные</th><th>Карта</th><th>Online</th><th>Перечисление</th><th class="c" style="width:50px"></th></tr>
              <c:forEach items="${pays}" var="pay">
                <tr>
                  <td><c:choose><c:when test="${pay.payType == 'ret'}"><span class="tp ret">Возврат</span></c:when><c:otherwise><span class="tp pay">Оплата</span></c:otherwise></c:choose></td>
                  <td class="c"><fmt:formatDate pattern="dd.MM.yyyy" value="${pay.crOn}"/></td>
                  <td class="<c:if test="${empty pay.cash || pay.cash == 0}">z</c:if>"><fmt:formatNumber value="${pay.cash}" type="number"/></td>
                  <td class="<c:if test="${empty pay.card || pay.card == 0}">z</c:if>"><fmt:formatNumber value="${pay.card}" type="number"/></td>
                  <td class="<c:if test="${empty pay.online || pay.online == 0}">z</c:if>"><fmt:formatNumber value="${pay.online}" type="number"/></td>
                  <td class="<c:if test="${empty pay.transfer || pay.transfer == 0}">z</c:if>"><fmt:formatNumber value="${pay.transfer}" type="number"/></td>
                  <td class="c"><c:if test="${pat.paid != 'CLOSED'}"><button type="button" class="ib" title="Удалить оплату" onclick="delCashOper(${pay.id})"><i class="fa fa-trash-o"></i></button></c:if></td>
                </tr>
              </c:forEach>
              <c:forEach items="${discounts}" var="discount">
                <tr>
                  <td><span class="tp dis">Скидка</span></td>
                  <td class="c"><a href="#" onclick="addEditDiscount(${discount.id});return false" title="Редактировать"><fmt:formatDate pattern="dd.MM.yyyy" value="${discount.crOn}"/></a></td>
                  <td colspan="4"><fmt:formatNumber value="${discount.summ}" type="number"/></td>
                  <td class="c"><c:if test="${pat.paid != 'CLOSED'}"><button type="button" class="ib" title="Удалить скидку" onclick="delDiscount(${discount.id})"><i class="fa fa-trash-o"></i></button></c:if></td>
                </tr>
              </c:forEach>
            </table>
          </c:when>
          <c:otherwise><div class="empty-row">Операций пока нет</div></c:otherwise>
        </c:choose>
      </div>
    </div>

    <!-- ================= Правая колонка: касса ================= -->
    <div class="card ca-pay">
      <div class="ca-due">
        <c:choose>
          <c:when test="${due < 0}">
            <div class="l">К возврату</div>
            <div class="big ret num" id="totalSumSpan"><fmt:formatNumber value="${-due}" type="number"/></div>
          </c:when>
          <c:when test="${due == 0}">
            <div class="l">К оплате</div>
            <div class="big done num" id="totalSumSpan">0</div>
          </c:when>
          <c:otherwise>
            <div class="l">К оплате</div>
            <div class="big num" id="totalSumSpan"><fmt:formatNumber value="${due}" type="number"/></div>
          </c:otherwise>
        </c:choose>
        <c:if test="${disShow > 0}">
          <div class="disc-badge"><i class="fa fa-tag"></i> Учтена скидка <b><fmt:formatNumber value="${disShow}" type="number"/></b></div>
        </c:if>
        <div class="rows">
          <c:if test="${actExist}"><span class="k">Сумма по акту</span><span class="v"><fmt:formatNumber value="${act.totalSum}" type="number"/></span></c:if>
          <c:if test="${disShow != 0}"><span class="k disc-k"><i class="fa fa-tag"></i> Скидка</span><span class="v disc-v">− <fmt:formatNumber value="${disShow}" type="number"/></span></c:if>
          <c:if test="${discountSum != 0}"><span class="k disc-k"><i class="fa fa-tag"></i> Скидка кассы</span><span class="v disc-v">− <fmt:formatNumber value="${discountSum}" type="number"/></span></c:if>
          <span class="k">Оплачено</span><span class="v"><fmt:formatNumber value="${paidSum}" type="number"/></span>
          <span class="line"></span>
          <c:if test="${not actExist}"><span class="k">Итого с учётом оплат</span><span class="v"><fmt:formatNumber value="${paidSum + serviceTotal}" type="number"/></span></c:if>
        </div>
        <div class="disc">
          <span>Скидка от койки</span>
          <c:choose>
            <c:when test="${pat.paid != 'CLOSED'}">
              <select id="diss_perc" onchange="setDisPerc(this.value)">
                <option <c:if test="${pat.dis_perc == 0 || pat.dis_perc == null}">selected</c:if> value="0">Без скидки</option>
                <option <c:if test="${pat.dis_perc == 3}">selected</c:if> value="3">3%</option>
                <option <c:if test="${pat.dis_perc == 4}">selected</c:if> value="4">4%</option>
                <option <c:if test="${pat.dis_perc == 5}">selected</c:if> value="5">5%</option>
                <option <c:if test="${pat.dis_perc == 10}">selected</c:if> value="10">10%</option>
              </select>
            </c:when>
            <c:otherwise><b style="color:#1F2430">${pat.dis_perc}%</b></c:otherwise>
          </c:choose>
        </div>
      </div>

      <c:choose>
        <c:when test="${due != 0 && pat.paid != 'CLOSED'}">
          <div class="ca-form">
            <input name="pay_type" id="pay_type" type="hidden" value="<c:if test="${due > 0}">pay</c:if><c:if test="${(due == 0 && paidSum > 0) || due < 0}">ret</c:if>"/>
            <ul class="nav nav-tabs seg">
              <c:if test="${due > 0}">
                <li class="active"><a href="#pager" onclick="setPayType('pay')" data-toggle="tab" aria-expanded="true">Оплата</a></li>
              </c:if>
              <c:if test="${paidSum != 0}">
                <li class="<c:if test="${(due == 0 && paidSum > 0) || due < 0}">active</c:if>"><a href="#pager" onclick="setPayType('ret')" data-toggle="tab" aria-expanded="true">Возврат</a></li>
              </c:if>
              <c:if test="${due > 0}">
                <li><a href="#discount" onclick="setPayType('discount')" data-toggle="tab" aria-expanded="false">Скидки</a></li>
              </c:if>
            </ul>
            <div class="tab-content">
              <div class="tab-pane active fade in" id="pager">
                <div class="pm"><label><input type="checkbox" id="cashCheck" tabindex="-1" onclick="setPay('cash', this)"/> Наличные</label>
                  <input class="in" id="cashInput" onblur="calcSum(this)" type="number" readonly/></div>
                <div class="pm"><label><input type="checkbox" id="cardCheck" tabindex="-1" onchange="setPay('card', this)"/> Карта</label>
                  <input class="in" id="cardInput" onblur="calcSum(this)" type="number" value="" readonly/></div>
                <div class="pm"><label><input type="checkbox" id="onlineCheck" tabindex="-1" onclick="setPay('online', this)"/> Online</label>
                  <input class="in" id="onlineInput" onblur="calcSum(this)" type="number" readonly/></div>
                <div class="pm"><label><input type="checkbox" id="transferCheck" tabindex="-1" onclick="setPay('transfer', this)"/> Перечисление</label>
                  <input class="in" id="transferInput" onblur="calcSum(this)" type="number" readonly/></div>
                <div class="pm tot"><label>Итого</label>
                  <input class="in" id="totalInput" readonly value="0"/></div>
                <div class="ca-actions">
                  <button type="button" class="ab" onclick="calcTotal()" title="Отметьте способы оплаты, заполните все кроме одного, остаток посчитается"><i class="fa fa-calculator"></i> Рассчитать</button>
                  <button type="button" class="ab main" onclick="saveForm()"><i class="fa fa-check"></i> Провести</button>
                </div>
              </div>
              <div class="tab-pane fade" id="discount">
                <div class="disc-list">
                  <c:choose>
                    <c:when test="${fn:length(discounts) > 0}">
                      <table class="ops">
                        <tr><th class="c">Дата</th><th style="text-align:left">Описание</th><th>Сумма</th><th class="c" style="width:44px"></th></tr>
                        <c:forEach items="${discounts}" var="discount">
                          <tr style="cursor:pointer" ondblclick="addEditDiscount(${discount.id})" title="${discount.crBy.fio}">
                            <td class="c"><fmt:formatDate pattern="dd.MM.yyyy" value="${discount.crOn}"/></td>
                            <td class="t">${discount.text}</td>
                            <td><b><fmt:formatNumber value="${discount.summ}" type="number"/></b></td>
                            <td class="c"><button type="button" class="ib" title="Удалить" onclick="delDiscount(${discount.id})"><i class="fa fa-trash-o"></i></button></td>
                          </tr>
                        </c:forEach>
                      </table>
                    </c:when>
                    <c:otherwise><div class="empty-row">Скидок нет</div></c:otherwise>
                  </c:choose>
                </div>
                <div class="ca-actions">
                  <button type="button" class="ab" id="discount_add" onclick="addEditDiscount(0);return false"><i class="fa fa-plus"></i> Добавить скидку</button>
                </div>
              </div>
            </div>
          </div>
        </c:when>
        <c:when test="${pat.paid == 'CLOSED'}">
          <div class="ca-note"><i class="fa fa-lock"></i> История болезни закрыта, касса только для просмотра.</div>
        </c:when>
        <c:otherwise>
          <div class="ca-note"><i class="fa fa-check-circle" style="color:#15803D"></i> Акт полностью оплачен.</div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>


<!-- Add Edit Discount -->
<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog" style="width:460px">
    <div class="modal-content ca" style="border:0; border-radius:16px; padding:0">
      <div style="display:flex; align-items:center; padding:14px 18px; border-bottom:1px solid #E6E8EC">
        <h4 id="myModalLabel" style="margin:0; flex:1; font-size:15px; font-weight:700">Скидка</h4>
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
      </div>
      <form id="addEditForm" name="addEditForm" onsubmit="saveDiscount(); return false" style="padding:16px 18px; display:flex; flex-direction:column; gap:12px">
        <input type="hidden" name="id" value="" />
        <input type="hidden" name="code" value="STAT" />
        <input type="hidden" name="patient" value="${pat.id}" />
        <div>
          <label style="display:block; font-size:12px; font-weight:600; color:#6B7280; margin-bottom:5px">Сумма скидки *</label>
          <input type="number" class="form-control" style="text-align:right; height:38px; border-radius:9px" maxlength="20" name="summ" min="0"/>
        </div>
        <div>
          <label style="display:block; font-size:12px; font-weight:600; color:#6B7280; margin-bottom:5px">Описание</label>
          <textarea class="form-control" style="border-radius:9px" name="text" maxlength="200" rows="3"></textarea>
        </div>
      </form>
      <div style="display:flex; justify-content:flex-end; gap:8px; padding:12px 18px; border-top:1px solid #E6E8EC; background:#FAFBFC; border-radius:0 0 16px 16px">
        <button type="button" class="ab" id="close-modal" data-dismiss="modal">Отмена</button>
        <button type="button" class="ab main" onclick="saveDiscount()"><i class="fa fa-floppy-o"></i> Сохранить</button>
      </div>
    </div>
  </div>
</div>

<script>
  var totalSum = ${due}, paidSum = ${paidSum}, discountSumm = ${discountSum}, payType = '';
  const operDay = '<fmt:formatDate pattern = "dd.MM.yyyy" value = "${operDay}" />';
  function setPay(type, dom) {
    var elem = document.getElementById(type + 'Input');
    if (dom.checked) {
      elem.removeAttribute("readonly");
    } else {
      dom.removeAttribute("checked");
      elem.setAttribute("readonly", "true");
      elem.value = '';
    }
  }
  function calcTotal(){
    var total = document.getElementById("totalInput"),
      card = document.getElementById('cardInput'),
      cash = document.getElementById('cashInput'),
      online = document.getElementById('onlineInput'),
      transfer = document.getElementById('transferInput');
    var sum = 0;
    var cCard = document.getElementById("cardCheck"),
      cCash = document.getElementById("cashCheck"),
      cOnline = document.getElementById("onlineCheck"),
      cTransfer = document.getElementById("transferCheck");
    var checkedCount = 0, valueCount = 0;
    if (card.value !== '') {valueCount++; sum = parseFloat(card.value);}
    if (cash.value !== '') {valueCount++; sum += parseFloat(cash.value);}
    if (online.value !== '') {valueCount++; sum += parseFloat(online.value);}
    if (transfer.value !== '') {valueCount++; sum += parseFloat(transfer.value);}
    if (cCard.checked) checkedCount++;
    if (cCash.checked) checkedCount++;
    if (cOnline.checked) checkedCount++;
    if (cTransfer.checked) checkedCount++;
    if (valueCount + 1 !== checkedCount) {
      FmsToast.show('Есть не заполненные поля', 'err');
      return;
    }
    if (cCard.checked && card.value === '') card.value = totalSum - sum;
    if (cCash.checked && cash.value === '') cash.value = totalSum - sum;
    if (cOnline.checked && online.value === '') online.value = totalSum - sum;
    if (cTransfer.checked && transfer.value === '') transfer.value = totalSum - sum;
    total.value = totalSum;

  }
  function calcSum(elem) {
    try {
      payType = $('#pay_type').val();
      var total = document.getElementById("totalInput");
      var card = document.getElementById('cardInput'),
        cash = document.getElementById('cashInput'),
        online = document.getElementById('onlineInput'),
        transfer = document.getElementById('transferInput');
      var sum = 0;
      total.style.border = '1px solid #eee';
      total.style.color = 'black';
      total.title = 'Сумма оплаты';
      if (card.value !== '') sum = parseFloat(card.value);
      if (cash.value !== '') sum += parseFloat(cash.value);
      if (online.value !== '') sum += parseFloat(online.value);
      if (transfer.value !== '') sum += parseFloat(transfer.value);
      //
      if(payType !== 'pay') {
        if(sum > paidSum) {
          if (elem != null) elem.value = 0;
          FmsToast.show('Итоговая сумма возврата не может быть больше оплаченной!', 'err');
          return;
        }
      }
      //
      if (payType === 'pay' && sum > totalSum) {
        if (elem != null) {
          elem.value = 0;
        }
        FmsToast.show('ИТОГО не может быть больше суммы к оплате', 'err');
        total.style.border = '1px solid red';
        total.style.color = 'red';
        total.title = 'Сумма оплаты больше ожидаемого';
      }
      document.getElementById("totalInput").value = sum;
    } catch (e) {
      FmsToast.show('Проверьте правильности ввода цифр', 'err');
      document.getElementById("totalInput").value = '0';
    }
  }
  function saveForm() {
    payType = $('#pay_type').val();
    var card = document.getElementById('cardInput'),
      cash = document.getElementById('cashInput'),
      online = document.getElementById('onlineInput'),
      transfer = document.getElementById('transferInput');
    var sum = 0, params = 'id=${pat.id}&pay_type=' + payType + '&';
    if (card.value !== '') {sum += parseFloat(card.value); params += 'card=' + card.value + '&';}
    if (cash.value !== '') {sum += parseFloat(cash.value); params += 'cash=' + cash.value + '&';}
    if (online.value !== '') {sum += parseFloat(online.value); params += 'online=' + online.value + '&';}
    if (transfer.value !== '') {sum += parseFloat(transfer.value); params += 'transfer=' + transfer.value + '&';}
    if (payType === 'pay' && totalSum === 0) {
      FmsToast.show('Сумма не верна. Проверьте правильности итоговой суммы', 'err');
      return;
    }
    $.ajax({
      url: "/cashbox/stat.s",
      method: "post",
      data: params,
      dataType: 'json',
      success: function (json) {
        if (json.success) {
          FmsToast.show('Данные сохранены', 'ok');
          setPage('/cashbox/stat.s?id=' + json.id);
        } else {
          FmsToast.show(json.msg, 'err')
        }
      },
      error: function (data, err) {
        FmsToast.show('Ошибка: ' + err, 'err');
      }
    });
  }
  function setPlanState(code, id){
    $.ajax({
      url: "/reg/stat/cashPlanState.s",
      method: "post",
      data: 'id=' + id + '&code=' + code,
      dataType: 'json',
      success: function (json) {
        if (json.success) {
          FmsToast.show('Данные сохранены', 'ok');
          setPage('/cashbox/stat.s?id=${pat.id}');
        } else {
          FmsToast.show(json.msg, 'err')
        }
      },
      error: function (data, err) {
        FmsToast.show('Ошибка: ' + err, 'err');
      }
    });
  }
  function setFizioState(code, id){
    $.ajax({
      url: "/cashbox/cashFizioState.s",
      method: "post",
      data: 'id=' + id + '&code=' + code,
      dataType: 'json',
      success: function (json) {
        if (json.success) {
          FmsToast.show('Данные сохранены', 'ok');
          setPage('/cashbox/stat.s?id=${pat.id}');
        } else {
          FmsToast.show(json.msg, 'err')
        }
      },
      error: function (data, err) {
        FmsToast.show('Ошибка: ' + err, 'err');
      }
    });
  }
  function setPayType(type) {
    if(type === 'discount')
      $('#discount_add').show();
    else
      $('#discount_add').hide();
    payType = type;
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
            $('*[name=id]').val(res.id);
            $('*[name=summ]').val(res.summ);
            $('*[name=text]').val(res.text);
          } else {
            FmsToast.show(res.msg, 'err');
          }
        }
      });
    }
  }
  function saveDiscount() {
    try {
      var discountSum = parseFloat($('*[name=summ]').val());
      if(discountSum + discountSumm > totalSum || discountSum === 0) {
        FmsToast.show('Сумма скидки не может превышать сумму к оплате', 'err');
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
            FmsToast.show('Данные сохранены', 'ok');
            setPage('/cashbox/stat.s?id=${pat.id}');
          } else {
            FmsToast.show(json.msg, 'err')
          }
        },
        error: function (data, err) {
          FmsToast.show('Ошибка: ' + err, 'err');
        }
      });
    } catch (e) {
      FmsToast.show('Проверьте правильности ввода', 'err');
    }
  }
  function delDiscount(id) {
    $.ajax({
      url: '/cashbox/delDiscount.s',
      method: "post",
      data: 'id=' + id,
      dataType: 'json',
      success: function (json) {
        if (json.success) {
          FmsToast.show('Данные сохранены', 'ok');
          setPage('/cashbox/stat.s?id=${pat.id}');
        } else {
          FmsToast.show(json.msg, 'err')
        }
      },
      error: function (data, err) {
        FmsToast.show('Ошибка: ' + err, 'err');
      }
    });
  }
  function delCashOper(id) {
    FmsConfirm('Вы действительно хотите удалить оплату?', function () { $.ajax({
        url: '/cashbox/stat/delPay.s',
        method: "post",
        data: 'id=' + id,
        dataType: 'json',
        success: function (json) {
          if (json.success) {
            FmsToast.show('Данные сохранены', 'ok');
            setPage('/cashbox/stat.s?id=${pat.id}');
          } else {
            FmsToast.show(json.msg, 'err')
          }
        },
        error: function (data, err) {
          FmsToast.show('Ошибка: ' + err, 'err');
        }
      }); });
  }
  function delWatcher(id) {
    FmsConfirm('Вы действительно хотите удалить?', function () { $.ajax({
        url: '/cashbox/stat/delWatcher.s',
        method: "post",
        data: 'id=' + id,
        dataType: 'json',
        success: function (json) {
          if (json.success) {
            FmsToast.show('Данные сохранены', 'ok');
            setPage('/cashbox/stat.s?id=${pat.id}');
          } else {
            FmsToast.show(json.msg, 'err')
          }
        },
        error: function (data, err) {
          FmsToast.show('Ошибка: ' + err, 'err');
        }
      }); });
  }
</script>
