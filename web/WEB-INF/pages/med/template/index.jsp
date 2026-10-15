<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Шаблоны текста врача (отдельное окно): клик по шаблону вставляет его в поле формы и закрывает окно --%>
<html>
<head>
  <meta charset="UTF-8">
  <title>Шаблоны</title>
  <script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
  <script src="/res/js/common.js?v=2026101501"></script>
  <link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    html, body { margin:0; background:#F5F6F8; font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:#1F2430; font-size:14px; }
    .bar { position:sticky; top:0; z-index:5; display:flex; align-items:center; gap:10px; padding:10px 16px; background:#fff; border-bottom:1px solid #E6E8EC; }
    .bar h1 { margin:0; font-size:16px; font-weight:700; }
    .bar .cnt { color:#6B7280; font-size:13px; }
    .bar .sp { flex:1; }
    .bar input { width:260px; height:34px; padding:0 10px; border:1px solid #E6E8EC; border-radius:9px; font:inherit; outline:none; }
    .bar input:focus { border-color:#4B5563; }
    .btn { display:inline-flex; align-items:center; gap:7px; height:34px; padding:0 14px; border:1px solid #E6E8EC; border-radius:9px; background:#fff; color:#1F2430; font:600 13px inherit; font-family:inherit; cursor:pointer; }
    .btn:hover { background:#F5F6F8; }
    .list { max-width:1100px; margin:14px auto; padding:0 14px; display:flex; flex-direction:column; gap:10px; }
    .tpl { background:#fff; border:1px solid #E6E8EC; border-radius:14px; overflow:hidden; }
    .tpl-h { display:flex; align-items:center; gap:8px; padding:9px 14px; border-bottom:1px solid #F0F1F4; font-weight:700; }
    .tpl-h span { flex:1; }
    .tpl-h button { width:30px; height:30px; border:0; border-radius:8px; background:none; color:#9AA1AC; cursor:pointer; }
    .tpl-h button:hover { background:#FDECEE; color:#A50F22; }
    .lv-template { padding:10px 14px; cursor:pointer; line-height:1.5; }
    .lv-template:hover { background:#EEF4FF; }
    .empty { padding:40px; text-align:center; color:#9AA1AC; }
  </style>
</head>
<body>
<div class="bar">
  <h1>Шаблоны</h1>
  <span class="cnt">${fn:length(templates)} · нажмите на текст, чтобы вставить</span>
  <span class="sp"></span>
  <input type="text" id="tpSearch" placeholder="Поиск" oninput="tpFilter()" autocomplete="off">
  <button type="button" class="btn" onclick="window.close()"><i class="fa fa-times"></i>Закрыть</button>
</div>
<div class="list" id="results">
  <c:forEach items="${templates}" var="r">
    <div class="tpl">
      <div class="tpl-h"><span>${r.name}</span><button type="button" title="Удалить шаблон" onclick="removeTemplate(${r.id})"><i class="fa fa-trash-o"></i></button></div>
      <div onclick="setTemp(this)" title="Вставить в поле и закрыть" class="lv-template">${r.template}</div>
    </div>
  </c:forEach>
  <c:if test="${empty templates}"><div class="empty">Шаблонов нет</div></c:if>
</div>
<script>
  function tpFilter() {
    var q = $.trim($('#tpSearch').val()).toLowerCase();
    $('#results .tpl').each(function () { $(this).toggle(!q || $(this).text().toLowerCase().indexOf(q) >= 0); });
  }
  function setTemp(dom) {
    <c:if test="${!isKdo}">
    opener.setText(dom, '${id}');
    self.close();
    return;
    </c:if>
    if (opener.setEditorHtml) opener.setEditorHtml('${id}', dom.innerHTML);
    else opener.nicEditors.findEditor('${id}').setContent(dom.innerHTML);
    self.close();
  }
  function removeTemplate(id) {
    FmsPrompt('Удалить шаблон? Введите код подтверждения:', function (msg) {
      $.ajax({
        url: '/templates/delete.s', method: 'post', data: 'id=' + id + '&pas=' + encodeURIComponent(msg), dataType: 'json',
        success: function (res) {
          FmsToast.show(res.msg || (res.success ? 'Шаблон удалён' : 'Не удалось удалить'), res.success ? 'ok' : 'err');
          if (res.success) setTimeout(function () { self.close(); }, 800);
        }
      });
    }, {input: 'Код подтверждения', ok: 'Удалить', danger: true});
  }
  $('#tpSearch').focus();
</script>
</body>
</html>
