<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Карточка пациента (просмотр) → Консультация: консультации других врачей и «Мои консультации» консультанта.
     Сохранение кнопкой карточки (#saveBtn → /lv/cls.s); у архивного пациента только просмотр --%>
<%@include file="/WEB-INF/pages/med/lv/frame_style.jsp"%>
<style>
  .cv-item { border:1px solid #E6E8EC; border-radius:12px; padding:12px 16px; margin-top:12px; }
  .cv-h { display:flex; align-items:center; gap:10px; font-size:13.5px; }
  .cv-h b { color:#1F2430; }
  .cv-h .d { color:#9AA1AC; font-size:12.5px; }
  .cv-h .sp { flex:1; }
  .cv-t { margin-top:8px; font-size:14px; line-height:1.5; color:#3C4250; }
  .cv-t .rq { margin-top:6px; }
  .cv-t .rq i { font-style:normal; color:#6B7280; }
  .cv-sec { margin:22px 0 4px; font-size:12px; font-weight:700; color:#6B7280; text-transform:uppercase; letter-spacing:.4px; }
  .cv-cm { margin-top:8px; padding:8px 12px; background:#F8F9FA; border-radius:8px; font-size:13px; }
  .cv-cm i { font-style:normal; color:#6B7280; }
  .cv-ta { width:100%; min-height:150px; padding:10px 12px; border:1px solid #E6E8EC; border-radius:10px; font-family:inherit; font-size:14px; line-height:1.5;
    box-sizing:border-box; resize:vertical; }
  .cv-ta:focus { outline:none; border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .cv-ta[readonly] { background:#F8F9FA; }
  .cv-ib { width:30px; height:30px; border:1px solid #E6E8EC; border-radius:8px; background:#fff; color:#4B5563; cursor:pointer; }
  .cv-ib:hover { background:#F5F6F8; }
  .cv-ib.danger:hover { color:#A50F22; border-color:#F3C3CA; }
</style>
<form id="clsForm" action="/lv/cls.s" method="post">
<div class="ld-sheet" style="max-width:960px">
  <div class="ld-title">
    <i class="fa fa-comments" style="color:#9AA1AC"></i> Консультация
    <span class="sub">${pat.surname} ${pat.name} ${pat.middlename}<c:if test="${not empty pat.birthyear}"> · ${pat.birthyear} г.р.</c:if></span>
    <span class="sp"></span>
    <c:if test="${arch}"><span class="ld-tag" title="Пациент в архиве"><i class="fa fa-lock"></i>только просмотр</span></c:if>
  </div>
  <div class="ld-body">
    <c:if test="${empty consuls && !consulFlag}"><div class="ld-empty">Консультаций пока нет</div></c:if>
    <c:forEach items="${consuls}" var="c">
      <div class="cv-item">
        <div class="cv-h"><b>${c.lvName}</b><span class="d">${c.date}</span></div>
        <c:if test="${not empty c.text}">
          <div class="cv-t">${c.text}<c:if test="${not empty c.req}"><div class="rq"><i>Рекомендация:</i> ${c.req}</div></c:if></div>
        </c:if>
        <c:if test="${empty c.text}"><div class="cv-t" style="color:#9AA1AC">Консультация ещё не проведена</div></c:if>
      </div>
    </c:forEach>

    <c:if test="${consulFlag}">
      <div class="cv-sec">Мои консультации</div>
      <c:forEach items="${cls}" var="d">
        <input type="hidden" name="id" value="${d.id}"/>
        <div class="cv-item">
          <div class="cv-h">
            <b>${d.lvName}</b><span class="d">${d.date}</span>
            <span class="sp"></span>
            <c:if test="${not empty d.text}">
              <button type="button" class="cv-ib" title="Печать" onclick="window.open('/lv/print.s?consul=${d.id}')"><i class="fa fa-print"></i></button>
              <c:if test="${!arch}">
                <button type="button" class="cv-ib" title="Создать новую на основе этой" onclick="document.location = '?copy=Y&id=${d.id}'"><i class="fa fa-copy"></i></button>
                <c:if test="${d.copied == 'Y'}">
                  <button type="button" class="cv-ib danger" title="Удалить" onclick="cvDel(${d.id})"><i class="fa fa-trash-o"></i></button>
                </c:if>
              </c:if>
            </c:if>
          </div>
          <c:if test="${not empty d.comment}"><div class="cv-cm"><i>Комментарий лечащего врача:</i> ${d.comment}</div></c:if>
          <div class="ld-l">Консультация</div>
          <textarea class="cv-ta" name="comment" maxlength="10000" <c:if test="${arch}">readonly</c:if>>${d.text}</textarea>
          <div class="ld-l">Рекомендация</div>
          <textarea class="cv-ta" name="reqs" maxlength="10000" <c:if test="${arch}">readonly</c:if>>${d.req}</textarea>
        </div>
      </c:forEach>
    </c:if>
  </div>
</div>
<c:if test="${consulFlag && !arch}"><button type="submit" id="saveBtn" style="display:none"></button></c:if>
</form>
<script>
  function cvDel(id) { FmsConfirm('Удалить консультацию?', function () { document.location = '?del=Y&id=' + id; }, null, {ok: 'Удалить', danger: true}); }
  $(function () {
    // кнопка «Сохранить» карточки нужна только консультанту с неархивным пациентом
    try { parent.document.getElementById('saveForm').style.display = ${consulFlag && !arch} ? 'inline' : 'none'; } catch (e) {}
    if (/msgState=1/.test(location.search)) FmsToast.show('Сохранено', 'ok');
  });
</script>
