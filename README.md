# AppDelegateHooks

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/AppDelegateHooks.svg)](https://img.shields.io/cocoapods/v/AppDelegateHooks.svg)
[![Platform](https://img.shields.io/cocoapods/p/AppDelegateHooks.svg?style=flat)](https://alamofire.github.io/Alamofire)

AppDelegateHooks： 一个可以轻松拦截AppDelegate所有回调的轻量级的库。

AppDelegateHooks: easy hook AppDelegate methods library.

## 特性

- [x] 原生的UIApplicationDelegate代码提示
- [x] 新建Class，继承AppDelegateHook即可，无需其他操作
- [x] 提供重写level，自定义调用优先级
- [x] 组件内，模块内，无限制hook主工程生命周期


- [x] Native UIApplicationDelegate code prompt
- [x] Just new class inhert AppDelegateHook
- [x] Rewrite level property,Custom calling sequence
- [x] Create class everywhere

## CocoaPods

    pod 'AppDelegateHooks'

## 使用   How To Use

主工程：
main project:

    class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("Main didFinishLaunchingWithOptions")
        return true
    }

}

在子组件里面 添加如下
sub framework or kit:

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
    
输出：
print:
    
    ExampleHook2 didFinishLaunchingWithOptions
    ExampleHook1 didFinishLaunchingWithOptions
    Main didFinishLaunchingWithOptions
    ExampleHook2 applicationWillResignActive
    ExampleHook1 applicationWillResignActive







