<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Параметры отчёта (правая часть страницы «Отчёты»): параметры строкой сверху, отчёт строится ниже во фрейме (frame=Y скрывает панель report.jsp).
     Excel — таблицы построенного отчёта в .xlsx (fms-rep-excel.js), если отчёт ещё не построен, сначала строится; «В новом окне» — прежнее открытие в новой вкладке. Значения списков запоминаются для каждого отчёта. --%>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script src="/res/js/fms-rep-excel.js?v=2026101402" type="text/javascript"></script>
<style>
  .rpp { display:flex; flex-direction:column; height:100%; min-height:0; }
  .rpp-head { padding:14px 18px 12px; border-bottom:1px solid #F0F1F4; }
  .rpp-top { display:flex; align-items:center; gap:8px; flex-wrap:wrap; margin-bottom:12px; }
  .rpp-top h3 { margin:0 auto 0 0; font-size:16px; font-weight:700; }
  .rpp-fields { display:flex; align-items:flex-start; gap:12px 16px; flex-wrap:wrap; }
  .rpp-f { display:flex; flex-direction:column; gap:5px; min-width:220px; flex:0 1 300px; }
  .rpp-f.date { flex:none; min-width:0; }
  .rpp-f .fm-l { margin:0; }
  .rpp-f .req { color:#D92D3C; }
  .rpp-f .fm-in.bad { border-color:#D92D3C; box-shadow:0 0 0 3px rgba(217,45,60,.12); }
  .rpp-range { display:flex; align-items:center; gap:6px; }
  .rpp-range .fm-in { width:130px; text-align:center; }
  .rpp-pre { display:flex; gap:4px; flex-wrap:wrap; margin-top:6px; }
  .rpp-pre button { height:24px; padding:0 9px; border:1px solid #E6E8EC; border-radius:999px; background:#fff; color:#4B5563; font-size:12px; font-weight:600; cursor:pointer; }
  .rpp-pre button:hover { background:#F5F6F8; }
  .rpp-pre button.on { background:#1F2430; border-color:#1F2430; color:#fff; }
  .rpp-out { position:relative; flex:1; min-height:420px; background:#F7F8FA; border-radius:0 0 14px 14px; overflow:hidden; }
  .rpp-out iframe { position:absolute; inset:0; width:100%; height:100%; border:0; background:#fff; display:none; }
  .rpp-out.has iframe { display:block; }
  .rpp-ph { position:absolute; inset:0; display:flex; flex-direction:column; align-items:center; justify-content:center; gap:10px; color:#9AA1AC; font-size:14px; text-align:center; }
  .rpp-ph .fa { font-size:34px; color:#C9CED6; }
  .rpp-out.has .rpp-ph { display:none; }
  .rpp-load { position:absolute; inset:0; display:none; align-items:center; justify-content:center; gap:10px; background:rgba(255,255,255,.75); color:#4B5563; font-weight:600; z-index:2; }
  .rpp-out.busy .rpp-load { display:flex; }
</style>
<form action="/rep/run.s" method="post" id="rpForm" target="rpFrame" class="rpp fm-admin" onsubmit="rpRun(); return false">
  <input type="hidden" name="repId" value="${id}"/>
  <input type="hidden" name="frame" value="Y"/>
  <div class="rpp-head">
    <div class="rpp-top">
      <h3>${report.name}</h3>
      <button type="button" class="fm-btn" id="rpPrint" onclick="window.rpPrint()" disabled title="Печать отчёта"><i class="fa fa-print"></i>Печать</button>
      <button type="button" class="fm-btn" onclick="rpExcel()" title="Скачать таблицы отчёта в Excel"><i class="fa fa-file-excel-o"></i>Excel</button>
      <button type="button" class="fm-btn" onclick="rpSend('tab')" title="Открыть отчёт в новой вкладке"><i class="fa fa-external-link"></i>В новом окне</button>
      <button type="submit" class="fm-btn primary"><i class="fa fa-play"></i>Сформировать</button>
    </div>
    <div class="rpp-fields">
      <c:forEach items="${params}" var="p">
        <div class="rpp-f ${p.c3 == 'input' && p.c5 != 'text' ? 'date' : ''}">
          <label class="fm-l">${p.c2}<c:if test="${p.c7}"> <span class="req">*</span></c:if></label>
          <c:if test="${p.c3 == 'input'}">
            <c:if test="${p.c5 == 'text'}">
              <input class="fm-in" name="${p.c6}" field_requeired="${p.c7}" autocomplete="off"/>
            </c:if>
            <c:if test="${p.c5 == 'single'}">
              <input name="${p.c6}" id="${p.c6}" type="text" class="fm-in datepicker" value="${sysdate}" style="width:130px; text-align:center" field_requeired="${p.c7}" autocomplete="off"/>
            </c:if>
            <c:if test="${p.c5 == 'range'}">
              <div class="rpp-range" data-range="${p.c6}">
                <input name="${p.c6}_start" id="${p.c6}_start" value="${sysdate}" type="text" class="fm-in datepicker" field_requeired="${p.c7}" autocomplete="off"/>
                <span style="color:#9AA1AC">—</span>
                <input name="${p.c6}_end" id="${p.c6}_end" value="${sysdate}" type="text" class="fm-in datepicker" field_requeired="${p.c7}" autocomplete="off"/>
              </div>
              <div class="rpp-pre" data-for="${p.c6}">
                <button type="button" data-p="today">Сегодня</button>
                <button type="button" data-p="yest">Вчера</button>
                <button type="button" data-p="week">Неделя</button>
                <button type="button" data-p="month">Этот месяц</button>
                <button type="button" data-p="prev">Прошлый месяц</button>
              </div>
            </c:if>
          </c:if>
          <c:if test="${p.c3 == 'select'}">
            <select class="fm-in fms-select" name="${p.c6}" field_requeired="${p.c7}">
              ${p.c4}
            </select>
          </c:if>
        </div>
      </c:forEach>
      <c:if test="${empty params}"><div style="color:#9AA1AC; font-size:13.5px">У отчёта нет параметров</div></c:if>
    </div>
  </div>
  <div class="rpp-out" id="rpOut">
    <div class="rpp-ph"><i class="fa fa-bar-chart"></i>Укажите параметры и нажмите «Сформировать»</div>
    <div class="rpp-load"><i class="fa fa-spinner fa-spin"></i>Формируется отчёт…</div>
    <iframe name="rpFrame" id="rpFrame" src="about:blank"></iframe>
  </div>
  <iframe name="rpDl" style="display:none"></iframe>
</form>
<script>
  <c:if test="${authErr}">parent.location = '/login.s';</c:if>
  (function () {
    var form = document.getElementById('rpForm'), key = 'rp:${id}';
    function ok() {
      var bad = null;
      $(form).find('[field_requeired]').each(function () {
        var miss = this.getAttribute('field_requeired') == 'true' && !$.trim(this.value);
        $(this).toggleClass('bad', miss);
        if (miss && !bad) bad = this;
      });
      if (bad) { FmsToast.show('Заполните обязательные поля', 'err'); bad.focus(); return false; }
      // запоминаем списки и текстовые поля (даты каждый раз свои)
      try {
        var v = {};
        $(form).find('select[name], input.fm-in[name]:not(.datepicker)').each(function () { v[this.name] = $(this).val(); });
        localStorage.setItem(key, JSON.stringify(v));
      } catch (e) {}
      return true;
    }
    // how: frame (на странице), word (файл), tab (новая вкладка)
    function send(how) {
      if (!ok()) { xlsWait = false; return; }
      var fr = form.elements['frame'], word = $(form).find('input[name=word], input[name=print]');
      word.remove();
      fr.disabled = how == 'tab';
      if (how == 'word') $(form).append('<input type="hidden" name="print" value="Y"><input type="hidden" name="word" value="Y">');
      form.target = how == 'frame' ? 'rpFrame' : (how == 'word' ? 'rpDl' : '_blank');
      if (how == 'frame') { $('#rpOut').addClass('busy'); $('#rpPrint').prop('disabled', true); }
      form.submit();
      $(form).find('input[name=word], input[name=print]').remove();
      fr.disabled = false;
      form.target = 'rpFrame';
    }
    window.rpRun = function () { send('frame'); };
    window.rpSend = send;
    // Excel: из уже построенного отчёта; если его нет или параметры поменяли — сначала строим
    var xlsWait = false, built = null;
    function cur() { return $(form).serialize(); }
    window.rpExcel = function () {
      if ($('#rpOut').hasClass('busy')) { xlsWait = true; return; }
      if ($('#rpOut').hasClass('has') && built == cur()) { xls(); return; }
      xlsWait = true;
      send('frame');
    };
    function xls() {
      var name = $(form).find('h3').first().text().trim(), per = [];
      $(form).find('.rpp-range').each(function () { per.push($(this).find('input').map(function () { return this.value; }).get().join('-')); });
      FmsRepExcel(document.getElementById('rpFrame').contentWindow.document, name + (per.length ? ' ' + per.join(' ') : ''));
    }
    window.rpPrint = function () { var w = document.getElementById('rpFrame').contentWindow; w.focus(); w.print(); };
    document.getElementById('rpFrame').onload = function () {
      if (this.src == 'about:blank' && !$('#rpOut').hasClass('busy')) return;
      $('#rpOut').removeClass('busy').addClass('has');
      $('#rpPrint').prop('disabled', false);
      built = cur();
      if (xlsWait) { xlsWait = false; xls(); }
    };

    // быстрый выбор периода
    function fmt(d) { return ('0' + d.getDate()).slice(-2) + '.' + ('0' + (d.getMonth() + 1)).slice(-2) + '.' + d.getFullYear(); }
    $(form).on('click', '.rpp-pre button', function () {
      var name = $(this).parent().attr('data-for'), t = new Date(), a = new Date(t), b = new Date(t);
      switch ($(this).attr('data-p')) {
        case 'yest': a.setDate(t.getDate() - 1); b = new Date(a); break;
        case 'week': a.setDate(t.getDate() - 6); break;
        case 'month': a = new Date(t.getFullYear(), t.getMonth(), 1); break;
        case 'prev': a = new Date(t.getFullYear(), t.getMonth() - 1, 1); b = new Date(t.getFullYear(), t.getMonth(), 0); break;
      }
      $('#' + name + '_start').val(fmt(a));
      $('#' + name + '_end').val(fmt(b));
      $(this).addClass('on').siblings().removeClass('on');
    });
    $(form).on('change input', '.rpp-range input', function () { $(this).closest('.rpp-f').find('.rpp-pre button').removeClass('on'); });

    // прежние значения списков этого отчёта
    try {
      var saved = JSON.parse(localStorage.getItem(key) || '{}');
      for (var n in saved) $(form).find('[name="' + n + '"]').not('.datepicker').val(saved[n]);
    } catch (e) {}
    if (window.FmsSelect) FmsSelect.attachAll(form);
  })();
</script>
