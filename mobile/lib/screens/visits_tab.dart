import 'package:flutter/material.dart';

import '../api.dart';
import '../files.dart';
import '../fmt.dart';
import '../theme.dart';
import '../widgets.dart';

/// Визиты в амбулаторию: услуги со статусом и PDF результатов (как «Мои результаты» в боте)
class VisitsTab extends StatelessWidget {
  final Map<String, dynamic> client;
  const VisitsTab({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Loader(
      load: () => Api.I.visits(asInt(client['id'])),
      builder: (ctx, d, reload) {
        final items = asList(d['items']);
        return TabPage([
          H2('Визиты в амбулаторию', sub: '${client['name']} · ${items.length} ${plural(items.length, 'визит', 'визита', 'визитов')}'),
          if (items.isEmpty) const Empty('Визитов пока нет', 'Когда вы придёте в клинику, здесь появятся услуги и результаты.'),
          for (var i = 0; i < items.length; i++) VisitCard(visit: asMap(items[i]), open: i == 0),
        ]);
      },
    );
  }
}

class VisitCard extends StatelessWidget {
  final Map<String, dynamic> visit;
  final bool open;
  const VisitCard({super.key, required this.visit, this.open = false});

  @override
  Widget build(BuildContext context) {
    final services = asList(visit['services']);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: C.line)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: open,
          shape: const Border(),
          collapsedShape: const Border(),
          tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          title: Text(dmy(visit['date']), style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Muted('${services.length} ${plural(services.length, 'услуга', 'услуги', 'услуг')}'),
          trailing: Tag.status(asStr(visit['status'])),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < services.length; i++)
              Line(first: i == 0, title: asStr(asMap(services[i])['name']), trailing: Tag.status(asStr(asMap(services[i])['status']))),
            const SizedBox(height: 8),
            if (visit['pdf'] == true)
              FilledButton.icon(
                onPressed: () => openFile(context, 'result', asInt(visit['id'])),
                icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                label: const Text('Результаты PDF'),
              )
            else
              const Muted('Результаты появятся здесь, когда будут готовы.'),
            if (visit['pdf'] == true && visit['status'] != 'ok')
              const Padding(padding: EdgeInsets.only(top: 6), child: Muted('Часть услуг ещё в работе: в PDF только готовые.')),
          ],
        ),
      ),
    );
  }
}
