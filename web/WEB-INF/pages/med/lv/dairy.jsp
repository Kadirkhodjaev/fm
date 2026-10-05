<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/res/quill/quill.snow.css" rel="stylesheet">
<script src="/res/quill/quill.js" type="text/javascript"></script>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/res/js/common.js" type="text/javascript"></script>
<script src="/res/js/fms-calendar.js" type="text/javascript"></script>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<style>
  .dr { --brand:#D7182E; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    max-width:1000px; margin:0 auto; padding:16px 20px 28px; color:var(--text); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .dr * { box-sizing:border-box; }
  .dr-title { display:flex; align-items:baseline; gap:14px; flex-wrap:wrap; margin-bottom:12px; }
  .dr-title h2 { margin:0; font-size:19px; font-weight:700; }
  .dr-title .who { color:var(--muted); font-size:13.5px; }
  .dr-item { background:#fff; border:1px solid var(--border); border-radius:14px; margin-bottom:12px; overflow:hidden; }
  .dr-item-h { display:flex; align-items:center; gap:10px; flex-wrap:wrap; padding:10px 16px; background:#FAFBFC; border-bottom:1px solid var(--border); }
  .dr-date { font-weight:700; font-size:15px; }
  .dr-chip { display:inline-block; padding:2px 10px; border-radius:10px; background:#F1F2F4; color:#374151; font-size:12.5px; font-weight:600; white-space:nowrap; }
  .dr-chip i { color:#9AA1AC; margin-right:4px; }
  .dr-tools { margin-left:auto; display:flex; align-items:center; gap:4px; }
  .dr-tools input[type=checkbox] { margin:0 8px 0 0; }
  .dr-tools .hand { cursor:pointer; color:#9AA1AC; padding:5px 6px; border-radius:8px; top:0; }
  .dr-tools .hand:hover { background:#FDECEE; color:var(--brand); }
  .dr-item-b { padding:12px 16px; word-break:break-word; line-height:1.5; }
  .dr-item-b p { margin:0 0 4px; }
  .dr-form { background:#fff; border:2px solid var(--border); border-radius:14px; padding:16px 18px 18px; margin-top:18px; }
  .dr-form h3 { margin:0 0 14px; font-size:16px; font-weight:700; text-align:center; }
  .dr-fields { display:flex; gap:14px; flex-wrap:wrap; align-items:flex-end; margin-bottom:12px; }
  .dr-fields label { display:block; font-size:12px; font-weight:600; color:var(--muted); margin-bottom:5px; }
  .dr-fields .form-control { height:38px; }
  .dr-bp { display:flex; align-items:center; gap:6px; }
  .osm-editor .ql-editor { min-height:170px; max-height:420px; overflow-y:auto; font-size:14px; }
  .osm-editor.ql-container { border-bottom-left-radius:6px; border-bottom-right-radius:6px; }
  .ql-toolbar.ql-snow { border-top-left-radius:6px; border-top-right-radius:6px; }
  .dr-empty { padding:18px; text-align:center; color:var(--muted); border:1px dashed var(--border); border-radius:14px; }
</style>
<script type="text/javascript">
  window.quills = window.quills || {};
  $(function () {
    var ta = document.getElementById('text');
    if (ta) {
      var host = $('<div class="osm-editor"></div>').insertAfter(ta)[0];
      var q = new Quill(host, {
        theme: 'snow',
        modules: {
          toolbar: [['bold', 'italic', 'underline', 'strike'], [{list: 'ordered'}, {list: 'bullet'}], [{script: 'sub'}, {script: 'super'}], ['clean']]
        }
      });
      if (ta.value && ta.value.trim() !== '')
        q.setContents(q.clipboard.convert({html: ta.value}), 'silent');
      window.quills[ta.id] = q;
      // the form is submitted by the "Save" button of the page header: put the editor html back into the textarea
      $(ta).closest('form').on('submit', function () {
        $(ta).val(getEditorHtml('text'));
      });
    }
  });
  function setDairy(id){
    setLocation('?dairyId=' + id + '#newDairy');
  }
  function copyDairy(id){
    setLocation('?copy=Y&dairyId=' + id + '#newDairy');
  }
  function printDairy(id) {
    window.open('/lv/print.s?dairyId=' + id);
  }
</script>
<f:form commandName="dairy" method="post">
  <f:hidden path="id"/>
  <div class="dr">
    <div class="dr-title">
      <h2>Дневник</h2>
      <span class="who"><b>${fio}</b> &nbsp;·&nbsp; Год рождения: ${birthyear}</span>
    </div>
    <%@include file="/incs/msgs/successError.jsp"%>
    <%@include file="/incs/msgs/errors.jsp"%>

    <c:if test="${empty dairies}">
      <div class="dr-empty">Записей в дневнике пока нет</div>
    </c:if>
    <c:forEach items="${dairies}" var="d">
      <div class="dr-item">
        <div class="dr-item-h">
          <span class="dr-date">${d.c2}</span>
          <c:if test="${not empty d.c3}"><span class="dr-chip"><i class="fa fa-heart"></i>Пульс ${d.c3} уд/мин</span></c:if>
          <c:if test="${not empty d.c6 or not empty d.c7}"><span class="dr-chip"><i class="fa fa-tachometer"></i>Давление ${d.c6} / ${d.c7}</span></c:if>
          <span class="dr-tools">
            <input type="checkbox" name="dairy" dairy="${d.c1}" title="Выбор несколько записи для печати" />
            <b title='Печать' onclick="printDairy('${d.c1}')" class="hand glyphicon glyphicon-print"></b>
            <b title='Редактировать' onclick="setDairy(${d.c1})" class="hand glyphicon glyphicon-edit"></b>
            <b title='Создать новый дневник на основании текущего' onclick="copyDairy(${d.c1})" class="hand glyphicon glyphicon-copy"></b>
          </span>
        </div>
        <div class="dr-item-b">${d.c5}</div>
      </div>
    </c:forEach>

    <div class="dr-form" id="newDairy">
      <h3><%=request.getParameter("dairyId") == null || request.getParameter("copy") != null ? "Новый дневник" : "Редактирование дневника"%></h3>
      <div class="dr-fields">
        <div>
          <label for="act_Date">Дата</label>
          <input name="act_Date" id="act_Date" value="${act_Date}" class="form-control fms-cal" autocomplete="off" type="text" style="width:150px"/>
        </div>
        <div>
          <label for="puls">Пульс (уд/мин)</label>
          <f:input path="puls" style="width:110px" class="form-control" type="number"/>
        </div>
        <div>
          <label for="dav1">Давление</label>
          <span class="dr-bp">
            <f:input path="dav1" style="width:80px" class="form-control" type="number" maxlength="3"/>
            <span>/</span>
            <f:input path="dav2" style="width:80px" class="form-control" type="number" maxlength="3"/>
          </span>
        </div>
      </div>
      <f:textarea path="text" style="display:none" rows="8" maxlength="10000"/>
    </div>
    <div class="panel-footer" style="display: none">
      <button id=saveBtn class="hidden">Сохранить</button>
    </div>
  </div>
</f:form>
