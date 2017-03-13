//
//  ThirdModelAnimationVC.m
//  ModelAnimations
//
//  Created by MAC on 2017/3/13.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import "ThirdModelAnimationVC.h"


static const CGFloat KcontentViewH = 300.0f;

@interface ThirdModelAnimationVC ()

/** 背景 */
@property (nonatomic, strong) UIButton *bgBtn;
/** 内容View */
@property (nonatomic, strong) UIView *contentView;

@end

@implementation ThirdModelAnimationVC

#pragma mark - lazy load

- (UIButton *) bgBtn {
    if (! _bgBtn) {
        UIButton *tempBGBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tempBGBtn.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.5f];
        tempBGBtn.alpha = 0.0f;
        [tempBGBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _bgBtn = tempBGBtn;
    }
    return _bgBtn;
}

- (UIView *)contentView {
    if (! _contentView) {
        UIView *tempView = [[UIView alloc]init];
        tempView.backgroundColor = [UIColor whiteColor];
        _contentView = tempView;
    }
    return _contentView;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initConfig];
        [self setupUI];
    }
    return self;
}

#pragma mark - lift cycle
#pragma mark - 在此方法做动画呈现
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.bgBtn.frame = [UIScreen mainScreen].bounds;
    self.contentView.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height, CGRectGetWidth([UIScreen mainScreen].bounds), KcontentViewH);
    
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.bgBtn.alpha = 1.0f ;
        
        self.contentView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - KcontentViewH, CGRectGetWidth([UIScreen mainScreen].bounds), KcontentViewH);
        
    } completion:^(BOOL finished) {
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - private Methods
- (void) initConfig {
    self.view.backgroundColor = [UIColor clearColor];
    // 必须加上这句话，不然看不到上一个控制器的View
    self.modalPresentationStyle = UIModalPresentationCustom;
}

- (void) setupUI {
    [self.view addSubview:self.bgBtn];
    [self.view addSubview:self.contentView];
    [self setupContentView];
}

- (void) setupContentView {
    
    // 1.可以通过xib加载
//    UIView *view = [[NSBundle mainBundle] loadNibNamed:@"LabelView" owner:nil options:nil].lastObject;
//    //view.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:view];
//    view.frame = self.contentView.frame;
    
    // 2.直接添加控件
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
    lab.frame = CGRectMake(10.f, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 20.f, KcontentViewH);
    lab.text = @"在此View上添加自己的具体实现，通过viewWillAppear和clickBgVie，可以自定义出很绚的动画效果，这种动画方式只是给大家提供一种思路，实现问题的方法有很多，有时候很多效果感觉很难实现，也许它用了一些障眼法之类的。我比较喜欢投机取巧的方式实现一些效果的，不过对于新技术，还是要积极去学习的，本Demo没有使用Swift，但是代码注释很详细，Swift对应方法和步骤敲出来即可！欢迎点赞。";
    lab.numberOfLines = 0 ;
    lab.font = [UIFont systemFontOfSize:16.f];
    [self.contentView addSubview:lab];

}

#pragma mark - Button Actions
- (void) bgBtnClick:(UIButton *) btn {
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.bgBtn.alpha = 0.0f ;
        self.contentView.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height, CGRectGetWidth([UIScreen mainScreen].bounds), KcontentViewH);
        
    } completion:^(BOOL finished) {
        // 动画Animated必须是NO，不然消失之后，会有0.35s时间，再点击无效
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

// 这里主动释放一些空间，加速内存的释放，防止有时候消失之后，再点不出来。
- (void)dealloc {
    NSLog(@"%@ --> dealloc",[self class]);
    [self.bgBtn removeFromSuperview];
    self.bgBtn = nil;
    [self.contentView removeFromSuperview];
    self.contentView = nil;
}

@end
