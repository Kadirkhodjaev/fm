<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- КДО → шаблон заключения обследования --%>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-file-text-o"></i></span>
        <div>
          <h2>${kdo.name}</h2>
          <span class="fm-count">шаблон заключения · <span id="ktLen">0</span> / 10000 знаков</span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <button type="button" class="fm-btn primary" id="ktSaveBtn" onclick="save()"><i class="fa fa-floppy-o"></i>Сохранить</button>
      <button type="button" class="fm-btn" onclick="openMainPage('/templates/index.s', true)"><i class="fa fa-arrow-left"></i>Назад</button>
    </div>
    <div class="fm-table-wrap" style="padding:12px; background:#F7F8FA">
      <form id="tempForm" method="post" action="/templates/edit.s" onsubmit="save(); return false" style="max-width:1000px; margin:0 auto">
        <input type="hidden" name="id" value="${kdo.id}"/>
        <label class="fm-l">Заключение</label>
        <textarea class="fm-in" name="template" id="ktText" rows="24" maxlength="10000" style="height:auto; font-family:inherit; line-height:1.5">${fn:escapeXml(kdo.template)}</textarea>
      </form>
    </div>
  </div>
</div>
<script>
  function ktCount() { $('#ktLen').text($('#ktText').val().length); }
  $('#ktText').on('input', ktCount);
  ktCount();
  function save() {
    $('#ktSaveBtn').prop('disabled', true);
    $.ajax({
      url: $('#tempForm').attr('action'), data: $('#tempForm').serialize(), method: 'post',
      success: function () { FmsToast.show('Шаблон сохранён', 'ok'); openMainPage('/templates/index.s', true); },
      error: function () { $('#ktSaveBtn').prop('disabled', false); }
    });
  }
</script>
