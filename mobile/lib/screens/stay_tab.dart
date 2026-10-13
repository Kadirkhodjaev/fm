import 'dart:math';

import 'package:flutter/material.dart';

import '../api.dart';
import '../files.dart';
import '../fmt.dart';
import '../theme.dart';
import '../widgets.dart';

/// Лечение: стационар («Мой день», «Ход лечения», «Обследования»), лечение дома после выписки, прошлые госпитализации.
/// Только просмотр: отмечать приём не нужно.
class StayTab extends StatefulWidget {
  final Map<String, dynamic> client;
  const StayTab({super.key, required this.client});
  @override
  State<StayTab> createState() => _StayTabState();
}

class _StayTabState extends State<StayTab> {
  int seg = 0;

  Future<Map<String, dynamic>> _load() async {
    final id = asInt(widget.client['id']);
    final stays = await Api.I.stays(id);
    final cur = asMap(stays['current']);
    if (cur.isNotEmpty) {
      final sid = asInt(cur['id']);
      stays['detail'] = await (seg == 0 ? Api.I.day(sid) : seg == 1 ? Api.I.progress(sid) : Api.I.exams(sid));
    } else if (widget.client['home'] == true) {
      stays['plan'] = (await Api.I.homePlan(id))['plan'];
    }
    return stays;
  }

  @override
  Widget build(BuildContext context) {
    return Loader(
      key: ValueKey('stay-$seg'),
      load: _load,
      builder: (ctx, d, reload) {
        final cur = asMap(d['current']);
        final past = asList(d['past']);
        if (cur.isNotEmpty) return TabPage([..._stay(cur, asMap(d['detail'])), ..._past(past)]);
        if (d['plan'] != null) return TabPage([..._home(asMap(d['plan'])), ..._past(past)]);
        return TabPage([
          H2('Стационар', sub: asStr(widget.client['name'])),
          Empty('Сейчас не в стационаре',
              'Когда ${asStr(widget.client['firstName'])} положат в стационар, здесь появятся назначения, процедуры и обследования.'),
          ..._past(past),
        ]);
      },
    );
  }

  List<Widget> _past(List<dynamic> past) {
    if (past.isEmpty) return const [];
    return [
      const Sec('Прошлые госпитализации'),
      Box(
        child: Column(children: [
          for (var i = 0; i < past.length; i++)
            Line(
              first: i == 0,
              title: asStr(asMap(past[i])['dept']).isEmpty ? 'Стационар' : asStr(asMap(past[i])['dept']),
              sub: '${dmy(asMap(past[i])['from'])} – ${dmy(asMap(past[i])['to'])}${asStr(asMap(past[i])['ib']).isEmpty ? '' : ' · ИБ ${asMap(past[i])['ib']}'}',
              trailing: asMap(past[i])['epicrisis'] == true
                  ? OutlinedButton(onPressed: () => openFile(context, 'epicrisis', asInt(asMap(past[i])['id'])), child: const Text('Выписка'))
                  : null,
            ),
        ]),
      ),
    ];
  }

  // ---------- Стационар ----------

  List<Widget> _stay(Map<String, dynamic> s, Map<String, dynamic> d) {
    final sub = [
      asStr(s['dept']),
      if (asStr(s['ib']).isNotEmpty) 'ИБ ${s['ib']}',
      '${dmy(s['from'])}${s['plannedTo'] != null ? ' – ${dmy(s['plannedTo'])}' : ''}',
    ].where((x) => x.isNotEmpty).join(' · ');
    return [
      H2('Стационар', sub: sub),
      SegmentedButton<int>(
        showSelectedIcon: false,
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: C.graphite,
          selectedForegroundColor: Colors.white,
          side: const BorderSide(color: C.line),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        segments: const [
          ButtonSegment(value: 0, label: Text('Мой день')),
          ButtonSegment(value: 1, label: Text('Ход лечения')),
          ButtonSegment(value: 2, label: Text('Обследования')),
        ],
        selected: {seg},
        onSelectionChanged: (v) => setState(() => seg = v.first),
      ),
      const SizedBox(height: 12),
      ...(seg == 0 ? _day(d) : seg == 1 ? _course(d) : _exams(d)),
    ];
  }

  List<Widget> _day(Map<String, dynamic> d) {
    final slots = asList(d['slots']);
    final out = <Widget>[
      Muted('${weekdayDate(d['date'])}${asStr(d['diet']).isEmpty ? '' : ' · ${d['diet']}'}'),
    ];
    if (slots.isEmpty) out.add(const Padding(padding: EdgeInsets.only(top: 12), child: Empty('Препаратов на сегодня нет', 'Назначения появятся здесь, когда врач их добавит.')));
    for (final x in slots) {
      final s = asMap(x);
      final items = asList(s['items']);
      out.add(Sec(asStr(s['name']), right: asStr(s['time'])));
      out.add(Box(
        child: Column(children: [
          for (var i = 0; i < items.length; i++) _drug(asMap(items[i]), i == 0),
        ]),
      ));
    }
    final fizio = asList(d['fizio']);
    if (fizio.isNotEmpty) {
      out.add(const Sec('Физиотерапия'));
      out.add(Box(
        child: Column(children: [
          for (var i = 0; i < fizio.length; i++)
            Line(
              first: i == 0,
              title: asStr(asMap(fizio[i])['name']) + (asStr(asMap(fizio[i])['area']).isEmpty ? '' : ' — ${asMap(fizio[i])['area']}'),
              sub: [
                if (asStr(asMap(fizio[i])['room']).isNotEmpty) 'Кабинет ${asMap(fizio[i])['room']}',
                'сеанс ${asMap(fizio[i])['session']} из ${asMap(fizio[i])['total']}',
              ].join(' · '),
              trailing: asMap(fizio[i])['done'] == true ? const Tag('Сделано', St.ok) : null,
            ),
        ]),
      ));
    }
    final exams = asList(d['exams']);
    if (exams.isNotEmpty) {
      out.add(const Sec('Обследования сегодня'));
      out.add(Box(child: Column(children: [for (var i = 0; i < exams.length; i++) Line(first: i == 0, title: asStr(exams[i]))])));
    }
    final tomorrow = asList(d['tomorrow']);
    if (tomorrow.isNotEmpty) {
      out.add(const Sec('Завтра'));
      out.add(Box(
        child: Column(children: [
          for (var i = 0; i < tomorrow.length; i++) Line(first: i == 0, title: asStr(tomorrow[i])),
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Muted('Если среди них анализ крови, уточните у медсестры, нужно ли сдавать натощак.'),
          ),
        ]),
      ));
    }
    return out;
  }

  Widget _drug(Map<String, dynamic> it, bool first) {
    final sub = [
      asStr(it['dose']),
      asStr(it['food']),
      if (it['tablet'] == true) (it['own'] == true ? 'свой препарат' : 'препарат клиники') else asStr(it['kind']).toLowerCase(),
    ].where((e) => e.isNotEmpty).join(' · ');
    final Widget? right = it['done'] == true
        ? Tag(it['tablet'] == true ? 'Отметила медсестра' : 'Сделано', St.ok)
        : it['tablet'] != true
            ? const Tag('Сделает медсестра', St.info)
            : null;
    return Line(first: first, title: asStr(it['name']), sub: sub, trailing: right);
  }

  List<Widget> _course(Map<String, dynamic> p) {
    final day = asInt(p['day']), days = asInt(p['days']);
    final parts = asList(p['parts']);
    return [
      Box(
        child: Row(children: [
          SizedBox(width: 80, height: 80, child: CustomPaint(painter: _Ring(days > 0 ? min(1.0, day / days) : 0), child: Center(child: Text(days > 0 ? '$day/$days' : '$day', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18))))),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(days > 0 ? 'День $day из $days' : 'День $day', style: const TextStyle(fontWeight: FontWeight.w700)),
              Muted('Поступили ${dayMonth(p['from'])}.${p['plannedTo'] != null ? ' Плановая выписка ${dayMonth(p['plannedTo'])}.' : ''}'),
            ]),
          ),
        ]),
      ),
      if (parts.isNotEmpty)
        Box(
          child: Column(children: [
            for (final x in parts)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [Expanded(child: Text(asStr(asMap(x)['name']))), Muted('${asMap(x)['done']} из ${asMap(x)['total']}')]),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: asInt(asMap(x)['total']) == 0 ? 0 : asInt(asMap(x)['done']) / asInt(asMap(x)['total']),
                      minHeight: 7,
                      backgroundColor: C.graySoft,
                      color: C.graphite,
                    ),
                  ),
                ]),
              ),
          ]),
        ),
      Box(
        child: Column(children: [
          _kv('Лечащий врач', asStr(p['doctor'])),
          _kv('Отделение', asStr(p['dept'])),
          _kv('Палата', asStr(p['room'])),
          if (asStr(p['diet']).isNotEmpty) _kv('Питание', asStr(p['diet'])),
        ]),
      ),
    ];
  }

  Widget _kv(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 120, child: Muted(k, size: 14)),
          Expanded(child: Text(v.isEmpty ? '—' : v, style: const TextStyle(fontWeight: FontWeight.w500))),
        ]),
      );

  List<Widget> _exams(Map<String, dynamic> d) {
    final items = asList(d['items']);
    return [
      Box(
        color: C.blueSoft,
        child: Text(asStr(d['note']), style: const TextStyle(color: C.blue, fontSize: 13.5)),
      ),
      if (items.isEmpty)
        const Empty('Обследования пока не назначены', 'Когда врач их назначит, они появятся здесь.')
      else
        Box(
          child: Column(children: [
            for (var i = 0; i < items.length; i++)
              Line(
                first: i == 0,
                time: dayMonthShort(asMap(items[i])['date']),
                title: asStr(asMap(items[i])['name']),
                trailing: Tag.result(asStr(asMap(items[i])['status'])),
              ),
          ]),
        ),
      Box(
        child: Line(
          first: true,
          title: 'Выписка',
          sub: d['epicrisis'] == true ? 'Готова' : 'Появится в день выписки',
          trailing: d['epicrisis'] == true ? const Tag('Готово', St.ok) : null,
        ),
      ),
    ];
  }

  // ---------- Лечение дома ----------

  List<Widget> _home(Map<String, dynamic> p) {
    final schedule = asList(p['schedule']);
    final drugs = asList(p['drugs']);
    final f = asMap(p['followup']);
    final rec = asStr(p['recommendations']);
    return [
      H2('Лечение дома',
          sub: 'После выписки${asStr(p['dept']).isEmpty ? '' : ' (${p['dept']})'} ${dmy(p['discharged'])}${asInt(p['days']) > 0 ? ' · день ${p['day']} из ${p['days']}' : ''}'),
      if (drugs.isEmpty) const Empty('Препараты не указаны', 'Врач не заполнил таблицу препаратов в выписке. Смотрите рекомендации ниже.'),
      for (final x in schedule) ...[
        Sec(asStr(asMap(x)['name']), right: asStr(asMap(x)['time'])),
        Box(
          child: Column(children: [
            for (var i = 0; i < asList(asMap(x)['items']).length; i++)
              Line(
                first: i == 0,
                title: asStr(asMap(asList(asMap(x)['items'])[i])['name']),
                sub: [asStr(asMap(asList(asMap(x)['items'])[i])['dose']), asStr(asMap(asList(asMap(x)['items'])[i])['foodText'])].where((e) => e.isNotEmpty).join(', '),
              ),
          ]),
        ),
      ],
      if (drugs.isNotEmpty) ...[
        const Sec('Курс'),
        Box(
          child: Column(children: [
            for (var i = 0; i < drugs.length; i++)
              Line(
                first: i == 0,
                title: asStr(asMap(drugs[i])['name']),
                sub: asMap(drugs[i])['active'] == true || asInt(asMap(drugs[i])['left']) > 0
                    ? 'до ${dm(asMap(drugs[i])['until'])} · осталось ${asMap(drugs[i])['left']} ${plural(asInt(asMap(drugs[i])['left']), 'день', 'дня', 'дней')}'
                    : 'курс закончен ${dm(asMap(drugs[i])['until'])}',
                trailing: asInt(asMap(drugs[i])['left']) > 0 && asInt(asMap(drugs[i])['left']) <= 7 ? const Tag('Скоро конец', St.wait) : null,
              ),
          ]),
        ),
        const Muted('Напоминания приходят на каждое время приёма. Время можно поменять в профиле.'),
      ],
      if (rec.isNotEmpty) ...[
        const Sec('Рекомендации врача'),
        Box(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(rec, style: const TextStyle(fontSize: 14, height: 1.5)),
            if (asStr(p['doctor']).isNotEmpty) ...[const SizedBox(height: 8), Muted('${p['doctor']}, из выписки ${dmy(p['discharged'])}')],
          ]),
        ),
      ],
      if (f.isNotEmpty)
        Box(
          child: Line(
            first: true,
            title: asStr(f['doctor']).isEmpty ? 'Повторный приём' : 'Повторный приём: ${f['doctor']}',
            sub: dmy(f['date']),
            trailing: asInt(f['inDays']) >= 1 ? const Tag('Напомним за день', St.info) : null,
          ),
        ),
    ];
  }
}

class _Ring extends CustomPainter {
  final double value;
  _Ring(this.value);
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2 - 6;
    final bg = Paint()
      ..color = C.graySoft
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    final fg = Paint()
      ..color = C.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;
    canvas.drawCircle(c, r, bg);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), -pi / 2, 2 * pi * value, false, fg);
  }

  @override
  bool shouldRepaint(covariant _Ring old) => old.value != value;
}
