#
# Be sure to run `pod lib lint CZAESCipher.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CZAESCipher'
  s.version          = '0.0.1'
  s.summary          = 'iOS AES 加密解密.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
iOS AES 加密解密，支持 16、14 和 32 位秘钥长度；支持 ECB 和 CBC 加密模式
                       DESC

  s.homepage         = 'https://github.com/JQZhangC/CZAESCipher'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'CZ' => 'cooper_jx@126.com' }
  s.source           = { :git => 'https://github.com/JQZhangC/CZAESCipher.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'CZAESCipher/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CZAESCipher' => ['CZAESCipher/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
