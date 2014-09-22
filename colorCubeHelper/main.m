//
//  main.m
//  colorCubeHelper
//
//  Created by Joshua Sullivan on 9/8/14.
//  Copyright (c) 2014 Joshua Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCHArgumentHelper.h"
#import "CCHReferenceImageCreator.h"
#import "CCHCubeDataCreator.h"

@import AppKit;

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        CCHArgumentHelper *argHelper = [CCHArgumentHelper new];
        CCHParseArgumentResult result = [argHelper processArguments];
        if (result == CCHParseArgumentResultFailed) {
            return 1;
        }
        else if (result == CCHParseArgumentResultSuccessAndContinue) {
            NSLog(@"App mode: %li", (long)argHelper.appMode);
            if (argHelper.appMode == CCHAppModeCreateImage) {
                CFTimeInterval startTime = CACurrentMediaTime();
                NSImage *image = [CCHReferenceImageCreator createReferenceImageWithCubeSize:argHelper.cubeSize];
                NSString *fileName = [NSString stringWithFormat:@"colorCubeReference%li.png", (long)argHelper.cubeSize];
                CGImageRef cgRef = [image CGImageForProposedRect:NULL
                                                         context:nil
                                                           hints:nil];
                NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
                [newRep setSize:[image size]];   // if you want the same resolution
                NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:nil];
                [pngData writeToFile:fileName atomically:YES];
                CFTimeInterval endTime = CACurrentMediaTime();
                NSLog(@"Image creation took %0.2fms.", (endTime - startTime) * 1000.0);
            }
            else if (argHelper.appMode == CCHAppModeGenerateData) {
                CFTimeInterval startTime = CACurrentMediaTime();
                NSData *data = [CCHCubeDataCreator createDataFromReferenceImage:argHelper.inputImage];
                [data writeToFile:argHelper.dataName atomically:YES];
                CFTimeInterval endTime = CACurrentMediaTime();
                NSLog(@"Data generation took %0.2fms.", (endTime - startTime) * 1000.0);
            }
        }
    }

    return 0;
}
