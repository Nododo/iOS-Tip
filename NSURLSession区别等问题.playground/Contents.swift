//用NSURLConnection/NSURLSession区别
/*
答:1.使用NSURLConnection发送请求的步骤很简单

（1）创建一个NSURL对象，设置请求路径（设置请求路径）

（2）传入NSURL创建一个NSURLRequest对象，设置请求头和请求体（创建请求对象）

（3）使用NSURLConnection发送NSURLRequest（发送请求）

2.使用NSURLSession发送请求的步骤很简单

1）确定请求路径（一般由公司的后台开发人员以接口文档的方式提供），GET请求参数直接跟在URL后面

2）创建请求对象（默认包含了请求头和请求方法【GET】），此步骤可以省略

3）创建会话对象（NSURLSession）

4）根据会话对象创建请求任务（NSURLSessionDataTask）

5）执行Task

6）当得到服务器返回的响应后，解析数据（XML|JSON|HTTP）
 **/