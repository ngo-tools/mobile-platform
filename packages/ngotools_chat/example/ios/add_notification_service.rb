# Adds the NotificationService extension target to Runner.xcodeproj (idempotent).
# Usage: ruby add_notification_service.rb
require 'xcodeproj'

project_path = File.join(__dir__, 'Runner.xcodeproj')
project = Xcodeproj::Project.open(project_path)
runner = project.targets.find { |target| target.name == 'Runner' }

if project.targets.any? { |target| target.name == 'NotificationService' }
  puts 'NotificationService already present'
  exit 0
end

nse = project.new_target(:app_extension, 'NotificationService', :ios, '15.0')
group = project.main_group.new_group('NotificationService', 'NotificationService')
source = group.new_file('NotificationService.swift')
group.new_file('Info.plist')
group.new_file('NotificationService.entitlements')
nse.add_file_references([source])

nse.build_configurations.each do |config|
  settings = config.build_settings
  settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'tools.ngo.mobile.chatExample.NotificationService'
  settings['INFOPLIST_FILE'] = 'NotificationService/Info.plist'
  settings['CODE_SIGN_ENTITLEMENTS'] = 'NotificationService/NotificationService.entitlements'
  settings['SWIFT_VERSION'] = '5.0'
  settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
  settings['TARGETED_DEVICE_FAMILY'] = '1,2'
  settings['SKIP_INSTALL'] = 'YES'
  settings['PRODUCT_NAME'] = '$(TARGET_NAME)'
  settings['GENERATE_INFOPLIST_FILE'] = 'NO'
  settings['CODE_SIGN_STYLE'] = 'Automatic'
  settings['LD_RUNPATH_SEARCH_PATHS'] = ['$(inherited)', '@executable_path/Frameworks', '@executable_path/../../Frameworks']
  # Flutter's Generated.xcconfig provides FLUTTER_BUILD_NAME/NUMBER.
  config.base_configuration_reference = nil
end

runner.build_configurations.each do |config|
  config.build_settings['CODE_SIGN_ENTITLEMENTS'] = 'Runner/Runner.entitlements'
end
project.main_group.find_subpath('Runner', false)&.new_file('Runner.entitlements')

embed = runner.new_copy_files_build_phase('Embed Foundation Extensions')
embed.dst_subfolder_spec = '13'
build_file = embed.add_file_reference(nse.product_reference, true)
build_file.settings = { 'ATTRIBUTES' => ['RemoveHeadersOnCopy'] }
runner.add_dependency(nse)

# The extension must be built before Runner's "Thin Binary"/embed phases.
phases = runner.build_phases
phases.delete(embed)
index = phases.index { |phase| phase.respond_to?(:name) && phase.name == 'Thin Binary' } || phases.length
phases.insert(index, embed)

project.save
puts 'NotificationService added'
