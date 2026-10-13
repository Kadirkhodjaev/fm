import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api.dart';
import '../theme.dart';
import '../widgets.dart';

/// Вход: номер -> код из Telegram-бота (или SMS) -> список клиентов на номере
class LoginFlow extends StatefulWidget {
  final VoidCallback onDone;
  const LoginFlow({super.key, required this.onDone});
  @override
  State<LoginFlow> createState() => _LoginFlowState();
}

class _LoginFlowState extends State<LoginFlow> {
  int step = 0; // 0 номер, 1 код, 2 найденные клиенты
  final phone = TextEditingController(text: '998 ');
  final code = TextEditingController();
  bool busy = false;
  String? error;
  String via = 'telegram';
  List<dynamic> clients = const [];
  int resendIn = 0;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    phone.dispose();
    code.dispose();
    super.dispose();
  }

  Future<void> sendCode() async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final r = await Api.I.sendCode(phone.text);
      via = asStr(r['via']);
      code.text = asStr(r['debugCode']); // только в режиме проверки на компьютере разработчика
      step = 1;
      startTimer(asInt(r['resendIn']));
    } on ApiException catch (e) {
      error = e.message;
    }
    if (mounted) setState(() => busy = false);
  }

  void startTimer(int sec) {
    timer?.cancel();
    resendIn = sec;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => resendIn--);
      if (resendIn <= 0) t.cancel();
    });
  }

  Future<void> verify() async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final r = await Api.I.verify(phone.text, code.text);
      clients = asList(r['clients']);
      step = 2;
    } on ApiException catch (e) {
      error = e.message;
    }
    if (mounted) setState(() => busy = false);
  }

  Future<void> server() async {
    final c = TextEditingController(text: Api.I.base);
    final v = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Адрес сервера'),
        content: TextField(controller: c, keyboardType: TextInputType.url, decoration: const InputDecoration(hintText: 'http://192.168.1.10:9999')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          FilledButton(onPressed: () => Navigator.pop(ctx, c.text), child: const Text('Сохранить')),
        ],
      ),
    );
    if (v != null && v.trim().isNotEmpty) {
      await Api.I.setBase(v);
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (ctx, box) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: box.maxHeight - 56),
              child: IntrinsicHeight(child: [phoneStep, codeStep, foundStep][step]()),
            ),
          ),
        ),
      ),
    );
  }

  Widget err() => error == null
      ? const SizedBox.shrink()
      : Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: C.redSoft, borderRadius: BorderRadius.circular(10)),
          child: Text(error!, style: const TextStyle(color: C.redDark)),
        );

  Widget bigButton(String text, VoidCallback? onTap) => SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: busy ? null : onTap,
          style: FilledButton.styleFrom(padding: const EdgeInsets.all(15), textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          child: busy ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(text),
        ),
      );

  Widget phoneStep() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      GestureDetector(onLongPress: server, child: Image.asset('assets/logo_fms_h.png', width: 210)),
      const SizedBox(height: 22),
      const Text('Вход', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
      const SizedBox(height: 4),
      const Muted('Номер телефона, который вы указали в регистратуре клиники.', size: 14),
      const SizedBox(height: 16),
      TextField(
        controller: phone,
        keyboardType: TextInputType.phone,
        style: const TextStyle(fontSize: 18, fontFeatures: [FontFeature.tabularFigures()]),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9 +]')), _PhoneFormatter()],
        decoration: const InputDecoration(prefixText: '+ '),
        onSubmitted: (_) => sendCode(),
      ),
      err(),
      const SizedBox(height: 14),
      bigButton('Получить код', sendCode),
      const Spacer(),
      const SizedBox(height: 20),
      const Center(
        child: Text('Код придёт в Telegram-бот клиники, если вы в нём зарегистрированы, иначе по SMS.',
            textAlign: TextAlign.center, style: TextStyle(color: C.muted, fontSize: 13)),
      ),
      Center(child: TextButton(onPressed: server, child: Text('Сервер: ${Api.I.base}', style: const TextStyle(color: C.muted, fontSize: 12)))),
    ]);
  }

  Widget codeStep() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      OutlinedButton.icon(
        onPressed: () => setState(() {
          step = 0;
          error = null;
        }),
        icon: const Icon(Icons.arrow_back, size: 18),
        label: const Text('Назад'),
      ),
      const SizedBox(height: 18),
      const Text('Введите код', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
      const SizedBox(height: 4),
      Muted(
          via == 'sms'
              ? 'Отправили 4 цифры по SMS на номер ${phone.text}.'
              : via == 'debug'
                  ? 'Режим проверки: код подставлен сам.'
                  : 'Отправили 4 цифры в Telegram-бот клиники на номер ${phone.text}.',
          size: 14),
      const SizedBox(height: 16),
      TextField(
        controller: code,
        autofocus: true,
        keyboardType: TextInputType.number,
        maxLength: 4,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600, letterSpacing: 18),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(counterText: '', hintText: '••••'),
        onChanged: (v) {
          if (v.length == 4 && !busy) verify();
        },
      ),
      err(),
      const SizedBox(height: 14),
      bigButton('Войти', verify),
      const SizedBox(height: 8),
      resendIn > 0
          ? Muted('Отправить код ещё раз через 0:${resendIn.toString().padLeft(2, '0')}')
          : TextButton(onPressed: busy ? null : sendCode, child: const Text('Отправить код ещё раз')),
    ]);
  }

  Widget foundStep() {
    final n = clients.length;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(n == 1 ? 'На ваш номер записан 1 клиент' : 'На ваш номер записаны $n ${n < 5 ? 'клиента' : 'клиентов'}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, height: 1.25)),
      const SizedBox(height: 6),
      if (n > 1) const Muted('Например, дети, которых записали на номер родителя. Всех вы увидите в приложении.', size: 14),
      const SizedBox(height: 14),
      for (var i = 0; i < n; i++) _foundRow(asMap(clients[i]), i),
      const SizedBox(height: 6),
      const Muted('Если здесь чужой человек, сообщите в регистратуру, и номер в его карточке исправят.'),
      const Spacer(),
      const SizedBox(height: 20),
      bigButton('Продолжить', widget.onDone),
    ]);
  }

  Widget _foundRow(Map<String, dynamic> c, int i) {
    final info = [
      if (c['birthyear'] != null) '${c['birthyear']} г.р.',
      if (c['stay'] != null) 'сейчас в стационаре' else if (c['home'] == true) 'лечение дома после выписки',
    ].join(' · ');
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(border: Border.all(color: C.line), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Avatar(asStr(c['initials']), i, size: 36),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(asStr(c['name']), style: const TextStyle(fontWeight: FontWeight.w600)),
            if (info.isNotEmpty) Muted(info),
          ]),
        ),
      ]),
    );
  }
}

/// Форматирует номер как 998 90 123 45 67
class _PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var d = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (d.length > 12) d = d.substring(0, 12);
    final parts = <String>[];
    const sizes = [3, 2, 3, 2, 2];
    var p = 0;
    for (final s in sizes) {
      if (p >= d.length) break;
      final e = (p + s) > d.length ? d.length : p + s;
      parts.add(d.substring(p, e));
      p = e;
    }
    final t = parts.join(' ');
    return TextEditingValue(text: t, selection: TextSelection.collapsed(offset: t.length));
  }
}

/// Круглый аватар с инициалами, цвет по номеру клиента
class Avatar extends StatelessWidget {
  final String text;
  final int index;
  final double size;
  final bool inverted;
  const Avatar(this.text, this.index, {super.key, this.size = 26, this.inverted = false});

  @override
  Widget build(BuildContext context) {
    const colors = [(C.redSoft, C.redDark), (C.blueSoft, C.blue), (C.amberSoft, C.amber), (C.greenSoft, C.green)];
    final (bg, fg) = inverted ? (Colors.white, C.graphite) : colors[index % colors.length];
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Text(text, style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: size * .42)),
    );
  }
}
