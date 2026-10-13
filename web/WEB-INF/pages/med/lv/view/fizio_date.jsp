<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/js/common.js?v=2026101309" type="text/javascript"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<style>
  .fz { --brand:#D7182E; --brand-dark:#A50F22; --brand-soft:#FDECEE; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    --ok:#15803D; --ok-bg:#E8F7EE; --bad:#B91C1C; --bad-bg:#FDECEE;
    padding:16px 20px 28px; color:var(--text); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .fz * { box-sizing:border-box; }
  .fz-head { display:flex; align-items:center; gap:12px; flex-wrap:wrap; margin-bottom:12px; }
  .fz-head h2 { margin:0; font-size:19px; font-weight:700; }
  .fz-head .who { color:var(--muted); font-size:13.5px; }
  .fz-head .act { margin-left:auto; display:flex; align-items:center; gap:8px; flex-wrap:wrap; }
  .fz-btn { display:inline-flex; align-items:center; gap:7px; height:36px; padding:0 14px; border-radius:9px; border:1.5px solid var(--border); background:#fff;
    color:var(--text); font-size:13.5px; font-weight:600; cursor:pointer; white-space:nowrap; text-decoration:none !important; }
  .fz-btn:hover { background:var(--bg); color:var(--text); }
  .fz-btn .fa { color:var(--muted); }
  .fz-btn.primary { background:var(--brand); border-color:var(--brand); color:#fff; }
  .fz-btn.primary .fa { color:#fff; }
  .fz-btn.primary:hover { background:var(--brand-dark); border-color:var(--brand-dark); }
  .fz-days { display:inline-flex; align-items:center; height:36px; border:1.5px solid var(--border); border-radius:9px; background:#fff; overflow:hidden; }
  .fz-days span { padding:0 10px; font-size:13px; font-weight:600; color:var(--muted); }
  .fz-days button { width:34px; height:100%; border:0; border-left:1.5px solid var(--border); background:#fff; color:var(--text); cursor:pointer; }
  .fz-days button:hover { background:var(--bg); }
  .fz-card { background:#fff; border:1px solid var(--border); border-radius:14px; overflow:hidden; }
  .fz-scroll { overflow-x:auto; }
  .fz-table { border-collapse:collapse; width:100%; }
  .fz-table th { padding:8px 10px; font-size:11.5px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px; background:#F8F9FA;
    border-bottom:1px solid var(--border); white-space:nowrap; text-align:left; }
  .fz-table th.c, .fz-table td.c { text-align:center; }
  .fz-table th.r, .fz-table td.r { text-align:right; }
  .fz-table td { padding:8px 10px; border-bottom:1px solid #F0F1F4; font-size:14px; vertical-align:middle; }
  .fz-table tr:last-child td { border-bottom:0; }
  .fz-table tbody tr:hover td { background:#FAFBFC; }
  .fz-table .n { width:36px; text-align:center; color:#9AA1AC; font-size:13px; }
  .fz-table .name { min-width:200px; font-weight:600; }
  .fz-table .sum { white-space:nowrap; font-variant-numeric:tabular-nums; }
  .fz-table .form-control { height:34px; border:1.5px solid var(--border); border-radius:8px; box-shadow:none; font-size:13px; }
  .fz-table .form-control:focus { border-color:var(--brand); box-shadow:0 0 0 3px rgba(215,24,46,.10); }
  .fz-table .w-ei { width:90px; } .fz-table .w-txt { min-width:180px; }
  .fz-table th.d { width:38px; padding:8px 4px; text-align:center; font-variant-numeric:tabular-nums; }
  .fz-table td.d { width:38px; padding:4px; text-align:center; cursor:pointer; }
  .fz-table td.d.locked { cursor:default; }
  .fz-table td.d input { display:none; }
  .fz-table td.d .mark { display:inline-flex; width:26px; height:26px; border-radius:50%; border:1.5px dashed #D5D8DE; align-items:center; justify-content:center;
    font-size:12px; color:transparent; transition:background .1s, border-color .1s; }
  .fz-table td.d:not(.locked):hover .mark { border-color:var(--ok); }
  .fz-table td.d input:checked + .mark { background:var(--ok-bg); border:1.5px solid var(--ok-bg); color:var(--ok); }
  .fz-table td.d.locked .mark { border-style:solid; border-color:#EEF0F3; background:#F8F9FA; }
  .fz-table td.d.locked input:checked + .mark { background:var(--ok); border-color:var(--ok); color:#fff; }
  .fz-del { width:30px; height:30px; display:inline-flex; align-items:center; justify-content:center; border-radius:8px; border:0; background:transparent; color:var(--muted); cursor:pointer; }
  .fz-del:hover { background:var(--bad-bg); color:var(--bad); }
  .fz-empty { padding:24px 18px; text-align:center; color:var(--muted); }
  .fz-legend { display:flex; gap:18px; flex-wrap:wrap; padding:10px 18px; border-top:1px solid var(--border); background:#FAFBFC; font-size:12.5px; color:var(--muted); }
  .fz-legend .mark { display:inline-flex; width:18px; height:18px; border-radius:50%; align-items:center; justify-content:center; font-size:10px; margin-right:5px; vertical-align:middle; }
  .fz-legend .mark.on { background:var(--ok-bg); color:var(--ok); }
  .fz-legend .mark.done { background:var(--ok); color:#fff; }
  /* подсказки «Область» / «Примечание» */
  .fz-sugg { position:relative; }
  .fz-sugg .oblast_filter, .fz-sugg .comment_filter { top:calc(100% + 4px); left:0; z-index:50; max-height:240px; overflow-y:auto;
    border:1px solid var(--border); border-radius:10px; box-shadow:0 12px 30px rgba(20,25,40,.14); }
  .fz-sugg table { width:100%; border:0; }
  .fz-sugg table td { padding:8px 12px; border:0; border-bottom:1px solid #F0F1F4; font-size:13px; cursor:pointer; background:#fff; }
  .fz-sugg table tr:hover td { background:var(--brand-soft); }
</style>
<script>
  function addRow() {
    document.location = '/view/fizio/list.s';
  }
  function removeFizio(id) {
    FmsConfirm('Удалить процедуру?', function () {
    $.ajax({
      url:'/view/fizio/delete.s',
      data:'id='+id,
      method:'post',
      dataType:'json',
      success:function (res) {
        showMsg(res.msg, true);
        if(res.counter > 0)
          $('#fizio' + id).remove();
        else
          setTimeout(function () { document.location = '/view/fizio/index.s'; }, 700);
      },
      error:function () { showMsg('Не удалось удалить процедуру', false); }
    });
  });
  }
  function saveFizio() {
    var empty = $('#fizioForm input[name=fizei]').filter(function () { return $.trim(this.value) === ''; });
    if(empty.length > 0) {
      showMsg('Укажите единицу измерения для всех процедур', false);
      empty.first().focus();
      return;
    }
    $.ajax({
      url:'/view/fizio/save.s',
      data:$('#fizioForm').serialize(),
      method:'post',
      dataType:'json',
      success:function (res) {
        showMsg(res.msg, true);
        setTimeout(function () { document.location = '/view/fizio/index.s'; }, 700);
      },
      error:function () { showMsg('Не удалось сохранить данные', false); }
    });
  }
  function setAct(code) {
    document.location = '/view/fizio/index.s?action=' + code;
  }
  function setCheck(evt, id, d) {
    if (${pat.state == 'ARCH' ? 'true' : 'false'}) return; // пациент в архиве
    if(evt.target.tagName != 'INPUT') {
      if(!document.getElementById("fizio_" + id + "_" + d).disabled)
        document.getElementById("fizio_" + id + "_" + d).checked = !document.getElementById("fizio_" + id + "_" + d).checked;
    }
  }
  $(() => {
    $('body').click(() => {
      $('.oblast_filter').hide();
      $('.comment_filter').hide();
    })
  })
  let oblast = [], comments = [];
  function search_templates(dom, kdo, code) {
    let elem = $(dom), v = elem.val().toUpperCase();
    let div = elem.parent().find('.' + code + '_filter');
    div.width(Math.max(elem.outerWidth(), 260));
    if(v.length === 0) div.hide();
    if(v.length > 3) {
      if(oblast.length === 0) {
        $('.' + code + '_filter').hide();
        $.ajax({
          url: '/view/fizio/search_templates.s',
          method: 'post',
          data: 'code=' + code + '&kdo=' + kdo + '&word=' + encodeURIComponent(v),
          dataType: 'json',
          success: function (res) {
            if (res.success) {
              oblast = res.rows;
              if(oblast.length > 0) {
                buildOblast(dom, oblast, code);
                div.show();
              }
            } else openMsg(res);
          }
        });
      } else {
        div.show();
        let cls = oblast.filter(obj => obj.toUpperCase().indexOf(v) !== -1);
        buildOblast(dom, cls, code);
      }
    } else {
      oblast = [];
    }
  }
  function buildOblast(dom, cls, code) {
    let table = $(dom).parent().find('.' + code + '_filter>table>tbody');
    table.html('');
    for(let obj of cls) {
      let tr = $('<tr></tr>');
      tr.click(()=> {
        $(dom).parent().find('.' + code + '_filter').hide();
        dom.value = obj;
      });
      tr.append($('<td></td>').text(obj));
      table.append(tr);
    }
  }
</script>
<c:set var="canEdit" value="${sessionScope.ENV.roleId == 16 && pat.state != 'ARCH'}"/>
<form id="fizioForm" method="post">
  <div class="fz">
    <div class="fz-head">
      <h2>Физиотерапия</h2>
      <span class="who"><b>${pat.surname} ${pat.name} ${pat.middlename}</b> &nbsp;·&nbsp; Год рождения: ${pat.birthyear}</span>
      <c:if test="${pat.state == 'ARCH'}"><span class="act" style="color:#6B7280"><i class="fa fa-lock"></i> Пациент в архиве: только просмотр</span></c:if>
      <c:if test="${sessionScope.ENV.roleId == 16 && pat.state != 'ARCH'}">
        <span class="act">
          <c:if test="${pat.paid != 'CLOSED' && fn:length(fizios) > 0}">
            <span class="fz-days" title="Добавить или убрать последний день в графике">
              <span>Дни</span>
              <button onclick="setAct('del')" type="button" title="Убрать день"><i class="fa fa-minus"></i></button>
              <button onclick="setAct('add')" type="button" title="Добавить день"><i class="fa fa-plus"></i></button>
            </span>
          </c:if>
          <button class="fz-btn" type="button" onclick="window.open('/lv/plan.s?new=Y')" title="Результаты обследований"><i class="fa fa-flask"></i> Результаты</button>
          <c:if test="${pat.paid != 'CLOSED'}">
            <button class="fz-btn" onclick="addRow()" type="button"><i class="fa fa-plus"></i> Добавить</button>
          </c:if>
          <button class="fz-btn primary" onclick="saveFizio()" type="button"><i class="fa fa-floppy-o"></i> Сохранить</button>
        </span>
      </c:if>
    </div>

    <div class="fz-card">
      <c:choose>
        <c:when test="${empty fizios}">
          <div class="fz-empty">Процедуры не назначены</div>
        </c:when>
        <c:otherwise>
          <div class="fz-scroll">
            <table class="fz-table">
              <thead>
              <tr>
                <th class="c">№</th>
                <th>Процедура</th>
                <th class="c">Ед. изм.</th>
                <c:if test="${canEdit}"><th class="r">Стоимость</th></c:if>
                <th>Область</th>
                <c:choose>
                  <c:when test="${canEdit}">
                    <c:forEach items="${dates}" var="d">
                      <th class="d"><fmt:formatDate pattern="dd.MM" value="${d.date}"/></th>
                    </c:forEach>
                  </c:when>
                  <c:otherwise><th class="c">Кол-во</th></c:otherwise>
                </c:choose>
                <th>Примечание</th>
                <c:if test="${canEdit}"><th class="c"></th></c:if>
              </tr>
              </thead>
              <tbody>
              <c:choose>
                <c:when test="${canEdit}">
                  <c:forEach items="${fizios}" var="fizio" varStatus="loop">
                    <tr id="fizio${fizio.id}">
                      <td class="n"><input type="hidden" name="id" value="${fizio.id}"/>${loop.index + 1}</td>
                      <td class="name">${fizio.kdo.name}</td>
                      <c:choose>
                        <c:when test="${ fizio.kdo.fizei == null || fizio.fizei == null}">
                          <td class="c"><input type="number" maxlength="10" class="form-control text-center w-ei" name="fizei" value="${fizio.fizei}"/></td>
                        </c:when>
                        <c:otherwise>
                          <td class="c"><input type="hidden" name="fizei" value="${fizio.fizei}"/>${fizio.fizei}</td>
                        </c:otherwise>
                      </c:choose>
                      <td class="r sum">${fizio.price * (fizio.count == null ? 0 : fizio.count) - (fizio.paidSum != null ? fizio.paidSum : 0)}</td>
                      <td class="fz-sugg">
                        <input type="text" maxlength="200" class="form-control w-txt" autocomplete="off" onkeyup="search_templates(this, ${fizio.kdo.id}, 'oblast')" name="oblast" value="${fizio.oblast}"/>
                        <div class="oblast_filter" style="display: none; position: absolute; background:white">
                          <table><tbody></tbody></table>
                        </div>
                      </td>
                      <c:forEach items="${ds[fizio.id]}" var="d">
                        <fmt:formatDate pattern="dd.MM.yyyy" value="${d.date}" var="dStr"/>
                        <td onclick="setCheck(event, ${fizio.id}, '${dStr}')" class="d<c:if test="${d.done != 'N'}"> locked</c:if>"
                            title="${dStr}<c:if test="${d.done != 'N'}"> — процедура уже проведена</c:if>">
                          <input type="hidden" name="date_${fizio.id}" value="${dStr}"/>
                          <input type="checkbox" <c:if test="${d.done != 'N' || pat.state == 'ARCH'}">disabled</c:if> <c:if test="${d.state == 'Y'}">checked</c:if> name="fizio_${fizio.id}_${dStr}" id="fizio_${fizio.id}_${dStr}" value="Y"/>
                          <span class="mark"><i class="fa fa-check"></i></span>
                        </td>
                      </c:forEach>
                      <td class="fz-sugg">
                        <input type="text" maxlength="200" class="form-control w-txt" autocomplete="off" name="comment" onkeyup="search_templates(this, ${fizio.kdo.id}, 'comment')" value="${fizio.comment}"/>
                        <div class="comment_filter" style="display: none; position: absolute; background:white">
                          <table><tbody></tbody></table>
                        </div>
                      </td>
                      <td class="c">
                        <c:if test="${fizio.paid != 'Y' && pat.state != 'ARCH'}">
                          <button class="fz-del" type="button" title="Удалить" onclick="removeFizio(${fizio.id})"><i class="fa fa-trash-o"></i></button>
                        </c:if>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <c:forEach items="${fizios}" var="fizio" varStatus="loop">
                    <tr id="fizio${fizio.id}">
                      <td class="n">${loop.index + 1}</td>
                      <td class="name">${fizio.kdo.name}</td>
                      <td class="c">${fizio.fizei}</td>
                      <td>${fizio.oblast}</td>
                      <td class="c">${fizio.count}</td>
                      <td>${fizio.comment}</td>
                    </tr>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
              </tbody>
            </table>
          </div>
          <c:if test="${canEdit}">
            <div class="fz-legend">
              <span><span class="mark on"><i class="fa fa-check"></i></span> назначено на дату (клик по клетке включает/выключает)</span>
              <span><span class="mark done"><i class="fa fa-check"></i></span> уже проведено, изменить нельзя</span>
            </div>
          </c:if>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</form>
