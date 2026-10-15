<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<title><ui:message code="med"/></title>
<link rel="icon" type="image/png" href="/res/imgs/logo_fms_mini.png">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/js/common.js?v=2026101501"></script>
<%-- Процедурная (Users.procUser): оболочка в новом дизайне для планшета. Меню из одного пункта не показываем,
     страницы (палаты, палата) открываются во всю ширину. --%>
<style>
  html, body { height:100%; margin:0; background:#F5F6F8; font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:#1F2430; }
  .pr-top { position:sticky; top:0; z-index:100; display:flex; align-items:center; gap:10px; height:60px; padding:0 14px;
    background:#fff; border-bottom:1px solid #E6E8EC; }
  .pr-top .logo { display:flex; align-items:center; text-decoration:none; }
  .pr-top .logo img { height:24px; width:auto; }
  .pr-spacer { flex:1; }
  .pr-btn { display:inline-flex; align-items:center; gap:8px; height:44px; padding:0 14px; border-radius:12px; color:#3C4250;
    font-size:15px; font-weight:600; text-decoration:none !important; cursor:pointer; }
  .pr-btn:hover { background:#F0F1F4; color:#1F2430; }
  .pr-btn .fa { color:#6B7280; }
  .pr-btn .av { width:32px; height:32px; border-radius:50%; display:inline-flex; align-items:center; justify-content:center;
    background:#FDECEE; color:#A50F22; font-weight:700; font-size:14px; }
  .pr-btn.exit:hover { background:#FDECEE; color:#A50F22; }
  .pr-btn.exit:hover .fa { color:#A50F22; }
  #mainWindow { min-height:calc(100vh - 60px); }
  @media (max-width: 600px) { .pr-btn .lbl { display:none; } .pr-top .logo img { height:20px; } }
</style>
<script>
  function exit() {
    FmsConfirm('<ui:message code="confirmExit" />', function () { document.location = 'out.s'; });
  }
  function setPage(url) {
    $('#mainWindow').load(url);
  }
  function setChangePass() {
    setPage('/admin/changePass.s');
  }
  function openMainPage(url) {
    $('#mainWindow').load(url);
  }
  $(function () {
    openMainPage('${empty openPage ? "/proc/palatas.s" : openPage}');
  });
</script>
</head>
<body>
<div class="med-msg" style="display: none">
  <table style="width:100%">
    <tr>
      <td id="med-msg-text" style="overflow: hidden"></td>
      <td style="width:35px;border-left: 1px solid #ababab;cursor: pointer" onclick="closeMedMsg()">
        <div class="close-msg" title="Закрыть">X</div>
      </td>
    </tr>
  </table>
</div>
<div class="pr-top">
  <a class="logo" href="main.s"><img src="/res/imgs/logo_fms_h.png" alt="Farhod Madad Shifo"></a>
  <a class="pr-btn" href="#" onclick="setPage('/proc/palatas.s'); return false;" title="Палаты"><i class="fa fa-hospital-o"></i><span class="lbl">Палаты</span></a>
  <span class="pr-spacer"></span>
  <a class="pr-btn" href="#" onclick="setChangePass(); return false;" title="Сменить пароль">
    <span class="av">${fn:substring(sessionScope.ENV.userName, 0, 1)}</span><span class="lbl">${fn:escapeXml(sessionScope.ENV.userName)}</span>
  </a>
  <a class="pr-btn exit" href="#" onclick="exit(); return false;" title="<ui:message code="exit"/>"><i class="fa fa-sign-out"></i><span class="lbl"><ui:message code="exit"/></span></a>
</div>
<div id="mainWindow"></div>
</body>
</html>
