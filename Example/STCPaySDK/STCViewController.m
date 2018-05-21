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
//#import <STCPaySDK/STCPayManager.h>
#import <STCPayCode/STCPayManager.h>
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
    [STCPayManager setAliPayScheme:@"zhifubao"];

    
    
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)buttonEvent:(id)sender {
    NSString *string = @"";
    string = @"";
    [STCPayManager openPayViewController:string withViewController:self];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
