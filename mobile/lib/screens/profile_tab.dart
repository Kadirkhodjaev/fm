import 'package:flutter/material.dart';

import '../api.dart';
import '../theme.dart';
import '../widgets.dart';
import 'login.dart';

/// Профиль: клиенты на номере с выключателем уведомлений, время напоминаний, язык, выход
class ProfileTab extends StatefulWidget {
  final List<Map<String, dynamic>> clients;
  final VoidCallback onChanged;
  final VoidCallback onLogout;
  const ProfileTab({super.key, required this.clients, required this.onChanged, required this.onLogout});
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Map<String, dynamic>? s;
  String? error;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final r = await Api.I.settings();
      if (mounted) setState(() => s = r);
    } on ApiException catch (e) {
      if (mounted) setState(() => error = e.message);
    }
  }

  Future<void> save(Map<String, dynamic> change) async {
    try {
      final r = await Api.I.saveSettings(change);
      if (mounted) setState(() => s = r);
    } on ApiException catch (e) {
      if (mounted) toast(context, e.message);
    }
  }

  Set<int> get off => asList(s?['clientsOff']).map(asInt).toSet();

  Future<void> pickTime(String key, String label) async {
    final cur = asStr(asMap(s?['homeTimes'])[key]).split(':');
    final t = await showTimePicker(
      context: context,
      helpText: label,
      initialTime: TimeOfDay(hour: int.tryParse(cur.first) ?? 8, minute: cur.length > 1 ? int.tryParse(cur[1]) ?? 0 : 0),
      builder: (ctx, child) => MediaQuery(data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true), child: child!),
    );
    if (t == null) return;
    await save({
      'homeTimes': {key: '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}'}
    });
  }

  @override
  Widget build(BuildContext context) {
    if (s == null) {
      return error == null
          ? const Center(child: CircularProgressIndicator(color: C.graphite))
          : TabPage([Empty('Не получилось загрузить', error!), OutlinedButton(onPressed: load, child: const Text('Повторить'))]);
    }
    final home = asMap(s!['homeTimes']);
    final stay = asMap(s!['stayTimes']);
    return TabPage([
      H2('Профиль', sub: 'Номер ${Api.I.phone ?? ''}'),
      const Sec('Клиенты на этом номере'),
      Box(
        child: Column(children: [
          for (var i = 0; i < widget.clients.length; i++) _client(widget.clients[i], i),
          const Padding(padding: EdgeInsets.only(top: 8), child: Muted('Переключатель включает уведомления по этому клиенту.')),
        ]),
      ),
      const Sec('Уведомления'),
      Box(
        child: Column(children: [
          _switch('Препараты и процедуры', 'в стационаре: ${stay['digest']} сводка, ${stay['morning']}, ${stay['noon']}, ${stay['evening']}', s!['meds'] == true,
              (v) => save({'meds': v}), true),
          _switch('Результаты готовы', 'сразу', s!['results'] == true, (v) => save({'results': v}), false),
        ]),
      ),
      const Sec('Время приёма лечения дома'),
      Box(
        child: Column(children: [
          _time('Утро', 'morning', asStr(home['morning']), true),
          _time('Обед', 'noon', asStr(home['noon']), false),
          _time('Вечер', 'evening', asStr(home['evening']), false),
        ]),
      ),
      const Sec('Язык'),
      Box(
        child: Row(children: [
          for (final l in const [('ru', 'Русский'), ('uz', 'O‘zbekcha')]) ...[
            Expanded(
              child: s!['lang'] == l.$1
                  ? FilledButton(onPressed: () {}, child: Text(l.$2))
                  : OutlinedButton(onPressed: () => save({'lang': l.$1}), child: Text(l.$2)),
            ),
            if (l.$1 == 'ru') const SizedBox(width: 8),
          ],
        ]),
      ),
      if (s!['lang'] == 'uz') const Padding(padding: EdgeInsets.only(bottom: 12), child: Muted('Узбекский перевод экранов будет в следующей версии.')),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () async {
            await Api.I.logout();
            widget.onLogout();
          },
          child: const Text('Выйти'),
        ),
      ),
      const SizedBox(height: 10),
      Center(child: Muted('Сервер: ${Api.I.base}', size: 11)),
    ]);
  }

  Widget _client(Map<String, dynamic> c, int i) {
    final id = asInt(c['id']);
    final on = !off.contains(id);
    final info = [
      if (c['birthyear'] != null) '${c['birthyear']} г.р.',
      c['stay'] != null ? 'в стационаре' : c['home'] == true ? 'лечение дома' : '${c['visits']} виз.',
    ].join(' · ');
    return Container(
      padding: EdgeInsets.only(top: i == 0 ? 0 : 8, bottom: 8),
      decoration: BoxDecoration(border: i == 0 ? null : const Border(top: BorderSide(color: C.line))),
      child: Row(children: [
        Avatar(asStr(c['initials']), i),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(asStr(c['name']), style: const TextStyle(fontWeight: FontWeight.w600)),
            Muted(info, size: 12.5),
          ]),
        ),
        Switch(
          value: on,
          activeTrackColor: C.green,
          onChanged: (v) {
            final o = off;
            v ? o.remove(id) : o.add(id);
            save({'clientsOff': o.toList()});
          },
        ),
      ]),
    );
  }

  Widget _switch(String title, String sub, bool value, ValueChanged<bool> onChanged, bool first) => Container(
        padding: EdgeInsets.only(top: first ? 0 : 8, bottom: 8),
        decoration: BoxDecoration(border: first ? null : const Border(top: BorderSide(color: C.line))),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              Muted(sub, size: 12.5),
            ]),
          ),
          Switch(value: value, activeTrackColor: C.green, onChanged: onChanged),
        ]),
      );

  Widget _time(String label, String key, String value, bool first) => InkWell(
        onTap: () => pickTime(key, label),
        child: Container(
          padding: EdgeInsets.only(top: first ? 2 : 10, bottom: 10),
          decoration: BoxDecoration(border: first ? null : const Border(top: BorderSide(color: C.line))),
          child: Row(children: [
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontFeatures: [FontFeature.tabularFigures()])),
            const SizedBox(width: 6),
            const Icon(Icons.edit_outlined, size: 16, color: C.muted),
          ]),
        ),
      );
}
