//
//  AnimationScaleButton.m
//  AnimationScaleButtonDemo
//
//  Created by CHENYI LONG on 14-11-27.
//  Copyright (c) 2014年 CHENYI LONG. All rights reserved.
//

#define kBackgroundImageCenterForUIView(ViewName,imageName)\
UIGraphicsBeginImageContext(self.frame.size);\
[[UIImage imageNamed:imageName] drawInRect:ViewName.bounds];\
ViewName.backgroundColor = [UIColor colorWithPatternImage:UIGraphicsGetImageFromCurrentImageContext()];\
UIGraphicsEndImageContext();\

#define kScaleViewGestureViewAlphaHighlighted 1
#define kScaleViewGestureViewAlphaNormal 1
#define kBackgroundGestureViewAlphaHighlighted 0.4
#define kBackgroundGestureViewAlphaNormal 1

#import "AnimationScaleButton.h"

@interface AnimationScaleButton() {
    CAAnimationGroup *_group;
}
@property (nonatomic, strong) UIView *animationScaleButton;
@property (nonatomic, assign) NSInteger repeatCount;

@end
@implementation AnimationScaleButton
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self setupBackgroundNotification];
        self.playAnimation = YES;
        [self addObserver:self forKeyPath:@"playAnimation" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}


- (void)setupBackgroundNotification {
    //页面将要进入前台，开启定时器
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActiveNotification)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    //页面消失，进入后台不显示该页面，关闭定时器
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackgroundNotification)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)applicationDidEnterBackgroundNotification {
    if(self.playAnimation) {
        [self pauseAnimate:nil];
    }
}

- (void)applicationDidBecomeActiveNotification {
    if(self.playAnimation) {
        [self startAnimate:nil];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"playAnimation"]) {
        if(!self.playAnimation) {[self pauseAnimate:nil];}
        if(self.playAnimation) {[self startAnimate:nil];}
    }
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:Nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:Nil];
    [self removeObserver:self forKeyPath:@"playAnimation"];
    
    [self stopAnimate];
}

- (void)initWithAnimationScaleButtonImage:(NSString *)buttonImage withBackgroundImage:(NSString *)backgroundImage withRepeatCount:(NSInteger)repeatCount {
    if (repeatCount&&(repeatCount != 0)) {
        self.repeatCount = repeatCount;
    } else {
        self.repeatCount = MAXFLOAT;
    }
    self.normalStateImageName = buttonImage;
    self.normalStateBgImageName = backgroundImage;
    [self setupBackgroundImage:backgroundImage];
    [self setupAnimationScaleButtonImage:buttonImage];
}

- (void)setupAnimationScaleButtonImage:(NSString *)buttonImage {
    self.animationScaleButton = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    kBackgroundImageCenterForUIView(self.animationScaleButton, buttonImage);
    [self addSubview:self.animationScaleButton];
    if(self.playAnimation) {[self monBtnIn];}
}

- (void)setupBackgroundImage:(NSString *)backgroundImage {
    _animationScaleButton.layer.cornerRadius = self.frame.size.width/2;
    kBackgroundImageCenterForUIView(self, backgroundImage);
    //添加手势
    UILongPressGestureRecognizer *longPressUIanimationScaleButtonBackground = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressUIanimationScaleButtonBackground:)];
    [longPressUIanimationScaleButtonBackground setMinimumPressDuration:0.001];
    [self addGestureRecognizer:longPressUIanimationScaleButtonBackground];
}

- (void)longPressUIanimationScaleButtonBackground:(UILongPressGestureRecognizer*)gesture {
    //手势开始时,设置背景为类似UIButton的高亮状态
    if ( gesture.state == UIGestureRecognizerStateBegan ){
        //如果没有设置背景的高亮图片,就默认做透明度处理
        if (self.highlightedStateBgImageName.length == 0) {
            kBackgroundImageCenterForUIView(self, self.normalStateBgImageName);
            self.alpha = kBackgroundGestureViewAlphaHighlighted;
        }
        //如果设置了背景的高亮图片,就默认做透明度处理
        else {
            kBackgroundImageCenterForUIView(self, self.highlightedStateBgImageName);
        }
        
        if (self.highlightedStateImageName.length == 0) {
            _animationScaleButton.alpha = kScaleViewGestureViewAlphaHighlighted;
        } else {
            kBackgroundImageCenterForUIView(_animationScaleButton, self.highlightedStateImageName);
        }
    }
    
    //手势结束时,设置背景为类似UIButton的Normal状态,并执行类似UIButton的如下方法
    //[button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        
        kBackgroundImageCenterForUIView(self, self.normalStateBgImageName);
        kBackgroundImageCenterForUIView(_animationScaleButton, self.normalStateImageName);
        
        _animationScaleButton.alpha = kScaleViewGestureViewAlphaNormal;
        self.alpha = kBackgroundGestureViewAlphaNormal;
        [self animationScaleButtonBackgroundClicked:nil];
        //NSLog(@"Long Press");
    }
}

- (void)animationScaleButtonBackgroundClicked:(id)sender {
    if([self.delegate respondsToSelector:@selector(animationScaleButtonClicked:)]) {
        [self.delegate animationScaleButtonClicked:sender];
    }
}

- (CAAnimation*)monInAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 0.5)];
    [animation setDuration:1.5];
    [animation setAutoreverses:YES];
    return animation;
}

- (void)monBtnIn
{
    _group = [CAAnimationGroup animation];
    _group.duration = 1.5;
    _group.repeatCount = self.repeatCount;
    _group.autoreverses = YES;
    _group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _group.animations = [NSArray arrayWithObjects:[self monInAnimation],nil];
    _group.fillMode = kCAFillModeForwards;
    _group.removedOnCompletion = NO;
    [self startAnimate:nil];
}


kDistinguishFromAllFathers(UIView);
/**
 *  //开始动画
 *
 */
- (void)startAnimate:(id)sender {
    if (!_isPlaying) {
        _isPlaying = YES;
        [self distinguishUIViewFromFatherUI:self distinguishSuccess:^(UIView *view) {
            if ([[view.layer animationKeys] count] == 0)
                [view.layer addAnimation:_group forKey:@"allMyAnimations"];
            view.layer.speed = 1.0;
            view.layer.beginTime = 0.0;
            CFTimeInterval pausedTime = [view.layer timeOffset];
            CFTimeInterval timeSincePause = [view.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
            view.layer.beginTime = timeSincePause;
        }];
    }
}
/**
 *  暂停动画
 *
 */
- (void)pauseAnimate:(id)sender {
    if (_isPlaying) {
        _isPlaying = NO;
        [self distinguishUIViewFromFatherUI:self distinguishSuccess:^(UIView *view) {
            CFTimeInterval pausedTime = [view.layer convertTime:CACurrentMediaTime() fromLayer:nil];
            view.layer.speed = 0.0;
            view.layer.timeOffset = pausedTime;
        }];
    }
}

/**
 *  彻底结束动画
 */
- (void)stopAnimate {
    [self distinguishUIViewFromFatherUI:self distinguishSuccess:^(UIView *view) {
        if ([[view.layer animationKeys] count] == 0) {
            [view.layer removeAllAnimations];
        }
    }];
}
@end
