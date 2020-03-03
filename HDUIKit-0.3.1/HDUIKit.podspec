Pod::Spec.new do |s|
  s.name = "HDUIKit"
  s.version = "0.3.1"
  s.summary = "\u6DF7\u6C8C iOS \u9879\u76EE\u7EC4\u4EF6\u5E93"
  s.license = "MIT"
  s.authors = {"VanJay"=>"wangwanjie1993@gmail.com"}
  s.homepage = "https://git.vipaylife.com/vipay/HDUIKit"
  s.description = "HDUIKit \u662F\u4E00\u7CFB\u5217 iOS \u7EC4\u4EF6\u7684\u7EC4\u6210\uFF0C\u7528\u4E8E\u5FEB\u901F\u5728\u5176\u4ED6\u9879\u76EE\u4F7F\u7528\u6216\u8005\u7B2C\u4E09\u65B9\u63A5\u5165"
  s.social_media_url = "https://git.vipaylife.com/vipay/HDUIKit"
  s.documentation_url = "https://git.vipaylife.com/vipay/HDUIKit"
  s.screenshots = "https://xxx.png"
  s.frameworks = ["AVFoundation", "Foundation", "UIKit", "CoreGraphics"]
  s.requires_arc = true
  s.source = { :path => '.' }

  s.ios.deployment_target    = '9.0'
  s.ios.vendored_framework   = 'ios/HDUIKit.framework'
end
