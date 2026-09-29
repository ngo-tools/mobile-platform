# Flutter side of the plugin. The Rust code lives in `ngotools_matrix_core`
# (shared with the Notification Service Extension).
Pod::Spec.new do |s|
  s.name             = 'ngotools_chat'
  s.version          = '0.0.1'
  s.summary          = 'NGO.Tools Matrix chat plugin.'
  s.homepage         = 'https://ngo.tools'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'NGO.Tools' => 'dev@ngo.tools' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'ngotools_matrix_core'
  s.platform = :ios, '15.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
