Pod::Spec.new do |s|
  s.name = "STCPaySDK"
  s.version = "1.0.1"
  s.summary = "A short description of STCPaySDK."
  s.license = {"type"=>"MIT"}
  s.authors = {"zhentong.huang"=>"181310067@qq.com"}
  s.homepage = "https://github.com/zhentong.huang/STCPaySDK"
  s.description = "TODO: Add long description of the pod here."
  s.frameworks = ["SystemConfiguration", "CoreTelephony", "QuartzCore", "CoreText", "CoreGraphics", "UIKit", "Foundation", "CFNetwork", "CoreMotion"]
  s.libraries = ["z", "c++", "sqlite3"]
  s.source = { :path => '.' }

  s.ios.deployment_target    = '9.0'
  s.ios.vendored_framework   = 'ios/STCPaySDK.framework'
end
