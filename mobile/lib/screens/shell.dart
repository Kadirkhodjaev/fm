import 'package:flutter/material.dart';

import '../api.dart';
import '../theme.dart';
import '../widgets.dart';
import 'doctor_tab.dart';
import 'home_tab.dart';
import 'login.dart';
import 'notifications.dart';
import 'profile_tab.dart';
import 'stay_tab.dart';
import 'visits_tab.dart';

/// Главный экран: переключатель клиентов наверху, пять вкладок внизу
class Shell extends StatefulWidget {
  final VoidCallback onLogout;
  const Shell({super.key, required this.onLogout});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  List<Map<String, dynamic>> clients = [];
  int cur = 0;
  int tab = 0;
  String? error;
  bool loading = true;
  int stamp = 0; // меняется при обновлении: вкладки перезагружают данные

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() {
      loading = clients.isEmpty;
      error = null;
    });
    try {
      final r = await Api.I.clients();
      clients = asList(r['clients']).map((e) => asMap(e)).toList();
      if (cur >= clients.length) cur = 0;
      stamp++;
    } on ApiException catch (e) {
      error = e.message;
    }
    if (mounted) setState(() => loading = false);
  }

  void go(int t) => setState(() => tab = t);

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: C.graphite)));
    if (clients.isEmpty) {
      return Scaffold(
        body: SafeArea(
          child: TabPage([
            Empty('Нет данных', error ?? 'На этот номер не найдено ни одной карточки. Обратитесь в регистратуру.'),
            FilledButton(onPressed: load, child: const Text('Повторить')),
            const SizedBox(height: 8),
            OutlinedButton(
                onPressed: () async {
                  await Api.I.logout();
                  widget.onLogout();
                },
                child: const Text('Выйти')),
          ]),
        ),
      );
    }
    final c = clients[cur];
    final key = ValueKey('${c['id']}-$stamp');
    final pages = [
      HomeTab(key: key, client: c, go: go),
      StayTab(key: key, client: c),
      VisitsTab(key: key, client: c),
      DoctorTab(key: key, client: c),
      ProfileTab(key: ValueKey('p-$stamp'), clients: clients, onChanged: load, onLogout: widget.onLogout),
    ];
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          _top(),
          Expanded(child: pages[tab]),
        ]),
      ),
      bottomNavigationBar: _tabs(),
    );
  }

  Widget _top() {
    return Container(
      color: C.surface,
      padding: const EdgeInsets.fromLTRB(16, 6, 8, 10),
      child: Column(children: [
        Row(children: [
          Image.asset('assets/logo_fms_h.png', height: 22),
          const Spacer(),
          IconButton(
            tooltip: 'Уведомления',
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsScreen(clients: clients))),
          ),
        ]),
        const SizedBox(height: 6),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: clients.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (ctx, i) => _chip(i),
          ),
        ),
      ]),
    );
  }

  Widget _chip(int i) {
    final c = clients[i];
    final on = i == cur;
    return InkWell(
      borderRadius: BorderRadius.circular(99),
      onTap: () => setState(() => cur = i),
      child: Container(
        padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
        decoration: BoxDecoration(
          color: on ? C.graphite : C.bg,
          border: Border.all(color: on ? C.graphite : C.line),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Avatar(asStr(c['initials']), i, inverted: on),
          const SizedBox(width: 7),
          Text(asStr(c['firstName']).isEmpty ? asStr(c['name']) : asStr(c['firstName']),
              style: TextStyle(fontSize: 13, color: on ? Colors.white : C.fg, fontWeight: on ? FontWeight.w600 : FontWeight.w400)),
          if (c['stay'] != null) ...[
            const SizedBox(width: 6),
            Container(width: 7, height: 7, decoration: const BoxDecoration(color: C.red, shape: BoxShape.circle)),
          ],
        ]),
      ),
    );
  }

  Widget _tabs() {
    const items = [
      (Icons.home_outlined, 'Главная'),
      (Icons.hotel_outlined, 'Лечение'),
      (Icons.description_outlined, 'Визиты'),
      (Icons.chat_bubble_outline, 'Врач'),
      (Icons.person_outline, 'Профиль'),
    ];
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: C.surface,
        indicatorColor: C.redSoft,
        labelTextStyle: WidgetStateProperty.resolveWith((s) => TextStyle(
            fontSize: 11, color: s.contains(WidgetState.selected) ? C.fg : C.muted, fontWeight: s.contains(WidgetState.selected) ? FontWeight.w600 : FontWeight.w400)),
        iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(color: s.contains(WidgetState.selected) ? C.redDark : C.muted)),
      ),
      child: Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: C.line))),
        child: NavigationBar(
          height: 64,
          selectedIndex: tab,
          onDestinationSelected: go,
          destinations: [for (final it in items) NavigationDestination(icon: Icon(it.$1), label: it.$2)],
        ),
      ),
    );
  }
}
