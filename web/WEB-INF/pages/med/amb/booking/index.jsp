<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Амбулаторная регистрация → Бронирование: предстоящие брони по дням (период — дата создания брони) --%>
<%@include file="/WEB-INF/pages/med/mn/mn_style.jsp"%>
<jsp:useBean id="bkNow" class="java.util.Date"/>
<fmt:formatDate var="bkToday" value="${bkNow}" pattern="dd.MM.yyyy"/>
<c:set var="bkTotal" value="0"/>
<c:forEach items="${rows}" var="d"><c:set var="bkTotal" value="${bkTotal + fn:length(d.bookings)}"/></c:forEach>
<style>
  .bk-st { display:inline-flex; align-items:center; gap:6px; font-size:12.5px; color:#6B7280; white-space:nowrap; }
  .bk-st::before { content:''; width:8px; height:8px; border-radius:50%; background:#E0A33A; }
  .bk-st.done::before { background:#2E9E62; }
  .bk-day .cnt { margin-left:8px; font-weight:500; color:#6B7280; font-size:12.5px; }
  .bk-day .tag { margin-left:8px; padding:1px 8px; border-radius:999px; background:#FDECEE; color:#A50F22; font-size:11.5px; font-weight:600; }
  #bkRows tr[data-id] { cursor:pointer; }
  #bkRows td.tm { font-weight:700; font-variant-numeric:tabular-nums; }
  #bkRows td.sv { color:#374151; }
</style>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-calendar"></i></span>
        <div>
          <h2>Бронирование</h2>
          <span class="fm-count"><b id="bkShown">${bkTotal}</b> из <b>${bkTotal}</b> · предстоящие брони</span>
        </div>
      </div>
      <div class="mn-flt" title="Брони, созданные за период">
        <span class="fm-hint">Созданы</span>
        <input id="period_start" type="text" class="fm-in datepicker" value="${period_start}" autocomplete="off"/>
        <span class="dash">—</span>
        <input id="period_end" type="text" class="fm-in datepicker" value="${period_end}" autocomplete="off"/>
        <button type="button" class="fm-btn" onclick="mnPeriod('/amb/bookings.s')"><i class="fa fa-search"></i>Показать</button>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="bkSearch" placeholder="ФИО, телефон или услуга" oninput="bkFilter()" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn primary" onclick="setPage('/amb/booking.s?id=0')"><i class="fa fa-plus"></i>Добавить</button>
    </div>
    <div class="fm-table-wrap">
      <table class="mn">
        <thead>
        <tr>
          <th style="width:50px">№</th>
          <th style="width:70px">Время</th>
          <th class="l">ФИО</th>
          <th class="l">Услуги</th>
          <th style="width:110px">Рождение</th>
          <th style="width:150px">Телефон</th>
          <th style="width:150px">Статус</th>
          <th style="width:130px">Создана</th>
          <th style="width:50px"></th>
        </tr>
        </thead>
        <tbody id="bkRows">
        <c:forEach items="${rows}" var="d">
          <tr class="grp bk-day" data-day="${d.name}">
            <td colspan="9">
              <i class="fa fa-calendar-o" style="color:#9AA1AC;margin-right:6px"></i>${d.name}
              <c:if test="${d.name == bkToday}"><span class="tag">Сегодня</span></c:if>
              <span class="cnt">${fn:length(d.bookings)}</span>
            </td>
          </tr>
          <c:forEach items="${d.bookings}" var="a" varStatus="loop">
            <tr data-id="${a.id}" data-day="${d.name}" data-s="${fn:escapeXml(a.fio)} ${fn:escapeXml(a.tel)} ${fn:escapeXml(services[a.id])}" onclick="bkOpen(${a.id})" title="Открыть бронь">
              <td class="c m">${loop.index + 1}</td>
              <td class="c tm"><fmt:formatDate pattern="HH:mm" value="${a.regDate}"/></td>
              <td class="nm">${fn:escapeXml(a.fio)}</td>
              <td class="sv">${empty services[a.id] ? '<span class="fm-hint">услуги не выбраны</span>' : fn:escapeXml(services[a.id])}</td>
              <td class="c"><fmt:formatDate pattern="dd.MM.yyyy" value="${a.birthday}"/></td>
              <td class="c">${fn:escapeXml(a.tel)}</td>
              <td class="c"><span class="bk-st ${a.state == 'ENT' ? '' : 'done'}">${a.state == 'ENT' ? 'Ожидает' : 'Зарегистрирован'}</span></td>
              <td class="c m"><fmt:formatDate pattern="dd.MM HH:mm" value="${a.crOn}"/></td>
              <td class="c">
                <c:if test="${a.state == 'ENT'}">
                  <button type="button" class="fm-act danger" title="Удалить бронь" onclick="event.stopPropagation(); bkDel(${a.id})"><i class="fa fa-trash-o"></i></button>
                </c:if>
              </td>
            </tr>
          </c:forEach>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="bkEmpty" style="display:${bkTotal == 0 ? 'block' : 'none'}"><i class="fa fa-calendar"></i>Броней нет</div>
    </div>
  </div>
</div>
<script>
  function bkOpen(id) {
    try { sessionStorage.setItem('bkLast', id); } catch (e) {}
    setPage('/amb/booking.s?id=' + id);
  }
  function bkFilter() {
    mnFilter('bk');
    // заголовок дня скрывается, если в нём не осталось строк
    $('#bkRows tr.bk-day').each(function () {
      var day = $(this).attr('data-day');
      $(this).toggle($('#bkRows tr[data-id][data-day="' + day + '"]:visible').length > 0);
    });
  }
  function bkDel(id) {
    FmsConfirm('Удалить бронь вместе с выбранными услугами?', function () {
      $.ajax({
        url: '/amb/booking/del.s', data: 'id=' + id, method: 'post', dataType: 'json',
        success: function (res) {
          if (!res.success) { FmsToast.show(res.msg || 'Не удалось удалить', 'err'); return; }
          FmsToast.show('Бронь удалена', 'ok');
          setPage('/amb/bookings.s');
        }
      });
    }, null, {ok: 'Удалить', danger: true});
  }
  (function () {
    var last = null;
    try { last = sessionStorage.getItem('bkLast'); } catch (e) {}
    var tr = last ? $('#bkRows tr[data-id=' + Number(last) + ']') : $();
    if (tr.length) { tr.addClass('sel'); tr[0].scrollIntoView({block: 'center'}); }
  })();
</script>
