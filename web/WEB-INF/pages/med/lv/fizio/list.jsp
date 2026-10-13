<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/res/js/common.js?v=2026101309"></script>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<style>
  .fz { --brand:#D7182E; --brand-dark:#A50F22; --brand-soft:#FDECEE; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    max-width:900px; margin:0 auto; padding:16px 20px 28px; color:var(--text); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .fz * { box-sizing:border-box; }
  .fz-head { display:flex; align-items:center; gap:12px; flex-wrap:wrap; margin-bottom:12px; }
  .fz-head h2 { margin:0; font-size:19px; font-weight:700; }
  .fz-head .act { margin-left:auto; display:flex; align-items:center; gap:8px; }
  .fz-btn { display:inline-flex; align-items:center; gap:7px; height:36px; padding:0 14px; border-radius:9px; border:1.5px solid var(--border); background:#fff;
    color:var(--text); font-size:13.5px; font-weight:600; cursor:pointer; white-space:nowrap; }
  .fz-btn:hover { background:var(--bg); }
  .fz-btn .fa { color:var(--muted); }
  .fz-btn.primary { background:var(--brand); border-color:var(--brand); color:#fff; }
  .fz-btn.primary .fa { color:#fff; }
  .fz-btn.primary:hover { background:var(--brand-dark); border-color:var(--brand-dark); }
  .fz-btn[disabled] { opacity:.5; cursor:default; }
  .fz-card { background:#fff; border:1px solid var(--border); border-radius:14px; overflow:hidden; }
  .fz-search { display:flex; align-items:center; gap:12px; padding:12px 16px; border-bottom:1px solid var(--border); }
  .fz-search .form-control { flex:1; height:38px; border:1.5px solid var(--border); border-radius:9px; box-shadow:none; font-size:14px; }
  .fz-search .form-control:focus { border-color:var(--brand); box-shadow:0 0 0 3px rgba(215,24,46,.10); }
  .fz-search .cnt { font-size:13px; color:var(--muted); white-space:nowrap; }
  .fz-search .cnt b { color:var(--text); }
  .fz-list { max-height:calc(100vh - 170px); overflow-y:auto; }
  .fz-item { display:flex; align-items:center; gap:12px; margin:0; padding:10px 16px; border-bottom:1px solid #F0F1F4; font-size:14px; font-weight:500; cursor:pointer; }
  .fz-item:last-child { border-bottom:0; }
  .fz-item:hover { background:#FAFBFC; }
  .fz-item input { width:16px; height:16px; margin:0; accent-color:var(--brand); cursor:pointer; }
  .fz-item.on { background:#FFF7F8; }
  .fz-empty { padding:24px 18px; text-align:center; color:var(--muted); }
</style>
<script>
  function saveFizio() {
    if($('#fizioForm input[name=ids]:checked').length === 0) {
      showMsg('Выберите хотя бы одну процедуру', false);
      return;
    }
    $.ajax({
      url : '/view/fizio/set.s',
      data : $('#fizioForm').serialize(),
      method:'post',
      dataType : 'json',
      success : function (res) {
        document.location = '/view/fizio/index.s';
      },
      error : function () { showMsg('Не удалось добавить процедуры', false); }
    });
  }
  function fzRecalc() {
    var n = 0;
    $('.fz-item').each(function () {
      var on = $(this).find('input').prop('checked');
      $(this).toggleClass('on', on);
      if(on) n++;
    });
    $('#fzCnt').text(n);
    $('#saveBtn').prop('disabled', n === 0);
  }
  $(function () {
    $('#fizioForm').on('change', 'input[name=ids]', fzRecalc);
    $('#fzFilter').on('input', function () {
      var q = $.trim(this.value).toLowerCase(), shown = 0;
      $('.fz-item').each(function () {
        var ok = !q || $(this).text().toLowerCase().indexOf(q) !== -1;
        $(this).toggle(ok);
        if(ok) shown++;
      });
      $('#fzNone').toggle(shown === 0);
    });
    fzRecalc();
  });
</script>
<div class="fz">
  <div class="fz-head">
    <h2>Физиотерапевтические процедуры</h2>
    <span class="act">
      <button class="fz-btn primary" id="saveBtn" type="button" onclick="saveFizio()" title="Добавить выбранные процедуры"><i class="fa fa-check"></i> Добавить выбранные</button>
      <button class="fz-btn" type="button" onclick="setLocation('/view/fizio/index.s')"><i class="fa fa-arrow-left"></i> Назад</button>
    </span>
  </div>
  <div class="fz-card">
    <div class="fz-search">
      <input type="text" id="fzFilter" class="form-control" placeholder="Поиск процедуры" autocomplete="off"/>
      <span class="cnt">Выбрано: <b id="fzCnt">0</b></span>
    </div>
    <form id="fizioForm" class="fz-list">
      <c:forEach items="${fizios}" var="k">
        <label class="fz-item" for="kdo${k.id}"><input type="checkbox" id="kdo${k.id}" value="${k.id}" name="ids"> ${k.name}</label>
      </c:forEach>
      <div class="fz-empty" id="fzNone" style="display:none">Ничего не найдено</div>
      <c:if test="${empty fizios}"><div class="fz-empty">Справочник процедур пуст</div></c:if>
    </form>
  </div>
</div>
