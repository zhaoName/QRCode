//
//  ZBarScanQRCodeView.h
//  QRCode
//
//  Created by zhao on 16/10/12.
//  Copyright © 2016年 zhaoName. All rights reserved.
//  ZBar扫码

#import <UIKit/UIKit.h>

@protocol ZBarScanQRCodeViewDelegate <NSObject>

/** 返回识别的二维码内容*/
- (void)sendZBarQRCodeContent:(NSString *)content;

@end



@interface ZBarScanQRCodeView : UIView

@property (nonatomic, weak) id<ZBarScanQRCodeViewDelegate> delegate;

/** 快速实例化ZBarScanQRCodeView类*/
+ (instancetype)initWithFrame:(CGRect)frame;

/** 开始扫描二维码*/
- (void)startZBarReadQRCode;
/** 结束扫描二维码*/
- (void)endZBarReadQRCode;

/** 进入相册，识别图片中的二维码*/
- (void)recognizeQRcodeFromAlbumWithZBar;

@end
