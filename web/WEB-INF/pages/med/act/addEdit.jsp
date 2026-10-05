<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/js/common.js" type="text/javascript"></script>
<script src="/res/js/fms-calendar.js" type="text/javascript"></script>
<style>
  .act { --brand:#D7182E; --brand-dark:#A50F22; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    padding:16px 20px 32px; color:var(--text); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .act * { box-sizing:border-box; }
  .act-card { background:#fff; border:1px solid var(--border); border-radius:14px; margin-bottom:14px; }

  /* ---------- Кнопки ---------- */
  .act .ab { display:inline-flex; align-items:center; gap:7px; height:36px; padding:0 14px; border-radius:9px; border:1px solid var(--border);
    background:#fff; color:var(--text); font-size:13.5px; font-weight:600; font-family:inherit; cursor:pointer; white-space:nowrap;
    text-decoration:none; transition:background .12s, border-color .12s; }
  .act .ab:hover { background:var(--bg); border-color:#D5D8DD; }
  .act .ab.sm { height:32px; padding:0 11px; font-size:13px; }
  .act .ab.main { background:var(--brand); border-color:var(--brand); color:#fff; }
  .act .ab.main:hover { background:var(--brand-dark); border-color:var(--brand-dark); }
  .act .ab.dark { background:var(--text); border-color:var(--text); color:#fff; }
  .act .ab.dark:hover { background:#000; }
  .act .ab.warn { border-color:#F5D9A8; background:#FEF8EC; color:#B45309; }
  .act .ab .dot { width:7px; height:7px; border-radius:50%; background:#D97706; }
  .act .ib { width:30px; height:30px; display:inline-flex; align-items:center; justify-content:center; border:0; border-radius:8px;
    background:none; color:#9AA1AC; cursor:pointer; font-size:14px; }
  .act .ib:hover { background:#FDECEE; color:var(--brand); }
  .act .ib.ok:hover { background:#E8F7EE; color:#15803D; }

  /* ---------- Шапка ---------- */
  .act-head { display:flex; align-items:center; gap:14px; padding:14px 18px; flex-wrap:wrap; }
  .act-back { flex:none; width:38px; height:38px; border-radius:10px; border:1px solid var(--border); background:#fff; color:var(--muted);
    display:flex; align-items:center; justify-content:center; cursor:pointer; font-size:15px; }
  .act-back:hover { background:var(--bg); color:var(--text); }
  .act-who { flex:1; min-width:240px; }
  .act-who h2 { margin:0; font-size:19px; font-weight:700; line-height:1.25; }
  .act-who .meta { margin-top:3px; font-size:13px; color:var(--muted); display:flex; gap:12px; flex-wrap:wrap; align-items:center; }
  .act-badge { display:inline-block; padding:2px 9px; border-radius:10px; font-size:12px; font-weight:600; background:#E8F7EE; color:#15803D; }
  .act-badge.closed { background:#F1F2F4; color:var(--muted); }
  .act-btns { display:flex; gap:8px; flex-wrap:wrap; }
  .act .ab.back { margin-left:8px; }

  /* ---------- Реквизиты и итоги ---------- */
  .act-body { display:grid; grid-template-columns: minmax(0, 1fr) auto; gap:18px; padding:16px 18px 18px; border-top:1px solid var(--border); }
  .act-fields { display:grid; grid-template-columns:repeat(5, minmax(120px, 1fr)); gap:12px; align-content:start; }
  .act .fg label { display:block; font-size:12px; font-weight:600; color:var(--muted); margin-bottom:5px; }
  .act .fg input { width:100%; height:38px; padding:0 10px; border:1px solid var(--border); border-radius:9px; font-size:14px; font-family:inherit;
    color:var(--text); background-color:#fff; outline:none; box-shadow:none; transition:border-color .15s, box-shadow .15s; }
  .act .fg input:focus { border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .act .fg input[readonly], .act .fg input:disabled { background-color:#F8F9FA; color:var(--muted); }
  .act-sums { display:grid; grid-template-columns:repeat(4, auto); gap:0; border:1px solid var(--border); border-radius:12px; overflow:hidden; align-self:start; }
  .act-sum { padding:10px 16px; border-left:1px solid var(--border); min-width:130px; }
  .act-sum:first-child { border-left:0; }
  .act-sum .l { font-size:11.5px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px; white-space:nowrap; }
  .act-sum .v { margin-top:3px; font-size:17px; font-weight:700; font-variant-numeric:tabular-nums; white-space:nowrap; }
  .act-sum.pay { background:#F8F9FA; }
  .act-sum.pay .v { font-size:20px; }
  .act-sum.ret { background:#FFF5F5; }
  .act-sum.ret .v { color:var(--brand); }
  .act-sum[title] .l:after { content:" ⓘ"; color:#9AA1AC; text-transform:none; }

  /* ---------- Навигация по разделам ---------- */
  .act-nav { display:flex; gap:8px; flex-wrap:wrap; margin-bottom:14px; }
  .act-nav a { display:inline-flex; align-items:center; gap:8px; padding:7px 12px; border:1px solid var(--border); border-radius:9px; background:#fff;
    color:var(--text); font-size:13px; font-weight:600; text-decoration:none; }
  .act-nav a:hover { background:var(--bg); }
  .act-nav a b { font-weight:700; color:var(--muted); font-variant-numeric:tabular-nums; }

  /* ---------- Разделы ---------- */
  .sec-h { display:flex; align-items:center; gap:10px; padding:12px 16px; border-bottom:1px solid var(--border); flex-wrap:wrap; }
  .sec-h h3 { margin:0; font-size:15px; font-weight:700; }
  .sec-h .sum { font-size:15px; font-weight:700; color:var(--muted); font-variant-numeric:tabular-nums; }
  .sec-h .sp { flex:1; }
  .sec-wrap { overflow-x:auto; }
  .act .st { width:100%; border-collapse:separate; border-spacing:0; font-size:13.5px; margin:0; }
  .act .st th { padding:9px 12px; background:#F8F9FA; border-bottom:1px solid var(--border); color:var(--muted); font-size:11.5px; font-weight:600;
    text-transform:uppercase; letter-spacing:.3px; text-align:right; white-space:nowrap; }
  .act .st th:first-child { text-align:left; }
  .act .st td { padding:6px 12px; border-bottom:1px solid #F0F1F4; vertical-align:middle; text-align:right; font-variant-numeric:tabular-nums; }
  .act .st td:first-child { text-align:left; }
  .act .st tbody tr:last-child td { border-bottom:0; }
  .act .st tbody tr:hover td { background:#FAFBFC; }
  .act .st td.c, .act .st th.c { text-align:center; }
  .act .st td.nm { font-weight:500; min-width:220px; }
  .act .st td.muted { color:var(--muted); }
  .act .st td.b { font-weight:600; }
  .act .st input.form-control { height:32px; padding:0 8px; border:1px solid var(--border); border-radius:8px; font-size:13.5px; box-shadow:none;
    background:#fff; font-family:inherit; }
  .act .st input.form-control:focus { border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .act .st input.form-control[readonly], .act .st input.form-control:disabled { background:#F8F9FA; color:var(--muted); }
  .act .st input.form-control { display:block; width:100%; max-width:130px; margin-left:auto; }
  .act .st input.right { text-align:right; }
  .act .st input.center { text-align:center; max-width:80px; margin:0 auto; }
  .act .st > tr input.form-control { max-width:none; margin:0; }
  .act .st tr.empty td { padding:18px 12px; text-align:center; color:#9AA1AC; }
  /* новая строка, добавленная кнопкой «Добавить» (вставляется между thead и tbody) */
  .act .st > tr td { padding:8px 12px; background:#FFFBEB; border-bottom:1px solid #F5E6C4; }

  /* ---------- Модалка обследований ---------- */
  .act-plan { width:100%; border-collapse:separate; border-spacing:0; font-size:13.5px; }
  .act-plan th { padding:9px 10px; background:#F8F9FA; border-bottom:1px solid #E6E8EC; color:#6B7280; font-size:11.5px; font-weight:600;
    text-transform:uppercase; letter-spacing:.3px; text-align:left; }
  .act-plan td { padding:8px 10px; border-bottom:1px solid #F0F1F4; vertical-align:middle; }
  .act-plan .st-ok, .act-plan .st-no { display:inline-block; padding:2px 8px; border-radius:10px; font-size:12px; font-weight:600; white-space:nowrap; }
  .act-plan .st-ok { background:#E8F7EE; color:#15803D; }
  .act-plan .st-no { background:#FEF3E2; color:#B45309; }

  @media (max-width: 1400px) { .act-body { grid-template-columns:1fr; } .act-sums { justify-self:start; } }
  @media (max-width: 900px)  { .act-fields { grid-template-columns:repeat(2, 1fr); } .act-sums { grid-template-columns:repeat(2, auto); } }
</style>
<iframe style="display: none" name="drug_excel"></iframe>

<div class="act">

  <!-- ================= Шапка и реквизиты ================= -->
  <div class="act-card">
    <div class="act-head">
      <div class="act-who" title="HNPATIENT: ${obj.id} PATIENT_ID: ${obj.patient.id}">
        <h2>${obj.patient.surname} ${obj.patient.name} ${obj.patient.middlename}</h2>
        <div class="meta">
          <span>№ ${obj.patient.yearNum}</span>
          <span>Поступил: <fmt:formatDate pattern="dd.MM.yyyy" value="${obj.patient.dateBegin}"/></span>
          <c:choose>
            <c:when test="${obj.closed == 'Y'}"><span class="act-badge closed">Акт закрыт</span></c:when>
            <c:otherwise><span class="act-badge">В работе</span></c:otherwise>
          </c:choose>
        </div>
      </div>
      <div class="act-btns">
        <button type="button" class="ab" onclick="excel()"><i class="fa fa-file-excel-o"></i> Excel</button>
        <c:if test="${(obj.closed == 'Y' && obj.patient.state == 'LV') && sessionScope.ENV.userId == 1}">
          <button type="button" class="ab" onclick="retPatient()"><i class="fa fa-retweet"></i> Возобновить</button>
        </c:if>
        <c:if test="${obj.closed == 'Y' && obj.patient.paid == 'CLOSED' && sessionScope.ENV.userId == 1}">
          <button type="button" class="ab" onclick="openCash()"><i class="fa fa-repeat"></i> Открыть кассу</button>
        </c:if>
        <c:if test="${(obj.state == 'C' || (obj.closed != 'Y' && obj.state == 'D'))}">
          <button type="button" class="ab dark" onclick="confirmPatient()"><i class="fa fa-check"></i> Подтвердить</button>
        </c:if>
        <c:if test="${obj.closed != 'Y'}">
          <button type="button" class="ab main" onclick="savePatient()"><i class="fa fa-save"></i> Сохранить</button>
        </c:if>
        <button type="button" class="ab back" onclick="setPage('/act/index.s')" title="Назад к списку актов"><i class="fa fa-arrow-left"></i> Назад</button>
      </div>
    </div>

    <div class="act-body">
      <form id="addEditForm" class="act-fields" onsubmit="return false;">
        <div class="fg">
          <label for="act_end_date">Дата выписки</label>
          <input type="text" id="act_end_date" class="form-control fms-cal" autocomplete="off" placeholder="дд.мм.гггг" value="<c:choose><c:when test="${not empty obj.dateEnd}"><fmt:formatDate pattern="dd.MM.yyyy" value="${obj.dateEnd}"/></c:when><c:otherwise><fmt:formatDate pattern="dd.MM.yyyy" value="${obj.patient.dateEnd}"/></c:otherwise></c:choose>"
                 title="Если в акте дата не указана, подставляется дата выписки пациента">
        </div>
        <div class="fg">
          <label for="act_num">Номер акта</label>
          <input type="text" id="act_num" class="form-control center" value="${obj.actNum}">
        </div>
        <div class="fg">
          <label for="day_count">Койко-дней</label>
          <input type="number" id="day_count" class="form-control center" value="${obj.dayCount}">
        </div>
        <div class="fg">
          <label for="koyko_price">Цена за койку</label>
          <input type="number" id="koyko_price" class="form-control center" value="${obj.koykoPrice}">
        </div>
        <div class="fg">
          <label for="eat_price">Питание</label>
          <input type="number" id="eat_price" class="form-control center" value="${obj.eatPrice}">
        </div>
      </form>

      <div class="act-sums">
        <div class="act-sum">
          <div class="l">Общая сумма</div>
          <div class="v"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${obj.totalSum}"/></div>
        </div>
        <div class="act-sum"
             <c:if test="${discountSum_discount > 0 || discountSum_koyko > 0}">title="<c:if test="${discountSum_discount > 0}">Сумма скидки - Касса: <fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${discountSum_discount}"/></c:if>
<c:if test="${discountSum_koyko > 0}">Сумма скидки - Койко (${dis_perc * 100}%): <fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${discountSum_koyko}"/></c:if>"</c:if>>
          <div class="l">Скидка</div>
          <div class="v"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${discountSum_discount + discountSum_koyko}"/></div>
        </div>
        <div class="act-sum">
          <div class="l">Оплачено</div>
          <div class="v"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${paidSum}"/></div>
        </div>
        <c:choose>
          <c:when test="${obj.paySum < 0}">
            <div class="act-sum pay ret">
              <div class="l">Возврат</div>
              <div class="v"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${obj.paySum}"/></div>
            </div>
          </c:when>
          <c:otherwise>
            <div class="act-sum pay">
              <div class="l">К оплате</div>
              <div class="v"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" type="number" value="${obj.paySum}"/></div>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>

  <!-- ================= Быстрый переход по разделам ================= -->
  <div class="act-nav">
    <c:if test="${fn:length(epics) > 0}">
      <a href="#" onclick="return actGo('sec_epic')">Переводной эпикриз <b><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${epicSum}" type="number"/></b></a>
    </c:if>
    <a href="#" onclick="return actGo('sec_drug')">Медикаменты <b><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${drugSum}" type="number"/></b></a>
    <a href="#" onclick="return actGo('sec_lab')">Лаборатория <b><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${labSum}" type="number"/></b></a>
    <a href="#" onclick="return actGo('sec_consul')">Узкие специалисты <b><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${consulSum}" type="number"/></b></a>
    <a href="#" onclick="return actGo('sec_kdo')">Медицинские услуги <b><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${kdoSum}" type="number"/></b></a>
    <c:if test="${fn:length(watchers) > 0}">
      <a href="#" onclick="return actGo('sec_watcher')">Доп. место <b><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${watcherSum}" type="number"/></b></a>
    </c:if>
  </div>

  <!-- ================= Переводной эпикриз ================= -->
  <c:if test="${fn:length(epics) > 0}">
    <div class="act-card" id="sec_epic">
      <div class="sec-h">
        <h3>Переводной эпикриз</h3>
        <span class="sum"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${epicSum}" type="number"/></span>
      </div>
      <div class="sec-wrap">
        <table class="st" id="patient_epic_list">
          <thead>
          <tr>
            <th>Отделение</th>
            <th class="c" style="width:130px">Дата начала</th>
            <th class="c" style="width:130px">Дата окончания</th>
            <th style="width:130px">Койко-дней</th>
            <th style="width:150px">Стоимость</th>
            <th style="width:140px">С НДС</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach items="${epics}" var="row" varStatus="loop">
            <tr>
              <td class="nm">${row.c1}</td>
              <td class="c">${row.c3}</td>
              <td class="c">${row.c4}</td>
              <td>
                <input type="number" <c:if test="${row.ib == '-1' && sessionScope.ENV.userId != 1}">disabled</c:if> class="form-control right" onchange="setFieldValue('epic', 'koyko', ${row.ib}, this)" value="${row.c6}">
              </td>
              <td>
                <input type="number" <c:if test="${row.ib == '-1' && sessionScope.ENV.userId != 1}">disabled</c:if> class="form-control right" onchange="setFieldValue('epic', 'price', ${row.ib}, this)" value="${row.c5}">
              </td>
              <td class="muted"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${row.c6 * row.c5}" type="number"/></td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </c:if>

  <!-- ================= Медикаменты ================= -->
  <div class="act-card" id="sec_drug">
    <div class="sec-h">
      <h3>Медикаменты</h3>
      <span class="sum"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${drugSum}" type="number"/></span>
      <span class="sp"></span>
      <c:if test="${obj.closed != 'Y'}">
        <button type="button" class="ab sm" onclick="addNewDrug()"><i class="fa fa-plus"></i> Добавить</button>
      </c:if>
    </div>
    <div class="sec-wrap">
      <table class="st" id="patient_drug_list">
        <thead>
        <tr>
          <th>Наименование</th>
          <th style="width:150px">Стоимость (аптека)</th>
          <th style="width:140px">Стоимость</th>
          <th style="width:130px">Цена за ед.</th>
          <th class="c" style="width:100px">Расход</th>
          <th style="width:130px">Сумма</th>
          <th style="width:130px">С НДС</th>
          <c:if test="${obj.closed != 'Y'}">
            <th class="c" style="width:50px"></th>
          </c:if>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${drugs}" var="row" varStatus="loop">
          <tr>
            <td class="nm">${row.drugName}</td>
            <td class="muted"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${row.drugPrice}" type="number"/></td>
            <td>
              <input type="number" class="form-control right" onchange="setFieldValue('drug', 'price', ${row.id}, this)" value="${row.price}">
            </td>
            <td class="muted"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${row.price}" type="number"/></td>
            <td>
              <input type="number" class="form-control center" value="${row.serviceCount}" onchange="setFieldValue('drug', 'counter', ${row.id}, this)">
            </td>
            <td class="b"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${row.serviceCount * row.price}" type="number"/></td>
            <td class="muted"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${row.serviceCount * (row.price + row.nds)}" type="number"/></td>
            <c:if test="${obj.closed != 'Y'}">
              <td class="c"><button type="button" class="ib" title="Удалить" onclick="delDrugRow(${row.id})"><i class="fa fa-trash-o"></i></button></td>
            </c:if>
          </tr>
        </c:forEach>
        <c:if test="${fn:length(drugs) == 0}"><tr class="empty"><td colspan="8">Медикаментов нет</td></tr></c:if>
        </tbody>
      </table>
    </div>
  </div>

  <!-- ================= Лабораторные исследования ================= -->
  <div class="act-card" id="sec_lab">
    <div class="sec-h">
      <h3>Лабораторные исследования</h3>
      <span class="sum"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${labSum}" type="number"/></span>
      <span class="sp"></span>
      <button type="button" class="ab sm <c:if test="${not_done}">warn</c:if>" onclick="$('#modal_window').click()"
              <c:if test="${not_done}">title="Есть невыполненные обследования"</c:if>>
        <c:if test="${not_done}"><span class="dot"></span></c:if><i class="fa fa-list"></i> Обследования
      </button>
      <c:if test="${obj.closed != 'Y'}">
        <button type="button" class="ab sm" onclick="restoreServiceRow(0, ${obj.id})"><i class="fa fa-refresh"></i> Восстановить</button>
        <button type="button" class="ab sm" onclick="addService('lab')"><i class="fa fa-plus"></i> Добавить</button>
      </c:if>
    </div>
    <div class="sec-wrap">
      <table class="st" id="patient_lab_list">
        <thead>
        <tr>
          <th>Наименование</th>
          <th style="width:150px">Реальная стоимость</th>
          <th style="width:140px">Стоимость</th>
          <th class="c" style="width:110px">Количество</th>
          <th style="width:130px">Сумма</th>
          <th style="width:130px">С НДС</th>
          <c:if test="${obj.closed != 'Y'}">
            <th class="c" style="width:50px"></th>
          </c:if>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${labs}" var="elem">
          <tr>
            <td class="nm">${elem.serviceName}</td>
            <td><input type="number" class="form-control right" value="${elem.real_price}" readonly></td>
            <td><input type="number" class="form-control right" value="${elem.price}" onchange="setFieldValue('service', 'price', ${elem.id}, this)"></td>
            <td><input type="number" class="form-control center" value="${elem.serviceCount}" onchange="setFieldValue('service', 'counter', ${elem.id}, this)"></td>
            <td class="b"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${elem.price * elem.serviceCount}" type="number"/></td>
            <td class="muted"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${(elem.price + elem.nds) * elem.serviceCount}" type="number"/></td>
            <c:if test="${obj.closed != 'Y'}">
              <td class="c"><button type="button" class="ib" title="Удалить" onclick="delServiceRow(${elem.id})"><i class="fa fa-trash-o"></i></button></td>
            </c:if>
          </tr>
        </c:forEach>
        <c:if test="${fn:length(labs) == 0}"><tr class="empty"><td colspan="7">Исследований нет</td></tr></c:if>
        </tbody>
      </table>
    </div>
  </div>

  <!-- ================= Узкие специалисты ================= -->
  <div class="act-card" id="sec_consul">
    <div class="sec-h">
      <h3>Узкие специалисты</h3>
      <span class="sum"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${consulSum}" type="number"/></span>
      <span class="sp"></span>
      <c:if test="${obj.closed != 'Y'}">
        <button type="button" class="ab sm" onclick="restoreServiceRow(2, ${obj.id})"><i class="fa fa-refresh"></i> Восстановить</button>
        <button type="button" class="ab sm" onclick="addService('consul')"><i class="fa fa-plus"></i> Добавить</button>
      </c:if>
    </div>
    <div class="sec-wrap">
      <table class="st" id="patient_consul_list">
        <thead>
        <tr>
          <th>Наименование</th>
          <th style="width:150px">Реальная стоимость</th>
          <th style="width:140px">Стоимость</th>
          <th class="c" style="width:110px">Количество</th>
          <th style="width:130px">Сумма</th>
          <th style="width:130px">С НДС</th>
          <c:if test="${obj.closed != 'Y'}">
            <th class="c" style="width:50px"></th>
          </c:if>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${consuls}" var="elem">
          <tr>
            <td class="nm">${elem.serviceName}</td>
            <td><input type="number" class="form-control right" value="${elem.real_price}" readonly></td>
            <td><input type="number" class="form-control right" value="${elem.price}" onchange="setFieldValue('service', 'price', ${elem.id}, this)"></td>
            <td><input type="number" class="form-control center" value="${elem.serviceCount}" onchange="setFieldValue('service', 'counter', ${elem.id}, this)"></td>
            <td class="b"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${elem.price * elem.serviceCount}" type="number"/></td>
            <td class="muted"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${(elem.price + elem.nds) * elem.serviceCount}" type="number"/></td>
            <c:if test="${obj.closed != 'Y'}">
              <td class="c"><button type="button" class="ib" title="Удалить" onclick="delServiceRow(${elem.id})"><i class="fa fa-trash-o"></i></button></td>
            </c:if>
          </tr>
        </c:forEach>
        <c:if test="${fn:length(consuls) == 0}"><tr class="empty"><td colspan="7">Консультаций нет</td></tr></c:if>
        </tbody>
      </table>
    </div>
  </div>

  <!-- ================= Медицинские услуги ================= -->
  <div class="act-card" id="sec_kdo">
    <div class="sec-h">
      <h3>Медицинские услуги</h3>
      <span class="sum"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${kdoSum}" type="number"/></span>
      <span class="sp"></span>
      <c:if test="${obj.closed != 'Y'}">
        <button type="button" class="ab sm" onclick="restoreServiceRow(1, ${obj.id})"><i class="fa fa-refresh"></i> Восстановить</button>
        <button type="button" class="ab sm" onclick="addService('kdo')"><i class="fa fa-plus"></i> Добавить</button>
      </c:if>
    </div>
    <div class="sec-wrap">
      <table class="st" id="patient_kdo_list">
        <thead>
        <tr>
          <th>Наименование</th>
          <th style="width:150px">Реальная стоимость</th>
          <th style="width:140px">Стоимость</th>
          <th class="c" style="width:110px">Количество</th>
          <th style="width:130px">Сумма</th>
          <th style="width:130px">С НДС</th>
          <c:if test="${obj.closed != 'Y'}">
            <th class="c" style="width:50px"></th>
          </c:if>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${kdos}" var="elem">
          <tr>
            <td class="nm">${elem.serviceName}</td>
            <td><input type="number" class="form-control right" value="${elem.real_price}" readonly></td>
            <td><input type="number" class="form-control right" value="${elem.price}" onchange="setFieldValue('service', 'price', ${elem.id}, this)"></td>
            <td><input type="number" class="form-control center" value="${elem.serviceCount}" onchange="setFieldValue('service', 'counter', ${elem.id}, this)"></td>
            <td class="b"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${elem.price * elem.serviceCount}" type="number"/></td>
            <td class="muted"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${(elem.price + elem.nds) * elem.serviceCount}" type="number"/></td>
            <c:if test="${obj.closed != 'Y'}">
              <td class="c"><button type="button" class="ib" title="Удалить" onclick="delServiceRow(${elem.id})"><i class="fa fa-trash-o"></i></button></td>
            </c:if>
          </tr>
        </c:forEach>
        <c:if test="${fn:length(kdos) == 0}"><tr class="empty"><td colspan="7">Услуг нет</td></tr></c:if>
        </tbody>
      </table>
    </div>
  </div>

  <!-- ================= Дополнительное место ================= -->
  <c:if test="${fn:length(watchers) > 0}">
    <div class="act-card" id="sec_watcher">
      <div class="sec-h">
        <h3>Дополнительное место</h3>
        <span class="sum"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${watcherSum}" type="number"/></span>
      </div>
      <div class="sec-wrap">
        <table class="st">
          <thead>
          <tr>
            <th class="c" style="width:150px">Количество</th>
            <th style="width:150px">Стоимость</th>
            <th>Сумма</th>
            <th>С НДС</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach items="${watchers}" var="row">
            <tr>
              <td><input type="number" class="form-control center" value="${row.dayCount}" onchange="setFieldValue('watcher', 'counter', ${row.id}, this)"></td>
              <td><input type="number" class="form-control right" value="${row.price}" onchange="setFieldValue('watcher', 'price', ${row.id}, this)"></td>
              <td class="b"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${row.price * row.dayCount}" type="number"/></td>
              <td class="muted"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${(row.price + row.nds) * row.dayCount}" type="number"/></td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </c:if>
</div>

<!-- ================= Модалка «Обследования» ================= -->
<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog" style="width:100%; max-width:1100px">
    <div class="modal-content" style="border-radius:14px; overflow:hidden">
      <div class="modal-header">
        <button type="button" class="close" id="close-modal" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel" style="font-weight:700">Обследования: ${obj.patient.surname} ${obj.patient.name} ${obj.patient.middlename}</h4>
      </div>
      <div class="modal-body" id="patient_drugs_list" style="padding:0">
        <table class="act-plan">
          <thead>
          <tr>
            <th style="width:40px">№</th>
            <th style="width:130px">Статус</th>
            <th>Наименование</th>
            <th style="width:140px">Дата</th>
            <th>Примечание</th>
            <th>Назначил</th>
            <th style="width:44px"></th>
          </tr>
          </thead>
          <tbody>
          <c:forEach items="${plans}" var="p" varStatus="loop">
            <tr id="stat_obs_row_${p.c1}">
              <td style="color:#9AA1AC">${loop.index + 1}</td>
              <td>
                <c:if test="${p.c7 == 'Y'}"><span class="st-ok">Выполнено</span></c:if>
                <c:if test="${p.c7 == 'N'}"><span class="st-no">Не выполнено</span></c:if>
              </td>
              <td style="font-weight:500">${p.c4}</td>
              <td nowrap>${p.c5}</td>
              <td>${p.c6}</td>
              <td>${p.c9}</td>
              <td style="text-align:center">
                <c:if test="${p.c7 == 'N'}">
                  <button class="btn btn-default btn-xs" type="button" title="Удалить" onclick="delPlan('${p.c1}')"><i class="fa fa-trash-o"></i></button>
                </c:if>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>

<script>
  var labCount = ${fn:length(labs)};
  var kdoCount = ${fn:length(kdos)};
  var consulCount = ${fn:length(consuls)};
  var drugCount = ${fn:length(drugs)};

  // Быстрый переход к разделу
  function actGo(id) {
    var el = document.getElementById(id);
    if (el && el.scrollIntoView) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
    return false;
  }

  function openCash(){
    if(confirm('Вы действительно хотите открыть кассу?')) {
      $.ajax({
        url: '/act/patient/cash.s',
        method: 'post',
        data: 'id=${obj.id}',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("<ui:message code="successSave"/>");
            parent.setPage('/act/info.s?id=${obj.id}');
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }

  function delPlan(id){
    if(confirm('Вы действительно хотите удалить?')) {
      $.ajax({
        url: '/act/stat/del/obs.s',
        method: 'post',
        data: 'id=' + id,
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert("<ui:message code="successSave"/>");
            $('#stat_obs_row_' + id).remove();
          } else {
            alert(res.msg);
          }
        }
      });
    }
  }
  function delDrugRow(id) {
    if(confirm('Действительно хотите удалить?')) {
      $.ajax({
        url: '/head_nurse/patient/drug/delete.s',
        data: 'id=' + id,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            parent.setPage('/act/info.s?id=${obj.id}');
          } else
            alert(res.msg);
        }
      });
    }
  }
  function confirmPatient() {
    if(confirm('Действительно хотите подтвердить?')) {
      $.ajax({
        url: '/act/confirm.s',
        data: 'id=${obj.id}',
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            setPage('/act/info.s?id=${obj.id}');
          } else
            alert(res.msg);
        }
      });
    }
  }
  function excel() {
    drug_excel.location = '/act/excel.s?id=${obj.id}';
  }
  function savePatient() {
    $.ajax({
      url: '/act/patient/save.s',
      data: 'id=${obj.id}&act=' + $('#act_num').val() + '&date_end=' + $('#act_end_date').val() + '&days=' + $('#day_count').val() + '&koyko=' + $('#koyko_price').val() + '&eat=' + $('#eat_price').val(),
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert('Данные успешно сохранены');
          setPage('/act/info.s?id=${obj.id}');
        } else
          alert(res.msg);
      }
    });
  }
  function addService(type) {
    var typeIdx = type === 'kdo' ? kdoCount++ : type === 'lab' ? labCount++ : type === 'consul' ? consulCount++ : 0;
    var tr = $('<tr id="row_' + typeIdx + '"></tr>');
    var td1 = $('<td><input type="text" class="form-control" name="name" placeholder="Наименование"/></td>');
    var td2 = $('<td><input type="number" class="form-control right" name="price" placeholder="Цена"/></td>');
    var td3 = $('<td><input type="number" class="form-control center" name="counter" placeholder="Кол-во"/></td>');
    var td4 = $('<td class="c" colspan="4" style="text-align:left"></td>');
    var sve = $('<button type="button" class="ib ok" title="Сохранить" onclick=\'saveNewKdo("' + type + '", ' + typeIdx +')\'><i class="fa fa-check"></i></button>');
    var del = $('<button type="button" class="ib" title="Отменить" onclick="removeNewKdo(' + typeIdx + ')"><i class="fa fa-times"></i></button>');
    td4.append(sve).append(del);
    tr.append(td1).append(td2).append(td3).append(td4);
    $('#patient_' + type + '_list').find('tbody').before(tr);
    tr.find('input[name=name]').focus();
  }
  function saveNewKdo(typeCode, idx) {
    var form = $('<form></form>');
    var id = $('<input type="text" name="id" value="${obj.id}">');
    var type = $('<input type="text" name="type" value="' + typeCode + '">');
    var name = $('<input type="text" name="name" value="' + $('#row_' + idx).find('input[name=name]').val() + '">');
    var price = $('<input type="text" name="price" value="' + $('#row_' + idx).find('input[name=price]').val() + '">');
    var counter = $('<input type="text" name="counter" value="' + $('#row_' + idx).find('input[name=counter]').val() + '">');
    form.append(id).append(type).append(name).append(price).append(counter);
    if(name.val() === '' || price.val() === '' || counter.val() === '') {
      alert('Не все поля заполнены');
      return;
    }
    $.ajax({
      url: '/act/service/save.s',
      data: form.serialize(),
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          setPage('/act/info.s?id=${obj.id}');
        } else
          alert(res.msg);
      }
    });
  }
  function removeNewKdo(idx) {
    $('#row_' + idx).remove();
  }
  function setFieldValue(cat, type, id, dom) {
    <c:if test="${obj.closed != 'Y'}">
    $.ajax({
      url: '/act/patient/row/save.s',
      data: 'id=' + id + '&value=' + dom.value + '&cat=' + cat + '&type=' + type,
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          setPage('/act/info.s?id=${obj.id}');
        } else
          alert(res.msg);
      }
    });
    </c:if>
  }
  function retPatient() {
    $.ajax({
      url: '/act/patient/open.s',
      data: 'id=${obj.id}',
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          alert('Данные успешно сохранены');
          setPage('/act/info.s?id=${obj.id}');
        } else
          alert(res.msg);
      }
    });
  }
  function delServiceRow(id) {
    if(confirm('Вы действительно хотите удалить?'))
      $.ajax({
        url: '/act/patient/service/del.s',
        data: 'id=' + id,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/act/info.s?id=${obj.id}');
          } else
            alert(res.msg);
        }
      });
  }
  function restoreServiceRow(type, id) {
    if(confirm('Вы действительно хотите восстановить данные? Все изменения будут сброшены.'))
      $.ajax({
        url: '/act/patient/service/restore.s',
        data: 'id=' + id + '&type=' + type,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            setPage('/act/info.s?id=${obj.id}');
          } else
            alert(res.msg);
        }
      });
  }
  function addNewDrug() {
    var typeIdx = drugCount++;
    var tr = $('<tr id="drug_row_' + typeIdx + '"></tr>');
    var td1 = $('<td><input type="text" class="form-control" name="name" placeholder="Наименование"/></td>');
    var td1_1 = $('<td>&nbsp;</td>');
    var td2 = $('<td><input type="number" class="form-control right" name="price" placeholder="Стоимость"/></td>');
    var td3 = $('<td><input type="number" class="form-control right" name="counter" placeholder="Цена за ед."/></td>');
    var td4 = $('<td><input type="number" class="form-control center" name="drug_count" placeholder="Расход"/></td>');
    var td5 = $('<td class="c" colspan="3" style="text-align:left"></td>');
    var sve = $('<button type="button" class="ib ok" title="Сохранить" onclick="saveNewDrug(' + typeIdx +')"><i class="fa fa-check"></i></button>');
    var del = $('<button type="button" class="ib" title="Отменить" onclick="removeNewDrug(' + typeIdx + ')"><i class="fa fa-times"></i></button>');
    td5.append(sve).append(del);
    tr.append(td1).append(td1_1).append(td2).append(td3).append(td4).append(td5);
    $('#patient_drug_list').find('tbody').before(tr);
    tr.find('input[name=name]').focus();
  }
  function saveNewDrug(idx) {
    var form = $('<form></form>');
    var id = $('<input type="text" name="id" value="${obj.id}">');
    var name = $('<input type="text" name="name" value="' + $('#drug_row_' + idx).find('input[name=name]').val() + '">');
    var price = $('<input type="text" name="price" value="' + $('#drug_row_' + idx).find('input[name=price]').val() + '">');
    var counter = $('<input type="text" name="counter" value="' + $('#drug_row_' + idx).find('input[name=counter]').val() + '">');
    var drug_count = $('<input type="text" name="drug_count" value="' + $('#drug_row_' + idx).find('input[name=drug_count]').val() + '">');
    form.append(id).append(name).append(price).append(counter).append(drug_count);
    if(name.val() === '' || price.val() === '' || counter.val() === '' || drug_count.val() === '') {
      alert('Не все поля заполнены');
      return;
    }
    $.ajax({
      url: '/act/drug/save.s',
      data: form.serialize(),
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          setPage('/act/info.s?id=${obj.id}');
        } else
          alert(res.msg);
      }
    });
  }
  function setArchive() {
    if(confirm('Вы действительно хотите архивировать пациента?'))
      $.ajax({
        url: '/act/patient/confirm.s',
        data: 'id=${obj.patient.id}',
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            setPage('/act/info.s?id=${obj.id}');
          } else
            alert(res.msg);
        }
      });
  }
  function removeNewDrug(idx) {
    $('#drug_row_' + idx).remove();
  }
</script>
