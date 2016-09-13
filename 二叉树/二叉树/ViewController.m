//
//  ViewController.m
//  二叉树
//
//  Created by 杜维欣 on 16/9/13.
//  Copyright © 2016年 Nododo. All rights reserved.
//

#import "ViewController.h"
#import "BinaryTree.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    BinaryTreeNode *node =  [BinaryTree createTreeWithValues:@[@1,@3,@5,@7,@22,@32]];
    [BinaryTree preOrderTraverseTree:node handler:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
