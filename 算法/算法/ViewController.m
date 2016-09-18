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
    //    NSArray *numberA = @[@33, @22, @58, @69, @98, @1, @6, @8, @56, @32];
    //    [self bubbleSortWithArray:numberA];
    NSLog(@"%d",[self binaryCountsWithNum:8]);
}

//冒泡排序
- (void)bubbleSortWithArray:(NSArray *)array {
    int count = 0;
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:array];
    for (int i = 0; i < tempArray.count; i ++) {
        count = 0;
        NSLog(@"%@",tempArray);
        for (int j = 0; j < tempArray.count - 1 - i; j ++) {
            count ++;
            //            NSLog(@"i = %d j = %d count = %d", i, j, count);
            if ([tempArray[j] intValue] > [tempArray[j + 1] intValue]) {
                NSNumber *numberJ = tempArray[j];
                tempArray[j] = tempArray[j + 1];
                tempArray[j + 1] = numberJ;
            }
        }
    }
}

//折半查找
- (void)binarySearch {
    const int rows = 3;
    const int cols = 4;
    int array[rows][cols] = {{1, 3, 5, 7}, {10, 11, 16, 20}, {23, 30, 34, 50}};
    for (int i = 0; i < rows; i ++) {
        NSLog(@"iiiiiiiiii%d",i);
        if (array[i][cols - 1] == 34) {
            NSLog(@"rows = %d cols = %d",i, cols);
            break;
        } else {
            int low, mid, high;
            low = 0;
            high = cols - 1;
            while (low < high) {
                mid = (low + high) / 2;
                if (array[i][mid] == 34) {
                    NSLog(@"rows = %d cols = %d",i, mid);
                    return;
                } else if (array[i][mid] < 34) {
                    low = mid + 1;
                } else {
                    high = mid - 1;
                }
                
            }
        }
    }
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
