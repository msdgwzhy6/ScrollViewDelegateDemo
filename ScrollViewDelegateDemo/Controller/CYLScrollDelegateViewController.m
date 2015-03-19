//
//  CYLScrollDelegateViewController.m
//  ScrollViewDelegateDemo
//
//  Created by CHENYI LONG on 14-11-24.
//  Copyright (c) 2014年 CHENYI LONG. All rights reserved.
//
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define IS_IOS7 (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")&&SYSTEM_VERSION_LESS_THAN(@"8.0"))

#define UI_SCREEN_WIDTH                 ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#import "UIImage+ResizeImg.h"
#define kBackgroundImageResizedForView(ViewName,imageName)\
UIImage *highlightedBgImage = [UIImage resizedImage:imageName];\
ViewName.backgroundColor = [UIColor colorWithPatternImage:highlightedBgImage];

#define kBackgroundImageCenterForUIControllerView(ViewName,imageName)\
UIGraphicsBeginImageContext(self.view.frame.size);\
[[UIImage imageNamed:imageName] drawInRect:ViewName.bounds];\
ViewName.backgroundColor = [UIColor colorWithPatternImage:UIGraphicsGetImageFromCurrentImageContext()];\
UIGraphicsEndImageContext();\


/**
 *  使用Layout进行iOS7适配,此方法适用于有导航条且视图是UIViewController
 */
#define CYLAdaptationIOS7AndIOS6UseLayoutWhenNavigationAndUIViewController \
- (void)viewWillLayoutSubviews\
{\
if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {\
CGFloat top = [self.topLayoutGuide length];\
CGRect bounds = self.view.bounds;\
bounds.origin.y = -top;\
self.view.bounds = bounds;\
}\
}\
- (void)viewWillAppear:(BOOL)animated\
{\
[super viewWillAppear:YES];\
if (IS_IOS7) {\
self.edgesForExtendedLayout = UIRectEdgeNone;\
}\
}
#define RGB(r, g, b)                        [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

#define kSearchBarHeight 50
#define kAlphaLevel 0.1
#define kScrollViewMaxOffSet 320

#define kSearchBarMaxOffSet 50
#define kSearchBarMaxValue 0
#define kSearchBarMinValue -50

#define kSegmentButtonViewMinValue 0
#define kSegmentButtonViewMaxValue kSearchBarHeight
#define kAlphaMaxValue 1
#define kAlphaMinValue 0
#define kAlphaMaxChangedValue 1

#define kUIleftAnimationScaleButtonX -50
#define kUIleftAnimationScaleButtonY 0
#define kUIleftAnimationScaleButtonWidth 50
#define kUIleftAnimationScaleButtonHeight 50


#define kUIrightAnimationScaleButtonX UI_SCREEN_WIDTH
#define kUIrightAnimationScaleButtonY 0
#define kUIrightAnimationScaleButtonWidth 50
#define kUIrightAnimationScaleButtonHeight 50

#define kUIrightAnimationScaleButtonXMaxOffSet 50
#define kUIrightAnimationScaleButtonXMinValue UI_SCREEN_WIDTH -50
#define kUIrightAnimationScaleButtonXMaxValue UI_SCREEN_WIDTH

#define kUIleftAnimationScaleButtonXMaxOffSet 50
#define kUIleftAnimationScaleButtonXMinValue -50
#define kUIleftAnimationScaleButtonXMaxValue 0

#define kUIAnimationScaleButtonXMaxOffSet 50



typedef enum {
    ColorViewBgYellowColor = kAlphaMaxValue,
    ColorViewBgBlueColor   = kAlphaMinValue,
} ColorViewBg;

#import "CYLScrollDelegateViewController.h"
#import "CYLSegmentButtonView.h"
#import "CYLSegmentUnitButton.h"
#import "CYLCommonViewProgramTool.h"
#import "AnimationScaleButton.h"

@interface CYLScrollDelegateViewController ()<UIScrollViewDelegate,CYLSegmentButtonViewDelegate,AnimationScaleButtonDelegate>

{
    float _alpha;
    BOOL _isUpDecelerating;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, strong) UIView *searchBar;
@property (nonatomic, strong)     CYLSegmentButtonView *segmentButtonView;
@property (nonatomic, strong) AnimationScaleButton *leftAnimationScaleButton;
@property (nonatomic, strong) AnimationScaleButton *rightAnimationScaleButton;

@end

@implementation CYLScrollDelegateViewController
CYLAdaptationIOS7AndIOS6UseLayoutWhenNavigationAndUIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
self.view.backgroundColor = RGB(35, 37, 43);
//    self.view.backgroundColor = [UIColor redColor];
    [self setupSearchBar];
    [self setupScrollView];
    //[self setupColorView];
    [self setupSegmentView];
    [self setupSendSNSCodeButton];
}

- (void)setupColorView {
    self.colorView = [[UIView alloc] init];
    self.colorView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 100);
    self.colorView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.colorView];
}
#pragma mark - ╭╮
#pragma mark - 设置SegmentView

/**
 *  添加一个自定义的红包segment
 */
- (void)setupSegmentView
{
    CGRect additionMoneyViewSegmentViewFrame =  CGRectMake(0, ViewHeight(self.searchBar), UI_SCREEN_WIDTH, 50);
    CYLSegmentButtonView *customSegmentView = [[CYLSegmentButtonView alloc] initWithFrame:additionMoneyViewSegmentViewFrame];
    kBackgroundImageResizedForView(customSegmentView,@"TabSelected");
    _segmentButtonView = customSegmentView;
    _segmentButtonView.delegate = self;
    [self addAllAdditionMoneyViewSegmentView];
    [self.view addSubview:customSegmentView];
}

/**
 *  添加所有的子控制器
 */
- (void)addAllAdditionMoneyViewSegmentView
{
    [self addSegmentButtonWithtitle:@"充电" image:@"tab_icon_charge" selectedImage:@"tab_icon_charge_selected"];
    [self addSegmentButtonWithtitle:@"加速" image:@"tab_icon_clear" selectedImage:@"tab_icon_clear_selected"];
    [self addSegmentButtonWithtitle:@"诊断" image:@"tab_icon_maintenance" selectedImage:@"tab_icon_maintenance_selected"];
    [self addSegmentButtonWithtitle:@"排行" image:@"tab_icon_market" selectedImage:@"tab_icon_market_selected"];
}

- (void)addSegmentButtonWithtitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    // 1.设置标题和图标
    CYLSegmentUnitButtonModel *item = [[CYLSegmentUnitButtonModel alloc] init];
    item.title = title;
    item.image = [UIImage imageNamed:image];
    UIImage *selected = [UIImage imageNamed:selectedImage];
    // 如果是iOS7以上，不要渲染选中的图片
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        item.selectedImage = selected;
    } else {
        item.selectedImage = [selected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    [_segmentButtonView addSegmentButtonWithModel:item];
}
#pragma mark - ╰╯
#pragma mark - ╭╮
#pragma mark - 设置UISCrollView

- (void)setupScrollView {
    _alpha = ColorViewBgYellowColor;
    CGRect scrollViewFrame = CGRectMake(0, 100, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = scrollViewFrame;
    kBackgroundImageResizedForView(self.scrollView, @"scrollViewBg");
    [self.scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT* 3)];
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    //    self.scrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.scrollView];
}
- (void)setupSearchBar {
    CGRect searchBarFrame = CGRectMake(0, 0, UI_SCREEN_WIDTH, kSearchBarHeight);
    self.searchBar = [[UIView alloc] init];
    self.searchBar.frame = searchBarFrame;
    kBackgroundImageResizedForView(self.searchBar, @"searchBar");
    
    //    self.searchBar.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.searchBar];
}

#pragma mark - ╰╯
#pragma mark - ╭╮
#pragma mark -



- (void)setupSendSNSCodeButton {
    
    CGRect leftAnimationScaleButtonFrame = CGRectMake(kUIleftAnimationScaleButtonX,kUIleftAnimationScaleButtonY,kUIleftAnimationScaleButtonWidth,kUIleftAnimationScaleButtonHeight);
    _leftAnimationScaleButton = [[AnimationScaleButton alloc] initWithFrame:leftAnimationScaleButtonFrame];
    [_leftAnimationScaleButton
     initWithAnimationScaleButtonImage:@"function_activity-" withBackgroundImage:@"function_activity" withRepeatCount:0];

    _leftAnimationScaleButton.delegate = self;
    _leftAnimationScaleButton.playAnimation = YES;
    [self.view addSubview:_leftAnimationScaleButton];
    
    CGRect rightAnimationScaleButtonFrame = CGRectMake(kUIrightAnimationScaleButtonX,kUIrightAnimationScaleButtonY,kUIrightAnimationScaleButtonWidth,kUIrightAnimationScaleButtonHeight);
    _rightAnimationScaleButton = [[AnimationScaleButton alloc] initWithFrame:rightAnimationScaleButtonFrame];

    [_rightAnimationScaleButton
     initWithAnimationScaleButtonImage:@"function_apps-" withBackgroundImage:@"function_apps" withRepeatCount:0];
//    _rightAnimationScaleButton.
    _rightAnimationScaleButton.playAnimation = YES;

    [self.view addSubview:_rightAnimationScaleButton];

}

- (void)snsCodeCountdownButtonClicked {
    NSLog(@"发送验证码");
}

#pragma mark - ╭╮
#pragma mark -

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //NSLog(@"scrollViewWillBeginDragging");
}

- (void)upLevel:(float)levelMultiple {
    //
    if (_alpha > kAlphaMaxValue || _alpha == kAlphaMaxValue)
    {_alpha = ColorViewBgYellowColor; }
    else
    {
        _alpha = _alpha + fabsf(levelMultiple);
    }
    //searchBar----------------------
    if (ViewY(self.searchBar) < kSearchBarMaxValue || ViewY(self.searchBar) == kSearchBarMaxValue) {
        RectMakeSetY(self.searchBar, ViewY(self.searchBar)- levelMultiple*kSearchBarMaxOffSet);
        self.searchBar.alpha = _alpha;
    }
    //segmentView----------------------
    if (ViewY(self.segmentButtonView) < kSegmentButtonViewMaxValue || ViewY(self.segmentButtonView) == kSegmentButtonViewMaxValue) {
        RectMakeSetY(self.segmentButtonView, ViewY(self.segmentButtonView) - levelMultiple*kSearchBarMaxOffSet);
        RectMakeSetY(self.scrollView, ViewY(self.scrollView)- levelMultiple*kSearchBarMaxOffSet);
    }
    //hiddenView----------------------
    if (ViewX(self.leftAnimationScaleButton) < kUIleftAnimationScaleButtonXMinValue || ViewX(self.leftAnimationScaleButton) == kUIleftAnimationScaleButtonXMinValue) {
        RectMakeSetX(self.leftAnimationScaleButton, kUIleftAnimationScaleButtonXMinValue);
    }else{
        RectMakeSetX(self.leftAnimationScaleButton, ViewX(self.leftAnimationScaleButton) - fabsf(levelMultiple*kUIAnimationScaleButtonXMaxOffSet));
    }
    
    if (ViewX(self.rightAnimationScaleButton) > kUIrightAnimationScaleButtonXMaxValue || ViewX(self.rightAnimationScaleButton) == kUIrightAnimationScaleButtonXMaxValue) {
        RectMakeSetX(self.rightAnimationScaleButton, kUIrightAnimationScaleButtonXMaxValue)
    }else{
        RectMakeSetX(self.rightAnimationScaleButton, ViewX(self.rightAnimationScaleButton) + fabsf(levelMultiple*kUIAnimationScaleButtonXMaxOffSet));
    }
    
}

- (void)downLevel:(float)levelMultiple {
    if (_alpha < kAlphaMinValue || _alpha == kAlphaMinValue)
    {_alpha = ColorViewBgBlueColor;}
    else
    {
        _alpha = _alpha - fabsf(levelMultiple);
    }
    //searchBar----------------------
    if (ViewY(self.searchBar) > kSearchBarMinValue || ViewY(self.searchBar) == kSearchBarMinValue) {
        RectMakeSetY(self.searchBar, ViewY(self.searchBar)- levelMultiple*kSearchBarMaxOffSet);
        //        RectMakeSetY(self.segmentButtonView, ViewY(self.segmentButtonView)- levelMultiple*kSearchBarMaxOffSet);
        //        RectMakeSetY(self.scrollView, ViewY(self.scrollView)- levelMultiple*kSearchBarMaxOffSet);
        self.searchBar.alpha = _alpha;
    }
    //segmentView----------------------
    if (ViewY(self.segmentButtonView) > kSegmentButtonViewMinValue || ViewY(self.segmentButtonView) == kSegmentButtonViewMinValue) {
        RectMakeSetY(self.segmentButtonView, ViewY(self.segmentButtonView)- levelMultiple*kSearchBarMaxOffSet);
        RectMakeSetY(self.scrollView, ViewY(self.scrollView)- levelMultiple*kSearchBarMaxOffSet);
    }
    //hiddenView----------------------
    if (ViewX(self.leftAnimationScaleButton) > kUIleftAnimationScaleButtonXMaxValue || ViewX(self.rightAnimationScaleButton) == kUIleftAnimationScaleButtonXMaxValue) {
        RectMakeSetX(self.leftAnimationScaleButton, kUIleftAnimationScaleButtonXMaxValue)
    }else{
        RectMakeSetX(self.leftAnimationScaleButton, ViewX(self.leftAnimationScaleButton) + fabsf(levelMultiple*kUIAnimationScaleButtonXMaxOffSet));
    }
    
    if (ViewX(self.rightAnimationScaleButton) < kUIrightAnimationScaleButtonXMinValue || ViewX(self.rightAnimationScaleButton) == kUIrightAnimationScaleButtonXMinValue) {
        RectMakeSetX(self.rightAnimationScaleButton, kUIrightAnimationScaleButtonXMinValue);
    }else{
        RectMakeSetX(self.rightAnimationScaleButton, ViewX(self.rightAnimationScaleButton) - fabsf(levelMultiple*kUIAnimationScaleButtonXMaxOffSet));
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSLog(@"scrollViewDidScroll");
    
    //   //NSLog(@"Y本次移动了\n-+++++++++%f",
    //          (scrollView.contentOffset.y - self.lastContentOffset)
    //          );
    
    //   int offset = (int)(scrollView.contentOffset.y - self.lastContentOffset);
    //    NSLog(@"之前是\n-+++++++++%f", self.lastContentOffset
    //);
    //    NSLog(@"现在是\n-+++++++++%f",scrollView.contentOffset.y);
    
    float levelMultiple =  (scrollView.contentOffset.y -  self.lastContentOffset)/kScrollViewMaxOffSet;
    
    //    当拖拽不松手,继续进行上下拖动时,判断上下手势,进行重置
    CGPoint velocity = [scrollView.panGestureRecognizer velocityInView:scrollView.superview];
    int offset = (int)velocity.y;
    if (offset == 0) {
        //NSLog(@"减速滑行");
        if(_isUpDecelerating == NO) {
            //NSLog(@"变黄减速透明度为%f",_alpha);
            [self upLevel:levelMultiple];
        } else {
            //NSLog(@"蓝减速透明度为%f",_alpha);
            [self downLevel:levelMultiple];
        }
    }
    
    if (offset < 0 )
    {
        NSLog(@"下下下下下下下下下下下下下下");
        [self downLevel:levelMultiple];
        NSLog(@"透明度为%f",_alpha);
    }
    
    if (offset > 0 ) {
        NSLog(@"上上上上上上上上上上上上上上");
        [self upLevel:levelMultiple];
        NSLog(@"透明度为%f",_alpha);
    }
    self.colorView.alpha = _alpha;
    self.lastContentOffset = scrollView.contentOffset.y;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    //NSLog(@"%f",targetContentOffset->y);
    if (velocity.y > 0){
        //NSLog(@"up");
        _isUpDecelerating = YES;
    } else if (velocity.y < 0){
        //NSLog(@"down");
        _isUpDecelerating = NO;
    } else {
        //NSLog(@"不知道什么时候,不上不下 啊啊啊啊 啊");
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"scrollViewDidEndDragging");
    //    self.lastContentOffset = scrollView.contentOffset.y;
    if (_alpha < 0.5) _alpha = ColorViewBgBlueColor; else _alpha=ColorViewBgYellowColor;
    //    self.colorView.alpha = _alpha;
    //    self.searchBar.alpha = _alpha;
    
    [self searchBarDidEnd];
    
    //   //NSLog(@"移动结束了\n%f",scrollView.contentOffset.y);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //   //NSLog(@"scrollViewDidEndDecelerating");
    if (_alpha < 0.5)
    {
        [UIView animateWithDuration:0.25 animations:^{
            _alpha = ColorViewBgBlueColor;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            _alpha = ColorViewBgYellowColor;
        }];
    }
    //    self.colorView.alpha = _alpha;
    //    self.searchBar.alpha = _alpha;
    
    //    RectMakeSetWidth(_segmentButtonView, UI_SCREEN_WIDTH/2)
    //scrollView---------------
    [self searchBarDidEnd];
    
}

- (void)searchBarDidEnd {
    //    if (ViewY(self.searchBar) > 3*(kSearchBarMinValue/4) ) {
    //        RectMakeSetY(self.searchBar, kSearchBarMaxValue);
    //    }
    //    else {
    //        RectMakeSetY(self.searchBar, kSearchBarMinValue);
    //    }
    
}



#pragma mark - ╰╯

@end
