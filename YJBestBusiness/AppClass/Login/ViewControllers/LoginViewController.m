//
//  LoginViewController.m
//  YJBestBusiness
//
//  Created by 郑少钦 on 2017/7/19.
//  Copyright © 2017年 YJBest. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabBarController.h"
#import "AppConfig.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)loginAction:(id)sender {
    
    NSDictionary *parameter = @{@"account":@"15559110988",
                                @"password":@"123456"};
    [JBestNetworking createRequest:LoginUrl WithParam:parameter withMethod:POST success:^(id result) {
        
        if (result) {
            NSLog(@"result:%@",result);
            if ([result[@"backView"][@"status"] intValue] == 200) {
                [[NSUserDefaults standardUserDefaults]setObject:result[@"sessionId"] forKey:@"sessionId"];
                
                MainTabBarController *vc = (MainTabBarController *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                [UIApplication sharedApplication].keyWindow.rootViewController = vc;
            }
        }
    } failure:^(NSError *erro) {
        
    } showHUD:self.view];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
