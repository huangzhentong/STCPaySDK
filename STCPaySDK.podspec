#
# Be sure to run `pod lib lint STCPaySDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'STCPaySDK'
  s.version          = '1.0.0'
  s.summary          = 'A short description of STCPaySDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/zhentong.huang/STCPaySDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT' }
  s.author           = { 'zhentong.huang' => '181310067@qq.com' }
  s.source           = { :git => '/Users/kt-stc08/Desktop/STCPaySDK/STCPaySDK', :tag => s.version }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'STCPaySDK/Classes/**/*'
  s.resources = "STCPaySDK/Assets/Res.bundle"
#s.resource_bundles = {
#  'STCPaySDK' => ['STCPaySDK/Assets/Res.budnle']
# }
 
   s.public_header_files = 'STCPaySDK/Classes/**/*.h','STCPaySDK/Classes/**/**/*.h'
    s.frameworks            = 'SystemConfiguration', 'CoreTelephony', 'QuartzCore', 'CoreText', 'CoreGraphics', 'UIKit', 'Foundation','CFNetwork', 'CoreMotion'
    s.libraries             = 'z', 'c++', 'sqlite3'
    s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-all_load' }
  # s.dependency 'AFNetworking', '~> 2.3'
    # "dependencies": {
    # "WechatOpenSDK": [ ]
    #  }
    s.dependency  'WechatOpenSDK'
    s.dependency 'AlipaySDK_MI'
end
