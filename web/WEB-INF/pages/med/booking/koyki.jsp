<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<script>
  function setVypDate(date) {
    setPage('/booking/koyki.s?vypDate=' + date);
  }
  function setEmptyDate(date) {
    setPage('/booking/koyki.s?emptyDate=' + date);
  }
</script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<style>
  .kk { --brand:#D7182E; --brand-dark:#A50F22; --brand-soft:#FDECEE; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    --cr:#15803D; --cr-bg:#E8F7EE; --bk:#B45309; --bk-bg:#FEF3E2; --ux:#BE185D; --ux-bg:#FDEDF3;
    padding:16px 20px 28px; color:var(--text); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .kk * { box-sizing:border-box; }

  /* Заголовок */
  .kk-bar { display:flex; align-items:center; gap:10px; flex-wrap:wrap; margin-bottom:14px; }
  .kk-bar h3 { margin:0 6px 0 0; font-size:19px; font-weight:700; display:flex; align-items:center; gap:9px; }
  .kk-bar h3 .ic { width:34px; height:34px; border-radius:10px; background:var(--brand-soft); color:var(--brand); display:inline-flex; align-items:center; justify-content:center; font-size:16px; }
  .kk-bar .sp { flex:1; }
  .kk-lg { display:inline-flex; align-items:center; gap:6px; font-size:12.5px; color:var(--muted); font-weight:500; }
  .kk-dot { flex:none; width:9px; height:9px; border-radius:50%; display:inline-block; }
  .kk-dot.cr { background:var(--cr); } .kk-dot.bk { background:#D97706; } .kk-dot.ux { background:var(--ux); }

  /* Плитки */
  .kk-kpi { display:grid; grid-template-columns:repeat(4, minmax(0, 1fr)); gap:14px; margin-bottom:18px; }
  .kk-tile { display:flex; flex-direction:column; gap:10px; padding:14px 16px; background:#fff; border:1px solid var(--border); border-radius:14px; }
  .kk-tile .top { display:flex; align-items:center; gap:12px; }
  .kk-tile .ti { flex:none; width:40px; height:40px; border-radius:11px; display:flex; align-items:center; justify-content:center; font-size:17px; }
  .kk-tile .v { font-size:28px; font-weight:700; line-height:1; font-variant-numeric:tabular-nums; }
  .kk-tile .l { font-size:13px; color:var(--muted); font-weight:500; margin-top:4px; }
  .kk-tile .form-control { height:34px; border:1.5px solid var(--border); border-radius:9px; box-shadow:none; font-size:13px; }
  .kk-tile .form-control:focus { border-color:var(--brand); box-shadow:0 0 0 3px rgba(215,24,46,.10); }
  .kk-tile .dt { display:flex; align-items:center; gap:8px; font-size:12.5px; color:var(--muted); }
  .kk-tile .dt .form-control { flex:1; width:100% !important; }
  .t-blue .ti { background:#EAF1FE; color:#2563EB; } .t-amb .ti { background:var(--bk-bg); color:var(--bk); }
  .t-grn .ti { background:var(--cr-bg); color:var(--cr); } .t-gry .ti { background:#F1F2F4; color:#4B5563; }

  /* Этажи */
  .kk-floor { margin-bottom:22px; }
  .kk-floor-h { display:flex; align-items:center; gap:10px; margin:0 0 10px; }
  .kk-floor-h h4 { margin:0; font-size:15px; font-weight:700; }
  .kk-floor-h .n { font-size:12.5px; color:var(--muted); }
  .kk-floor-h .ln { flex:1; height:1px; background:var(--border); }
  .kk-grid { display:grid; grid-template-columns:repeat(auto-fill, minmax(300px, 1fr)); gap:12px; }

  /* Палата */
  .kk-room { display:flex; flex-direction:column; background:#fff; border:1px solid var(--border); border-radius:12px; overflow:hidden; }
  .kk-room-h { display:flex; align-items:center; gap:8px; padding:9px 10px 9px 14px; border-bottom:1px solid #F0F1F4; }
  .kk-room-h .num { font-size:15px; font-weight:700; }
  .kk-room-h .tp { padding:2px 8px; border-radius:7px; background:#F1F2F4; color:#4B5563; font-size:12px; font-weight:600; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; max-width:150px; }
  .kk-room-h .sp { flex:1; }
  .kk-room-h .beds { display:inline-flex; align-items:center; gap:5px; padding:2px 8px; border-radius:7px; background:#F1F2F4; color:var(--muted); font-size:12px; font-weight:600; white-space:nowrap; font-variant-numeric:tabular-nums; }
  .kk-room-h .beds .fa { font-size:11px; }
  .kk-room-h .beds.has { background:var(--cr-bg); color:var(--cr); }
  .kk-room-h .cnt { font-size:12px; color:var(--muted); white-space:nowrap; }
  .kk-add { flex:none; width:28px; height:28px; border:0; border-radius:8px; background:transparent; color:var(--muted); cursor:pointer; }
  .kk-add:hover { background:var(--brand-soft); color:var(--brand); }
  .kk-room.free { border-color:#CDEBD8; }
  .kk-room.free .kk-room-h { background:#F6FCF8; }
  .kk-room.off { background:#FAFAFB; }
  .kk-room.off .kk-room-h .num { color:var(--muted); }
  .kk-pl { list-style:none; margin:0; padding:4px 0; }
  /* ФИО целиком (переносится), даты отдельной строкой под ФИО */
  .kk-pl li { display:flex; flex-wrap:wrap; align-items:center; gap:2px 9px; padding:7px 14px; font-size:13px; }
  .kk-pl li + li { border-top:1px solid #F5F6F8; }
  .kk-pl li:hover { background:#FAFBFC; }
  .kk-pl .fio { flex:1 1 0; min-width:0; font-weight:600; line-height:1.35; white-space:normal; overflow-wrap:anywhere; }
  .kk-pl .ib { flex:none; padding:1px 7px; border-radius:6px; background:#F1F2F4; color:#4B5563; font-size:11.5px; font-weight:600; font-variant-numeric:tabular-nums; }
  .kk-pl .ib.ux { background:var(--ux-bg); color:var(--ux); }
  .kk-pl .ib.bk { background:var(--bk-bg); color:var(--bk); }
  .kk-pl .dd { flex:0 0 100%; padding-left:18px; color:var(--muted); font-size:12px; white-space:nowrap; font-variant-numeric:tabular-nums; }
  .kk-pl .dd .fa { font-size:10px; margin:0 3px; color:#C3C7CE; }
  .kk-free { padding:14px; text-align:center; color:var(--cr); font-size:13px; font-weight:600; }
  .kk-off { padding:14px; text-align:center; color:var(--brand); font-size:13px; font-weight:600; }

  /* Окно брони */
  .kk-modal .modal-dialog { width:100%; max-width:820px; }
  .kk-modal .modal-content { border:0; border-radius:16px; box-shadow:0 24px 60px rgba(20,25,40,.25); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:#1F2430; }
  .kk-modal .modal-header { padding:16px 20px; border-bottom:1px solid #E6E8EC; }
  .kk-modal .modal-title { font-size:17px; font-weight:700; }
  .kk-modal .modal-title .fa { color:#D7182E; margin-right:6px; }
  .kk-modal .modal-body { padding:18px 20px 20px; }
  .kk-modal .modal-footer { padding:14px 20px; border-top:1px solid #E6E8EC; display:flex; align-items:center; justify-content:flex-end; gap:8px; }
  .kk-modal .sec { margin:0 0 8px; font-size:11.5px; font-weight:700; text-transform:uppercase; letter-spacing:.4px; color:#9AA1AC; }
  .kk-modal .sec + .fg { margin-bottom:18px; }
  .kk-modal .fg { display:grid; grid-template-columns:repeat(6, 1fr); gap:12px 14px; }
  .kk-modal .fg .f { display:flex; flex-direction:column; gap:6px; min-width:0; }
  .kk-modal .fg .s2 { grid-column:span 2; } .kk-modal .fg .s3 { grid-column:span 3; } .kk-modal .fg .s6 { grid-column:span 6; } .kk-modal .fg .s4 { grid-column:span 4; }
  .kk-modal .fg label { margin:0; font-size:12.5px; font-weight:600; color:#6B7280; }
  .kk-modal .fg label i { font-style:normal; color:#D7182E; }
  .kk-modal .form-control { height:38px; border:1.5px solid #E6E8EC; border-radius:9px; box-shadow:none; font-size:14px; color:#1F2430; background-color:#fff; }
  .kk-modal .form-control:focus { border-color:#D7182E; box-shadow:0 0 0 3px rgba(215,24,46,.10); }
  .kk-modal .form-control.up { text-transform:uppercase; }
  .kk-modal .form-control.datepicker { width:100% !important; }
  .kk-modal .ab { display:inline-flex; align-items:center; gap:7px; height:36px; padding:0 14px; border-radius:9px; border:1.5px solid #E6E8EC;
    background:#fff; color:#1F2430; font-size:13.5px; font-weight:600; cursor:pointer; }
  .kk-modal .ab:hover { background:#F5F6F8; }
  .kk-modal .ab.primary { background:#D7182E; border-color:#D7182E; color:#fff; }
  .kk-modal .ab.primary:hover { background:#A50F22; border-color:#A50F22; }

  /* Статистика и фильтр по типам */
  .kk-stat { display:inline-flex; align-items:center; gap:7px; height:32px; padding:0 12px; border-radius:16px; border:1.5px solid transparent;
    font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; user-select:none; }
  .kk-stat b { font-variant-numeric:tabular-nums; }
  .kk-stat.cr { background:var(--cr-bg); color:var(--cr); } .kk-stat.bk { background:var(--bk-bg); color:var(--bk); } .kk-stat.ux { background:var(--ux-bg); color:var(--ux); }
  .kk-stat:hover { border-color:currentColor; }
  .kk-stat.on { border-color:currentColor; box-shadow:0 0 0 3px rgba(0,0,0,.04); }
  .kk-sel { height:36px; min-width:200px; padding:0 10px; border:1.5px solid var(--border); border-radius:9px; background:#fff; color:var(--text);
    font-size:13.5px; font-weight:600; font-family:inherit; cursor:pointer; outline:none; }
  .kk-sel:focus { border-color:var(--brand); box-shadow:0 0 0 3px rgba(215,24,46,.10); }
  .kk-none { padding:28px; margin-bottom:18px; text-align:center; color:var(--muted); background:#fff; border:1px dashed var(--border); border-radius:14px; }

  /* Вкладки */
  .kk-tabs { display:flex; gap:3px; padding:3px; background:#E9EBEF; border-radius:10px; }
  .kk-tabs button { display:inline-flex; align-items:center; gap:6px; height:30px; padding:0 12px; border:0; border-radius:8px; background:transparent;
    color:var(--muted); font-size:13px; font-weight:600; font-family:inherit; cursor:pointer; white-space:nowrap; }
  .kk-tabs button:hover { color:var(--text); }
  .kk-tabs button.on { background:#fff; color:var(--text); box-shadow:0 1px 3px rgba(20,25,40,.10); }
  .kk-tabs button.on .fa { color:var(--brand); }
  span.kk-rt { display:inline-flex; align-items:center; gap:8px; flex-wrap:wrap; }
  .kk-card { background:#fff; border:1px solid var(--border); border-radius:14px; padding:14px 16px; margin-bottom:14px; }
  .kk-card-h { display:flex; align-items:center; gap:14px; flex-wrap:wrap; margin-bottom:10px; }
  .kk-card-h .sp { flex:1; }
  .kk-hint { padding-top:8px; font-size:12px; color:var(--muted); }
  .kk-lg .sw { display:inline-block; width:12px; height:12px; border-radius:4px; vertical-align:-2px; }
  .kk-lg .sw.ln { height:0; border-top:2px dashed var(--brand); border-radius:0; vertical-align:3px; }
  .kk-tile .sub { font-size:12px; color:var(--muted); margin-top:3px; }
  .kk-tile.warn .v { color:var(--brand); }
  .t-red .ti { background:var(--brand-soft); color:var(--brand); }

  /* Прогноз: график */
  .fc-chart { position:relative; display:flex; align-items:flex-end; gap:4px; height:220px; padding-top:22px; border-bottom:1px solid var(--border); }
  .fc-col { flex:1; min-width:0; height:100%; display:flex; flex-direction:column; justify-content:flex-end; cursor:pointer; border-radius:4px; position:relative; }
  .fc-col:hover { background:#F5F6F8; }
  .fc-col.sel { background:#FDECEE; }
  .fc-col .p { background:#4CAF7A; }
  .fc-col .p.top, .fc-col .b { border-radius:4px 4px 0 0; }
  .fc-col .b { background:#F0A53A; }
  .fc-col .b.over { background:#E8606F; }
  .fc-col .n { position:absolute; left:0; right:0; text-align:center; font-size:10.5px; font-weight:700; color:var(--muted); font-variant-numeric:tabular-nums; }
  .fc-lim { position:absolute; left:0; right:0; border-top:2px dashed var(--brand); opacity:.55; pointer-events:none; z-index:1; }
  .fc-lim i { position:absolute; right:0; top:-17px; font-style:normal; font-size:11px; font-weight:700; color:var(--brand); }
  .fc-x { display:flex; gap:4px; margin-top:5px; }
  .fc-x span { flex:1; min-width:0; text-align:center; font-size:10.5px; color:var(--muted); font-variant-numeric:tabular-nums; white-space:nowrap; overflow:hidden; }
  .fc-x span.we { color:#9AA1AC; } .fc-x span.over { color:var(--brand); font-weight:700; } .fc-x span.td { color:var(--text); font-weight:700; }
  .fc-day h4 { margin:0; font-size:15px; font-weight:700; }
  .fc-day .cols { display:grid; grid-template-columns:repeat(2, minmax(0, 1fr)); gap:16px; margin-top:10px; }
  .fc-day h5 { margin:0 0 6px; font-size:12px; font-weight:700; letter-spacing:.3px; text-transform:uppercase; color:#9AA1AC; }
  .fc-day .kk-pl li { padding:6px 0; }
  .fc-day .kk-pl .r { color:var(--muted); font-size:12px; white-space:nowrap; }
  .fc-day .empty { color:#9AA1AC; font-size:13px; padding:6px 0; }

  /* Шахматка */
  .gt-wrap { overflow:auto; max-height:calc(100vh - 220px); border:1px solid #F0F1F4; border-radius:10px; }
  .gt { position:relative; min-width:max-content; font-size:12px; }
  .gt-row { display:flex; border-bottom:1px solid #F0F1F4; }
  .gt-row.hd { position:sticky; top:0; z-index:4; background:#F8F9FA; border-bottom:1px solid var(--border); }
  .gt-rm { position:sticky; left:0; z-index:3; flex:none; width:170px; padding:6px 10px; background:#fff; border-right:1px solid var(--border); }
  .gt-row.hd .gt-rm { background:#F8F9FA; color:var(--muted); font-weight:600; display:flex; align-items:center; }
  .gt-rm b { display:block; font-size:13px; }
  .gt-rm span { display:block; color:var(--muted); font-size:11px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
  .gt-rm .full { display:inline; color:var(--brand); font-weight:700; }
  .gt-days { display:flex; }
  .gt-days div { flex:none; text-align:center; padding:4px 0; color:var(--muted); font-weight:600; line-height:1.2; }
  .gt-days div small { display:block; font-size:10px; font-weight:500; color:#9AA1AC; }
  .gt-days div.we { background:#F1F2F4; } .gt-days div.td { color:var(--brand); }
  .gt-fl { position:sticky; left:0; padding:8px 10px 4px; font-size:11.5px; font-weight:700; letter-spacing:.4px; text-transform:uppercase; color:#9AA1AC; background:#FCFCFD; border-bottom:1px solid #F0F1F4; }
  .gt-tr { position:relative; flex:none; cursor:cell; }
  .gt-hv { position:absolute; top:3px; bottom:3px; border-radius:6px; background:var(--brand-soft); color:var(--brand); font-weight:700;
    display:flex; align-items:center; justify-content:center; pointer-events:none; }
  .gt-bar { position:absolute; height:20px; padding:0 7px; border-radius:6px; font-size:11px; font-weight:600; line-height:20px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; cursor:default; z-index:2; box-sizing:border-box; }
  .gt-bar.cr { background:#CDEFD9; color:#0F5A2B; }
  .gt-bar.cr.over { box-shadow:inset -4px 0 0 #D97706; }
  .gt-bar.bk { background:#FDE3BD; color:#8A4B04; cursor:pointer; }
  .gt-bar.ux { background:#FBE0EC; color:#9D174D; }
  .gt-bar.cf { background:#FBD0D6 !important; color:#A50F22 !important; outline:1.5px solid var(--brand); }
  .gt-bar.cl { border-top-left-radius:0; border-bottom-left-radius:0; }
  .gt-bar.cr2 { border-top-right-radius:0; border-bottom-right-radius:0; }
  .gt-empty { padding:30px; text-align:center; color:#9AA1AC; }

  @media (max-width: 1100px) { .kk-kpi { grid-template-columns:repeat(2, minmax(0, 1fr)); } }
  @media (max-width: 700px) { .kk-modal .fg .s2, .kk-modal .fg .s3 { grid-column:span 6; } }
</style>

<div class="kk">
  <div class="kk-bar">
    <h3><span class="ic"><i class="fa fa-h-square"></i></span>Койки</h3>
    <div class="kk-tabs">
      <button type="button" class="on" data-v="rooms" onclick="kkView('rooms')"><i class="fa fa-th-large"></i> Палаты</button>
      <button type="button" data-v="fc" onclick="kkView('fc')"><i class="fa fa-bar-chart"></i> Прогноз</button>
      <button type="button" data-v="gt" onclick="kkView('gt')"><i class="fa fa-calendar"></i> Шахматка</button>
    </div>
    <%-- статистика по типам: считаем по тем же данным, что выводятся в палатах --%>
    <c:set var="nCr" value="0"/><c:set var="nBk" value="0"/><c:set var="nUx" value="0"/><c:set var="nFree" value="0"/><c:set var="nBeds" value="0"/>
    <c:forEach items="${stages}" var="st">
      <c:forEach items="${st.rooms}" var="rm">
        <c:if test="${rm.state == 'A' && fn:length(rm.patients) == 0}"><c:set var="nFree" value="${nFree + 1}"/></c:if>
        <c:set var="occ" value="0"/>
        <c:forEach items="${rm.patients}" var="pt">
          <c:set var="occ" value="${occ + (pt.c2 == 'bk' ? pt.c3 : 1)}"/>
          <c:if test="${pt.c2 == 'cr'}"><c:set var="nCr" value="${nCr + 1}"/></c:if>
          <c:if test="${pt.c2 == 'bk'}"><c:set var="nBk" value="${nBk + 1}"/></c:if>
          <c:if test="${pt.c2 == 'ux'}"><c:set var="nUx" value="${nUx + 1}"/></c:if>
        </c:forEach>
        <c:if test="${rm.state == 'A' && rm.limit - occ > 0}"><c:set var="nBeds" value="${nBeds + rm.limit - occ}"/></c:if>
      </c:forEach>
    </c:forEach>
    <span class="kk-rt">
    <span class="kk-stat cr" onclick="kkFilter('cr', true)" title="Показать только пациентов"><span class="kk-dot cr"></span> Пациент <b>${nCr}</b></span>
    <span class="kk-stat bk" onclick="kkFilter('bk', true)" title="Показать только брони"><span class="kk-dot bk"></span> Бронь <b>${nBk}</b></span>
    <span class="kk-stat ux" onclick="kkFilter('ux', true)" title="Показать только уход"><span class="kk-dot ux"></span> Уход <b>${nUx}</b></span>
    </span>
    <span class="sp"></span>
    <select id="kkType" class="kk-sel kk-rt" onchange="kkFilter(this.value)" title="Фильтр по типу">
      <option value="">Все типы</option>
      <option value="cr">Пациент (${nCr})</option>
      <option value="bk">Бронь (${nBk})</option>
      <option value="ux">Уход (${nUx})</option>
      <option value="free">Свободные палаты (${nFree})</option>
      <option value="beds">Свободные койки (${nBeds})</option>
    </select>
    <select id="kkDept" class="kk-sel kk-ft" onchange="kkRender()" title="Отделение" style="display:none">
      <option value="0">Все отделения</option>
      <c:forEach items="${depts}" var="dp"><option value="${dp.id}">${dp.name}</option></c:forEach>
    </select>
    <select id="kkDays" class="kk-sel kk-ft" onchange="kkRender()" title="Период" style="display:none; min-width:120px">
      <option value="7">7 дней</option>
      <option value="14" selected>14 дней</option>
      <option value="30">30 дней</option>
    </select>
  </div>

  <!-- ================= Прогноз ================= -->
  <div id="kkVfc" style="display:none">
    <div class="kk-kpi" id="fcKpi"></div>
    <div class="kk-card">
      <div class="kk-card-h"><b>Загрузка коек по дням</b><span class="sp"></span>
        <span class="kk-lg"><span class="sw" style="background:#4CAF7A"></span> Пациенты и уход</span>
        <span class="kk-lg"><span class="sw" style="background:#F0A53A"></span> Брони</span>
        <span class="kk-lg"><span class="sw ln"></span> Лимит коек</span>
      </div>
      <div class="fc-chart" id="fcChart"></div>
      <div class="kk-hint">Наведите на столбец, чтобы увидеть цифры, и кликните, чтобы посмотреть, кто в этот день поступает и выписывается. Красная дата означает нехватку мест.</div>
    </div>
    <div class="kk-card" id="fcDay" style="display:none"></div>
  </div>

  <!-- ================= Шахматка ================= -->
  <div id="kkVgt" style="display:none">
    <div class="kk-card">
      <div class="kk-card-h">
        <span class="kk-lg"><span class="sw" style="background:#CDEFD9"></span> Пациент</span>
        <span class="kk-lg"><span class="sw" style="background:#FDE3BD"></span> Бронь</span>
        <span class="kk-lg"><span class="sw" style="background:#FBE0EC"></span> Уход</span>
        <span class="kk-lg"><span class="sw" style="background:#FBD0D6; outline:1.5px solid #D7182E"></span> Нет места</span>
        <span class="kk-lg">Бронь считается на <span class="gtDef">10</span> дн.</span>
        <span class="sp"></span>
        <span class="kk-hint" style="padding:0">Клик по пустой клетке открывает бронь на эту палату и дату, клик по брони открывает её</span>
      </div>
      <div class="gt-wrap" id="gtWrap"></div>
    </div>
  </div>

  <div id="kkVrooms">
  <div class="kk-none" id="kkNone" style="display:none">По выбранному типу ничего нет</div>

  <!-- ================= Плитки ================= -->
  <div class="kk-kpi">
    <div class="kk-tile t-blue">
      <div class="top">
        <span class="ti"><i class="fa fa-users"></i></span>
        <div><div class="v">${cur}</div><div class="l">Пациентов в стационаре</div></div>
      </div>
    </div>
    <div class="kk-tile t-amb">
      <div class="top">
        <span class="ti"><i class="fa fa-sign-out"></i></span>
        <div><div class="v">${vyp}</div><div class="l">Выписка</div></div>
      </div>
      <div class="dt">на дату <input id="period_end" onchange="setVypDate(this.value)" type="text" class="form-control datepicker" value="${vypDate}"/></div>
    </div>
    <div class="kk-tile t-grn">
      <div class="top">
        <span class="ti"><i class="fa fa-home"></i></span>
        <div><div class="v">${emptyCount}</div><div class="l">Свободных палат</div></div>
      </div>
      <div class="dt">на дату <input id="period_ends" onchange="setEmptyDate(this.value)" type="text" class="form-control datepicker" value="${emptyDate}"/></div>
    </div>
    <div class="kk-tile t-gry">
      <div class="top">
        <span class="ti"><i class="fa fa-h-square"></i></span>
        <div><div class="v">${nBeds}</div><div class="l">Свободных коек</div></div>
      </div>
    </div>
  </div>

  <!-- ================= Этажи и палаты ================= -->
  <c:forEach items="${stages}" var="stage">
    <div class="kk-floor noselect">
      <div class="kk-floor-h">
        <h4>${stage.name}</h4>
        <span class="n">${fn:length(stage.rooms)} палат</span>
        <span class="ln"></span>
      </div>
      <div class="kk-grid">
        <c:forEach items="${stage.rooms}" var="room">
          <c:set var="pc" value="${fn:length(room.patients)}"/>
          <c:set var="occ" value="0"/>
          <c:forEach items="${room.patients}" var="pt"><c:set var="occ" value="${occ + (pt.c2 == 'bk' ? pt.c3 : 1)}"/></c:forEach>
          <c:set var="fb" value="${room.state == 'A' && room.limit - occ > 0 ? room.limit - occ : 0}"/>
          <div class="kk-room<c:if test="${room.state != 'A'}"> off</c:if><c:if test="${room.state == 'A' && pc == 0}"> free</c:if>" data-beds="${fb}">
            <div class="kk-room-h">
              <span class="num">№ ${room.num}</span>
              <span class="tp" title="${room.type}">${room.type}</span>
              <span class="sp"></span>
              <c:if test="${room.state == 'A'}"><span class="beds<c:if test="${fb > 0}"> has</c:if>" title="Свободных коек из лимита палаты"><i class="fa fa-h-square"></i> ${fb} из ${room.limit}</span></c:if>
              <c:if test="${room.state == 'A'}">
                <button type="button" class="kk-add" title="Забронировать" onclick="addBooking(${room.id})"><i class="fa fa-plus"></i></button>
              </c:if>
            </div>
            <c:choose>
              <c:when test="${room.state != 'A'}">
                <div class="kk-off"><i class="fa fa-ban"></i> Палата временно не функционирует</div>
              </c:when>
              <c:when test="${pc == 0}">
                <div class="kk-free">Свободно</div>
              </c:when>
              <c:otherwise>
                <ul class="kk-pl">
                  <c:forEach items="${room.patients}" var="patient">
                    <li data-t="${patient.c2}">
                      <span class="kk-dot ${patient.c2}" title="<c:choose><c:when test="${patient.c2 == 'cr'}">Пациент</c:when><c:when test="${patient.c2 == 'bk'}">Бронь</c:when><c:otherwise>Уход</c:otherwise></c:choose>"></span>
                      <span class="fio" title="${patient.fio}">${patient.fio}</span>
                      <c:choose>
                        <c:when test="${patient.c2 == 'ux'}"><span class="ib ux">Уход</span></c:when>
                        <c:when test="${patient.c2 == 'bk'}"><span class="ib bk" title="Коек: ${patient.c3}<c:if test="${patient.c4 == 'Y'}">, включая ухаживающего</c:if>">Бронь<c:if test="${patient.c3 > 1}"> ×${patient.c3}</c:if></span></c:when>
                        <c:when test="${not empty patient.ib}"><span class="ib" title="№ истории болезни">${patient.ib}</span></c:when>
                      </c:choose>
                      <span class="dd" title="Регистрация → выписка">${patient.date}<c:if test="${not empty patient.c1}"><i class="fa fa-long-arrow-right"></i>${patient.c1}</c:if></span>
                    </li>
                  </c:forEach>
                </ul>
              </c:otherwise>
            </c:choose>
          </div>
        </c:forEach>
      </div>
    </div>
  </c:forEach>
  </div>
</div>

<!-- AddEdit Form -->
<a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
<div class="modal fade kk-modal" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 class="modal-title" id="myModalLabel"><i class="fa fa-h-square"></i> Пациент маълумотлари</h4>
      </div>
      <div class="modal-body">
        <form id="addEditForm" name="addEditForm">
          <input type="hidden" name="id" value="" />

          <div class="sec">Пациент</div>
          <div class="fg">
            <div class="f s2">
              <label>Фамилия <i>*</i></label>
              <input type="text" autocomplete="off" placeholder="Фамилия" class="form-control up" name="surname" value="" required/>
            </div>
            <div class="f s2">
              <label>Исм <i>*</i></label>
              <input type="text" autocomplete="off" placeholder="Исм" class="form-control up" name="name" value="" required/>
            </div>
            <div class="f s2">
              <label>Шариф</label>
              <input type="text" autocomplete="off" placeholder="Шариф" class="form-control up" name="middlename" value=""/>
            </div>
            <div class="f s2">
              <label>Тугилган йили <i>*</i></label>
              <input type="number" autocomplete="off" placeholder="xxxx" class="form-control center" name="birthyear" value="" required/>
            </div>
            <div class="f s2">
              <label>Жинси <i>*</i></label>
              <select name="sex" class="form-control" required>
                <c:forEach items="${sex}" var="ss">
                  <option value="${ss.id}">${ss.name}</option>
                </c:forEach>
              </select>
            </div>
            <div class="f s2">
              <label>Резидентлиги <i>*</i></label>
              <select name="country" class="form-control" required>
                <c:forEach items="${countries}" var="ss">
                  <option value="${ss.id}">${ss.name}</option>
                </c:forEach>
              </select>
            </div>
            <div class="f s3">
              <label>Телефон <i>*</i></label>
              <input type="text" autocomplete="off" class="form-control" name="tel" value="" required/>
            </div>
            <div class="f s3">
              <label>Паспорт маълумотлари</label>
              <input type="text" autocomplete="off" class="form-control" name="passport" value=""/>
            </div>
          </div>

          <div class="sec">Бронь</div>
          <div class="fg">
            <div class="f s2">
              <label>Дата рег <i>*</i></label>
              <input type="text" autocomplete="off" placeholder="дд.мм.гггг" class="form-control datepicker" id="date_begin" name="date_begin" value="" required/>
            </div>
            <div class="f s2">
              <label>Булим <i>*</i></label>
              <select name="dept" class="form-control" required>
                <c:forEach items="${depts}" var="ss">
                  <option value="${ss.id}">${ss.name}</option>
                </c:forEach>
              </select>
            </div>
            <div class="f s2">
              <label>№ хона <i>*</i></label>
              <select name="room" class="form-control" required>
                <c:forEach items="${rooms}" var="ss">
                  <option value="${ss.id}">${ss.name} - ${ss.roomType.name}</option>
                </c:forEach>
              </select>
            </div>
            <div class="f s2">
              <label>Кол-во коек <i>*</i></label>
              <input type="number" min="1" max="20" autocomplete="off" class="form-control" name="bed_count" value="1" required/>
            </div>
            <div class="f s2">
              <label title="Бронь или ухаживающий рядом с пациентом: +1 койка">Бронь</label>
              <select name="bron" class="form-control" title="Бронь или ухаживающий рядом с пациентом: +1 койка">
                <option value="0">Нет</option>
                <c:forEach items="${watcherTypes}" var="type">
                  <option value="${type.id}">${type.name} (+1 койка)</option>
                </c:forEach>
              </select>
            </div>
            <div class="f s2">
              <label>Шифокор</label>
              <select name="lv" class="form-control">
                <option></option>
                <c:forEach items="${lvs}" var="ss">
                  <option value="${ss.id}">${ss.profil} - ${ss.fio}</option>
                </c:forEach>
              </select>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="ab" id="close-modal" data-dismiss="modal">Закрыть</button>
        <button type="button" class="ab primary" onclick="saveBooking()"><i class="fa fa-floppy-o"></i> Сохранить</button>
      </div>
    </div>
  </div>
</div>
<script>
  // фильтр палат по типу: пациент / бронь / уход / свободные (повторный клик по чипу снимает фильтр)
  function kkFilter(t, toggle) {
    var sel = $('#kkType');
    if (toggle && sel.val() === t) t = '';
    sel.val(t);
    $('.kk-stat').removeClass('on');
    if (t) $('.kk-stat.' + t).addClass('on');
    var any = false;
    $('.kk-floor').each(function () {
      var floorAny = false;
      $(this).find('.kk-room').each(function () {
        var room = $(this), li = room.find('.kk-pl li'), show;
        if (!t) { li.show(); show = true; }
        else if (t === 'free') { li.show(); show = room.hasClass('free'); }
        else if (t === 'beds') { li.show(); show = parseInt(room.attr('data-beds'), 10) > 0; }
        else { li.each(function () { $(this).toggle($(this).attr('data-t') === t); }); show = li.filter('[data-t=' + t + ']').length > 0; }
        room.toggle(show);
        if (show) floorAny = true;
      });
      $(this).toggle(floorAny);
      if (floorAny) any = true;
    });
    $('#kkNone').toggle(!any);
  }
  // закрыть окно брони и только потом перезагрузить страницу (иначе остаётся тёмный фон окна)
  function closeModalThen(url) {
    var m = $('#myModal');
    var go = function () {
      $('.modal-backdrop').remove();
      $('body').removeClass('modal-open').css('padding-right', '');
      setPage(url);
    };
    if (m.hasClass('in')) m.one('hidden.bs.modal', go).modal('hide'); else go();
  }
  function addBooking(id){
    addEditForm.reset();
    document.getElementById("modal_window").click();
    document.getElementsByName('room')[0].value = id;
  }
  function editBooking(id) {
    document.getElementById("modal_window").click();
    $.ajax({
      url: '/booking/get.s',
      method: 'post',
      data: 'id=' + id,
      dataType: 'json',
      success: function (res) {
        if (res.success) {
          var data = res.data;
          for (var e in data) {
            try {
              document.getElementsByName(e)[0].value = data[e];
            } catch (e) {}
          }
        } else {
          openMedMsg(res.msg, false);
        }
      }
    });
  }
  function saveBooking() {
    if (checkForm($('#addEditForm'))) {
      $.ajax({
        url: '/booking/save.s',
        method: 'post',
        data: $('#addEditForm').serialize(),
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            openMsg(res);
            closeModalThen('/booking/koyki.s');
          } else {
            openMedMsg(res.msg, false);
          }
        }
      });
    }
  }

  // ================= Прогноз и шахматка =================
  var kkData = null;
  var KK_WD = ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'];
  function kkView(v) {
    $('.kk-tabs button').removeClass('on').filter('[data-v=' + v + ']').addClass('on');
    $('#kkVrooms').toggle(v === 'rooms');
    $('#kkVfc').toggle(v === 'fc');
    $('#kkVgt').toggle(v === 'gt');
    $('.kk-rt').toggle(v === 'rooms');
    $('.kk-ft').toggle(v !== 'rooms');
    try { sessionStorage.setItem('kkView', v); } catch (e) {}
    if (v !== 'rooms') kkLoad();
  }
  function kkLoad() {
    if (kkData) { kkRender(); return; }
    $('#fcChart').html('<div class="kk-hint" style="margin:auto">Загрузка...</div>');
    $('#gtWrap').html('<div class="gt-empty">Загрузка...</div>');
    $.ajax({
      url: '/booking/forecast.s',
      dataType: 'json',
      cache: false,
      success: function (res) {
        if (!res.success) { openMedMsg(res.msg, false); return; }
        kkData = res;
        $('.gtDef').text(res.defDays);
        kkRender();
      },
      error: function () { openMedMsg('Не удалось загрузить данные прогноза', false); }
    });
  }
  function kkD(iso) { var p = iso.split('-'); return new Date(+p[0], p[1] - 1, +p[2]); }
  function kkFmt(d, full) {
    var s = ('0' + d.getDate()).slice(-2) + '.' + ('0' + (d.getMonth() + 1)).slice(-2);
    return full ? s + '.' + d.getFullYear() : s;
  }
  function kkEsc(t) { return $('<div/>').text(t == null ? '' : t).html(); }
  function kkRender() {
    if (!kkData) return;
    var dept = $('#kkDept').val(), n = parseInt($('#kkDays').val(), 10), t0 = kkD(kkData.today), days = [];
    for (var i = 0; i < n; i++) { var d = new Date(t0); d.setDate(t0.getDate() + i); days.push(d); }
    var di = function (iso) { return Math.round((kkD(iso) - t0) / 86400000); };
    var rooms = $.grep(kkData.rooms, function (r) { return r.state === 'A' && (dept === '0' || String(r.dept) === dept); });
    rooms.sort(function (a, b) {
      return a.floor === b.floor ? String(a.num).localeCompare(String(b.num), 'ru', {numeric: true}) : String(a.floor).localeCompare(String(b.floor), 'ru', {numeric: true});
    });
    var byRoom = {};
    $.each(rooms, function (k, r) { byRoom[r.id] = {room: r, items: [], occ: days.map(function () { return 0; })}; });
    var list = $.grep(kkData.items, function (it) { return byRoom[it.room]; });
    // сначала пациенты, потом брони по дате: бронь, которая не помещается в лимит палаты, отмечается «нет места»
    list.sort(function (a, b) { return a.t === b.t ? (a.from < b.from ? -1 : a.from > b.from ? 1 : 0) : (a.t === 'cr' ? -1 : 1); });
    $.each(list, function (k, it) {
      var b = byRoom[it.room];
      it.s = di(it.from); it.e = di(it.to); it.cf = false;
      it.w = it.t === 'bk' ? (it.beds || 1) : 1;
      for (var i = Math.max(0, it.s); i < Math.min(n, it.e); i++) { b.occ[i] += it.w; if (it.t === 'bk' && b.occ[i] > b.room.limit) it.cf = true; }
      b.items.push(it);
    });
    kkForecast(rooms, byRoom, days, n);
    kkGantt(rooms, byRoom, days, n);
  }

  function kkForecast(rooms, byRoom, days, n) {
    var L = 0, pt = days.map(function () { return 0; }), bk = pt.slice(), dis = 0, arr = 0, cf = 0, i;
    $.each(rooms, function (k, r) {
      L += r.limit;
      $.each(byRoom[r.id].items, function (j, it) {
        for (var i = Math.max(0, it.s); i < Math.min(n, it.e); i++) (it.t === 'bk' ? bk : pt)[i] += it.w;
        if (it.t === 'cr' && !it.over && it.e >= 1 && it.e < n) dis++;
        if (it.t === 'bk' && it.s >= 0 && it.s < n) arr++;
        if (it.cf && it.e > 0 && it.s < n) cf++;
      });
    });
    var short = [];
    for (i = 0; i < n; i++) if (pt[i] + bk[i] > L) short.push(kkFmt(days[i]));
    var occ0 = pt[0] + bk[0];
    $('#fcKpi').html(
      '<div class="kk-tile t-blue"><div class="top"><span class="ti"><i class="fa fa-users"></i></span><div><div class="v">' + occ0 + ' / ' + L + '</div><div class="l">Занято сегодня, свободно ' + Math.max(0, L - occ0) + '</div></div></div></div>' +
      '<div class="kk-tile t-amb"><div class="top"><span class="ti"><i class="fa fa-sign-out"></i></span><div><div class="v">' + dis + '</div><div class="l">Плановых выписок за ' + n + ' дн.</div></div></div></div>' +
      '<div class="kk-tile t-grn"><div class="top"><span class="ti"><i class="fa fa-sign-in"></i></span><div><div class="v">' + arr + '</div><div class="l">Поступлений по броням за ' + n + ' дн.</div></div></div></div>' +
      '<div class="kk-tile t-red' + (short.length || cf ? ' warn' : '') + '"><div class="top"><span class="ti"><i class="fa fa-exclamation-triangle"></i></span><div><div class="v">' + short.length + ' дн.</div><div class="l">Нехватка мест' +
        (short.length ? ': ' + short.slice(0, 4).join(', ') + (short.length > 4 ? '…' : '') : '') + '</div>' +
        (cf ? '<div class="sub">Броней без места в своей палате: <b>' + cf + '</b></div>' : '') + '</div></div></div>');
    var top = L;
    for (i = 0; i < n; i++) top = Math.max(top, pt[i] + bk[i]);
    var max = (top || 1) * 1.08, H = 198;
    var h = '<div class="fc-lim" style="bottom:' + (L / max * H) + 'px"><i>лимит ' + L + '</i></div>';
    for (i = 0; i < n; i++) {
      var tot = pt[i] + bk[i], over = tot > L;
      h += '<div class="fc-col" data-i="' + i + '" title="' + kkFmt(days[i], true) + ': пациенты и уход ' + pt[i] + ', брони ' + bk[i] + ', свободно ' + Math.max(0, L - tot) + (over ? ', не хватает ' + (tot - L) : '') + '">' +
        '<span class="n" style="bottom:' + (tot / max * H + 2) + 'px">' + (n <= 14 ? tot : '') + '</span>' +
        (bk[i] ? '<div class="b' + (over ? ' over' : '') + '" style="height:' + (bk[i] / max * H) + 'px"></div>' : '') +
        '<div class="p' + (bk[i] ? '' : ' top') + '" style="height:' + (pt[i] / max * H) + 'px"></div></div>';
    }
    $('#fcChart').html(h);
    var x = '';
    for (i = 0; i < n; i++) {
      var wd = days[i].getDay(), cls = i === 0 ? 'td' : (pt[i] + bk[i] > L ? 'over' : (wd === 0 || wd === 6 ? 'we' : ''));
      x += '<span class="' + cls + '">' + (n > 14 ? days[i].getDate() : kkFmt(days[i])) + '</span>';
    }
    $('#fcChart').next('.fc-x').remove();
    $('#fcChart').after('<div class="fc-x">' + x + '</div>');
    $('#fcChart .fc-col').on('click', function () {
      $('#fcChart .fc-col').removeClass('sel');
      $(this).addClass('sel');
      kkDay(parseInt($(this).attr('data-i'), 10), rooms, byRoom, days);
    });
    $('#fcDay').hide();
  }
  function kkDay(i, rooms, byRoom, days) {
    var inn = [], out = [];
    $.each(rooms, function (k, r) {
      $.each(byRoom[r.id].items, function (j, it) {
        var line = '<li><span class="kk-dot ' + it.t + '"></span><span class="fio">' + kkEsc(it.fio) + '</span>' +
          (it.t === 'bk' ? '<span class="ib bk">' + (it.cf ? 'нет места' : 'бронь') + (it.w > 1 ? ' ×' + it.w : '') + '</span>' : (it.ib ? '<span class="ib">' + kkEsc(it.ib) + '</span>' : '')) +
          '<span class="r">№ ' + kkEsc(r.num) + ', ' + kkEsc(r.type) + '</span></li>';
        if (it.s === i) inn.push(line);
        if (it.e === i && !(it.t === 'cr' && it.over)) out.push(line);
      });
    });
    $('#fcDay').html('<div class="fc-day"><h4>' + KK_WD[days[i].getDay()] + ', ' + kkFmt(days[i], true) + '</h4><div class="cols">' +
      '<div><h5>Поступают (' + inn.length + ')</h5>' + (inn.length ? '<ul class="kk-pl">' + inn.join('') + '</ul>' : '<div class="empty">Никого</div>') + '</div>' +
      '<div><h5>Выписываются (' + out.length + ')</h5>' + (out.length ? '<ul class="kk-pl">' + out.join('') + '</ul>' : '<div class="empty">Никого</div>') + '</div>' +
      '</div></div>').show();
  }

  function kkGantt(rooms, byRoom, days, n) {
    if (!rooms.length) { $('#gtWrap').html('<div class="gt-empty">Нет палат в выбранном отделении</div>'); return; }
    // ширина дня: растягиваем шахматку на всю ширину, но не уже 28px
    var avail = ($('#gtWrap').width() || 900) - 172, W = Math.max(28, Math.min(90, Math.floor(avail / n))), LH = 24;
    var h = '<div class="gt"><div class="gt-row hd"><div class="gt-rm">Палата</div><div class="gt-days">';
    $.each(days, function (i, d) {
      var wd = d.getDay();
      h += '<div style="width:' + W + 'px" class="' + (i === 0 ? 'td' : (wd === 0 || wd === 6 ? 'we' : '')) + '">' + d.getDate() + '<small>' + KK_WD[wd] + '</small></div>';
    });
    h += '</div></div>';
    var floor = null;
    var grid = 'background-image:repeating-linear-gradient(to right, transparent 0 ' + (W - 1) + 'px, #F0F1F4 ' + (W - 1) + 'px ' + W + 'px), linear-gradient(to right, #FFF7F8 0 ' + W + 'px, transparent ' + W + 'px);';
    $.each(rooms, function (k, r) {
      if (r.floor !== floor) { floor = r.floor; h += '<div class="gt-fl" style="width:' + (170 + n * W) + 'px">' + kkEsc(floor) + '</div>'; }
      var b = byRoom[r.id], lanes = [], bars = '';
      var vis = $.grep(b.items, function (it) { return it.e > 0 && it.s < n; });
      vis.sort(function (a, c) { return a.s - c.s; });
      $.each(vis, function (j, it) {
        var s = Math.max(0, it.s), e = Math.min(n, it.e), l = 0;
        while (lanes[l] != null && lanes[l] > s) l++;
        lanes[l] = e;
        var cls = 'gt-bar ' + it.t + (it.cf ? ' cf' : '') + (it.over ? ' over' : '') + (it.s < 0 ? ' cl' : '') + (it.e > n ? ' cr2' : '');
        var tip = it.fio + (it.ib ? ', ИБ ' + it.ib : '') + '\n' + (it.t === 'cr' ? 'Пациент' : it.t === 'ux' ? 'Уход' : 'Бронь') + ': ' + kkFmt(kkD(it.from), true) + ' → ' + kkFmt(kkD(it.to), true) +
          (it.over ? '\nПлановая выписка прошла, пациент ещё в палате' : '') + (it.t === 'bk' ? '\nКоек: ' + it.w + (it.extra ? ', включая ухаживающего' : '') + '\nБронь считается на ' + kkData.defDays + ' дн.' : '') +
          (it.cf ? '\nВ палате не хватает места' : '') + (it.t === 'bk' ? '\nКлик: открыть бронь' : '');
        bars += '<div class="' + cls + '" data-t="' + it.t + '" data-id="' + it.id + '" title="' + kkEsc(tip) + '" style="left:' + (s * W + 2) + 'px;width:' + Math.max(8, (e - s) * W - 4) + 'px;top:' + (4 + l * LH) + 'px">' +
          (it.cf ? '⚠ ' : '') + kkEsc(it.fio) + (it.w > 1 ? ' <b>×' + it.w + '</b>' : '') + '</div>';
      });
      var rows = Math.max(1, lanes.length), occ0 = b.occ[0];
      h += '<div class="gt-row"><div class="gt-rm"><b>№ ' + kkEsc(r.num) + '</b><span>' + kkEsc(r.type) + ', ' +
        (occ0 >= r.limit ? '<span class="full">' + occ0 + ' из ' + r.limit + '</span>' : occ0 + ' из ' + r.limit) + '</span></div>' +
        '<div class="gt-tr" data-room="' + r.id + '" data-dept="' + r.dept + '" style="width:' + (n * W) + 'px;height:' + (rows * LH + 8) + 'px;' + grid + '">' + bars + '</div></div>';
    });
    h += '</div>';
    $('#gtWrap').html(h);
    $('#gtWrap .gt-tr').on('mousemove', function (e) {
      var tr = $(this);
      if (e.target !== this) { tr.find('.gt-hv').remove(); return; }
      var i = Math.floor((e.pageX - tr.offset().left) / W), hv = tr.find('.gt-hv');
      if (!hv.length) hv = $('<div class="gt-hv">+</div>').appendTo(tr);
      hv.css({left: i * W + 2, width: W - 4});
    }).on('mouseleave', function () {
      $(this).find('.gt-hv').remove();
    }).on('click', function (e) {
      var bar = $(e.target).closest('.gt-bar');
      if (bar.length) { if (bar.attr('data-t') === 'bk') editBooking(bar.attr('data-id')); return; }
      var tr = $(this), i = Math.floor((e.pageX - tr.offset().left) / W), dp = tr.attr('data-dept');
      if (i < 0 || i >= n) return;
      addBooking(tr.attr('data-room'));
      $('#date_begin').val(kkFmt(days[i], true));
      if (dp !== '0' && $('select[name=dept] option[value=' + dp + ']').length) $('select[name=dept]').val(dp);
    });
  }
  try { var kkV = sessionStorage.getItem('kkView'); if (kkV === 'fc' || kkV === 'gt') kkView(kkV); } catch (e) {}
</script>
