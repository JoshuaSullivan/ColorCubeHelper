//
//  main.m
//  colorCubeHelper
//
//  Created by Joshua Sullivan on 9/8/14.
//  Copyright (c) 2014 Joshua Sullivan. All rights reserved.
//

@import AppKit;

#import "CCHArgumentHelper.h"
#import "CCHReferenceImageCreator.h"


int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        CCHArgumentHelper *argHelper = [CCHArgumentHelper new];
        CCHParseArgumentResult result = [argHelper processArguments];
        if (result == CCHParseArgumentResultFailed) {
            return 1;
        }
        else if (result == CCHParseArgumentResultSuccessAndContinue) {
            CFTimeInterval startTime = CACurrentMediaTime();
            NSImage *image = [CCHReferenceImageCreator createReferenceImageWithCubeSize:argHelper.cubeSize];
            NSString *fileName = [NSString stringWithFormat:@"colorCubeImage%li.png", (long)argHelper.cubeSize];
            CGImageRef cgRef = [image CGImageForProposedRect:NULL
                                                     context:nil
                                                       hints:nil];
            NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
            [newRep setSize:[image size]];   // if you want the same resolution
            NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:@{NSImageInterlaced : @0}];
            [pngData writeToFile:fileName atomically:YES];
            CFTimeInterval endTime = CACurrentMediaTime();
            NSLog(@"Image creation took %0.2fms.", (endTime - startTime) * 1000.0);
        }
    }
    
    return 0;
}
