//
//  OfficialScanQRCodeView.m
//  QRCode
//
//  Created by zhao on 16/10/9.
//  Copyright © 2016年 zhaoName. All rights reserved.
//  画出扫描区域和非扫描区域，执行扫描动画

#import "OfficialScanAnimationView.h"
#import <AVFoundation/AVFoundation.h>

@interface OfficialScanAnimationView ()

@property (nonatomic, strong) CADisplayLink *displayLink; /**< 定时器*/
@property (nonatomic, strong) UIImageView *scanImageView; /**< 扫描区域背景图片*/
@property (nonatomic, strong) UIImageView *scanLineImageView; /**< 扫描线*/
@property (nonatomic, assign) CGFloat scanX; /**< 扫描区域的X值*/
@property (nonatomic, assign) CGFloat scanY; /**< 扫描区域的Y值*/

@property (nonatomic, strong) AVCaptureDevice *device; /**< 设备*/

@end

@implementation OfficialScanAnimationView

#pragma mark -- 初始化

+ (instancetype)initWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if([super initWithFrame:frame])
    {
        [self initDatas];
    }
    return self;
}

- (instancetype)init
{
    if([super init])
    {
        [self initDatas];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if([super initWithCoder:aDecoder])
    {
        [self initDatas];
    }
    return self;
}

- (void)initDatas
{
    self.backgroundColor = [UIColor clearColor];
    self.scanX = (Scan_Width - ScanW) / 2.0;
    self.scanY = self.scanX;
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

#pragma mark -- 画扫描区域和非扫描区域

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();;
    // 非扫描区域
    // 颜色
    [[[UIColor blackColor] colorWithAlphaComponent:0.4] setFill];
    // 上侧
    CGContextAddRect(context, CGRectMake(0, 0, Scan_Width, self.scanY));
    // 左侧
    CGContextAddRect(context, CGRectMake(0, self.scanY, self.scanX, ScanW));
    // 下侧
    CGContextAddRect(context, CGRectMake(0, CGRectGetMaxY(self.scanImageView.frame), Scan_Width, Scan_Height - CGRectGetMaxY(self.scanImageView.frame)));
    //右侧
    CGContextAddRect(context, CGRectMake(CGRectGetMaxY(self.scanImageView.frame), self.scanY, Scan_Width - CGRectGetMaxY(self.scanImageView.frame), ScanW));
    CGContextFillPath(context);
    
    // 扫描区域(可以直接放一张图片，也可以自己画出来)
#if 0
    [self addSubview:self.scanImageView];
#else
    CGContextSetLineWidth(context, 3);
    [[UIColor greenColor] setStroke];
    // 左上角
    CGContextMoveToPoint(context, self.scanX, self.scanY + Scan_Angle_Width);
    CGContextAddLineToPoint(context, self.scanX, self.scanY);
    CGContextAddLineToPoint(context, self.scanX + Scan_Angle_Width, self.scanY);
    // 右上角
    CGContextMoveToPoint(context, self.scanX + ScanW - Scan_Angle_Width, self.scanY);
    CGContextAddLineToPoint(context, self.scanX + ScanW, self.scanY);
    CGContextAddLineToPoint(context, self.scanX + ScanW, self.scanY + Scan_Angle_Width);
    // 右下角
    CGContextMoveToPoint(context, self.scanX + ScanW, self.scanY + ScanW - Scan_Angle_Width);
    CGContextAddLineToPoint(context, self.scanX + ScanW, self.scanY + ScanW);
    CGContextAddLineToPoint(context, self.scanX + ScanW - Scan_Angle_Width, self.scanY + ScanW);
    // 左下角
    CGContextMoveToPoint(context, self.scanX + Scan_Angle_Width, self.scanY + ScanW);
    CGContextAddLineToPoint(context, self.scanX, self.scanY + ScanW);
    CGContextAddLineToPoint(context, self.scanX, self.scanY + ScanW - Scan_Angle_Width);
    CGContextStrokePath(context);
#endif
    
    [self setupSubivews];
}

/** 创建子视图*/
- (void)setupSubivews
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.scanImageView.frame) + 30, Scan_Width - 20*2, 21)];
    label.text = @"请将二维码/条形码放入框内,即可自动扫描";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    [self addSubview:label];
    
    UIButton *lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lightBtn.frame = CGRectMake((Scan_Width - 120)/2, CGRectGetMaxY(label.frame) + 30, 120, 30);
    [lightBtn setTitle:@"打开闪光灯" forState:UIControlStateNormal];
    [lightBtn setTitle:@"关闭闪光灯" forState:UIControlStateSelected];
    [lightBtn addTarget:self action:@selector(touchLightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lightBtn];
}

#pragma mark -- 打开或关闭闪光灯
- (void)touchLightBtn:(UIButton *)btn
{
    if(![self.device hasTorch] || ![self.device hasFlash]) return;
    
    [self.device lockForConfiguration:nil];
    if(btn.selected == NO)
    {
        btn.selected = YES;
        [self.device setTorchMode:AVCaptureTorchModeOn];
        [self.device setFlashMode:AVCaptureFlashModeOn];
    }
    else
    {
        btn.selected = NO;
        [self.device setTorchMode:AVCaptureTorchModeOff];
        [self.device setFlashMode:AVCaptureFlashModeOff];
    }
    [self.device unlockForConfiguration];
}

#pragma mark -- 扫描动画

// 开始动画
- (void)startScanAnimation
{
    [self addSubview:self.scanLineImageView];
    if(self.displayLink == nil)
    {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(scanAnimation:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

// 定时器加载动画
- (void)scanAnimation:(CADisplayLink *)link
{
    CGRect scanLineFrame = self.scanLineImageView.frame;
    // 超过背景图片范围 则重头来过
    if (scanLineFrame.origin.y + 6 > CGRectGetMaxY(self.scanImageView.frame))
    {
        scanLineFrame.origin.y = self.scanY;
    }
    else //未超过
    {
        scanLineFrame.origin.y += 2;
    }
    self.scanLineImageView.frame = scanLineFrame;
}

// 结束动画
- (void)endScanAnimation
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

#pragma mark -- getter

- (UIImageView *)scanImageView
{
    if(!_scanImageView)
    {
        _scanImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScanBackgroundImage"]];
        _scanImageView.backgroundColor = [UIColor clearColor];
        _scanImageView.frame = CGRectMake(self.scanX, self.scanY, ScanW, ScanW);
    }
    return _scanImageView;
}

- (UIImageView *)scanLineImageView
{
    if(!_scanLineImageView)
    {
        _scanLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.scanX, self.scanY, ScanW, 6)];
        _scanLineImageView.image = [UIImage imageNamed:@"ScanLine"];
    }
    return _scanLineImageView;
}

@end
