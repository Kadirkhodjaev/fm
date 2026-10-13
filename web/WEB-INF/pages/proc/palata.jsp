<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@include file="nurse_style.jsp"%>
<%-- Постовая: палата. Сверху выбор пациента крупными карточками, ниже назначения выбранного пациента на выбранное время. --%>
<div class="np">
  <div class="np-head">
    <div class="np-title">
      <span class="ic"><i class="fa fa-hospital-o"></i></span>
      <div>
        <h2>Палата ${fn:escapeXml(room.name)}</h2>
        <span class="sub">${fn:escapeXml(dep_name)} · ${fn:length(patients)} пациентов</span>
      </div>
    </div>
    <span class="np-spacer"></span>
    <input type="date" class="np-in" id="npDate" onchange="npReload()"/>
    <div class="np-seg">
      <button type="button" class="${time == '1' ? 'on' : ''}" onclick="npTime(1)"><i class="fa fa-sun-o"></i> Утро</button>
      <button type="button" class="${time == '2' ? 'on' : ''}" onclick="npTime(2)"><i class="fa fa-cutlery"></i> День</button>
      <button type="button" class="${time == '3' ? 'on' : ''}" onclick="npTime(3)"><i class="fa fa-moon-o"></i> Вечер</button>
    </div>
    <button type="button" class="np-btn" onclick="setPage('/proc/palatas.s')"><i class="fa fa-arrow-left"></i> Назад</button>
  </div>

  <c:if test="${empty patients}">
    <div class="np-empty"><i class="fa fa-hospital-o"></i>В палате нет пациентов на лечении</div>
  </c:if>

  <div class="np-pats">
    <c:forEach items="${patients}" var="p">
      <button type="button" class="np-pat ${p.id == first_one ? 'on' : ''}" id="npPat${p.id}" onclick="npOpen(${p.id})"
              data-fio="${fn:escapeXml(p.fio)}" data-meta="ИБ № ${p.yearNum}<c:if test="${not empty p.birthyear}"> · ${p.birthyear} г.р.</c:if><c:if test="${not empty p.lv}"> · врач ${fn:escapeXml(p.lv)}</c:if>">
        <span class="av"><i class="fa ${p.sex == 'F' ? 'fa-female' : p.sex == 'M' ? 'fa-male' : 'fa-user'} ${p.pending > 0 ? 'p-pend' : p.meds ? 'p-done' : 'p-none'}"></i></span>
        <span>
          <span class="nm">${fn:escapeXml(p.fio)}</span>
          <span class="mt">ИБ № ${p.yearNum}<c:if test="${not empty p.birthyear}"> · ${p.birthyear} г.р.</c:if></span>
        </span>
        <c:choose>
          <c:when test="${p.pending > 0}"><span class="badge pend" title="Не сделано процедур">${p.pending}</span></c:when>
          <c:when test="${p.meds}"><span class="badge ok" title="Всё сделано"><i class="fa fa-check"></i></span></c:when>
        </c:choose>
      </button>
    </c:forEach>
  </div>

  <c:if test="${not empty patients}">
    <div class="np-card">
      <div class="np-card-head">
        <div>
          <h3 id="npName"></h3>
          <span class="sub" id="npMeta"></span>
        </div>
        <span class="np-spacer"></span>
        <c:if test="${tgEnabled}">
          <button type="button" class="np-btn tg" onclick="openTgModal(npCur)"><i class="fa fa-paper-plane"></i>Telegram</button>
        </c:if>
      </div>
      <div class="np-card-body">
        <input type="hidden" id="oper_day"/>
        <div id="home"></div>
      </div>
    </div>
  </c:if>
</div>

<%@ include file="../med/lv/tg_modal.jsp" %>

<script>
  var npCur = ${empty first_one ? 0 : first_one};
  var npDay = '${oper_day}'; // dd.mm.yyyy
  function npIso(d) { var p = d.split('.'); return p.length == 3 ? p[2] + '-' + p[1] + '-' + p[0] : ''; }
  function npRu(d) { var p = d.split('-'); return p.length == 3 ? p[2] + '.' + p[1] + '.' + p[0] : ''; }
  function npLoad() {
    $("#oper_day").val(npDay); // proc/drugs.jsp берёт дату отсюда при перезагрузке после отметки
    // назначения пациента на дату и время (proc/drugs.jsp): сам перезагружается в #home после отметки
    $('#home').html('<div class="np-empty" style="padding:30px">Загрузка...</div>')
      .load('/proc/patient/drugs.s?id=' + npCur + '&oper_day=' + npDay + '&time=${time}');
  }
  function npOpen(id) {
    npCur = id;
    $('.np-pat').removeClass('on');
    var b = $('#npPat' + id).addClass('on');
    $('#npName').text(b.data('fio'));
    $('#npMeta').html(b.data('meta'));
    npLoad();
  }
  function npReload() {
    var v = $('#npDate').val();
    if (v) { npDay = npRu(v); npLoad(); }
  }
  function npTime(t) {
    setPage('/proc/palata.s?id=${room.id}&time=' + t + '&pat=' + npCur + '&oper_day=' + npDay);
  }
  $('#npDate').val(npIso(npDay));
  if (npCur) npOpen(npCur);
</script>
