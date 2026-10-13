import 'package:flutter/material.dart';

import 'api.dart';
import 'theme.dart';

/// Белая карточка с рамкой
class Box extends StatelessWidget {
  final Widget child;
  final Color? accent;
  final Color? color;
  final EdgeInsets padding;
  const Box({super.key, required this.child, this.accent, this.color, this.padding = const EdgeInsets.all(14)});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color ?? C.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color != null ? Colors.transparent : C.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: accent == null ? null : BoxDecoration(border: Border(left: BorderSide(color: accent!, width: 4))),
        padding: padding,
        child: child,
      ),
    );
  }
}

/// Заголовок раздела: «УТРО ........ 08:00»
class Sec extends StatelessWidget {
  final String title;
  final String? right;
  const Sec(this.title, {super.key, this.right});

  @override
  Widget build(BuildContext context) {
    const st = TextStyle(fontSize: 12, letterSpacing: .8, color: C.muted, fontWeight: FontWeight.w500);
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 18, 2, 8),
      child: Row(children: [
        Expanded(child: Text(title.toUpperCase(), style: st)),
        if (right != null) Text(right!.toUpperCase(), style: st),
      ]),
    );
  }
}

enum St { ok, wait, plan, info, red, mute }

class Tag extends StatelessWidget {
  final String text;
  final St kind;
  const Tag(this.text, this.kind, {super.key});

  static Tag status(String? s) => s == 'ok'
      ? const Tag('Готово', St.ok)
      : s == 'plan'
          ? const Tag('Запланировано', St.mute)
          : const Tag('В работе', St.wait);

  static Tag result(String? s) => s == 'ok'
      ? const Tag('Результат готов', St.ok)
      : s == 'plan'
          ? const Tag('Запланировано', St.mute)
          : const Tag('В работе', St.wait);

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (kind) {
      St.ok => (C.greenSoft, C.green),
      St.wait => (C.amberSoft, C.amber),
      St.info => (C.blueSoft, C.blue),
      St.red => (C.redSoft, C.redDark),
      _ => (C.graySoft, C.muted),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

/// Строка списка: время слева, название и подпись, справа метка
class Line extends StatelessWidget {
  final String? time;
  final String title;
  final String? sub;
  final Widget? trailing;
  final bool first;
  const Line({super.key, this.time, required this.title, this.sub, this.trailing, this.first = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: first ? 2 : 10, bottom: 10),
      decoration: BoxDecoration(border: first ? null : const Border(top: BorderSide(color: C.line))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (time != null)
          SizedBox(
            width: 48,
            child: Text(time!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, fontFeatures: [FontFeature.tabularFigures()])),
          ),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            if (sub != null && sub!.isNotEmpty) Text(sub!, style: const TextStyle(fontSize: 12.5, color: C.muted)),
          ]),
        ),
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ]),
    );
  }
}

/// Список строк внутри карточки (первая без верхней линии)
List<Widget> lines(List<Line Function(bool first)> items) => [for (var i = 0; i < items.length; i++) items[i](i == 0)];

class Empty extends StatelessWidget {
  final String title;
  final String text;
  const Empty(this.title, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Box(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(children: [
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(text, textAlign: TextAlign.center, style: const TextStyle(color: C.muted)),
        ]),
      ),
    );
  }
}

class H2 extends StatelessWidget {
  final String text;
  final String? sub;
  const H2(this.text, {super.key, this.sub});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, height: 1.25)),
      if (sub != null && sub!.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 2), child: Text(sub!, style: const TextStyle(color: C.muted, fontSize: 13))),
      const SizedBox(height: 12),
    ]);
  }
}

class Muted extends StatelessWidget {
  final String text;
  final double size;
  const Muted(this.text, {super.key, this.size = 13});
  @override
  Widget build(BuildContext context) => Text(text, style: TextStyle(color: C.muted, fontSize: size));
}

void toast(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text), duration: const Duration(seconds: 3)));
}

/// Загрузка данных с экраном ожидания, ошибкой и обновлением жестом вниз
class Loader extends StatefulWidget {
  final Future<Map<String, dynamic>> Function() load;
  final Widget Function(BuildContext, Map<String, dynamic>, Future<void> Function() reload) builder;
  const Loader({super.key, required this.load, required this.builder});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  Map<String, dynamic>? data;
  String? error;
  bool busy = true;

  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  void didUpdateWidget(covariant Loader old) {
    super.didUpdateWidget(old);
    if (old.key != widget.key) reload();
  }

  Future<void> reload() async {
    setState(() {
      busy = data == null;
      error = null;
    });
    try {
      final d = await widget.load();
      if (!mounted) return;
      setState(() {
        data = d;
        busy = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e is ApiException ? e.message : 'Не удалось загрузить данные.';
        busy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (busy && data == null) return const Center(child: CircularProgressIndicator(color: C.graphite));
    if (error != null && data == null) {
      return ListView(padding: const EdgeInsets.all(16), children: [
        Empty('Не получилось загрузить', error!),
        OutlinedButton(onPressed: reload, child: const Text('Повторить')),
      ]);
    }
    return RefreshIndicator(color: C.graphite, onRefresh: reload, child: widget.builder(context, data!, reload));
  }
}

/// Прокручиваемая страница вкладки
class TabPage extends StatelessWidget {
  final List<Widget> children;
  const TabPage(this.children, {super.key});
  @override
  Widget build(BuildContext context) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: children,
      );
}

int asInt(dynamic v) => v is int ? v : int.tryParse('$v') ?? 0;
String asStr(dynamic v) => v == null ? '' : '$v';
List<dynamic> asList(dynamic v) => v is List ? v : const [];
Map<String, dynamic> asMap(dynamic v) => v is Map<String, dynamic> ? v : const {};
