import 'dart:convert';
import 'dart:io';

import 'package:golden_app/generated/mobile_app_config.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

Future<void> main(List<String> arguments) async {
  final options = _options(arguments);

  if (options == null) {
    stderr.writeln(
      'Usage: dart run tool/request_release.dart '
      '--platform=<android|ios> --artifact-sha256=<sha256> '
      '--source-revision=<40-character-commit-sha> '
      '--build-number=<number> --result=/absolute/path/result.json',
    );
    exitCode = 64;

    return;
  }

  final resultFile = File(options.resultPath);

  if (await FileSystemEntity.type(resultFile.path, followLinks: false) !=
      FileSystemEntityType.notFound) {
    stderr.writeln('Release result target already exists.');
    exitCode = 1;

    return;
  }

  final setup = await _setupMetadata();
  final platform = switch (options.platform) {
    'android' => MobileReleasePlatform.android,
    'ios' => MobileReleasePlatform.ios,
    _ => throw StateError('Validated platform was not handled.'),
  };
  final distribution = _map(setup, 'distribution');
  final channel = _channel(platform, _string(distribution, options.platform));
  final environment = mobileAppConfiguration.forEnvironment(
    MobileEnvironment.production,
  );
  final gateway = MobileReleaseGateway(apiBaseUrl: environment.apiBaseUrl);

  try {
    final approval = await gateway.start(
      MobileReleaseArtifact(
        appId: _string(setup, 'app_id'),
        platform: platform,
        channel: channel,
        version: _string(setup, 'app_version'),
        buildNumber: options.buildNumber,
        sourceRevision: options.sourceRevision,
        artifactSha256: options.artifactSha256,
        sdkVersion: _string(setup, 'platform_sdk_version'),
        contractVersion: _string(setup, 'contract_version'),
      ),
    );
    stdout.writeln(
      'Organization approval required: ${approval.authorizationUri}',
    );
    stdout.writeln('Waiting for the immutable artifact to be approved.');

    final release = await gateway.waitForApproval(approval);
    await resultFile.parent.create(recursive: true);
    await resultFile.writeAsString(
      '${const JsonEncoder.withIndent('  ').convert({'release_id': release.id, 'management_url': release.managementUri.toString()})}\n',
      flush: true,
    );
    stdout.writeln('Release ${release.id} was approved.');
  } on MobileApiException catch (error) {
    stderr.writeln('Release approval failed: ${error.problem}');
    exitCode = 1;
  } on Object catch (error) {
    stderr.writeln('Release approval failed: ${error.runtimeType}.');
    exitCode = 1;
  } finally {
    gateway.close();
  }
}

Future<Map<String, Object?>> _setupMetadata() async {
  final source = await File('.ngotools-setup.json').readAsString();
  final decoded = jsonDecode(source);

  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('Invalid setup provenance.');
  }

  return decoded.cast<String, Object?>();
}

MobileReleaseChannel _channel(
  MobileReleasePlatform platform,
  String distribution,
) => switch ((platform, distribution)) {
  (MobileReleasePlatform.android, 'internal_testing') =>
    MobileReleaseChannel.internal,
  (MobileReleasePlatform.android, 'closed_testing') =>
    MobileReleaseChannel.beta,
  (MobileReleasePlatform.android, 'managed_private') ||
  (MobileReleasePlatform.android, 'public') ||
  (MobileReleasePlatform.ios, 'private') ||
  (MobileReleasePlatform.ios, 'public') => MobileReleaseChannel.production,
  (MobileReleasePlatform.ios, 'testflight') => MobileReleaseChannel.beta,
  _ => throw FormatException(
    'Unsupported ${platform.name} distribution.',
    distribution,
  ),
};

Map<String, Object?> _map(Map<String, Object?> value, String key) {
  final nested = value[key];

  if (nested is! Map<String, dynamic>) {
    throw FormatException('Missing setup field.', key);
  }

  return nested.cast<String, Object?>();
}

String _string(Map<String, Object?> value, String key) {
  final text = value[key];

  if (text is! String || text.isEmpty) {
    throw FormatException('Missing setup field.', key);
  }

  return text;
}

_ReleaseOptions? _options(List<String> arguments) {
  final values = <String, String>{};

  for (final argument in arguments) {
    final separator = argument.indexOf('=');

    if (!argument.startsWith('--') || separator < 3) {
      return null;
    }

    values[argument.substring(2, separator)] = argument.substring(
      separator + 1,
    );
  }

  if (values.keys.toSet().difference(const {
    'platform',
    'artifact-sha256',
    'source-revision',
    'build-number',
    'result',
  }).isNotEmpty) {
    return null;
  }

  final platform = values['platform'];
  final artifactSha256 = values['artifact-sha256'];
  final sourceRevision = values['source-revision'];
  final buildNumber = values['build-number'];
  final resultPath = values['result'];

  if (!const {'android', 'ios'}.contains(platform) ||
      artifactSha256 == null ||
      sourceRevision == null ||
      buildNumber == null ||
      resultPath == null ||
      !File(resultPath).isAbsolute) {
    return null;
  }

  return _ReleaseOptions(
    platform: platform!,
    artifactSha256: artifactSha256,
    sourceRevision: sourceRevision,
    buildNumber: buildNumber,
    resultPath: resultPath,
  );
}

final class _ReleaseOptions {
  const _ReleaseOptions({
    required this.platform,
    required this.artifactSha256,
    required this.sourceRevision,
    required this.buildNumber,
    required this.resultPath,
  });

  final String platform;
  final String artifactSha256;
  final String sourceRevision;
  final String buildNumber;
  final String resultPath;
}
