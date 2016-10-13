//
//  UIImage+OfficialCode.m
//  QRCode
//
//  Created by zhao on 16/10/9.
//  Copyright © 2016年 zhaoName. All rights reserved.
//  官方API生成二维码

#import "UIImage+OfficialGenerateQRCode.h"

#define LOGO_WIDTH 25

@implementation UIImage (OfficialGenerateQRCode)

#pragma mark -- 二维码
// 生成指定样式的二维码
+ (UIImage *)generateOfficialQRCodeWithString:(NSString *)string imageSize:(CGFloat)size codeType:(QRCodeType)type
{
    if (string.length == 0) return nil;
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 字符串转化成data
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 通过KVC设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 设置二维码容错率 默认@“M” 15%
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 获取滤镜输出的图像
    CIImage *outImage = [filter outputImage];
    
    // 算出滤镜输出的图片的宽度,并放大到需要的尺寸
    CGFloat outImageWidth = outImage.extent.size.width;
    CIImage *scaleImage = [outImage imageByApplyingTransform:CGAffineTransformMakeScale(size/outImageWidth, size/outImageWidth)];
    
    //最终的二维码图片
    UIImage *codeImage = nil;
    switch (type)
    {
        case QRCodeTypeDefault: codeImage = [self changeImageSizeWithCiImage:outImage size:size]; break;
        case QRCodeTypeColor: codeImage = [self colorQRCode:scaleImage isIconImage:YES]; break;
        case QRCodeTypeIcon: codeImage = [self iconQRCode:scaleImage]; break;
        case QRCodeTypeIconAndColor: codeImage = [self colorQRCode:scaleImage isIconImage:NO]; break;
    }
    return codeImage;
}
#pragma  mark -- 条形码
// 条形码
+ (UIImage *)generateBarCodeWithString:(NSString *)string width:(CGFloat)width height:(CGFloat)height
{
    if (string.length == 0) return nil;
    
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setDefaults];
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:false];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *outImage = [filter outputImage];
    
    // 放缩到指定宽高
    CGFloat scaleX = width / outImage.extent.size.width;
    CGFloat scaleY = height / outImage.extent.size.height;
    CIImage *scaleImage = [outImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:scaleImage];
}

#pragma mark -- 私有方法
/**
 *  生成彩色的二维码
 */
+ (UIImage *)colorQRCode:(CIImage *)outImage isIconImage:(BOOL)isIconImage
{
    // 颜色过滤器
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    [colorFilter setDefaults];
    
    [colorFilter setValue:outImage forKey:@"inputImage"];
    // 二维码的颜色
    [colorFilter setValue:[CIColor colorWithRed:1.0 green:0 blue:0] forKey:@"inputColor0"];
    // 二维码背景色
    [colorFilter setValue:[CIColor colorWithRed:0 green:1.0 blue:0] forKey:@"inputColor1"];
    
    if(isIconImage)
    {
        return [UIImage imageWithCIImage:[colorFilter outputImage]];
    }
    return [self iconQRCode:[colorFilter outputImage]];
}

/**
 *  生成中间带logo的二维码,在一定限度logo图标越大,扫二维码用时越长
 */
+ (UIImage *)iconQRCode:(CIImage *)outImage
{
    UIImage *iconImage = [UIImage imageWithCIImage:outImage];
    // 获取图形上下文
    UIGraphicsBeginImageContext(iconImage.size);
    // 将二维码图片画上去
    [iconImage drawInRect:CGRectMake(0, 0, iconImage.size.width, iconImage.size.height)];
    
    // 将中间的logo画上去
    UIImage *middleImage = [UIImage imageNamed:@"dog"];
    CGFloat midImageX = (iconImage.size.width - LOGO_WIDTH)/2.0;
    CGFloat midImageY = midImageX;
    [middleImage drawInRect:CGRectMake(midImageX, midImageY, LOGO_WIDTH, LOGO_WIDTH)];
    
    // 获取加上中间logo的二维码
    iconImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return iconImage;
}

/**
 *  将CIImage转换成UIImage，并放大成需要的尺寸
 *
 *  @param outImage 滤镜输出的图像
 *  @param size     需要的尺寸(正方形)
 *
 *  @return UIImage
 */
+ (UIImage *)changeImageSizeWithCiImage:(CIImage *)outImage size:(CGFloat)size
{
    CGRect extent = CGRectIntegral(outImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:outImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
