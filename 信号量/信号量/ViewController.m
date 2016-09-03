//
//  ViewController.m
//  信号量
//
//  Created by 杜维欣 on 16/9/2.
//  Copyright © 2016年 Nododo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
   dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        NSLog(@"1");
    });
    
    dispatch_async(concurrentQueue, ^{
        
        NSLog(@"2");
        
    });
    
    dispatch_async(concurrentQueue, ^{
        NSLog(@"3");
    });
    
    dispatch_async(concurrentQueue, ^{
        NSLog(@"4");
    });
    
    dispatch_async(concurrentQueue, ^{
        NSLog(@"5");
        dispatch_semaphore_signal(sema);
    });

}

@end
