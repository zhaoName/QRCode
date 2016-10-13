//
//  ZBarScanQRCodeView.m
//  QRCode
//
//  Created by zhao on 16/10/12.
//  Copyright © 2016年 zhaoName. All rights reserved.
//  ZBar扫码

#import "ZBarScanQRCodeView.h"
#import "OfficialScanAnimationView.h"
#import <ZBarSDK.h>
#import "UIImage+ZBarGenerateQRCode.h"

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

@interface ZBarScanQRCodeView ()<ZBarReaderViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) ZBarReaderView *readerView;
@property (nonatomic, strong) OfficialScanAnimationView *scanAniView;

@property (nonatomic, strong) UIImagePickerController *imagePicker; /**< 相册*/

@end

@implementation ZBarScanQRCodeView

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
    self.readerView = [[ZBarReaderView alloc] init];
    self.readerView.readerDelegate = self;
    // 相机的拍摄范围
    self.readerView.frame = self.bounds;
    self.readerView.allowsPinchZoom = NO;
    
    // 扫码区域
    CGFloat scanX = (self.frame.size.width - ScanW) / 2.0;
    CGFloat scanY = scanX;
    self.readerView.scanCrop = CGRectMake((scanY + 64)/Screen_Height, scanX/Screen_Width, ScanW/Screen_Height, ScanW/Screen_Width);
    
    ZBarImageScanner *imageScanner = [[ZBarImageScanner alloc] init];
    [imageScanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    [self.readerView initWithImageScanner:imageScanner];
    [self.readerView addSubview:self.scanAniView];
    [self addSubview:self.readerView];
    
}

#pragma mark -- ZBarReaderViewDelegate

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    for (ZBarSymbol *symbol in symbols)
    {
        if ([self.delegate respondsToSelector:@selector(sendZBarQRCodeContent:)])
        {
            [self.delegate sendZBarQRCodeContent:symbol.data];
        }
        break;
    }
}

- (void)startZBarReadQRCode
{
    [self.scanAniView startScanAnimation];
    [self.readerView start];
}

- (void)endZBarReadQRCode
{
    [self.readerView stop];
}

#pragma mark -- 从相册中识别二维码

- (void)recognizeQRcodeFromAlbumWithZBar
{
    if([UIDevice currentDevice].systemVersion.intValue < 8.0) return;
    // 授权进入相册
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIViewController *currentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        [currentVC presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

// 代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    // 从相册选取的照片
    UIImage *selectImage = info[UIImagePickerControllerOriginalImage];
    
    NSString *codeContent = [UIImage ZbarQRReaderForImage:selectImage];
    if([self.delegate respondsToSelector:@selector(sendZBarQRCodeContent:)] && codeContent.length > 0)
    {
        [self.delegate sendZBarQRCodeContent:codeContent];
       
    }
    // 界面跳转
    UIViewController *currentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [currentVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- getter

- (OfficialScanAnimationView *)scanAniView
{
    if(!_scanAniView)
    {
        _scanAniView = [OfficialScanAnimationView initWithFrame:self.bounds];
    }
    return _scanAniView;
}

- (UIImagePickerController *)imagePicker
{
    if(!_imagePicker)
    {
        _imagePicker = [[UIImagePickerController alloc] init];
        // 表示仅仅从相册中选取照片
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

@end

