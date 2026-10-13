<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  .cp-page { --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    min-height:100%; box-sizing:border-box; padding:24px 14px; background:var(--bg);
    font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:var(--text); }
  .cp-page * { box-sizing:border-box; }
  .cp-wrap { max-width:560px; margin:0 auto; display:flex; flex-direction:column; gap:14px; }
  .cp-box { background:#fff; border:1px solid var(--border); border-radius:16px; overflow:hidden;
    box-shadow:0 1px 2px rgba(20,25,40,.04), 0 8px 24px rgba(20,25,40,.06); }

  .cp-head { display:flex; align-items:center; gap:12px; padding:14px 18px; border-bottom:1px solid var(--border); }
  .cp-head .ic { width:30px; height:30px; border-radius:9px; display:flex; align-items:center; justify-content:center;
    background:#EEF1F6; color:#3C4A63; font-size:14px; flex:none; }
  .cp-head .ic.tg { background:#E8F4FC; color:#229ED9; }
  .cp-head h2 { margin:0; font-size:16px; font-weight:700; line-height:1.2; }
  .cp-head .sub { display:block; font-size:12.5px; color:var(--muted); }

  .cp-body { padding:16px 18px; display:flex; flex-direction:column; gap:12px; }
  .cp-field label { display:block; margin:0 0 5px; font-size:12px; font-weight:600; color:var(--muted); }
  .cp-input-wrap { position:relative; }
  .cp-input { width:100%; height:36px; padding:0 38px 0 12px; border:1px solid var(--border); border-radius:9px; background:#fff;
    font-size:14px; font-family:inherit; color:var(--text); }
  .cp-input:focus { outline:none; border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .cp-input.err { border-color:#D93848; box-shadow:0 0 0 3px rgba(217,56,72,.12); }
  .cp-eye { position:absolute; right:6px; top:5px; width:26px; height:26px; border:0; background:none; color:#9AA1AC; cursor:pointer; border-radius:6px; }
  .cp-eye:hover { color:var(--text); background:#F1F2F4; }
  .cp-msg { display:none; padding:8px 12px; border-radius:9px; font-size:13px; }
  .cp-msg.bad { display:block; background:#FDECEE; color:#A50F22; }
  .cp-msg.ok { display:block; background:#E9F7EF; color:#1E7B43; }

  .cp-foot { display:flex; justify-content:flex-end; gap:8px; padding:10px 18px; border-top:1px solid var(--border); background:#FAFBFC; }
  .cp-btn { height:32px; padding:0 14px; border-radius:9px; border:1px solid var(--border); background:#fff; color:var(--text);
    font-size:13px; font-weight:600; font-family:inherit; cursor:pointer; }
  .cp-btn:hover { background:#F5F6F8; }
  .cp-btn .fa { margin-right:6px; }
  .cp-btn.primary { background:#1F2430; border-color:#1F2430; color:#fff; }
  .cp-btn.primary:hover { background:#353B4A; }
  .cp-btn.tg { background:#229ED9; border-color:#229ED9; color:#fff; }
  .cp-btn.tg:hover { background:#1C8DC3; }
  .cp-btn[disabled] { opacity:.6; cursor:default; }

  .cp-state { display:flex; align-items:center; gap:10px; font-size:13.5px; }
  .cp-dot { width:9px; height:9px; border-radius:50%; background:#C3C7CE; flex:none; }
  .cp-dot.on { background:#22A55B; box-shadow:0 0 0 3px rgba(34,165,91,.15); }
  .cp-note { font-size:12.5px; color:var(--muted); line-height:1.5; }
  .cp-note b { color:var(--text); }
</style>

<div class="cp-page">
  <div class="cp-wrap">

    <form class="cp-box" id="changeForm" onsubmit="cpSave(); return false;" autocomplete="off">
      <div class="cp-head">
        <span class="ic"><i class="fa fa-lock"></i></span>
        <div>
          <h2>Смена пароля</h2>
          <span class="sub">${fn:escapeXml(u.fio)} · ${fn:escapeXml(u.login)}</span>
        </div>
      </div>
      <div class="cp-body">
        <div class="cp-field">
          <label for="currPass">Текущий пароль</label>
          <div class="cp-input-wrap">
            <input type="password" name="currPass" id="currPass" class="cp-input" maxlength="16"/>
            <button type="button" class="cp-eye" tabindex="-1" onclick="cpEye(this)" title="Показать"><i class="fa fa-eye"></i></button>
          </div>
        </div>
        <div class="cp-field">
          <label for="newPass">Новый пароль</label>
          <div class="cp-input-wrap">
            <input type="password" name="newPass" id="newPass" class="cp-input" maxlength="16"/>
            <button type="button" class="cp-eye" tabindex="-1" onclick="cpEye(this)" title="Показать"><i class="fa fa-eye"></i></button>
          </div>
        </div>
        <div class="cp-field">
          <label for="confPass">Повторите новый пароль</label>
          <div class="cp-input-wrap">
            <input type="password" name="confPass" id="confPass" class="cp-input" maxlength="16"/>
            <button type="button" class="cp-eye" tabindex="-1" onclick="cpEye(this)" title="Показать"><i class="fa fa-eye"></i></button>
          </div>
        </div>
        <div class="cp-msg" id="cpMsg"></div>
      </div>
      <div class="cp-foot">
        <button type="button" class="cp-btn" onclick="document.location = 'main.s'"><i class="fa fa-arrow-left"></i>Назад</button>
        <button type="submit" class="cp-btn primary" id="cpSaveBtn"><i class="fa fa-floppy-o"></i>Сохранить</button>
      </div>
    </form>

    <c:if test="${tgEnabled}">
    <div class="cp-box">
      <div class="cp-head">
        <span class="ic tg"><i class="fa fa-paper-plane"></i></span>
        <div>
          <h2>Уведомления в Telegram</h2>
          <span class="sub">Новый пациент, повторный больничный и др.</span>
        </div>
      </div>
      <div class="cp-body">
        <c:choose>
          <c:when test="${tgLinked}">
            <div class="cp-state"><span class="cp-dot on"></span>
              <span>Telegram подключён<c:if test="${not empty tgPhone}">, номер <b>${fn:escapeXml(tgPhone)}</b></c:if></span></div>
          </c:when>
          <c:otherwise>
            <div class="cp-state"><span class="cp-dot"></span><span>Telegram не подключён</span></div>
            <div class="cp-note" id="tgHint" style="display:none">
              В открывшемся Telegram нажмите <b>Start</b> (Запустить) и поделитесь номером, затем обновите эту страницу.
            </div>
          </c:otherwise>
        </c:choose>
      </div>
      <div class="cp-foot">
        <c:choose>
          <c:when test="${tgLinked}">
            <button type="button" class="cp-btn" onclick="tgUnlink()"><i class="fa fa-times"></i>Отключить</button>
          </c:when>
          <c:otherwise>
            <button type="button" class="cp-btn tg" onclick="tgLink()"><i class="fa fa-paper-plane"></i>Подключить Telegram</button>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
    </c:if>

  </div>
</div>

<script>
  function cpEye(btn){
    var inp = $(btn).siblings('input');
    var show = inp.attr('type') == 'password';
    inp.attr('type', show ? 'text' : 'password');
    $(btn).find('.fa').toggleClass('fa-eye', !show).toggleClass('fa-eye-slash', show);
  }
  function cpMsg(text, ok){
    $('#cpMsg').attr('class', 'cp-msg ' + (ok ? 'ok' : 'bad')).text(text);
  }
  function cpSave(){
    var a = $('#currPass'), b = $('#newPass'), c = $('#confPass');
    $('.cp-input').removeClass('err');
    var empty = [a, b, c].filter(function(x){ return x.val() == ''; });
    if(empty.length) {
      empty.forEach(function(x){ x.addClass('err'); });
      cpMsg('Заполните все поля');
      return;
    }
    if(b.val() != c.val()) {
      b.addClass('err'); c.addClass('err');
      cpMsg('Новый пароль и подтверждение не совпадают');
      return;
    }
    $('#cpSaveBtn').prop('disabled', true);
    $.ajax({
      url: '/admin/changePass.s',
      method: 'post',
      data: $('#changeForm').serialize(),
      dataType: 'json',
      success: function (res) {
        if(res.success) {
          $('#changeForm').trigger('reset');
          cpMsg('Пароль изменён', true);
        } else if(res.msg == 'WRONG_PASS') {
          a.addClass('err').focus();
          cpMsg('Текущий пароль указан неверно');
        } else {
          cpMsg(res.msg || 'Не удалось сохранить');
        }
      },
      complete: function(){ $('#cpSaveBtn').prop('disabled', false); }
    });
  }
  function tgLink(){
    // окно открываем сразу по клику, иначе браузер заблокирует его как всплывающее
    var w = window.open('', '_blank');
    $.ajax({
      url: '/admin/tgLink.s',
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if(!res.success) { if(w) w.close(); errMsg(res.msg); return; }
        if(w) w.location = res.url; else document.location = res.url;
        $('#tgHint').show();
      }
    });
  }
  function tgUnlink(){
    FmsConfirm('Отключить уведомления в Telegram?', function () {
    $.ajax({
      url: '/admin/tgUnlink.s',
      method: 'post',
      dataType: 'json',
      success: function (res) {
        if(!res.success) { errMsg(res.msg); return; }
        setPage('/admin/changePass.s');
      }
    });
  });
  }
  $('#currPass').focus();
</script>
