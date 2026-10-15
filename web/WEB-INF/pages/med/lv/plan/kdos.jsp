<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/res/js/common.js?v=2026101501"></script>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<style>
  .kd { --brand:#D7182E; --brand-soft:#FDECEE; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC;
    padding:16px 20px 28px; color:var(--text); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .kd * { box-sizing:border-box; }
  .kd-head { display:flex; align-items:center; gap:14px; flex-wrap:wrap; margin-bottom:12px; }
  .kd-head h2 { margin:0; font-size:19px; font-weight:700; }
  .kd-head .tools { margin-left:auto; display:flex; align-items:center; gap:10px; }
  .kd-btn { display:inline-flex; align-items:center; gap:7px; height:36px; padding:0 14px; border-radius:9px; border:1px solid var(--border); background:#fff;
    color:var(--text); font-size:13.5px; font-weight:600; cursor:pointer; }
  .kd-btn:hover { background:#F5F6F8; }
  .kd-sel { font-size:13.5px; color:var(--muted); }
  .kd-sel b { color:var(--brand); font-size:15px; }
  .kd-card { background:#fff; border:1px solid var(--border); border-radius:14px; overflow:hidden; }
  .kd-search { padding:12px 16px; border-bottom:1px solid var(--border); position:relative; }
  .kd-search i { position:absolute; left:28px; top:50%; margin-top:-7px; color:#9AA1AC; }
  .kd-search input { width:100%; height:38px; padding:0 12px 0 34px; border:1px solid var(--border); border-radius:9px; font-size:14px; outline:none; }
  .kd-search input:focus { border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .kd .nav-tabs { border-bottom:1px solid var(--border); padding:8px 12px 0; background:#FAFBFC; display:flex; flex-wrap:wrap; gap:2px; }
  .kd .nav-tabs > li { float:none; margin:0; }
  .kd .nav-tabs > li > a { border:0 !important; border-radius:9px 9px 0 0; color:var(--muted); font-weight:600; font-size:13.5px; padding:9px 14px; margin:0; background:transparent; }
  .kd .nav-tabs > li > a:hover { background:#F1F2F4; color:var(--text); }
  .kd .nav-tabs > li.active > a, .kd .nav-tabs > li.active > a:hover, .kd .nav-tabs > li.active > a:focus { background:#fff; color:var(--brand); box-shadow:inset 0 -2px 0 var(--brand); }
  .kd .nav-tabs > li.dim > a { opacity:.4; }
  .kd .tb { display:inline-block; min-width:18px; margin-left:6px; padding:0 6px; border-radius:9px; background:var(--brand); color:#fff; font-size:11px; line-height:18px; text-align:center; }
  .kd .tb:empty, .kd .tb.zero { display:none; }
  .kd .tab-content { padding:14px 16px 16px; }
  .kd-list { display:grid; grid-template-columns:repeat(auto-fill, minmax(290px, 1fr)); gap:8px; }
  .kd-item { display:flex; align-items:center; gap:10px; margin:0; padding:9px 12px; border:1px solid var(--border); border-radius:10px; cursor:pointer; font-weight:500; font-size:14px; }
  .kd-item:hover { background:#FAFBFC; }
  .kd-item.on { border-color:var(--brand); background:var(--brand-soft); }
  .kd-item.on span { font-weight:600; }
  .kd-item input { margin:0; width:17px; height:17px; flex:none; }
  .kd-none { padding:22px; text-align:center; color:var(--muted); display:none; }
</style>
<script>
  function updKdo() {
    $('#selCount').text($('input[name=ids]:checked').length);
    $('.tab-pane').each(function () {
      var n = $(this).find('input[name=ids]:checked').length;
      $('a[href="#' + this.id + '"] .tb').text(n || '').toggleClass('zero', !n);
    });
  }
  function filterKdo() {
    var q = $.trim($('#kdoSearch').val()).toLowerCase(), first = null;
    $('.tab-pane').each(function () {
      var pane = $(this), cnt = 0;
      pane.find('.kd-item').each(function () {
        var ok = !q || $(this).text().toLowerCase().indexOf(q) > -1;
        $(this).toggle(ok);
        if (ok) cnt++;
      });
      pane.find('.kd-none').toggle(cnt === 0);
      $('a[href="#' + pane.attr('id') + '"]').closest('li').toggleClass('dim', !!q && cnt === 0);
      if (cnt > 0 && !first) first = pane.attr('id');
    });
    if (q && first && $('.tab-pane.active .kd-item:visible').length === 0)
      $('a[href="#' + first + '"]').tab('show');
  }
  function clearKdo() {
    $('input[name=ids]').prop('checked', false);
    $('.kd-item').removeClass('on');
    updKdo();
  }
  $(function () {
    $('input[name=ids]').on('change', function () {
      $(this).closest('.kd-item').toggleClass('on', this.checked);
      updKdo();
    });
    $('#kdoSearch').on('input', filterKdo);
    updKdo();
  });
</script>
<f:form method="post">
  <div class="kd">
    <div class="kd-head">
      <h2>Список обследования</h2>
      <div class="tools">
        <span class="kd-sel">Выбрано: <b id="selCount">0</b></span>
        <button class="kd-btn" type="button" onclick="clearKdo()" title="Снять все отметки"><i class="fa fa-times"></i> Сбросить</button>
        <button class="hidden" id="saveBtn" type="submit" title="Сохранить"><i class="fa fa-floppy-o"></i> Сохранить</button>
        <button class="kd-btn" type="button" onclick="setLocation('/lv/plan/index.s')"><i class="fa fa-arrow-left"></i> Назад</button>
      </div>
    </div>
    <div class="kd-card">
      <div class="kd-search">
        <i class="fa fa-search"></i>
        <input type="text" id="kdoSearch" placeholder="Поиск обследования по названию" autocomplete="off">
      </div>
      <ul class="nav nav-tabs">
        <c:forEach items="${types}" var="ty" varStatus="loop">
          <li class="<c:if test="${loop.index == 0}">active</c:if>"><a href="#page${ty.id}" data-toggle="tab" aria-expanded="true">${ty.name}<span class="tb zero"></span></a></li>
        </c:forEach>
      </ul>
      <div class="tab-content">
        <c:forEach items="${types}" var="ty" varStatus="loop">
          <div class="tab-pane <c:if test="${loop.index == 0}">active</c:if> fade in" id="page${ty.id}">
            <div class="kd-list">
              <c:forEach items="${ty.list}" var="k">
                <label class="kd-item" for="kdo${k.id}"><input type="checkbox" id="kdo${k.id}" value="${k.id}" name="ids"><span>${k.c1}</span></label>
              </c:forEach>
            </div>
            <div class="kd-none">Ничего не найдено</div>
          </div>
        </c:forEach>
      </div>
    </div>
  </div>
</f:form>
