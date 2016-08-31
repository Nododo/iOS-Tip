// RunLoop学习
// RunLoop概念--CoreFoundation
/**
 RunLoop是一个对象 管理其需要处理的事件和消息
 CFRunLoop是基于pthread来管理的
 苹果不允许直接创建RunLoop,只提供了两个自动获取的函数:苹果不允许直接创建 RunLoop，它只提供了两个自动获取的函数：CFRunLoopGetMain() 和 CFRunLoopGetCurrent()
 线程和RunLoop是一一对应关系,其关系保存在一个全局的Dictionary里。线程刚创建时并没有 RunLoop，如果你不主动获取，那它一直都不会有。RunLoop 的创建是发生在第一次获取时，RunLoop 的销毁是发生在线程结束时。你只能在一个线程的内部获取其 RunLoop（主线程除外）。
 一个 RunLoop 包含若干个 Mode，每个 Mode 又包含若干个 Source/Timer/Observer(sto)。每次调用 RunLoop 的主函数时，只能指定其中一个 Mode，这个Mode被称作 CurrentMode。如果需要切换 Mode，只能退出 Loop，再重新指定一个 Mode 进入。这样做主要是为了分隔开不同组的 Source/Timer/Observer，让其互不影响。
 在 CoreFoundation 里面关于 RunLoop 有5个类:
 CFRunLoopRef
 CFRunLoopModeRef
 CFRunLoopSourceRef
 CFRunLoopTimerRef
 CFRunLoopObserverRef
 其中 CFRunLoopModeRef 类并没有对外暴露，只是通过 CFRunLoopRef 的接口进行了封装
 
 上面的 Source/Timer/Observer 被统称为 mode item，一个 item 可以被同时加入多个 mode。但一个 item 被重复加入同一个 mode 时是不会有效果的。如果一个 mode 中一个 item 都没有，则 RunLoop 会直接退出，不进入循环。
 应用场景举例：主线程的 RunLoop 里有两个预置的 Mode：kCFRunLoopDefaultMode 和 UITrackingRunLoopMode。这两个 Mode 都已经被标记为"Common"属性。DefaultMode 是 App 平时所处的状态，TrackingRunLoopMode 是追踪 ScrollView 滑动时的状态。当你创建一个 Timer 并加到 DefaultMode 时，Timer 会得到重复回调，但此时滑动一个TableView时，RunLoop 会将 mode 切换为 TrackingRunLoopMode，这时 Timer 就不会被回调，并且也不会影响到滑动操作。
 有时你需要一个 Timer，在两个 Mode 中都能得到回调，一种办法就是将这个 Timer 分别加入这两个 Mode。还有一种方式，就是将 Timer 加入到顶层的 RunLoop 的 "commonModeItems" 中。"commonModeItems" 被 RunLoop 自动更新到所有具有"Common"属性的 Mode 里去。
 struct __CFRunLoopMode {
 CFStringRef _name;            // Mode Name, 例如 @"kCFRunLoopDefaultMode"
 CFMutableSetRef _sources0;    // Set
 CFMutableSetRef _sources1;    // Set
 CFMutableArrayRef _observers; // Array
 CFMutableArrayRef _timers;    // Array
 ...
 };
 
 struct __CFRunLoop {
 CFMutableSetRef _commonModes;     // Set
 CFMutableSetRef _commonModeItems; // Set<Source/Observer/Timer>
 CFRunLoopModeRef _currentMode;    // Current Runloop Mode
 CFMutableSetRef _modes;           // Set
 ...
 };
 你只能通过 mode name 来操作内部的 mode，当你传入一个新的 mode name 但 RunLoop 内部没有对应 mode 时，RunLoop会自动帮你创建对应的 CFRunLoopModeRef。对于一个 RunLoop 来说，其内部的 mode 只能增加不能删除。
 
 苹果公开提供的 Mode 有两个：kCFRunLoopDefaultMode (NSDefaultRunLoopMode) 和 UITrackingRunLoopMode，你可以用这两个 Mode Name 来操作其对应的 Mode。
 
 同时苹果还提供了一个操作 Common 标记的字符串：kCFRunLoopCommonModes (NSRunLoopCommonModes)，你可以用这个字符串来操作 Common Items，或标记一个 Mode 为 "Common"。使用时注意区分这个字符串和其他 mode name。
 */

//苹果用 RunLoop 实现的功能
/**苹果官方将整个系统大致划分为上述4个层次：
应用层包括用户能接触到的图形应用，例如 Spotlight、Aqua、SpringBoard 等。
应用框架层即开发人员接触到的 Cocoa 等框架。
核心框架层包括各种核心框架、OpenGL 等内容。
Darwin 即操作系统的核心，包括系统内核、驱动、Shell 等内容
 
 可以看到，系统默认注册了5个Mode:
 1. kCFRunLoopDefaultMode: App的默认 Mode，通常主线程是在这个 Mode 下运行的。
 2. UITrackingRunLoopMode: 界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 Mode 影响。
 3. UIInitializationRunLoopMode: 在刚启动 App 时第进入的第一个 Mode，启动完成后就不再使用。
 4: GSEventReceiveRunLoopMode: 接受系统事件的内部 Mode，通常用不到。
 5: kCFRunLoopCommonModes: 这是一个占位的 Mode，没有实际作用。
 */