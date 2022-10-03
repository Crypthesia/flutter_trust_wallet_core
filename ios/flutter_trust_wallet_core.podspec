#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_trust_wallet_core.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_trust_wallet_core'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin for trust wallet core'
  s.description      = <<-DESC
A Flutter plugin for trust wallet core
                       DESC
  s.homepage         = 'https://github.com/Crypthesia/flutter_trust_wallet_core'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Crypthesia' => 'tom@diagon1.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # trust wallet core
  s.vendored_frameworks = 'Frameworks/*.xcframework'
end
