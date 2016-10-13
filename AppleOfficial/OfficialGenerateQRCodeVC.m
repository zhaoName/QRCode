//
//  OfficialQRCodeViewController.m
//  QRCode
//
//  Created by zhao on 16/10/8.
//  Copyright © 2016年 zhaoName. All rights reserved.
//  官方API生成二维码

#import "OfficialGenerateQRCodeVC.h"
#import "UIImage+OfficialGenerateQRCode.h"

@interface OfficialGenerateQRCodeVC ()

@property (weak, nonatomic) IBOutlet UIImageView *defaultQRCodeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconQRCodeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *colorQRCodeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iocn_ColorQRCodeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *barCodeImageView;


@end

@implementation OfficialGenerateQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.defaultQRCodeImageView.image = [UIImage generateOfficialQRCodeWithString:@"1235346256" imageSize:120.0 codeType:QRCodeTypeDefault];
    NSLog(@"%f, %f", self.defaultQRCodeImageView.image.size.width, self.defaultQRCodeImageView.image.size.height);
    
    
    self.iconQRCodeImageView.image = [UIImage generateOfficialQRCodeWithString:@"人终有一死" imageSize:120.0 codeType:QRCodeTypeIcon];
    NSLog(@"%f, %f", self.iconQRCodeImageView.image.size.width, self.iconQRCodeImageView.image.size.height);
    
    self.colorQRCodeImageView.image = [UIImage generateOfficialQRCodeWithString:@"https://www.baidu.com" imageSize:120 codeType:QRCodeTypeColor];
    NSLog(@"%f, %f", self.colorQRCodeImageView.image.size.width, self.colorQRCodeImageView.image.size.height);
    
    self.iocn_ColorQRCodeImageView.image = [UIImage generateOfficialQRCodeWithString:@"123合肥https://www.baidu.com" imageSize:120 codeType:QRCodeTypeIconAndColor];
    NSLog(@"%f, %f", self.iocn_ColorQRCodeImageView.image.size.width, self.iocn_ColorQRCodeImageView.image.size.height);
    
    
    self.barCodeImageView.image = [UIImage generateBarCodeWithString:@"345756124987" width:180 height:50];
    NSLog(@"%f, %f", self.barCodeImageView.image.size.width, self.barCodeImageView.image.size.height);
}

- (void)dealloc
{
    self.defaultQRCodeImageView = nil;
    self.iconQRCodeImageView = nil;
    self.iocn_ColorQRCodeImageView = nil;
}

@end
