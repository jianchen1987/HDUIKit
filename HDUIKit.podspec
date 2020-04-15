Pod::Spec.new do |s|
  s.name             = "HDUIKit"
  s.version          = "1.1.8"
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

  s.platform         = :ios, '9.0'
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

  $lib = ENV['use_lib']
  $lib_name = ENV["#{s.name}_use_lib"]
  if $lib || $lib_name
    puts '--------- HDUIKit binary -------'

    s.frameworks       = 'Foundation', 'UIKit', 'CoreGraphics', 'QuartzCore', 'CoreLocation'
    s.ios.vendored_framework = "#{s.name}-#{s.version}/ios/#{s.name}.framework"
    s.resources = "#{s.name}-#{s.version}/ios/#{s.name}.framework/Versions/A/Resources/*.bundle"
    s.dependency 'FFToast', '~> 1.2.0'
    s.dependency 'Masonry'
  else
    puts '....... HDUIKit source ........'

    s.frameworks       = 'Foundation', 'UIKit', 'CoreGraphics', 'QuartzCore'
    s.source_files     = 'HDUIKit/HDUIKit.h'

    s.subspec 'Core' do |ss|
      ss.source_files = 'HDUIKit/Extensions', 'HDUIKit/Extensions/**/*'
    end

    s.subspec 'MainFrame' do |ss|
      ss.source_files = 'HDUIKit/MainFrame'
      ss.dependency 'HDUIKit/HDNavigationBar'
      ss.dependency 'HDUIKit/HDAppTheme'
      ss.dependency 'HDUIKit/Core'
      ss.dependency 'HDKitCore/Extensions/UIImage'
      ss.dependency 'HDUIKit/Components/HDTips'
      ss.resource_bundles = {'HDUIKitMainFrameResources' => ['HDUIKit/MainFrame/Resources/*.*']}
    end

    s.subspec 'HDNavigationBar' do |ss|
      ss.source_files = 'HDUIKit/MainFrame/HDNavigationBar', 'HDUIKit/MainFrame/HDNavigationBar/*/*'
    end

    s.subspec 'HDAppTheme' do |ss|
      ss.source_files = 'HDUIKit/Theme'
      ss.dependency 'HDKitCore/Extensions/UIColor'
    end

    s.subspec 'HDCodeGenerator' do |ss|
      ss.source_files = 'HDUIKit/Vender/HDCodeGenerator', 'HDUIKit/Vender/HDCodeGenerator/*/*'
    end

    s.subspec 'Components' do |ss|
      ss.dependency 'HDUIKit/Core'
      ss.dependency 'HDKitCore/Core'
      ss.dependency 'HDUIKit/HDAppTheme'
      ss.dependency 'HDKitCore/DispatchMainQueueSafe'

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
        sss.dependency 'HDKitCore/HDFrameLayout'
        sss.resource_bundles = {'HDUIKitKeyboardResources' => ['HDUIKit/Components/HDKeyBoard/Resources/*.*']}
      end

      ss.subspec 'HDRatingStarView' do |sss|
        sss.source_files = 'HDUIKit/Components/HDRatingStarView'
      end

      ss.subspec 'HDTextView' do |sss|
        sss.source_files = 'HDUIKit/Components/HDTextView'
        sss.dependency 'HDKitCore/MultipleDelegates'
      end

      ss.subspec 'HDTips' do |sss|
        sss.source_files = 'HDUIKit/Components/HDTips'
        sss.dependency 'HDUIKit/Components/ToastView'
        sss.dependency 'HDUIKit/Components/ProgressView'
        sss.resource_bundles = {'HDUIKitTipsResources' => ['HDUIKit/Components/HDTips/Resources/*.*']}
      end
      ss.subspec 'ProgressView' do |sss|
        sss.source_files = 'HDUIKit/Components/ProgressView'
      end

      ss.subspec 'ToastView' do |sss|
        sss.source_files = 'HDUIKit/Components/ToastView', 'HDUIKit/Components/HDVisualEffectView'
      end

      ss.subspec 'HDActionAlertView' do |sss|
        sss.source_files = 'HDUIKit/Components/HDActionAlertView'
        sss.dependency 'HDKitCore/DispatchMainQueueSafe'
      end

      ss.subspec 'HDAlertView' do |sss|
        sss.source_files = 'HDUIKit/Components/HDAlertView'
        sss.dependency 'HDUIKit/Components/HDActionAlertView'
        sss.dependency 'HDKitCore/HDFrameLayout'
      end

      ss.subspec 'NAT' do |sss|
        sss.source_files = 'HDUIKit/Components/NAT'
        sss.dependency 'FFToast', '~> 1.2.0'
        sss.dependency 'HDUIKit/Components/HDAlertView'
      end

      ss.subspec 'HDCountDownButton' do |sss|
        sss.source_files = 'HDUIKit/Components/HDCountDownButton'
        sss.dependency 'HDKitCore/HDWeakTimer'
        sss.dependency 'HDUIKit/Components/HDUIButton'
      end

      ss.subspec 'HDUISlider' do |sss|
        sss.source_files = 'HDUIKit/Components/HDUISlider'
      end

      ss.subspec 'HDUITextField' do |sss|
        sss.source_files = 'HDUIKit/Components/HDUITextField'
        sss.dependency 'HDKitCore/KVOController'
        sss.dependency 'Masonry'
      end

      ss.subspec 'HDCitySelect' do |sss|
        sss.source_files = 'HDUIKit/Components/HDCitySelect', 'HDUIKit/Components/HDCitySelect/*/*'
        sss.resource_bundles = {'HDUIKITCitySelectResources' => ['HDUIKit/Components/HDCitySelect/Resources/*.*']}
        sss.dependency 'YYModel'
        sss.dependency 'HDKitCore/KVOController'
        sss.dependency 'HDUIKit/Components/HDFloatLayoutView'
        sss.dependency 'HDUIKit/Components/HDUIButton'
        sss.dependency 'HDUIKit/Components/HDTableHeaderFootView'
        sss.dependency 'HDKitCore/HDFrameLayout'
        sss.dependency 'HDUIKit/MainFrame'
        sss.dependency 'Masonry'
        sss.frameworks = 'CoreLocation'
      end

      ss.subspec 'HDScrollTitleBar' do |sss|
        sss.source_files = 'HDUIKit/Components/HDScrollTitleBar'
        sss.dependency 'HDKitCore/HDFrameLayout'
      end

      ss.subspec 'HDSearchBar' do |sss|
        sss.source_files = 'HDUIKit/Components/HDSearchBar'
        sss.dependency 'Masonry'
        sss.dependency 'HDKitCore/KVOController'
        sss.resource_bundles = {'HDUIKitSearchBarResources' => ['HDUIKit/Components/HDSearchBar/Resources/*.*']}
      end

      ss.subspec 'HDTableHeaderFootView' do |sss|
        sss.source_files = 'HDUIKit/Components/HDTableHeaderFootView'
        sss.dependency 'Masonry'
      end

      ss.subspec 'HDSkeletonLayer' do |sss|
        sss.source_files = 'HDUIKit/Components/HDSkeletonLayer'
      end

      ss.subspec 'UIViewPlaceholder' do |sss|
        sss.source_files = 'HDUIKit/Components/UIViewPlaceholder'
        sss.dependency 'Masonry'
        sss.dependency 'HDUIKit/Components/HDUIButton'
      end

      ss.subspec 'HDUnitTextField' do |sss|
        sss.source_files = 'HDUIKit/Components/HDUnitTextField'
      end

      ss.subspec 'UIViewKeyboardMoveRespond' do |sss|
        sss.source_files = 'HDUIKit/Components/UIViewKeyboardMoveRespond'
      end

      ss.subspec 'HDActionSheetView' do |sss|
        sss.source_files = 'HDUIKit/Components/HDActionSheetView'
        sss.dependency 'HDUIKit/Components/HDActionAlertView'
      end

      ss.subspec 'HDSocialShareView' do |sss|
        sss.source_files = 'HDUIKit/Components/HDSocialShareView'
        sss.dependency 'HDUIKit/Components/HDActionAlertView'
        sss.dependency 'Masonry'
      end

      ss.subspec 'HDCustomViewActionView' do |sss|
        sss.source_files = 'HDUIKit/Components/HDCustomViewActionView'
        sss.dependency 'HDUIKit/Components/HDActionAlertView'
        sss.dependency 'HDKitCore/HDFrameLayout'
      end

      ss.subspec 'HDShareImageAlertView' do |sss|
        sss.source_files = 'HDUIKit/Components/HDShareImageAlertView'
        sss.dependency 'HDUIKit/Components/HDActionAlertView'
      end

      ss.subspec 'HDImageUploadAddImageView' do |sss|
        sss.source_files = 'HDUIKit/Components/HDImageUploadAddImageView'
        sss.dependency 'Masonry'
      end

      ss.subspec 'HDImageBrowserToolViewHandler' do |sss|
        sss.source_files = 'HDUIKit/Components/HDImageBrowserToolViewHandler'
        sss.dependency 'HDKitCore/HDFrameLayout'
        sss.dependency 'YBImageBrowser', '~> 3.0.8'
        sss.dependency 'HDUIKit/Components/HDUIButton'
        sss.resource_bundles = {'HDUIKitImageBrowserResources' => ['HDUIKit/Components/HDImageBrowserToolViewHandler/Resources/*.*']}
      end

      ss.subspec 'HDImageCropper' do |sss|
        sss.source_files = 'HDUIKit/Components/HDImageCropper'
        sss.dependency 'Masonry'
      end

    end

  end

end
