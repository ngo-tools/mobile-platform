import 'dart:io';

import 'package:ngo_tools_mobile_platform/mobile_platform_tooling.dart';

Future<void> main(List<String> arguments) async {
  final options = _options(arguments);

  if (options == null) {
    stderr.writeln(
      'Usage: dart run tool/setup_app.dart '
      '--registration=/absolute/path/ngo-tools.mobile.yaml '
      '--output=/absolute/path/new-app '
      '--platform-ref=<40-character-commit-sha>',
    );
    exitCode = 64;

    return;
  }

  try {
    await OrganizationAppSetup.generate(
      repository: Directory.current.absolute,
      registration: File(options.registration),
      output: Directory(options.output),
      platformRef: options.platformRef,
    );
    stdout.writeln('Organization app created at ${options.output}.');
  } on Object catch (error) {
    stderr.writeln('App setup failed: $error');
    exitCode = 1;
  }
}

_SetupOptions? _options(List<String> arguments) {
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
    'registration',
    'output',
    'platform-ref',
  }).isNotEmpty) {
    return null;
  }

  final registration = values['registration'];
  final output = values['output'];
  final platformRef = values['platform-ref'];

  if (registration == null || output == null || platformRef == null) {
    return null;
  }

  if (!File(registration).isAbsolute || !Directory(output).isAbsolute) {
    return null;
  }

  return _SetupOptions(
    registration: registration,
    output: output,
    platformRef: platformRef,
  );
}

final class _SetupOptions {
  const _SetupOptions({
    required this.registration,
    required this.output,
    required this.platformRef,
  });

  final String registration;
  final String output;
  final String platformRef;
}
