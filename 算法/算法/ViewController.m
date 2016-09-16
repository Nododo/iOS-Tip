//
//  ViewController.m
//  算法
//
//  Created by dwx on 16/9/16.
//  Copyright © 2016年 Nododo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%d",[self binaryCountsWithNum:8]);
}


//某个整数的二进制含有多少个1
- (int)binaryCountsWithNum:(int)num {
    int count = 0;
    while (num >= 1) {
        //先判断奇数偶数  偶数证明转二级制时除以2余数为0 二进制中不包含1  不为0证明二级制中含有1
        if (num % 2 == 1) {
            count ++;
        }
        num /= 2;
        NSLog(@"num =%d",num);
    }
    return count;
}
@end
