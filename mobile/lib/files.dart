import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import 'api.dart';
import 'widgets.dart';

/// Скачивает PDF результатов визита (kind = result) или выписку (kind = epicrisis) и открывает их
/// в программе телефона. Это тот же файл, что уходит кнопкой «Отправить результаты» в fm.
Future<void> openFile(BuildContext context, String kind, int id) async {
  toast(context, 'Готовлю файл…');
  try {
    final dir = await getTemporaryDirectory();
    final f = await Api.I.download(kind, id, dir.path);
    final r = await OpenFilex.open(f.path);
    if (r.type != ResultType.done && context.mounted) {
      toast(context, kind == 'result' ? 'Нет программы для просмотра PDF.' : 'Не удалось открыть файл.');
    }
  } on ApiException catch (e) {
    if (context.mounted) toast(context, e.message);
  } catch (_) {
    if (context.mounted) toast(context, 'Не удалось открыть файл.');
  }
}
