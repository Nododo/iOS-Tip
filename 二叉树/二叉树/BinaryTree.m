//
//  BinaryTree.m
//  二叉树
//
//  Created by 杜维欣 on 16/9/13.
//  Copyright © 2016年 Nododo. All rights reserved.
//

#import "BinaryTree.h"

@implementation BinaryTree
+ (BinaryTreeNode *)createTreeWithValues:(NSArray *)values {
    
    BinaryTreeNode *root = nil;
    for (NSInteger i=0; i<values.count; i++) {
        NSInteger value = [(NSNumber *)[values objectAtIndex:i] integerValue];
        root = [BinaryTree addTreeNode:root value:value];
    }
    return root;
}

+ (BinaryTreeNode *)addTreeNode:(BinaryTreeNode *)treeNode value:(NSInteger)value {
    //根节点不存在，创建节点
    if (!treeNode) {
        treeNode = [BinaryTreeNode new];
        treeNode.value = value;
        NSLog(@"node:%@", @(value));
    }
    else if (value <= treeNode.value) {
        NSLog(@"to left");
        //值小于根节点，则插入到左子树
        treeNode.leftNode = [BinaryTree addTreeNode:treeNode.leftNode value:value];
    }
    else {
        NSLog(@"to right");
        //值大于根节点，则插入到右子树
        treeNode.rightNode = [BinaryTree addTreeNode:treeNode.rightNode value:value];
    }
    
    return treeNode;
}

+ (void)preOrderTraverseTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *treeNode))handler {
    if (rootNode) {
//        NSLog(@"====%ld====",rootNode.value);
        if (handler) {
            handler(rootNode);
        }
        
        [self preOrderTraverseTree:rootNode.leftNode handler:handler];
//        NSLog(@"left====%ld====",rootNode.leftNode.value);
        [self preOrderTraverseTree:rootNode.rightNode handler:handler];
//        NSLog(@"right====%ld====",rootNode.rightNode.value);
    }
}

@end
