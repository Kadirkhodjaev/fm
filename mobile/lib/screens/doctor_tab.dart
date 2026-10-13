import 'package:flutter/material.dart';

import '../api.dart';
import '../fmt.dart';
import '../theme.dart';
import '../widgets.dart';

/// Вопрос лечащему врачу во время лечения в стационаре (вопрос уходит врачу в бот сотрудников)
class DoctorTab extends StatefulWidget {
  final Map<String, dynamic> client;
  const DoctorTab({super.key, required this.client});
  @override
  State<DoctorTab> createState() => _DoctorTabState();
}

class _DoctorTabState extends State<DoctorTab> {
  final text = TextEditingController();
  bool sending = false;
  int version = 0;

  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  int get stayId => asInt(asMap(widget.client['stay'])['id']);

  Future<void> send() async {
    final t = text.text.trim();
    if (t.isEmpty || sending) return;
    setState(() => sending = true);
    try {
      final r = await Api.I.ask(stayId, t);
      text.clear();
      if (mounted) toast(context, asStr(r['message']));
      version++;
    } on ApiException catch (e) {
      if (mounted) toast(context, e.message);
    }
    if (mounted) setState(() => sending = false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.client['stay'] == null) {
      return TabPage([
        const H2('Вопрос врачу'),
        Empty('Доступно во время лечения в стационаре',
            'Вопрос уходит лечащему врачу. Сейчас у ${asStr(widget.client['firstName'])} нет лечения в стационаре. По визитам в амбулаторию звоните в регистратуру.'),
      ]);
    }
    return Loader(
      key: ValueKey('q-$version'),
      load: () => Api.I.questions(stayId),
      builder: (ctx, d, reload) {
        final items = asList(d['items']);
        final doctor = asStr(d['doctor']);
        return Column(children: [
          Expanded(
            child: TabPage([
              H2('Вопрос врачу', sub: '${doctor.isEmpty ? 'Лечащий врач' : doctor} · отвечает на обходе или в рабочее время'),
              if (items.isEmpty) const Empty('Вопросов пока нет', 'Напишите вопрос ниже, и он придёт лечащему врачу.'),
              for (final x in items) ..._msg(asMap(x)),
              const SizedBox(height: 4),
              const Muted('Если врач не на связи, вопрос увидит постовая медсестра. Срочные вопросы задавайте на посту.'),
            ]),
          ),
          Container(
            color: C.surface,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: text,
                  minLines: 1,
                  maxLines: 4,
                  maxLength: 2000,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(hintText: 'Напишите вопрос', counterText: '', contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(onPressed: sending ? null : send, child: const Text('Отправить')),
            ]),
          ),
        ]);
      },
    );
  }

  List<Widget> _msg(Map<String, dynamic> q) {
    return [
      Align(
        alignment: Alignment.centerRight,
        child: _bubble(asStr(q['text']), '${dmy(q['created'])} ${hm(q['created'])}${q['delivered'] == true ? '' : ' · не доставлено'}', true),
      ),
      if (asStr(q['answer']).isNotEmpty)
        Align(
          alignment: Alignment.centerLeft,
          child: _bubble(asStr(q['answer']), '${hm(q['answeredAt'])} · ${asStr(q['answeredBy'])}', false),
        ),
      const SizedBox(height: 6),
    ];
  }

  Widget _bubble(String t, String meta, bool me) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .78),
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: me ? C.graphite : C.surface,
        border: me ? null : Border.all(color: C.line),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(14),
          topRight: const Radius.circular(14),
          bottomLeft: Radius.circular(me ? 14 : 4),
          bottomRight: Radius.circular(me ? 4 : 14),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t, style: TextStyle(color: me ? Colors.white : C.fg, fontSize: 14)),
        const SizedBox(height: 3),
        Text(meta, style: TextStyle(color: (me ? Colors.white : C.fg).withAlpha(180), fontSize: 11)),
      ]),
    );
  }
}
