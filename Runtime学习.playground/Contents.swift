
//:Runtime 学习

//[receiver message]    发送消息

//不包含参数
//objc_msgSend(receiver, selector)
//包含参数
//objc_msgSend(receiver, selector, arg1, arg2, ...)

//SEL 方法选择器   selector 在Objc中的表示
/**
 typedef struct objc_method *Method
 struct objc_method {
    SEL method_name    方法名    方法名类型为SEL
    char *method_types    方法类型    方法类型method_types是个char指针，其实存储着方法的参数类型和返回值类型
    IMP method_imp    方法实现    指向了方法的实现，本质上是一个函数指针  typedef id (*IMP)(id, SEL, ...);
 }
 */

//typedef struct objc_object *id;
//struct objc_object { Class isa; };

//Class是一个指向objc_class结构体的指针
//包含:超类指针 类名 成员变量 方法 缓存 协议等

/**
 struct objc_ivar {实例变量    通过class_copyIvarList
 char *ivar_name   变量名
 char *ivar_type   变量类型
 int ivar_offset   偏移量
 }
 */

//Cache

/**
 struct objc_cache {
 unsigned int mask /* total = mask + 1 */                 OBJC2_UNAVAILABLE;
 unsigned int occupied                                    OBJC2_UNAVAILABLE;
 Method buckets[1]                                        OBJC2_UNAVAILABLE;
 };
 Cache为方法调用的性能进行优化，通俗地讲，每当实例对象接收到一个消息时，它不会直接在isa指向的类的方法列表中遍历查找能够响应消息的方法，因为这样效率太低了，而是优先在Cache中查找。Runtime 系统会把被调用的方法存到Cache中（理论上讲一个方法如果被调用，那么它有可能今后还会被调用），下次查找的时候效率更高。
 */

//Property

/**
 通过class_copyPropertyList获取属性列表
 通过property_getName获取属性名字
 通过property_getAttributes获取属性值
 */

//objc_msgSend函数

/**
 检测这个 selector 是不是要忽略的。比如 Mac OS X 开发，有了垃圾回收就不理会 retain, release 这些函数了。
 检测这个 target 是不是 nil 对象。ObjC 的特性是允许对一个 nil 对象执行任何一个方法不会 Crash，因为会被忽略掉。
 如果上面两个都过了，那就开始查找这个类的 IMP，先从 cache 里面找，完了找得到就跳到对应的函数去执行。
 如果 cache 找不到就找一下方法分发表。
 如果分发表找不到就到超类的分发表去找，一直找，直到找到NSObject类为止。
 如果还找不到就要开始进入动态方法解析了，后面会提到。
 PS:这里说的分发表其实就是Class中的方法列表，它将方法选择器和方法实现地址联系起来。
 */

//Objective-C Associated Objects
/**
 void objc_setAssociatedObject ( id object, const void *key, id value, objc_AssociationPolicy policy );
 id objc_getAssociatedObject ( id object, const void *key );
 void objc_removeAssociatedObjects ( id object );
 */

//Method swizzling
/**
 #import <objc/runtime.h>
 @implementation UIViewController (Tracking)
 + (void)load {
 static dispatch_once_t onceToken;
 dispatch_once(&onceToken, ^{
 Class aClass = [self class];
 
 SEL originalSelector = @selector(viewWillAppear:);
 SEL swizzledSelector = @selector(xxx_viewWillAppear:);
 
 Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
 Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);
 
 // When swizzling a class method, use the following:
 // Class aClass = object_getClass((id)self);
 // ...
 // Method originalMethod = class_getClassMethod(aClass, originalSelector);
 // Method swizzledMethod = class_getClassMethod(aClass, swizzledSelector);
 
 BOOL didAddMethod =
 class_addMethod(aClass,
 originalSelector,
 method_getImplementation(swizzledMethod),
 method_getTypeEncoding(swizzledMethod));
 
 if (didAddMethod) {
 class_replaceMethod(aClass,
 swizzledSelector,
 method_getImplementation(originalMethod),
 method_getTypeEncoding(originalMethod));
 } else {
 method_exchangeImplementations(originalMethod, swizzledMethod);
 }
 });
 }
 - (void)xxx_viewWillAppear:(BOOL)animated {
 [self xxx_viewWillAppear:animated];
 NSLog(@"viewWillAppear: %@", self);
 }
 
 @end*/
