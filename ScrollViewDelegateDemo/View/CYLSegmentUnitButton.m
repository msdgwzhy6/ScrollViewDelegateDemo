//
//  CYLSegmentUnitButton.m
//  PostMenuDemo
//
//  Created by CHENYI LONG on 14-10-14.
//  Copyright (c) 2014年 CHENYI LONG. All rights reserved.
//

#define RGB(r, g, b)                        [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]


#import "CYLSegmentUnitButton.h"
#define kUIupstairsImageX 0
#define kUIupstairsImageY 0

@interface CYLSegmentUnitButton ()
@property (nonatomic,strong) UILabel *downStairsMoneyLable;
@end
@implementation CYLSegmentUnitButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.图片居中
        self.imageView.contentMode = UIViewContentModeCenter;
        // 2.文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setTitleColor:RGB(44, 195, 164) forState:UIControlStateSelected];
    }
    return self;
}

/**
 *  目的是去掉父类在高亮时所做的操作
 */
- (void)setHighlighted:(BOOL)highlighted {}
#pragma mark ----覆盖UIButton父类的两个方法,默认是上图片下文字
//https://app.yinxiang.com/shard/s22/sh/516e5ec1-a6bb-4d77-8b4c-ccb37ad4616d/1cdbba2a86bd909e51833f74c6f0792b/deep/0/重组UIButton.jpg
//#pragma mark 设置按钮图片的frame
//- (CGRect)imageRectForContentRect:(CGRect)contentRect {
//    UIImage *image = [self imageForState:UIControlStateNormal];
//    return CGRectMake(0, 0, contentRect.size.width, image.size.height + 5);
//}
//#pragma mark 设置按钮标题的frame
//- (CGRect)titleRectForContentRect:(CGRect)contentRect {
//    UIImage *image = [self imageForState:UIControlStateNormal];
//    CGFloat titleY = image.size.height;
//    CGFloat titleHeight = self.bounds.size.height - titleY;
//    return CGRectMake(0, titleY, self.bounds.size.width, titleHeight);
//}

- (void)setSegmentUnitButtonModel:(CYLSegmentUnitButtonModel *)item {
    _segmentUnitButtonModel = item;
    // 1.利用KVO监听item属性值的改变
    [item addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:NSKeyValueObservingOptionNew context:nil];
    // 2.属性赋值
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

/**
 *  KVO监听必须在监听器释放的时候，移除监听操作
 *  通知也得在释放的时候移除监听
 */
- (void)dealloc
{
    [_segmentUnitButtonModel removeObserver:self forKeyPath:@"title"];
    [_segmentUnitButtonModel removeObserver:self forKeyPath:@"image"];
    [_segmentUnitButtonModel removeObserver:self forKeyPath:@"selectedImage"];
}

/**
 *  监听item的属性值改变
 *
 *  @param keyPath 哪个属性改变了
 *  @param object  哪个对象的属性改变了
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //    MyLog(@"------%@的%@改变了", object, keyPath);
    [self setTitle:_segmentUnitButtonModel.title forState:UIControlStateNormal];
    [self setImage:_segmentUnitButtonModel.image forState:UIControlStateNormal];
    [self setImage:_segmentUnitButtonModel.selectedImage forState:UIControlStateSelected];

}




@end
