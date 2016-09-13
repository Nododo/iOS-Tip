//
//  BinaryTree.h
//  二叉树
//
//  Created by 杜维欣 on 16/9/13.
//  Copyright © 2016年 Nododo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BinaryTreeNode.h"

@interface BinaryTree : NSObject
+ (BinaryTreeNode *)createTreeWithValues:(NSArray *)values;
+ (void)preOrderTraverseTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *treeNode))handler;
@end
