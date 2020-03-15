# AppDelegateHooks  

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/AppDelegateHooks.svg)](https://img.shields.io/cocoapods/v/AppDelegateHooks.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/AppDelegateHooks.svg?style=flat)](https://alamofire.github.io/Alamofire)

AppDelegateHooks: easy hook AppDelegate methods library.


## Features

- [x] Native UIApplicationDelegate code prompt
- [x] Just new class inhert AppDelegateHook
- [x] Rewrite level property,Custom calling sequence
- [x] Create class everywhere

## Installation

### Cocoapods

```ruby
pod 'AppDelegateHooks', '~> 0.0.1'
```
    
### Carthage

```ogdl
github "FengDeng/AppDelegateHooks" ~> 0.0.1
```
    
### ~~SPM~~

```swift
dependencies: [
    .package(url: "https://github.com/FengDeng/AppDelegateHooks", from: "0.0.1")
]
```


## Usage

sample in main project:

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("Main didFinishLaunchingWithOptions")
        return true
    }

}
```


in your workspace or framework:

```swift
class ExampleHook1 : AppDelegateHook{
  //添加你想要的生命周期
  self.level = 1000//如果你这个组件想要最先加载 level越大越先

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
    print("ExampleHook1 didFinishLaunchingWithOptions")
    return false
  }
  func applicationWillResignActive(_ application: UIApplication) {
    print("ExampleHook1 applicationWillResignActive")
  }

  ......
}
```
    
```swift
class ExampleHook2 : AppDelegateHook{
  //添加你想要的生命周期
  self.level = 10000//如果你这个组件想要最先加载 level越大越先

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
    print("ExampleHook2 didFinishLaunchingWithOptions")
    return false
  }
  func applicationWillResignActive(_ application: UIApplication) {
    print("ExampleHook2 applicationWillResignActive")
  }

  ......
}
```
    
    
print:

    
    ExampleHook2 didFinishLaunchingWithOptions
    ExampleHook1 didFinishLaunchingWithOptions
    Main didFinishLaunchingWithOptions
    ExampleHook2 applicationWillResignActive
    ExampleHook1 applicationWillResignActive


## Thanks

Thanks for [Aspects](https://github.com/steipete/Aspects) which developed by [@steipete](http://twitter.com/steipete) in GitHub


# 中文

AppDelegateHooks： 一个可以轻松拦截AppDelegate所有回调的轻量级的库。

## 特性

- [x] 原生的UIApplicationDelegate代码提示
- [x] 新建Class，继承AppDelegateHook即可，无需其他操作
- [x] 提供重写level，自定义调用优先级
- [x] 组件内，模块内，无限制hook主工程生命周期

## 安装

 ### Cocoapods

```ruby
pod 'AppDelegateHooks', '~> 0.0.1'
```
    
### Carthage

```ogdl
github "FengDeng/AppDelegateHooks" ~> 0.0.1
```
    
### ~~SPM~~

```swift
dependencies: [
    .package(url: "https://github.com/FengDeng/AppDelegateHooks", from: "0.0.1")
]
```
    
## 使用

在子组件或者模块内新建文件

```swift
class ExampleHook1 : AppDelegateHook{
  //添加你想要的生命周期
  self.level = 1000//如果你这个组件想要最先加载 level越大越先

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
    print("ExampleHook1 didFinishLaunchingWithOptions")
    return false
  }
  func applicationWillResignActive(_ application: UIApplication) {
    print("ExampleHook1 applicationWillResignActive")
  }

  ......
}
```
    
```swift
class ExampleHook2 : AppDelegateHook{
  //添加你想要的生命周期
  self.level = 10000//如果你这个组件想要最先加载 level越大越先

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
    print("ExampleHook2 didFinishLaunchingWithOptions")
    return false
  }
  func applicationWillResignActive(_ application: UIApplication) {
    print("ExampleHook2 applicationWillResignActive")
  }

  ......
}
```
    
打印如下：

    ExampleHook2 didFinishLaunchingWithOptions
    ExampleHook1 didFinishLaunchingWithOptions
    Main didFinishLaunchingWithOptions
    ExampleHook2 applicationWillResignActive
    ExampleHook1 applicationWillResignActive
    


