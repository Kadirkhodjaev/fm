<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Амбулаторные услуги → Сотрудники → карточка сотрудника: реквизиты (только просмотр) и его визиты; «Регистрация» — новый визит для обследования --%>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<style>
  .ed-wrap { display:grid; grid-template-columns:minmax(0, 420px) minmax(0, 1fr); gap:14px; padding:14px; background:#F7F8FA; align-items:start; min-height:100%; }
  .ed-card { background:#fff; border:1px solid #E6E8EC; border-radius:14px; overflow:hidden; }
  .ed-h { display:flex; align-items:center; gap:8px; padding:12px 16px; border-bottom:1px solid #F0F1F4; font-size:12px; font-weight:700; color:#6B7280; text-transform:uppercase; letter-spacing:.4px; }
  .ed-info { padding:14px 16px; display:grid; grid-template-columns:1fr 1fr; gap:12px 16px; font-size:13.5px; }
  .ed-info .w { grid-column:1 / -1; }
  .ed-info .l { display:block; font-size:11px; font-weight:600; color:#9AA1AC; text-transform:uppercase; letter-spacing:.3px; margin-bottom:2px; }
  .ed-st { display:inline-flex; align-items:center; gap:6px; padding:2px 10px; border-radius:999px; font-size:12px; font-weight:600; background:#F1F2F4; color:#4B5563; }
  .ed-st.work { background:#FEF6D6; color:#8A6100; }
  .ed-st.done { background:#E3F6EC; color:#1E7A4C; }
  #edRows tr { cursor:pointer; }
  @media (max-width: 1000px) { .ed-wrap { grid-template-columns:1fr; } }
</style>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-id-card"></i></span>
        <div>
          <h2>${fn:escapeXml(emp.client.fio)}</h2>
          <span class="fm-count">сотрудник<c:if test="${not empty emp.text}"> · ${fn:escapeXml(emp.text)}</c:if></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <button type="button" class="fm-btn primary" onclick="regEmpAmb()"><i class="fa fa-check"></i>Регистрация на обследование</button>
      <button type="button" class="fm-btn" onclick="setPage('/emp/doctor/emps.s')"><i class="fa fa-arrow-left"></i>Назад</button>
    </div>
    <div class="fm-table-wrap" style="padding:0">
      <div class="ed-wrap">
        <div class="ed-card">
          <div class="ed-h"><i class="fa fa-user"></i> Реквизиты</div>
          <div class="ed-info">
            <div class="w"><span class="l">ФИО</span><b>${fn:escapeXml(emp.client.fio)}</b></div>
            <div><span class="l">Дата рождения</span><fmt:formatDate pattern="dd.MM.yyyy" value="${emp.client.birthdate}"/></div>
            <div><span class="l">Пол</span>${emp.client.sex.name}</div>
            <div><span class="l">Телефон</span>${empty emp.client.tel ? '—' : fn:escapeXml(emp.client.tel)}</div>
            <div><span class="l">Паспорт</span>${fn:escapeXml(emp.client.docSeria)} ${fn:escapeXml(emp.client.docNum)}</div>
            <div><span class="l">Резидентство</span>${emp.client.country.name}</div>
            <div><span class="l">Область</span>${emp.client.region.name}</div>
            <c:if test="${not empty emp.client.address}"><div class="w"><span class="l">Адрес</span>${fn:escapeXml(emp.client.address)}</div></c:if>
            <c:if test="${not empty emp.text}"><div class="w"><span class="l">Описание</span>${fn:escapeXml(emp.text)}</div></c:if>
          </div>
        </div>
        <div class="ed-card">
          <div class="ed-h"><i class="fa fa-stethoscope"></i> Визиты <span style="font-weight:400; text-transform:none; letter-spacing:0">· ${fn:length(rows)}</span></div>
          <c:if test="${empty rows}"><div class="fm-empty" style="display:block; padding:30px"><i class="fa fa-stethoscope"></i>Визитов ещё не было</div></c:if>
          <c:if test="${not empty rows}">
            <table class="fm-grid">
              <thead><tr><th style="width:50px">№</th><th>Дата и время регистрации</th><th style="width:200px">Состояние</th></tr></thead>
              <tbody id="edRows">
              <c:forEach items="${rows}" var="a" varStatus="loop">
                <tr onclick="setPage('/amb/reg.s?id=${a.id}')" title="Открыть визит">
                  <td class="mut">${loop.index + 1}</td>
                  <td><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${a.crOn}"/></td>
                  <td>
                    <c:choose>
                      <c:when test="${a.state == 'PRN'}"><span class="ed-st">Регистрация</span></c:when>
                      <c:when test="${a.state == 'CASH'}"><span class="ed-st work">Ожидание оплаты</span></c:when>
                      <c:when test="${a.state == 'WORK'}"><span class="ed-st work">Оказание услуг</span></c:when>
                      <c:when test="${a.state == 'DONE'}"><span class="ed-st done">Услуги оказаны</span></c:when>
                      <c:when test="${a.state == 'ARCH'}"><span class="ed-st">Закрыт</span></c:when>
                      <c:otherwise><span class="ed-st">${a.state}</span></c:otherwise>
                    </c:choose>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </c:if>
        </div>
      </div>
    </div>
  </div>
</div>
<script>
  function regEmpAmb() {
    FmsConfirm('Зарегистрировать сотрудника на обследование? Будет создан новый амбулаторный визит.', function () {
      $.ajax({
        url: '/emp/doctor/emp/reg.s', method: 'post', data: 'id=${emp.id}', dataType: 'json',
        success: function (res) {
          if (!res.success) { FmsToast.show(res.msg || 'Не удалось зарегистрировать', 'err'); return; }
          setPage('/amb/reg.s?id=' + res.id);
        }
      });
    }, null, {ok: 'Зарегистрировать'});
  }
</script>
