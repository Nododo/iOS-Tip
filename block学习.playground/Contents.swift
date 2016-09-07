//block

//http://ios.jobbole.com/88406/

/*
 一个 block 实例实际上由 6 部分构成：
 isa 指针，所有对象都有该指针，用于实现对象相关的功能。
 flags，用于按 bit 位表示一些 block 的附加信息，本文后面介绍 block copy 的实现代码可以看到对该变量的使用。
 reserved，保留变量。
 invoke，函数指针，指向具体的 block 实现的函数调用地址。
 descriptor， 表示该 block 的附加描述信息，主要是 size 大小，以及 copy 和 dispose 函数的指针。
 variables，capture 过来的变量，block 能够访问它外部的局部变量，就是因为将这些变量（或变量的地址）复制到了结构体中。
 **/

//在 Objective-C 语言中，一共有 3 种类型的 block：
/*
 _NSConcreteStackBlock：
 只用到外部局部变量、成员属性变量，且没有强指针引用的block都是StackBlock。
 StackBlock的生命周期由系统控制的，一旦返回之后，就被系统销毁了。
 _NSConcreteMallocBlock：
 有强指针引用或copy修饰的成员属性引用的block会被复制一份到堆中成为MallocBlock，没有强指针引用即销毁，生命周期由程序员控制
 _NSConcreteGlobalBlock：
 没有用到外界变量或只用到全局变量、静态变量的block为_NSConcreteGlobalBlock，生命周期从创建到应用程序结束。
 **/

//由于_NSConcreteStackBlock所属的变量域一旦结束，那么该Block就会被销毁。在ARC环境下，编译器会自动的判断，把Block自动的从栈copy到堆。比如当Block作为函数返回值的时候，肯定会copy到堆上。
/*
1.手动调用copy
2.Block是函数的返回值
3.Block被强引用，Block被赋值给__strong或者id类型
4.调用系统API入参中含有usingBlcok的方法
**/


//Block 循环引用  存在循环引用的情况：当block对象 作为类的 属性或者成员变量，并且在block初始化的时候，调用了self或者self相关类的成员变量。都会引起引用循环。
/*
 解决方法：
 
 使用__weak 修饰要截取的自动变量，
 当在MRC 中时，可以使用__unsafe_unretained（弊端 不会自动置nil 容易出现野指针） 修饰。
 可以使用block 修饰，前提是 必须 执行block代码块，而且可以适当地在代码块中 手动的把block变量置nil
 **/