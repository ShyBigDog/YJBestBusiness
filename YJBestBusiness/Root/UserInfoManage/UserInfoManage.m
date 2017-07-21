//
//  UserInfoManage.m
//  CloudDecorate
//
//  Created by 郑少钦 on 2017/4/28.
//  Copyright © 2017年 com.1jbest.www. All rights reserved.
//

#import "UserInfoManage.h"

@implementation UserInfoManage

+ (UserInfoManage *)sharedInstance {
    static dispatch_once_t onceToken;
    static UserInfoManage *sharedInstace = nil;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
    });

    return sharedInstace;
}


@end
