# HDUIKit

[![CI Status](https://img.shields.io/travis/wangwanjie/HDUIKit.svg?style=flat)](https://travis-ci.org/wangwanjie/HDUIKit)
[![Version](https://img.shields.io/cocoapods/v/HDUIKit.svg?style=flat)](https://cocoapods.org/pods/WJFrameLayout)
[![License](https://img.shields.io/cocoapods/l/HDUIKit.svg?style=flat)](https://cocoapods.org/pods/WJFrameLayout)
[![Platform](https://img.shields.io/cocoapods/p/HDUIKit.svg?style=flat)](https://cocoapods.org/pods/WJFrameLayout)

## 说明
HDUIKit 是一系列 iOS 组件的组成，用于快速在其他项目使用或者第三方接入

## 例子

Example 目录下执行

```
pod install
```

## 要求

iOS 9.0

## 使用

使用 CocoaPods
在你的项目的 Podfile 里添加如下内容：

顶部添加

```
source 'git@git.vipaylife.com:vipay/Chaos-specs.git'
```

使用全部模块

```ruby
pod 'HDUIKit'
```
如果只需要引入某几个特定的子模块，则可参照以下写法，具体的子模块列表请直接查看项目源码里的 HDUIKit.podspec 文件：

```ruby
pod 'HDUIKit/HDLog'
pod 'HDUIKit/Components/HDGridView'
```

## Author

wangwanjie, wangwanjie1993@gmail.com

## License

项目版权归属混沌网络科技有限公司所有
