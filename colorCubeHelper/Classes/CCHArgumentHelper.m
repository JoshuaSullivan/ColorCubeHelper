//
// Created by Joshua Sullivan on 9/8/14.
// Copyright (c) 2014 Joshua Sullivan. All rights reserved.
//

#import "CCHArgumentHelper.h"
@import AppKit;

static NSString * const kCreateImageKey = @"image";
static NSString * const kGenerateDataKey = @"data";
static NSString * const kHelpKey = @"-help";
static NSString * const kVersionKey = @"-version";
static NSString * const kSizeKey = @"size";
static NSString * const kImageKey = @"image";
static NSString * const kDataKey = @"data";
static NSString * const kDataFileExtension = @"cqb";

static NSString * const kInvalidAppModeError = @"ERROR: You must specify an app mode. See -help for details.";

@interface CCHArgumentHelper ()

@property (assign, nonatomic) CCHAppMode appMode;
@property (assign, nonatomic) size_t cubeSize;
@property (strong, nonatomic) NSImage *inputImage;
@property (strong, nonatomic) NSString *dataName;

@end

@implementation CCHArgumentHelper

- (CCHParseArgumentResult)processArguments
{
    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
    NSUInteger argCount = [arguments count];
    if (argCount == 1) {
        NSLog(kInvalidAppModeError);
        return CCHParseArgumentResultFailed;
    }

    NSString *firstArg = [arguments[1] lowercaseString];

    if ([firstArg isEqualToString:kHelpKey]) {
        [self showHelp];
        return CCHParseArgumentResultSuccessAndStop;
    }
    else if ([firstArg isEqualToString:kVersionKey]) {
        [self showVersion];
        return CCHParseArgumentResultSuccessAndStop;
    }
    else if ([firstArg isEqualToString:kImageKey]) {
        NSString *sizeString = [[NSUserDefaults standardUserDefaults] objectForKey:kSizeKey];
        NSNumber *sizeNum = nil;
        if (!sizeString) {
            sizeNum = @64;
        } else {
            sizeNum = @([sizeString integerValue]);
            NSArray *validSizes = @[@4, @16, @64, @256];
            if ([validSizes indexOfObject:sizeNum] == NSNotFound) {
                NSLog(@"ERROR: The -size parameter only accepts the following values: %@", [validSizes componentsJoinedByString:@", "]);
                return CCHParseArgumentResultFailed;
            }
        }
        self.cubeSize = (size_t)[sizeNum integerValue];
        self.appMode = CCHAppModeCreateImage;
    }
    else if ([firstArg isEqualToString:kGenerateDataKey]) {
        NSString *imageString = [[NSUserDefaults standardUserDefaults] objectForKey:kImageKey];
        if (!imageString) {
            NSLog(@"ERROR: You must specify an input image with the -image argument.");
            return CCHParseArgumentResultFailed;
        }
        BOOL imageFileExists = [[NSFileManager defaultManager] fileExistsAtPath:imageString];
        if (!imageFileExists) {
            NSLog(@"ERROR: Could not find file '%@'.", imageString);
            return CCHParseArgumentResultFailed;
        }
        self.inputImage = [[NSImage alloc] initWithContentsOfFile:imageString];
        if (!self.inputImage) {
            NSLog(@"ERROR: Could not read contents of file '%@'.", imageString);
            return CCHParseArgumentResultFailed;
        }
        NSString *dataString = [[NSUserDefaults standardUserDefaults] objectForKey:kDataKey];
        if (!dataString) {
            dataString = [imageString stringByDeletingPathExtension];
        }
        NSString *dataName = [dataString stringByAppendingPathExtension:kDataFileExtension];
        BOOL dataFileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataName];
        if (dataFileExists) {
            NSLog(@"ERROR: Data file '%@' already exists. Please remove or rename it, as app will not overwrite.", dataName);
            return CCHParseArgumentResultFailed;
        }
        self.dataName = dataName;
        self.appMode = CCHAppModeGenerateData;
    }

    return CCHParseArgumentResultSuccessAndContinue;
}

- (void)showHelp
{
    NSLog(@"colorCubeHelper has 2 modes of action:");
    NSLog(@" ");
    NSLog(@"\timage\tGenerate a reference color cube image for manipulation in Photoshop.");
    NSLog(@"\tdata\tTake a manipulated reference image and create the NSData needed by the CIColorCube filter.");
    NSLog(@" ");
    NSLog(@"USAGE:");
    NSLog(@" ");
    NSLog(@"colorCubeHelper image [-size S]");
    NSLog(@" ");
    NSLog(@"\t-size S\t\tSpecify the color cube dimension. Valid values for S are: 4, 16, 64, and 256.");
    NSLog(@"\t\t\t\tIf omitted, a value of 64 will be used by default.");
    NSLog(@" ");
    NSLog(@"colorCubeHelper data [-image inputFileName] [-data outputFileName]");
    NSLog(@" ");
    NSLog(@"\t-image\t\tThe manipulated reference image to use in generating data.");
    NSLog(@" ");
    NSLog(@"\t-data\t\tThe file to write the generated NSData to. The file extension 'cqb' will be added to this name.");
    NSLog(@"\t\t\t\tIf omitted, the file will be named identically to the image but with a .cqb extension.");
}

- (void)showVersion
{
    NSLog(@"colorCubeHelper v0.1 - (c) 2014 Joshua Sullivan and The Nerdery");
}

@end