Pod::Spec.new do |s|
  s.name             = "HDUIKit"
  s.version          = "0.4.0"
  s.summary          = "混沌 iOS 项目组件库"
  s.description      = <<-DESC
                       HDUIKit 是一系列 iOS 组件的组成，用于快速在其他项目使用或者第三方接入
                       DESC
  s.homepage         = "https://git.vipaylife.com/vipay/HDUIKit"
  s.license          = 'MIT'
  s.author           = {"VanJay" => "wangwanjie1993@gmail.com"}
  s.source           = {:git => "git@git.vipaylife.com:vipay/HDUIKit.git", :tag => s.version.to_s}
  s.social_media_url = 'https://git.vipaylife.com/vipay/HDUIKit'
  s.requires_arc     = true
  s.documentation_url = 'https://git.vipaylife.com/vipay/HDUIKit'
  s.screenshot       = 'https://xxx.png'

  s.platform         = :ios, '9.0'
  s.frameworks       = 'AVFoundation', 'Foundation', 'UIKit', 'CoreGraphics'
  s.source_files     = 'HDUIKit/HDUIKit.h'
  s.resource_bundles = {'HDResources' => ['HDUIKit/HDResources/*.*']}

  s.subspec 'Core' do |ss|
    ss.source_files = 'HDUIKit/HDUIKit.h', 'HDUIKit/Core','HDUIKit/UIKitExtensions', 'HDUIKit/UIKitExtensions/*/*'
    ss.dependency 'HDUIKit/HDWeakObjectContainer'
    ss.dependency 'HDUIKit/HDLog'
    ss.dependency 'HDUIKit/HDRuntime'
  end

  s.subspec 'MainFrame' do |ss|
    ss.source_files = 'HDUIKit/MainFrame'
    ss.dependency 'HDUIKit/HDNavigationBar'
    ss.dependency 'HDUIKit/HDAppTheme'
    ss.dependency 'HDUIKit/UIKitExtensions/UIImage'
  end

  s.subspec 'HDNavigationBar' do |ss|
    ss.source_files = 'HDUIKit/MainFrame/HDNavigationBar', 'HDUIKit/MainFrame/HDNavigationBar/*/*'
  end

  s.subspec 'HDRuntime' do |ss|
    ss.source_files = 'HDUIKit/Core/Runtime','HDUIKit/UIKitExtensions/{NSMethodSignature}+HDUIKit.{h,m}'
    ss.dependency 'HDUIKit/HDLog'
  end

  s.subspec 'MethodSwizzle' do |ss|
    ss.source_files = 'HDUIKit/UIKitExtensions/NSObject/NSObject+HD_Swizzle.{h,m}'
  end

  s.subspec 'DispatchMainQueueSafe' do |ss|
    ss.source_files = 'HDUIKit/DispatchMainQueueSafe'
  end

  s.subspec 'HDAppTheme' do |ss|
    ss.source_files = 'HDUIKit/Theme'
    ss.dependency 'HDUIKit/UIKitExtensions/UIColor'
  end

  s.subspec 'HDWeakObjectContainer' do |ss|
    ss.source_files = 'HDUIKit/Components/HDWeakObjectContainer/HDWeakObjectContainer.{h,m}'
  end

  s.subspec 'WJFrameLayout' do |ss|
    ss.source_files = 'HDUIKit/WJFrameLayout'
  end

  s.subspec 'WJFunctionThrottle' do |ss|
    ss.source_files = 'HDUIKit/WJFunctionThrottle'
  end

  s.subspec 'HDLog' do |ss|
    ss.source_files = 'HDUIKit/Components/HDLog'
  end

  s.subspec 'HDCodeGenerator' do |ss|
    ss.source_files = 'HDUIKit/Vender/HDCodeGenerator', 'HDUIKit/Vender/HDCodeGenerator/*/*'
  end

  s.subspec 'UIKitExtensions' do |ss|
    ss.source_files = 'HDUIKit/UIKitExtensions', 'HDUIKit/UIKitExtensions/*/*'
    ss.dependency 'HDUIKit/Core'

    ss.subspec 'UIView' do |sss|
      sss.source_files = 'HDUIKit/UIKitExtensions/UIView'
    end

    ss.subspec 'NSString' do |sss|
      sss.source_files = 'HDUIKit/UIKitExtensions/NSString'
    end

    ss.subspec 'UIColor' do |sss|
      sss.source_files = 'HDUIKit/UIKitExtensions/UIColor'
      sss.dependency 'HDUIKit/UIKitExtensions/NSString'
    end

    ss.subspec 'UIImage' do |sss|
      sss.source_files = 'HDUIKit/UIKitExtensions/UIImage'
      sss.dependency 'HDUIKit/UIKitExtensions/NSString'
    end

    ss.subspec 'UIButton' do |sss|
      sss.source_files = 'HDUIKit/UIKitExtensions/UIButton'
    end

  end

  s.subspec 'Components' do |ss|
    ss.dependency 'HDUIKit/Core'
    ss.dependency 'HDUIKit/HDAppTheme'

    ss.subspec 'HDButton' do |sss|
      sss.source_files = 'HDUIKit/Components/HDButton'
    end

    ss.subspec 'HDCyclePagerView' do |sss|
      sss.source_files = 'HDUIKit/Components/HDCyclePagerView'
    end

    ss.subspec 'HDFloatLayoutView' do |sss|
      sss.source_files = 'HDUIKit/Components/HDFloatLayoutView'
    end

    ss.subspec 'HDGridView' do |sss|
      sss.source_files = 'HDUIKit/Components/HDGridView'
    end

    ss.subspec 'HDKeyBoard' do |sss|
      sss.source_files = 'HDUIKit/Components/HDKeyBoard'
      sss.dependency 'HDUIKit/Components/HDButton'
      sss.dependency 'HDUIKit/WJFrameLayout'
    end

    ss.subspec 'HDRatingStarView' do |sss|
      sss.source_files = 'HDUIKit/Components/HDRatingStarView'
    end

    ss.subspec 'HDTextView' do |sss|
      sss.source_files = 'HDUIKit/Components/HDTextView'
      sss.dependency 'HDUIKit/Components/MultipleDelegates'
    end

    ss.subspec 'HDTips' do |sss|
      sss.source_files = 'HDUIKit/Components/HDTips'
      sss.dependency 'HDUIKit/Components/ToastView'
      sss.dependency 'HDUIKit/Components/ProgressView'
    end

    ss.subspec 'MultipleDelegates' do |sss|
      sss.source_files = 'HDUIKit/Components/MultipleDelegates'
    end

    ss.subspec 'ProgressView' do |sss|
      sss.source_files = 'HDUIKit/Components/ProgressView'
    end

    ss.subspec 'ToastView' do |sss|
      sss.source_files = 'HDUIKit/Components/ToastView', 'HDUIKit/Components/HDVisualEffectView'
    end

    ss.subspec 'HDActionAlertView' do |sss|
      sss.source_files = 'HDUIKit/Components/HDActionAlertView'
      sss.dependency 'HDUIKit/DispatchMainQueueSafe'
    end

    ss.subspec 'HDAlertView' do |sss|
      sss.source_files = 'HDUIKit/Components/HDAlertView'
      sss.dependency 'HDUIKit/Components/HDActionAlertView'
      sss.dependency 'HDUIKit/HDAppTheme'
      sss.dependency 'HDUIKit/WJFrameLayout'
    end

    ss.subspec 'NAT' do |sss|
      sss.source_files = 'HDUIKit/Components/NAT'
      sss.dependency 'FFToast', '~> 1.2.0'
      sss.dependency 'HDUIKit/Components/HDAlertView'
    end

  end

end
