//
//  CYLSegmentUnitButtonModel.h
//  PostMenuDemo
//
//  Created by CHENYI LONG on 14-10-15.
//  Copyright (c) 2014年 CHENYI LONG. All rights reserved.
//
#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>


#define kInitH(name) \
- (id)initWithDict:(NSDictionary *)dict; \
+ (id)name##WithDict:(NSDictionary *)dict;

#define kInitM(name) \
+ (id)name##WithDict:(NSDictionary *)dict \
{ \
return [[self alloc] initWithDict:dict]; \
}


@interface CYLSegmentUnitButtonModel : NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIImage *selectedImage;
kInitH(CYLAddtionMoneyModel)

@end
