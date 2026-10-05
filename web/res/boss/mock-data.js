/*
 * Пример данных для предпросмотра без сервера. В JSP этот файл НЕ подключается.
 * FmsRukMock(вкладка, {from, to, prevFrom, prevTo}) возвращает объект в том же формате, что должен отдавать /rukovodstvo/<вкладка>.s.
 * Цифры условные: помесячные суммы делятся по дням с учётом дня недели, чтобы любой период выглядел правдоподобно.
 */
(function (w) {
  'use strict';
  const P = w.FmsRukPicker;
  const M6 = 1e6;
  // Помесячно с октября 2025 по сентябрь 2026, млн сум и люди
  const START = { y: 2025, m: 9 };
  const stat = [1390, 1420, 1530, 1310, 1350, 1460, 1580, 1540, 1470, 1420, 1500, 1610];
  const amb = [720, 745, 790, 680, 705, 770, 830, 815, 790, 760, 805, 870];
  const dis = [176, 181, 193, 168, 172, 186, 198, 195, 187, 182, 191, 212];
  const regs = [3540, 3610, 3790, 3380, 3450, 3720, 3950, 3900, 3820, 3710, 3900, 4180];
  const dayK = d => [0.72, 1.12, 1.08, 1.06, 1.05, 1.02, 0.95][d.getDay()] * (1 + 0.06 * Math.sin(d.getDate() * 1.3));
  const mi = d => (d.getFullYear() - START.y) * 12 + d.getMonth() - START.m;

  function weights(a, b) {
    const wts = stat.map(() => 0);
    for (let d = new Date(a); d <= b; d = P.addD(d, 1)) {
      const i = mi(d);
      if (i < 0 || i > 11) continue;
      wts[i] += dayK(d) / new Date(d.getFullYear(), d.getMonth() + 1, 0).getDate();
    }
    return wts;
  }
  const sum = (a, wts) => wts.reduce((q, x, i) => q + a[i] * x, 0);
  const r = v => Math.round(v);

  function totals(a, b) {
    const wts = weights(a, b), s = sum(stat, wts) * M6, am = sum(amb, wts) * M6;
    return { wts, cash: r(s + am), stat: r(s), amb: r(am), drugs: r(s * .14 + am * .02), cash_discount: r((s + am) * .012), dis_sum: r(s * .006), discharged: r(sum(dis, wts)), ambRegs: r(sum(regs, wts)) };
  }

  function full(params) {
    const from = P.parse(params.from), to = P.parse(params.to);
    const pf = P.parse(params.prevFrom), pt = P.parse(params.prevTo);
    const cur = totals(from, to), prev = pf && pt ? totals(pf, pt) : null;
    const k = P.days(from, to) / 30.4; // длина периода в месяцах для строк, где нет помесячных данных
    const strip = t => t && { cash: t.cash, stat: t.stat, amb: t.amb, drugs: t.drugs, cash_discount: t.cash_discount, dis_sum: t.dis_sum, discharged: t.discharged, ambRegs: t.ambRegs };

    // 12 месяцев до месяца конца периода, но не раньше октября 2025
    const last = mi(to), months = [];
    for (let i = Math.max(0, last - 11); i <= Math.min(11, last); i++) {
      const y = START.y + Math.floor((START.m + i) / 12), m = (START.m + i) % 12 + 1;
      months.push({ ym: y + '-' + (m < 10 ? '0' : '') + m, stat: stat[i] * M6, amb: amb[i] * M6, discharged: dis[i], ambRegs: regs[i] });
    }

    const mix = [['bed', 'Койко-дни', .38], ['svc', 'Медицинские услуги', .17], ['drug', 'Медикаменты', .14], ['lab', 'Лабораторные исследования', .20], ['spec', 'Узкие специалисты', .07], ['food', 'Питание', .03], ['extra', 'Дополнительное место', .01]];
    const floors = [
      { name: '2-й этаж · Стандарт', rooms: [['201', 3, 3, 0], ['202', 3, 2, 1], ['203', 3, 3, 0], ['204', 3, 3, 0], ['205', 3, 1, 0], ['206', 2, 2, 0], ['207', 3, 3, 0], ['208', 2, 2, 0]] },
      { name: '3-й этаж · Стандарт и полулюкс', rooms: [['301', 3, 3, 0], ['302', 3, 3, 0], ['303', 3, 2, 1], ['304', 3, 3, 0], ['305', 2, 2, 0], ['306', 2, 1, 1], ['307', 2, 2, 0], ['308', 3, 3, 0], ['309', 3, 2, 0]] },
      { name: '4-й этаж · Люкс', rooms: [['401', 2, 2, 0], ['402', 2, 1, 1], ['403', 2, 2, 0], ['404', 2, 0, 2], ['405', 2, 2, 0], ['406', 2, 1, 1]] }
    ].map(f => ({ name: f.name, rooms: f.rooms.map(x => ({ no: x[0], cap: x[1], occ: x[2], booked: x[3] })) }));
    const bedsAll = [].concat(...floors.map(f => f.rooms));
    const debtRows = [
      ['ИБ 2026/1147', 'Терапия', '18.09.2026', 9.8, 4.0], ['ИБ 2026/1152', 'Хирургия', '20.09.2026', 14.6, 9.0], ['ИБ 2026/1098', 'Неврология', '04.09.2026', 11.2, 3.5],
      ['ИБ 2026/1171', 'Кардиология', '25.09.2026', 8.4, 6.0], ['ИБ 2026/1063', 'Терапия', '28.08.2026', 7.1, 2.2]
    ].map(x => ({ ib: x[0], dep: x[1], discharged: x[2], total: x[3] * M6, paid: x[4] * M6 }));
    const disc = 46.2 * M6 * k;
    const drugBilled = cur.drugs, statDrugs = r(cur.stat * .14);

    return {
      period: { from: params.from, to: params.to },
      prevPeriod: prev ? { from: params.prevFrom, to: params.prevTo } : null,
      summary: { cur: strip(cur), prev: strip(prev) },
      months,
      actSections: mix.map(([code, name, s]) => ({ code, name, cur: r(cur.stat * s), prev: prev ? r(prev.stat * s) : null })),
      beds: { total: sumCap(bedsAll, 'cap'), occupied: sumCap(bedsAll, 'occ'), booked: sumCap(bedsAll, 'booked'), floors },
      debts: { count: 23, sum: r(debtRows.reduce((q, x) => q + x.total - x.paid, 0) * 4.1), rows: debtRows },
      cash: {
        payTypes: [['cash', 'Наличные', .41], ['card', 'Пластик', .36], ['transfer', 'Перечисление', .14], ['online', 'Онлайн', .09]].map(([code, name, s]) => ({ code, name, sum: r(cur.cash * s) })),
        discounts: [['staff', 'Сотрудники клиники', .305, false], ['manual', 'Ручная скидка в кассе', .232, true], ['benefit', 'Льготные категории', .255, false], ['package', 'Пакеты услуг', .208, false]].map(([code, name, s, manual]) => ({ code, name, sum: r(disc * s), manual })),
        cashiers: [['Кассир 1 · стационар', 412, .36, 3, .12, .18], ['Кассир 2 · амбулатория', 1880, .29, 6, .51, .43], ['Кассир 3 · амбулатория', 1520, .23, 2, .19, .26], ['Кассир 4 · вечерняя смена', 610, .12, 1, .18, .13]]
          .map(([name, ops, s, ret, rs, ds]) => ({ name, ops: r(ops * k), returns: r(ret * k), returnsSum: r(18.4 * M6 * k * rs), discounts: r(disc * ds), sum: r(cur.cash * s) }))
      },
      stat: {
        deps: [['Терапия', 64, 6.1, .26], ['Хирургия', 48, 5.2, .32], ['Неврология', 41, 7.8, .19], ['Кардиология', 33, 6.9, .15], ['Гинекология', 26, 3.9, .08]]
          .map(([name, v, alos, s]) => ({ name, discharged: r(cur.discharged * v / 212), alos, sum: r(cur.stat * s) }))
      },
      amb: {
        flow: [['PRN', 'Регистрация', 12], ['CASH', 'Ожидание оплаты', 9], ['WORK', 'Оказание услуг', 27], ['DONE', 'Услуги оказаны', 31], ['ARCH', 'Закрыта сегодня', 148]].map(([code, name, count]) => ({ code, name, count })),
        waitingLong: 4,
        groups: [['Консультации', .31], ['Лаборатория', .24], ['УЗИ и обследования', .18], ['Физиотерапия', .15], ['Пакеты', .07], ['Иглотерапия', .05]].map(([name, s]) => ({ name, sum: r(cur.amb * s) })),
        residents: { residents: r(cur.ambRegs * .94), foreigners: r(cur.ambRegs * .06), foreignersSum: r(cur.amb * .11), ambSum: cur.amb }
      },
      drugs: {
        billed: drugBilled, prevBilled: prev ? prev.drugs : null, statBilled: statDrugs, stock: 62.4 * M6,
        deps: [['Терапия', .29, .975], ['Хирургия', .26, .91], ['Неврология', .18, .985], ['Кардиология', .15, .99], ['Гинекология', .07, .97], ['Амбулатория', .05, 1]]
          .map(([name, s, rate]) => ({ name, billed: r(drugBilled * s), issued: r(drugBilled * s / rate) })),
        top: [['Натрия хлорид 0,9% 200 мл', 'Капельница', .197], ['Актовегин 40 мг/мл 5 мл', 'Инъекция в/в', .105], ['Омепразол 40 мг', 'Инъекция в/в', .092], ['Цефтриаксон 1 г', 'Инъекция в/в, в/м', .091], ['Амоксиклав 1,2 г', 'Инъекция в/в', .085], ['Система для инфузий', 'Расходники', .066], ['Мексидол 50 мг/мл 5 мл', 'Инъекция в/в, в/м', .061], ['Глюкоза 5% 200 мл', 'Капельница', .045]]
          .map(([name, type, s]) => ({ name, type, sum: r(drugBilled * s) })),
        types: [['Капельницы', .34], ['Инъекции в/в', .29], ['Инъекции в/м', .16], ['Расходники', .10], ['Таблетки', .09], ['Инъекции п/к', .02]].map(([name, s]) => ({ name, sum: r(drugBilled * s) })),
        source: { clinic: r(4650 * k), own: r(350 * k) }
      },
      doctors: [['Врач 01 · терапевт', 486, 212, 10], ['Врач 02 · хирург', 138, 318, 12], ['Врач 03 · невролог', 302, 176, 10], ['Врач 04 · кардиолог', 268, 161, 10], ['Врач 05 · гинеколог', 244, 124, 10], ['Врач 06 · УЗИ', 612, 118, 8], ['Врач 07 · физиотерапевт', 930, 96, 7], ['Врач 08 · иглотерапевт', 356, 44, 10]]
        .map(([name, svc, rev, pc]) => { const revenue = r(rev * M6 * cur.cash / 2480e6); return { name, services: r(svc * k), percent: pc, revenue, reward: r(revenue * pc / 100) }; }),
      partners: [['P-014', 'Партнёр 1 · семейная поликлиника', 58, 236, 8], ['P-027', 'Партнёр 2 · частный врач', 31, 171, 10], ['P-003', 'Партнёр 3 · районная больница', 44, 152, 6], ['P-041', 'Партнёр 4 · частный врач', 17, 88, 10], ['P-019', 'Партнёр 5 · диагностический центр', 22, 64, 5]]
        .map(([code, name, p, rev, pc]) => { const revenue = r(rev * M6 * cur.cash / 2480e6); return { code, name, patients: r(p * k), percent: pc, revenue, payout: r(revenue * pc / 100) }; })
    };
  }

  // Ответ каждой вкладки: те же данные, что вернёт её контроллер
  w.FmsRukMock = function (tab, params) {
    const d = full(params);
    switch (tab) {
      case 'sum': return { summary: d.summary, months: d.months, actSections: d.actSections,
        beds: { total: d.beds.total, occupied: d.beds.occupied, booked: d.beds.booked }, debts: { count: d.debts.count, sum: d.debts.sum } };
      case 'cash': return d.cash;
      case 'stat': return { beds: d.beds, deps: d.stat.deps, debts: d.debts };
      case 'amb': return d.amb;
      case 'drug': return Object.assign({ cash: d.summary.cur.cash, discharged: d.summary.cur.discharged }, d.drugs);
      case 'doc': return { doctors: d.doctors, partners: d.partners };
    }
    return {};
  };
  function sumCap(a, key) { return a.reduce((q, x) => q + x[key], 0); }
})(window);
