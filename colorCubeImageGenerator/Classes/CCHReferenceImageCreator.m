//
// Created by Joshua Sullivan on 9/13/14.
// Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import "CCHReferenceImageCreator.h"
@import AppKit;

@implementation CCHReferenceImageCreator

+ (NSImage *)createReferenceImageWithCubeSize:(size_t)cubeSize
{
    size_t gridSize = (size_t)sqrt(cubeSize);
    size_t imageDimension = cubeSize * gridSize;
    size_t componentSize = sizeof(uint8_t);
    size_t memSize = cubeSize * cubeSize * cubeSize * 4 * componentSize;
    uint8_t *bytes = malloc(memSize);
    float colorStep = 255.0f / (float)(cubeSize - 1);
    size_t offset = 0;
    uint8_t r, g, b;
    for (size_t j = 0; j < imageDimension; j++) {
        for (size_t i = 0; i < imageDimension; i++) {
            r = (uint8_t)roundf((i % cubeSize) * colorStep);
            g = (uint8_t)roundf((j % cubeSize) * colorStep);
            b = (uint8_t)roundf((i / cubeSize + (j / cubeSize) * gridSize) * colorStep);
            bytes[offset + 0] = r;
            bytes[offset + 1] = g;
            bytes[offset + 2] = b;
            bytes[offset + 3] = 255U;
            offset += 4;
        }
    }

    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, bytes, memSize, NULL);
    size_t bitsPerComponent = componentSize * 8;
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