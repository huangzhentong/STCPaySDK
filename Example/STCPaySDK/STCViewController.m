//
//  STCViewController.m
//  STCPaySDK
//
//  Created by zhentong.huang on 04/23/2018.
//  Copyright (c) 2018 zhentong.huang. All rights reserved.
//

#import "STCViewController.h"
//#import <STCPaySDK/STCPayManager.h>
//#import <STCPaySDK/STCPaySDK/STCPayManager.h>
#import <STCPaySDK/STCPayManager.h>
//#import <STCPayCode/STCPayManager.h>
@interface STCViewController ()
{
    UIImageView *imageView;
}

@end

@implementation STCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageView = [UIImageView new];
    imageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:imageView];
    imageView.frame = CGRectMake(100,100, 100, 100);
    
    imageView.image = [UIImage imageNamed:[@"STCPaySDK.bundle/Res.bundle" stringByAppendingPathComponent:@"nav_close"]];
    //支付宝
//    [STCPayManager setAliPayScheme:@"zhifubao"];

    
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSString *airUrl  = @"https://cloud.keytop.cn/pc/page/app_pay.html?pay_info=eyJwYXlUeXBlIjoiQUxJIiwiZGF0YVR5cGUiOiJTdHJpbmciLCJkYXRhIjoiYWxpcGF5X3Nkaz1hbGlwYXktc2RrLWphdmEtZHluYW1pY1ZlcnNpb25ObyZhcHBfaWQ9MjAxNjA3MTMwMTYxMzczMCZiaXpfY29udGVudD0lN0IlMjJvdXRfdHJhZGVfbm8lMjIlM0ElMjJQQ1RFU1QxNTI0NDY2OTQ3Mzc0JTIyJTJDJTIydG90YWxfYW1vdW50JTIyJTNBJTIyMC4wMSUyMiUyQyUyMnN1YmplY3QlMjIlM0ElMjIlRTYlQjUlOEIlRTglQUYlOTUlMjIlMkMlMjJib2R5JTIyJTNBJTIyJUU2JTk0JUFGJUU0JUJCJTk4JUU2JUI1JThCJUU4JUFGJTk1JTIyJTJDJTIyc3RvcmVfaWQlMjIlM0ElMjJzdG9yZUlkJTIyJTJDJTIyZXh0ZW5kX3BhcmFtcyUyMiUzQSU3QiUyMnN5c19zZXJ2aWNlX3Byb3ZpZGVyX2lkJTIyJTNBJTIyMjA4ODMxMTQzNzk1ODY1NiUyMiU3RCUyQyUyMnRpbWVfZXhwaXJlJTIyJTNBJTIyMjAxOC0wNC0yMysxNyUzQTIzJTNBNDIlMjIlN0QmY2hhcnNldD1VVEYtOCZmb3JtYXQ9anNvbiZtZXRob2Q9YWxpcGF5LnRyYWRlLmFwcC5wYXkmbm90aWZ5X3VybD1odHRwcyUzQSUyRiUyRnRzLmtleXRvcC5jbiUyRnBjdGVzdCUyRnNlcnZpY2UlMkZub3RpZnklMkZhbGlwYXkmc2lnbj1JU0RwRlJVM3Y4U3NGJTJGRUl5b0lieE5KOWI1WVA5eUxmVXYlMkZiZzFWVWxwN1dIeVc2QXNBZGtGdTV6WW42JTJCM0UxTXNFaWNxJTJCUTJ2SFA2cjEwWEdDSDdxTFBCWEt6OVBZeSUyQlh2cDNraVYyUVVtajBnb1YzYnFxUVRTTFJlQk56ZkUzejduZFhydXUwN1FkMGR4JTJGdW05bGhzb0JxS3FHTVRkNGkySEl5ZXlMb0ElM0Qmc2lnbl90eXBlPVJTQSZ0aW1lc3RhbXA9MjAxOC0wNC0yMysxNSUzQTAyJTNBMzMmdmVyc2lvbj0xLjAiLCJyZXR1cm5VcmwiOiJodHRwczovL3d3dy5iYWlkdS5jb20vIn0=";
    NSString *WXURL = @"https://cloud.keytop.cn/pc/page/app_pay.html?pay_info=eyJwYXlUeXBlIjoiV1giLCJkYXRhVHlwZSI6IkpTT04iLCJkYXRhIjoie1wiYXBwaWRcIjpcInd4MmNmYjNjNTVhMjg3MTA3N1wiLFwibm9uY2VzdHJcIjpcImYyNDI4Yjc3MDUxZjRhNDZiZjQ1NDYwNDZhMGMxYjc0XCIsXCJwYWNrYWdlXCI6XCJTaWduPVdYUGF5XCIsXCJwYXJ0bmVyaWRcIjpcIjEyMTg3ODY1MDFcIixcInByZXBheWlkXCI6XCJ3eDIzMTIyMjIzNTE4MDA4MjE0ZmMzYzJmYzA5Nzg4Mzg0NzJcIixcInNpZ25cIjpcIjRBMjVENkVFM0UwQ0Y5REMyNzdCRDExNkM2QzZFQkE2XCIsXCJ0aW1lc3RhbXBcIjpcIjE1MjQ0NTczNDRcIn0iLCJyZXR1cm5VcmwiOiJodHRwczovL3d3dy5iYWlkdS5jb20vIn0=";
    NSString *string = arc4random()%2?airUrl:WXURL;
     string = @"https://cloud.keytop.cn/pc/page/payment_confirm.html?parameters=eyJtb2R1bGUiOiJDUCIsImNhdGVnb3J5IjoiUEFSSyIsInBheW1lbnRDb25maWciOiJiZDQ1NDdiZjRkMWY0ZDA0YTAwZjNiMmIwOWMwNjBlOSIsImlubmVyT3JkZXJObyI6IjIwMTgwNTE2Njc1NDgyNSIsInByb2R1Y3Rpb25OYW1lIjoi5YGc6L2m6LS5LemXvVBHMDAwMS3pgJ%2FlgZzovabkupHovablnLoiLCJwcm9kdWN0aW9uRGVzY3JpcHRpb24iOiJf6YCf5YGc6L2m5LqR6L2m5Zy6IiwiZXhwaXJlZFRpbWUiOiIyMDE4LTA1LTE2IDEzOjMzOjQ3IiwiYW1vdW50IjoxLCJzaWduIjoiNTQ2MDdmYTdlNWVmZmRhYTFmNzQwNTMyOGJmNWEzNGQiLCJyZXR1cm5VcmwiOiJodHRwczovL2Nsb3VkLmtleXRvcC5jbi9wYWdlL29yZGVyL2FjY2Vzc19vcmRlcl9wYXlpbmcuaHRtbD9vPTIwMTgwNTE2Njc1NDgyNSZsb3RJZD0xNjMmcGxhdGVObz3pl71QRzAwMDEiLCJjdXN0b21QYXJhbWV0ZXJzIjp7ImxvdElkIjoiMTYzIiwicGxhdGVObyI6IumXvVBHMDAwMSIsInBhcmtpbmdEdXJhdGlvbiI6IiJ9fQ%3D%3D";
    
    [STCPayManager openPayViewController:string withViewController:self];
//    [STCPayManager openPayViewController:string withViewController:self];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
