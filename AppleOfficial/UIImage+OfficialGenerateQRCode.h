//
//  UIImage+OfficialCode.h
//  QRCode
//
//  Created by zhao on 16/10/9.
//  Copyright © 2016年 zhaoName. All rights reserved.
//  官方API生成二维码

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QRCodeType)
{
    QRCodeTypeDefault = 0, // 默认样式
    QRCodeTypeIcon, // 中间带logo
    QRCodeTypeColor, // 彩色
    QRCodeTypeIconAndColor, // 彩色且中间带logo
};

@interface UIImage (OfficialGenerateQRCode)

/**
 *  生成指定样式的二维码
 *
 *  @param string 二维码内容
 *  @param size   二维码大小
 *  @param type   二维码样式
 *
 *  @return 二维码图片
 */
+ (UIImage *)generateOfficialQRCodeWithString:(NSString *)string imageSize:(CGFloat)size codeType:(QRCodeType)type;


/**
 *  生成条形码
 *
 *  @param string 条形码内容
 *  @param width  条形码宽度
 *  @param height 条形码高度
 *
 *  @return 条形码图片
 */
+ (UIImage *)generateBarCodeWithString:(NSString *)string width:(CGFloat)width height:(CGFloat)height;

@end
