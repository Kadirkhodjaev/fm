<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<style>
  .pl-bar { display:inline-block; width:90px; height:6px; margin-right:8px; border-radius:3px; background:#EEF0F3; vertical-align:middle; overflow:hidden; }
  .pl-bar i { display:block; height:100%; border-radius:3px; background:#34A16B; }
  .pl-bar.full i { background:#D92D3C; }
  .pl-n { font-weight:600; }
  .pl-n.full { color:#C0182B; }
  .pl-off { color:#C0182B; font-weight:600; }
  .pl-open { display:inline-block; padding:0 7px; border-radius:6px; background:#E9F7EF; color:#1E7B43; font-size:11.5px; font-weight:600; line-height:18px; }
  .fm-btn.ok { color:#1E7B43; } .fm-btn.ok:hover { background:#E9F7EF; border-color:#BFE5CF; }
  table.fm-grid tr.st-first td { border-top:2px solid #E6E8EC; }
</style>

<c:set var="total" value="0"/><c:set var="full" value="0"/><c:set var="off" value="0"/>
<c:forEach items="${rooms}" var="r">
  <c:set var="total" value="${total + 1}"/>
  <c:if test="${r.state != 'A'}"><c:set var="off" value="${off + 1}"/></c:if>
  <c:if test="${r.state == 'A' && r.next_tr - r.limit >= 0}"><c:set var="full" value="${full + 1}"/></c:if>
</c:forEach>

<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-hospital-o"></i></span>
        <div>
          <h2>Палаты</h2>
          <span class="fm-count"><b>${total}</b> палат · заполнено <b>${full}</b><c:if test="${off > 0}"> · не работает <b>${off}</b></c:if></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="plSeg">
        <button type="button" data-f="" class="on" onclick="plSeg(this)">Все</button>
        <button type="button" data-f="full" onclick="plSeg(this)">Заполненные</button>
        <button type="button" data-f="free" onclick="plSeg(this)">Есть места</button>
      </div>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="plSearch" placeholder="Палата или этаж" oninput="plFilter()" autocomplete="off"/>
      </div>
    </div>

    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:80px" class="c">Этаж</th>
          <th>Палата</th>
          <th style="width:210px">Пациентов</th>
          <th style="width:260px" class="r">Доступ сверх лимита</th>
        </tr>
        </thead>
        <tbody id="plRows">
        <c:set var="prevStage" value=""/>
        <c:forEach items="${rooms}" var="room">
          <c:set var="isFull" value="${room.state == 'A' && room.next_tr - room.limit >= 0}"/>
          <tr class="${prevStage != '' && prevStage != room.stage ? 'st-first' : ''}"
              data-f="${room.state != 'A' ? 'off' : isFull ? 'full' : 'free'}"
              data-s="${fn:toLowerCase(fn:escapeXml(room.stage))} ${fn:toLowerCase(fn:escapeXml(room.num))} ${fn:toLowerCase(fn:escapeXml(room.type))}">
            <td class="c mut"><b>${room.stage}</b></td>
            <td><span class="nm">${room.num}</span> <span style="color:#6B7280">· ${room.type}</span></td>
            <c:choose>
              <c:when test="${room.state == 'A'}">
                <td>
                  <c:set var="pct" value="${room.limit > 0 ? room.next_tr * 100 / room.limit : 0}"/>
                  <span class="pl-bar ${isFull ? 'full' : ''}"><i style="width:${pct > 100 ? 100 : pct}%"></i></span>
                  <span class="pl-n ${isFull ? 'full' : ''}">${room.next_tr}</span><span style="color:#9AA1AC"> из ${room.limit}</span>
                </td>
                <td class="r">
                  <c:if test="${room.access == 'Y'}">
                    <span class="pl-open">доступ открыт</span>
                    <button type="button" class="fm-btn danger" style="margin-left:8px" onclick="getAccess(${room.id})"><i class="fa fa-times"></i>Убрать</button>
                  </c:if>
                  <c:if test="${room.next_tr - room.limit == 0 && room.access == 'N'}">
                    <button type="button" class="fm-btn ok" onclick="setAccess(${room.id})"><i class="fa fa-check"></i>Открыть доступ</button>
                  </c:if>
                </td>
              </c:when>
              <c:otherwise>
                <td colspan="2"><span class="pl-off"><i class="fa fa-ban"></i> Палата временно не функционирует</span></td>
              </c:otherwise>
            </c:choose>
          </tr>
          <c:set var="prevStage" value="${room.stage}"/>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="plEmpty" style="display:none"><i class="fa fa-hospital-o"></i>Палаты не найдены</div>
    </div>
  </div>
</div>
<script>
  function plSeg(btn) {
    $('#plSeg button').removeClass('on');
    $(btn).addClass('on');
    plFilter();
  }
  function plFilter() {
    var f = $('#plSeg button.on').data('f') || '';
    var q = $.trim($('#plSearch').val()).toLowerCase();
    var n = 0;
    $('#plRows tr').each(function () {
      var ok = (!f || $(this).data('f') == f) && (!q || String($(this).data('s')).indexOf(q) >= 0);
      $(this).toggle(ok);
      if (ok) n++;
    });
    $('#plEmpty').toggle(n == 0);
  }
  function plAccess(code, id, text) {
    FmsConfirm(text, function () {
    $.ajax({
      url: '/booking/palata.s', method: 'post', data: 'code=' + code + '&id=' + id, dataType: 'json',
      success: function (res) {
        if (res.success) setPage('/booking/palata.s');
        else openMedMsg(res.msg, false);
      }
    });
  });
  }
  function setAccess(id) { plAccess('set', id, 'Действительно открыть доступ сверх лимита?'); }
  function getAccess(id) { plAccess('get', id, 'Действительно убрать доступ?'); }
</script>
