import 'dart:convert';
import 'dart:io';

/// Plays the user's part of the OAuth authorization code flow in MAS
/// (login form + consent) over plain HTTP, the same requests the system
/// browser sheet would send. Test-only; accepts the local dev CA.
class MasBrowser {
  MasBrowser({required this.callbackScheme});

  final String callbackScheme;
  final _cookies = <String, String>{};

  late final HttpClient _http = HttpClient()
    ..badCertificateCallback = (cert, host, port) => host == 'localhost';

  Future<String> authorize(
    String authorizationUrl,
    String username,
    String password,
  ) async {
    var page = await _follow(Uri.parse(authorizationUrl));

    for (var step = 0; step < 5; step++) {
      if (page.callback != null) {
        return page.callback!;
      }

      final csrf = RegExp(
        r'name="csrf" value="([^"]+)"',
      ).firstMatch(page.body)?.group(1);

      if (csrf == null) {
        throw StateError('MAS page without form at ${page.uri}');
      }

      final fields = page.body.contains('name="password"')
          ? {'csrf': csrf, 'username': username, 'password': password}
          : {'csrf': csrf, 'action': 'consent'};
      page = await _follow(page.uri, form: fields);
    }

    throw StateError('MAS flow did not finish');
  }

  Future<_Page> _follow(Uri uri, {Map<String, String>? form}) async {
    var current = uri;
    var body = form;

    while (true) {
      final request = body == null
          ? await _http.getUrl(current)
          : await _http.postUrl(current);
      request.followRedirects = false;

      if (_cookies.isNotEmpty) {
        request.headers.set(
          HttpHeaders.cookieHeader,
          _cookies.entries
              .map((cookie) => '${cookie.key}=${cookie.value}')
              .join('; '),
        );
      }

      if (body != null) {
        request.headers.contentType = ContentType(
          'application',
          'x-www-form-urlencoded',
        );
        request.write(Uri(queryParameters: body).query);
      }

      final response = await request.close();

      for (final cookie in response.cookies) {
        _cookies[cookie.name] = cookie.value;
      }

      final text = await response.transform(utf8.decoder).join();
      final location = response.headers.value(HttpHeaders.locationHeader);
      body = null;

      if (location == null) {
        return _Page(current, text, null);
      }

      final next = current.resolve(location);

      if (next.scheme == callbackScheme) {
        return _Page(current, text, next.toString());
      }

      current = next;
    }
  }

  void close() => _http.close(force: true);
}

class _Page {
  _Page(this.uri, this.body, this.callback);

  final Uri uri;
  final String body;
  final String? callback;
}
