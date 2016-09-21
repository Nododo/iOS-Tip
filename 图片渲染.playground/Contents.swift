//GPU屏幕渲染有以下两种方式：

/*On-Screen Rendering
意为当前屏幕渲染，指的是GPU的渲染操作是在当前用于显示的屏幕缓冲区中进行。

Off-Screen Rendering
意为离屏渲染，指的是GPU在当前屏幕缓冲区以外新开辟一个缓冲区进行渲染操作。
 
 特殊的离屏渲染：
 如果将不在GPU的当前屏幕缓冲区中进行的渲染都称为离屏渲染，那么就还有另一种特殊的“离屏渲染”方式： CPU渲染。
 如果我们重写了drawRect方法，并且使用任何Core Graphics的技术进行了绘制操作，就涉及到了CPU渲染。整个渲染过程由CPU在App内 同步地
 完成，渲染得到的bitmap最后再交由GPU用于显示。
 备注：CoreGraphic通常是线程安全的，所以可以进行异步绘制，显示的时候再放回主线程，一个简单的异步绘制过程大致如下
 **/

//在编解码图形类型（颜色少、细节少）的图片时，PNG 和 JPEG 差距并不大；但是对于照片类型（颜色和细节丰富）的图片来说，PNG 在文件体积、编解码速度上都差 JPEG 不少了。和 JPEG 不同，PNG 是无损压缩，其并不能提供压缩比的选项，其压缩比是有上限的。

//图片大小计算

//iOS 处理图片的一些小 Tip

/*
 如何把 GIF 动图保存到相册？
 
 iOS 的相册是支持保存 GIF 和 APNG 动图的，只是不能直接播放。用 [ALAssetsLibrary writeImageDataToSavedPhotosAlbum:metadata:completionBlock] 可以直接把 APNG、GIF 的数据写入相册。如果图省事直接用 UIImageWriteToSavedPhotosAlbum() 写相册，那么图像会被强制转码为 PNG。
 
 将 UIImage 保存到磁盘，用什么方式最好？
 
 目前来说，保存 UIImage 有三种方式：1.直接用 NSKeyedArchiver 把 UIImage 序列化保存，2.用 UIImagePNGRepresentation() 先把图片转为 PNG 保存，3.用 UIImageJPEGRepresentation() 把图片压缩成 JPEG 保存。
 
 实际上，NSKeyedArchiver 是调用了 UIImagePNGRepresentation 进行序列化的，用它来保存图片是消耗最大的。苹果对 JPEG 有硬编码和硬解码，保存成 JPEG 会大大缩减编码解码时间，也能减小文件体积。所以如果图片不包含透明像素时，UIImageJPEGRepresentation(0.9) 是最佳的图片保存方式，其次是 UIImagePNGRepresentation()。
 
 UIImage 缓存是怎么回事？
 
 通过 imageNamed 创建 UIImage 时，系统实际上只是在 Bundle 内查找到文件名，然后把这个文件名放到 UIImage 里返回，并没有进行实际的文件读取和解码。当 UIImage 第一次显示到屏幕上时，其内部的解码方法才会被调用，同时解码结果会保存到一个全局缓存去。据我观察，在图片解码后，App 第一次退到后台和收到内存警告时，该图片的缓存才会被清空，其他情况下缓存会一直存在。
 
 我要是用 imageWithData 能不能避免缓存呢？
 
 不能。通过数据创建 UIImage 时，UIImage 底层是调用 ImageIO 的 CGImageSourceCreateWithData() 方法。该方法有个参数叫 ShouldCache，在 64 位的设备上，这个参数是默认开启的。这个图片也是同样在第一次显示到屏幕时才会被解码，随后解码数据被缓存到 CGImage 内部。与 imageNamed 创建的图片不同，如果这个图片被释放掉，其内部的解码数据也会被立刻释放。
 
 怎么能避免缓存呢？
 
 1. 手动调用 CGImageSourceCreateWithData() 来创建图片，并把 ShouldCache 和 ShouldCacheImmediately 关掉。这么做会导致每次图片显示到屏幕时，解码方法都会被调用，造成很大的 CPU 占用。
 2. 把图片用 CGContextDrawImage() 绘制到画布上，然后把画布的数据取出来当作图片。这也是常见的网络图片库的做法。
 
 我能直接取到图片解码后的数据，而不是通过画布取到吗？
 
 1.CGImageSourceCreateWithData(data) 创建 ImageSource。
 2.CGImageSourceCreateImageAtIndex(source) 创建一个未解码的 CGImage。
 3.CGImageGetDataProvider(image) 获取这个图片的数据源。
 4.CGDataProviderCopyData(provider) 从数据源获取直接解码的数据。
 ImageIO 解码发生在最后一步，这样获得的数据是没有经过颜色类型转换的原生数据（比如灰度图像）。
 **/

//图片显示原理
/*
 ios_screen_display
 通常来说，计算机系统中 CPU、GPU、显示器是以上面这种方式协同工作的。CPU 计算好显示内容提交到 GPU，GPU 渲染完成后将渲染结果放入帧缓冲区，随后视频控制器会按照 VSync 信号逐行读取帧缓冲区的数据，经过可能的数模转换传递给显示器显示。
 
 在最简单的情况下，帧缓冲区只有一个，这时帧缓冲区的读取和刷新都都会有比较大的效率问题。为了解决效率问题，显示系统通常会引入两个缓冲区，即双缓冲机制。在这种情况下，GPU 会预先渲染好一帧放入一个缓冲区内，让视频控制器读取，当下一帧渲染好后，GPU 会直接把视频控制器的指针指向第二个缓冲器。如此一来效率会有很大的提升。
 
 双缓冲虽然能解决效率问题，但会引入一个新的问题。当视频控制器还未读取完成时，即屏幕内容刚显示一半时，GPU 将新的一帧内容提交到帧缓冲区并把两个缓冲区进行交换后，视频控制器就会把新的一帧数据的下半段显示到屏幕上，造成画面撕裂现象，如下图：
 
 ios_vsync_off
 
 为了解决这个问题，GPU 通常有一个机制叫做垂直同步（简写也是 V-Sync），当开启垂直同步后，GPU 会等待显示器的 VSync 信号发出后，才进行新的一帧渲染和缓冲区更新。这样能解决画面撕裂现象，也增加了画面流畅度，但需要消费更多的计算资源，也会带来部分延迟。
 **/

//卡顿产生的原因和解决方案

//在 VSync 信号到来后，系统图形服务会通过 CADisplayLink 等机制通知 App，App 主线程开始在 CPU 中计算显示内容，比如视图的创建、布局计算、图片解码、文本绘制等。随后 CPU 会将计算好的内容提交到 GPU 去，由 GPU 进行变换、合成、渲染。随后 GPU 会把渲染结果提交到帧缓冲区去，等待下一次 VSync 信号到来时显示到屏幕上。由于垂直同步的机制，如果在一个 VSync 时间内，CPU 或者 GPU 没有完成内容提交，则那一帧就会被丢弃，等待下一次机会再显示，而这时显示屏会保留之前的内容不变。这就是界面卡顿的原因。从上面的图中可以看到，CPU 和 GPU 不论哪个阻碍了显示流程，都会造成掉帧现象。所以开发时，也需要分别对 CPU 和 GPU 压力进行评估和优化。

//CPU 资源消耗原因和解决方案
/*
对象创建

对象的创建会分配内存、调整属性、甚至还有读取文件等操作，比较消耗 CPU 资源。尽量用轻量的对象代替重量的对象，可以对性能有所优化。比如 CALayer 比 UIView 要轻量许多，那么不需要响应触摸事件的控件，用 CALayer 显示会更加合适。如果对象不涉及 UI 操作，则尽量放到后台线程去创建，但可惜的是包含有 CALayer 的控件，都只能在主线程创建和操作。通过 Storyboard 创建视图对象时，其资源消耗会比直接通过代码创建对象要大非常多，在性能敏感的界面里，Storyboard 并不是一个好的技术选择。

尽量推迟对象创建的时间，并把对象的创建分散到多个任务中去。尽管这实现起来比较麻烦，并且带来的优势并不多，但如果有能力做，还是要尽量尝试一下。如果对象可以复用，并且复用的代价比释放、创建新对象要小，那么这类对象应当尽量放到一个缓存池里复用。

对象调整

对象的调整也经常是消耗 CPU 资源的地方。这里特别说一下 CALayer：CALayer 内部并没有属性，当调用属性方法时，它内部是通过运行时 resolveInstanceMethod 为对象临时添加一个方法，并把对应属性值保存到内部的一个 Dictionary 里，同时还会通知 delegate、创建动画等等，非常消耗资源。UIView 的关于显示相关的属性（比如 frame/bounds/transform）等实际上都是 CALayer 属性映射来的，所以对 UIView 的这些属性进行调整时，消耗的资源要远大于一般的属性。对此你在应用中，应该尽量减少不必要的属性修改。

当视图层次调整时，UIView、CALayer 之间会出现很多方法调用与通知，所以在优化性能时，应该尽量避免调整视图层次、添加和移除视图。

对象销毁

对象的销毁虽然消耗资源不多，但累积起来也是不容忽视的。通常当容器类持有大量对象时，其销毁时的资源消耗就非常明显。同样的，如果对象可以放到后台线程去释放，那就挪到后台线程去。这里有个小 Tip：把对象捕获到 block 中，然后扔到后台队列去随便发送个消息以避免编译器警告，就可以让对象在后台线程销毁了。


NSArray *tmp = self.array;
self.array = nil;
dispatch_async(queue, ^{
    [tmp class];
    });

布局计算

视图布局的计算是 App 中最为常见的消耗 CPU 资源的地方。如果能在后台线程提前计算好视图布局、并且对视图布局进行缓存，那么这个地方基本就不会产生性能问题了。

不论通过何种技术对视图进行布局，其最终都会落到对 UIView.frame/bounds/center 等属性的调整上。上面也说过，对这些属性的调整非常消耗资源，所以尽量提前计算好布局，在需要时一次性调整好对应属性，而不要多次、频繁的计算和调整这些属性。

Autolayout

Autolayout 是苹果本身提倡的技术，在大部分情况下也能很好的提升开发效率，但是 Autolayout 对于复杂视图来说常常会产生严重的性能问题。随着视图数量的增长，Autolayout 带来的 CPU 消耗会呈指数级上升。具体数据可以看这个文章：http://pilky.me/36/。 如果你不想手动调整 frame 等属性，你可以用一些工具方法替代（比如常见的 left/right/top/bottom/width/height 快捷属性），或者使用 ComponentKit、AsyncDisplayKit 等框架。

文本计算

如果一个界面中包含大量文本（比如微博微信朋友圈等），文本的宽高计算会占用很大一部分资源，并且不可避免。如果你对文本显示没有特殊要求，可以参考下 UILabel 内部的实现方式：用 [NSAttributedString boundingRectWithSize:options:context:] 来计算文本宽高，用 -[NSAttributedString drawWithRect:options:context:] 来绘制文本。尽管这两个方法性能不错，但仍旧需要放到后台线程进行以避免阻塞主线程。

如果你用 CoreText 绘制文本，那就可以先生成 CoreText 排版对象，然后自己计算了，并且 CoreText 对象还能保留以供稍后绘制使用。

文本渲染

屏幕上能看到的所有文本内容控件，包括 UIWebView，在底层都是通过 CoreText 排版、绘制为 Bitmap 显示的。常见的文本控件 （UILabel、UITextView 等），其排版和绘制都是在主线程进行的，当显示大量文本时，CPU 的压力会非常大。对此解决方案只有一个，那就是自定义文本控件，用 TextKit 或最底层的 CoreText 对文本异步绘制。尽管这实现起来非常麻烦，但其带来的优势也非常大，CoreText 对象创建好后，能直接获取文本的宽高等信息，避免了多次计算（调整 UILabel 大小时算一遍、UILabel 绘制时内部再算一遍）；CoreText 对象占用内存较少，可以缓存下来以备稍后多次渲染。

图片的解码

当你用 UIImage 或 CGImageSource 的那几个方法创建图片时，图片数据并不会立刻解码。图片设置到 UIImageView 或者 CALayer.contents 中去，并且 CALayer 被提交到 GPU 前，CGImage 中的数据才会得到解码。这一步是发生在主线程的，并且不可避免。如果想要绕开这个机制，常见的做法是在后台线程先把图片绘制到 CGBitmapContext 中，然后从 Bitmap 直接创建图片。目前常见的网络图片库都自带这个功能。

图像的绘制

图像的绘制通常是指用那些以 CG 开头的方法把图像绘制到画布中，然后从画布创建图片并显示这样一个过程。这个最常见的地方就是 [UIView drawRect:] 里面了。由于 CoreGraphic 方法通常都是线程安全的，所以图像的绘制可以很容易的放到后台线程进行。一个简单异步绘制的过程大致如下（实际情况会比这个复杂得多，但原理基本一致）：


- (void)display {
    dispatch_async(backgroundQueue, ^{
        CGContextRef ctx = CGBitmapContextCreate(...);
        // draw in context...
        CGImageRef img = CGBitmapContextCreateImage(ctx);
        CFRelease(ctx);
        dispatch_async(mainQueue, ^{
            layer.contents = img;
            });
        });
}
**/

// GPU 资源消耗原因和解决方案
/*
 相对于 CPU 来说，GPU 能干的事情比较单一：接收提交的纹理（Texture）和顶点描述（三角形），应用变换（transform）、混合并渲染，然后输出到屏幕上。通常你所能看到的内容，主要也就是纹理（图片）和形状（三角模拟的矢量图形）两类。
 
 纹理的渲染
 
 所有的 Bitmap，包括图片、文本、栅格化的内容，最终都要由内存提交到显存，绑定为 GPU Texture。不论是提交到显存的过程，还是 GPU 调整和渲染 Texture 的过程，都要消耗不少 GPU 资源。当在较短时间显示大量图片时（比如 TableView 存在非常多的图片并且快速滑动时），CPU 占用率很低，GPU 占用非常高，界面仍然会掉帧。避免这种情况的方法只能是尽量减少在短时间内大量图片的显示，尽可能将多张图片合成为一张进行显示。
 
 当图片过大，超过 GPU 的最大纹理尺寸时，图片需要先由 CPU 进行预处理，这对 CPU 和 GPU 都会带来额外的资源消耗。目前来说，iPhone 4S 以上机型，纹理尺寸上限都是 4096x4096，更详细的资料可以看这里：iosres.com。所以，尽量不要让图片和视图的大小超过这个值。
 
 视图的混合 (Composing)
 
 当多个视图（或者说 CALayer）重叠在一起显示时，GPU 会首先把他们混合到一起。如果视图结构过于复杂，混合的过程也会消耗很多 GPU 资源。为了减轻这种情况的 GPU 消耗，应用应当尽量减少视图数量和层次，并在不透明的视图里标明 opaque 属性以避免无用的 Alpha 通道合成。当然，这也可以用上面的方法，把多个视图预先渲染为一张图片来显示。
 
 图形的生成。
 
 CALayer 的 border、圆角、阴影、遮罩（mask），CASharpLayer 的矢量图形显示，通常会触发离屏渲染（offscreen rendering），而离屏渲染通常发生在 GPU 中。当一个列表视图中出现大量圆角的 CALayer，并且快速滑动时，可以观察到 GPU 资源已经占满，而 CPU 资源消耗很少。这时界面仍然能正常滑动，但平均帧数会降到很低。为了避免这种情况，可以尝试开启 CALayer.shouldRasterize 属性，但这会把原本离屏渲染的操作转嫁到 CPU 上去。对于只需要圆角的某些场合，也可以用一张已经绘制好的圆角图片覆盖到原本视图上面来模拟相同的视觉效果。最彻底的解决办法，就是把需要显示的图形在后台线程绘制为图片，避免使用圆角、阴影、遮罩等属性。
 **/

//GPUImage是现在做滤镜最主流的开源框架，没有之一。作者BradLarson基于openGL对图片处理单元进行封装，提供出GPUImageFilter基类，配合shader，常用滤镜都拿下不是问题。
//OpenGL是一种应用程序编程接口（API），它是一种可以对图形硬件设备特性进行访问的软件库。
//shader 着色器
