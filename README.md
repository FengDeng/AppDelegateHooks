# AppDelegateHooks
让每个组件都拥有AppDelegate的生命周期  感觉自己就在AppDelegate里面



##Pod

pod 'AppDelegateHooks', :git => "git@github.com:FengDeng/AppDelegateHooks.git",:branch=>"master"

##How to use

在子组件里面 添加如下

    class Module1 : ApplicationHook{
      //添加你想要的生命周期
    }

没了。。
