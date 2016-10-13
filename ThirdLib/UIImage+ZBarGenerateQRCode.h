//
//  UIImage+ZBarGenerateQRCode.h
//  QRCode
//
//  Created by zhao on 16/10/12.
//  Copyright © 2016年 zhaoName. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZBarGenerateQRCode)

/**
 *  生成二维码
 *
 *  @param string 二维码内容
 *  @param size   二维码大小
 */
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size;

/**
 *  生成带logo的二维码
 *
 *  @param string   二维码内容
 *  @param size     二维码大小
 *  @param logo     logo图片
 *  @param logoSize logo大小
 */
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size logo:(UIImage *)logo logoSize:(CGFloat)logoSize;


+ (NSString *)ZbarQRReaderForImage:(UIImage *)image;

@end
