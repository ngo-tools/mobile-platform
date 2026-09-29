# Rust facade (matrix-rust-sdk) as a standalone framework without a Flutter
# dependency, so that the app and its Notification Service Extension link the
# same binary.
Pod::Spec.new do |s|
  s.name             = 'ngotools_matrix_core'
  s.version          = '0.0.1'
  s.summary          = 'NGO.Tools Matrix facade on matrix-rust-sdk (spike).'
  s.homepage         = 'https://ngo.tools'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'NGO.Tools' => 'dev@ngo.tools' }
  s.source           = { :path => '.' }
  s.source_files     = 'Core/**/*.{h,c}'
  s.public_header_files = 'Core/**/*.h'
  s.platform         = :ios, '15.0'

  s.script_phase = {
    :name => 'Build Rust library',
    :script => 'sh "$PODS_TARGET_SRCROOT/../cargokit/build_pod.sh" ../rust ngotools_matrix_core',
    :execution_position => :before_compile,
    :input_files => ['${BUILT_PRODUCTS_DIR}/cargokit_phony'],
    :output_files => ["${BUILT_PRODUCTS_DIR}/libngotools_matrix_core.a"],
  }
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'APPLICATION_EXTENSION_API_ONLY' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 x86_64',
    'OTHER_LDFLAGS' => '-force_load ${BUILT_PRODUCTS_DIR}/libngotools_matrix_core.a',
  }
end
