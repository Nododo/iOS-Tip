//SQLite(增、删、改、查 )以及第三方框架FMDB的基本使用

//多线程操作数据库
/*
 http://www.jianshu.com/p/7858d6c4df9e
 1, NSLock或类似方法加锁
 2, FMDatabaseQueue
 3, SQLITE_CONFIG_SERIALIZED
 **/

//相比其他数据库,SQLite数据库的数据类型仅仅就四种:
/*
integer : 整型值

real : 浮点值

text : 文本字符串

blob : 二进制数据（比如文件）
**/

//SQL语句简单的可以分为以下三类
/*
 数据定义语句（DDL：Data Definition Language）
 包括create和drop等操作(通常用来创建表或者删除表)
 
 数据操作语句（DML：Data Manipulation Language）
 包括insert、update、delete等操作(添加、修改、删除表中的数据)
 
 数据查询语句（DQL：Data Query Language）
 可以用于查询获得表中的数据 关键字select(通常用来查询表数据)以及where(添加条件)，order by(排序)，group by(分组)和having(通常是在一个 SQL 句子的最后)
 **/

//SQLite数据库的基本操作
/*
 SQLite数据库的基本操作
 表的约束
 工作中,为了符合我们日常操作以及流程的规范,常常创建表的时候我们需要考虑多方面的因素,比如有些代表特别意义的字段不能为空(姓名,性别等...),有些字段必须为一(身份证),这个时候就需要我们给字段设置严格的约束,让其从创建数据库表的时候就把一些不规范的数据给排除掉,以保证数据的规范性.
 
 关健字:
 Not Null ：规定字段的值不能为NULL
 
 Unique ：规定字段的值必须唯一
 
 Default ：指定字段的默认值
 
 //NAME字段不能为NULL，并且唯一age字段不能为NULL，并且默认为1
 CREATE TABLE t_test (ID INTEGER, NAME TEXT NOT NULL UNIQUE, AGE INTEGER NOT NULL DEFAULE 1);
 主键约束
 为了更方便的管理数据,保证数据的规范性,数据库设计之初应该多考虑数据的唯一性,因此再创建表的时候,我们有必要给表添加一个主键,来约束表中的数据,当然如果设计的数据逻辑关联性比较复杂的时候我们也可以指定多个字段来充当我们表的主键(联合主键)
 
 在创表的时候用PRIMARY KEY声明一个主键
 
 //ID作为t_test表的主键,并且设置为自增长
 CREATE TABLE t_test (ID INTEGER PRIMARY KEY AUTOINCREMENT,NAME TEXT,AGE INTEGER);
 外键
 主要使用来约束表与表之间的关系,比如某个表中得一个字段是另一个表中得主键,这个时候我们就需要用到外键了
 
 创建表(CREATE)
 格式:
 CREATE TABLE IF NOT EXISTS 表名 (字段名1 字段1类型,字段名2,字段2类型,...);
 示例:
 CREATE TABLE IF NOT EXISTS t_test (ID INTEGER,NAME TEXT,AGE INTEGER);
 删除表(DROP)
 格式:
 DROP TABLE IF EXISTS 表名;
 示例:
 DROP TABLE IF EXISTS t_test;
 插入数据(INSERT)
 格式:
 INSERT INTO 表名 (字段名1,字段名2,...)VALUES (字段1的值,字段2的值,...);
 示例:
 INSERT INTO t_test (ID,NAME,AGE)VALUES (1,'J_mailbox',23);
 更新数据(UPDATE)
 格式:
 UPDATE 表名 SET 字段名1=字段1的值,字段名2=字段名2的值,...;
 示例:
 UPDATE t_test SET ID=2,NAME='J_mailbox',AGE=25;
 删除数据(DELETE)
 格式:
 DELETE FROM 表名;
 示例:
 DELETE FROM t_test;
 查询语句
 格式:
 SELECT * FROM 表名;
 SELECT NAME,AGE FROM 表名;
 示例:
 SELECT * FROM t_test;
 SELECT NAME,AGE FROM t_test;
 条件语句
 格式:
 //查询表中字段等于某个值的所有记录
 SELECT * FROM 表名 WHERE 字段 = 某个值;
 
 //查询表中字段不等于某个值的所有记录
 SELECT * FROM 表名 WHERE 字段 != 某个值
 
 //查询表中字段是某个值的所有记录
 SELECT * FROM 表名 WHERE 字段 IS 某个值
 
 //查询表中字段不是某个值的所有记录
 SELECT * FROM 表名 WHERE 字段 IS NOT 某个值
 
 //查询表中字段大于某个值的所有记录
 SELECT * FROM 表名 WHERE 字段 > 某个值
 
 //查询表中字段小于某个值的所有记录
 SELECT * FROM 表名 WHERE 字段 < 某个值
 
 //查询表中某个字段依某个值开头的所有记录
 SELECT * FROM 表名 WHERE 字段 LIKE "某个值%"
 
 //查询表中某个字段包含某个值的所有记录
 SELECT * FROM 表名 WHERE 字段 LIKE "%某个值%"
 
 //查询表中记录从多少行开始,查询多少行记录
 SELECT * FROM 表名 LIMIT 从多少行开始,查询多少行;
 
 //查询表中字段名1等于某个值并且字段名2大于某个值的所有记录(两个条件都要满足)
 SELECT * FROM 表名 WHERE 字段名1 = 某个值 AND 字段名2 >某个值
 
 //查询表中字段名1等于某个值或者字段名2小于某个值的所有记录(两个条件满足一个就可以)
 SELECT * FROM 表名 WHERE 字段名1 = 某个值 OR 字段名2 <某个值
 
 //更新表中字段等于某个值并且字段大于某个值的所有记录
 UPDATE 表名 SET 字段名1= WHERE 字段名2=某个值 AND 字段名3 >某个值;
 //删除t_test表中NAME等于J_mailbox或者AGE小于18的所有记录
 DELETE FROM 表名 WHERE 字段名1=某个值 OR 字段名2 <某个值;
 
 
 示例:
 //查询t_test表中NAME字段等于J_mailbox的所有记录
 SELECT * FROM t_test WHERE NAME ='J_mailbox';
 
 //查询t_test表中NAME字段不等于J_mailbox的所有记录
 SELECT * FROM t_test WHERE NAME !='J_mailbox';
 
 //查询t_test表中NAME字段是J_mailbox的所有记录
 SELECT * FROM t_test WHERE NAME IS 'J_mailbox';
 
 //查询t_test表中NAME字段不是J_mailbox的所有记录
 SELECT * FROM t_test WHERE NAME IS NOT 'J_mailbox';
 
 //查询t_test表中AGE字段大于20的所有记录
 SELECT * FROM t_test WHERE AGE > 20;
 
 //查询t_test表中AGE字段大于20的所有记录
 SELECT * FROM t_test WHERE AGE < 20;
 
 //查询t_test中NAME依J字母开头的所有记录
 SELECT * FROM 表名 WHERE NAME LIKE "J%"
 
 //查询t_test中NAME包含_mail的所有记录
 SELECT * FROM 表名 WHERE NAME LIKE "%_mail%"
 
 //查询表中记录从0行开始,查询10行记录
 SELECT * FROM 表名 LIMIT 0,10;
 
 //查询t_test表中NAME等于J_mailbox并且AGE字段大于20的所有记录(两个条件都要满足)
 SELECT * FROM t_test WHERE NAME ='J_mailbox' AND AGE > 20;
 
 //查询t_test表中NAME等于J_mailbox或者AGE字段小于20的所有记录(两个条件满足一个就可以)
 SELECT * FROM t_test WHERE NAME ='J_mailbox' OR AGE < 20;
 
 //更新t_test表中NAME等于J_mailbox并且AGE大于18的所有记录
 UPDATE t_test SET AGE=20 WHERE NAME='J_mailbox' AND AGE >18;
 
 //删除t_test表中NAME等于J_mailbox或者AGE小于18的所有记录
 DELETE FROM t_test WHERE NAME='J_mailbox' OR AGE <18;
 起别名(AS)
 格式:
 SELECT 字段名1 别名1 ,字段名2 别名2,... FROM 表名;
 SELECT 字段名1 AS 别名1 ,字段名2 AS 别名2,... FROM 表名;
 
 示例:
 SELECT NAME 姓名 ,AGE 年龄 FROM t_test;
 SELECT NAME AS 姓名,AGE AS 年龄 FROM t_test;
 排序(ORDER BY, ASC,DESC)
 格式:
 SELECT * FROM 表名 ORDER BY 字段名;
 SELECT * FROM 表名 ORDER BY 字段名 DESC;
 SELECT * FROM 表名 ORDER BY 字段名1 ASC,字段名2 DESC;
 
 示例:
 SELECT * FFROM t_test ORDER BY AGE;
 SELECT * FFROM t_test ORDER BY AGE DESC;
 SELECT * FROM t_test ORDER BY 字段名1 ASC,字段名2 DESC;
 计算记录的总数量(COUNT)
 格式:
 SELECT COUNT(*) FROM 表名;
 SELECT COUNT(字段) FROM 表名;
 
 示例:
 SELECT COUNT(*) FROM t_test;
 SELECT COUNT(AGE) FROM t_test;
 SQLite常用函数
 打开数据库
 
 int sqlite3_open(
 
 const char *filename,   // 数据库的文件路径
 
 sqlite3 **ppDb          // 数据库实例
 
 );
 执行SQL语句
 
 int sqlite3_exec(
 
 sqlite3*,                                  // 一个打开的数据库实例
 
 const char *sql,                           // 需要执行的SQL语句
 
 int (*callback)(void*,int,char**,char**),  // SQL语句执行完毕后的回调
 
 void *,                                    // 回调函数的第1个参数
 
 char **errmsg                              // 错误信息
 
 );
 Objective-C对SQLite数据库的增删改查操作
 要使用SQLite,首先我们要导入SQLite3框架
 #import "ViewController.h"
 #import <sqlite3.h>
 
 @interface ViewController ()
 @property (nonatomic,assign)sqlite3 *db;
 @end
 
 @implementation ViewController
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 //连接数据库
 [self connectionDB];
 }
 
 //连接数据库
 - (void)connectionDB{
 NSLog(@"%@",NSHomeDirectory());
 //获取路径
 NSString *path=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"data.sqlite"];
 //判断数据库是否打开成功
 int success=sqlite3_open(path.UTF8String, &_db);
 //如果数据库打开成功
 if (success==SQLITE_OK) {
 //创建表SQL语句,并且设置ID为主键,且自动增长
 NSString *sql=@"CREATE TABLE IF NOT EXISTS t_test (ID INTEGER PRIMARY KEY AUTOINCREMENT,NAME TEXT,AGE INTEGER)";
 //判断创建表是否成功
 int success_t=sqlite3_exec(_db, sql.UTF8String, NULL, NULL, NULL);
 //如果创建表成功
 if (success_t==SQLITE_OK) {
 NSLog(@"创建表成功!");
 }else{
 NSLog(@"创建表失败");
 }
 }else{
 NSLog(@"数据库创建失败");
 }
 //关闭数据库
 //sqlite3_close(_db);
 }
 
 //增加数据
 - (IBAction)addClick:(id)sender {
 
 //往表中循环插入100条数据
 for (int i = 0; i < 100 ; i++) {
 //名称设置为J_mailbox
 NSString *name = [NSString stringWithFormat:@"J_mailbox-%d",i];
 //随机生成20岁~25岁之间的记录
 NSInteger age = arc4random_uniform(5) + 20;
 
 //sql插入语句的拼接
 NSString *resultStr = [NSString stringWithFormat:@"INSERT INTO t_test (NAME,AGE) VALUES('%@',%zd) ",name,age];
 //执行sql插入语句
 int success =  sqlite3_exec(_db, resultStr.UTF8String, NULL, NULL, NULL);
 //判断是否插入成功
 if (success == SQLITE_OK) {
 NSLog(@"添加数据成功!");
 }else{
 NSLog(@"添加数据失败!");
 }
 
 }
 
 }
 
 //删除数据
 - (IBAction)deleteClick:(id)sender {
 
 //sql删除语句
 NSString *sqlStr = @"DELETE FROM t_test WHERE AGE > 22 ;";
 //执行删除语句操作
 int success =  sqlite3_exec(_db, sqlStr.UTF8String, NULL, NULL, NULL);
 
 if (success == SQLITE_OK) {
 NSLog(@"删除数据成功!");
 }else{
 NSLog(@"删除数据失败!");
 }
 
 }
 
 //修改数据数据
 - (IBAction)updateClick:(id)sender {
 
 //sql修改语句
 NSString *sqlStr = @"UPDATE t_test SET AGE = 30 WHERE AGE <25;";
 //执行修改语句操作
 int success =  sqlite3_exec(_db, sqlStr.UTF8String, NULL, NULL, NULL);
 
 if (success == SQLITE_OK) {
 NSLog(@"修改数据成功!");
 }else{
 NSLog(@"修改数据失败!");
 }
 }
 
 //查询数据
 - (IBAction)selectClick:(id)sender {
 
 //sql查询语句
 NSString *sqlStr = @"SELECT NAME,AGE FROM t_test WHERE AGE = 30;";
 //定义存放结果数据stmt
 sqlite3_stmt *stmt = NULL;
 //取一条记录
 int success = sqlite3_prepare_v2(_db, sqlStr.UTF8String,-1, &stmt, NULL);
 if (success == SQLITE_OK) {
 NSLog(@"查询数据成功!");
 //拿数据 step 一步 拿一条记录
 while (sqlite3_step(stmt) == SQLITE_ROW) { //证明取到了一条记录
 //查询到得NAME
 const char *name = (const char *)sqlite3_column_text(stmt, 0);
 //查询到得AGE
 int age = sqlite3_column_int(stmt, 1);
 //打印结果
 NSLog(@"NAME = %@ AGE = %d",[NSString stringWithUTF8String:name],age);
 }
 
 }else{
 NSLog(@"查询数据失败!");
 }
 }
 FMDB的使用
 因为自带的SQLite3 是基于C语言的API,所以使用的时候有些繁琐,而FMDB是面向对象的,使用起来更加的简单,且只需要调用对应的方法,传值进去即可,而且还提供了多线程安全
 FMDB下载地址:https://github.com/ccgus/fmdb
 示例:
 #import "ViewController.h"
 #import <sqlite3.h>
 #import "FMDB.h"
 @interface ViewController ()
 @property (nonatomic, strong) FMDatabase *db;
 @end
 
 @implementation ViewController
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 
 //连接数据库
 [self connectionDB];
 }
 
 //连接数据库
 - (void)connectionDB{
 
 //创建数据库路径
 NSString *path  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"data.sqlite"];
 FMDatabase *db = [FMDatabase databaseWithPath:path];
 self.db = db;
 BOOL success = [db open];
 if (success) { //打开成功
 NSLog(@"数据库创建成功!");
 //创建表  执行一条sql语句  增删改 都是这样的  查询比较特殊
 NSString *sqlStr = @"CREATE TABLE IF NOT EXISTS t_test (ID INTEGER PRIMARY KEY AUTOINCREMENT ,NAME TEXT ,AGE INTEGER );";
 BOOL successT = [self.db executeUpdate:sqlStr];
 
 if (successT) {
 NSLog(@"创建表成功!");
 }else{
 NSLog(@"创建表失败!");
 }
 
 
 }else{
 NSLog(@"数据库创建失败!");
 }
 
 NSLog(@"%@",NSHomeDirectory());
 
 //关闭数据库
 //sqlite3_close(_db);
 }
 
 //增加数据
 - (IBAction)addClick:(id)sender {
 
 //往表中循环插入100条数据
 for (int i = 0; i < 100 ; i++) {
 //名称设置为J_mailbox
 NSString *name = [NSString stringWithFormat:@"J_mailbox-%d",i];
 //随机生成20岁~25岁之间的记录
 NSInteger age = arc4random_uniform(5) + 20;
 
 //sql插入语句的拼接
 NSString *resultStr = [NSString stringWithFormat:@"INSERT INTO t_test (NAME,AGE) VALUES('%@',%zd) ",name,age];
 
 //执行sql插入语句(调用FMDB对象方法)
 BOOL success = [self.db executeUpdate:resultStr];
 //判断是否添加成功
 if (success) {
 NSLog(@"添加数据成功!");
 }else{
 NSLog(@"添加数据失败!");
 }
 
 }
 
 
 }
 
 //删除数据
 - (IBAction)deleteClick:(id)sender {
 
 //删除语句
 NSString *sqlStr = @"DELETE FROM t_test WHERE AGE > 22 ;";
 //执行sql删除语句(调用FMDB对象方法)
 BOOL success = [self.db executeUpdate:sqlStr];
 
 if (success) {
 NSLog(@"删除数据成功!");
 }else{
 NSLog(@"删除数据失败!");
 }
 }
 
 //修改数据
 - (IBAction)updateClick:(id)sender {
 
 //修改语句
 NSString *sqlStr = @"UPDATE t_test SET AGE = 30 WHERE AGE <25;";
 //执行sql修改语句(调用FMDB对象方法)
 BOOL success = [self.db executeUpdate:sqlStr];
 
 if (success) {
 NSLog(@"修改数据成功!");
 }else{
 NSLog(@"修改数据失败!");
 }
 
 }
 
 //查询数据
 - (IBAction)selectClick:(id)sender {
 
 //查询语句
 NSString *sqlStr = @"SELECT NAME,AGE FROM t_test WHERE AGE = 30;";
 
 //执行sql查询语句(调用FMDB对象方法)
 FMResultSet *set =  [self.db executeQuery:sqlStr];
 
 while ([set next]) { //等价于 == sqlite_Row
 //NAME
 NSString *name = [set stringForColumnIndex:0];
 //AGE
 NSInteger age = [set intForColumnIndex:1];
 
 NSLog(@"NAME = %@ AGE = %ld",name,(long)age);
 }
 
 }
 @end
 **/
