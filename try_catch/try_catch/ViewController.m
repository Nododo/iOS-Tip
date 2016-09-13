//
//  ViewController.m
//  try_catch
//
//  Created by 杜维欣 on 16/9/13.
//  Copyright © 2016年 Nododo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[];
    NSString *firstObject = [array objectAtIndex:1];
//    @try {
//        
//        [self testException];
//        
//    }
//    
//    @catch (NSException *exception) {
//        
//        NSLog(@"exception name is %@,reason is %@",exception.name,exception.reason);
//        
//    }
//    
//    @finally {
//        
//        NSLog(@"@finally里的代码始终会执行的");
//        
//    }
}

- (void)testException {
    
    NSException *excetpion = [NSException exceptionWithName:@"MyException" reason:@"test exception" userInfo:nil];
    
    @throw excetpion;
    
    //或者这样
    
    //[NSException raise:@"MyException" format:@"test exception"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSArray *array = @[];
    @try {
        NSString *firstObject = [array objectAtIndex:1];
    } @catch (NSException *exception) {
        NSLog(@"exception name is %@,reason is %@",exception.name,exception.reason);
    } @finally {
        NSLog(@"@finally里的代码始终会执行的");
    }

}

@end
