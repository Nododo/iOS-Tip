//
//  ViewController.m
//  MergeTwoArray
//
//  Created by 杜维欣 on 16/11/9.
//  Copyright © 2016年 Nododo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arr1 = @[@"1", @"3", @"5", @"7", @"9"];
    
    NSArray *arr2 = @[@"2", @"4", @"6", @"8", @"10"];
    
    NSArray *array =  [self mergeArray1:arr1 array2:arr2];
    
    NSLog(@"%@",array);
}

- (NSArray *)mergeArray1:(NSArray *)array1 array2:(NSArray *)array2 {
    int i = 0;
    int j = 0;
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:array1.count + array2.count];
    while (i < array1.count && j < array2.count) {
        resultArray[i + j] = [array1[i] integerValue] < [array2[j] integerValue] ? array1[i++] : array2[j++];
    }
    while (i < array1.count) {
        resultArray[i + j] = array1[i ++];
    }
    while (j < array2.count) {
        resultArray[i + j] = array2[j ++];
    }
    
    return resultArray;
}
@end
