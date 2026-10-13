<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Окно «Роли и отчёты» пользователя: загружается в контейнер страницы и открывается сразу --%>
<%@include file="/WEB-INF/pages/med/drugs/dicts/dict_kit.jsp"%>
<style>
  #urModal .fm-modal { width:1100px; max-width:calc(100vw - 32px); }
  .ur-cols { display:grid; grid-template-columns:1fr 1fr; gap:16px; align-items:start; }
  .ur-col { display:flex; flex-direction:column; gap:10px; min-width:0; }
  .ur-h { display:flex; align-items:center; gap:8px; font-weight:700; font-size:14px; }
  .ur-h small { font-weight:500; color:#9AA0AB; font-size:12px; }
  .ur-h .fm-spacer { flex:1; }
  .ur-link { border:0; background:none; color:#3B6FE0; font-size:12px; cursor:pointer; padding:0; font-family:inherit; }
  .ur-sub { border:1px solid #E6E8EC; border-radius:12px; padding:10px; background:#FAFBFC; display:flex; flex-direction:column; gap:8px; }
  .ur-list { max-height:300px; overflow:auto; display:flex; flex-direction:column; }
  .ur-list label { display:flex; align-items:center; gap:8px; margin:0; padding:5px 6px; border-radius:7px; cursor:pointer; font-weight:400; font-size:13px; }
  .ur-list label:hover { background:#F1F2F4; }
  .ur-list label.grp { font-weight:700; }
  .ur-list .g { margin:8px 6px 2px; font-size:11px; font-weight:600; color:#9AA1AC; text-transform:uppercase; letter-spacing:.4px; }
  .ur-list input { margin:0; }
</style>
<div class="fm-overlay fm-admin open" id="urModal" onclick="if (event.target === this) urClose()">
  <div class="fm-modal">
    <div class="fm-modal-head">
      <h3>Роли и отчёты · ${fn:escapeXml(user.fio)}</h3>
      <button type="button" class="fm-x" onclick="urClose()"><i class="fa fa-times"></i></button>
    </div>
    <form id="urForm" onsubmit="urSave(); return false">
      <input type="hidden" name="userId" value="${user.id}"/>
      <div class="fm-modal-body" style="max-height:calc(100vh - 190px); overflow:auto">
        <div class="fm-err" id="urErr"></div>
        <div class="ur-cols">
          <div class="ur-col">
            <div class="ur-h"><i class="fa fa-key"></i>Роли <small id="urRoleCnt"></small></div>
            <div class="fm-tgls">
              <c:forEach items="${roles}" var="r">
                <label class="fm-tgl"><input type="checkbox" name="role" value="${r.id}" <c:if test="${r.active}">checked</c:if> onchange="urSubs()"/><span>${r.name}</span></label>
              </c:forEach>
            </div>

            <div class="ur-sub" id="urKdo">
              <div class="ur-h">Лаборатория: типы исследований<span class="fm-spacer"></span>
                <button type="button" class="ur-link" onclick="urAll('#urKdo', true)">все</button>
                <button type="button" class="ur-link" onclick="urAll('#urKdo', false)">снять</button>
              </div>
              <div class="fm-tgls">
                <c:forEach items="${kdos}" var="k">
                  <label class="fm-tgl"><input type="checkbox" name="kdo" value="${k.id}" <c:if test="${k.active}">checked</c:if>/><span>${k.name}</span></label>
                </c:forEach>
              </div>
            </div>

            <div class="ur-sub" id="urAmb">
              <div class="ur-h">Амбулаторные услуги <small>выбрано <b id="urAmbCnt">0</b></small><span class="fm-spacer"></span>
                <button type="button" class="ur-link" onclick="urOnlyOn = !urOnlyOn; $(this).text(urOnlyOn ? 'все' : 'выбранные'); urAmbFilter()">выбранные</button>
              </div>
              <div class="fm-search-wrap" style="width:100%">
                <i class="fa fa-search"></i>
                <input type="text" class="fm-search" id="urAmbSearch" style="width:100%" placeholder="Услуга или группа" oninput="urAmbFilter()" autocomplete="off"/>
              </div>
              <div class="ur-list" id="urAmbList">
                <c:set var="prevG" value="-"/>
                <c:forEach items="${services}" var="s">
                  <c:if test="${s.c3 != prevG}"><div class="g">${s.c3}</div><c:set var="prevG" value="${s.c3}"/></c:if>
                  <label class="${s.c1 < 0 ? 'grp' : ''}" data-s="${fn:toLowerCase(fn:escapeXml(s.c2))} ${fn:toLowerCase(fn:escapeXml(s.c3))}">
                    <input type="checkbox" name="service" value="${s.c1}" <c:if test="${s.c4 == 'Y'}">checked</c:if> onchange="urAmbCount()"/>${s.c2}
                  </label>
                </c:forEach>
              </div>
            </div>
          </div>

          <div class="ur-col">
            <div class="ur-h"><i class="fa fa-bar-chart"></i>Отчёты <small id="urRepCnt"></small><span class="fm-spacer"></span>
              <button type="button" class="ur-link" onclick="urAll('#urReps', true)">все</button>
              <button type="button" class="ur-link" onclick="urAll('#urReps', false)">снять</button>
            </div>
            <div class="fm-tgls" id="urReps">
              <c:forEach items="${reports}" var="r">
                <label class="fm-tgl"><input type="checkbox" name="report" value="${r.id}" <c:if test="${r.active}">checked</c:if> onchange="urSubs()"/><span>${r.name}</span></label>
              </c:forEach>
            </div>
          </div>
        </div>
      </div>
      <div class="fm-modal-foot">
        <span class="fm-spacer"></span>
        <button type="button" class="fm-btn" onclick="urClose()">Отмена</button>
        <button type="submit" class="fm-btn primary" id="urSaveBtn"><i class="fa fa-floppy-o"></i>Сохранить</button>
      </div>
    </form>
  </div>
</div>
<script>
  var urOnlyOn = false;
  function urClose() { $('#urModal').remove(); }
  function urAll(box, on) { $(box).find('input[type=checkbox]').prop('checked', on); urSubs(); }
  // лаборатория (роль 7) и амбулатория (роль 14): вложенные списки видны только при включённой роли
  function urSubs() {
    var f = $('#urForm'), lab = f.find('[name=role][value=7]').is(':checked'), amb = f.find('[name=role][value=14]').is(':checked');
    $('#urKdo').toggle(lab);
    if (!lab) $('#urKdo input').prop('checked', false);
    $('#urAmb').toggle(amb);
    if (!amb) $('#urAmb input[name=service]').prop('checked', false);
    $('#urRoleCnt').text('выбрано ' + f.find('[name=role]:checked').length);
    $('#urRepCnt').text('выбрано ' + f.find('[name=report]:checked').length);
    urAmbCount();
  }
  function urAmbCount() { $('#urAmbCnt').text($('#urAmbList input:checked').length); }
  function urAmbFilter() {
    var q = $.trim($('#urAmbSearch').val()).toLowerCase();
    $('#urAmbList label').each(function () {
      $(this).toggle((!q || String($(this).attr('data-s')).indexOf(q) >= 0) && (!urOnlyOn || $(this).find('input').is(':checked')));
    });
    $('#urAmbList .g').each(function () { $(this).toggle($(this).nextUntil('.g', 'label:visible').length > 0); });
  }
  function urSave() {
    $('#urSaveBtn').prop('disabled', true);
    $.ajax({
      url: '/core/user/roles.s', method: 'post', data: $('#urForm').serialize(), dataType: 'json',
      success: function (res) {
        if (res.success) { openMsg(res); urClose(); }
        else DK.err('ur', res.msg);
      },
      complete: function () { $('#urSaveBtn').prop('disabled', false); }
    });
  }
  urSubs();
</script>
