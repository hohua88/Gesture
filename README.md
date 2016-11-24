# Gesture
实现手势密码布局以及手势密码弹出时机和QQ一致
手势密码之前一直是一个应用的标配，渐渐的支付宝和微信已不再使用手势密码。可是鉴于我司还保留使用手势密码，所以还是要研究一下QQ的手势密码的机制。本文主旨是手势密码的出现机制，实现请自行参考别处代码。

我司手势密码之前是有上个同事负责的，他的实现方式是写一个基础ViewController，在viewDidAppear监听手势密码监听事件，实现代码如下：

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verifyGesturePwd) name:@"VerifyGesturePwd" object:nil];
这样的实现方式并不能满足上面的需求（我们暂不讨论代码的方式）；每次后台进入程序手势密码界面弹出时机都是当前界面出现后再弹出，不是直接进入手势密码界面。

接下来问题来了，我们如何实现上述需求呢（参照QQ密码弹出机制）？

经过对QQ手势密码的机制进行研究，每次手势密码都是直接弹出的。我就在AppDelegate中的applicationDidEnterBackground方法中弹出手势密码界面，这样每次从后台进入程序首先展示的就是手势密码界面，符合要求。

可是我们杀死程序后进入呢？显然手势密码并不会直接弹出；接下来我陷入思维误区，想直接present手势密码界面出来，试了之后发现不能满足需求。然后在applicationDidBecomeActive方法中present手势密码界面，发现弹出时会有动画，不满足需求。人们还是很容易只盯着问题看，这样是不会找到解决问题的钥匙的。

最终还是找到实现方式，每次进入程序时，在didFinishLaunchingWithOptions方法中判断是否设置手势密码，如果有手势密码功能的话，直接把手势密码界面设置为rootViewController，并注册一个监听：

[[NSNotificationCenter defaultCenter] addObserver:self

selector:@selector(loginStateChange:)

name:KNOTIFICATION_LOGINCHANGE

object:nil];
这里我直接合并到登陆状态的监听里面。手势密码界面在验证后做如下判断：

if (self.navigationController) {

[[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];}else{

[self dismissViewControllerAnimated:YES completion:^{

}];}
即在验证后判断如果当前手势界面是设置的rootViewController时，发出通知。监听处需要重新设置rootViewController。

本以为这样就完成了，后面测试还是发现一个问题，即在杀死程序再次进入应用时，直接进入后台发现手势密码界面有2个。此处只需要添加如下代码逻辑来解决重复弹出的问题。

UIViewController *rootViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        return;
    }
即在进入后台时先判断当前的页面是不是手势密码界面，再决定是否弹出手势密码界面。

最后，这个需求被解决了。

今天抽时间把手势密码抽离出来，https://github.com/hohua88/Gesture，欢迎交流。
