//
//  ThirdLibQRCodeViewController.m
//  QRCode
//
//  Created by zhao on 16/10/8.
//  Copyright © 2016年 zhaoName. All rights reserved.
//  三方库生成的二维码


#import "ZBarGenerateQRCodeVC.h"
#import "UIImage+ZBarGenerateQRCode.h"
#import "Code39.h"

@interface ZBarGenerateQRCodeVC ()

@property (weak, nonatomic) IBOutlet UIImageView *normalQRCodeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoQRCodeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *barcode_39ImageVIew;

@end

@implementation ZBarGenerateQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.normalQRCodeImageView.image = [UIImage qrImageForString:@"这是常规二维码" imageSize:120];
    self.logoQRCodeImageView.image = [UIImage qrImageForString:@"这是带logo的二维码" imageSize:120 logo:[UIImage imageNamed:@"dog"] logoSize:20];
    
    self.barcode_39ImageVIew.image = [Code39 code39ImageFromString:@"399432456" Width:275 Height:60];
}

@end
