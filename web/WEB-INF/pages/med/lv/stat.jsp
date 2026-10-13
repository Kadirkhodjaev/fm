<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Лечащий врач → Статистика: мои пациенты сейчас, сегодня, выбранный месяц по типам палат, динамика за 12 месяцев --%>
<%@include file="/WEB-INF/pages/med/head_nurse/hn_style.jsp"%>
<style>
  .ls-wrap { padding:12px; display:flex; flex-direction:column; gap:12px; background:#F5F6F8; min-height:100%; box-sizing:border-box; }
  .ls-kpi { display:grid; grid-template-columns:repeat(auto-fit, minmax(150px, 1fr)); gap:10px; }
  .ls-kpi > div { background:#fff; border:1px solid #E6E8EC; border-radius:14px; padding:12px 14px; }
  .ls-kpi .k { font-size:12px; color:#6B7280; display:flex; align-items:center; gap:6px; }
  .ls-kpi .k .fa { color:#9AA1AC; }
  .ls-kpi .v { font-size:24px; font-weight:700; color:#1F2430; font-variant-numeric:tabular-nums; margin-top:2px; line-height:1.2; }
  .ls-kpi .d { font-size:12px; color:#9AA1AC; margin-top:2px; }
  .ls-kpi .d.up { color:#1E7B43; } .ls-kpi .d.down { color:#A50F22; }
  .ls-kpi .main { background:#1F2430; border-color:#1F2430; }
  .ls-kpi .main .k, .ls-kpi .main .k .fa, .ls-kpi .main .d { color:#C9CDD5; }
  .ls-kpi .main .v { color:#fff; }
  .ls-grid { display:grid; grid-template-columns:minmax(0, 3fr) minmax(340px, 2fr); gap:12px; align-items:start; }
  .ls-col { display:flex; flex-direction:column; gap:12px; min-width:0; }
  .ls-chart { display:flex; align-items:flex-end; gap:8px; height:170px; padding:16px 16px 6px; }
  .ls-bar { flex:1; display:flex; flex-direction:column; align-items:center; justify-content:flex-end; height:100%; cursor:pointer; min-width:0; }
  .ls-bar .n { font-size:11.5px; font-weight:600; color:#6B7280; margin-bottom:3px; font-variant-numeric:tabular-nums; }
  .ls-bar .b { width:100%; max-width:38px; min-height:3px; border-radius:6px 6px 2px 2px; background:#D5DCE8; transition:background .12s; }
  .ls-bar:hover .b { background:#9DB3DB; }
  .ls-bar.sel .b { background:#3B6FE0; }
  .ls-bar.sel .n { color:#1F2430; }
  .ls-lbl { display:flex; gap:8px; padding:0 16px 12px; }
  .ls-lbl span { flex:1; text-align:center; font-size:11px; color:#9AA1AC; white-space:nowrap; }
  .ls-lbl span.sel { color:#1F2430; font-weight:700; }
  .ls-num { text-align:right; white-space:nowrap; font-variant-numeric:tabular-nums; }
  .ls-sub { color:#9AA1AC; font-size:11.5px; }
  .ls-cur tr { cursor:pointer; }
  .ls-day { display:inline-flex; align-items:baseline; gap:2px; font-variant-numeric:tabular-nums; }
  .ls-day.over { color:#A50F22; font-weight:700; }
  .ls-prog { height:4px; border-radius:2px; background:#EEF0F3; margin-top:3px; overflow:hidden; width:70px; }
  .ls-prog i { display:block; height:100%; background:#22A55B; }
  .ls-prog.over i { background:#D92D3C; }
  .ls-mnav { display:flex; align-items:center; gap:6px; }
  .ls-mnav .m { min-width:140px; text-align:center; font-weight:700; font-size:14px; }
</style>
<c:set var="curCount" value="${fn:length(current)}"/>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-bar-chart"></i></span>
        <div>
          <h2>Моя статистика</h2>
          <span class="fm-count">${sessionScope.ENV.userName}</span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <div class="ls-mnav">
        <button type="button" class="fm-btn" title="Предыдущий месяц" onclick="lsGo('${prevYm}')"><i class="fa fa-chevron-left"></i></button>
        <span class="m">${selName}</span>
        <button type="button" class="fm-btn" title="Следующий месяц" onclick="lsGo('${nextYm}')" <c:if test="${empty nextYm}">disabled</c:if>><i class="fa fa-chevron-right"></i></button>
      </div>
    </div>
    <div class="fm-table-wrap" style="padding:0">
      <div class="ls-wrap">
        <div class="ls-kpi">
          <div class="main"><div class="k"><i class="fa fa-hospital-o"></i>На лечении сейчас</div><div class="v">${curCount}</div><div class="d">моих пациентов</div></div>
          <div><div class="k"><i class="fa fa-sign-in"></i>Поступили сегодня</div><div class="v">${admToday}</div></div>
          <div><div class="k"><i class="fa fa-sign-out"></i>Выписаны сегодня</div><div class="v">${disToday}</div></div>
          <div>
            <div class="k"><i class="fa fa-calendar"></i>Выписано за месяц</div>
            <div class="v">${selCount}</div>
            <c:set var="diff" value="${selCount - prevCount}"/>
            <div class="d ${diff > 0 ? 'up' : (diff < 0 ? 'down' : '')}">${diff > 0 ? '+' : ''}${diff} к прошлому месяцу</div>
          </div>
          <div><div class="k"><i class="fa fa-clock-o"></i>Койко-дней</div><div class="v"><fmt:formatNumber value="${selDays}" pattern="#,##0"/></div><div class="d">в среднем ${selAvg} на пациента</div></div>
          <div>
            <div class="k"><i class="fa fa-line-chart"></i>Выписано за год</div>
            <div class="v">${yearCount}</div>
            <div class="d">прошлый год: ${lastYearCount}</div>
          </div>
        </div>

        <div class="ls-grid">
          <div class="ls-col">
            <div class="hn-card">
              <div class="hn-card-h"><h3 style="flex:1">Выписано по месяцам</h3><span class="fm-count">за 12 месяцев · нажмите на месяц</span></div>
              <div class="ls-chart">
                <c:forEach items="${chart}" var="m">
                  <div class="ls-bar ${m.sel ? 'sel' : ''}" onclick="lsGo('${m.ym}')" title="${m.label}: выписано ${m.cnt}, койко-дней ${m.days}">
                    <span class="n">${m.cnt}</span><span class="b" style="height:${m.pct}%"></span>
                  </div>
                </c:forEach>
              </div>
              <div class="ls-lbl"><c:forEach items="${chart}" var="m"><span class="${m.sel ? 'sel' : ''}">${m.label}</span></c:forEach></div>
            </div>

            <div class="hn-card">
              <div class="hn-card-h"><h3 style="flex:1">${selName}: по типам палат</h3><span class="fm-count">выписанные пациенты</span></div>
              <table class="fm-grid">
                <thead>
                <tr>
                  <th>Тип палаты</th>
                  <th class="r" style="width:100px">Пациентов</th>
                  <th class="r" style="width:110px">Койко-дней</th>
                  <th class="r" style="width:140px">Резиденты</th>
                  <th class="r" style="width:140px">Нерезиденты</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${types}" var="t">
                  <tr>
                    <td><span class="nm">${t.name}</span></td>
                    <td class="ls-num"><b>${t.cnt}</b></td>
                    <td class="ls-num">${t.days}</td>
                    <td class="ls-num">${t.res} <span class="ls-sub">· ${t.resDays} к/д</span></td>
                    <td class="ls-num">${t.nonRes} <span class="ls-sub">· ${t.nonResDays} к/д</span></td>
                  </tr>
                </c:forEach>
                </tbody>
                <c:if test="${not empty types}">
                  <tfoot>
                  <tr style="font-weight:700; background:#FAFBFC">
                    <td>Итого</td>
                    <td class="ls-num">${selCount}</td>
                    <td class="ls-num">${selDays}</td>
                    <td class="ls-num">${selRes} <span class="ls-sub">· ${selResDays} к/д</span></td>
                    <td class="ls-num">${selCount - selRes} <span class="ls-sub">· ${selDays - selResDays} к/д</span></td>
                  </tr>
                  </tfoot>
                </c:if>
              </table>
              <c:if test="${empty types}"><div class="fm-empty" style="display:block"><i class="fa fa-calendar"></i>В этом месяце выписок нет</div></c:if>
            </div>
          </div>

          <div class="ls-col">
            <div class="hn-card">
              <div class="hn-card-h"><h3 style="flex:1">Мои пациенты сейчас</h3><span class="fm-count">${curCount}</span></div>
              <table class="fm-grid ls-cur">
                <thead><tr><th style="width:60px">ИБ</th><th>Пациент</th><th style="width:96px">День</th></tr></thead>
                <tbody>
                <c:forEach items="${current}" var="p">
                  <tr onclick="openMainPage('/lv/index.s?id=${p.id}', false)" title="Открыть историю болезни">
                    <td class="mut">${p.ib}</td>
                    <td><span class="nm">${fn:escapeXml(p.fio)}</span><div class="ls-sub">${p.room} · с ${p.begin}</div></td>
                    <td>
                      <span class="ls-day ${p.over ? 'over' : ''}">${p.day}<c:if test="${p.plan > 0}"><span class="ls-sub">&nbsp;из ${p.plan}</span></c:if></span>
                      <c:if test="${p.plan > 0}"><div class="ls-prog ${p.over ? 'over' : ''}"><i style="width:${p.day >= p.plan ? 100 : p.day * 100 / p.plan}%"></i></div></c:if>
                    </td>
                  </tr>
                </c:forEach>
                </tbody>
              </table>
              <c:if test="${empty current}"><div class="fm-empty" style="display:block"><i class="fa fa-hospital-o"></i>Сейчас пациентов нет</div></c:if>
            </div>

          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<script>
  function lsGo(ym) { if (ym) setPage('/view/stat.s?ym=' + ym); }
</script>
