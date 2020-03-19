Pod::Spec.new do |s|
  s.name             = "HDUIKit"
  s.version          = "0.5.4"
  s.summary          = "混沌 iOS 项目组件库"
  s.description      = <<-DESC
                       HDUIKit 是一系列 iOS 组件的组成，用于快速在其他项目使用或者第三方接入
                       DESC
  s.homepage         = "https://code.kh-super.net/projects/MOB/repos/hduikit/"
  s.license          = 'MIT'
  s.author           = {"VanJay" => "wangwanjie1993@gmail.com"}
  s.source           = {:git => "ssh://git@code.kh-super.net:7999/mob/hduikit.git", :tag => s.version.to_s}
  s.social_media_url = 'https://code.kh-super.net/projects/MOB/repos/hduikit/'
  s.requires_arc     = true
  s.documentation_url = 'https://code.kh-super.net/projects/MOB/repos/hduikit/'
  s.screenshot       = 'https://xxx.png'

  s.platform         = :ios, '9.0'
  s.frameworks       = 'Foundation', 'UIKit', 'CoreGraphics', 'QuartzCore'
  s.source_files     = 'HDUIKit/HDUIKit.h'
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

  s.subspec 'Core' do |ss|
    ss.source_files = 'HDUIKit/HDUIKit.h', 'HDUIKit/Core','HDUIKit/UIKitExtensions', 'HDUIKit/UIKitExtensions/*/*'
    ss.dependency 'HDUIKit/HDWeakObjectContainer'
    ss.dependency 'HDUIKit/HDLog'
    ss.dependency 'HDUIKit/HDRuntime'
    ss.frameworks = 'AVFoundation'
  end

  s.subspec 'MainFrame' do |ss|
    ss.source_files = 'HDUIKit/MainFrame'
    ss.dependency 'HDUIKit/HDNavigationBar'
    ss.dependency 'HDUIKit/HDAppTheme'
    ss.dependency 'HDUIKit/UIKitExtensions/UIImage'
    ss.dependency 'HDUIKit/Components/HDTips'
    ss.resource_bundles = {'HDUIKitMainFrameResources' => ['HDUIKit/MainFrame/Resources/*.*']}
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

    ss.subspec 'HDUIButton' do |sss|
      sss.source_files = 'HDUIKit/Components/HDUIButton'
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
      sss.dependency 'HDUIKit/Components/HDUIButton'
      sss.dependency 'HDUIKit/WJFrameLayout'
      sss.resource_bundles = {'HDUIKitKeyboardResources' => ['HDUIKit/Components/HDKeyBoard/Resources/*.*']}
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
      sss.resource_bundles = {'HDUIKitTipsResources' => ['HDUIKit/Components/HDTips/Resources/*.*']}
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

    ss.subspec 'HDCountDownButton' do |sss|
      sss.source_files = 'HDUIKit/Components/HDCountDownButton'
      sss.dependency 'HDVendorKit/HDWeakTimer'
      sss.dependency 'HDUIKit/Components/HDUIButton'
    end

    ss.subspec 'HDUISlider' do |sss|
      sss.source_files = 'HDUIKit/Components/HDUISlider'
    end

    ss.subspec 'HDUITextField' do |sss|
      sss.source_files = 'HDUIKit/Components/HDUITextField'
      sss.dependency 'HDVendorKit/KVOController'
      sss.dependency 'Masonry'
    end

  end

end
