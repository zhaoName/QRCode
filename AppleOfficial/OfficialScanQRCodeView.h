//
//  OfficialScanQRCodeView.h
//  QRCode
//
//  Created by zhao on 16/10/10.
//  Copyright © 2016年 zhaoName. All rights reserved.
//  获取摄像头读取二维码内容

#import <UIKit/UIKit.h>

@protocol OfficialScanQRCodeViewDelegate <NSObject>

/** 返回识别的二维码内容*/
- (void)sendQRCodeContent:(NSString *)content;

@end



@interface OfficialScanQRCodeView : UIView

@property (nonatomic, weak) id<OfficialScanQRCodeViewDelegate> delegate;

/** 快速实例化OfficialScanQRCodeView类*/
+ (instancetype)initWithFrame:(CGRect)frame;

/** 开始扫描二维码*/
- (void)startReadQRCode;
/** 结束扫描二维码*/
- (void)endReadQRCode;

/** 进入相册，识别图片中的二维码*/
- (void)recognizeQRcodeFromAlbum;

@end
