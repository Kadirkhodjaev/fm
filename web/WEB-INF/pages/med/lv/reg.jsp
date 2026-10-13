<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Карточка пациента → Регистрация: три вкладки (регистрационные, основные, дополнительные данные); содержимое — /reg/nurse/view.s и /reg/doctor/view.s --%>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">
<style>
  html, body { background:#F7F8FA !important; }
  .rg { max-width:1100px; margin:14px auto 30px; background:#fff; border:1px solid #E6E8EC; border-radius:14px; font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .rg-tabs { display:flex; gap:4px; padding:0 14px; border-bottom:1px solid #E6E8EC; }
  .rg-tabs button { height:46px; padding:0 14px; border:0; border-bottom:2px solid transparent; margin-bottom:-1px; background:none; color:#6B7280; font-family:inherit;
    font-size:14px; font-weight:600; cursor:pointer; }
  .rg-tabs button:hover { color:#1F2430; }
  .rg-tabs button.on { color:#A50F22; border-bottom-color:#D7182E; }
  .rg-body { padding:14px; }
  .rg-pane { display:none; }
  .rg-pane.on { display:block; }
  .rg-load { padding:30px; text-align:center; color:#9AA1AC; }
</style>
<div class="rg">
  <div class="rg-tabs">
    <button type="button" class="on" data-p="home" data-url="/reg/nurse/view.s">Регистрационные данные</button>
    <button type="button" data-p="profile1" data-url="/reg/doctor/view.s?page=1">Основные данные</button>
    <button type="button" data-p="profile2" data-url="/reg/doctor/view.s?page=2">Дополнительные данные</button>
  </div>
  <div class="rg-body">
    <div class="rg-pane on" id="home"></div>
    <div class="rg-pane" id="profile1"></div>
    <div class="rg-pane" id="profile2"></div>
  </div>
</div>
<script>
  // вкладка грузится при каждом открытии (как раньше)
  function rgOpen(b) {
    $(b).addClass('on').siblings().removeClass('on');
    var p = $('#' + $(b).attr('data-p'));
    $('.rg-pane').removeClass('on');
    p.addClass('on').html('<div class="rg-load">Загрузка…</div>').load($(b).attr('data-url'));
  }
  // прежние имена (на случай вызова из вложенных страниц)
  function nursePage() { rgOpen($('.rg-tabs button')[0]); }
  function docPage(id) { rgOpen($('.rg-tabs button')[id]); }
  $('.rg-tabs button').on('click', function () { rgOpen(this); });
  $(function () { rgOpen($('.rg-tabs button').first()); });
</script>
