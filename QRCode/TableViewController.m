//
//  TableViewController.m
//  QRCode
//
//  Created by zhao on 16/10/10.
//  Copyright © 2016年 zhaoName. All rights reserved.
//

#import "TableViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 判断当前设备是否有摄像头
    if(indexPath.row == 1)
    {
        [self jump:@"OfficialScanQRCodeVC"];
    }
    if(indexPath.row == 3)
    {
        [self jump:@"ZBarScanViewController"];
    }
}

- (void)jump:(NSString *)identifier
{
    if ([AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo])
    {
        [self performSegueWithIdentifier:identifier sender:nil];
    }
    else
    {
        UIAlertController *aC = [UIAlertController alertControllerWithTitle:@"警告" message:@"未检测到您的摄像头, 请在真机上测试" preferredStyle:UIAlertControllerStyleAlert];
        [aC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:aC animated:YES completion:nil];
    }
}

@end
