//
// Created by Joshua Sullivan on 9/13/14.
// Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import "CCHCubeDataCreator.h"
@import AppKit;

@implementation CCHCubeDataCreator

+ (NSData *)createDataFromReferenceImage:(NSImage *)image
{
    NSSize imageSize = [image size];
    size_t dim = (size_t)imageSize.width;
    size_t channels = 4;
    size_t componentSize = 1;
    size_t bytesPerRow = dim * channels * componentSize;
    size_t memSize = bytesPerRow * dim;
    uint8_t *imageBytes = malloc(memSize);
    CGImageRef imageRef = [image CGImageForProposedRect:nil
                                                context:[NSGraphicsContext currentContext]
                                                  hints:nil];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGBitmapInfo bitmapInfo = kCGBitmapFloatComponents | kCGImageAlphaPremultipliedLast;
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaNoneSkipLast;
    CGContextRef bitmapContext = CGBitmapContextCreate(imageBytes, dim, dim, componentSize * 8, bytesPerRow, colorSpace, bitmapInfo);
    CGContextDrawImage(bitmapContext, CGRectMake(0.0f, 0.0f, dim, dim), imageRef);
    CGContextRelease(bitmapContext);
    CGColorSpaceRelease(colorSpace);

    size_t floatSize = memSize * sizeof(float);
    float *floatBuffer = malloc(floatSize);
    for (size_t i = 0; i < memSize; i++) {
        floatBuffer[i] = (float)imageBytes[i] / 255.0f;
    }
    free(imageBytes);

    NSData *cubeData = [NSData dataWithBytesNoCopy:floatBuffer
                                            length:floatSize
                                      freeWhenDone:YES];

    return cubeData;
}


@end