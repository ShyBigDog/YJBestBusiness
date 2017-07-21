//
//  AppDelegate+First.m
//  YJBestBusiness
//
//  Created by 郑少钦 on 2017/7/18.
//  Copyright © 2017年 YJBest. All rights reserved.
//

#import "AppDelegate+First.h"

@implementation AppDelegate (First)

#pragma mark - 判断App是否首次打开 -
-(void)isAppFirstClose{
    BOOL isFirstLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstLogin"] boolValue];
    if (!isFirstLogin) {
        //是第一次
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isFirstLogin"];
        
        
        //        //静态图引导页
        //        JLTabBarController *tabBarVc = [[JLTabBarController alloc] init];
        //        NSArray *mArray = @[@"1.png",@"2.png",@"3.png"];
        //        JLNewFetureController *vc = [[JLNewFetureController alloc]initWithNSArray:[mArray copy] withButtonSize:CGSizeMake(ScreenWidth-160, 50) withButtonTitle:@"立即体验" withButtonImage:nil withButtonTitleColor:kWhiteColor withButtonHeight:0.85 withViewController:tabBarVc];
        //        self.window.rootViewController = vc;
    }else{
        //不是首次启动
        //        JLTabBarController *tabBarVc = [[JLTabBarController alloc] init];
        //        self.window.rootViewController = tabBarVc;
    }
}

@end
