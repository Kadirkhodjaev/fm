/*
 * Модуль «Руководство и учредители» для Farhod Madad Shifo.
 * Каждая вкладка грузит свои данные отдельно, когда её открывают: POST на /boss/data.s?tab=<вкладка>
 * с полями from, to, prevFrom, prevTo в теле запроса. Сервер отвечает JSON-объектом (формат в README.md и data/*.json).
 * Ответ кэшируется до смены периода, поэтому повторное открытие вкладки запроса не делает.
 * Все суммы в JSON приходят в сумах, на экране показываются в тыс. сум.
 * Держите файл отдельным .js: внутри JSP запись ${...} будет съедена EL.
 *
 * Запуск: FmsRuk.init(document.getElementById('fmsRuk'), {
 *   urls: null,                      // свой адрес для вкладки, например { drug: '/boss/drug.s' }; по умолчанию /boss/data.s?tab=<вкладка>
 *   today: '30.09.2026',             // сегодняшняя дата сервера
 *   dataFrom: '01.10.2025',          // с какой даты есть данные
 *   mock: null                       // функция (вкладка, поля) с примером данных, только для предпросмотра
 * });
 */
(function (w) {
  'use strict';
  const P = w.FmsRukPicker;
  const fmt = (n, d = 0) => (n == null || isNaN(n) ? '—' : n.toLocaleString('ru-RU', { minimumFractionDigits: d, maximumFractionDigits: d }));
  const pct = (n, d = 1) => fmt(n, d) + '%';
  const esc = s => String(s == null ? '' : s).replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
  const tys = v => (v == null ? null : v / 1e3);
  const sumBy = (a, k) => a.reduce((q, x) => q + (+x[k] || 0), 0);  // the server may send numbers as strings
  const MONTHS = ['янв','фев','мар','апр','май','июн','июл','авг','сен','окт','ноя','дек'];
  const MONTHS_FULL = ['январь','февраль','март','апрель','май','июнь','июль','август','сентябрь','октябрь','ноябрь','декабрь'];

  // ---- Общие элементы ----
  function delta(cur, prev, good = true) {
    if (prev == null || !prev) return '';
    const d = (cur - prev) / prev * 100, up = d >= 0;
    const cls = good === 'neu' ? 'neu' : (up === good ? 'good' : 'bad');
    return `<span class="chip ${cls}">${up ? '▲' : '▼'} ${pct(Math.abs(d))}</span>`;
  }
  function spark(arr, col) {
    if (!arr || arr.length < 2) return '';
    const W = 120, H = 28, mn = Math.min(...arr), mx = Math.max(...arr);
    const p = arr.map((v, i) => [i * (W / (arr.length - 1)), H - 3 - (v - mn) / (mx - mn || 1) * (H - 6)]);
    const last = p[p.length - 1];
    return `<svg class="spark" viewBox="0 0 ${W} ${H}" preserveAspectRatio="none"><path d="${p.map((q, i) => (i ? 'L' : 'M') + q[0].toFixed(1) + ' ' + q[1].toFixed(1)).join('')}" fill="none" stroke="${col}" stroke-width="1.6" vector-effect="non-scaling-stroke"/><circle cx="${last[0]}" cy="${last[1]}" r="2.5" fill="${col}"/></svg>`;
  }
  function hbars(el, rows, max) {
    max = max || Math.max(...rows.map(r => r.v), 1);
    el.innerHTML = rows.map(r => `<div class="t" title="${esc(r.t)}">${esc(r.t)}</div><div class="tr" data-tip="<b>${esc(r.t)}</b><br>${esc(r.tip || r.lbl || fmt(r.v))}"><div class="f ${r.cls || ''}" style="width:${(r.v / max * 100).toFixed(1)}%"></div></div><div class="v num">${r.lbl || fmt(r.v)}</div>`).join('');
  }
  // Таблица с сортировкой по клику на заголовок числового столбца
  function sortable(el, cols, rows, totals) {
    let key = cols[cols.length - 1].k, dir = -1;
    const col = k => cols.find(c => c.k === k);
    function draw() {
      const rs = rows.slice().sort((a, b) => { const A = col(key).get(a), B = col(key).get(b); return (A > B ? 1 : A < B ? -1 : 0) * dir; });
      el.innerHTML = `<thead><tr>${cols.map(c => `<th class="${c.num ? 'sort' : 'l'}" data-k="${c.k}" ${c.num ? 'tabindex="0"' : ''}>${c.h}${c.k === key ? (dir < 0 ? ' ↓' : ' ↑') : ''}</th>`).join('')}</tr></thead>` +
        `<tbody>${rs.map(r => `<tr>${cols.map(c => `<td class="${c.num ? 'num' : 'l'}">${c.fmt ? c.fmt(c.get(r), r) : esc(c.get(r))}</td>`).join('')}</tr>`).join('')}${totals ? `<tr class="tot">${totals(rows)}</tr>` : ''}</tbody>`;
      el.querySelectorAll('th.sort').forEach(th => {
        const go = () => { const kk = th.dataset.k; if (kk === key) dir = -dir; else { key = kk; dir = -1; } draw(); };
        th.onclick = go;
        th.onkeydown = e => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); go(); } };
      });
    }
    draw();
  }

  // Подсказка одна на документ
  function tipEl() {
    let t = document.querySelector('.fms-ruk-tip');
    if (!t) { t = document.createElement('div'); t.className = 'fms-ruk-tip'; t.hidden = true; document.body.appendChild(t); }
    return t;
  }
  function showTip(html, x, y) {
    const tip = tipEl(); tip.innerHTML = html; tip.hidden = false;
    const tw = tip.offsetWidth, th = tip.offsetHeight;
    let L = x + 14, T = y + 14;
    if (L + tw > innerWidth - 8) L = x - tw - 14;
    if (T + th > innerHeight - 8) T = y - th - 14;
    tip.style.left = L + 'px'; tip.style.top = T + 'px';
  }
  function hideTip() { tipEl().hidden = true; }

  function init(root, opts) {
    opts = opts || {};
    const q = k => root.querySelector(`[data-rk="${k}"]`);
    const today = P.parse(opts.today) || new Date(new Date().setHours(0, 0, 0, 0));
    const min = P.parse(opts.dataFrom) || P.addD(today, -365);
    let from = new Date(today.getFullYear(), today.getMonth(), 1), to = today, prev = null, curL = '', prevL = '', active = 'sum';
    const cache = {};     // вкладка -> { key, data }: что уже загружено для текущего периода
    const pending = {};   // вкладка -> ключ периода, который сейчас грузится

    q('sample').hidden = !opts.mock;

    const RENDER = {
      sum: d => { renderSummary(d); renderTrend(d); renderActs(d); },
      cash: d => renderCash(d),
      stat: d => renderStat(d),
      amb: d => renderAmb(d),
      drug: d => renderDrugs(d),
      doc: d => renderDocs(d)
    };
    const panel = t => root.querySelector(`[data-panel="${t}"]`);
    const urlOf = t => (opts.urls && opts.urls[t]) || '/boss/data.s?tab=' + t;

    // ---- Вкладки ----
    function openTab(t) {
      active = t;
      root.querySelectorAll('.tabs button').forEach(b => b.setAttribute('aria-selected', String(b.dataset.t === t)));
      root.querySelectorAll('[data-panel]').forEach(p => { p.hidden = p.dataset.panel !== t; });
      try { localStorage.setItem('fms-ruk-tab', t); } catch (e) { /* без localStorage вкладка просто не запоминается */ }
      q('error').hidden = true;
      load(t);
    }
    root.querySelectorAll('.tabs button').forEach(b => { b.onclick = () => openTab(b.dataset.t); });

    root.addEventListener('mousemove', e => {
      const t = e.target.closest('[data-tip]');
      if (t) showTip(t.dataset.tip, e.clientX, e.clientY);
      else if (!e.target.closest('[data-rk="trend"]')) hideTip();
    });
    root.addEventListener('mouseleave', hideTip);

    // ---- Загрузка данных ----
    function params() {
      return { from: P.format(from), to: P.format(to), prevFrom: prev ? P.format(prev[0]) : '', prevTo: prev ? P.format(prev[1]) : '' };
    }
    const keyOf = pr => [pr.from, pr.to, pr.prevFrom, pr.prevTo].join('|');
    // POST как у форм: application/x-www-form-urlencoded, в Spring читается через @RequestParam
    function post(t, pr) {
      if (opts.mock) return new Promise(res => setTimeout(() => res(opts.mock(t, pr)), 250));
      const body = Object.keys(pr).filter(k => pr[k]).map(k => k + '=' + encodeURIComponent(pr[k])).join('&');
      return fetch(urlOf(t), {
        method: 'POST', credentials: 'same-origin', body,
        headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8', Accept: 'application/json', 'X-Requested-With': 'XMLHttpRequest' }
      }).then(r => {
        if (!r.ok) throw new Error('сервер ответил ' + r.status);
        // Текстом, чтобы принять и JSONObject.toString() с типом text/html
        return r.text().then(txt => {
          let d;
          try { d = JSON.parse(txt); } catch (e) { throw new Error('ответ не в формате JSON'); }
          if (d && d.error) throw new Error(d.error);   // сервер может вернуть {"error": "текст"}
          return d;
        });
      });
    }
    function setState() {
      const loading = pending[active] != null;
      root.classList.toggle('is-loading', loading);
      q('loading').hidden = !loading;
    }
    function load(t) {
      if (!RENDER[t]) return;
      const pr = params(), key = keyOf(pr);
      if ((cache[t] && cache[t].key === key) || pending[t] === key) { setState(); return; }
      pending[t] = key;
      if (t === active) q('error').hidden = true;
      setState();
      post(t, pr)
        .then(d => {
          if (keyOf(params()) !== key) return;          // период уже сменили, ответ устарел
          cache[t] = { key, data: d };
          panel(t).classList.remove('stale');
          RENDER[t](d);
        })
        .catch(e => {
          if (keyOf(params()) !== key) return;
          panel(t).classList.add('stale');                // не показываем цифры другого периода под новой подписью
          if (t !== active) return;
          q('errorText').textContent = 'Не удалось загрузить данные вкладки: ' + e.message + '.';
          q('error').hidden = false;
        })
        .then(() => { if (pending[t] === key) delete pending[t]; setState(); });
    }
    q('retry').onclick = () => { q('error').hidden = true; load(active); };

    function setPeriod(a, b) {
      from = a; to = b;
      prev = P.prevPeriod(from, to, today, min);
      curL = P.label(from, to); prevL = prev ? P.label(prev[0], prev[1]) : 'нет данных';
      q('periodLabel').textContent = curL;
      q('prevLabel').textContent = prevL;
    }
    setPeriod(from, to);
    // Смена периода: кэш остальных вкладок устаревает сам по ключу, грузится только открытая вкладка
    P.make(q('period'), { today, min, max: today, from, to, preset: 'month', onChange: (a, b) => { setPeriod(a, b); q('error').hidden = true; load(active); } });

    // Производные показатели для сравнения
    // Месяцы по возрастанию, последние 12, в каком бы порядке их ни прислал сервер
    function months(d) {
      return (d.months || []).slice().sort((a, b) => (a.ym < b.ym ? -1 : a.ym > b.ym ? 1 : 0)).slice(-12);
    }

    function derive(s) {
      if (!s) return null;
      // Поле, которого нет в ответе, показывается прочерком, а не NaN
      const n = v => (v == null || v === '' || isNaN(v) ? null : +v);
      // «Стационар по актам» — к оплате по актам (total_sum), если сервер его прислал, иначе stat
      const cash = n(s.cash), stat = n(s.total_sum) != null ? n(s.total_sum) : n(s.stat), amb = n(s.amb), discharged = n(s.discharged), ambRegs = n(s.ambRegs);
      return {
        cash, stat, amb, drugs: n(s.drugs), discharged, ambRegs,
        cashDisc: n(s.cash_discount), disSum: n(s.dis_sum),
        chkStat: stat != null && discharged ? stat / discharged : null,
        chkAmb: amb != null && ambRegs ? amb / ambRegs : null,
        // Доля стационара в кассе: всё, что пришло в кассу, кроме амбулатории
        statShare: cash && amb != null ? (cash - amb) / cash * 100 : null
      };
    }

    function renderSummary(d) {
      const c = derive(d.summary.cur), p = derive(d.summary.prev);
      const B = d.beds, occ = B.total ? B.occupied / B.total : 0;
      const items = [
        { lab: 'Поступления в кассу', val: fmt(tys(c.cash)), u: 'тыс.', meta: delta(c.cash, p && p.cash), was: p && fmt(tys(p.cash)) + ' тыс.', sp: spark(months(d).map(m => m.stat + m.amb), 'var(--s1)') },
        { lab: 'Средний чек стационара', val: fmt(tys(c.chkStat)), u: 'тыс.', meta: `${delta(c.chkStat, p && p.chkStat)} сумма акта на пациента`, was: p && fmt(tys(p.chkStat)) + ' тыс.' },
        { lab: 'Выписано из стационара', val: fmt(c.discharged), u: 'чел.', meta: `${delta(c.discharged, p && p.discharged)} акты ${fmt(tys(c.stat))} тыс.`, was: p && fmt(p.discharged) + ' чел.', sp: spark(months(d).map(m => m.discharged), 'var(--s1)') },
        { lab: 'Амбулаторные регистрации', val: fmt(c.ambRegs), u: '', meta: `${delta(c.ambRegs, p && p.ambRegs)} ${fmt(tys(c.amb))} тыс.`, was: p && fmt(p.ambRegs), sp: spark(months(d).map(m => m.ambRegs), 'var(--s2)') },
        { lab: 'Койки заняты', val: `${B.occupied} из ${B.total}`, u: '', meta: `<span class="chip ${occ > .85 ? 'warn' : 'neu'}">${pct(occ * 100, 0)}</span> брони ${B.booked}` },
        { lab: 'Долг по открытым актам', val: fmt(tys(d.debts.sum)), u: 'тыс.', meta: `<span class="chip bad">${fmt(d.debts.count)} ${plural(d.debts.count, 'акт', 'акта', 'актов')}</span>` }
      ];
      q('kpis').innerHTML = items.map(i => `<div class="kpi"><div class="lab">${i.lab}</div><div class="val num">${i.val}<small>${i.u}</small></div><div class="meta num">${i.meta}</div>${i.was ? `<div class="was num">было ${i.was}</div>` : ''}${i.sp || ''}</div>`).join('');

      // Таблица «Сейчас и в прошлом периоде». Строка: [название, ключ, единица, знаков, как красить изменение]
      const rows = [
        ['Деньги'],
        ['Поступления в кассу', 'cash', 'тыс.'], ['Стационар по актам', 'stat', 'тыс.'], ['Амбулатория', 'amb', 'тыс.'], ['Медикаменты по цене аптеки', 'drugs', 'тыс.', 0, 'neu'],
        ['Скидки в кассе', 'cashDisc', 'тыс.', 0, false], ['Скидки по актам стационара', 'disSum', 'тыс.', 0, false],
        ['Пациенты'],
        ['Выписано из стационара', 'discharged', 'чел.'], ['Амбулаторные регистрации', 'ambRegs', ''],
        ['Средний чек'],
        ['Стационар, на пациента', 'chkStat', 'тыс.'], ['Амбулатория, на регистрацию', 'chkAmb', 'тыс.'], ['Доля стационара в поступлениях', 'statShare', '%', 1, 'pp']
      ];
      // Скидки показываем, только если сервер их прислал
      const OPTIONAL = { cashDisc: 1, disSum: 1 };
      const scale = u => u === 'тыс.' ? tys : (v => v);
      q('cmp').innerHTML = `<thead><tr><th>Показатель</th><th>${esc(curL)}</th><th>${esc(prevL)}</th><th>Разница</th><th>Изменение</th></tr></thead><tbody>` +
        rows.filter(([, k]) => !OPTIONAL[k] || c[k] != null).map(([n, k, u, dg = 0, how = true]) => {
          if (!k) return `<tr class="grp"><td colspan="5">${n}</td></tr>`;
          const s = scale(u), v = c[k] == null ? null : s(c[k]), pv = p && p[k] != null ? s(p[k]) : null, df = pv == null || v == null ? null : v - pv;
          const f = x => (x == null ? '—' : fmt(x, dg) + (u === '%' ? '%' : ''));
          const sign = x => (x >= 0 ? '+' : '−') + fmt(Math.abs(x), dg);
          const ch = pv == null || v == null ? '—' : how === 'pp' ? `<span class="chip neu">${sign(df)} п.п.</span>` : delta(v, pv, how);
          return `<tr><td class="wrap">${n}${u && u !== '%' ? ` <span class="hint">${u}</span>` : ''}</td><td class="num"><b>${f(v)}</b></td><td class="num">${pv == null ? '—' : f(pv)}</td><td class="num">${df == null ? '—' : sign(df)}</td><td class="num">${ch}</td></tr>`;
        }).join('') + '</tbody>';
      q('cmpSub').textContent = p ? `${curL} рядом с периодом ${prevL}.` : `Для выбранного периода нет данных за прошлый период: данные есть с ${P.format(min)}.`;
    }

    // График по месяцам: выбранный период залит серым, прошлый обведён пунктиром
    function renderTrend(d) {
      const svg = q('trend'), W = 1200, H = 250, m = { l: 72, r: 16, t: 12, b: 28 }, ms = months(d), n = ms.length;
      if (!n) { svg.innerHTML = ''; return; }
      const stat = ms.map(x => tys(x.stat)), amb = ms.map(x => tys(x.amb));
      const top = Math.max(...stat, ...amb, 1), mag = Math.pow(10, Math.floor(Math.log10(top / 4))), stepV = Math.ceil(top / 4 / mag) * mag, mx = stepV * 4;
      const step = (W - m.l - m.r) / Math.max(1, n - 1);
      const x = i => m.l + i * step, y = v => H - m.b - v / mx * (H - m.t - m.b);
      const ym = dt => dt.getFullYear() * 12 + dt.getMonth();
      const idx = ms.map(x => { const [yy, mm] = x.ym.split('-').map(Number); return yy * 12 + mm - 1; });
      const inRange = (a, b) => idx.map((v, i) => v >= ym(a) && v <= ym(b) ? i : -1).filter(i => i >= 0);
      const band = (ix, fill, extra, text, bold) => ix.length ? `<rect x="${Math.max(m.l - step / 2, x(ix[0]) - step / 2)}" y="${m.t}" width="${ix.length * step}" height="${H - m.t - m.b}" fill="${fill}" ${extra}/><text x="${x(ix[0]) - step / 2 + 6}" y="${m.t + 14}" ${bold ? 'style="fill:var(--ink-2);font-weight:600"' : ''}>${text}</text>` : '';
      const sel = inRange(from, to);
      const ps = prev ? inRange(prev[0], prev[1]).filter(i => sel.indexOf(i) < 0) : [];
      let s = band(sel, 'var(--hover-bg)', '', 'сейчас', true) + band(ps, 'var(--surface-2)', 'stroke="var(--line)" stroke-dasharray="4 3"', 'прошлый');
      for (let v = 0; v <= mx; v += stepV) s += `<line x1="${m.l}" x2="${W - m.r}" y1="${y(v)}" y2="${y(v)}" stroke="var(--line-soft)"/><text x="${m.l - 8}" y="${y(v) + 4}" text-anchor="end">${fmt(v)}</text>`;
      s += idx.map((v, i) => `<text x="${x(i)}" y="${H - 8}" text-anchor="middle">${MONTHS[v % 12]}</text>`).join('');
      const path = a => a.map((v, i) => (i ? 'L' : 'M') + x(i).toFixed(1) + ' ' + y(v).toFixed(1)).join('');
      const dots = i => `<circle cx="${x(i)}" cy="${y(stat[i])}" r="4" fill="var(--s1)" stroke="var(--surface)" stroke-width="2"/><circle cx="${x(i)}" cy="${y(amb[i])}" r="4" fill="var(--s2)" stroke="var(--surface)" stroke-width="2"/>`;
      s += `<path d="${path(amb)}" fill="none" stroke="var(--s2)" stroke-width="2"/><path d="${path(stat)}" fill="none" stroke="var(--s1)" stroke-width="2"/>${dots(n - 1)}`;
      s += `<line data-x="h" y1="${m.t}" y2="${H - m.b}" stroke="var(--faint)" stroke-dasharray="3 3" visibility="hidden"/><g data-x="d"></g><rect data-x="hit" x="${m.l}" y="${m.t}" width="${W - m.l - m.r}" height="${H - m.t - m.b}" fill="transparent"/>`;
      svg.innerHTML = s;
      const hit = svg.querySelector('[data-x="hit"]'), xh = svg.querySelector('[data-x="h"]'), xd = svg.querySelector('[data-x="d"]');
      hit.addEventListener('mousemove', e => {
        const b = svg.getBoundingClientRect(), px = (e.clientX - b.left) / b.width * W, i = Math.max(0, Math.min(n - 1, Math.round((px - m.l) / step)));
        xh.setAttribute('x1', x(i)); xh.setAttribute('x2', x(i)); xh.setAttribute('visibility', 'visible');
        xd.innerHTML = dots(i);
        showTip(`<b>${MONTHS_FULL[idx[i] % 12]} ${Math.floor(idx[i] / 12)}</b><div class="r"><span><i style="background:var(--s1)"></i>Стационар</span><span>${fmt(stat[i])}</span></div><div class="r"><span><i style="background:var(--s2)"></i>Амбулатория</span><span>${fmt(amb[i])}</span></div><div class="r"><span>Всего</span><span>${fmt(stat[i] + amb[i])}</span></div>`, e.clientX, e.clientY);
      });
      hit.addEventListener('mouseleave', () => { xh.setAttribute('visibility', 'hidden'); xd.innerHTML = ''; hideTip(); });
    }

    function renderActs(d) {
      const a = d.actSections, tc = sumBy(a, 'cur'), hasPrev = a.some(x => x.prev != null), tp = hasPrev ? sumBy(a, 'prev') : null;
      q('acts').innerHTML = `<thead><tr><th>Раздел акта</th><th>${esc(curL)}</th><th>Доля</th><th>${esc(hasPrev ? prevL : 'Прошлый период')}</th><th>Изменение</th></tr></thead><tbody>` +
        a.map(x => `<tr><td>${esc(x.name)}</td><td class="num"><b>${fmt(tys(x.cur))}</b></td><td class="num">${tc ? pct(x.cur / tc * 100, 0) : '—'}</td><td class="num">${x.prev == null ? '—' : fmt(tys(x.prev))}</td><td class="num">${x.prev == null ? '—' : delta(x.cur, x.prev)}</td></tr>`).join('') +
        `<tr class="tot"><td>Итого по актам</td><td class="num">${fmt(tys(tc))}</td><td class="num">100%</td><td class="num">${tp == null ? '—' : fmt(tys(tp))}</td><td class="num">${tp == null ? '—' : delta(tc, tp)}</td></tr>` +
        actsNet(d, tc, tp) + '</tbody>';
    }

    // Если сервер прислал скидки по актам (dis_sum), показываем их и сумму к оплате = итог − скидки
    function actsNet(d, tc, tp) {
      const S = d.summary || {}, dc = S.cur && S.cur.dis_sum, dp = S.prev && S.prev.dis_sum;
      if (dc == null) return '';
      const nc = tc - dc, np = tp == null || dp == null ? null : tp - dp;
      const m1 = v => (v ? '−' + fmt(tys(v)) : '0');
      return `<tr><td>Скидки по актам</td><td class="num">${m1(dc)}</td><td class="num">${tc ? pct(dc / tc * 100, 1) : '—'}</td><td class="num">${dp == null ? '—' : m1(dp)}</td><td class="num"></td></tr>` +
        `<tr class="tot"><td>К оплате по актам</td><td class="num">${fmt(tys(nc))}</td><td class="num"></td><td class="num">${np == null ? '—' : fmt(tys(np))}</td><td class="num">${np == null ? '—' : delta(nc, np)}</td></tr>`;
    }

    function renderCash(d) {
      const c = d, pt = sumBy(c.payTypes, 'sum');
      hbars(q('pay'), c.payTypes.map(x => ({ t: x.name, v: x.sum, lbl: fmt(tys(x.sum)) + ' · ' + pct(pt ? x.sum / pt * 100 : 0, 0), tip: fmt(tys(x.sum)) + ' тыс. сум' })));
      hbars(q('disc'), c.discounts.map(x => ({ t: x.name, v: x.sum, lbl: fmt(tys(x.sum)), cls: x.manual ? 'warn' : '', tip: fmt(tys(x.sum)) + ' тыс. сум' })));
      sortable(q('cashiers'), [
        { k: 'name', h: 'Кассир', get: x => x.name },
        { k: 'ops', h: 'Операций', num: 1, get: x => x.ops, fmt: v => fmt(v) },
        { k: 'returns', h: 'Возвратов', num: 1, get: x => x.returns, fmt: v => `<span class="chip neu">${fmt(v)}</span>` },
        { k: 'returnsSum', h: 'Сумма возвратов', num: 1, get: x => tys(x.returnsSum), fmt: v => fmt(v) },
        { k: 'discounts', h: 'Скидки', num: 1, get: x => tys(x.discounts), fmt: v => fmt(v) },
        { k: 'sum', h: 'Принято', num: 1, get: x => tys(x.sum), fmt: v => fmt(v) }
      ], c.cashiers);
    }

    function renderStat(d) {
      const B = d.beds;
      q('bedSub').textContent = `Всего ${B.total} коек: занято ${B.occupied}, в брони ${B.booked}, свободно ${B.total - B.occupied - B.booked}. Как на странице «Койки».`;
      q('floors').innerHTML = B.floors.map(f => `<div class="floor"><h4>${esc(f.name)}</h4><div class="rooms">${f.rooms.map(r => {
        const free = r.cap - r.occ - r.booked;
        return `<div class="room" data-tip="<b>Палата ${esc(r.no)}</b><br>${r.cap} коек: занято ${r.occ}, бронь ${r.booked}, свободно ${free}"><div class="rn"><span>${esc(r.no)}</span><span>${r.occ}/${r.cap}</span></div><div class="beds">${Array.from({ length: r.cap }, (_, i) => `<i class="bed ${i < r.occ ? '' : i < r.occ + r.booked ? 'bron' : 'free'}"></i>`).join('')}</div></div>`;
      }).join('')}</div></div>`).join('');
      sortable(q('deps'), [
        { k: 'name', h: 'Отделение', get: x => x.name },
        { k: 'discharged', h: 'Выписано', num: 1, get: x => x.discharged, fmt: v => fmt(v) },
        { k: 'alos', h: 'Койко-день', num: 1, get: x => x.alos, fmt: v => fmt(v, 1) },
        { k: 'sum', h: 'Сумма актов', num: 1, get: x => tys(x.sum), fmt: v => fmt(v) }
      ], d.deps);
      const db = d.debts;
      q('debts').innerHTML = `<thead><tr><th>История болезни</th><th class="l">Отделение</th><th>Выписан</th><th>Общая сумма</th><th>Оплачено</th><th>К оплате</th></tr></thead><tbody>` +
        db.rows.map(x => `<tr><td>${esc(x.ib)}</td><td class="l">${esc(x.dep)}</td><td>${esc(x.discharged)}</td><td class="num">${fmt(tys(x.total))}</td><td class="num">${fmt(tys(x.paid))}</td><td class="num neg">${fmt(tys(x.total - x.paid))}</td></tr>`).join('') +
        `<tr class="tot"><td>Показаны ${db.rows.length} из ${db.count}</td><td></td><td></td><td></td><td>Всего долг</td><td class="num">${fmt(tys(db.sum))}</td></tr></tbody>`;
    }

    function renderAmb(d) {
      const a = d;
      q('flow').innerHTML = a.flow.map(x => {
        const hot = x.code === 'CASH' && a.waitingLong > 0;
        return `<div class="step ${hot ? 'hot' : ''}"><span>${esc(x.name)}</span><b class="num">${fmt(x.count)}</b>${x.code === 'CASH' ? `<span>ждут кассу дольше 20 мин: ${fmt(a.waitingLong)}</span>` : ''}</div>`;
      }).join('');
      const gt = sumBy(a.groups, 'sum');
      hbars(q('ambGroups'), a.groups.map(x => ({ t: x.name, v: x.sum, lbl: fmt(tys(x.sum)) + ' · ' + pct(gt ? x.sum / gt * 100 : 0, 0), tip: fmt(tys(x.sum)) + ' тыс. сум' })));
      const r = a.residents;
      hbars(q('resid'), [{ t: 'Резиденты', v: r.residents, lbl: fmt(r.residents) + ' чел.' }, { t: 'Иностранцы', v: r.foreigners, lbl: fmt(r.foreigners) + ' чел.', cls: 'brand' }]);
      const all = r.residents + r.foreigners;
      q('residNote').textContent = `Иностранцы составляют ${pct(all ? r.foreigners / all * 100 : 0, 0)} пациентов и ${pct(r.ambSum ? r.foreignersSum / r.ambSum * 100 : 0, 0)} выручки амбулатории: ${fmt(tys(r.foreignersSum))} тыс. сум.`;
    }

    function renderDrugs(d) {
      // Акт попадает в период по дате выписки, а выдача на пост по дате выдачи, поэтому у отделения за период
      // в акты может уйти больше, чем выдано (расходуются остатки поста). Такое не считаем потерей:
      // «не списано» складываем только по отделениям, где выдано больше, чем списано.
      const g = d, s = { cash: d.cash, discharged: d.discharged }, issued = sumBy(g.deps, 'issued'), billedDeps = sumBy(g.deps, 'billed'),
        lost = g.deps.reduce((a, x) => a + Math.max(0, (+x.issued || 0) - (+x.billed || 0)), 0);
      const days = P.days(from, to), perDay = issued / Math.max(1, days);
      const items = [
        { lab: 'Расход медикаментов', val: fmt(tys(g.billed)), u: 'тыс.', meta: `${delta(g.billed, g.prevBilled, 'neu')} по цене аптеки`, was: g.prevBilled != null && fmt(tys(g.prevBilled)) + ' тыс.' },
        { lab: 'Доля в поступлениях', val: pct(s.cash ? g.billed / s.cash * 100 : 0), u: '', meta: 'медикаменты в выручке' },
        { lab: 'На пациента стационара', val: fmt(tys(s.discharged ? g.statBilled / s.discharged : 0)), u: 'тыс.', meta: 'в среднем за лечение' },
        { lab: 'Не списано в акты', val: fmt(tys(lost)), u: 'тыс.', meta: lost > 0 ? `<span class="chip bad">${pct(issued ? lost / issued * 100 : 0)} выданного</span>` : '<span class="chip good">всё выданное списано</span>' },
        { lab: 'Запас на складе', val: fmt(tys(g.stock)), u: 'тыс.', meta: perDay ? `хватит на ${fmt(g.stock / perDay)} дн.` : '' }
      ];
      q('drugKpis').innerHTML = items.map(i => `<div class="kpi"><div class="lab">${i.lab}</div><div class="val num">${i.val}<small>${i.u}</small></div><div class="meta num">${i.meta}</div>${i.was ? `<div class="was num">было ${i.was}</div>` : ''}</div>`).join('');
      sortable(q('drugDeps'), [
        { k: 'name', h: 'Отделение', get: x => x.name },
        { k: 'issued', h: 'Выдано на пост', num: 1, get: x => tys(x.issued), fmt: v => fmt(v) },
        { k: 'billed', h: 'Списано в акты', num: 1, get: x => tys(x.billed), fmt: v => fmt(v) },
        { k: 'lost', h: 'Не списано', num: 1, get: x => tys(x.issued - x.billed), fmt: v => v > 0.5 ? `<span class="neg">${fmt(v)}</span>` : '—' },
        { k: 'rate', h: 'Списано, %', num: 1, get: x => x.issued ? x.billed / x.issued * 100 : 100,
          fmt: v => v > 105 ? `<span class="chip neu" data-tip="В акты ушло больше, чем выдано за период: расходовались остатки поста">${pct(v)}</span>` : `<span class="chip ${v < 95 ? 'warn' : 'good'}">${pct(v)}</span>` }
      ], g.deps, () => `<td>Итого</td><td class="num">${fmt(tys(issued))}</td><td class="num">${fmt(tys(billedDeps))}</td><td class="num ${lost > 0 ? 'neg' : ''}">${lost > 0 ? fmt(tys(lost)) : '—'}</td><td class="num">${pct(issued ? billedDeps / issued * 100 : 0)}</td>`);
      q('drugTop').innerHTML = `<thead><tr><th>Препарат</th><th class="l">Тип</th><th>Сумма</th><th>Доля</th></tr></thead><tbody>` +
        g.top.map(x => `<tr><td>${esc(x.name)}</td><td class="l">${esc(x.type || '—')}</td><td class="num">${fmt(tys(x.sum))}</td><td class="num">${pct(g.billed ? x.sum / g.billed * 100 : 0, 0)}</td></tr>`).join('') + '</tbody>';
      // типы назначений считаются в штуках назначений (у назначения нет суммы)
      const tt = sumBy(g.types, 'count');
      hbars(q('drugTypes'), g.types.map(x => ({ t: x.name, v: x.count, lbl: fmt(x.count) + ' · ' + pct(tt ? x.count / tt * 100 : 0, 0) })));
      const st = g.source.clinic + g.source.own, cl = st ? g.source.clinic / st * 100 : 0;
      hbars(q('drugSource'), [{ t: 'Клиника', v: cl, lbl: pct(cl, 0) + ' назначений' }, { t: 'Свой', v: 100 - cl, lbl: pct(100 - cl, 0), cls: 'brand' }], 100);
    }

    // Процент врача: из карточки услуги он у разных услуг разный, поэтому показываем средний по деньгам = вознаграждение / выручка
    function docPct(x) {
      if (x.percent !== '' && x.percent != null && !isNaN(+x.percent)) return +x.percent;
      return +x.revenue ? +x.reward / +x.revenue * 100 : null;
    }
    function fmtPct(v) { return v == null ? '—' : fmt(v, Math.abs(v - Math.round(v)) < 0.05 ? 0 : 1) + '%'; }

    function renderDocs(d) {

      sortable(q('docs'), [
        { k: 'name', h: 'Врач', get: x => x.name },
        { k: 'services', h: 'Услуг', num: 1, get: x => +x.services, fmt: v => fmt(v) },
        { k: 'percent', h: 'Процент', num: 1, get: x => docPct(x), fmt: v => fmtPct(v) },
        { k: 'reward', h: 'Вознаграждение', num: 1, get: x => tys(+x.reward), fmt: v => fmt(v) },
        { k: 'revenue', h: 'Выручка', num: 1, get: x => tys(+x.revenue), fmt: v => fmt(v) }
      ], d.doctors, rs => {
        const rw = sumBy(rs, 'reward'), rv = sumBy(rs, 'revenue');
        return `<td>Итого</td><td class="num">${fmt(sumBy(rs, 'services'))}</td><td class="num">${fmtPct(rv ? rw / rv * 100 : null)}</td><td class="num">${fmt(tys(rw))}</td><td class="num">${fmt(tys(rv))}</td>`;
      });

      sortable(q('partners'), [
        { k: 'code', h: 'Код', get: x => x.code },
        { k: 'name', h: 'Партнёр', get: x => x.name },
        { k: 'patients', h: 'Пациентов', num: 1, get: x => +x.patients, fmt: v => fmt(v) },
        { k: 'percent', h: 'Процент', num: 1, get: x => x.percent, fmt: v => fmt(v, 0) + '%' },
        { k: 'payout', h: 'Выплата', num: 1, get: x => tys(+x.payout), fmt: v => fmt(v) },
        { k: 'revenue', h: 'Выручка', num: 1, get: x => tys(x.revenue), fmt: v => fmt(v) }
      ], d.partners);
    }

    let start = 'sum';
    try { start = localStorage.getItem('fms-ruk-tab') || 'sum'; } catch (e) { /* по умолчанию Сводка */ }
    if (!root.querySelector(`[data-panel="${start}"]`)) start = root.querySelector('[data-panel]').dataset.panel;
    openTab(start);
    return { reload: () => { delete cache[active]; load(active); } };
  }

  function plural(n, one, few, many) {
    const a = Math.abs(n) % 100, b = a % 10;
    if (a > 10 && a < 20) return many;
    if (b > 1 && b < 5) return few;
    if (b === 1) return one;
    return many;
  }

  w.FmsRuk = { init: init };
})(window);
