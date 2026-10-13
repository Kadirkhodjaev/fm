<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<style>
  body { margin:0; background:#F5F6F8; font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:#1F2430; }
  .tp-wrap { max-width:760px; margin:16px auto; padding:0 14px; display:flex; flex-direction:column; gap:12px; }
  .tp-card { background:#fff; border:1px solid #E6E8EC; border-radius:16px; box-shadow:0 1px 2px rgba(20,25,40,.04), 0 8px 24px rgba(20,25,40,.06); }
  .tp-head { display:flex; align-items:center; gap:12px; padding:14px 18px; border-bottom:1px solid #E6E8EC; }
  .tp-head .ic { width:32px; height:32px; border-radius:9px; display:flex; align-items:center; justify-content:center; background:#E8F4FC; color:#229ED9; }
  .tp-head h2 { margin:0; font-size:16px; font-weight:700; }
  .tp-head .sub { display:block; font-size:12.5px; color:#6B7280; }
  .tp-body { display:flex; gap:22px; padding:18px; align-items:flex-start; flex-wrap:wrap; }
  .tp-qr { width:220px; height:220px; flex:none; border:1px solid #E6E8EC; border-radius:12px; display:flex; align-items:center; justify-content:center; background:#fff; }
  .tp-qr img { width:200px; height:200px; }
  .tp-text { flex:1; min-width:240px; font-size:14px; line-height:1.55; }
  .tp-text ol { margin:6px 0 0; padding-left:20px; }
  .tp-link { margin-top:10px; padding:8px 10px; border-radius:9px; background:#F5F6F8; font-family:Consolas, monospace; font-size:12px; word-break:break-all; }
  .tp-state { display:flex; align-items:center; gap:10px; padding:12px 18px; border-top:1px solid #E6E8EC; font-size:13.5px; }
  .dot { width:9px; height:9px; border-radius:50%; background:#C3C7CE; }
  .dot.on { background:#22A55B; box-shadow:0 0 0 3px rgba(34,165,91,.15); }
  .tp-foot { display:flex; gap:8px; padding:10px 18px; border-top:1px solid #E6E8EC; background:#FAFBFC; border-radius:0 0 16px 16px; }
  .tp-btn { height:32px; padding:0 14px; border-radius:9px; border:1px solid #E6E8EC; background:#fff; color:#1F2430; font-size:13px; font-weight:600; font-family:inherit; cursor:pointer; }
  .tp-btn.primary { background:#229ED9; border-color:#229ED9; color:#fff; }
  .tp-btn .fa { margin-right:6px; }
  .tp-muted { color:#6B7280; font-size:13px; }
  @media print {
    body { background:#fff; }
    .tp-card { box-shadow:none; border:0; }
    .no-print { display:none !important; }
  }
</style>
</head>
<body>
<div class="tp-wrap">
  <c:choose>
    <c:when test="${!enabled}">
      <div class="tp-card" style="padding:18px">Бот для пациентов не настроен: укажите <b>patient.bot.token</b> в telegram.properties.</div>
    </c:when>
    <c:when test="${not empty err}">
      <div class="tp-card" style="padding:18px; color:#A50F22">Ошибка: ${fn:escapeXml(err)}</div>
    </c:when>
    <c:otherwise>
      <div class="tp-card">
        <div class="tp-head">
          <span class="ic"><i class="fa fa-paper-plane"></i></span>
          <div>
            <h2>${fn:escapeXml(pat.surname)} ${fn:escapeXml(pat.name)} ${fn:escapeXml(pat.middlename)}</h2>
            <span class="sub">Telegram-помощник пациента<c:if test="${not empty pat.yearNum}"> · ИБ № ${pat.yearNum}</c:if></span>
          </div>
        </div>
        <div class="tp-body">
          <div class="tp-qr">
            <%-- QR генерирует сам fm (CApp /qrcode_png.s) --%>
            <img src="/qrcode_png.s?size=400&url=${linkEnc}" alt="QR"
                 onerror="this.style.display='none'; document.getElementById('tpQrErr').style.display='';"/>
            <span id="tpQrErr" class="tp-muted" style="display:none; padding:14px; text-align:center">QR-код не загрузился. Пациент может открыть ссылку справа.</span>
          </div>
          <div class="tp-text">
            <b>Как подключиться</b>
            <ol>
              <li>Наведите камеру телефона на QR-код и откройте Telegram.</li>
              <li>Нажмите «Start» («Запустить»).</li>
              <li>Нажмите «Отправить мой номер». Номер должен совпадать с номером в карточке: <b>${empty pat.tel ? 'не указан' : fn:escapeXml(pat.tel)}</b>.</li>
            </ol>
            <c:if test="${fn:length(pat.tel) < 9}">
              <div class="no-print" style="margin-top:8px; padding:8px 10px; border-radius:9px; background:#FFF6E5; color:#8A5A00; font-size:13px">
                <i class="fa fa-exclamation-triangle"></i> Номер в карточке неполный, поэтому бот не сможет его сверить и подключит любой номер. Лучше исправить телефон в регистрации.
              </div>
            </c:if>
            <div style="margin-top:8px">В боте: назначения на день, напоминания о приёме таблеток, процедуры, обследования и вопрос лечащему врачу.</div>
            <div class="tp-link">${fn:escapeXml(link)}</div>
          </div>
        </div>
        <div class="tp-state no-print">
          <c:choose>
            <c:when test="${st.linked == 'Y'}"><span class="dot on"></span><span>Пациент подключён<c:if test="${not empty st.phone}">, номер ${fn:escapeXml(st.phone)}</c:if><c:if test="${not empty st.linkedDate}">, с ${st.linkedDate}</c:if>.</span></c:when>
            <c:otherwise><span class="dot"></span><span>Пациент ещё не подключился.</span></c:otherwise>
          </c:choose>
        </div>
        <div class="tp-foot no-print">
          <button type="button" class="tp-btn" onclick="location.reload()"><i class="fa fa-refresh"></i>Обновить статус</button>
          <span style="flex:1"></span>
          <button type="button" class="tp-btn" onclick="FmsConfirm('Выдать новый код? Старый QR перестанет работать, подключение пациента будет сброшено.', function () { location.href='/lv/tg.s?reset=Y${modal ? '&id=' : ''}${modal ? pat.id : ''}'; })" title="Если QR потерян или попал к посторонним"><i class="fa fa-ban"></i>Новый код</button>
        </div>
      </div>
    </c:otherwise>
  </c:choose>
</div>
<script>
  function tpInvite() {
    FmsConfirm('Отправить пациенту ссылку на бота с номера клиники в Telegram?', function () {
    var b = $('#tpInvite').prop('disabled', true);
    $.ajax({
      url: '/lv/tg/invite.s', method: 'post', dataType: 'json',
      success: function (res) { alert(res.msg || (res.success ? 'Отправлено' : 'Не удалось отправить')); },
      error: function () { alert('Не удалось отправить'); },
      complete: function () { b.prop('disabled', false); }
    });
  });
  }
</script>
</body>
</html>
