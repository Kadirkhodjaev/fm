<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><ui:message code="med"/></title>
  <link rel="icon" type="image/png" href="/res/imgs/logo_fms_v.png">
  <%-- Bootstrap оставлен только ради стилей блока ошибок (errors.jsp) --%>
  <link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    :root {
      --text:   #1F2430;
      --muted:  #6B7280;
      --border: #E3E6EB;
      --bg:     #F4F5F7;
      --focus:  #4B5563;
      --radius: 10px;
    }
    * { box-sizing: border-box; }
    html, body { height: 100%; margin: 0; }
    body {
      font-family: 'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif;
      font-size: 15px;
      color: var(--text);
      background: var(--bg);
    }

    /* Одна карточка по центру, красный остаётся только в логотипе */
    .auth { min-height: 100vh; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 32px 16px; }
    .auth-card {
      width: 100%; max-width: 380px;
      background: #fff; border: 1px solid var(--border); border-radius: 16px;
      padding: 36px 32px 32px;
      box-shadow: 0 1px 2px rgba(20,25,40,.04), 0 8px 24px rgba(20,25,40,.05);
    }
    .auth-logo { display: block; height: 84px; margin: 0 auto 22px; }
    .auth-card h2 { font-size: 20px; font-weight: 600; margin: 0 0 4px; text-align: center; }
    .auth-card .sub { text-align: center; color: var(--muted); font-size: 14px; margin: 0 0 26px; }

    .field { margin-bottom: 16px; }
    .field label { display: block; font-size: 13px; font-weight: 500; color: var(--muted); margin-bottom: 6px; font-family: inherit; }
    .input-wrap { position: relative; }
    .auth-card input.form-control {
      display: block;
      width: 100%;
      height: 46px;
      padding: 0 14px;
      font-size: 15px;
      font-family: inherit;
      color: var(--text);
      background: #fff;
      border: 1px solid var(--border);
      border-radius: var(--radius);
      box-shadow: none;
      transition: border-color .15s, box-shadow .15s;
    }
    .auth-card input#password { padding-right: 46px; }
    .auth-card input.form-control:focus {
      outline: none;
      border-color: var(--focus);
      box-shadow: 0 0 0 3px rgba(75,85,99,.12);
    }
    .toggle-pass {
      position: absolute; right: 6px; top: 50%; transform: translateY(-50%);
      width: 34px; height: 34px; border: 0; background: transparent; border-radius: 8px;
      cursor: pointer; display: flex; align-items: center; justify-content: center;
    }
    .toggle-pass:hover { background: #F0F1F4; }
    .toggle-pass svg { width: 18px; height: 18px; stroke: #9AA1AC; fill: none; stroke-width: 1.8; }

    .btn-main {
      width: 100%;
      height: 46px;
      margin-top: 8px;
      border: 0;
      border-radius: var(--radius);
      background: var(--text);
      color: #fff;
      font-size: 15px;
      font-weight: 600;
      font-family: inherit;
      cursor: pointer;
      transition: background .15s;
    }
    .btn-main:hover  { background: #000; }
    .btn-main:disabled { opacity: .6; cursor: default; }

    .auth-card .alert { border-radius: var(--radius); font-size: 14px; }
    .auth-foot { text-align: center; color: #A0A6B0; font-size: 12px; margin-top: 20px; }

    @media (max-width: 480px) {
      .auth-card { padding: 28px 20px 24px; border-radius: 14px; }
    }
  </style>
</head>
<body>

<main class="auth">
  <div class="auth-card">
    <img class="auth-logo" src="/res/imgs/logo_fms_v.png" alt="Farhod Madad Shifo">

    <h2>Вход в MedOnline</h2>
    <p class="sub"><ui:message code="auth"/></p>

    <f:form role="form" method="POST" action="/login.s" commandName="loginForm" name="bufferForm" id="loginForm">
      <%@include file="/incs/msgs/errors.jsp"%>

      <div class="field">
        <label for="login">${login}</label>
        <div class="input-wrap">
          <f:input path="login" id="login" type="text" cssClass="form-control" placeholder="${login}"
                   value="" autofocus="true" autocomplete="username"/>
        </div>
      </div>

      <div class="field">
        <label for="password">${password}</label>
        <div class="input-wrap">
          <f:input path="password" id="password" type="password" cssClass="form-control" placeholder="${password}"
                   value="" autocomplete="current-password"/>
          <button type="button" class="toggle-pass" id="togglePass" aria-label="Показать пароль">
            <svg viewBox="0 0 24 24"><path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/></svg>
          </button>
        </div>
      </div>

      <div id="idleNote" style="display:none; margin:0 0 12px; padding:10px 12px; border-radius:10px; background:#FFF4D6; color:#8A5A00; font-size:13px; line-height:1.4">Сеанс завершён: 15 минут без действий. Войдите снова.</div>
      <button type="submit" class="btn-main" id="submitBtn"><ui:message code="enter"/></button>
    </f:form>
  </div>
  <div class="auth-foot">&copy; <span id="year"></span> Farhod Madad Shifo klinikasi</div>
</main>

<script>
  (function () {
    document.getElementById('year').textContent = new Date().getFullYear();

    // после автовыхода по бездействию (common.js FmsIdle) показываем причину
    try {
      var idleOut = parseInt(localStorage.getItem('fmsIdleOut'), 10) || 0;
      if (idleOut && Date.now() - idleOut < 10 * 60 * 1000) document.getElementById('idleNote').style.display = 'block';
      localStorage.removeItem('fmsIdleOut');
    } catch (e) {}

    var pass = document.getElementById('password');
    document.getElementById('togglePass').addEventListener('click', function () {
      pass.type = pass.type === 'password' ? 'text' : 'password';
      pass.focus();
    });

    // Защита от двойного нажатия
    document.getElementById('loginForm').addEventListener('submit', function () {
      document.getElementById('submitBtn').disabled = true;
    });

    <c:if test="${debug}">
    document.getElementById('login').value = 'admin';
    pass.value = '1';
    </c:if>
  })();
</script>
</body>
</html>
