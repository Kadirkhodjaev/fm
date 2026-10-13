/// Даты и склонения по-русски без лишних пакетов.
const _months = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
const _monthsShort = ['янв', 'фев', 'мар', 'апр', 'мая', 'июн', 'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'];
const _weekdays = ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'];

DateTime? parseDate(dynamic s) => s == null ? null : DateTime.tryParse('$s');

String two(int n) => n.toString().padLeft(2, '0');

/// 05.10.2026
String dmy(dynamic s) {
  final d = parseDate(s);
  return d == null ? '' : '${two(d.day)}.${two(d.month)}.${d.year}';
}

/// 05.10
String dm(dynamic s) {
  final d = parseDate(s);
  return d == null ? '' : '${two(d.day)}.${two(d.month)}';
}

/// 9 октября
String dayMonth(dynamic s) {
  final d = parseDate(s);
  return d == null ? '' : '${d.day} ${_months[d.month - 1]}';
}

/// 10 окт
String dayMonthShort(dynamic s) {
  final d = parseDate(s);
  return d == null ? '' : '${d.day} ${_monthsShort[d.month - 1]}';
}

/// Понедельник, 12 октября
String weekdayDate(dynamic s) {
  final d = parseDate(s);
  return d == null ? '' : '${_weekdays[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]}';
}

/// 12:14
String hm(dynamic s) {
  final d = parseDate(s);
  return d == null ? '' : '${two(d.hour)}:${two(d.minute)}';
}

String plural(int n, String one, String few, String many) {
  final a = n.abs() % 100, b = a % 10;
  if (a > 10 && a < 20) return many;
  if (b == 1) return one;
  if (b >= 2 && b <= 4) return few;
  return many;
}

String isoDate(DateTime d) => '${d.year}-${two(d.month)}-${two(d.day)}';
