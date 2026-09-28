import 'dart:convert';
import 'dart:io';

import 'package:ngo_tools_mobile_platform/mobile_platform_tooling.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

Future<void> main(List<String> arguments) async {
  final options = _options(arguments);

  if (options == null) {
    stderr.writeln(
      'Usage: dart run tool/live_preview.dart '
      '--app=/absolute/path/preview-app '
      '--tenant=<organization-slug> '
      '[--modules=contacts,events] [--platform=ios|android] '
      '[--base-url=https://<organization-slug>.ngo.tools]',
    );
    exitCode = 64;

    return;
  }

  try {
    final app = Directory(options['app']!);
    final manifest = await _manifest(app);
    final tenant = options['tenant']!;
    final request = LivePreviewRequest(
      tenant: tenant,
      modules:
          options['modules']?.split(',').map((module) => module.trim()) ??
          manifest.modules,
      platform: options['platform'] ?? 'ios',
      redirectUri: manifest.redirectUri,
    );
    final client = LivePreviewClient(
      baseUrl: Uri.parse(options['base-url'] ?? 'https://$tenant.ngo.tools'),
    );

    final start = await client.start(request);

    stdout
      ..writeln('Live-Vorschau angefordert für $tenant.')
      ..writeln('Ein Organisationsadmin öffnet jetzt diesen Link:')
      ..writeln('  ${start.authorizationUrl}')
      ..writeln('und prüft den Code: ${start.userCode}')
      ..writeln(
        'Nur freigeben, wenn Du oder Dein Team diese Vorschau gerade selbst '
        'gestartet habt. Die App darf danach 8 Stunden lang lesen.',
      )
      ..writeln('Warte auf die Freigabe …');

    final result = await client.waitForDecision(start);

    switch (result) {
      case LivePreviewApproved(:final configuration):
        _requireMatch(configuration, request);
        await _write(app, manifest, configuration);
        stdout
          ..writeln('Freigegeben. Konfiguration geschrieben.')
          ..writeln(
            'Starten: cd ${app.path} && flutter run -t lib/main_development.dart',
          )
          ..writeln(
            'Zugriff bis ${configuration.expiresAt.toLocal()} '
            '(Module: ${configuration.modules.join(', ')}).',
          );
      case LivePreviewRejected(:final code):
        stderr.writeln(switch (code) {
          'access_denied' => 'Die Vorschau wurde abgelehnt.',
          'preview_revoked' => 'Die Vorschau wurde widerrufen.',
          'expired_preview' =>
            'Die Freigabe ist abgelaufen. Bitte neu starten.',
          _ => 'Die Vorschau ist nicht mehr gültig ($code).',
        });
        exitCode = 1;
      case LivePreviewPending():
        stderr.writeln('Keine Entscheidung erhalten.');
        exitCode = 1;
    }
  } on FormatException catch (error) {
    stderr.writeln('Live-Vorschau abgebrochen: ${error.message}');
    exitCode = 1;
  } on Object catch (error) {
    stderr.writeln('Live-Vorschau abgebrochen: $error');
    exitCode = 1;
  }
}

void _requireMatch(
  LivePreviewConfiguration configuration,
  LivePreviewRequest request,
) {
  if (configuration.tenant != request.tenant ||
      configuration.platform != request.platform ||
      configuration.redirectUri != request.redirectUri ||
      configuration.modules
          .toSet()
          .difference(request.modules.toSet())
          .isNotEmpty) {
    throw const LivePreviewException(
      'The approved preview does not match the request.',
    );
  }
}

Future<void> _write(
  Directory app,
  _PreviewManifest manifest,
  LivePreviewConfiguration configuration,
) async {
  final generated = File(
    path.join(app.path, 'lib', 'generated', 'mobile_app_config.dart'),
  );
  await generated.writeAsString(
    renderLivePreviewConfiguration(
      configuration,
      defaultLocale: manifest.defaultLocale,
      locales: manifest.locales,
    ),
  );

  final summary = File(path.join(app.path, '.ngotools', 'live-preview.json'));
  await summary.parent.create(recursive: true);
  await summary.writeAsString(
    '${const JsonEncoder.withIndent('  ').convert(configuration.toSummary())}\n',
  );

  final formatted = await Process.run('dart', ['format', generated.path]);

  if (formatted.exitCode != 0) {
    throw const LivePreviewException(
      'The configuration could not be formatted.',
    );
  }
}

Future<_PreviewManifest> _manifest(Directory app) async {
  final file = File(path.join(app.path, 'ngo-tools.mobile.yaml'));

  if (!await file.exists()) {
    throw FormatException('No ngo-tools.mobile.yaml found in ${app.path}.');
  }

  final yaml = loadYaml(await file.readAsString());
  final redirectUri = _at(yaml, const [
    'backend',
    'environments',
    'development',
    'oidc',
    'redirectUri',
  ]);
  final localization = _at(yaml, const ['localization']);
  final features = _at(yaml, const ['features']);

  if (redirectUri is! String ||
      localization is! YamlMap ||
      features is! YamlMap) {
    throw const FormatException(
      'The preview app manifest lacks a development redirect, locales or modules.',
    );
  }

  return _PreviewManifest(
    redirectUri: redirectUri,
    defaultLocale: '${localization['defaultLocale']}',
    locales: [
      for (final locale in localization['locales'] as YamlList) '$locale',
    ],
    modules: [
      for (final module in features['modules'] as YamlList)
        if (livePreviewModules.contains('$module')) '$module',
    ],
  );
}

Object? _at(Object? node, List<String> keys) {
  var current = node;

  for (final key in keys) {
    if (current is! YamlMap) {
      return null;
    }

    current = current[key];
  }

  return current;
}

final class _PreviewManifest {
  const _PreviewManifest({
    required this.redirectUri,
    required this.defaultLocale,
    required this.locales,
    required this.modules,
  });

  final String redirectUri;
  final String defaultLocale;
  final List<String> locales;
  final List<String> modules;
}

Map<String, String>? _options(List<String> arguments) {
  const allowed = {'app', 'tenant', 'modules', 'platform', 'base-url'};
  final values = <String, String>{};

  for (final argument in arguments) {
    final separator = argument.indexOf('=');

    if (!argument.startsWith('--') || separator < 3) {
      return null;
    }

    final key = argument.substring(2, separator);

    if (!allowed.contains(key)) {
      return null;
    }

    values[key] = argument.substring(separator + 1);
  }

  if (values['app'] == null ||
      values['tenant'] == null ||
      !path.isAbsolute(values['app']!)) {
    return null;
  }

  return values;
}
