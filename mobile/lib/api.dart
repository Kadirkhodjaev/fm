import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

/// Адрес сервера по умолчанию. Для проверки по Wi-Fi: flutter run --dart-define=API_BASE=http://192.168.68.56:9999
/// На экране входа адрес можно поменять (кнопка «Сервер»).
const String kDefaultBase = String.fromEnvironment('API_BASE', defaultValue: 'http://192.168.68.56:9999');

class ApiException implements Exception {
  final int status;
  final String code;
  final String message;
  ApiException(this.status, this.code, this.message);
  bool get needLogin => status == 401;
  @override
  String toString() => message;
}

/// Клиент API fm (/api/m/v1). Токены в защищённом хранилище, access-токен продлевается сам.
class Api {
  Api._();
  static final Api I = Api._();

  final _store = const FlutterSecureStorage();
  String base = kDefaultBase;
  String? _access;
  String? _refresh;
  String? phone;

  /// Вызывается, когда сессия закончилась и нужно войти заново
  void Function()? onLoggedOut;

  Future<void> load() async {
    base = await _store.read(key: 'base') ?? kDefaultBase;
    _access = await _store.read(key: 'access');
    _refresh = await _store.read(key: 'refresh');
    phone = await _store.read(key: 'phone');
  }

  bool get loggedIn => _refresh != null;

  Future<void> setBase(String b) async {
    var v = b.trim();
    while (v.endsWith('/')) {
      v = v.substring(0, v.length - 1);
    }
    if (!v.startsWith('http')) v = 'http://$v';
    base = v;
    await _store.write(key: 'base', value: v);
  }

  Uri _uri(String path, [Map<String, String>? q]) => Uri.parse('$base/api/m/v1$path').replace(queryParameters: q);

  Future<void> _saveTokens(Map<String, dynamic> j) async {
    _access = j['accessToken'];
    _refresh = j['refreshToken'];
    if (j['phone'] != null) phone = j['phone'];
    await _store.write(key: 'access', value: _access);
    await _store.write(key: 'refresh', value: _refresh);
    if (phone != null) await _store.write(key: 'phone', value: phone);
  }

  Future<void> clear() async {
    _access = null;
    _refresh = null;
    await _store.delete(key: 'access');
    await _store.delete(key: 'refresh');
  }

  Map<String, dynamic> _decode(http.Response r) {
    Map<String, dynamic> j;
    try {
      j = jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException(r.statusCode, 'bad_response', 'Сервер клиники ответил с ошибкой (${r.statusCode}).');
    }
    if (r.statusCode >= 400 || j['error'] != null) {
      throw ApiException(r.statusCode, '${j['error'] ?? 'error'}', '${j['message'] ?? 'Ошибка'}');
    }
    return j;
  }

  Future<http.Response> _send(String method, String path, {Object? body, Map<String, String>? query, bool auth = true}) async {
    final headers = <String, String>{'Content-Type': 'application/json; charset=utf-8', 'Accept': 'application/json'};
    if (auth && _access != null) headers['Authorization'] = 'Bearer $_access';
    final uri = _uri(path, query);
    final data = body == null ? null : jsonEncode(body);
    try {
      switch (method) {
        case 'GET':
          return await http.get(uri, headers: headers).timeout(const Duration(seconds: 30));
        case 'PUT':
          return await http.put(uri, headers: headers, body: data).timeout(const Duration(seconds: 30));
        default:
          return await http.post(uri, headers: headers, body: data).timeout(const Duration(seconds: 60));
      }
    } on SocketException {
      throw ApiException(0, 'offline', 'Нет связи с сервером клиники. Проверьте интернет.');
    } on HttpException {
      throw ApiException(0, 'offline', 'Нет связи с сервером клиники.');
    } on Exception catch (e) {
      if ('$e'.contains('TimeoutException')) throw ApiException(0, 'timeout', 'Сервер клиники долго не отвечает. Попробуйте ещё раз.');
      throw ApiException(0, 'offline', 'Нет связи с сервером клиники.');
    }
  }

  Future<Map<String, dynamic>> call(String method, String path, {Object? body, Map<String, String>? query}) async {
    var r = await _send(method, path, body: body, query: query);
    if (r.statusCode == 401 && _refresh != null) {
      // access-токен устарел: продлеваем по refresh-токену и повторяем запрос
      if (await _tryRefresh()) {
        r = await _send(method, path, body: body, query: query);
      }
    }
    if (r.statusCode == 401) {
      await clear();
      onLoggedOut?.call();
    }
    return _decode(r);
  }

  Future<bool> _tryRefresh() async {
    try {
      final r = await _send('POST', '/auth/refresh', body: {'refreshToken': _refresh}, auth: false);
      if (r.statusCode != 200) return false;
      await _saveTokens(_decode(r));
      return true;
    } catch (_) {
      return false;
    }
  }

  // ---------- Вход ----------

  Future<Map<String, dynamic>> sendCode(String phone) async =>
      _decode(await _send('POST', '/auth/code', body: {'phone': phone}, auth: false));

  Future<Map<String, dynamic>> verify(String phone, String code) async {
    final j = _decode(await _send('POST', '/auth/verify',
        body: {'phone': phone, 'code': code, 'device': Platform.operatingSystem, 'platform': Platform.isIOS ? 'ios' : 'android'}, auth: false));
    await _saveTokens(j);
    return j;
  }

  Future<void> logout() async {
    try {
      await _send('POST', '/auth/logout');
    } catch (_) {}
    await clear();
  }

  // ---------- Данные ----------

  Future<Map<String, dynamic>> clients() => call('GET', '/clients');
  Future<Map<String, dynamic>> stays(int clientId) => call('GET', '/clients/$clientId/stays');
  Future<Map<String, dynamic>> visits(int clientId) => call('GET', '/clients/$clientId/visits');
  Future<Map<String, dynamic>> homePlan(int clientId) => call('GET', '/clients/$clientId/home-plan');
  Future<Map<String, dynamic>> day(int stayId, [String? date]) => call('GET', '/stays/$stayId/day', query: date == null ? null : {'date': date});
  Future<Map<String, dynamic>> progress(int stayId) => call('GET', '/stays/$stayId/progress');
  Future<Map<String, dynamic>> exams(int stayId) => call('GET', '/stays/$stayId/exams');
  Future<Map<String, dynamic>> questions(int stayId) => call('GET', '/stays/$stayId/questions');
  Future<Map<String, dynamic>> ask(int stayId, String text) => call('POST', '/stays/$stayId/questions', body: {'text': text});
  Future<Map<String, dynamic>> notifications() => call('GET', '/notifications');
  Future<Map<String, dynamic>> settings() => call('GET', '/settings');
  Future<Map<String, dynamic>> saveSettings(Map<String, dynamic> s) => call('PUT', '/settings', body: s);

  /// Ссылка на файл (PDF результатов или выписка) живёт 10 минут; файл скачивается во временную папку
  Future<File> download(String kind, int id, String dir) async {
    final link = await call('POST', '/files', body: {'kind': kind, 'id': id});
    final url = '$base${link['url']}';
    final http.Response r;
    try {
      r = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 120));
    } catch (_) {
      throw ApiException(0, 'offline', 'Не удалось скачать файл. Проверьте интернет.');
    }
    if (r.statusCode != 200) _decode(r);
    final name = '${kind}_$id.${link['type']}';
    final f = File('$dir/$name');
    await f.writeAsBytes(r.bodyBytes, flush: true);
    return f;
  }
}
