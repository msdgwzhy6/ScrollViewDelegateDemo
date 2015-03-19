//
//  CYLCommonProgramTool.h
//  红人在哪儿
//
//  Created by CHENYI LONG on 14-9-28.
//  Copyright (c) 2014年 Roman Efimov. All rights reserved.
//



#define Bundle                              [NSBundle mainBundle]
#define MainScreen                          [UIScreen mainScreen]

#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y
#define SelfViewHeight                      self.view.bounds.size.height

#define RectX(f)                            f.origin.x
#define RectY(f)                            f.origin.y
#define RectWidth(f)                        f.size.width
#define RectHeight(f)                       f.size.height
#define RectSetWidth(f, w)                  CGRectMake(RectX(f), RectY(f), w, RectHeight(f))
#define RectSetHeight(f, h)                 CGRectMake(RectX(f), RectY(f), RectWidth(f), h)
#define RectSetX(f, x)                      CGRectMake(x, RectY(f), RectWidth(f), RectHeight(f))
#define RectSetY(f, y)                      CGRectMake(RectX(f), y, RectWidth(f), RectHeight(f))

#define RectSetSize(f, w, h)                CGRectMake(RectX(f), RectY(f), w, h)
#define RectSetOrigin(f, x, y)              CGRectMake(x, y, RectWidth(f), RectHeight(f))
#define Rect(x, y, w, h)                    CGRectMake(x, y, w, h)
#define RGB(r, g, b)                        [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define StatusBarHeight                     [UIApplication sharedApplication].statusBarFrame.size.height
#define SelfDefaultToolbarHeight            self.navigationController.navigationBar.frame.size.height
#define Size(w, h)                          CGSizeMake(w, h)
#define Point(x, y)                         CGPointMake(x, y)
#define RectMakeSetX(f, x)                  f.frame = RectSetX(f.frame, x);
#define RectMakeSetY(f, y)                  f.frame = RectSetY(f.frame, y);
#define RectMakeSetWidth(f, w)              f.frame = RectSetWidth(f.frame, w);
#define RectMakeSetHeight(f, h)             f.frame = RectSetHeight(f.frame, h);
#define RectMakeSetOrigin(f, x, y)          f.frame = RectSetOrigin(f.frame, x, y);
#define RectMakeSetSize(f, w, h)            f.frame = RectSetSize(f.frame, w, h);

#define RectMakeSetCenterX(f)   RectMakeSetX(f, UI_SCREEN_WIDTH/2 -ViewWidth(f)/2);
#define RectMakeSetCenterY(f,superViewName) RectMakeSetY(f, (ViewHeight(superViewName) - ViewHeight(f))/2);

#define kAddClearButtonOnUI(name,actions) \
UIButton *addedOnUI##name##ClearButton= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ViewWidth(name), ViewHeight(name))];\
addedOnUI##name##ClearButton.backgroundColor = [UIColor clearColor];\
[addedOnUI##name##ClearButton addTarget:self action:@selector(actions) forControlEvents:UIControlEventTouchUpInside];\
[name addSubview:addedOnUI##name##ClearButton];



//kScreenView##nameOfTheUI##UpScreenDistance
//k##nameOfTheUI##Width,k##nameOfTheUI##Height

#define kUIkdtLogoY 15
#define kUIkdtLogoWidth 264.75
#define kUIkdtLogoHeight 162

#define kAddOneUIBeCenterInWidthUpConstrainWithYWidthAndHeight(nameOfTheUI,yOfTheUI,widthOfTheUI,heightOftheUI) \
[nameOfTheUI setFrame:CGRectMake(UI_SCREEN_WIDTH/2- widthOfTheUI/2,yOfTheUI, widthOfTheUI,heightOftheUI)];


#import <CoreLocation/CLLocation.h>
static const CLLocationDegrees EmptyLocation = -1000.0;
static const CLLocationDegrees EmptyCoordinate = 0;

static const CLLocationCoordinate2D EmptyLocationCoordinate = {EmptyLocation,EmptyLocation};

#define IS_COORDINATE_EMPTY(RegionCenterName) \
(((RegionCenterName.latitude == EmptyLocation)&&(RegionCenterName.longitude == EmptyLocation))?YES:NO)


#define IS_Map_Loading(MapName) \
((((int)MapName.userLocation.location.coordinate.latitude == EmptyCoordinate)&&((int)MapName.userLocation.location.coordinate.longitude == EmptyCoordinate))?YES:NO)

//#define kScreenViewUI<#kdtLogoDownScreenDistance 15
////#define kUIkdtLogoWidth 264.75
////#define kUIkdtLogoHeight 162
//#define kAddOneUIBeCenterInWidthDownConstrainWithYWidthAndHeight(nameOfTheUI,theUIDownScreenDistance,widthOfTheUI,heightOftheUI) \
//[nameOfTheUI setFrame:CGRectMake(UI_SCREEN_WIDTH/2- widthOfTheUI/2,UI_MAINSCREEN_HEIGHT-theUIDownScreenDistance, widthOfTheUI,heightOftheUI)];
