//
// Created by Joshua Sullivan on 9/13/14.
// Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import "CCHReferenceImageCreator.h"
@import AppKit;

@implementation CCHReferenceImageCreator

// 16, 64, 256

+ (NSImage *)createReferenceImageWithCubeSize:(size_t)cubeSize
{
    NSAssert(cubeSize == 16 || cubeSize == 64 || cubeSize == 256, @"ERROR: cubeSize must be one of the following: 16, 64, 256");
    size_t pixels = cubeSize * cubeSize * cubeSize;
    size_t imageDimension = (size_t)sqrt(pixels);
    size_t channels = 4;
    size_t channelSize = sizeof(uint8_t);
    size_t memSize = pixels * channels * channelSize;
    uint8_t *bytes = malloc(memSize);
    size_t cubeSizeSquared = cubeSize * cubeSize;
    size_t offset;
    float colorStep = 255.0f / (cubeSize - 1);
    for (size_t i = 0; i < pixels; i++) {
        offset = i * channels;
        bytes[offset + 0] = (uint8_t)roundf((i % cubeSize) * colorStep);
        bytes[offset + 1] = (uint8_t)roundf(((i / cubeSize) % cubeSize) * colorStep);
        bytes[offset + 2] = (uint8_t)roundf((i / cubeSizeSquared) * colorStep);
        bytes[offset + 3] = 255U;
    }
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, bytes, memSize, NULL);
    size_t bitsPerComponent = 8U * channelSize;
    size_t bitsPerPixel = channels * bitsPerComponent;
    size_t bytesPerRow = imageDimension * channels;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
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