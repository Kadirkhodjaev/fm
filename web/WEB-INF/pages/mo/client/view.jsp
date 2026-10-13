<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Регистрация → Клиенты → карточка клиента: реквизиты, Telegram, дубликаты, визиты, закрепление записей --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<style>
  .cv-wrap { max-width:1300px; margin:0 auto; padding:12px; display:flex; flex-direction:column; gap:12px; }
  .cv-card { background:#fff; border:1px solid #E6E8EC; border-radius:14px; }
  .cv-h { display:flex; align-items:center; gap:8px; padding:11px 16px; border-bottom:1px solid #F0F1F4; font-weight:700; font-size:14px; }
  .cv-h .fa { color:#6B7280; width:16px; text-align:center; }
  .cv-h small { font-weight:500; color:#9AA0AB; font-size:12px; }
  .cv-h .fm-spacer { flex:1; }
  .cv-b { padding:14px 16px; }
  .cv-form { display:grid; grid-template-columns:repeat(6, 1fr); gap:12px; }
  .cv-form .s2 { grid-column:span 2; }
  .cv-form .s3 { grid-column:span 3; }
  .cv-form .s4 { grid-column:span 4; }
  .cv-form .s6 { grid-column:span 6; }
  .cv-form .up { text-transform:uppercase; }
  .cv-form .c { text-align:center; }
  .cv-st { display:inline-flex; align-items:center; gap:6px; padding:2px 10px; border-radius:20px; font-size:12px; font-weight:600; background:#F1F2F4; color:#6B7280; white-space:nowrap; }
  .cv-st:before { content:''; width:7px; height:7px; border-radius:50%; background:#C3C7CE; }
  .cv-st.ok { background:#E8F6EE; color:#1E7A4A; }
  .cv-st.ok:before { background:#2E9E62; }
  .cv-st.wk { background:#EEF4FF; color:#2F5BBF; }
  .cv-st.wk:before { background:#3B6FE0; }
  .cv-st.wt { background:#FFF6E5; color:#8A5A00; }
  .cv-st.wt:before { background:#F59E0B; }
  .cv-tg { display:flex; align-items:center; gap:12px; flex-wrap:wrap; }
  .cv-chips { display:flex; flex-wrap:wrap; gap:8px; align-items:center; }
  .cv-chips .lbl { color:#6B7280; font-size:12px; font-weight:600; width:150px; }
  .cv-chip { display:inline-flex; align-items:center; gap:6px; height:30px; padding:0 12px; border:1px solid #E6E8EC; border-radius:9px; background:#fff; font-size:13px; cursor:pointer; user-select:none; }
  .cv-chip:hover { border-color:#C9CDD5; }
  .cv-chip.on { border-color:#1F2430; background:#1F2430; color:#fff; font-weight:600; }
  .cv-chip .fa { font-size:11px; }
  .cv-card .fm-grid td { white-space:nowrap; }
  .cv-card .fm-grid tr.go { cursor:pointer; }
  .cv-empty { color:#9AA0AB; padding:16px; text-align:center; }
</style>
<c:set var="noVisits" value="${fn:length(ambs) == 0 && fn:length(stats) == 0}"/>
<div class="fm-page fm-admin">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-user"></i></span>
        <div>
          <h2>${fn:escapeXml(client.fio)}</h2>
          <span class="fm-count">ID <b>${client.id}</b> · амбулатория <b>${fn:length(ambs)}</b> · стационар <b>${fn:length(stats)}</b></span>
        </div>
      </div>
      <span class="cv-st ${client.flag == 'DONE' ? 'ok' : ''}">${client.flag == 'DONE' ? 'Проверено' : 'Не проверено'}</span>
      <span class="fm-spacer"></span>
      <c:if test="${noVisits}">
        <button type="button" class="fm-btn danger" onclick="cvDel()"><i class="fa fa-trash-o"></i>Удалить</button>
      </c:if>
      <c:if test="${client.flag != 'DONE'}">
        <button type="button" class="fm-btn" onclick="cvFlag()"><i class="fa fa-check-circle"></i>Проверено</button>
      </c:if>
      <button type="button" class="fm-btn primary" id="cvSaveBtn" onclick="cvSave()"><i class="fa fa-floppy-o"></i>Сохранить</button>
      <button type="button" class="fm-btn" onclick="setPage('/clients/list.s')"><i class="fa fa-arrow-left"></i>Назад</button>
    </div>
    <div class="fm-table-wrap" style="background:#F7F8FA">
      <div class="cv-wrap">

        <div class="cv-card">
          <div class="cv-h"><i class="fa fa-user"></i>Реквизиты</div>
          <div class="cv-b">
            <div class="fm-err" id="cvErr" style="margin-bottom:12px"></div>
            <form id="cvForm" onsubmit="cvSave(); return false" autocomplete="off">
              <input type="hidden" value="${client.id}" name="cl_id"/>
              <div class="cv-form">
                <div class="s2"><label class="fm-l">Фамилия *</label><input name="cl_surname" class="fm-in up" maxlength="64" value="${fn:escapeXml(client.surname)}"/></div>
                <div class="s2"><label class="fm-l">Имя *</label><input name="cl_name" class="fm-in up" maxlength="64" value="${fn:escapeXml(client.name)}"/></div>
                <div class="s2"><label class="fm-l">Отчество</label><input name="cl_middlename" class="fm-in up" maxlength="64" value="${fn:escapeXml(client.middlename)}"/></div>

                <div><label class="fm-l">Дата рождения *</label><input name="cl_birthdate" id="cvBirth" class="fm-in c" placeholder="дд.мм.гггг" maxlength="10" value="<fmt:formatDate pattern="dd.MM.yyyy" value="${client.birthdate}"/>"/></div>
                <div>
                  <label class="fm-l">Пол *</label>
                  <select name="cl_sex_id" class="fm-in">
                    <c:forEach items="${sex}" var="sx">
                      <option <c:if test="${client.sex.id == sx.id}">selected</c:if> value="${sx.id}">${sx.name}</option>
                    </c:forEach>
                  </select>
                </div>
                <div><label class="fm-l">Серия паспорта</label><input name="cl_doc_seria" class="fm-in c up" maxlength="2" placeholder="AA" value="${fn:escapeXml(client.docSeria)}"/></div>
                <div><label class="fm-l">Номер паспорта</label><input name="cl_doc_num" class="fm-in c" maxlength="10" placeholder="1234567" value="${fn:escapeXml(client.docNum)}"/></div>
                <div class="s2"><label class="fm-l">Кем и когда выдан</label><input name="cl_doc_info" class="fm-in" maxlength="64" value="${fn:escapeXml(client.docInfo)}"/></div>

                <div class="s2"><label class="fm-l">Телефон</label><input name="cl_tel" class="fm-in" maxlength="400" placeholder="+998 XX XXX XX XX" value="${fn:escapeXml(client.tel)}"/></div>
                <div class="s2">
                  <label class="fm-l">Резидентство *</label>
                  <select name="cl_country_id" id="cvCountry" class="fm-in" onchange="cvCountry()">
                    <c:forEach items="${counteries}" var="reg">
                      <option <c:if test="${client.country.id == reg.id}">selected</c:if> value="${reg.id}">${reg.name}</option>
                    </c:forEach>
                  </select>
                </div>
                <div class="s2" id="cvRegionBox">
                  <label class="fm-l">Область</label>
                  <select name="cl_region_id" id="cvRegion" class="fm-in">
                    <option value="">Не выбрано</option>
                    <c:forEach items="${regions}" var="reg">
                      <option <c:if test="${client.region.id == reg.id}">selected</c:if> value="${reg.id}">${reg.name}</option>
                    </c:forEach>
                  </select>
                </div>
                <div class="s6"><label class="fm-l">Адрес</label><input name="cl_address" class="fm-in" maxlength="400" value="${fn:escapeXml(client.address)}"/></div>
              </div>
            </form>
          </div>
        </div>

        <c:if test="${not empty tg}">
          <div class="cv-card">
            <div class="cv-h"><i class="fa fa-paper-plane"></i>Telegram-помощник</div>
            <div class="cv-b cv-tg">
              <c:choose>
                <c:when test="${tg.linked == 'Y'}">
                  <span class="cv-st ok">Подключён</span>
                  <span>через бот<c:if test="${not empty tg.phone}">, номер ${fn:escapeXml(tg.phone)}</c:if><c:if test="${not empty tg.linkedDate}">, с ${tg.linkedDate}</c:if>. Результаты отправляются кнопкой <i class="fa fa-paper-plane"></i> в визитах амбулатории.</span>
                </c:when>
                <c:otherwise>
                  <span class="cv-st">Не подключён</span>
                  <c:if test="${tgInvite}">
                    <button type="button" class="fm-btn" id="tgInviteBtn" onclick="tgInvite()" <c:if test="${empty tgPhone}">disabled title="В карточке неполный номер телефона"</c:if>>
                      <i class="fa fa-paper-plane"></i>Отправить ссылку в Telegram
                    </button>
                    <c:if test="${empty tgPhone}"><span class="mut" style="color:#9AA0AB; font-size:12px">в карточке неполный номер телефона</span></c:if>
                  </c:if>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </c:if>

        <c:if test="${fn:length(dublicates) > 0}">
          <div class="cv-card" id="cvDups">
            <div class="cv-h"><i class="fa fa-files-o"></i>Возможные дубликаты <small>визиты дубликата переходят на эту карточку, дубликат удаляется</small></div>
            <table class="fm-grid">
              <thead><tr><th style="width:50px">#</th><th>ФИО</th><th class="c" style="width:130px">Амбулатория</th><th class="c" style="width:130px">Стационар</th><th style="width:140px"></th></tr></thead>
              <tbody>
              <c:forEach items="${dublicates}" var="d" varStatus="loop">
                <tr id="client_${d.id}">
                  <td class="mut">${loop.index + 1}</td>
                  <td><a href="#" onclick="setPage('/clients/view.s?id=${d.id}'); return false">${fn:escapeXml(d.fio)}</a> <span class="mut">ID ${d.id}</span></td>
                  <td class="c">${d.ambCount}</td>
                  <td class="c">${d.statCount}</td>
                  <td class="r"><button type="button" class="fm-btn" onclick="cvCombine(${d.id})"><i class="fa fa-compress"></i>Объединить</button></td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </c:if>

        <div class="cv-card">
          <div class="cv-h"><i class="fa fa-user-md"></i>Визиты в амбулаторию <small>${fn:length(ambs)}</small></div>
          <c:choose>
            <c:when test="${fn:length(ambs) == 0}"><div class="cv-empty">Визитов нет</div></c:when>
            <c:otherwise>
              <table class="fm-grid">
                <thead>
                <tr>
                  <th style="width:50px">#</th>
                  <th>ФИО в записи</th>
                  <th style="width:120px">Год рождения</th>
                  <th style="width:150px">Дата рег.</th>
                  <th style="width:170px">Состояние</th>
                  <th style="width:130px"></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${ambs}" var="rw" varStatus="loop">
                  <tr class="go" onclick="setPage('/amb/reg.s?id=${rw.id}')" title="Открыть запись">
                    <td class="mut">${loop.index + 1}</td>
                    <td>${fn:escapeXml(rw.fio)}</td>
                    <td>${rw.birthyear}</td>
                    <td><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${rw.crOn}"/></td>
                    <td>
                      <c:choose>
                        <c:when test="${rw.state == 'PRN'}"><span class="cv-st">Регистрация</span></c:when>
                        <c:when test="${rw.state == 'CASH'}"><span class="cv-st wt">Ожидание оплаты</span></c:when>
                        <c:when test="${rw.state == 'WORK'}"><span class="cv-st wk">Оказание услуг</span></c:when>
                        <c:when test="${rw.state == 'DONE'}"><span class="cv-st ok">Услуги оказаны</span></c:when>
                        <c:when test="${rw.state == 'ARCH'}"><span class="cv-st">Закрыта</span></c:when>
                        <c:otherwise><span class="cv-st">${rw.state}</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td class="r" onclick="event.stopPropagation()">
                      <c:if test="${tg.linked == 'Y'}">
                        <button type="button" class="fm-act" title="Отправить PDF результатов в Telegram" onclick="tgResult(${rw.id}, this)" <c:if test="${rw.state != 'DONE' && rw.state != 'ARCH'}">disabled</c:if>><i class="fa fa-paper-plane"></i></button>
                      </c:if>
                      <c:if test="${sessionScope.ENV.userId == 1}">
                        <button type="button" class="fm-act" title="Обновить данные записи из карточки" onclick="cvUpd('amb', ${rw.id})"><i class="fa fa-refresh"></i></button>
                        <button type="button" class="fm-act danger" title="Открепить запись от клиента" onclick="cvRemove('amb', ${rw.id})"><i class="fa fa-chain-broken"></i></button>
                      </c:if>
                    </td>
                  </tr>
                </c:forEach>
                </tbody>
              </table>
            </c:otherwise>
          </c:choose>
        </div>

        <div class="cv-card">
          <div class="cv-h"><i class="fa fa-h-square"></i>Стационар <small>${fn:length(stats)}</small></div>
          <c:choose>
            <c:when test="${fn:length(stats) == 0}"><div class="cv-empty">Госпитализаций нет</div></c:when>
            <c:otherwise>
              <table class="fm-grid">
                <thead>
                <tr>
                  <th style="width:50px">#</th>
                  <th>ФИО в записи</th>
                  <th style="width:120px">Год рождения</th>
                  <th style="width:100px">ИБ №</th>
                  <th style="width:120px">Поступление</th>
                  <th style="width:120px">Выписка</th>
                  <th style="width:190px">Состояние</th>
                  <c:if test="${sessionScope.ENV.userId == 1}"><th style="width:90px"></th></c:if>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${stats}" var="rw" varStatus="loop">
                  <tr>
                    <td class="mut">${loop.index + 1}</td>
                    <td>${fn:escapeXml(rw.fio)}</td>
                    <td>${rw.birthyear}</td>
                    <td>${rw.yearNum}</td>
                    <td><fmt:formatDate pattern="dd.MM.yyyy" value="${rw.dateBegin}"/></td>
                    <td><fmt:formatDate pattern="dd.MM.yyyy" value="${rw.dateEnd}"/></td>
                    <td>
                      <c:choose>
                        <c:when test="${rw.state == 'PRN'}"><span class="cv-st">Регистрация</span></c:when>
                        <c:when test="${rw.state == 'PRD'}"><span class="cv-st wt">Приёмное отделение</span></c:when>
                        <c:when test="${rw.state == 'LV'}"><span class="cv-st wk">Текущий пациент</span></c:when>
                        <c:when test="${rw.state == 'CZG'}"><span class="cv-st wt">На утверждении</span></c:when>
                        <c:when test="${rw.state == 'ZGV'}"><span class="cv-st ok">Подтверждён</span></c:when>
                        <c:when test="${rw.state == 'ARCH'}"><span class="cv-st">Закрыта</span></c:when>
                        <c:otherwise><span class="cv-st">${rw.state}</span></c:otherwise>
                      </c:choose>
                    </td>
                    <c:if test="${sessionScope.ENV.userId == 1}">
                      <td class="r">
                        <button type="button" class="fm-act" title="Обновить данные записи из карточки" onclick="cvUpd('stat', ${rw.id})"><i class="fa fa-refresh"></i></button>
                        <button type="button" class="fm-act danger" title="Открепить запись от клиента" onclick="cvRemove('stat', ${rw.id})"><i class="fa fa-chain-broken"></i></button>
                      </td>
                    </c:if>
                  </tr>
                </c:forEach>
                </tbody>
              </table>
            </c:otherwise>
          </c:choose>
        </div>

        <c:if test="${client.flag != 'DONE'}">
          <div class="cv-card">
            <div class="cv-h"><i class="fa fa-link"></i>Закрепление записей <small>записи без клиента, совпадающие по выбранным полям</small></div>
            <div class="cv-b">
              <div class="cv-chips">
                <span class="lbl">Совпадение по полям</span>
                <span class="cv-chip" data-c="surname"><i class="fa fa-check"></i>Фамилия</span>
                <span class="cv-chip" data-c="name"><i class="fa fa-check"></i>Имя</span>
                <span class="cv-chip" data-c="middlename"><i class="fa fa-check"></i>Отчество</span>
                <span class="cv-chip" data-c="birth"><i class="fa fa-check"></i>Год рождения</span>
              </div>
            </div>
            <table class="fm-grid" id="cvLinkTable" style="display:none">
              <thead>
              <tr>
                <th style="width:50px">#</th>
                <th style="width:80px">Где</th>
                <th>ФИО</th>
                <th style="width:120px">Рождение</th>
                <th style="width:90px">Пол</th>
                <th style="width:200px">Документ</th>
                <th style="width:100px">Состояние</th>
                <th style="width:130px"></th>
              </tr>
              </thead>
              <tbody id="cvLinkRows"></tbody>
            </table>
            <div class="cv-empty" id="cvLinkEmpty">Выберите поля для поиска записей</div>
          </div>
        </c:if>

      </div>
    </div>
  </div>
</div>
<script>
  (function () {
    var CID = ${client.id};
    function esc(t) { return String(t == null ? '' : t).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;'); }
    function post(url, data, ok) {
      $.ajax({
        url: url, method: 'post', data: data, dataType: 'json',
        success: function (res) { if (res.success) ok(res); else FmsToast.show(res.msg || 'Ошибка', 'err'); }
      });
    }
    // маска даты рождения: плагин подключается, только если его ещё нет
    function mask() { if ($.fn.mask) $('#cvBirth').mask('99.99.9999', {placeholder: '_'}); }
    if ($.fn.mask) mask(); else $.getScript('/res/js/jquery.maskedinput.js', mask);

    window.cvCountry = function () {
      var uz = $('#cvCountry').val() === '199';
      $('#cvRegionBox').toggle(uz);
      if (!uz) $('#cvRegion').val('').trigger('change');
    };
    window.cvSave = function () {
      var f = document.getElementById('cvForm'), err = '';
      if (!$.trim(f.elements['cl_surname'].value)) err = 'Укажите фамилию';
      else if (!$.trim(f.elements['cl_name'].value)) err = 'Укажите имя';
      else if (!/^\d{2}\.\d{2}\.\d{4}$/.test(f.elements['cl_birthdate'].value)) err = 'Укажите дату рождения в формате дд.мм.гггг';
      if (err) { DK.err('cv', err); return; }
      $('#cvErr').hide();
      $('#cvSaveBtn').prop('disabled', true);
      $.ajax({
        url: '/clients/save.s', method: 'post', data: $(f).serialize(), dataType: 'json',
        success: function (res) {
          if (res.success) { openMsg(res); setPage('/clients/view.s?id=' + CID); }
          else DK.err('cv', res.msg);
        },
        complete: function () { $('#cvSaveBtn').prop('disabled', false); }
      });
    };
    window.cvFlag = function () {
      post('/clients/set/flag.s', 'id=' + CID, function () { FmsToast.show('Клиент отмечен как проверенный', 'ok'); setPage('/clients/list.s'); });
    };
    window.cvDel = function () {
      FmsConfirm('Удалить карточку клиента?', function () {
        post('/clients/del.s', 'id=' + CID, function () { FmsToast.show('Карточка удалена', 'ok'); setPage('/clients/list.s'); });
      });
    };
    window.cvCombine = function (old) {
      FmsConfirm('Объединить: визиты дубликата перейдут на эту карточку, а сам дубликат будет удалён?', function () {
        post('/clients/combine.s', 'old=' + old + '&cur=' + CID, function () { FmsToast.show('Клиенты объединены', 'ok'); setPage('/clients/view.s?id=' + CID); });
      }, {ok: 'Объединить'});
    };
    window.cvUpd = function (type, id) {
      FmsConfirm('Перезаписать ФИО, дату рождения, пол и адрес в записи данными из карточки?', function () {
        post('/clients/update/patient.s', 'id=' + CID + '&type=' + type + '&patient=' + id, function () { FmsToast.show('Запись обновлена', 'ok'); setPage('/clients/view.s?id=' + CID); });
      }, {ok: 'Обновить'});
    };
    window.cvRemove = function (type, id) {
      FmsConfirm('Открепить эту запись от клиента?', function () {
        post('/clients/remove/patient.s', 'type=' + type + '&patient=' + id, function () { FmsToast.show('Запись откреплена', 'ok'); setPage('/clients/view.s?id=' + CID); });
      }, {danger: true, ok: 'Открепить'});
    };
    // закрепление: записи без клиента, совпадающие с карточкой по выбранным полям
    function linkRows() {
      var codes = $('.cv-chip.on').map(function () { return 'code=' + $(this).attr('data-c'); }).get();
      $('#cvLinkRows').html('');
      if (!codes.length) { $('#cvLinkTable').hide(); $('#cvLinkEmpty').text('Выберите поля для поиска записей').show(); return; }
      post('/clients/get/rows.s', 'id=' + CID + '&' + codes.join('&'), function (res) {
        var rows = res.patients || [], h = [];
        for (var i = 0; i < rows.length; i++) {
          var g = rows[i];
          h.push('<tr><td class="mut">' + (i + 1) + '</td><td><span class="cv-st ' + (g.type === 'amb' ? 'wk' : 'wt') + '">' + (g.type === 'amb' ? 'Амб' : 'Стац') + '</span></td>' +
            '<td>' + esc(g.fio) + '</td><td>' + esc(g.birth) + '</td><td>' + esc(g.sex) + '</td><td>' + esc(g.doc) + '</td><td class="mut">' + esc(g.state) + '</td>' +
            '<td class="r"><button type="button" class="fm-btn" data-t="' + g.type + '" data-id="' + g.id + '"><i class="fa fa-link"></i>Закрепить</button></td></tr>');
        }
        $('#cvLinkRows').html(h.join(''));
        $('#cvLinkTable').toggle(rows.length > 0);
        $('#cvLinkEmpty').text('Совпадающих записей без клиента нет').toggle(rows.length == 0);
      });
    }
    $('.cv-chip').on('click', function () { $(this).toggleClass('on'); linkRows(); });
    $('#cvLinkRows').on('click', 'button', function () {
      var t = $(this).attr('data-t'), id = $(this).attr('data-id');
      FmsConfirm('Закрепить эту запись за клиентом?', function () {
        post('/clients/set/patient.s', 'id=' + CID + '&type=' + t + '&patient=' + id, function () { FmsToast.show('Запись закреплена', 'ok'); linkRows(); });
      }, {ok: 'Закрепить'});
    });
    window.tgInvite = function () {
      FmsConfirm('Отправить клиенту ссылку на бот с номера клиники в Telegram?', function () {
        var b = $('#tgInviteBtn').prop('disabled', true);
        $.ajax({
          url: '/clients/tg/invite.s', method: 'post', dataType: 'json', data: {id: CID},
          success: function (res) { FmsToast.show(res.msg || (res.success ? 'Отправлено' : 'Не удалось отправить'), res.success ? 'ok' : 'err'); },
          complete: function () { b.prop('disabled', false); }
        });
      }, {ok: 'Отправить'});
    };
    window.tgResult = function (amb, btn) {
      FmsConfirm('Отправить клиенту PDF результатов этого визита в Telegram?', function () {
        var b = $(btn).prop('disabled', true);
        $.ajax({
          url: '/clients/tg/result.s', method: 'post', dataType: 'json', data: {amb: amb},
          success: function (res) { FmsToast.show(res.msg || (res.success ? 'Отправлено' : 'Не удалось отправить'), res.success ? 'ok' : 'err'); },
          complete: function () { b.prop('disabled', false); }
        });
      }, {ok: 'Отправить'});
    };
    cvCountry();
  })();
</script>
