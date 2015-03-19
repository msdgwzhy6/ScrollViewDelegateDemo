//
//  CYLSegmentButtonView.h
//  PostMenuDemo
//
//  Created by CHENYI LONG on 14-10-14.
//  Copyright (c) 2014年 CHENYI LONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYLSegmentUnitButtonModel.h"
#import "CYLSegmentUnitButton.h"
@class CYLSegmentButtonView;

@protocol CYLSegmentButtonViewDelegate <NSObject>

@optional
/**
 *  segmentButtonView上面的按钮被选中了
 *
 *  @param tabBar 被点击的segmentButton
 *  @param from   原来按钮的位置
 *  @param to     新选中按钮的位置
 */
- (void)segmentButtonView:(CYLSegmentButtonView *)segmentView didSelectButtonFrom:(int)from to:(int)to;
@end



@interface CYLSegmentButtonView : UIView 
/**
 *  通过一个item对象来添加一个按钮TabBarButton
 */
- (void)addSegmentButtonWithModel:(CYLSegmentUnitButtonModel *)item;
/**
 *  代理
 */
@property (nonatomic, weak) id<CYLSegmentButtonViewDelegate> delegate;

@end
