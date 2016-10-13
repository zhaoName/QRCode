//
//  OfficialScanQRCodeView.h
//  QRCode
//
//  Created by zhao on 16/10/9.
//  Copyright © 2016年 zhaoName. All rights reserved.
//  画出扫描区域和非扫描区域，执行扫描动画

#import <UIKit/UIKit.h>

#define ScanW 220
#define Scan_Width self.frame.size.width
#define Scan_Height self.frame.size.height
#define Scan_Angle_Width 25

@interface OfficialScanAnimationView : UIView

/**
 *  快速实例化OfficialScanAnimationView类
 */
+ (instancetype)initWithFrame:(CGRect)frame;

/** 开始扫描动画*/
- (void)startScanAnimation;
/** 结束扫描动画*/
- (void)endScanAnimation;

@end
