//
// Created by Joshua Sullivan on 9/8/14.
// Copyright (c) 2014 Joshua Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CCHAppMode) {
    CCHAppModeCreateImage,
    CCHAppModeGenerateData
};

typedef NS_ENUM(NSInteger, CCHParseArgumentResult) {
    CCHParseArgumentResultFailed = 0,
    CCHParseArgumentResultSuccessAndContinue,
    CCHParseArgumentResultSuccessAndStop,
};

@interface CCHArgumentHelper : NSObject

@property (readonly, nonatomic) CCHAppMode appMode;
@property (readonly, nonatomic) size_t cubeSize;
@property (readonly, nonatomic) NSImage *inputImage;
@property (readonly, nonatomic) NSString *dataName;

- (CCHParseArgumentResult)processArguments;

@end