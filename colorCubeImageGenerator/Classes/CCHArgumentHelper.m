//
// Created by Joshua Sullivan on 9/8/14.
// Copyright (c) 2014 Joshua Sullivan. All rights reserved.
//

#import "CCHArgumentHelper.h"
@import AppKit;

static NSString * const kHelpKey = @"-help";
static NSString * const kVersionKey = @"-version";
static NSString * const kSizeKey = @"size";

static NSString * const kInvalidAppModeError = @"ERROR: You must specify an app mode. See -help for details.";

@interface CCHArgumentHelper ()

@property (assign, nonatomic) size_t cubeSize;

@end

@implementation CCHArgumentHelper

- (CCHParseArgumentResult)processArguments
{
    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
    NSUInteger argCount = [arguments count];

    if (argCount > 0) {
        NSString *firstArg = [arguments[0] lowercaseString];

        if ([firstArg isEqualToString:kHelpKey]) {
            [self showHelp];
            return CCHParseArgumentResultSuccessAndStop;
        }
        else if ([firstArg isEqualToString:kVersionKey]) {
            [self showVersion];
            return CCHParseArgumentResultSuccessAndStop;
        }
    }

    NSString *sizeString = [[NSUserDefaults standardUserDefaults] objectForKey:kSizeKey];
    NSNumber *sizeNum = nil;
    if (!sizeString) {
        sizeNum = @16;
    } else {
        sizeNum = @([sizeString integerValue]);
        NSArray *validSizes = @[@16, @64, @256];
        if ([validSizes indexOfObject:sizeNum] == NSNotFound) {
            NSLog(@"ERROR: The -size parameter only accepts the following values: %@", [validSizes componentsJoinedByString:@", "]);
            return CCHParseArgumentResultFailed;
        }
    }
    self.cubeSize = (size_t)[sizeNum integerValue];

    return CCHParseArgumentResultSuccessAndContinue;
}

- (void)showHelp
{
    NSLog(@"USAGE:");
    NSLog(@" ");
    NSLog(@"colorCubeImageGenerator [-size S]");
    NSLog(@" ");
    NSLog(@"\t-size S\t\tSpecify the color cube dimension. Valid values for S are: 16, 64, and 256.");
    NSLog(@"\t\t\t\tIf omitted, a value of 16 will be used by default.");
}

- (void)showVersion
{
    NSLog(@"colorCubeImageGenerator v0.1 - (c) 2014 Joshua Sullivan and The Nerdery");
}

@end