<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
  function openUrl(dom){
    $('.leftMenu li').attr("class", "");
    dom.className = "active";
    lvContent.location = dom.id;
    var o = dom.getAttribute("ord");
    $('#saveForm').css('display', (o == 1 && ${sessionScope.ENV.roleId} === 6) || o == 2 || o == 4 || o == 5 || o == 6 || o == 7 || o == 8 || o == 9 || o == 10 || o == 11 || o == 12 ||o == 13 || o == 16 ? 'inline' : "none");
    $('#planResult').css('display', o == 10 ? 'inline' : "none");
    $('#planResultPage').css('display', o == 6 || o == 8  ? 'inline' : "none");
    $('#statCard').css('display', o == 9  ? 'inline' : "none");
    $('#histBtn').css('display', LV_HIST[o] ? 'inline' : 'none');
    window.lvOrd = o;
    <c:if test="${p.paid != 'CLOSED'}">
    $('#planAdd').css('display', o == 10 ? 'inline' : "none");
    </c:if>
    <c:if test="${p.paid != 'CLOSED'}">
    $('#printBtn').css('display', o == 1 || o == 2 || o == 18 || o == 9 || o == 15 || o == 21 ? 'none' : 'inline');
    </c:if>
    <c:if test="${p.paid == 'CLOSED'}">
    $('#printBtn').css('display', o == 1 || o == 2 || o == 18 ? 'none' : 'inline');
    </c:if>
    if(dom.id.indexOf('view/vypiska.s') != -1 && '${p.state}' === 'ARCH') {
      $('#statCard').css('display', 'inline');
    }
    if((dom.id.indexOf('drug/index.s') != -1 || dom.id.indexOf('drugs.s') != -1) && '${p.state}' === 'ARCH') {
      $('#printBtn').css('display', 'none');
    }
  }
  // «История»: этот же раздел в прошлых госпитализациях клиента (печатный вид, /view/...?print=Y&hist=id)
  var LV_HIST = {4: ['Осмотр врача', '/view/osm.s'], 20: ['Назначение', '/view/drug/index.s'], 10: ['Обследования', '/view/plan/index.s'],
                 5: ['Обоснование', '/view/obos.s'], 9: ['Выписка', '/view/vypiska.s']};
  function lvHist() {
    var h = LV_HIST[window.lvOrd];
    if (!h) return;
    $('#lvHistT').text(h[0]);
    $('#lvHist').addClass('open');
    lvHistLoad();
  }
  function lvHistLoad() {
    var h = LV_HIST[window.lvOrd], id = $('#lvHistSel').val();
    if (h && id) $('#lvHistFrame').attr('src', h[1] + '?print=Y&hist=' + id);
  }
  function lvHistPrint() { var w = document.getElementById('lvHistFrame').contentWindow; w.focus(); w.print(); }
  function saveForm(){
    lvContent.document.getElementById("saveBtn").click();
  }
  function back(){
    openMainPage('${backUrl}', true);
  }
  // iframe занимает всё место до низа окна
  function resizeFrame() {
    var f = $('#lvContent');
    if (!f.length) return;
    f.height(Math.max(300, $(window).height() - f.offset().top - 12));
  }
  // Новый стиль для страниц во фрейме: подключаем /res/css/fms-theme.css после каждой загрузки раздела
  // разделы «только для чтения» показываются печатной версией: серый фон и лист бумаги, как будет на печати
  var PAPER = ['/view/osm.s', '/view/obos.s', '/view/dairy.s', '/view/vypiska.s', '/view/drugs.s', '/view/drug/index.s', '/view/epic.s', '/view/extra.s'];
  function paperFrame(d) {
    var path = d.location.pathname;
    if (path == '/view/all.s') return true; // «Вся история» оформлена сама
    if (PAPER.indexOf(path) < 0 || d.getElementById('fmsPaper')) return false;
    var st = d.createElement('style');
    st.id = 'fmsPaper';
    st.appendChild(d.createTextNode(
      'html,body{margin:0;background:#E9EBEE}' +
      '.fms-sheet{max-width:860px;margin:16px auto;padding:28px 32px;background:#fff;border-radius:4px;box-sizing:border-box;' +
      'box-shadow:0 1px 3px rgba(20,25,40,.12),0 8px 24px rgba(20,25,40,.06)}' +
      '@media print{html,body{background:#fff}.fms-sheet{margin:0;padding:0;box-shadow:none;max-width:none}}'));
    (d.head || d.documentElement).appendChild(st);
    var sheet = d.createElement('div');
    sheet.className = 'fms-sheet';
    while (d.body.firstChild) sheet.appendChild(d.body.firstChild);
    d.body.appendChild(sheet);
    return true;
  }
  function themeFrame() {
    try {
      var d = document.getElementById('lvContent').contentDocument;
      if (d && d.body && paperFrame(d)) return;
      if (d && d.head && !d.getElementById('fmsTheme')) {
        var l = d.createElement('link');
        l.id = 'fmsTheme';
        l.rel = 'stylesheet';
        l.href = '/res/css/fms-theme.css';
        d.head.appendChild(l);
      }
    } catch (e) {}
  }
  $(document).ready(function(){
    $(window).resize(function(){resizeFrame();});
    resizeFrame();
    $('#lvContent').on('load', themeFrame);
    openUrl(document.getElementById('${formUrl}'));
  });
  function setPrint(){
    var url = '' + lvContent.location, dairyIds = '';
    if(url.indexOf('/lv/dairy.s') > -1) {
      $('#lvContent').contents().find('input[name=dairy]:checked').each(function(){
        dairyIds += $(this).attr('dairy') + ',';
      });
      if(dairyIds.length > 0)
        dairyIds = '?dairyIds=' + dairyIds;
    }
    if(url.indexOf('drug') !== -1 && '${table}' === '') {
      FmsToast.show('Питание не установлено! Установите питание перед распечаткой', 'err');
      return;
    }
    window.open('/lv/print.s' + dairyIds);
  }
  function setReg(){
    openMainPage('/reg/nurse/index.s?reg=Y', true);
  }
  function setBooking() {
    openMainPage('/booking/index.s?history=${p.id}', true);
  }
</script>

<style>
  .lv { --brand:#D7182E; --brand-dark:#A50F22; --brand-soft:#FDECEE; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    display:flex; height:100%; min-height:0; background:var(--bg); color:var(--text);
    font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }

  /* ---------- Меню истории болезни ---------- */
  .lv > #tdLeftMenu.lv-menu {
    flex:none; width:230px; height:auto; overflow-y:auto; overflow-x:hidden;
    background:#fff; border-right:1px solid var(--border);
  }
  #tdLeftMenu.lv-menu .lv-menu-h { padding:14px 16px 6px; font-size:11px; font-weight:700; letter-spacing:.5px; text-transform:uppercase; color:#9AA1AC; }
  #tdLeftMenu.lv-menu ul.leftMenu { list-style:none; margin:0; padding:4px 10px 12px; }
  #tdLeftMenu.lv-menu ul.leftMenu li {
    position:relative; display:flex; align-items:center; gap:10px;
    min-height:38px; margin:1px 0; padding:6px 12px !important;
    border:0; border-radius:9px; background:transparent;
    color:#3C4250; font-size:13.5px; font-weight:500; line-height:1.25;
    cursor:pointer; user-select:none; transition:background .12s, color .12s;
  }
  #tdLeftMenu.lv-menu ul.leftMenu li > i { flex:none; width:18px; text-align:center; font-size:15px; color:#8B92A0; }
  #tdLeftMenu.lv-menu ul.leftMenu li:hover { background:var(--bg); color:var(--text); }
  #tdLeftMenu.lv-menu ul.leftMenu li.active { background:var(--brand-soft); color:var(--brand-dark); font-weight:600; }
  #tdLeftMenu.lv-menu ul.leftMenu li.active > i { color:var(--brand); }
  #tdLeftMenu.lv-menu ul.leftMenu li.active::before { content:''; position:absolute; left:-10px; top:8px; bottom:8px; width:4px; border-radius:0 4px 4px 0; background:var(--brand); }
  #tdLeftMenu.lv-menu ul.leftMenu li.lv-back { margin-top:10px; border-top:1px solid var(--border); border-radius:0 0 9px 9px; padding-top:10px !important; color:var(--muted); }

  /* ---------- Правая часть ---------- */
  .lv-main { flex:1; min-width:0; display:flex; flex-direction:column; }
  .lv-bar {
    flex:none; display:flex; align-items:center; gap:12px; flex-wrap:wrap;
    height:auto !important; min-height:60px; margin:0; position:static;
    padding:10px 16px; background:#fff; border-bottom:1px solid var(--border); box-shadow:none;
  }
  .lv-back-btn { flex:none; width:36px; height:36px; border:1.5px solid var(--border); border-radius:9px; background:#fff;
    color:var(--muted); cursor:pointer; display:flex; align-items:center; justify-content:center; }
  .lv-back-btn:hover { background:var(--bg); color:var(--text); }
  .lv-title { flex:1 1 280px; min-width:0; }
  .lv-title .t1 { display:flex; align-items:baseline; gap:10px; min-width:0; }
  .lv-title .ib { flex:none; font-size:13px; font-weight:700; color:var(--brand-dark); background:var(--brand-soft); padding:2px 8px; border-radius:6px; }
  .lv-title .fio { font-size:17px; font-weight:700; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
  .lv-title .t2 { display:flex; align-items:center; gap:8px; margin-top:3px; font-size:12.5px; color:var(--muted); }
  .lv .st { display:inline-flex; align-items:center; gap:6px; padding:2px 9px; border-radius:999px; font-size:12px; font-weight:600; white-space:nowrap; }
  .lv .st::before { content:''; width:7px; height:7px; border-radius:50%; background:currentColor; }
  .lv .st-open  { background:var(--brand-soft); color:var(--brand); }
  .lv .st-close { background:#E8F7EE; color:#15803D; }
  .lv .st-sick  { background:#EAF1FE; color:#2563EB; margin-left:6px; }

  .lv-switch { flex:0 1 340px; min-width:220px; }
  .lv-actions { display:flex; align-items:center; gap:6px; flex-wrap:wrap; justify-content:flex-end; }
  /* span-обёртки с id: их показывает/прячет JS через display:inline/none */
  .lv-actions > span { white-space:nowrap; }
  .lv .ab { display:inline-flex; align-items:center; gap:7px; height:34px; padding:0 12px; border-radius:9px;
    border:1.5px solid var(--border); background:#fff; color:var(--text); font-size:13px; font-weight:600;
    white-space:nowrap; cursor:pointer; text-decoration:none !important; vertical-align:middle; transition:background .12s, border-color .12s; }
  .lv .ab:hover { background:var(--bg); color:var(--text); }
  .lv .ab .fa { color:var(--muted); }
  .lv .ab.primary { background:var(--brand); border-color:var(--brand); color:#fff; }
  .lv .ab.primary .fa { color:#fff; }
  .lv .ab.primary:hover { background:var(--brand-dark); border-color:var(--brand-dark); }

  .lv-frame { flex:1; min-height:0; padding:10px 12px 0; }
  .lv-frame iframe { display:block; width:100%; height:400px; border:1px solid var(--border); border-radius:12px 12px 0 0; background:#fff; }

  @media (max-width: 1300px) {
    .lv > #tdLeftMenu.lv-menu { width:200px; }
    .lv .ab .lbl { display:none; }          /* на узком экране у кнопок остаются иконки */
    .lv .ab { padding:0 10px; }
  }
</style>

<div class="lv">
  <!-- ================= Меню истории болезни ================= -->
  <aside id="tdLeftMenu" class="lv-menu">
    <div class="lv-menu-h">История болезни</div>
    <ul class="leftMenu">
      <c:forEach items="${menuList}" var="m">
        <li ord="${m.ord}" class="${m.state}" onclick="openUrl(this)" id="${m.url}" title="${m.name}">
          <i class="${m.icon}"></i><span>${m.name}</span>
        </li>
      </c:forEach>
      <li class="lv-back" onclick="back()"><i class="fa fa-reply fa-fw"></i><span>Назад к списку</span></li>
    </ul>
  </aside>

  <!-- ================= Содержимое ================= -->
  <div class="lv-main">
    <div class="lv-bar">
      <div class="lv-title" title="ID: ${p.id}">
        <div class="t1">
          <span class="ib">ИБ №${p.yearNum}</span>
          <span class="fio">${p.fio}</span>
        </div>
        <div class="t2">
          Касса:
          <c:if test="${p.paid != 'CLOSED'}"><span class="st st-open">Открыта</span></c:if>
          <c:if test="${p.paid == 'CLOSED'}"><span class="st st-close">Закрыта</span></c:if>
          <c:if test="${p.sickLeave == 'Y'}"><span class="st st-sick">Больничный лист: Да</span></c:if>
        </div>
      </div>

      <%-- только в карточке своего пациента --%>
      <c:set var="lvMine" value="false"/>
      <c:forEach items="${myPats}" var="mp"><c:if test="${mp.id == p.id}"><c:set var="lvMine" value="true"/></c:if></c:forEach>
      <c:if test="${lvMine && fn:length(myPats) > 2}">
        <%-- переключение между своими пациентами: открывается та же вкладка карточки --%>
        <div class="lv-switch" id="lvSwitch" title="Перейти к другому своему пациенту">
          <select class="form-control fms-select" onchange="if (this.value && this.value != '${p.id}') openMainPage('/lv/index.s?id=' + this.value, false)">
            <c:forEach items="${myPats}" var="mp">
              <option value="${mp.id}" <c:if test="${mp.id == p.id}">selected</c:if>>${fn:escapeXml(mp.fio)} (ИБ №${mp.ib}<c:if test="${not empty mp.room}">, палата ${fn:escapeXml(mp.room)}</c:if>)</option>
            </c:forEach>
          </select>
        </div>
        <script>if (window.FmsSelect) FmsSelect.attachAll(document.getElementById('lvSwitch'));</script>
      </c:if>

      <div class="lv-actions">
        <span id="statCard" style="display:none"><a href="#" class="ab" onclick="window.open('lv/print.s?statcard=Y'); return false;" title="Стат. карта"><i class="fa fa-file-text-o"></i><span class="lbl">Стат. карта</span></a></span>
        <span id="planResultPage" style="display:none"><a href="#" class="ab" onclick="window.open('lv/plan.s?new=Y'); return false;" title="Результаты всех обследований"><i class="fa fa-flask"></i><span class="lbl">Результаты</span></a></span>
        <span id="planResult" style="display:none"><a href="#" class="ab" onclick="lvContent.location = '/lv/plan.s'; return false;" title="Результаты всех обследований"><i class="fa fa-flask"></i><span class="lbl">Результаты</span></a></span>
        <span id="planAdd" style="display:none"><a href="#" class="ab" onclick="lvContent.location = '/lv/plan/kdos.s'; return false;" title="Добавить новое обследование"><i class="fa fa-plus"></i><span class="lbl">Добавить</span></a></span>
        <c:if test="${roleId == 17}">
          <span><a href="#" class="ab" onclick="setBooking(); return false;" title="Бронирование"><i class="fa fa-calendar-check-o"></i><span class="lbl">Бронирование</span></a></span>
        </c:if>
        <c:if test="${not empty histStays}">
          <span id="histBtn" style="display:none"><a href="#" class="ab" onclick="lvHist(); return false;" title="Этот раздел в прошлых госпитализациях пациента"><i class="fa fa-history"></i><span class="lbl">История</span></a></span>
        </c:if>
        <span id="printBtn"><a href="#" class="ab" onclick="setPrint(); return false;" title="Печать"><i class="fa fa-print"></i><span class="lbl">Печать</span></a></span>
        <span id="saveForm" style="display:none"><a href="#" class="ab primary" onclick="saveForm(); return false;" title="Сохранить"><i class="fa fa-floppy-o"></i><span class="lbl">Сохранить</span></a></span>
        <a href="#" class="ab" onclick="back(); return false;" title="Сохранить"><i class="fa fa-arrow-left"></i><span class="lbl">Назад</span></a>
      </div>
    </div>

    <div class="lv-frame">
      <iframe id="lvContent" name="lvContent"></iframe>
    </div>
  </div>
</div>
<c:if test="${not empty histStays}">
  <%-- окно «История»: выбор прошлой госпитализации (новые сверху) и раздел в печатном виде --%>
  <style>
    .lvh { position:fixed; inset:0; z-index:1050; display:none; align-items:center; justify-content:center; background:rgba(20,25,40,.45); }
    .lvh.open { display:flex; }
    .lvh-box { width:1000px; max-width:calc(100% - 32px); height:calc(100% - 60px); display:flex; flex-direction:column; background:#fff; border-radius:14px;
      box-shadow:0 20px 60px rgba(20,25,40,.3); overflow:hidden; font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
    .lvh-head { display:flex; align-items:center; gap:12px; padding:12px 16px; border-bottom:1px solid #E6E8EC; }
    .lvh-head h3 { margin:0; font-size:15px; font-weight:700; white-space:nowrap; }
    .lvh-head h3 span { font-weight:400; color:#6B7280; }
    .lvh-sel { flex:1; min-width:380px; max-width:560px; }
    .lvh-head .sp { flex:1; }
    .lvh-btn { height:32px; padding:0 12px; border:1px solid #E6E8EC; border-radius:9px; background:#fff; color:#3C4250; font-size:13px; font-weight:600; cursor:pointer; }
    .lvh-btn:hover { background:#F5F6F8; }
    .lvh-body { flex:1; min-height:0; background:#ECEEF1; padding:14px; }
    .lvh-body iframe { width:100%; height:100%; border:0; background:#fff; border-radius:4px; box-shadow:0 1px 3px rgba(20,25,40,.1); }
  </style>
  <div class="lvh" id="lvHist" onclick="if (event.target === this) $(this).removeClass('open')">
    <div class="lvh-box">
      <div class="lvh-head">
        <h3><i class="fa fa-history" style="color:#9AA1AC"></i> История: <span id="lvHistT"></span></h3>
        <div class="lvh-sel" id="lvHistSelBox">
          <select class="form-control fms-select" id="lvHistSel" onchange="lvHistLoad()">
            <c:forEach items="${histStays}" var="hs">
              <option value="${hs.id}">ИБ №${hs.yearNum} (<fmt:formatDate pattern="dd.MM.yyyy" value="${hs.dateBegin}"/> – <fmt:formatDate pattern="dd.MM.yyyy" value="${hs.dateEnd}"/><c:if test="${not empty hs.dept}">, ${fn:escapeXml(hs.dept.name)}</c:if><c:if test="${not empty histLv[hs.lv_id]}">, леч. врач ${fn:escapeXml(histLv[hs.lv_id])}</c:if>)</option>
            </c:forEach>
          </select>
        </div>
        <span class="sp"></span>
        <button type="button" class="lvh-btn" onclick="lvHistPrint()"><i class="fa fa-print"></i> Печать</button>
        <button type="button" class="lvh-btn" onclick="$('#lvHist').removeClass('open')"><i class="fa fa-times"></i> Закрыть</button>
      </div>
      <div class="lvh-body"><iframe id="lvHistFrame"></iframe></div>
    </div>
  </div>
  <script>if (window.FmsSelect) FmsSelect.attachAll(document.getElementById('lvHistSelBox'));</script>
</c:if>

