<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  .tg-page { --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8; --tg:#229ED9;
    height:100%; box-sizing:border-box; display:flex; flex-direction:column; gap:8px;
    padding:10px 14px; background:var(--bg); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:var(--text); }
  .tg-page * { box-sizing:border-box; }
  .tg-box { flex:1; min-height:0; display:flex; flex-direction:column; background:#fff; border:1px solid var(--border); border-radius:16px;
    overflow:hidden; box-shadow:0 1px 2px rgba(20,25,40,.04), 0 8px 24px rgba(20,25,40,.06); }

  .tg-toolbar { flex:none; display:flex; align-items:center; flex-wrap:wrap; gap:10px; padding:8px 14px; }
  .tg-title { display:flex; align-items:center; gap:12px; }
  .tg-title .ic { width:30px; height:30px; border-radius:9px; display:flex; align-items:center; justify-content:center;
    background:#E8F4FC; color:var(--tg); font-size:14px; }
  .tg-title h2 { margin:0; font-size:16px; font-weight:700; line-height:1.2; }
  .tg-count { display:block; font-size:12.5px; color:var(--muted); font-variant-numeric:tabular-nums; }
  .tg-count b { color:var(--text); font-weight:600; }
  .tg-spacer { flex:1; }
  .tg-seg { display:flex; padding:2px; background:#F1F2F4; border-radius:9px; }
  .tg-seg button { height:26px; padding:0 10px; border:0; border-radius:7px; background:none; color:var(--muted);
    font-size:12.5px; font-weight:600; font-family:inherit; cursor:pointer; }
  .tg-seg button.on { background:#fff; color:var(--text); box-shadow:0 1px 2px rgba(20,25,40,.08); }
  .tg-search-wrap { position:relative; }
  .tg-search-wrap .fa { position:absolute; left:10px; top:9px; color:#9AA1AC; font-size:12px; }
  .tg-search { width:220px; height:30px; padding:0 10px 0 28px; border:1px solid var(--border); border-radius:9px; font-size:13px; font-family:inherit; color:var(--text); }
  .tg-search:focus { outline:none; border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }

  .tg-warn { margin:0 14px 8px; padding:8px 12px; border-radius:9px; background:#FFF6E5; color:#8A5A00; font-size:13px; }

  .tg-table-wrap { flex:1; min-height:0; overflow:auto; border-top:1px solid var(--border); }
  table.tg-grid { width:100%; margin:0; border-collapse:separate; border-spacing:0; font-size:13px; }
  table.tg-grid thead th { position:sticky; top:0; z-index:2; height:32px; padding:0 8px; background:#F8F9FA; border-bottom:1px solid var(--border);
    color:var(--muted); font-size:11px; font-weight:600; text-transform:uppercase; letter-spacing:.3px; text-align:left; white-space:nowrap; }
  table.tg-grid tbody td { height:40px; padding:0 8px; border-bottom:1px solid #F0F1F4; vertical-align:middle; white-space:nowrap; font-variant-numeric:tabular-nums; }
  table.tg-grid tbody tr:hover td { background:#F8F9FB; }
  table.tg-grid td.num { color:#B0B5BD; font-size:12px; text-align:center; }
  table.tg-grid td.mut { color:var(--muted); }
  table.tg-grid td.none { color:#C3C7CE; }
  table.tg-grid .fio { font-weight:600; }
  table.tg-grid .login { margin-left:6px; color:var(--muted); font-size:12px; }
  .tg-dot { display:inline-block; width:8px; height:8px; margin-right:7px; border-radius:50%; background:#C3C7CE; vertical-align:middle; }
  .tg-dot.on { background:#22A55B; box-shadow:0 0 0 3px rgba(34,165,91,.15); }
  .tg-sub { display:block; color:var(--muted); font-size:11.5px; line-height:1.2; }

  .tg-chip { display:inline-flex; align-items:center; gap:5px; height:24px; margin:0 4px 0 0; padding:0 9px; border-radius:7px; border:1px solid transparent;
    font-size:12px; font-weight:600; font-family:inherit; cursor:pointer; user-select:none; }
  .tg-chip.on { background:#E9F7EF; color:#1E7B43; border-color:#CDEBD9; }
  .tg-chip.off { background:#F5F6F8; color:#9AA1AC; border-color:var(--border); text-decoration:line-through; }
  .tg-chip .fa { font-size:11px; }
  .tg-chip:hover { filter:brightness(.97); }

  /* сводка уведомлений в строке: число включённых, отключённые подписаны; настройка в окне */
  .tg-sum { display:inline-flex; align-items:center; gap:8px; height:28px; padding:0 10px; border:1px solid var(--border); border-radius:8px; background:#fff;
    font-size:12.5px; font-weight:600; font-family:inherit; color:var(--text); cursor:pointer; max-width:100%; overflow:hidden; }
  .tg-sum:hover { background:#F5F6F8; }
  .tg-sum .fa { color:#22A55B; }
  .tg-sum.part .fa { color:#D97706; }
  .tg-sum.none .fa { color:#9AA1AC; }
  .tg-sum .bar { width:46px; height:6px; border-radius:3px; background:#EEF0F3; overflow:hidden; flex:none; }
  .tg-sum .bar i { display:block; height:100%; background:#22A55B; border-radius:3px; }
  .tg-sum.part .bar i { background:#D97706; }
  /* отключённые типы — отдельной строкой под сводкой, мелкими метками с переносом */
  .tg-offs { display:flex; flex-wrap:wrap; gap:4px; margin-top:5px; max-width:420px; }
  .tg-offs span { display:inline-flex; align-items:center; gap:4px; padding:1px 7px; border-radius:999px; background:#F3F4F6; color:#6B7280; font-size:11.5px; line-height:18px; }
  .tg-offs span .fa { font-size:10px; color:#B0B6BF; }
  .tg-kmode .tg-offs { display:none; }
  .tg-kinds { display:none; }
  .tg-kmode .tg-sum { display:none; }
  .tg-kmode .tg-kinds { display:block; }
  .tg-kmode .tg-kinds .tg-chip { display:none; }
  .tg-kmode .tg-kinds .tg-chip.cur { display:inline-flex; }
  .tg-kind-sel { height:30px; min-width:220px; padding:0 8px; border:1px solid var(--border); border-radius:9px; font-size:13px; font-family:inherit; color:var(--text); background:#fff; }
  /* окно настроек: переключатель на каждый тип */
  .tg-sw-row { display:flex; align-items:center; gap:12px; padding:10px 2px; border-bottom:1px solid #F0F1F4; cursor:pointer; user-select:none; }
  .tg-sw-row:last-child { border-bottom:0; }
  .tg-sw-row .nm { flex:1; font-size:14px; }
  .tg-sw { position:relative; width:38px; height:22px; border-radius:11px; background:#D5D8DE; transition:background .15s; flex:none; }
  .tg-sw:after { content:''; position:absolute; top:3px; left:3px; width:16px; height:16px; border-radius:50%; background:#fff; box-shadow:0 1px 2px rgba(0,0,0,.2); transition:left .15s; }
  .tg-sw-row.on .tg-sw { background:#22A55B; }
  .tg-sw-row.on .tg-sw:after { left:19px; }
  .tg-sw-row.busy { opacity:.5; pointer-events:none; }
  .tg-act { width:30px; height:28px; margin-left:2px; border:1px solid var(--border); border-radius:8px; background:#fff; color:#3C4250; cursor:pointer; }
  .tg-act:hover { background:#F5F6F8; }
  .tg-act.danger:hover { color:#A50F22; border-color:#F3C5CB; background:#FDECEE; }
  .tg-act[disabled] { opacity:.35; cursor:default; background:#fff; }

  .tg-empty { padding:60px 20px; text-align:center; color:#9AA1AC; }
  .tg-empty .fa { display:block; font-size:36px; margin-bottom:10px; color:#D5D8DE; }

  /* ---------- Окна ---------- */
  .tg-overlay { position:fixed; inset:0; z-index:1050; display:none; align-items:center; justify-content:center; background:rgba(20,25,40,.35); }
  .tg-overlay.open { display:flex; }
  .tg-modal { width:560px; max-width:calc(100% - 32px); max-height:calc(100% - 60px); display:flex; flex-direction:column; background:#fff; border-radius:16px;
    box-shadow:0 20px 60px rgba(20,25,40,.25); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:#1F2430; }
  .tg-modal-head { display:flex; align-items:center; gap:10px; padding:14px 18px; border-bottom:1px solid #E6E8EC; }
  .tg-modal-head h3 { margin:0; font-size:15px; font-weight:700; flex:1; }
  .tg-modal-head .sub { display:block; font-size:12.5px; font-weight:400; color:#6B7280; }
  .tg-x { width:28px; height:28px; border:0; border-radius:8px; background:none; color:#9AA1AC; cursor:pointer; }
  .tg-x:hover { background:#F1F2F4; color:#1F2430; }
  .tg-modal-body { padding:16px 18px; overflow:auto; }
  .tg-modal-foot { display:flex; justify-content:flex-end; gap:8px; padding:10px 18px; border-top:1px solid #E6E8EC; background:#FAFBFC; border-radius:0 0 16px 16px; }
  .tg-text { width:100%; min-height:120px; padding:10px 12px; border:1px solid #E6E8EC; border-radius:9px; resize:vertical; font-size:14px; font-family:inherit; color:#1F2430; }
  .tg-text:focus { outline:none; border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .tg-btn { height:32px; padding:0 14px; border-radius:9px; border:1px solid #E6E8EC; background:#fff; color:#1F2430; font-size:13px; font-weight:600; font-family:inherit; cursor:pointer; }
  .tg-btn .fa { margin-right:6px; }
  .tg-btn.primary { background:#229ED9; border-color:#229ED9; color:#fff; }
  .tg-btn.primary:hover { background:#1C8DC3; }
  .tg-btn[disabled] { opacity:.6; cursor:default; }

  .tg-log-item { padding:10px 0; border-bottom:1px solid #F0F1F4; }
  .tg-log-item:last-child { border-bottom:0; }
  .tg-log-top { display:flex; align-items:center; gap:8px; font-size:12px; color:#6B7280; }
  .tg-log-kind { padding:1px 7px; border-radius:6px; background:#F1F2F4; color:#3C4250; font-weight:600; }
  .tg-log-kind.k-MANUAL { background:#E8F4FC; color:#1C6E99; }
  .tg-log-fail { color:#A50F22; font-weight:600; }
  .tg-log-text { margin-top:5px; font-size:13px; white-space:pre-wrap; color:#1F2430; }
</style>

<div class="tg-page fm-admin">
  <div class="tg-box">
    <div class="tg-toolbar">
      <div class="tg-title">
        <span class="ic"><i class="fa fa-paper-plane"></i></span>
        <div>
          <h2>Телеграм<c:if test="${not empty botName}"> · @${fn:escapeXml(botName)}</c:if></h2>
          <span class="tg-count">Подключено <b>${linkedCount}</b> из <b>${fn:length(rows)}</b> пользователей</span>
        </div>
      </div>
      <span class="tg-spacer"></span>
      <div class="tg-seg" id="tgSeg">
        <button type="button" data-f="Y" class="on" onclick="tgSeg(this)">Подключены</button>
        <button type="button" data-f="N" onclick="tgSeg(this)">Не подключены</button>
        <button type="button" data-f="" onclick="tgSeg(this)">Все</button>
      </div>
      <select class="tg-kind-sel" id="tgKind" onchange="tgKindMode()" title="Показать, кто получает выбранное уведомление">
        <option value="">Все уведомления</option>
        <c:forEach items="${kinds}" var="k"><option value="${k.key}">${k.value}</option></c:forEach>
      </select>
      <div class="tg-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="tg-search" id="tgSearch" placeholder="ФИО, логин, отделение" oninput="tgFilter()" autocomplete="off"/>
      </div>
    </div>

    <c:if test="${!tgEnabled}">
      <div class="tg-warn"><i class="fa fa-exclamation-triangle"></i> Бот не настроен: укажите токен в <b>telegram.properties</b> (bot.token), иначе уведомления не отправляются.</div>
    </c:if>
    <c:if test="${loadErr}">
      <div class="tg-warn">Не удалось загрузить данные, подробности в логе сервера.</div>
    </c:if>

    <div class="tg-table-wrap">
      <table class="tg-grid">
        <thead>
        <tr>
          <th style="width:40px;text-align:center">#</th>
          <th style="width:24%">Пользователь</th>
          <th style="width:14%">Отделение</th>
          <th style="width:15%">Telegram</th>
          <th>Уведомления</th>
          <th style="width:130px">Последнее</th>
          <th style="width:110px"></th>
        </tr>
        </thead>
        <tbody id="tgRows">
        <c:forEach items="${rows}" var="r">
          <tr data-l="${r.linked ? 'Y' : 'N'}" data-s="${fn:toLowerCase(fn:escapeXml(r.fio))} ${fn:toLowerCase(fn:escapeXml(r.login))} ${fn:toLowerCase(fn:escapeXml(r.dept))}"
              data-id="${r.id}" data-fio="${fn:escapeXml(r.fio)}">
            <td class="num"></td>
            <td><span class="fio">${fn:escapeXml(r.fio)}</span><span class="login">${fn:escapeXml(r.login)}</span></td>
            <c:choose>
              <c:when test="${not empty r.dept}"><td class="mut">${fn:escapeXml(r.dept)}</td></c:when>
              <c:otherwise><td class="none">—</td></c:otherwise>
            </c:choose>
            <td>
              <c:choose>
                <c:when test="${r.linked}">
                  <span class="tg-dot on"></span>${not empty r.phone ? fn:escapeXml(r.phone) : 'Подключён'}
                  <span class="tg-sub" style="margin-left:15px">с ${r.linkedDate}</span>
                </c:when>
                <c:otherwise><span class="tg-dot"></span><span class="mut" style="color:#9AA1AC">Не подключён</span></c:otherwise>
              </c:choose>
            </td>
            <td class="tg-ncell">
              <c:set var="anyKind" value="false"/>
              <c:forEach items="${r.kinds}" var="k"><c:if test="${k.applies}"><c:set var="anyKind" value="true"/></c:if></c:forEach>
              <c:choose>
                <c:when test="${anyKind}">
                  <button type="button" class="tg-sum" onclick="tgSettings(this)" title="Настроить уведомления"></button>
                  <div class="tg-offs"></div>
                  <div class="tg-kinds">
                    <c:forEach items="${r.kinds}" var="k">
                      <c:if test="${k.applies}">
                        <span class="tg-chip ${k.on ? 'on' : 'off'}" data-kind="${k.kind}" data-name="${fn:escapeXml(k.name)}" onclick="tgToggle(this)"
                              title="${k.on ? 'Получает. Нажмите, чтобы отключить' : 'Отключено. Нажмите, чтобы включить'}">
                          <i class="fa ${k.on ? 'fa-bell' : 'fa-bell-slash'}"></i>${k.name}
                        </span>
                      </c:if>
                    </c:forEach>
                  </div>
                </c:when>
                <c:otherwise><span style="color:#C3C7CE" title="По роли пользователю не положено ни одно уведомление">—</span></c:otherwise>
              </c:choose>
            </td>
            <c:choose>
              <c:when test="${not empty r.lastSent}"><td>${r.lastSent}<span class="tg-sub">всего ${r.sentCount}</span></td></c:when>
              <c:otherwise><td class="none">—</td></c:otherwise>
            </c:choose>
            <td style="text-align:right">
              <button type="button" class="tg-act" title="Написать" onclick="tgWrite(this)" <c:if test="${!r.linked}">disabled</c:if>><i class="fa fa-envelope-o"></i></button>
              <button type="button" class="tg-act" title="История уведомлений" onclick="tgLog(this)"><i class="fa fa-history"></i></button>
              <button type="button" class="tg-act danger" title="Отвязать Telegram" onclick="tgUnlinkUser(this)" <c:if test="${!r.linked}">disabled</c:if>><i class="fa fa-chain-broken"></i></button>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="tg-empty" id="tgEmpty" style="display:none"><i class="fa fa-paper-plane-o"></i>Нет пользователей</div>
    </div>
  </div>
</div>

<div class="tg-overlay" id="tgWriteWin" onclick="if(event.target == this) tgClose()">
  <div class="tg-modal">
    <div class="tg-modal-head">
      <h3>Сообщение в Telegram<span class="sub" id="tgWriteTo"></span></h3>
      <button type="button" class="tg-x" onclick="tgClose()"><i class="fa fa-times"></i></button>
    </div>
    <div class="tg-modal-body">
      <textarea class="tg-text" id="tgText" maxlength="3500" placeholder="Текст сообщения"></textarea>
    </div>
    <div class="tg-modal-foot">
      <button type="button" class="tg-btn" onclick="tgClose()">Отмена</button>
      <button type="button" class="tg-btn primary" id="tgSendBtn" onclick="tgSend()"><i class="fa fa-paper-plane"></i>Отправить</button>
    </div>
  </div>
</div>

<div class="tg-overlay" id="tgSetWin" onclick="if(event.target == this) tgClose()">
  <div class="tg-modal" style="width:460px">
    <div class="tg-modal-head">
      <h3>Уведомления<span class="sub" id="tgSetFor"></span></h3>
      <button type="button" class="tg-x" onclick="tgClose()"><i class="fa fa-times"></i></button>
    </div>
    <div class="tg-modal-body" id="tgSetBody" style="padding-top:6px; padding-bottom:6px"></div>
    <div class="tg-modal-foot">
      <span style="flex:1; color:#9AA1AC; font-size:12px; align-self:center">Показаны только уведомления, положенные по роли</span>
      <button type="button" class="tg-btn" onclick="tgClose()">Готово</button>
    </div>
  </div>
</div>

<div class="tg-overlay" id="tgLogWin" onclick="if(event.target == this) tgClose()">
  <div class="tg-modal" style="width:640px">
    <div class="tg-modal-head">
      <h3>История уведомлений<span class="sub" id="tgLogFor"></span></h3>
      <button type="button" class="tg-x" onclick="tgClose()"><i class="fa fa-times"></i></button>
    </div>
    <div class="tg-modal-body" id="tgLogBody"></div>
  </div>
</div>

<script>
  var tgCur = null;
  function tgSeg(btn){
    $('#tgSeg button').removeClass('on');
    $(btn).addClass('on');
    tgFilter();
  }
  function tgFilter(){
    var f = $('#tgSeg button.on').data('f') || '';
    var q = $.trim($('#tgSearch').val()).toLowerCase();
    var kind = $('#tgKind').val() || '';
    var n = 0;
    $('#tgRows tr').each(function(){
      var ok = (!f || $(this).data('l') == f) && (!q || String($(this).data('s')).indexOf(q) >= 0) && (!kind || $(this).find('.tg-chip[data-kind="' + kind + '"]').length > 0);
      $(this).toggle(ok);
      if(ok) $(this).find('td.num').text(++n);
    });
    $('#tgEmpty').toggle(n == 0);
  }
  function tgRow(el){ return $(el).closest('tr'); }
  function tgToggle(chip, done){
    var c = $(chip), on = c.hasClass('off');
    $.ajax({
      url: '/admin/tg/toggle.s', method: 'post', dataType: 'json',
      data: {user: tgRow(chip).data('id'), kind: c.data('kind'), on: on ? 'Y' : 'N'},
      success: function(res){
        if(!res.success) { FmsToast.show(res.msg, 'err'); return; }
        c.toggleClass('on', on).toggleClass('off', !on)
          .attr('title', on ? 'Получает. Нажмите, чтобы отключить' : 'Отключено. Нажмите, чтобы включить');
        c.find('.fa').toggleClass('fa-bell', on).toggleClass('fa-bell-slash', !on);
        tgSum(tgRow(chip));
      },
      complete: function(){ if (done) done(); }
    });
  }
  // сводка в строке: «4 из 4» или «3 из 4», отключённые типы метками под ней
  function tgSum(row){
    var chips = row.find('.tg-kinds .tg-chip'), on = chips.filter('.on').length, all = chips.length, offs = [];
    if (!all) return;
    chips.filter('.off').each(function(){ offs.push($(this).data('name')); });
    var b = row.find('.tg-sum').removeClass('part none').addClass(on == all ? '' : (on ? 'part' : 'none'));
    b.html('<i class="fa ' + (on ? 'fa-bell' : 'fa-bell-slash') + '"></i><span>' + (on == all ? 'Все ' + all : on + ' из ' + all) + '</span>' +
      '<span class="bar"><i style="width:' + Math.round(on * 100 / all) + '%"></i></span>');
    var box = row.find('.tg-offs').empty();
    offs.forEach(function (n) { box.append($('<span title="Отключено"><i class="fa fa-bell-slash"></i></span>').append(document.createTextNode(n))); });
    b.attr('title', 'Настроить уведомления' + (offs.length ? '\nОтключено: ' + offs.join(', ') : ''));
  }
  // окно настроек пользователя: переключатель на каждый тип
  function tgSettings(btn){
    tgCur = tgRow(btn);
    $('#tgSetFor').text(tgCur.data('fio'));
    var body = $('#tgSetBody').empty();
    tgCur.find('.tg-kinds .tg-chip').each(function(){
      var chip = this, row = $('<div class="tg-sw-row"><span class="nm"></span><span class="tg-sw"></span></div>');
      row.find('.nm').text($(chip).data('name'));
      row.toggleClass('on', $(chip).hasClass('on'));
      row.on('click', function(){
        row.addClass('busy');
        tgToggle(chip, function(){ row.removeClass('busy').toggleClass('on', $(chip).hasClass('on')); });
      });
      body.append(row);
    });
    $('#tgSetWin').addClass('open');
  }
  // режим «по типу»: в строках остаётся только переключатель выбранного уведомления
  function tgKindMode(){
    var kind = $('#tgKind').val();
    $('table.tg-grid').toggleClass('tg-kmode', !!kind);
    $('#tgRows .tg-chip').removeClass('cur');
    if (kind) $('#tgRows .tg-chip[data-kind="' + kind + '"]').addClass('cur');
    tgFilter();
  }
  function tgWrite(btn){
    tgCur = tgRow(btn);
    $('#tgWriteTo').text(tgCur.data('fio'));
    $('#tgText').val('');
    $('#tgWriteWin').addClass('open');
    $('#tgText').focus();
  }
  function tgSend(){
    var text = $.trim($('#tgText').val());
    if(!text) { $('#tgText').focus(); return; }
    $('#tgSendBtn').prop('disabled', true);
    $.ajax({
      url: '/admin/tg/send.s', method: 'post', dataType: 'json',
      data: {user: tgCur.data('id'), text: text},
      success: function(res){
        if(!res.success) { FmsToast.show(res.msg, 'err'); return; }
        tgClose();
        FmsToast.show('Сообщение отправлено', 'ok');
      },
      complete: function(){ $('#tgSendBtn').prop('disabled', false); }
    });
  }
  function tgLog(btn){
    tgCur = tgRow(btn);
    $('#tgLogFor').text(tgCur.data('fio'));
    var body = $('#tgLogBody').empty().append($('<div class="tg-empty" style="padding:30px"/>').text('Загрузка...'));
    $('#tgLogWin').addClass('open');
    $.ajax({
      url: '/admin/tg/log.s', method: 'post', dataType: 'json',
      data: {user: tgCur.data('id')},
      success: function(res){
        body.empty();
        if(!res.success) { body.append($('<div class="tg-empty" style="padding:30px"/>').text(res.msg)); return; }
        if(!res.rows.length) {
          body.append('<div class="tg-empty" style="padding:30px"><i class="fa fa-bell-slash-o"></i>Уведомлений ещё не было</div>');
          return;
        }
        $.each(res.rows, function(i, r){
          var top = $('<div class="tg-log-top"/>')
            .append($('<span/>').text(r.date))
            .append($('<span class="tg-log-kind"/>').addClass('k-' + r.kind).text(r.kindName));
          if(r.by) top.append($('<span/>').text(r.by));
          if(!r.ok) top.append('<span class="tg-log-fail"><i class="fa fa-exclamation-circle"></i> не доставлено</span>');
          body.append($('<div class="tg-log-item"/>').append(top).append($('<div class="tg-log-text"/>').text(r.text)));
        });
      }
    });
  }
  function tgUnlinkUser(btn){
    var row = tgRow(btn);
    FmsConfirm('Отвязать Telegram пользователя ' + row.data('fio') + '? Уведомления перестанут приходить.', function () {
    $.ajax({
      url: '/admin/tg/unlink.s', method: 'post', dataType: 'json',
      data: {user: row.data('id')},
      success: function(res){
        if(!res.success) { FmsToast.show(res.msg, 'err'); return; }
        setPage('/admin/tg/index.s');
      }
    });
  });
  }
  function tgClose(){ $('.tg-overlay').removeClass('open'); }
  $(document).off('keydown.tg').on('keydown.tg', function(e){ if(e.keyCode == 27) tgClose(); });
  $('#tgRows tr').each(function(){ tgSum($(this)); });
  tgFilter();
</script>
