<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<style>
  .tp-list { font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .tp-row { display:flex; align-items:center; gap:12px; padding:10px 16px; border-bottom:1px solid #F0F1F4; }
  .tp-row:last-child { border-bottom:0; }
  .tp-row:hover { background:#FAFBFC; }
  .tp-main { flex:1; min-width:0; cursor:pointer; }
  .tp-name { font-weight:600; font-size:14px; line-height:1.35; word-break:break-word; }
  .tp-name .pl { color:#B0B5BD; font-weight:400; margin:0 4px; }
  .tp-meta { margin-top:3px; font-size:12.5px; color:#6B7280; }
  .tp-meta .dot { margin:0 5px; color:#C3C7CE; }
  .tp-meta i { color:#9AA1AC; }
  .tp-btns { flex:none; display:flex; align-items:center; gap:4px; }
  .tp-use { height:30px; padding:0 12px; border-radius:8px; border:1.5px solid #E6E8EC; background:#fff; color:#1F2430; font-size:12.5px; font-weight:600; cursor:pointer; }
  .tp-use:hover { background:#FDECEE; border-color:#D7182E; color:#D7182E; }
  .tp-del { width:30px; height:30px; border:0; border-radius:8px; background:transparent; color:#B0B5BD; cursor:pointer; }
  .tp-del:hover { background:#FDECEE; color:#D7182E; }
  .tp-empty { padding:28px 16px; text-align:center; color:#9AA1AC; font-size:13.5px; }
</style>
<div class="tp-list" id="user-drug-temps">
  <c:if test="${empty rows}">
    <div class="tp-empty">Шаблонов нет</div>
  </c:if>
  <c:forEach items="${rows}" var="d" varStatus="lp">
    <div class="tp-row" id="drug-row-temp-${d.id}">
      <div class="tp-main" ondblclick="setLocation('drugs.s?temp=${d.id}')" title="Двойной клик — применить шаблон">
        <div class="tp-name">
          <c:forEach items="${d.rows}" var="row" varStatus="loop">${row.name}<c:if test="${loop.index + 1 < fn:length(d.rows)}"><span class="pl">+</span></c:if></c:forEach>
        </div>
        <div class="tp-meta">
          ${d.drugType.name}<c:if test="${d.drugType.id == 8}"> - ${d.injectionType.name}</c:if>
          <c:if test="${not empty d.goal.name}"><span class="dot">·</span><i class="fa fa-bullseye"></i> ${d.goal.name}</c:if>
          <c:if test="${not empty d.note}"><span class="dot">·</span>${d.note}</c:if>
        </div>
      </div>
      <div class="tp-btns">
        <button type="button" class="tp-use" onclick="setLocation('drugs.s?temp=${d.id}')">Применить</button>
        <button type="button" class="tp-del" title="Удалить шаблон" onclick="removeDrugTemp(${d.id})"><i class="fa fa-trash-o"></i></button>
      </div>
    </div>
  </c:forEach>
</div>
