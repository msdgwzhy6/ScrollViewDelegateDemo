//
//  CYLSegmentButtonView.m
//  PostMenuDemo
//
//  Created by CHENYI LONG on 14-10-14.
//  Copyright (c) 2014年 CHENYI LONG. All rights reserved.
//
#import "CYLSegmentButtonView.h"

#import "CYLSegmentUnitButton.h"

@interface CYLSegmentButtonView()  {
    CYLSegmentUnitButton *_selectedAdditionMoneyUnitView;
    int _segmentUnitButtonCount;
}
@end

@implementation CYLSegmentButtonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)addSegmentButtonWithModel:(CYLSegmentUnitButtonModel *)item
{
    // 0.最多添加4个
    if (_segmentUnitButtonCount >= 4) return;
    
    // 1.创建按钮
    CYLSegmentUnitButton *btn = [[CYLSegmentUnitButton alloc] init];
    // 2.设置frame
    CGFloat btnH = self.frame.size.height;
    CGFloat btnW = self.frame.size.width / 4;
    CGFloat btnX = btnW * _segmentUnitButtonCount;
    btn.frame = CGRectMake(btnX, 0, btnW, btnH);
    // 3.设置图片和文字
    btn.segmentUnitButtonModel = item;
    // 4.监听点击
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    
    // 5.默认让第0个按钮选中
    btn.tag = _segmentUnitButtonCount;
    if (_segmentUnitButtonCount == 0) {
        [self btnClick:btn];
    }
    //    btn.backgroundColor = [self randomColor];
    [self addSubview:btn];
    _segmentUnitButtonCount++;
}



/**
 *  监听IWTabBarButton点击
 *
 *  @param btn 被点击的tabbarButton
 */
- (void)btnClick:(CYLSegmentUnitButton *)btn
{
    // 0.通知代理
    if ([self.delegate respondsToSelector:@selector(segmentButtonView:didSelectButtonFrom:to:)]) {
        int from = -1;
        if (_selectedAdditionMoneyUnitView) {
            from = (int)_selectedAdditionMoneyUnitView.tag;
        }
        NSLog(@"- (void)btnClick中to的值是%d",(int)(btn.tag));
        [self.delegate segmentButtonView:self didSelectButtonFrom:from to:(int)(btn.tag)];
    }
    
    // 1.控制器选中按钮,_selectedAdditionMoneyUnitView的selected属性是受到监听的.
    _selectedAdditionMoneyUnitView.selected = NO;
    btn.selected = YES;
    _selectedAdditionMoneyUnitView = btn;
}


@end
