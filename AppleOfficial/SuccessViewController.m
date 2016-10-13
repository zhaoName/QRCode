//
//  SuccessViewController.m
//  QRCode
//
//  Created by zhao on 16/10/10.
//  Copyright © 2016年 zhaoName. All rights reserved.
//  扫码成功后的跳转界面

#import "SuccessViewController.h"

@interface SuccessViewController ()

@end

@implementation SuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 200, 250, 50)];
    label.text = self.codeContent;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    [self.view addSubview:label];
}


@end
