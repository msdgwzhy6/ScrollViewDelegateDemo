//
//  CYLCommonDistinguishUITool.h
//  红人在哪儿
//
//  Created by CHENYI LONG on 14-9-26.
//  Copyright (c) 2014年 Roman Efimov. All rights reserved.
//=================遍历某特定视图中的某特定控件并放入数组中



//=================遍历某特定视图中“所有子视图”的某特定控件并放入数组中（嵌套版本）
#define kDistinguishSuccessBlock(childUIname) \
typedef void (^Distinguish##childUIname##SuccessBlock)(childUIname *view);

#define kDistinguishUIProperty(childUIname) \
@property (nonatomic,readonly) NSMutableArray *distinguished##childUIname##Result;

#define kDistinguishUISynthesize(childUIname) \
@synthesize distinguished##childUIname##Result= _distinguished##childUIname##Result;

#define kDistinguishFromAllFathers(childUIname) \
- (void)distinguish##childUIname##FromFatherUI:(UIView *)view {\
for (UIView *child in view.subviews) {\
if ([child isKindOfClass:[childUIname class]]) {\
childUIname *childUI = (childUIname *)child;\
[_distinguished##childUIname##Result addObject:childUI];\
} else {\
[self distinguish##childUIname##FromFatherUI:child];\
}\
}\
} \
- (void)distinguish##childUIname##FromFatherUI:(UIView *)fatherView distinguishSuccess:(Distinguish##childUIname##SuccessBlock)getedUIs{\
_distinguished##childUIname##Result = [NSMutableArray array];\
[self distinguish##childUIname##FromFatherUI:fatherView];\
for (childUIname *childUI in  _distinguished##childUIname##Result) {\
getedUIs(childUI);\
}\
}



//=================遍历某特定视图中“单个子视图”的某特定控件并放入数组中（非嵌套版本）

//#define kDistinguishSuccessBlock(childUIname) \
//typedef void (^Distinguish##childUIname##SuccessBlock)(childUIname *view);

#define kDistinguishUIFromSingleFatherProperty(childUIname) \
@property (nonatomic,readonly) NSMutableArray *distinguished##childUIname##FromSingleFatherResult;
#define kDistinguishUIFromSingleFatheSynthesize(childUIname) \
@synthesize distinguished##childUIname##FromSingleFatherResult= _distinguished##childUIname##FromSingleFatherResult;

#define kDistinguishFromSingleFather(childUIname) \
- (void)distinguish##childUIname##FromSingleFather:(UIView *)view {\
for (UIView *child in view.subviews) {\
if ([child isKindOfClass:[childUIname class]]) {\
childUIname *childUI = (childUIname *)child;\
[_distinguished##childUIname##FromSingleFatherResult addObject:childUI];\
} \
}\
} \
- (void)distinguish##childUIname##SingleFather:(UIView *)fatherView distinguishSuccess:(Distinguish##childUIname##SuccessBlock)getedUIs{\
_distinguished##childUIname##FromSingleFatherResult = [NSMutableArray array];\
[self distinguish##childUIname##FromSingleFather:fatherView];\
for (childUIname *childUI in  _distinguished##childUIname##FromSingleFatherResult) {\
getedUIs(childUI);\
}\
}