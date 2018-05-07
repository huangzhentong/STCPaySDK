#
# Be sure to run `pod lib lint STCPaySDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'STCPaySDK'
  s.version          = '1.0.9'
  s.summary          = 'A short description of STCPaySDK.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/zhentong.huang/STCPaySDK'

  s.license          = { :type => 'MIT' }
  s.author           = { 'zhentong.huang' => '181310067@qq.com' }
 
  s.source           = { :git => 'https://github.com/huangzhentong/STCPaySDK.git', :tag => s.version }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
	s.resources =  'STCPaySDK/Assets/*.{bundle,png}'
#s.resource_bundles = {
  #'STCPaySDK' => ['STCPaySDK/Assets/*.{bundle,png}']
# }
    
    s.subspec 'Core' do |core|
        core.ios.vendored_frameworks = 'STCPaySDK/Classes/STCPayCode.framework'
        #core.source_files = 'STCPaySDK/Classes/SDK/**/*.{h,m}'
        # core.source_files = 'STCPaySDK/Classes/STCPayCode.framework'
        #core.public_header_files = 'STCPaySDK/Classes/STCPaySDK.framework/Headers/STCPayManager.h'
        core.frameworks            =  'CoreGraphics', 'UIKit', 'Foundation','WebKit'
    end
    
    
    s.subspec 'WXPay' do|ss|
        #ss.vendored_libraries = 'STCPaySDK/Classes/ThirdSDK/WechatSDK1.8.2/libWeChatSDK.a'
        #ss.libraries             = 'z', 'c++', 'sqlite3'
        #ss.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-all_load' }
        ss.source_files = 'STCPaySDK/Classes/WeixinApiManager/*.{h,m}'
        #ss.preserve_paths = "STCPaySDK/Classes/ThirdSDK/WechatSDK1.8.2/libWeChatSDK.a"
        ss.dependency 'WechatOpenSDK'
    end
    s.subspec 'ALIPay' do|ss|
        #ss.vendored_libraries = 'STCPaySDK/Classes/ThirdSDK/WechatSDK1.8.2/libWeChatSDK.a'
        #ss.libraries             = 'z', 'c++', 'sqlite3'
        #ss.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-all_load' }
        #ss.source_files = 'STCPaySDK/Classes/WeixinApiManager/*.{h,m}'
        #ss.preserve_paths = "STCPaySDK/Classes/ThirdSDK/WechatSDK1.8.2/libWeChatSDK.a"
        ss.dependency 'AlipaySDK_No_UTDID'
    end

    

end
