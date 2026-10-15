<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/choosen/chosen.min.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<script src="/res/js/common.js?v=2026101501" type="text/javascript"></script>
<script src="/res/choosen/chosen.jquery.min.js" type="text/javascript"></script>

<style>
  body { background:#F5F6F8; }
  .dr { --brand:#D7182E; --brand-dark:#A50F22; --brand-soft:#FDECEE; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    padding:12px; color:var(--text); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; font-size:14px; }
  .dr-card { background:#fff; border:1px solid var(--border); border-radius:14px; margin-bottom:14px; }
  .dr-card-h { display:flex; align-items:center; gap:8px; flex-wrap:wrap; padding:12px 16px; border-bottom:1px solid var(--border); }
  .dr-card-h h3 { margin:0; font-size:16px; font-weight:700; }
  .dr-card-h .sp { flex:1; }
  .dr-card-b { padding:16px; }

  /* Кнопки */
  .dr .ab { display:inline-flex; align-items:center; gap:7px; height:34px; padding:0 12px; border-radius:9px; border:1.5px solid var(--border);
    background:#fff; color:var(--text); font-size:13px; font-weight:600; white-space:nowrap; cursor:pointer; text-decoration:none !important; }
  .dr .ab:hover { background:var(--bg); color:var(--text); }
  .dr .ab .fa { color:var(--muted); }
  .dr .ab.primary { background:var(--brand); border-color:var(--brand); color:#fff; }
  .dr .ab.primary .fa { color:#fff; }
  .dr .ab.primary:hover { background:var(--brand-dark); border-color:var(--brand-dark); }
  .dr .ab.sm { height:30px; padding:0 10px; font-size:12.5px; }
  .dr .ab-ico { width:30px; height:30px; display:inline-flex; align-items:center; justify-content:center; border-radius:8px; border:0;
    background:transparent; color:var(--muted); cursor:pointer; }
  .dr .ab-ico:hover { background:var(--bg); color:var(--text); }
  .dr .ab-ico.del:hover { background:var(--brand-soft); color:var(--brand); }

  /* Поля формы */
  .dr .row-f { display:flex; flex-wrap:wrap; gap:14px 16px; margin-bottom:16px; }
  .dr .fld { display:flex; flex-direction:column; gap:6px; min-width:0; }
  .dr .fld > label, .dr .sec-l { margin:0; font-size:12.5px; font-weight:600; color:var(--muted); }
  .dr .sec-l { display:flex; align-items:center; gap:8px; margin-bottom:8px; }
  .dr .form-control { height:38px; border:1.5px solid var(--border); border-radius:9px; box-shadow:none; font-size:14px; color:var(--text); }
  .dr .form-control:focus { border-color:var(--brand); box-shadow:0 0 0 3px rgba(215,24,46,.10); }
  .dr .form-control[disabled] { background:#F8F9FA; }
  .dr .period { display:flex; align-items:center; gap:8px; }
  .dr .period span { color:#B0B5BD; }
  .dr .period input[type=date] { width:170px; cursor:pointer; }

  /* chosen */
  .dr .chzn-container { font-size:14px; }
  .dr .chzn-container-single .chzn-single { height:38px; line-height:34px; border:1.5px solid var(--border); border-radius:9px;
    background:#fff; box-shadow:none; padding-left:12px; color:var(--text); }
  .dr .chzn-container-single .chzn-single div { top:6px; }
  .dr .chzn-container-active .chzn-single { border-color:var(--brand); box-shadow:0 0 0 3px rgba(215,24,46,.10); }
  .dr .chzn-container .chzn-drop { border-color:var(--border); border-radius:0 0 9px 9px; box-shadow:0 12px 28px rgba(20,25,40,.12); }
  .dr .chzn-container .chzn-results .highlighted { background:var(--brand); color:#fff; }

  /* Таблицы внутри формы */
  .dr table.it { width:100%; border-collapse:separate; border-spacing:0; border:1px solid var(--border); border-radius:10px; overflow:hidden; font-size:13.5px; }
  .dr table.it th, .dr table.it thead td { padding:8px 10px; background:#F8F9FA; border-bottom:1px solid var(--border); color:var(--muted);
    font-size:11.5px; font-weight:600; text-transform:uppercase; letter-spacing:.3px; text-align:left; }
  .dr table.it td { padding:6px 10px; border-bottom:1px solid #F0F1F4; vertical-align:middle; }
  .dr table.it tbody tr:last-child td { border-bottom:0; }
  .dr table.it .form-control { height:34px; }
  .dr .empty-lines { padding:14px; text-align:center; color:#9AA1AC; font-size:13px; }

  /* Даты периода */
  .dr .dates-wrap { overflow-x:auto; border:1px solid var(--border); border-radius:10px; }
  .dr #period_rows { border-collapse:separate; border-spacing:0; font-size:12px; min-width:100%; }
  .dr #period_rows td { padding:6px 8px; text-align:center; white-space:nowrap; border-right:1px solid #F0F1F4; }
  .dr #period_rows tr:first-child td { background:#F8F9FA; color:var(--muted); font-weight:600; border-bottom:1px solid var(--border); }
  .dr #period_rows tr + tr td { cursor:pointer; height:36px; }
  .dr #period_rows tr + tr td:hover { background:#FAFBFC; }
  .dr #period_rows tr + tr td:has(input[type=checkbox]:checked) { background:var(--brand-soft); }
  .dr #period_rows:empty + .dates-empty, .dr .dates-empty { display:none; }

  /* Время приёма */
  .dr table.tm { border-collapse:separate; border-spacing:0; border:1px solid var(--border); border-radius:10px; overflow:hidden; font-size:13px; }
  .dr table.tm td { width:110px; padding:7px 8px; text-align:center; border-right:1px solid #F0F1F4; border-bottom:1px solid #F0F1F4; }
  .dr table.tm tr:last-child td { border-bottom:0; }
  .dr table.tm td:last-child { border-right:0; }
  .dr table.tm tr.h1 td { background:#F8F9FA; font-weight:700; }
  .dr table.tm tr.h2 td { color:var(--muted); font-size:12px; font-weight:600; }
  .dr table.tm td.ck { cursor:pointer; height:36px; }
  .dr table.tm td.ck:hover { background:#FAFBFC; }
  .dr table.tm td.ck:has(input:checked) { background:var(--brand-soft); }
  .dr input[type=checkbox] { width:17px; height:17px; margin:0; cursor:pointer; accent-color:var(--brand); vertical-align:middle; }
  .dr input[type=checkbox]:disabled { cursor:not-allowed; opacity:.45; }

  .dr .form-foot { display:flex; justify-content:flex-end; gap:8px; padding-top:14px; margin-top:4px; border-top:1px solid var(--border); }

  /* Лист назначений */
  .dr table.ls { width:100%; border-collapse:separate; border-spacing:0; font-size:13.5px; }
  .dr table.ls th { padding:9px 12px; background:#F8F9FA; border-bottom:1px solid var(--border); color:var(--muted); font-size:11.5px;
    font-weight:600; text-transform:uppercase; letter-spacing:.3px; text-align:left; white-space:nowrap; }
  .dr table.ls td { padding:10px 12px; border-bottom:1px solid #F0F1F4; vertical-align:middle; }
  .dr table.ls tr.main:hover td { background:#FAFBFC; }
  .dr table.ls .dname { color:var(--text); font-weight:600; text-decoration:none; }
  .dr table.ls .dname:hover { color:var(--brand); }
  .dr table.ls .dname .plus { color:#B0B5BD; font-weight:400; margin:0 3px; }
  .dr table.ls .muted { color:var(--muted); white-space:nowrap; }
  .dr table.ls tr.det td { padding:0 12px; border-bottom:1px solid #F0F1F4; }
  .dr .det-dates { display:flex; flex-wrap:wrap; gap:6px; padding:10px 0 12px; }
  .dr .det-dates span { padding:3px 9px; border-radius:7px; background:#F1F2F4; color:#6B7280; font-size:12px; font-variant-numeric:tabular-nums; }
  .dr .det-dates span.on { background:var(--brand-soft); color:var(--brand-dark); font-weight:700; }
  .dr .ls-empty { padding:26px; text-align:center; color:#9AA1AC; }

  /* Модальные окна */
  .dr-modal .modal-content { border:0; border-radius:16px; box-shadow:0 24px 60px rgba(20,25,40,.25); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .dr-modal .modal-header { display:flex; align-items:center; gap:10px; padding:14px 18px; border-bottom:1px solid #E6E8EC; }
  .dr-modal .modal-header .close { order:2; margin-left:auto; }
  .dr-modal .modal-title { flex:1; }
  .dr-modal .modal-title .form-control { height:40px; border:1.5px solid #E6E8EC; border-radius:10px; box-shadow:none; }
  .dr-modal .modal-title .form-control:focus { border-color:#D7182E; box-shadow:0 0 0 3px rgba(215,24,46,.10); }
  .dr-modal .miniGrid thead th { background:#F8F9FA; color:#6B7280; font-size:12px; text-transform:uppercase; }
  .dr-modal .miniGrid tbody tr:hover { background:#FDECEE; cursor:pointer; }

  /* ===== Компактный вид формы назначения (переопределяет размеры выше) ===== */
  .dr { padding:8px 10px; }
  .dr-card { margin-bottom:10px; }
  .dr-card-h { padding:8px 12px; }
  .dr-card-h h3 { font-size:15px; }
  .dr-card-b { padding:10px 12px 8px; }
  .dr .row-f { gap:8px 12px; margin-bottom:10px; }
  .dr .fld { gap:3px; }
  .dr .fld > label, .dr .sec-l { font-size:12px; }
  .dr .sec-l { margin-bottom:4px; }
  .dr .blk { margin-bottom:10px; }
  .dr .form-control { height:32px; font-size:13.5px; padding:4px 10px; }
  .dr .period input[type=date] { width:140px; }
  .dr .ab { height:32px; }
  .dr .ab.sm { height:28px; }
  .dr .goal-row { display:flex; gap:6px; align-items:center; }
  .dr .goal-row .form-control { flex:1; min-width:0; }
  .dr table.it th, .dr table.it thead td { padding:5px 8px; }
  .dr table.it td { padding:3px 8px; }
  .dr table.it .form-control { height:30px; }
  .dr .form-foot { padding-top:8px; margin-top:0; }
  .dr .dates-wrap { max-height:84px; }
  .dr #period_rows td { padding:3px 7px; }
  .dr #period_rows tr + tr td { height:28px; }

  /* Время приёма в одну строку */
  .dr .tstrip { display:flex; flex-wrap:wrap; gap:6px 12px; align-items:center; min-height:32px; }
  .dr .tg { display:flex; align-items:center; gap:10px; padding:4px 10px; border:1px solid var(--border); border-radius:9px; background:#fff; }
  .dr .tg label { margin:0; display:inline-flex; align-items:center; gap:5px; font-weight:500; font-size:13px; cursor:pointer; white-space:nowrap; }
  .dr .tg .tgm { font-weight:700; }
  .dr .tg .tgs { color:var(--muted); font-size:12.5px; }
  .dr .tg label:has(input:disabled) { opacity:.45; cursor:not-allowed; }

  /* Лист назначений плотнее */
  .dr table.ls th { padding:6px 10px; }
  .dr table.ls td { padding:6px 10px; }

  /* Выбор препарата: поиск с подсказками */
  .dp { position:relative; }
  .dp-input { width:100%; }
  .dp-input.bad { border-color:var(--brand) !important; }
  .dp-list { position:fixed; z-index:2000; max-height:280px; overflow-y:auto; background:#fff; border:1px solid var(--border); border-radius:10px;
    box-shadow:0 12px 28px rgba(20,25,40,.16); display:none; }
  .dp-list.open { display:block; }
  .dp-item { display:flex; justify-content:space-between; gap:14px; padding:7px 12px; cursor:pointer; font-size:13.5px; border-bottom:1px solid #F5F6F8; }
  .dp-item:last-child { border-bottom:0; }
  .dp-item.act { background:var(--brand-soft); }
  .dp-item .m { color:var(--muted); font-size:12px; white-space:nowrap; align-self:center; }
  .dp-item mark { background:transparent; color:var(--brand); font-weight:700; padding:0; }
  .dp-none { padding:10px 12px; color:var(--muted); font-size:13px; }
</style>

<div class="dr">

  <!-- ================= Форма назначения ================= -->
  <div class="dr-card">
    <div class="dr-card-h">
      <h3><c:choose><c:when test="${drug.id != null}">Редактирование назначения</c:when><c:otherwise>Новое назначение</c:otherwise></c:choose></h3>
      <span class="sp"></span>
      <button type="button" class="ab sm" onclick="fromTemplate()"><i class="fa fa-file-text-o"></i> Шаблоны</button>
      <c:if test="${drug.id != null}">
        <button type="button" class="ab sm" onclick="saveTemplate()"><i class="fa fa-bookmark-o"></i> Сохранить как шаблон</button>
      </c:if>
      <button type="button" class="ab sm" onclick="addDrug()" title="Очистить форму и начать новое назначение"><i class="fa fa-plus"></i> Новое</button>
      <button class="ab sm" type="button" onclick="$('#patient-drug-add').slideToggle();" title="Свернуть / развернуть форму"><i class="fa fa-chevron-up"></i></button>
    </div>

    <div class="dr-card-b" id="patient-drug-add">
      <form name="add_edit_drug" id="add_edit_drug">
        <input type="hidden" name="id" value="${drug.id}">

        <!-- Тип, вид, цель и период в одну строку -->
        <div class="row-f">
          <div class="fld" style="width:190px">
            <label>Тип</label>
            <select class="form-control" id="drug_type_code" name="drug_type" onchange="setDrugType(this)" required>
              <c:forEach items="${drugTypes}" var="drugType">
                <option <c:if test="${drug.drugType.id == drugType.id}">selected</c:if> value="${drugType.id}">${drugType.name}</option>
              </c:forEach>
            </select>
          </div>
          <div class="fld" style="width:190px">
            <label>
              <span id="injection_type_label" style="display:none">Тип инъекции</span>
              <span id="tablet_type_label" style="display:none">Тип лекарств</span>
            </label>
            <select class="form-control" style="display:none" name="injection_type" id="injection_type">
              <option value=""></option>
              <c:forEach items="${injectionTypes}" var="injectionType">
                <option <c:if test="${drug.injectionType.id == injectionType.id}">selected</c:if> value="${injectionType.id}">${injectionType.name}</option>
              </c:forEach>
            </select>
            <select class="form-control" style="display:none" name="tablet_type" id="tablet_type">
              <option <c:if test="${drug.tabletType == 'TABLET'}">selected</c:if> value="TABLET">Таблетка</option>
              <option <c:if test="${drug.tabletType == 'INHA'}">selected</c:if> value="INHA">Ингаляция</option>
              <option <c:if test="${drug.tabletType == 'CANDLE'}">selected</c:if> value="CANDLE">Свеча</option>
            </select>
          </div>
          <div class="fld" style="flex:1 1 230px">
            <label>Цель</label>
            <div class="goal-row">
              <select class="form-control" name="goal">
                <c:forEach items="${goals}" var="gl">
                  <option <c:if test="${drug.goal.id == gl.id}">selected</c:if> value="${gl.id}">${gl.name}</option>
                </c:forEach>
              </select>
              <button type="button" class="ab" onclick="addGoal(); return false;" title="Новая цель"><i class="fa fa-plus"></i></button>
            </div>
          </div>
          <div class="fld">
            <label>Период</label>
            <div class="period">
              <%-- На сервер уходят скрытые dateBegin/dateEnd в формате дд.мм.гггг; видимые поля — календарь браузера --%>
              <input type="hidden" id="dateBegin" name="dateBegin" value="<fmt:formatDate pattern="dd.MM.yyyy" value="${drug.dateBegin}"/>"/>
              <input type="hidden" id="dateEnd" name="dateEnd" value="<fmt:formatDate pattern="dd.MM.yyyy" value="${drug.dateEnd}"/>"/>
              <input type="date" class="form-control" id="dateBeginPick" onclick="drOpen(this)" onchange="drSyncDates()"/>
              <span>—</span>
              <input type="date" class="form-control" id="dateEndPick" onclick="drOpen(this)" onchange="drSyncDates()"/>
            </div>
          </div>
        </div>

        <!-- Препараты -->
        <div class="blk">
          <div class="sec-l">
            Препараты
            <button class="ab sm" id="add_new_drug" onclick="newDrugLine()" type="button"><i class="fa fa-plus"></i> Добавить препарат</button>
          </div>
          <table class="it" id="drug-lines">
            <thead>
            <tr>
              <td style="width:125px">Источник</td>
              <td>Наименование</td>
              <td style="width:80px">За раз</td>
              <td style="width:110px">Ед. изм.</td>
              <td style="width:40px"></td>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${drug.rows}" var="rw" varStatus="loop">
              <tr id="line_${loop.index}">
                <td>
                  <input type="hidden" name="row_id" value="${rw.id}"/>
                  <input type="hidden" name="source_code" value="${rw.source}">
                  <c:if test="${rw.source == 'own'}">Свой</c:if><c:if test="${rw.source == 'cln'}">Клиника</c:if>
                </td>
                <td>
                  <c:if test="${rw.source == 'own'}">
                    <input type="hidden" name="drug_drug" value="_">
                    <input type="text" name="drug_name" maxlength="256" class="form-control" value="${rw.name}">
                  </c:if>
                  <c:if test="${rw.source != 'own'}">
                    <input type="hidden" name="drug_name" value="_">
                    <input type="hidden" name="drug_drug" value="${rw.drug.id}">
                    <b style="font-weight:600">${rw.name}</b>
                  </c:if>
                </td>
                <td>
                  <c:if test="${rw.source != 'own'}">
                    <input type="number" class="form-control text-center" value="${rw.expanse}" name="out_count"/>
                  </c:if>
                  <c:if test="${rw.source == 'own'}">
                    <input type="number" class="form-control text-center" value="1" name="out_count"/>
                  </c:if>
                </td>
                <td style="color:#6B7280">
                  <input type="hidden" name="drug_measure" value="${rw.measure.id}">
                    ${rw.measure.name}
                </td>
                <td class="text-center">
                  <c:if test="${rw.state == 'ENT'}">
                    <button class="ab-ico del" type="button" title="Удалить" onclick="removeDrug(${loop.index}, ${rw.id})"><i class="fa fa-trash-o"></i></button>
                  </c:if>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </div>

        <!-- Даты приёма -->
        <div class="blk">
          <div class="sec-l">Даты приёма <span style="font-weight:400; color:#9AA1AC">— отметьте дни</span></div>
          <div class="dates-wrap">
            <table id="period_rows">
              <tr>
                <c:forEach items="${drug.dates}" var="date">
                  <td><fmt:formatDate pattern="dd.MM.yyyy" value="${date.date}"/></td>
                </c:forEach>
              </tr>
              <tr>
                <c:forEach items="${drug.dates}" var="date">
                  <td class="hand" onclick="setCheckbox()">
                    <input type="hidden" name="date_id" value="${date.id}"/>
                    <input type="hidden" name="dt_state" value="${date.state}"/>
                    <input type="hidden" name="dates" value="<fmt:formatDate pattern="dd.MM.yyyy" value="${date.date}"/>"/>
                    <input type="checkbox" name="date_state" <c:if test="${date.checked}">checked</c:if> <c:if test="${date.disabled}">disabled</c:if> value="<fmt:formatDate pattern="dd.MM.yyyy" value="${date.date}"/>"/>
                  </td>
                </c:forEach>
              </tr>
            </table>
          </div>
        </div>

        <!-- Время приёма и описание в одну строку -->
        <div class="row-f" style="margin-bottom:0; align-items:flex-end">
          <div class="fld">
            <label>Время приёма</label>
            <div class="tstrip">
              <div class="tg">
                <label class="tgm"><input type="checkbox" name="morningTime" onchange="setTimeCheck('morning')" <c:if test="${drug.morningTime}">checked</c:if>/> Утро</label>
                <label class="tgs"><input type="checkbox" name="morningTimeBefore" <c:if test="${drug.morningTimeBefore}">checked</c:if>/> до еды</label>
                <label class="tgs"><input type="checkbox" name="morningTimeAfter" <c:if test="${drug.morningTimeAfter}">checked</c:if>/> после</label>
              </div>
              <div class="tg">
                <label class="tgm"><input type="checkbox" name="noonTime" onchange="setTimeCheck('noon')" <c:if test="${drug.noonTime}">checked</c:if>/> Обед</label>
                <label class="tgs"><input type="checkbox" name="noonTimeBefore" <c:if test="${drug.noonTimeBefore}">checked</c:if>/> до еды</label>
                <label class="tgs"><input type="checkbox" name="noonTimeAfter" <c:if test="${drug.noonTimeAfter}">checked</c:if>/> после</label>
              </div>
              <div class="tg">
                <label class="tgm"><input type="checkbox" name="eveningTime" onchange="setTimeCheck('evening')" <c:if test="${drug.eveningTime}">checked</c:if>/> Вечер</label>
                <label class="tgs"><input type="checkbox" name="eveningTimeBefore" <c:if test="${drug.eveningTimeBefore}">checked</c:if>/> до еды</label>
                <label class="tgs"><input type="checkbox" name="eveningTimeAfter" <c:if test="${drug.eveningTimeAfter}">checked</c:if>/> после</label>
              </div>
            </div>
          </div>
          <div class="fld" style="flex:1 1 240px">
            <label>Описание</label>
            <input name="note" type="text" class="form-control" value="${drug.note}" placeholder="Дополнительные указания">
          </div>
        </div>
      </form>

      <div class="form-foot">
        <button class="ab primary" type="button" onclick="save()"><i class="fa fa-floppy-o"></i> Сохранить</button>
      </div>
    </div>
  </div>

  <!-- ================= Лист назначений ================= -->
  <div class="dr-card" style="overflow:hidden">
    <div class="dr-card-h">
      <h3>Лист назначений</h3>
      <span style="color:#6B7280; font-size:13px">${fn:length(list)}</span>
      <span class="sp"></span>
      <button class="ab sm" type="button" title="Обоснование" onclick="printObos()"><i class="fa fa-print"></i> Обоснование</button>
    </div>
    <div style="overflow-x:auto">
      <table class="ls miniGrid">
        <thead>
        <tr>
          <th>Наименование</th>
          <th style="width:200px">Тип</th>
          <th>Цель</th>
          <th style="width:190px">Период</th>
          <th>Описание</th>
          <th style="width:84px"></th>
        </tr>
        </thead>
        <c:forEach items="${list}" var="d" varStatus="lp">
          <tr id="patient-drug-${d.id}" class="main">
            <td>
              <a href="#" class="dname" title="Изменить" onclick="editDrug(${d.id}); return false;">
                <c:forEach items="${d.rows}" var="row" varStatus="loop">${row.name}<c:if test="${loop.index + 1 < fn:length(d.rows)}"><span class="plus">+</span></c:if></c:forEach>
              </a>
            </td>
            <td class="muted" style="white-space:normal">
                ${d.drugType.name}<c:if test="${d.drugType.id == 16}"> · ${d.injectionType.name}</c:if><c:if test="${d.drugType.id != 16}"> · ${d.tabletType}</c:if>
            </td>
            <td>${d.goal.name}</td>
            <td class="muted"><fmt:formatDate pattern="dd.MM.yyyy" value="${d.dateBegin}"/> — <fmt:formatDate pattern="dd.MM.yyyy" value="${d.dateEnd}"/></td>
            <td style="color:#3C4250">${d.note}</td>
            <td style="white-space:nowrap; text-align:right">
              <c:if test="${fn:length(d.dates) > 0}">
                <button class="ab-ico" type="button" title="Даты приёма" onclick="viewDetails(${lp.index})"><i class="fa fa-calendar"></i></button>
              </c:if>
              <c:if test="${d.canDel}">
                <button class="ab-ico del" type="button" title="Удалить" onclick="removePatientDrug(${d.id})"><i class="fa fa-trash-o"></i></button>
              </c:if>
            </td>
          </tr>
          <c:if test="${fn:length(d.dates) > 0}">
            <tr id="patient-drug-details-${d.id}" class="det">
              <td colspan="6">
                <div id="drug-line-${lp.index}" style="display: none">
                  <div class="det-dates">
                    <c:forEach items="${d.dates}" var="date">
                      <span class="${date.checked ? 'on' : ''}"><fmt:formatDate pattern="dd.MM.yyyy" value="${date.date}"/></span>
                    </c:forEach>
                  </div>
                </div>
              </td>
            </tr>
          </c:if>
        </c:forEach>
      </table>
      <c:if test="${empty list}"><div class="ls-empty">Назначений пока нет</div></c:if>
    </div>
  </div>

  <!-- ================= Экстренный шкаф ================= -->
  <c:if test="${fn:length(shocks) > 0}">
    <div class="dr-card" style="overflow:hidden" id="patient_drug_rows">
      <div class="dr-card-h"><h3>Экстренный шкаф</h3><span style="color:#6B7280; font-size:13px">${fn:length(shocks)}</span></div>
      <div style="overflow-x:auto">
        <table class="ls miniGrid">
          <thead>
          <tr>
            <th style="width:50px">№</th>
            <th>Склад</th>
            <th>Наименование</th>
            <th style="width:100px; text-align:right">Расход</th>
            <th style="width:100px">Ед. изм.</th>
            <th>Врач</th>
            <th style="width:140px">Дата и время</th>
          </tr>
          </thead>
          <c:forEach items="${shocks}" var="d" varStatus="lp">
            <tr class="main">
              <td class="muted">${lp.index + 1}</td>
              <td class="muted">${d.hndrug.direction.name}</td>
              <td id="edit_drug_name_${d.id}" style="font-weight:600">${d.drug.name}</td>
              <td style="text-align:right; font-variant-numeric:tabular-nums">${d.rasxod}</td>
              <td id="edit_drug_measure_${d.id}" class="muted">${d.hndrug.measure.name}</td>
              <td>${d.crBy.fio}</td>
              <td class="muted"><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${d.crOn}"/></td>
            </tr>
          </c:forEach>
        </table>
      </div>
    </div>
  </c:if>
</div>

<!-- ================= Модальное окно: выбор препарата ================= -->
<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
<div class="modal fade dr-modal" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog" style="width:640px; max-width:96vw">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel">
          <input type="text" placeholder="Поиск препаратов" onkeyup="filterDrugs()" class="form-control" style="font-size:15px; max-width:420px" id="drug-list-filter" value="">
        </h4>
      </div>
      <div class="modal-body">
        <table class="table table-bordered miniGrid" id="drug-list" style="width:100%">
          <thead>
          <tr>
            <th style="width:60px">№</th>
            <th>Наименование</th>
          </tr>
          </thead>
          <tbody>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<!-- ================= Модальное окно: шаблоны ================= -->
<a href="#" data-toggle="modal" data-target="#newModal" id="new_modal_window" class="hidden"></a>
<div class="modal fade dr-modal" id="newModal" tabindex="-1" role="dialog" aria-labelledby="newModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog" style="width:760px; max-width:96vw">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="newModalLabel">
          <input type="text" placeholder="Поиск шаблонов — введите и нажмите Enter" onkeyup="filterDrugTemps(this)" class="form-control" style="font-size:15px; max-width:none" id="temp-list-filter" value="">
        </h4>
      </div>
      <div class="modal-body" id="drug-temp-list" style="padding:0; max-height:62vh; overflow-y:auto"></div>
    </div>
  </div>
</div>

<script>
  var idx = 1, selected = 0;
  var drugs = [];
  <c:forEach items="${drugs}" var="d">
  drugs.push({id: ${d.id}, name: `${d.name}`, measure: `${d.measure.name}`});
  </c:forEach>
  $(".chzn-select").chosen();
  <c:forEach begin="0" end="${fn:length(rows)}" var="x">
  setSourceCode(${x});
  </c:forEach>
  initCheckers();
  /*region Scripts*/
  setDrugType(getDOM("drug_type_code"));

  // --- Период: календарь браузера <-> скрытые поля dateBegin/dateEnd (дд.мм.гггг) ---
  function drToIso(v) {
    var m = /^(\d{2})\.(\d{2})\.(\d{4})/.exec(v || '');
    return m ? (m[3] + '-' + m[2] + '-' + m[1]) : '';
  }
  function drFromIso(v) {
    if (!v) return '';
    var a = v.split('-');
    return a[2] + '.' + a[1] + '.' + a[0];
  }
  function drOpen(el) { try { el.showPicker(); } catch (e) {} }
  function drSyncDates() {
    $('#dateBegin').val(drFromIso($('#dateBeginPick').val()));
    $('#dateEnd').val(drFromIso($('#dateEndPick').val()));
    if ($('#dateBegin').val() && $('#dateEnd').val()) setPeriod();
  }
  $('#dateBeginPick').val(drToIso($('#dateBegin').val()));
  $('#dateEndPick').val(drToIso($('#dateEnd').val()));

  function setSourceCode(idx) {
    if($('#line_' + idx + ' [name=source_code]').val() === 'own') {
      $('#line_' + idx).find('.source_code_own').show();
      $('#line_' + idx).find('.source_code_cln').hide();
      $('#line_' + idx).find('.measure_select').hide();
      $('#line_' + idx).find('input[name=out_count]').hide();
    } else {
      $('#line_' + idx).find('.source_code_cln').show();
      $('#line_' + idx).find('.source_code_own').hide();
      $('#line_' + idx).find('.measure_select').show();
      $('#line_' + idx).find('input[name=out_count]').show();
    }
  }
  function addDrug() {
    setLocation('drugs.s');
  }
  function addGoal() {
    var pr = prompt('Новая цель! Введите наименование');
    if (pr != null) {
      $.ajax({
        url:'/lv/drug/addgoal.s',
        method:'post',
        data:'goal=' + pr,
        dataType:'json',
        success:function (res) {
          $('select[name=goal]').each(function (elem, dom) {
            var options = dom.options;
            dom.options[options.length] = new Option(pr, res.id);
            $(this).trigger('liszt:updated');
          });
        }
      });
    }
  }
  function markRequired() {
    var elems = $('input,select').filter('[required]:visible');
    var isErr = false;
    for(var i=0;i<elems.length;i++) {
      if(elems[i].value === '') {
        elems[i].style.borderColor = '#D7182E';
        isErr = true;
      } else {
        elems[i].style.borderColor = '';
      }
    }
    // препарат клиники должен быть выбран из списка подсказок
    $('.dp:visible').each(function () {
      var v = $(this).find('input[name=drug_drug]').val();
      var bad = (v === '' || v === '0');
      $(this).find('.dp-input').toggleClass('bad', bad);
      if (bad) isErr = true;
    });
    if(isErr) {
      alert('Заполните все обязательные поля (препарат нужно выбрать из списка подсказок)');
      return false;
    }
    if($('#drug-lines').find('tbody').find('tr').length === 0) {
      alert('Список препаратов не может быть пустым');
      return false;
    }
    return true;
  }
  function save() {
    if (!markRequired()) return;
    $.ajax({
      url:'/lv/drugs/save.s',
      method:'post',
      data: $('#add_edit_drug').serialize(),
      dataType:'json',
      success:function (res) {
        if(res.success) {
          alert('Данные успешно сохранены');
          setLocation('/lv/drugs.s');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function setTimeCheck(code) {
    var status = $('input[name=' + code + 'Time]').is(':checked');
    if(code === 'morning') {
      $('input[name=morningTimeBefore]').attr('disabled', !status).attr('checked', false);
      $('input[name=morningTimeAfter]').attr('disabled', !status).attr('checked', false);
    }
    if(code === 'noon') {
      $('input[name=noonTimeBefore]').attr('disabled', !status).attr('checked', false);
      $('input[name=noonTimeAfter]').attr('disabled', !status).attr('checked', false);
    }
    if(code === 'evening') {
      $('input[name=eveningTimeBefore]').attr('disabled', !status).attr('checked', false);
      $('input[name=eveningTimeAfter]').attr('disabled', !status).attr('checked', false);
    }
  }
  /*region Выбор препарата: поле поиска с подсказками (вместо выпадающего списка chosen)*/
  var dpAct = null;
  function dpEsc(s) { return $('<div/>').text(s == null ? '' : s).html(); }
  function dpMatches(q) {
    q = $.trim(q).toLowerCase();
    if (!q) return drugs.slice(0, 60);
    var words = q.split(/\s+/), res = [];
    for (var i = 0; i < drugs.length; i++) {
      var n = drugs[i].name.toLowerCase(), ok = true;
      for (var w = 0; w < words.length; w++) {
        if (n.indexOf(words[w]) === -1) { ok = false; break; }
      }
      if (ok) res.push({d: drugs[i], s: n.indexOf(words[0]) === 0 ? 0 : 1});
    }
    res.sort(function (a, b) { return a.s - b.s; });
    return res.slice(0, 60).map(function (x) { return x.d; });
  }
  function dpMark(name, q) {
    var low = name.toLowerCase(), ranges = [];
    $.each($.trim(q).toLowerCase().split(/\s+/), function (i, w) {
      if (!w) return;
      var p = low.indexOf(w);
      while (p > -1) { ranges.push([p, p + w.length]); p = low.indexOf(w, p + w.length); }
    });
    ranges.sort(function (a, b) { return a[0] - b[0]; });
    var out = '', pos = 0;
    $.each(ranges, function (i, r) {
      if (r[1] <= pos) return;
      var s = Math.max(r[0], pos);
      out += dpEsc(name.substring(pos, s)) + '<mark>' + dpEsc(name.substring(s, r[1])) + '</mark>';
      pos = r[1];
    });
    return out + dpEsc(name.substring(pos));
  }
  function dpList() {
    var l = $('#dp-list');
    if (!l.length) l = $('<div id="dp-list" class="dp-list"></div>').appendTo('body');
    return l;
  }
  function dpClose() { $('#dp-list').removeClass('open'); dpAct = null; }
  function dpRender($dp) {
    var list = dpList(), inp = $dp.find('.dp-input'), q = inp.val();
    var items = dpMatches(q);
    dpAct = {dp: $dp, items: items, i: items.length ? 0 : -1};
    list.empty();
    if (!items.length) list.append('<div class="dp-none">Ничего не найдено</div>');
    $.each(items, function (i, d) {
      list.append($('<div class="dp-item"></div>').toggleClass('act', i === 0).attr('data-i', i)
        .html('<span>' + dpMark(d.name, q) + '</span><span class="m">' + dpEsc(d.measure) + '</span>'));
    });
    var r = inp[0].getBoundingClientRect();
    list.addClass('open').css({left: r.left, width: Math.max(r.width, 380)});
    var h = list.outerHeight();
    var top = (r.bottom + h + 8 > window.innerHeight && r.top > h + 8) ? r.top - h - 2 : r.bottom + 2;
    list.css({top: top});
  }
  function dpMove(step) {
    if (!dpAct || !dpAct.items.length) return;
    dpAct.i = (dpAct.i + step + dpAct.items.length) % dpAct.items.length;
    var list = dpList();
    list.find('.dp-item').removeClass('act').eq(dpAct.i).addClass('act');
    var el = list.find('.dp-item').eq(dpAct.i)[0];
    if (el && el.scrollIntoView) el.scrollIntoView({block: 'nearest'});
  }
  function dpPick($dp, d) {
    $dp.find('.dp-input').val(d.name).removeClass('bad');
    $dp.find('input[name=drug_drug]').val(d.id);
    $dp.closest('tr').find('.measure_select').val(d.measure);
    dpClose();
  }
  $(document)
    .on('focus click', '.dp-input', function () { dpRender($(this).closest('.dp')); })
    .on('input', '.dp-input', function () {
      var $dp = $(this).closest('.dp');
      $dp.find('input[name=drug_drug]').val('0');
      $dp.closest('tr').find('.measure_select').val('');
      dpRender($dp);
    })
    .on('keydown', '.dp-input', function (e) {
      if (e.which === 40) { e.preventDefault(); dpMove(1); }
      else if (e.which === 38) { e.preventDefault(); dpMove(-1); }
      else if (e.which === 13) {
        e.preventDefault();
        if (dpAct && dpAct.i > -1) dpPick(dpAct.dp, dpAct.items[dpAct.i]);
      } else if (e.which === 27 || e.which === 9) dpClose();
    })
    .on('focusout', '.dp-input', function () {
      var $dp = $(this).closest('.dp'), v = $.trim($(this).val()).toLowerCase();
      if (!v || $dp.find('input[name=drug_drug]').val() !== '0') return;
      for (var i = 0; i < drugs.length; i++) {
        if (drugs[i].name.toLowerCase() === v) { dpPick($dp, drugs[i]); return; }
      }
    })
    .on('mousedown', '.dp-item', function (e) {
      e.preventDefault();
      if (dpAct) dpPick(dpAct.dp, dpAct.items[$(this).data('i')]);
    })
    .on('mousedown', function (e) {
      if (!$(e.target).closest('.dp, #dp-list').length) dpClose();
    });
  $(window).on('resize scroll', function () { dpClose(); });
  /*endregion*/
  function newDrugLine() {
    this.idx++;
    var tr = $('<tr id="line_' + this.idx + '"></tr>');
    var td1 = $('<td></td>');
    var rowId = $('<input type="hidden" name="row_id" value="0"/>');
    var sourceCode = $('<select name="source_code" class="form-control" onchange="setSourceCode(' + this.idx + ')"><option value="cln">Клиника</option><option value="own">Свой</option></select>');
    td1.append(sourceCode).append(rowId);
    var td2 = $('<td></td>');
    var nameDiv = $('<div class="source_code_own" style="display: none"></div>');
    var drugName = $('<input type="text" name="drug_name" maxlength="256" value="" class="form-control" placeholder="Название препарата">');
    nameDiv.append(drugName);
    var drugDiv = $('<div class="source_code_cln dp" style="width:100%"></div>');
    drugDiv.append('<input type="text" class="form-control dp-input" placeholder="Начните вводить название препарата" autocomplete="off">');
    drugDiv.append('<input type="hidden" name="drug_drug" value="0">');
    td2.append(nameDiv).append(drugDiv);
    var td3 = $('<td></td>');
    var outInput = $('<input type="number" class="form-control text-center" value="1" name="out_count"/>');
    td3.append(outInput);
    var td4 = $('<td></td>');
    var measureInput = $('<input class="form-control measure_select" disabled name="drug_measure"/>');
    td4.append(measureInput);
    var td5 = $('<td class="text-center"></td>');
    var btn = $('<button class="ab-ico del" type="button" title="Удалить" onclick=\'$("#line_' + this.idx + '").remove()\'><i class="fa fa-trash-o"></i></button>');
    td5.append(btn);
    tr.append(td1).append(td2).append(td3).append(td4).append(td5);
    $('#drug-lines').find('tbody').append(tr);
    drugDiv.find('.dp-input').focus();
  }
  function setMeasure(dom, idx) {
    $('#line_' + idx).find('.measure_select').val(dom.options[dom.selectedIndex].getAttribute("measure"));
  }
  function setPeriod() {
    $.ajax({
      url:'/lv/drugs/setPeriod.s',
      method:'post',
      data: 'begin=' + $('#dateBegin').val() + '&end=' + $('#dateEnd').val(),
      dataType:'json',
      success:function (res) {
        if(res.success) {
          var tr = $('<tr></tr>');
          for(var i=0;i<res.dates.length;i++) {
            var td = $('<td>' + res.dates[i].date + '</td>');
            tr.append(td);
          }
          var trs = $('<tr></tr>');
          for(var i=0;i<res.dates.length;i++) {
            var td = $('<td class="hand" onclick="setCheckbox()"></td>');
            var input = $('<input type="checkbox" name="date_state" value="' + res.dates[i].date + '"/>');
            if(res.dates[i].state)
              input.attr('checked', true);
            input.val(res.dates[i].date);
            td.append(input).append($('<input type="hidden" name="date_id" value="0"/>'))
              .append('<input type="hidden" name="dates" value="' + res.dates[i].date + '" />')
              .append($('<input type="hidden" name="dt_state" value="ENT"/>'));
            trs.append(td);
          }
          $('#period_rows').empty().append(tr);
          $('#period_rows').append(trs);
        } else {
          alert(res.msg);
        }
      }
    });
  }
  //
  function viewDetails(idx) {
    $('#drug-line-' + idx).slideToggle();
  }
  function editDrug(id) {
    document.location = '/lv/drugs.s?id=' + id;
  }
  function initCheckers() {
    var morningStatus = $('input[name=morningTime]').is(':checked');
    var noonStatus = $('input[name=noonTime]').is(':checked');
    var eveningStatus = $('input[name=eveningTime]').is(':checked');
    //
    var dmorningStatus = $('input[name=morningTime]').is(':disabled');
    var dnoonStatus = $('input[name=noonTime]').is(':disabled');
    var deveningStatus = $('input[name=eveningTime]').is(':disabled');
    $('input[name=morningTimeBefore]').attr('disabled', !morningStatus || dmorningStatus);
    $('input[name=morningTimeAfter]').attr('disabled', !morningStatus || dmorningStatus);
    $('input[name=noonTimeBefore]').attr('disabled', !noonStatus || dnoonStatus);
    $('input[name=noonTimeAfter]').attr('disabled', !noonStatus || dnoonStatus);
    $('input[name=eveningTimeBefore]').attr('disabled', !eveningStatus || deveningStatus);
    $('input[name=eveningTimeAfter]').attr('disabled', !eveningStatus || deveningStatus);
  }
  function removeDrug(idx, id) {
    FmsConfirm('Вы действительно хотите удалить выбранную запись?', function () { $.ajax({
        url: '/lv/drugs/removeDrug.s',
        data: 'id=' + id,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно удалены');
            $('#line_' + idx).remove();
          } else
            alert(res.msg);
        }
      }); });
  }
  function removePatientDrug(id) {
    FmsConfirm('Вы действительно хотите удалить выбранную запись?', function () { $.ajax({
        url: '/lv/drugs/removePatientDrug.s',
        data: 'id=' + id,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно удалены');
            $('#patient-drug-' + id).remove();
            $('#patient-drug-details-' + id).remove();
          } else
            alert(res.msg);
        }
      }); });
  }
  function setCheckbox() {
    if(event.target.tagName == 'TD') {
      var elem = event.target.querySelector('INPUT[type=checkbox]');
      if(!elem) return;
      if(elem.disabled && elem.checked) {
        errMsg('Нельзя отменить медикаменты! Медсестры уже выполнили задание');
        return;
      }
      if(!elem.disabled)
        elem.click();
    }
  }
  function setDrugType(dom) {
    $('#injection_type_label').toggle(dom.value == 16);
    $('#injection_type').attr('required', dom.value == 16).toggle(dom.value == 16);
    $('#tablet_type_label').toggle(dom.value != 16);
    $('#tablet_type').attr('required', dom.value != 16).toggle(dom.value != 16);
  }
  function printObos() {
    window.open('/lv/print.s?obos=Y');
  }
  function saveTemplate() {
    if (!markRequired()) return;
    $.ajax({
      url:'/lv/drugs/template/save.s',
      method:'post',
      data: 'id=${drug.id}',
      dataType:'json',
      success:function (res) {
        if(res.success) {
          alert('Данные успешно сохранены');
          setLocation('/lv/drugs.s');
        } else {
          alert(res.msg);
        }
      }
    });
  }
  function fromTemplate() {
    $('#drug-temp-list').load('drug/temps.s', ()=> {
      $('#new_modal_window').click();
    });
  }
  function filterDrugTemps(dom) {
    event.preventDefault();
    if(event.keyCode == 13) {
      $('#drug-temp-list').load('drug/temps.s?filter=' + dom.value);
    }
  }
  function removeDrugTemp(id) {
    FmsConfirm('Вы действительно хотите удалить запись?', function () { $.ajax({
        url: '/lv/drug/temp/delete.s',
        data: 'id=' + id,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            $('#drug-row-temp-' + id).remove();
          } else
            alert(res.msg);
        }
      }); });
  }
  /*endregion*/
</script>
