//
// Created by Joshua Sullivan on 9/13/14.
// Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import "CCHReferenceImageCreator.h"
@import AppKit;

@implementation CCHReferenceImageCreator

// 4, 16, 64, 256

+ (NSImage *)createReferenceImageWithCubeSize:(size_t)cubeSize
{
    size_t gridSize = (size_t)sqrt(cubeSize);
    size_t imageDimension = cubeSize * gridSize;
    size_t memSize = cubeSize * cubeSize * cubeSize * 4 * sizeof(uint8_t);
    uint8_t *bytes = malloc(memSize);
    float colorStep = 255.0f / (cubeSize - 1);
    size_t offset = 0;
    for (size_t j = 0; j < imageDimension; j++) {
        for (size_t i = 0; i < imageDimension; i++) {
            bytes[offset] = (uint8_t)roundf((i % cubeSize) * colorStep);
            bytes[offset + 1] = (uint8_t)roundf((j % cubeSize) * colorStep);
            bytes[offset + 2] = (uint8_t)roundf((i / cubeSize + (j / cubeSize) * gridSize) * colorStep);
            bytes[offset + 3] = 255U;
            offset += 4;
        }
    }
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, bytes, memSize, NULL);
    size_t bitsPerComponent = 8;
    size_t bitsPerPixel = 32;
    size_t bytesPerRow = imageDimension * 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(imageDimension, imageDimension, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpace, bitmapInfo, dataProvider, NULL, NO, renderingIntent);
    NSImage *cubeImage = [[NSImage alloc] initWithCGImage:imageRef size:CGSizeMake(imageDimension, imageDimension)];
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(dataProvider);
    free(bytes);
    return cubeImage;
}


@end