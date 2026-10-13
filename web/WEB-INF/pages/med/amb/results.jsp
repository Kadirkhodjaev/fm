<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Амбулатория → услуга консультанта → «Результаты»: готовые результаты других услуг пациента (окно svOv в svc.jsp) --%>
<style>
  .ar-top { display:flex; align-items:center; gap:10px; margin-bottom:12px; }
  .ar-top .ar-n { color:#6B7280; font-size:13px; }
  .ar-top .sp { flex:1; }
  .ar-list { display:flex; flex-direction:column; gap:8px; max-height:65vh; overflow:auto; }
  .ar-item { border:1px solid #E6E8EC; border-radius:10px; padding:10px 14px; background:#fff; }
  .ar-item.lab { display:flex; align-items:baseline; gap:12px; padding:8px 14px; }
  .ar-h { display:flex; align-items:center; gap:10px; margin-bottom:4px; }
  .ar-item.lab .ar-h { margin:0; flex:1; }
  .ar-h b { font-size:14px; color:#1F2430; }
  .ar-h .d { font-size:12px; color:#9AA1AC; white-space:nowrap; }
  .ar-h .sp { flex:1; }
  .ar-t { font-size:13.5px; line-height:1.5; color:#3C4250; }
  .ar-item.lab .ar-t { font-weight:600; color:#1F2430; white-space:nowrap; }
  .ar-t i { font-style:normal; color:#6B7280; }
  .ar-t p { margin:0 0 2px; }
  .ar-cp { border:0; background:none; color:#9AA1AC; cursor:pointer; padding:2px 4px; border-radius:6px; }
  .ar-cp:hover { color:#1F2430; background:#F1F3F6; }
  .ar-empty { padding:30px; text-align:center; color:#9AA1AC; }
</style>
<c:choose>
  <c:when test="${empty list}">
    <div class="ar-empty">Готовых результатов у пациента пока нет</div>
  </c:when>
  <c:otherwise>
    <div class="ar-top">
      <span class="ar-n">Готовых услуг: ${list.size()}</span>
      <span class="sp"></span>
      <button type="button" class="fm-btn primary" onclick="arCopy()"><i class="fa fa-clipboard"></i>Скопировать всё</button>
    </div>
    <div class="ar-list" id="arList">
      <c:forEach items="${list}" var="r">
        <div class="ar-item ${r.lab ? 'lab' : ''}">
          <div class="ar-h">
            <b class="ar-name">${r.name}</b>
            <span class="d"><fmt:formatDate value="${r.date}" pattern="dd.MM.yyyy"/></span>
            <span class="sp"></span>
            <button type="button" class="ar-cp" title="Скопировать" onclick="arCopy(this)"><i class="fa fa-clipboard"></i></button>
          </div>
          <div class="ar-t">${r.text}</div>
        </div>
      </c:forEach>
    </div>
  </c:otherwise>
</c:choose>
<script>
  // текст для вставки в заключение: «Услуга: результат» по одной на строку
  function arLine(it) {
    var $t = $(it).find('.ar-t').clone();
    $t.find('div, p, br').after('\n');
    return $(it).find('.ar-name').text().trim() + ': ' + $.trim($t.text()).replace(/\n{2,}/g, '\n');
  }
  function arCopy(btn) {
    var items = btn ? [$(btn).closest('.ar-item')[0]] : $('#arList .ar-item').get();
    var txt = $.map(items, arLine).join('\n');
    navigator.clipboard.writeText(txt).then(function () {
      FmsToast.show('Текст скопирован', 'ok');
    });
  }
</script>
