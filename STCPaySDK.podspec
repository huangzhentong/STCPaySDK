#
# Be sure to run `pod lib lint STCPaySDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'STCPaySDK'
  s.version          = '1.0.3'
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
  #s.source           = { :git => 'https://huangzhentong@dev365.keytop.cn/bitbucket/scm/stcpays/stcpaysdk.git', :tag => s.version }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

#s.source_files = 'STCPaySDK/Classes/**/*.{h,m,a,framework}','STCPaySDK/Classes/**/**/*.{a,framework}','STCPaySDK/Classes/*'
s.source_files = 'STCPaySDK/Classes/**/*','STCPaySDK/Classes/*'

s.resource_bundles = {
    'STCPaySDK' => ['STCPaySDK/Assets/*.{bundle,png}']
 }
 
 #s.public_header_files = 'STCPaySDK/Classes/**/*.h'
    s.frameworks            = 'SystemConfiguration', 'CoreTelephony', 'QuartzCore', 'CoreText', 'CoreGraphics', 'UIKit', 'Foundation','CFNetwork', 'CoreMotion','WebKit'
    s.libraries             = 'z', 'c++', 'sqlite3'
    s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-all_load' }
  
    s.public_header_files = 'STCPaySDK/Classes/STCPaySDK.framework/Headers/STCPayManager.h','STCPaySDK/Classes/**/*.h'
    s.ios.vendored_libraries = 'STCPaySDK/Classes/ThirdSDK/WechatSDK1.8.2/libWeChatSDK.a',
    s.ios.vendored_frameworks = 'STCPaySDK/Classes/STCPayCode.framework'
#s.ios.vendored_frameworks = 'STCPaySDK/Classes/ThirdSDK/AlipaySDK/AlipaySDK.framework','STCPaySDK/Classes/STCPayCode.framework'
    s.preserve_paths = "STCPaySDK/Classes/ThirdSDK/WechatSDK1.8.2/libWeChatSDK.a"

end
