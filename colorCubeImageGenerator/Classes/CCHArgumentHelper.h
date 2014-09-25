//
// Created by Joshua Sullivan on 9/8/14.
// Copyright (c) 2014 Joshua Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CCHParseArgumentResult) {
    CCHParseArgumentResultFailed = 0,
    CCHParseArgumentResultSuccessAndContinue,
    CCHParseArgumentResultSuccessAndStop,
};

@interface CCHArgumentHelper : NSObject

@property (readonly, nonatomic) size_t cubeSize;

- (CCHParseArgumentResult)processArguments;

@end