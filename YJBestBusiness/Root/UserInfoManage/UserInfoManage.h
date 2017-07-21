//
//  UserInfoManage.h
//  CloudDecorate
//
//  Created by 郑少钦 on 2017/4/28.
//  Copyright © 2017年 com.1jbest.www. All rights reserved.
//
/****   NSUserDefaults  保存本地的信息  ****
 sessionId //登录成功保存，添加到请求头之后删除
 
*/


#import <Foundation/Foundation.h>

@interface UserInfoManage : NSObject

+ (UserInfoManage *)sharedInstance;

@property (nonatomic, assign) BOOL       isLogin;

@property (nonatomic, assign) NSUInteger lastselectedIndex;

@end
