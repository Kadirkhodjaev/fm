<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/res/js/common.js" type="text/javascript"></script>
<script src="/res/js/fms-calendar.js" type="text/javascript"></script>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<style>
  .cn { --brand:#D7182E; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    max-width:1000px; margin:0 auto; padding:16px 20px 28px; color:var(--text); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .cn * { box-sizing:border-box; }
  .cn-title { display:flex; align-items:baseline; gap:14px; flex-wrap:wrap; margin-bottom:12px; }
  .cn-title h2 { margin:0; font-size:19px; font-weight:700; }
  .cn-title .who { color:var(--muted); font-size:13.5px; }
  .cn-item { background:#fff; border:1px solid var(--border); border-radius:14px; margin-bottom:12px; overflow:hidden; }
  .cn-item-h { display:flex; align-items:center; gap:10px; flex-wrap:wrap; padding:10px 16px; background:#FAFBFC; border-bottom:1px solid var(--border); }
  .cn-doc { font-weight:700; font-size:15px; }
  .cn-doc a { color:var(--text); text-decoration:underline; text-decoration-color:#C3C7CE; }
  .cn-date { color:var(--muted); font-size:13px; }
  .cn-badge { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; font-weight:600; background:#FEF3C7; color:#B45309; }
  .cn-badge.done { background:#E8F7EE; color:#15803D; }
  .cn-badge.out { background:#EEF0F3; color:#4B5563; }
  .cn-del { margin-left:auto; }
  .cn-del button { border:0; background:none; color:#B0B6BF; padding:4px 8px; border-radius:8px; cursor:pointer; }
  .cn-del button:hover { background:#FDECEE; color:var(--brand); }
  .cn-item-b { padding:12px 16px; }
  .cn-row { display:flex; gap:8px; margin-bottom:6px; font-size:14px; }
  .cn-row .l { flex:none; width:170px; font-weight:600; color:var(--muted); font-size:13px; }
  .cn-result { margin-top:8px; padding:10px 12px; border:1px solid var(--border); border-radius:10px; background:#FCFCFD; word-break:break-word; line-height:1.5; }
  .cn-result .l { font-size:12px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px; margin-bottom:4px; }
  .cn-form { background:#fff; border:2px solid var(--border); border-radius:14px; padding:16px 18px 18px; margin-top:18px; }
  .cn-form h3 { margin:0 0 14px; font-size:16px; font-weight:700; text-align:center; }
  .cn-sw { display:flex; align-items:center; gap:10px; margin-bottom:14px; padding:10px 12px; border-radius:10px; background:#F8F9FA; }
  .cn-sw input { margin:0; width:18px; height:18px; }
  .cn-sw label { margin:0; font-weight:600; cursor:pointer; }
  .cn-fields { display:flex; gap:14px; flex-wrap:wrap; align-items:flex-end; margin-bottom:12px; }
  .cn-fields label.t { display:block; font-size:12px; font-weight:600; color:var(--muted); margin-bottom:5px; }
  .cn-fields .form-control { height:38px; }
  .cn-form textarea { width:100%; }
</style>
<script>
  function setInnerConsul(dom){
    if(dom.checked) {
      document.getElementById('consulText').style.display = 'none';
      document.getElementById('lvId').style.display = 'inline';
      document.getElementById('lvName').style.display = 'none';
    } else {
      document.getElementById('lvId').style.display = 'none';
      document.getElementById('lvName').style.display = 'inline';
      document.getElementById('consulText').style.display = 'block';
    }
  }
  function delConsul(id){
    if(confirm('Вы действительно хотите удалить запись?'))
      setLocation('/lv/consul.s?del=Y&id=' + id);
  }
  function setRow(id) {
    setLocation('/lv/consul.s?edit=Y&id=' + id);
  }
</script>
<form action="/lv/consul.s" method="post">
  <input type="hidden" name="id" value="${id}"/>
  <div class="cn">
    <div class="cn-title">
      <h2>Консультация</h2>
      <span class="who"><b>${patient.surname}&nbsp;${patient.name}&nbsp;${patient.middlename}</b> &nbsp;·&nbsp; Год рождения: ${patient.birthyear}</span>
    </div>
    <%@include file="/incs/msgs/successError.jsp"%>

    <c:forEach items="${consuls}" var="c">
      <div class="cn-item">
        <div class="cn-item-h">
          <span class="cn-doc">
            <c:if test="${c.state == 'OUT'}"><a href="#" onclick="setRow('${c.id}'); return false;" title="Редактировать">${c.lvName}</a></c:if>
            <c:if test="${c.state != 'OUT'}">${c.lvName}</c:if>
          </span>
          <span class="cn-date"><i class="fa fa-calendar-o"></i> ${c.date}</span>
          <c:choose>
            <c:when test="${c.state == 'DONE'}"><span class="cn-badge done">Выполнена</span></c:when>
            <c:when test="${c.state == 'OUT'}"><span class="cn-badge out">Внешний врач</span></c:when>
            <c:otherwise><span class="cn-badge">Ожидает</span></c:otherwise>
          </c:choose>
          <c:if test="${c.state != 'DONE'}">
            <span class="cn-del">
              <button type="button" onclick="delConsul('${c.id}')" title="Удалить консультацию"><i class="fa fa-trash-o"></i></button>
            </span>
          </c:if>
        </div>
        <div class="cn-item-b">
          <c:if test="${not empty c.comment}">
            <div class="cn-row"><span class="l">Комментарий врача</span><span>${c.comment}</span></div>
          </c:if>
          <div class="cn-row">
            <span class="l">Создана</span><span><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${c.crOn}"/></span>
          </div>
          <div class="cn-row">
            <span class="l">Результат</span><span><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${c.saveDate}"/></span>
          </div>
          <c:if test="${c.state == 'DONE'}">
            <div class="cn-result">
              <div class="l">Консультация</div>
              ${c.text}; ${c.req}
            </div>
          </c:if>
        </div>
      </div>
    </c:forEach>

    <div class="cn-form">
      <h3>Новая консультация</h3>
      <div class="cn-sw">
        <input value="Y" type="checkbox" id="innerDoc" name="innerDoc" onclick="setInnerConsul(this)"/>
        <label for="innerDoc">Консультация врача клиники ${shortClinicName}</label>
      </div>
      <div class="cn-fields">
        <div>
          <label class="t" for="lvName">Врач</label>
          <input type="text" style="width:300px; display: inline;" class="form-control" name="lvName" id="lvName" value="${lvName}"/>
          <select class="form-control" style="width:300px; display: none;" id='lvId' name='lvId'>
            <c:forEach items="${lvs}" var="d">
              <option value="${d.id}" <c:if test="${d.id == epic.lvId}">selected</c:if>>${d.profil} - ${d.fio}</option>
            </c:forEach>
          </select>
        </div>
        <div>
          <label class="t" for="conDate">Дата</label>
          <input type="text" id="conDate" name="conDate" class="form-control fms-cal" autocomplete="off" style="width:150px" value="${conDate}"/>
        </div>
        <div style="flex:1; min-width:240px">
          <label class="t" for="commentInp">Комментарий</label>
          <div id="comment"><input class="form-control" id="commentInp" name="comment" maxlength="500" value="${comment}"></div>
        </div>
      </div>
      <div id="consulText">
        <label class="t" style="display:block; font-size:12px; font-weight:600; color:#6B7280; margin-bottom:5px">Заключение консультанта</label>
        <textarea class="form-control" name="conText" rows="8" maxlength="10000">${conText}</textarea>
      </div>
    </div>
    <div class="panel-footer" style="display: none">
      <button id=saveBtn type="submit" class="hidden">Сохранить</button>
    </div>
  </div>
</form>
