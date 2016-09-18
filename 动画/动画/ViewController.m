//
//  ViewController.m
//  动画
//
//  Created by 杜维欣 on 16/9/18.
//  Copyright © 2016年 Nododo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIView *blueView;

@end

static dispatch_semaphore_t semaphore ;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self differentViewWithMultiAnimationsOneByOne];
//    [self oneViewWithMultiAnimationsOneByOne];
}

- (void)differentViewWithMultiAnimationsOneByOne {
    CABasicAnimation *horAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    horAnimation.fromValue = @(CGRectGetMidX(self.redView.frame));
    horAnimation.toValue = @300;
    horAnimation.duration = 2;
    horAnimation.removedOnCompletion = NO;
    horAnimation.fillMode = kCAFillModeForwards;
    horAnimation.delegate = self;
    [self.redView.layer addAnimation:horAnimation forKey:nil];
    
    CABasicAnimation *verAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    verAnimation.fromValue = @(CGRectGetMidY(self.blueView.frame));
    verAnimation.toValue = @500;
    verAnimation.duration = 2;
    verAnimation.removedOnCompletion = NO;
    verAnimation.fillMode = kCAFillModeForwards;
    //如果不是在group内  必须要用CACurrentMediaTime
    verAnimation.beginTime = CACurrentMediaTime() + 2;
    [self.blueView.layer addAnimation:verAnimation forKey:nil];
}

- (void)animationDidStart:(CAAnimation *)anim {
    NSLog(@"begin red = %@, begin blue = %@",NSStringFromCGRect(self.redView.frame),NSStringFromCGRect(self.blueView.frame));
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"end red = %@, end blue = %@",NSStringFromCGRect(self.redView.frame),NSStringFromCGRect(self.blueView.frame));
}

//单个试图一个接一个播放动画
- (void)oneViewWithMultiAnimationsOneByOne {
    CABasicAnimation *horAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    horAnimation.fromValue = @(CGRectGetMidX(self.redView.frame));
    horAnimation.toValue = @300;
    horAnimation.duration = 2;
    horAnimation.removedOnCompletion = NO;
    horAnimation.fillMode = kCAFillModeForwards;
    
    
    CABasicAnimation *verAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    verAnimation.fromValue = @(CGRectGetMidY(self.redView.frame));
    verAnimation.toValue = @300;
    verAnimation.duration = 2;
    verAnimation.beginTime = 2;
    verAnimation.removedOnCompletion = NO;
    verAnimation.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.fromValue = @0;
    rotateAnimation.toValue = @(2 * M_PI);
    rotateAnimation.duration = 0.3;
    rotateAnimation.beginTime = 4;
    //当前动画的结束时下个动画的开始
//    rotateAnimation.cumulative = YES;
    rotateAnimation.repeatCount = CGFLOAT_MAX;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    //每个动画设置后 组动画可以不用设置以下属性
    //    group.removedOnCompletion = NO;
    //    group.fillMode = kCAFillModeForwards;
    //这个时间决定动画的时间长度  每个子动画的时间如果小于此时间 不受影响  如果大于则此时间后动画结束
    group.duration = CGFLOAT_MAX;
    group.animations = @[horAnimation, verAnimation, rotateAnimation];
    [self.redView.layer addAnimation:group forKey:nil];
}
@end
