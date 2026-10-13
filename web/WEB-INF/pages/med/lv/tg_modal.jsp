<%@ page pageEncoding="UTF-8" %>
<%-- Окно "Telegram пациента" на 80% экрана (палаты постовой и карточка пациента). Подключается через include.
     openTgModal(id) открывает /lv/tg.s?id=<пациент> во фрейме. --%>
<style>
  .tgm-overlay { position:fixed; inset:0; z-index:2000; display:none; align-items:center; justify-content:center; background:rgba(20,25,40,.45); }
  .tgm-overlay.open { display:flex; }
  .tgm-box { position:relative; width:80vw; height:80vh; background:#F5F6F8; border-radius:18px; overflow:hidden; box-shadow:0 24px 70px rgba(20,25,40,.3); }
  .tgm-box iframe { width:100%; height:100%; border:0; display:block; }
  .tgm-close { position:absolute; top:10px; right:12px; z-index:2; width:44px; height:44px; border:0; border-radius:12px;
    background:#fff; color:#1F2430; font-size:20px; cursor:pointer; box-shadow:0 2px 8px rgba(20,25,40,.15); }
  @media (max-width: 900px) { .tgm-box { width:94vw; height:88vh; } }
</style>
<div class="tgm-overlay" id="tgmOverlay" onclick="if (event.target == this) closeTgModal()">
  <div class="tgm-box">
    <button type="button" class="tgm-close" onclick="closeTgModal()" title="Закрыть"><i class="fa fa-times"></i></button>
    <iframe id="tgmFrame" src="about:blank"></iframe>
  </div>
</div>
<script>
  function openTgModal(id) {
    openTgUrl('/lv/tg.s?id=' + id);
  }
  function openTgUrl(url) {
    document.getElementById('tgmFrame').src = url;
    document.getElementById('tgmOverlay').className = 'tgm-overlay open';
  }
  function closeTgModal() {
    document.getElementById('tgmOverlay').className = 'tgm-overlay';
    document.getElementById('tgmFrame').src = 'about:blank';
  }
</script>
