<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Руководство -> Клиенты: карточка клиента (реквизиты только для просмотра и финансовый анализ). Грузится во вкладку boss.jsp. --%>
<style>
  .cv-page { --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    min-height:100%; box-sizing:border-box; padding:10px 14px 20px; background:var(--bg);
    font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:var(--text); }
  .cv-wrap { max-width:1400px; margin:0 auto; display:flex; flex-direction:column; gap:10px; }
  .cv-card { background:#fff; border:1px solid var(--border); border-radius:16px; box-shadow:0 1px 2px rgba(20,25,40,.04), 0 8px 24px rgba(20,25,40,.06); }
  .cv-head { display:flex; align-items:center; flex-wrap:wrap; gap:12px; padding:12px 16px; }
  .cv-ava { width:42px; height:42px; border-radius:12px; display:flex; align-items:center; justify-content:center; background:#EEF1F6; color:#3C4A63; font-size:18px; flex:none; }
  .cv-head h2 { margin:0; font-size:18px; font-weight:700; line-height:1.2; }
  .cv-sub { display:block; margin-top:2px; font-size:12.5px; color:var(--muted); }
  .cv-spacer { flex:1; }
  .cv-btn { height:30px; padding:0 12px; border:1px solid var(--border); border-radius:9px; background:#fff; color:#3C4250; font-size:12.5px; font-weight:600; font-family:inherit; cursor:pointer; }
  .cv-btn:hover { background:#F5F6F8; }
  .cv-tabs { display:flex; gap:2px; padding:0 12px; border-top:1px solid var(--border); }
  .cv-tabs button { height:40px; padding:0 14px; border:0; border-bottom:2px solid transparent; background:none; color:var(--muted); font-size:13px; font-weight:600; font-family:inherit; cursor:pointer; }
  .cv-tabs button.on { color:var(--text); border-bottom-color:#1F2430; }
  .cv-tabs button .n { margin-left:5px; padding:0 6px; border-radius:6px; background:#F1F2F4; color:var(--muted); font-size:11px; }
  .cv-tab { display:none; }
  .cv-tab.on { display:block; }

  .badge-seg { display:inline-flex; align-items:center; gap:5px; padding:2px 9px; border-radius:7px; font-size:12px; font-weight:600; line-height:18px; white-space:nowrap; vertical-align:middle; }
  .dot { width:8px; height:8px; border-radius:50%; display:inline-block; flex:none; }
  .s-VIP { background:#FFF4D6; color:#8A5A00; } .d-VIP { background:#E0A100; }
  .s-REGULAR { background:#E9F7EF; color:#1E7B43; } .d-REGULAR { background:#22A55B; }
  .s-NEW { background:#E8F1FD; color:#1F5FBF; } .d-NEW { background:#3B82F6; }
  .s-USUAL { background:#F1F2F4; color:#3C4250; } .d-USUAL { background:#9AA1AC; }
  .s-SLEEP { background:#F3EEFB; color:#6B3FA0; } .d-SLEEP { background:#8B5CF6; }
  .s-NONE { background:#F5F6F8; color:#9AA1AC; } .d-NONE { background:#D5D8DE; }

  .cv-kpis { display:grid; grid-template-columns:repeat(auto-fill, minmax(170px, 1fr)); gap:10px; }
  .cv-kpi { padding:12px 14px; }
  .cv-kpi .l { font-size:12px; font-weight:600; color:var(--muted); }
  .cv-kpi .v { margin-top:3px; font-size:20px; font-weight:700; font-variant-numeric:tabular-nums; white-space:nowrap; }
  .cv-kpi .h { margin-top:2px; font-size:12px; color:var(--muted); }
  .up { color:#1E7B43; font-weight:600; } .down { color:#A50F22; font-weight:600; }
  .cv-split { display:flex; height:6px; margin-top:8px; border-radius:4px; overflow:hidden; background:#F1F2F4; }
  .cv-split .a { background:#3B82F6; } .cv-split .b { background:#8B5CF6; }

  .cv-grid2 { display:grid; grid-template-columns:repeat(auto-fit, minmax(420px, 1fr)); gap:10px; }
  .cv-sec { padding:14px 16px; }
  .cv-sec h3 { margin:0 0 12px; font-size:14px; font-weight:700; }
  .cv-sec h3 .h { margin-left:6px; font-size:12px; font-weight:400; color:var(--muted); }
  .cv-chart { display:flex; align-items:flex-end; gap:6px; height:150px; padding-top:18px; }
  .cv-col { flex:1; display:flex; flex-direction:column; align-items:center; justify-content:flex-end; height:100%; min-width:0; }
  .cv-bar { width:100%; max-width:34px; border-radius:6px 6px 2px 2px; background:#1F2430; opacity:.85; position:relative; }
  .cv-bar:hover { opacity:1; }
  .cv-bar.zero { height:2px !important; background:#E6E8EC; }
  .cv-col .lb { margin-top:6px; font-size:11px; color:var(--muted); white-space:nowrap; }
  .cv-rows .rw { display:grid; grid-template-columns:minmax(0, 1fr) auto; gap:4px 12px; padding:6px 0; font-size:13px; }
  .cv-rows .rw .nm { overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
  .cv-rows .rw .sm { font-weight:600; font-variant-numeric:tabular-nums; text-align:right; white-space:nowrap; }
  .cv-rows .rw .sm span { margin-left:6px; color:var(--muted); font-weight:400; font-size:12px; }
  .cv-rows .rw .tr { grid-column:1 / -1; height:6px; border-radius:4px; background:#F1F2F4; overflow:hidden; }
  .cv-rows .rw .tr i { display:block; height:100%; border-radius:4px; background:#3C4A63; }
  .cv-muted { color:var(--muted); font-size:13px; }

  table.cv-t { width:100%; border-collapse:separate; border-spacing:0; font-size:13px; }
  table.cv-t th { height:30px; padding:0 8px; background:#F8F9FA; border-bottom:1px solid var(--border); color:var(--muted); font-size:11px; font-weight:600; text-transform:uppercase; letter-spacing:.3px; text-align:left; }
  table.cv-t td { height:34px; padding:0 8px; border-bottom:1px solid #F0F1F4; font-variant-numeric:tabular-nums; }
  table.cv-t tr.go { cursor:pointer; }
  table.cv-t tr.go:hover td { background:#F8F9FB; }
  table.cv-t .r { text-align:right; }
  .tp { display:inline-block; padding:0 7px; border-radius:6px; font-size:11.5px; font-weight:600; line-height:18px; }
  .tp.AMB { background:#E8F1FD; color:#1F5FBF; } .tp.STAT { background:#F3EEFB; color:#6B3FA0; }
  .cv-tab .panel { margin-bottom:10px; }
</style>

<div class="cv-page">
<div class="cv-wrap">

  <div class="cv-card">
    <div class="cv-head">
      <span class="cv-ava"><i class="fa fa-user"></i></span>
      <div>
        <h2>${fn:escapeXml(client.surname)} ${fn:escapeXml(client.name)} ${fn:escapeXml(client.middlename)}
          <c:if test="${not empty fin}"><span class="badge-seg s-${fin.segment}" title="${fn:escapeXml(fin.segmentHint)}"><span class="dot d-${fin.segment}"></span>${fin.segmentName}</span></c:if>
        </h2>
        <span class="cv-sub">ID ${client.id}<c:if test="${not empty client.birthdate}"> · <fmt:formatDate pattern="dd.MM.yyyy" value="${client.birthdate}"/></c:if><c:if test="${not empty client.tel}"> · ${fn:escapeXml(client.tel)}</c:if><c:if test="${client.flag == 'DONE'}"> · <i class="fa fa-check-circle" style="color:#22A55B"></i> реквизиты проверены</c:if></span>
      </div>
      <span class="cv-spacer"></span>
      <button type="button" class="cv-btn" onclick="bossCl('/boss/clients/list.s')"><i class="fa fa-arrow-left"></i> Назад</button>
    </div>
    <div class="cv-req">
      <div><span>Дата рождения</span><b><c:choose><c:when test="${not empty client.birthdate}"><fmt:formatDate pattern="dd.MM.yyyy" value="${client.birthdate}"/></c:when><c:otherwise>${empty client.birthyear ? '—' : client.birthyear}</c:otherwise></c:choose></b></div>
      <div><span>Пол</span><b>${empty client.sex ? '—' : client.sex.name}</b></div>
      <div><span>Телефон</span><b>${empty client.tel ? '—' : fn:escapeXml(client.tel)}</b></div>
      <div><span>Паспорт</span><b>${empty client.docNum ? '—' : fn:escapeXml(client.docSeria)} ${fn:escapeXml(client.docNum)}</b></div>
      <div><span>Резиденство</span><b>${empty client.country ? '—' : client.country.name}<c:if test="${not empty client.region}">, ${client.region.name}</c:if></b></div>
      <div><span>Адрес</span><b>${empty client.address ? '—' : fn:escapeXml(client.address)}</b></div>
      <div><span>Карточка создана</span><b><c:choose><c:when test="${not empty client.crOn}"><fmt:formatDate pattern="dd.MM.yyyy" value="${client.crOn}"/></c:when><c:otherwise>—</c:otherwise></c:choose></b></div>
    </div>
  </div>

  <div>
    <c:choose>
      <c:when test="${empty fin}">
        <div class="cv-card cv-sec cv-muted">Не удалось посчитать финансовый анализ, подробности в логе сервера.</div>
      </c:when>
      <c:otherwise>
        <div class="cv-kpis">
          <div class="cv-card cv-kpi" title="${fin.total}">
            <div class="l">Всего оплачено</div>
            <div class="v">${fin.totalShort}</div>
            <div class="cv-split" title="Амбулатория ${fin.ambPaid} / Стационар ${fin.statPaid}"><div class="a" style="width:${fin.ambPct}%"></div><div class="b" style="width:${100 - fin.ambPct}%"></div></div>
            <div class="h"><span style="color:#1F5FBF">●</span> амб ${fin.ambPaid} · <span style="color:#6B3FA0">●</span> стац ${fin.statPaid}</div>
          </div>
          <div class="cv-card cv-kpi">
            <div class="l">За последние 12 мес</div>
            <div class="v">${fin.paid12}</div>
            <div class="h">
              <c:choose>
                <c:when test="${empty fin.trend}">нет данных за прошлый год</c:when>
                <c:when test="${fin.trend >= 0}"><span class="up">▲ ${fin.trend}%</span> к прошлым 12 мес</c:when>
                <c:otherwise><span class="down">▼ ${-fin.trend}%</span> к прошлым 12 мес</c:otherwise>
              </c:choose>
            </div>
          </div>
          <div class="cv-card cv-kpi">
            <div class="l">Визитов</div>
            <div class="v">${fin.visitCount}</div>
            <div class="h">${fin.ambCount} амбулатория · ${fin.statCount} стационар</div>
          </div>
          <div class="cv-card cv-kpi">
            <div class="l">Средний чек за визит</div>
            <div class="v">${fin.avgCheck}</div>
            <div class="h"><c:choose><c:when test="${not empty fin.avgInterval}">приходит в среднем раз в ${fin.avgInterval} дн.</c:when><c:otherwise>один визит</c:otherwise></c:choose></div>
          </div>
          <div class="cv-card cv-kpi">
            <div class="l">Последний визит</div>
            <div class="v">${empty fin.last ? '—' : fin.last}</div>
            <div class="h"><c:if test="${not empty fin.daysSinceLast}">${fin.daysSinceLast} дн. назад · </c:if>первый ${empty fin.first ? '—' : fin.first}</div>
          </div>
          <div class="cv-card cv-kpi">
            <div class="l">Место по сумме оплат</div>
            <div class="v"><c:choose><c:when test="${not empty fin.place}">${fin.place}</c:when><c:otherwise>—</c:otherwise></c:choose></div>
            <div class="h"><c:if test="${not empty fin.place}">из ${fin.placeOf} · топ ${fin.topPct}%</c:if><c:if test="${empty fin.place}">оплат нет</c:if></div>
          </div>
          <div class="cv-card cv-kpi">
            <div class="l">Возвраты / скидки</div>
            <div class="v" style="font-size:16px">${fin.returns} / ${fin.discounts}</div>
            <div class="h">возвращено клиенту / скидки кассы</div>
          </div>
        </div>

        <div class="cv-grid2" style="margin-top:10px">
          <div class="cv-card cv-sec">
            <h3>Оплаты по месяцам<span class="h">последние 12 месяцев</span></h3>
            <c:choose>
              <c:when test="${fin.hasMonths}">
                <div class="cv-chart">
                  <c:forEach items="${fin.months}" var="mo">
                    <div class="cv-col" title="${mo.label}: ${mo.value}">
                      <div class="cv-bar ${mo.pct == 0 ? 'zero' : ''}" style="height:${mo.pct}%"></div>
                      <span class="lb">${mo.label}</span>
                    </div>
                  </c:forEach>
                </div>
              </c:when>
              <c:otherwise><div class="cv-muted">За последние 12 месяцев оплат не было.</div></c:otherwise>
            </c:choose>
          </div>
          <div class="cv-card cv-sec">
            <h3>Способы оплаты</h3>
            <c:if test="${empty fin.methods}"><div class="cv-muted">Оплат нет.</div></c:if>
            <div class="cv-rows">
              <c:forEach items="${fin.methods}" var="pm">
                <div class="rw"><span class="nm">${pm.name}</span><span class="sm">${pm.sum}<span>${pm.pct}%</span></span><div class="tr"><i style="width:${pm.pct}%"></i></div></div>
              </c:forEach>
            </div>
          </div>
          <div class="cv-card cv-sec">
            <h3>Направления амбулатории<span class="h">стоимость оказанных услуг</span></h3>
            <c:if test="${empty fin.groups}"><div class="cv-muted">Амбулаторных услуг не было.</div></c:if>
            <div class="cv-rows">
              <c:forEach items="${fin.groups}" var="g">
                <div class="rw"><span class="nm" title="${fn:escapeXml(g.name)}">${fn:escapeXml(g.name)} <span class="cv-muted">· ${g.count}</span></span><span class="sm">${g.sum}<span>${g.pct}%</span></span><div class="tr"><i style="width:${g.pct}%"></i></div></div>
              </c:forEach>
            </div>
          </div>
          <div class="cv-card cv-sec">
            <h3>Частые услуги</h3>
            <c:if test="${empty fin.services}"><div class="cv-muted">Амбулаторных услуг не было.</div></c:if>
            <table class="cv-t">
              <c:forEach items="${fin.services}" var="sv">
                <tr><td>${fn:escapeXml(sv.name)}</td><td class="r cv-muted" style="width:60px">${sv.count} раз</td><td class="r" style="width:120px;font-weight:600">${sv.sum}</td></tr>
              </c:forEach>
            </table>
          </div>
        </div>

        <div class="cv-card cv-sec" style="margin-top:10px">
          <h3>История визитов<span class="h">с оплатами по каждому визиту</span></h3>
          <c:if test="${empty fin.visits}"><div class="cv-muted">Визитов нет.</div></c:if>
          <c:if test="${not empty fin.visits}">
            <table class="cv-t">
              <thead><tr><th style="width:40px">#</th><th style="width:200px">Дата</th><th style="width:110px">Тип</th><th>Детали</th><th style="width:170px">Состояние</th><th class="r" style="width:140px">Оплачено</th></tr></thead>
              <tbody>
              <c:forEach items="${fin.visits}" var="v" varStatus="lp">
                <tr>
                  <td class="cv-muted">${lp.index + 1}</td>
                  <td>${v.dateStr}</td>
                  <td><span class="tp ${v.type}">${v.type == 'AMB' ? 'Амбулатория' : 'Стационар'}</span></td>
                  <td class="cv-muted">${fn:escapeXml(v.info)}</td>
                  <td>${v.state}</td>
                  <td class="r" style="font-weight:600">${v.paid}</td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </c:if>
        </div>
      </c:otherwise>
    </c:choose>
  </div>

</div>
</div>
<style>
  #bossClients .cv-page { padding:0; background:transparent; min-height:0; }
  .cv-req { display:grid; grid-template-columns:repeat(auto-fill, minmax(190px, 1fr)); gap:10px 16px; padding:12px 16px; border-top:1px solid var(--border); font-size:13px; }
  .cv-req span { display:block; font-size:11.5px; color:var(--muted); }
  .cv-req b { font-weight:600; }
</style>
