//
//  HttpCommunicateDefine.h
//  CloudDecorate
//
//  Created by 郑少钦 on 2017/4/28.
//  Copyright © 2017年 com.1jbest.www. All rights reserved.
//

#ifndef HttpCommunicateDefine_h
#define HttpCommunicateDefine_h

/*
 IS_DEBUG  1 测试环境
           2 预发布环境
           3 正式环境
 */

#define IS_DEBUG  1

#if IS_DEBUG==1
#define URL_BASE          @"https://yj.1jbest.com:8888/mobile-service/"
#elif IS_DEBUG==2
#define URL_BASE          @"http://mapi.1jbest.com:8082/temp/"
#else
#define URL_BASE          @"https://mapi.1jbest.com:8443/new/"
#endif


static NSString *const LoginUrl = @"system/multiMobileLogin";//登录
static NSString *const GetLoginUrl = @"system/getLoginInfo";//获取登录信息


#endif
