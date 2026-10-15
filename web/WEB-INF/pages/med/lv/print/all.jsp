<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Вся история болезни одной страницей: печатные версии разделов подряд, оглавление слева; печать — каждый раздел с новой страницы --%>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<style>
  /* tables from the text editor (Quill: td[data-row]) - cell borders on print */ td[data-row] { border:1px solid #888 !important; padding:3px 6px !important; vertical-align:top; } table:has(td[data-row]) { border-collapse:collapse; max-width:100%; }
  html, body { margin:0; }
  body.fms-all { background:#E9EBEE; }
  .ah-wrap { display:flex; gap:16px; align-items:flex-start; padding:16px; font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .ah-toc { position:sticky; top:16px; flex:none; width:220px; background:#fff; border:1px solid #E6E8EC; border-radius:14px; padding:8px; }
  .ah-toc .h { padding:6px 10px 8px; font-size:12px; font-weight:600; color:#9AA1AC; text-transform:uppercase; letter-spacing:.4px; }
  .ah-toc a { display:flex; align-items:center; gap:8px; padding:7px 10px; border-radius:8px; color:#1F2430; font-size:13.5px; text-decoration:none; }
  .ah-toc a:hover { background:#F1F2F4; }
  .ah-toc a .st { margin-left:auto; width:8px; height:8px; border-radius:50%; background:#D5D8DE; }
  .ah-toc a.ok .st { background:#22A55B; }
  .ah-toc a.err .st { background:#D92D3C; }
  .ah-list { flex:1; min-width:0; display:flex; flex-direction:column; gap:16px; }
  .ah-sheet { background:#fff; border-radius:4px; box-shadow:0 1px 3px rgba(20,25,40,.12), 0 8px 24px rgba(20,25,40,.06); padding:28px 32px; max-width:860px; width:100%; margin:0 auto; box-sizing:border-box; }
  .ah-sheet .ah-load { color:#9AA1AC; text-align:center; padding:30px 0; font-family:'Inter', Arial, sans-serif; }
  @media print {
    body.fms-all { background:#fff; }
    .ah-wrap { display:block; padding:0; }
    .ah-toc { display:none; }
    .ah-sheet { box-shadow:none; border-radius:0; padding:0; max-width:none; page-break-before:always; }
    .ah-sheet:first-child { page-break-before:auto; }
  }
</style>
<div class="ah-wrap">
  <nav class="ah-toc" id="ahToc">
    <div class="h">${pat.surname} ${pat.name}</div>
  </nav>
  <div class="ah-list" id="ahList"></div>
</div>
<script>
  (function () {
    document.body.className += ' fms-all';
    var sections = [
      ['Осмотр врача', '/view/osm.s'],
      ['Назначение', '${withDrug ? '/view/drug/index.s' : '/view/drugs.s'}'],
      ['Обследования', '/view/plan/index.s'],
      ['Консультации', '/view/consul.s'],
      ['Дневник', '/view/dairy.s'],
      ['Обоснование', '/view/obos.s'],
      ['Переводной эпикриз', '/view/epic.s'],
      ['Выписка', '/view/vypiska.s'],
      ['Дополнительные данные', '/view/extra.s']
    ];
    var toc = $('#ahToc'), list = $('#ahList');
    $.each(sections, function (i, s) {
      var id = 'ahSec' + i;
      var a = $('<a href="#"></a>').attr('data-to', id).append($('<span></span>').text(s[0])).append('<span class="st"></span>');
      a.on('click', function () { var el = document.getElementById(id); if (el) el.scrollIntoView({behavior: 'smooth', block: 'start'}); return false; });
      toc.append(a);
      var sheet = $('<section class="ah-sheet"></section>').attr('id', id).append('<div class="ah-load">Загрузка: ' + $('<i></i>').text(s[0]).html() + '…</div>');
      list.append(sheet);
      $.ajax({
        url: s[1], data: {print: 'Y', all: 'Y'}, dataType: 'html',
        success: function (html) { sheet.html(html); a.addClass('ok'); },
        error: function () { sheet.find('.ah-load').text('Не удалось загрузить раздел «' + s[0] + '»'); a.addClass('err'); }
      });
    });
  })();
</script>
