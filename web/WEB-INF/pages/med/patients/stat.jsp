<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  .sd { --brand:#D7182E; --brand-soft:#FDECEE; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8; --bar:#2a78d6;
    max-width:1200px; margin:0 auto; padding:16px 20px 32px; color:var(--text);
    font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .sd-card { background:#fff; border:1px solid var(--border); border-radius:14px; }

  /* ---------- Плитки ---------- */
  .sd-tiles { display:grid; grid-template-columns:repeat(4, 1fr); gap:16px; margin-bottom:16px; }
  .sd-tile { padding:18px 20px; display:flex; flex-direction:column; gap:10px; }
  .sd-tile .t-h { display:flex; align-items:center; gap:10px; font-size:13px; font-weight:600; color:var(--muted); line-height:1.3; }
  .sd-tile .ico { flex:none; width:36px; height:36px; border-radius:10px; display:flex; align-items:center; justify-content:center; font-size:16px; }
  .sd-tile .val { font-size:34px; font-weight:700; line-height:1; letter-spacing:-.5px; font-variant-numeric:tabular-nums; }
  .sd-tile.cur  .ico { background:var(--brand-soft); color:var(--brand); }
  .sd-tile.vyp  .ico { background:#E8F7EE; color:#15803D; }
  .sd-tile.mon  .ico { background:#EAF1FE; color:#2563EB; }
  .sd-tile.year .ico { background:#F1F2F4; color:#6B7280; }

  /* ---------- Таблица врачей ---------- */
  .sd-h { display:flex; align-items:center; gap:10px; padding:14px 18px; border-bottom:1px solid var(--border); }
  .sd-h h3 { margin:0; font-size:16px; font-weight:700; }
  .sd-h .sp { flex:1; }
  .sd-h .hint { font-size:12.5px; color:#9AA1AC; }
  .sd-t { width:100%; border-collapse:separate; border-spacing:0; font-size:14px; }
  .sd-t th { padding:10px 16px; background:#F8F9FA; border-bottom:1px solid var(--border); color:var(--muted); font-size:12px; font-weight:600;
    text-transform:uppercase; letter-spacing:.3px; text-align:right; white-space:nowrap; }
  .sd-t th:first-child { text-align:left; }
  .sd-t td { padding:11px 16px; border-bottom:1px solid #F0F1F4; text-align:right; font-variant-numeric:tabular-nums; }
  .sd-t td:first-child { text-align:left; }
  .sd-t tbody tr:hover td { background:#FAFBFC; }
  .sd-t tr:last-child td { border-bottom:0; }
  .sd-t .doc { display:flex; align-items:center; gap:10px; }
  .sd-t .ava { flex:none; width:28px; height:28px; border-radius:50%; background:#F1F2F4; color:#6B7280; font-size:12px; font-weight:700;
    display:flex; align-items:center; justify-content:center; }
  .sd-t .z { color:#C3C7CE; }
  /* строки-итоги / группы (c1 = 0) */
  .sd-t tr.grp td { background:#FAFBFC; font-weight:700; border-top:1px solid var(--border); }
  .sd-t tr.grp .ava { background:var(--brand-soft); color:var(--brand); }
  /* полоска «Всего» */
  .sd-t td.bar-cell { width:220px; text-align:left; }
  .sd-bar { display:flex; align-items:center; gap:10px; }
  .sd-bar i { display:block; height:8px; min-width:2px; border-radius:0 4px 4px 0; background:var(--bar); }
  .sd-bar b { font-weight:700; min-width:28px; }

  @media (max-width: 1100px) { .sd-tiles { grid-template-columns:repeat(2, 1fr); } .sd-t td.bar-cell { width:160px; } }
</style>

<div class="sd">
  <!-- ================= Плитки ================= -->
  <div class="sd-tiles">
    <div class="sd-card sd-tile cur">
      <div class="t-h"><span class="ico"><i class="fa fa-bed"></i></span>Текущие пациенты</div>
      <div class="val">${cur}</div>
    </div>
    <div class="sd-card sd-tile vyp">
      <div class="t-h"><span class="ico"><i class="fa fa-sign-out"></i></span>Выписанные пациенты</div>
      <div class="val">${vyp}</div>
    </div>
    <div class="sd-card sd-tile mon">
      <div class="t-h"><span class="ico"><i class="fa fa-calendar"></i></span>Пациентов за месяц</div>
      <div class="val">${curMonth}</div>
    </div>
    <div class="sd-card sd-tile year">
      <div class="t-h"><span class="ico"><i class="fa fa-line-chart"></i></span>Пациентов за год</div>
      <div class="val">${curYear}</div>
    </div>
  </div>

  <!-- ================= По лечащим врачам ================= -->
  <div class="sd-card" style="overflow:hidden">
    <div class="sd-h">
      <h3>По лечащим врачам</h3>
      <span class="sp"></span>
      <span class="hint">Регистрация · выписка · всего</span>
    </div>
    <div style="overflow-x:auto">
      <table class="sd-t">
        <thead>
        <tr>
          <th>Лечащий врач</th>
          <th style="width:130px">Регистрация</th>
          <th style="width:110px">Выписка</th>
          <th style="width:220px; text-align:left">Всего</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${lvs}" var="lv">
          <tr class="${lv.c1 == '0' ? 'grp' : 'doc-row'}">
            <td>
              <span class="doc">
                <span class="ava"><c:choose><c:when test="${lv.c1 == '0'}"><i class="fa fa-hospital-o"></i></c:when><c:otherwise><i class="fa fa-user-md"></i></c:otherwise></c:choose></span>
                ${lv.c2}
              </span>
            </td>
            <td><c:choose><c:when test="${lv.c3 != '0'}">${lv.c3}</c:when><c:otherwise><span class="z">—</span></c:otherwise></c:choose></td>
            <td><c:choose><c:when test="${lv.c4 != '0'}">${lv.c4}</c:when><c:otherwise><span class="z">—</span></c:otherwise></c:choose></td>
            <td class="bar-cell">
              <span class="sd-bar" data-v="${lv.c5}">
                <i></i><c:choose><c:when test="${lv.c5 != '0'}"><b>${lv.c5}</b></c:when><c:otherwise><span class="z">—</span></c:otherwise></c:choose>
              </span>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div>

<script>
  // Длина полоски «Всего» — относительно максимума среди врачей (строки-итоги не участвуют)
  (function () {
    var rows = document.querySelectorAll('.sd-t tr.doc-row .sd-bar'), max = 0;
    rows.forEach(function (b) { max = Math.max(max, parseFloat(b.getAttribute('data-v')) || 0); });
    document.querySelectorAll('.sd-t .sd-bar').forEach(function (b) {
      var v = parseFloat(b.getAttribute('data-v')) || 0, i = b.querySelector('i');
      var isGrp = b.closest('tr').classList.contains('grp');
      if (!v || isGrp || !max) { i.style.display = 'none'; return; }
      i.style.width = Math.max(2, Math.round(v / max * 130)) + 'px';
      b.title = v + ' пац.';
    });
  })();
</script>
