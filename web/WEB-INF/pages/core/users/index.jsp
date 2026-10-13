<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/pages/core/skin.jsp"%>
<style>
  table.fm-grid tbody tr { cursor:pointer; }
  .us-yes { display:inline-block; padding:0 7px; border-radius:6px; background:#E9F7EF; color:#1E7B43; font-size:11.5px; font-weight:600; line-height:18px; }
  .us-no { color:#C3C7CE; }
  .us-off td { color:#9AA1AC; }
  .us-off .nm { color:#9AA1AC; }
</style>
<c:set var="cntA" value="0"/>
<c:forEach items="${users}" var="u"><c:if test="${u.active}"><c:set var="cntA" value="${cntA + 1}"/></c:if></c:forEach>

<div id="usRolesBox"></div>

<div class="fm-page fm-admin">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-users"></i></span>
        <div>
          <h2>Пользователи</h2>
          <span class="fm-count"><b id="usShown">${cntA}</b> из <b>${fn:length(users)}</b> · активных <b>${cntA}</b></span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-seg" id="usSeg">
        <button type="button" data-f="" onclick="usSeg(this)">Все</button>
        <button type="button" data-f="Y" class="on" onclick="usSeg(this)">Активные</button>
        <button type="button" data-f="N" onclick="usSeg(this)">Отключённые</button>
      </div>
      <select class="fm-in fms-select" id="usDept" style="width:200px; height:30px" onchange="usFilter()">
        <option value="">Все отделения</option>
      </select>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="usSearch" placeholder="Логин, ФИО или ID" oninput="usFilter()" autocomplete="off"/>
      </div>
      <button type="button" class="fm-btn primary" onclick="setPage('/core/user/save.s?id=0')"><i class="fa fa-plus"></i>Новый пользователь</button>
    </div>

    <div class="fm-table-wrap">
      <table class="fm-grid">
        <thead>
        <tr>
          <th style="width:60px">ID</th>
          <th style="width:160px">Логин</th>
          <th>ФИО</th>
          <th style="width:220px">Отделение</th>
          <th style="width:110px" class="c">Консультант</th>
          <th style="width:110px" class="c">Зав. отд.</th>
          <th style="width:90px"></th>
        </tr>
        </thead>
        <tbody id="usRows">
        <c:forEach items="${users}" var="u">
          <tr class="${u.active ? '' : 'us-off'}" data-a="${u.active ? 'Y' : 'N'}" data-d="${fn:escapeXml(u.dept.name)}"
              data-s="${u.id} ${fn:toLowerCase(fn:escapeXml(u.login))} ${fn:toLowerCase(fn:escapeXml(u.fio))}"
              onclick="setPage('/core/user/save.s?id=${u.id}')" title="Открыть">
            <td class="mut"><b>${u.id}</b></td>
            <td>${u.login}</td>
            <td><span class="nm">${u.fio}</span><c:if test="${!u.active}"> <span class="flag off">отключён</span></c:if></td>
            <td class="mut">${u.dept.name}</td>
            <td class="c">${u.consul ? '<span class="us-yes">Да</span>' : '<span class="us-no">—</span>'}</td>
            <td class="c">${u.zavlv ? '<span class="us-yes">Да</span>' : '<span class="us-no">—</span>'}</td>
            <td class="r" onclick="event.stopPropagation()">
              <button type="button" class="fm-act" title="Роли" onclick="setRoles(${u.id})"><i class="fa fa-list"></i></button>
              <button type="button" class="fm-act danger" title="Удалить" onclick="delUser(${u.id})"><i class="fa fa-trash-o"></i></button>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="fm-empty" id="usEmpty" style="display:none"><i class="fa fa-users"></i>Пользователи не найдены</div>
    </div>
  </div>
</div>
<script>
  (function () {
    var d = {};
    $('#usRows tr').each(function () { var v = $(this).data('d'); if (v) d[v] = 1; });
    Object.keys(d).sort().forEach(function (v) { $('#usDept').append($('<option>').val(v).text(v)); });
  })();
  function usSeg(btn) {
    $('#usSeg button').removeClass('on');
    $(btn).addClass('on');
    usFilter();
  }
  function usFilter() {
    var f = $('#usSeg button.on').data('f') || '', dep = $('#usDept').val();
    var q = $.trim($('#usSearch').val()).toLowerCase();
    var n = 0;
    $('#usRows tr').each(function () {
      var ok = (!f || $(this).data('a') == f) && (!dep || $(this).data('d') == dep) && (!q || String($(this).data('s')).indexOf(q) >= 0);
      $(this).toggle(ok);
      if (ok) n++;
    });
    $('#usShown').text(n);
    $('#usEmpty').toggle(n == 0);
  }
  usFilter();
  function delUser(id) {
    FmsConfirm('Вы действительно хотите удалить?', function () {
      $.ajax({
        url: '/core/user/del.s', method: 'post', data: 'id=' + id, dataType: 'json',
        success: function (res) { openMsg(res); }
      });
    });
  }
  function setRoles(id) {
    $('#usRolesBox').load('/core/user/roles.s?id=' + id);
  }
</script>
