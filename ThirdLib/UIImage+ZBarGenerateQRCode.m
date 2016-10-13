
//
//  UIImage+ZBarGenerateQRCode.m
//  QRCode
//
//  Created by zhao on 16/10/12.
//  Copyright © 2016年 zhaoName. All rights reserved.
//

#import "UIImage+ZBarGenerateQRCode.h"
#import "QRCodeGenerator.h"
#import "Code39.h"
#import <ZBarSDK.h>

@implementation UIImage (ZBarGenerateQRCode)

#pragma mark -- 二维码
// 生成常规二维码
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size
{
    return [QRCodeGenerator qrImageForString:string imageSize:size];
}

// 生成带logo的二维码
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size logo:(UIImage *)logo logoSize:(CGFloat)logoSize
{
    UIImage *normalCodeImage = [QRCodeGenerator qrImageForString:string imageSize:size];
    
    UIGraphicsBeginImageContext(normalCodeImage.size);
    
    CGFloat normalW = normalCodeImage.size.width;
    CGFloat normalH = normalCodeImage.size.height;
    [normalCodeImage drawInRect:CGRectMake(0, 0, normalW, normalH)];
    [logo drawInRect:CGRectMake((normalW - logoSize) / 2, (normalH - logoSize) / 2, logoSize, logoSize)];
    
    UIImage *logoImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"%f, %f", logoImage.size.width, logoImage.size.height);
    return logoImage;
}

#pragma mark -- 相册识别二维码

+ (NSString *)ZbarQRReaderForImage:(UIImage *)image
{
    ZBarReaderController *read = [[ZBarReaderController alloc] init];
    NSString *qrResult = nil;
    for(ZBarSymbol* symbol in [read scanImage:image.CGImage])
    {
        qrResult = symbol.data ;
    
    }
    return qrResult?:@"";
}

@end
