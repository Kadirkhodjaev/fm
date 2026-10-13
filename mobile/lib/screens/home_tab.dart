import 'package:flutter/material.dart';

import '../api.dart';
import '../fmt.dart';
import '../theme.dart';
import '../widgets.dart';
import 'visits_tab.dart';

/// Главная: текущее лечение (стационар или дома), ближайшие препараты, последний визит
class HomeTab extends StatelessWidget {
  final Map<String, dynamic> client;
  final void Function(int tab) go;
  const HomeTab({super.key, required this.client, required this.go});

  Future<Map<String, dynamic>> _load() async {
    final id = asInt(client['id']);
    final res = <String, dynamic>{};
    final stay = asMap(client['stay']);
    final futures = <Future>[
      Api.I.visits(id).then((v) => res['visits'] = asList(v['items'])),
      if (stay.isNotEmpty) Api.I.day(asInt(stay['id'])).then((v) => res['day'] = v),
      if (stay.isEmpty && client['home'] == true) Api.I.homePlan(id).then((v) => res['plan'] = v['plan']),
    ];
    await Future.wait(futures);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Loader(
      load: _load,
      builder: (ctx, d, reload) {
        final c = client;
        final age = c['age'] == null ? '' : ', ${c['age']} ${plural(asInt(c['age']), 'год', 'года', 'лет')}';
        final visits = asList(d['visits']);
        return TabPage([
          H2(asStr(c['name']), sub: c['birthyear'] == null ? null : '${c['birthyear']} г.р.$age'),
          if (c['stay'] != null)
            ..._stay(asMap(c['stay']), asMap(d['day']))
          else if (d['plan'] != null)
            ..._home(asMap(d['plan']))
          else
            Box(child: Muted('Сейчас ${asStr(c['firstName'])} не лежит в стационаре.', size: 14)),
          Sec('Последний визит', right: visits.isEmpty ? null : 'всего ${visits.length}'),
          if (visits.isEmpty)
            const Empty('Визитов пока нет', 'Здесь появятся визиты в амбулаторию и результаты.')
          else ...[
            VisitCard(visit: asMap(visits.first), open: true),
            OutlinedButton(onPressed: () => go(2), child: const Text('Все визиты')),
          ],
        ]);
      },
    );
  }

  /// Ближайшее время приёма после текущего времени
  static String? nextTime(List<dynamic> slots) {
    final now = TimeOfDay.now();
    final n = now.hour * 60 + now.minute;
    for (final s in slots) {
      final t = asStr(asMap(s)['time']).split(':');
      if (t.length == 2 && (int.tryParse(t[0]) ?? 0) * 60 + (int.tryParse(t[1]) ?? 0) > n) return asStr(asMap(s)['time']);
    }
    return null;
  }

  List<Widget> _stay(Map<String, dynamic> s, Map<String, dynamic> day) {
    final slots = asList(day['slots']);
    final count = slots.fold<int>(0, (a, x) => a + asList(asMap(x)['items']).length);
    final next = nextTime(slots);
    final info = [asStr(s['dept']), if (asStr(s['room']).isNotEmpty) 'палата ${s['room']}', if (asStr(s['doctor']).isNotEmpty) 'врач ${s['doctor']}']
        .where((x) => x.isNotEmpty)
        .join(' · ');
    final upcoming = <Widget Function(bool)>[];
    final now = TimeOfDay.now();
    final nowMin = now.hour * 60 + now.minute;
    for (final x in slots) {
      final m = asMap(x);
      final t = asStr(m['time']).split(':');
      final min = t.length == 2 ? (int.tryParse(t[0]) ?? 0) * 60 + (int.tryParse(t[1]) ?? 0) : 0;
      if (min <= nowMin) continue;
      for (final it in asList(m['items'])) {
        final i = asMap(it);
        upcoming.add((f) => Line(first: f, time: asStr(m['time']), title: asStr(i['name']), sub: [asStr(i['dose']), asStr(i['food'])].where((e) => e.isNotEmpty).join(', ')));
      }
    }
    for (final x in asList(day['fizio'])) {
      final f0 = asMap(x);
      if (f0['done'] == true) continue;
      upcoming.add((f) => Line(
          first: f,
          time: '',
          title: asStr(f0['name']),
          sub: [if (asStr(f0['room']).isNotEmpty) 'Кабинет ${f0['room']}', 'сеанс ${f0['session']} из ${f0['total']}'].join(' · ')));
    }
    return [
      Box(
        accent: C.red,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Expanded(child: Text('Сейчас в стационаре', style: TextStyle(fontWeight: FontWeight.w700))),
            if (s['day'] != null) Tag(s['days'] != null ? 'День ${s['day']} из ${s['days']}' : 'День ${s['day']}', St.red),
          ]),
          const SizedBox(height: 4),
          Muted(info),
          const SizedBox(height: 10),
          Row(children: [
            const Expanded(child: Text('Препараты сегодня')),
            Text(count == 0 ? 'не назначены' : '$count${next == null ? '' : ', следующие в $next'}'),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            FilledButton(onPressed: () => go(1), child: const Text('Мой день')),
            const SizedBox(width: 8),
            OutlinedButton(onPressed: () => go(3), child: const Text('Вопрос врачу')),
          ]),
        ]),
      ),
      if (upcoming.isNotEmpty) ...[
        const Sec('Следующее'),
        Box(child: Column(children: [for (var i = 0; i < upcoming.length && i < 6; i++) upcoming[i](i == 0)])),
      ],
    ];
  }

  List<Widget> _home(Map<String, dynamic> p) {
    final schedule = asList(p['schedule']);
    final count = schedule.fold<int>(0, (a, x) => a + asList(asMap(x)['items']).length);
    final next = nextTime(schedule);
    final f = asMap(p['followup']);
    return [
      Box(
        accent: C.green,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Expanded(child: Text('Лечение дома', style: TextStyle(fontWeight: FontWeight.w700))),
            if (asInt(p['days']) > 0) Tag('День ${p['day']} из ${p['days']}', St.ok),
          ]),
          const SizedBox(height: 4),
          Muted('После выписки ${dmy(p['discharged'])}${asStr(p['doctor']).isEmpty ? '' : ' · врач ${p['doctor']}'}'),
          if (count > 0) ...[
            const SizedBox(height: 10),
            Row(children: [
              const Expanded(child: Text('Препараты сегодня')),
              Text('$count${next == null ? '' : ', следующие в $next'}'),
            ]),
          ],
          const SizedBox(height: 12),
          FilledButton(onPressed: () => go(1), child: const Text('Расписание и рекомендации')),
        ]),
      ),
      if (f.isNotEmpty && asInt(f['inDays']) >= 0)
        Box(
          child: Line(
            first: true,
            title: asStr(f['doctor']).isEmpty ? 'Повторный приём' : 'Повторный приём: ${f['doctor']}',
            sub: '${dmy(f['date'])} · запишитесь в регистратуре',
            trailing: Tag(asInt(f['inDays']) == 0 ? 'Сегодня' : 'Через ${f['inDays']} ${plural(asInt(f['inDays']), 'день', 'дня', 'дней')}', St.info),
          ),
        ),
    ];
  }
}
