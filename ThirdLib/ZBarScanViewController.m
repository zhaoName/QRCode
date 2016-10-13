//
//  ZBarScanViewController.m
//  QRCode
//
//  Created by zhao on 16/10/11.
//  Copyright © 2016年 zhaoName. All rights reserved.
//  ZBar扫码

#import "ZBarScanViewController.h"
#import "ZBarScanQRCodeView.h"
#import "SuccessViewController.h"

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

@interface ZBarScanViewController ()<ZBarScanQRCodeViewDelegate>

@property (nonatomic, strong) ZBarScanQRCodeView *scanQRCodeView;

@end

@implementation ZBarScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (IBAction)zBarScanQRCode:(UIButton *)sender
{
    [self.view addSubview:self.scanQRCodeView];
    [self.scanQRCodeView startZBarReadQRCode];
}

- (IBAction)recognizeQRCodeWithZbar:(UIBarButtonItem *)sender
{
    [self.scanQRCodeView recognizeQRcodeFromAlbumWithZBar];
}


#pragma mark -- ZBarScanQRCodeViewDelegate
- (void)sendZBarQRCodeContent:(NSString *)content
{
    SuccessViewController *successVC = [[SuccessViewController alloc] init];
    successVC.codeContent = content;
    [self.navigationController pushViewController:successVC animated:YES];
}

#pragma mark -- getter

- (ZBarScanQRCodeView *)scanQRCodeView
{
    if(!_scanQRCodeView)
    {
        _scanQRCodeView = [ZBarScanQRCodeView initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height - 64)];
        _scanQRCodeView.delegate = self;
    }
    return _scanQRCodeView;
}

@end
