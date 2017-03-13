//
//  SecondAnimationPresentationController.m
//  ModelAnimations
//
//  Created by MAC on 2017/3/13.
//  Copyright © 2017年 MAC. All rights reserved.
//

/**
 * 1.遵守UIViewControllerTransitioningDelegate
 
 // 2.
 func presentationTransitionWillBegin()          跳转将要开始
 func presentationTransitionDidEnd(completed: Bool)  跳转完成
 func dismissalTransitionWillBegin()         dismiss将要开始
 func dismissalTransitionDidEnd(completed: Bool)     dismiss完成
 func frameOfPresentedViewInContainerView()    动画之后，目标控制器View的位置
 */

#import "SecondAnimationPresentationController.h"

static const CGFloat KcontentView = 300.f;

@interface SecondAnimationPresentationController ()<UIViewControllerTransitioningDelegate>

// 黑色半透明背景
@property (nonatomic, strong) UIButton *bgBtn;

@end

@implementation SecondAnimationPresentationController

#pragma mark - lazy load
- (UIButton *) bgBtn {
    if (! _bgBtn) {
        UIButton *tempBGBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tempBGBtn.frame = self.containerView.bounds;
        tempBGBtn.opaque = NO; // 不设置透明
        tempBGBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tempBGBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        tempBGBtn.alpha = 0.0f;
        [tempBGBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _bgBtn = tempBGBtn;
    }
    return _bgBtn;
}

#pragma mark - UIViewControllerTransitioningDelegate
/*
 * 来告诉控制器，谁是动画主管(UIPresentationController)，因为此类继承了UIPresentationController，就返回了self
 */
- (UIPresentationController* )presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source {
    return self;
}

// 以下两个方法不去实现，即：使用系统默认的 Presented 动画效果，就是从下而上的效果。
// 由于我们没有指定具体动画的效果类，所以第三步也就不用去实现。

// 返回的对象控制Presented时的动画 (开始动画的具体细节负责类)
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//{
//    return nil;
//}
// 由返回的控制器控制dismissed时的动画 (结束动画的具体细节负责类)
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
//{
//    return nil;
//}

#pragma mark - 重写UIPresentationController个别方法
/*
    presentedViewController:     要 modal 显示的视图控制器
    presentingViewController:    跳转前视图控制器
    containerView()              容器视图
    presentedView()              被展现控制器的视图
*/
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if (self) {
        // 必须设置 presentedViewController 的 modalPresentationStyle
        // 在自定义动画效果的情况下，苹果强烈建议设置为 UIModalPresentationCustom
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    return self;
}

// 呈现过渡即将开始的时候被调用的
// 可以在此方法创建和设置自定义动画所需的view
- (void)presentationTransitionWillBegin {
    
    [self.containerView addSubview:self.bgBtn];
    // 获取presentingViewController 的转换协调器，应该动画期间的一个类？上下文？之类的，负责动画的一个东西
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    // 动画期间，背景View的动画方式
    self.bgBtn.alpha = 0.f;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.bgBtn.alpha = 0.5f;
    } completion:NULL];
}

// 在呈现过渡结束时被调用的，并且该方法提供一个布尔变量来判断过渡效果是否完成
- (void)presentationTransitionDidEnd:(BOOL)completed {
    // 在取消动画的情况下，可能为NO，这种情况下，应该取消视图的引用，防止视图没有释放
    if (!completed){
        self.bgBtn = nil;
    }
}

// 消失过渡即将开始的时候被调用的
- (void)dismissalTransitionWillBegin {
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.bgBtn.alpha = 0.f;
    } completion:nil];
}

// 消失过渡完成之后调用，此时应该将视图移除，防止强引用
- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [self.bgBtn removeFromSuperview];
        self.bgBtn = nil;
    }
}

// 返回目标控制器Viewframe
- (CGRect)frameOfPresentedViewInContainerView {
    // 这里直接按照想要的大小写死，其实这样写不好，在第二个Demo里，我们将按照苹果官方Demo，写灵活的获取方式。
    CGFloat height = KcontentView;
    CGRect containerViewBounds = self.containerView.bounds;
    containerViewBounds.origin.y = containerViewBounds.size.height - height;
    containerViewBounds.size.height = height;
    return containerViewBounds;
}

//  This method is invoked whenever the presentedViewController's
//  preferredContentSize property changes.  It is also invoked just before the
//  presentation transition begins (prior to -presentationTransitionWillBegin).
//  建议就这样重写就行，这个应该是控制器内容大小变化时，就会调用这个方法， 比如适配横竖屏幕时，翻转屏幕时
//  可以使用UIContentContainer的方法来调整任何子视图控制器的大小或位置。
- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    
    if (container == self.presentedViewController) {
        [self.containerView setNeedsLayout];
    }
}

//| ----------------------------------------------------------------------------
//  This method is similar to the -viewWillLayoutSubviews method in
//  UIViewController.  It allows the presentation controller to alter the
//  layout of any custom views it manages.
//
- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
    self.bgBtn.frame = self.containerView.bounds;
}


#pragma mark - button Action
- (void) bgBtnClick:(UIButton *) btn {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
