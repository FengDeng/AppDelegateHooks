# AppDelegateHooks


让每个组件都拥有AppDelegate的生命周期  感觉自己就在AppDelegate里面

- 单个Class搞定一切
- 对主工程毫无侵入性
- 原生的AppDelegate代码体验 提示


## CocoaPods

    pod 'AppDelegateHooks', :git => "git@github.com:FengDeng/AppDelegateHooks.git",:branch=>"master"

## How to use

在子组件里面 添加如下

    class XXXClass : ApplicationHook{
      //添加你想要的生命周期

      self.level = 1000//如果你这个组件想要最先加载 level越大越先

      func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        print("ExampleHook2 didFinishLaunchingWithOptions")
        return false
      }
      func applicationWillResignActive(_ application: UIApplication) {
        print("ExampleHook2 applicationWillResignActive")
      }

      。。。。等等等
    }

## Notice

    如果application的代理类名 不含有Delegate字符串  
    或者
    有多个含有Delegate字符串并且实现了UIApplicationDelegate协议的类 
    会有问题




