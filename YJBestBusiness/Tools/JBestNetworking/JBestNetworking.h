//
//  JBestNetworking.h
//  CloudDecorate
//
//  Created by 郑少钦 on 2017/4/28.
//  Copyright © 2017年 com.1jbest.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpCommunicateDefine.h"
#import "AFHTTPSessionManager.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger , HTTPRequestMethod)
{
    POST = 0,
    GET,
    PUT,
    DELETE
};

@interface JBestNetworking : NSObject

@property (nonatomic,strong) AFHTTPSessionManager *HTTPManager;

+ (id)sharedInstance;


/**
 *  HTTP请求
 *
 *  @param URLString 服务器提供的接口
 *  @param param    传的参数
 *  @param method   GET,POST,DELETE,PUT方法
 *  @param success  请求完成
 *  @param failure  请求失败
 *  @param showView 界面上显示的网络加载进度状态(nil为不显示)
 */
+ (void)createRequest:(NSString *)URLString
            WithParam:(NSDictionary *)param
           withMethod:(HTTPRequestMethod)method
              success:(void(^)(id result))success
              failure:(void(^)(NSError *erro))failure
              showHUD:(UIView *)showView;


/**
 *  上传文件功能，如图片等
 *
 *  @param URLString          服务器提供的接口
 *  @param param              传的参数
 *  @param Exparam            文件流，将要上传的文件转成NSData中，然后一起传给服务器
 *  @param method             GET,POST,DELETE,PUT方法
 *  @param success            请求完成
 *  @param uploadFileProgress 请求图片的进度条，百分比
 *  @param failure            请求失败
 */
+ (void)createRequest:(NSString *)URLString
            WithParam:(NSDictionary*)param
          withExParam:(NSDictionary*)Exparam
           withMethod:(HTTPRequestMethod)method
              success:(void (^)(id result))success
   uploadFileProgress:(void(^)(NSProgress *uploadProgress))uploadFileProgress
              failure:(void (^)(NSError* erro))failure;

/**
 *  下载文件功能
 *
 *  @param URLString                 要下载文件的URL
 *  @param downloadFileProgress      下载的进度条，百分比
 *  @param setupFilePath             设置下载的路径
 *  @param downloadCompletionHandler 下载完成后（下载完成后可拿到存储的路径）
 */
+ (void)createDownloadFileWithURLString:(NSString *)URLString
                   downloadFileProgress:(void(^)(NSProgress *downloadProgress))downloadFileProgress
                          setupFilePath:(NSURL*(^)(NSURLResponse *response))setupFilePath
              downloadCompletionHandler:(void (^)(NSURL *filePath, NSError *error))downloadCompletionHandler;

@end
