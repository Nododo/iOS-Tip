//用NSURLConnection/NSURLSession区别

/*
 Hi,
  I understand that NSURLSession from iOS 9 automatically handles HTTP/2 without any user interaction.
 Is the same correct using CFNetwork (CFHTTP for example)? Or I need to handle the whole "upgrade" flow?
 Thanks

 Is the same correct using CFNetwork (CFHTTP for example)?
 No.
 To be clear, both NSURLConnection and CFHTTPStream are now formally deprecated and, while we don't plan to remove those APIs any time soon, we also don't plan to add any new features to them either.
 You should adopt NSURLSession.
 If you can't adopt NSURLSession due to some deficiency in the API or implementation, please file a bug report describing the problem, and then post the bug number here just for the record.
 **/
/*
1.使用NSURLConnection发送请求的步骤

（1）创建一个NSURL对象，设置请求路径（设置请求路径）

（2）传入NSURL创建一个NSURLRequest对象，设置请求头和请求体（创建请求对象）

（3）使用NSURLConnection发送NSURLRequest（发送请求）

2.使用NSURLSession发送请求的步骤

1）确定请求路径

2）创建会话对象（NSURLSession）

3）根据会话对象创建请求任务（NSURLSessionDataTask）

4）执行Task

 **/

/*
 1.NSURLSession最直接的改进在于可以配置每个session的缓存，协议，cookie以及证书策略，甚至跨程序共享这些信息，这将允许程序和网络框架之间相互独立，不会发生干扰。每个NSURLSession 对象都由一个NSURLSessionConfiguration对象来进行初始化，提升了性能。
 2.NSURLSession第二大区别：session Task。它负责处理数据加载以及文件和数据在客户端与服务端之间下载和上传。NSURLSession与NSURLConnection都是负责数据加载，不同之处在于所有的task共享其创造者NSURLSession 公共委托者；
 **/

 //一.CFNetWork简介
 /*
 1.CFNetWork是属于core Foundation层。该层是苹果对socket进行了简单的封装，该层提供了CFNetWork,CFNetServices。
 
 2.著名的ASI网络框架在网络请求方面 就是对CFNetWork进行封装的。
 
 3.CFNetWork主要依赖两个API，CFSocket和CFStream，CFSocket主要用于网络底层的通信，而CFSteam包括CFReadStream和CFWriteStream，分别对Socket的读取和写入。
 **/
//二.NSURLSession简介
/*
1.NSURLSession是一系列类的总称，核心类包括：NSURLSession,NSURLRequest，NSURLSessionConfiguration，NSURLSessionTask，NSCache

2.NSURLSession的作用是帮助我们快速的实现网络请求，并且非常方便的管理网络请求任务，例如后台任务，暂停任务。
**/

//HTTP  Socket区别
/*
 http：
 http是简单对象访问协议，是基于socket上的；对应于应用层，主要解决如何包装数据
 
 socket：
 socket本身不是协议，而是一个调用接口（API),是对TCP、UDP的封装
 
 TCP协议：
 对应传输层
 
 ip协议
 对应网络层，主要解决数据如何在网络中传输
 
 区别
 http连接是短连接，即客户端向服务器发送一次请求，服务器端响应后会断掉连接。
 socket连接是长连接，理论上客户端和服务器建立连接将不会主动断掉。
 socket是一个接口，封装了TCP和UDP，可以借助socket建立TCP连接。TCP/UDP是传输层，Http是应用层协议，而Http实际上也建立在TCP协议之上。socket是对TCP/UDP协议的封装，本身不是协议，只是调用接口。通过socket我们可以使用TCP/UDP协议，socket只是让程序员更方便的使用TCP/UDP协议，从而形成了我们知道的一些最基本的函数接口。
 **/
