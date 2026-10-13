import 'package:flutter/material.dart';

import '../api.dart';
import '../fmt.dart';
import '../theme.dart';
import '../widgets.dart';

/// История уведомлений по всем клиентам номера (то, что ушло в push или в Telegram-бот)
class NotificationsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> clients;
  const NotificationsScreen({super.key, required this.clients});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Уведомления', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18))),
      body: Loader(
        load: Api.I.notifications,
        builder: (ctx, d, reload) {
          final items = asList(d['items']);
          return TabPage([
            if (items.isEmpty) const Empty('Уведомлений пока нет', 'Здесь будут напоминания о препаратах, готовые результаты и ответы врача.'),
            for (final x in items)
              Box(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(asStr(asMap(x)['title']), style: const TextStyle(fontWeight: FontWeight.w600))),
                    Muted('${dm(asMap(x)['created'])} ${hm(asMap(x)['created'])}', size: 12),
                  ]),
                  if (asStr(asMap(x)['body']).isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(asStr(asMap(x)['body']), style: const TextStyle(color: C.fg, fontSize: 13.5)),
                  ],
                ]),
              ),
          ]);
        },
      ),
    );
  }
}
