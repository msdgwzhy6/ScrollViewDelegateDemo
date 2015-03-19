//
//  CYLSegmentUnitButtonModel.m
//  PostMenuDemo
//
//  Created by CHENYI LONG on 14-10-15.
//  Copyright (c) 2014年 CHENYI LONG. All rights reserved.
//

#import "CYLSegmentUnitButtonModel.h"

@implementation CYLSegmentUnitButtonModel

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.title = dict[@"title"];
        self.image = dict[@"image"];
        self.selectedImage = dict[@"selectedImage"];
    }
    return self;
}
kInitM(addtionMoneyModel)

@end
