//
//  AnimationScaleButton.h
//  AnimationScaleButtonDemo
//
//  Created by CHENYI LONG on 14-11-27.
//  Copyright (c) 2014年 CHENYI LONG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AnimationScaleButton;
@protocol AnimationScaleButtonDelegate <NSObject>
@optional
-(void)animationScaleButtonClicked:(id)sender;
@end

#import "CYLCommonViewDistinguishTool.h"
kDistinguishSuccessBlock(UIView)

@interface AnimationScaleButton : UIView
@property (nonatomic, weak) id<AnimationScaleButtonDelegate> delegate;
@property (nonatomic, copy) NSString *normalStateImageName;
@property (nonatomic, copy) NSString *highlightedStateImageName;
@property (nonatomic, copy) NSString *selectedStateImageName;
@property (nonatomic, copy) NSString *normalStateBgImageName;
@property (nonatomic, copy) NSString *highlightedStateBgImageName;
@property (nonatomic, copy) NSString *selectedStateBgImageName;
@property (nonatomic, assign) BOOL playAnimation;
@property (nonatomic, assign) BOOL isPlaying;

kDistinguishUIProperty(UIView)
/**
 *  初始化动画按钮
 *
 *  @param buttonImage     用于放大的按钮
 *  @param backgroundImage 纯色背景图片
 *  @param repeatCount     重复次数,默认为无穷大,赋值为0,或者赋值为nil,NULL皆是无穷大
 */
- (void)initWithAnimationScaleButtonImage:(NSString *)buttonImage withBackgroundImage:(NSString *)backgroundImage withRepeatCount:(NSInteger)repeatCount;
@end
