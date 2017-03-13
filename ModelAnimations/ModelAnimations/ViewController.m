//
//  ViewController.m
//  ModelAnimations
//
//  Created by MAC on 2017/3/13.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import "ViewController.h"
#import "ThirdModelAnimationVC.h"

#import "FirstPresentationController.h"
#import "FirstContentVC.h"

#import "SecondAnimationContentVC.h"
#import "SecondAnimationPresentationController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    FirstContentVC *toVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstContentVC"];
//    
//    FirstPresentationController *presentationC = [[FirstPresentationController alloc] initWithPresentedViewController:toVC presentingViewController:self];
//    toVC.transitioningDelegate = presentationC ;  // 指定自定义modal动画的代理
//    [self presentViewController:toVC animated:YES completion:nil];
    // animated必须是YES，因为此Demo1没有自己实现动画细节协议。
    
    SecondAnimationContentVC *toVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondAnimationContentVC"];
    
    SecondAnimationPresentationController *presentationC = [[SecondAnimationPresentationController alloc] initWithPresentedViewController:toVC presentingViewController:self];
    toVC.transitioningDelegate = presentationC ;  // 指定自定义modal动画的代理
    [self presentViewController:toVC animated:YES completion:nil];
    
    // 第三种使用方式(animated 要设置为NO)
//    ThirdModelAnimationVC *VC = [[ThirdModelAnimationVC alloc]init];
//    [self presentViewController:VC animated:NO completion:nil];

}

@end
