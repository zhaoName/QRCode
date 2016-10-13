//
//  OfficialScanQRCodeVC.m
//  QRCode
//
//  Created by zhao on 16/10/9.
//  Copyright © 2016年 zhaoName. All rights reserved.
//  官方扫码

#import "OfficialScanQRCodeVC.h"
#import "OfficialScanAnimationView.h"
#import "OfficialScanQRCodeView.h"
#import "SuccessViewController.h"

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

@interface OfficialScanQRCodeVC ()<OfficialScanQRCodeViewDelegate>

@property (nonatomic, strong) OfficialScanAnimationView *scanView; /**< 扫描区域*/
@property (nonatomic, strong) OfficialScanQRCodeView *scanQRCodeView; /**< 读取二维码内容*/

@end

@implementation OfficialScanQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注意添加的顺序
    [self.view addSubview:self.scanQRCodeView];
    [self.view addSubview:self.scanView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.scanView startScanAnimation];
    [self.scanQRCodeView startReadQRCode];
}

#pragma mark -- 相册

- (IBAction)recognizeQRcodeFromAlbum:(UIBarButtonItem *)sender
{
    [self.scanQRCodeView recognizeQRcodeFromAlbum];
}

#pragma mark -- OfficialScanQRCodeViewDelegate

- (void)sendQRCodeContent:(NSString *)content
{
    // 停止扫描动画和识别二维码
    [self.scanView endScanAnimation];
    [self.scanQRCodeView endReadQRCode];
    // 条状界面
    SuccessViewController* successVC = [[SuccessViewController alloc] init];
    successVC.codeContent = content;
    [self.navigationController pushViewController:successVC animated:YES];
}

#pragma mark -- getter

- (OfficialScanAnimationView *)scanView
{
    if(!_scanView)
    {
        _scanView = [OfficialScanAnimationView initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height-64)];
    }
    return _scanView;
}

- (OfficialScanQRCodeView *)scanQRCodeView
{
    if (!_scanQRCodeView)
    {
        _scanQRCodeView = [OfficialScanQRCodeView initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height-64)];
        _scanQRCodeView.delegate = self;
    }
    return _scanQRCodeView;
}

@end
