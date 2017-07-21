//
//  JBestNetworking.m
//  CloudDecorate
//
//  Created by 郑少钦 on 2017/4/28.
//  Copyright © 2017年 com.1jbest.www. All rights reserved.
//

#import "JBestNetworking.h"

#import "MBProgressHUD+Add.h"

#define TIME_NETOUT     20.0f

@implementation JBestNetworking


- (id)init
{
    if (self = [super init])
    {
        _HTTPManager = [AFHTTPSessionManager manager];
        _HTTPManager.requestSerializer.HTTPShouldHandleCookies = YES;
        
        _HTTPManager.requestSerializer  = [AFHTTPRequestSerializer serializer];
        _HTTPManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        [_HTTPManager.requestSerializer setTimeoutInterval:TIME_NETOUT];
        
        //把版本号信息传导请求头中
        [_HTTPManager.requestSerializer setValue:[NSString stringWithFormat:@"iOS-%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]] forHTTPHeaderField:@"MM-Version"];
        
        [_HTTPManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];
        _HTTPManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html", @"text/plain",nil];
        
        
    }
    return self;
}


+ (id)sharedInstance
{
    static JBestNetworking * HTTPCommunicate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HTTPCommunicate = [[JBestNetworking alloc] init];
    });
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"sessionId"]) {
        [HTTPCommunicate.HTTPManager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionId"]  forHTTPHeaderField:@"session-id"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sessionId"];
    }
    return HTTPCommunicate;
}




+ (void)createRequest:(NSString *)URLString
            WithParam:(NSDictionary *)param
           withMethod:(HTTPRequestMethod)method
              success:(void(^)(id result))success
              failure:(void(^)(NSError *erro))failure
              showHUD:(UIView *)showView
{
        [[JBestNetworking sharedInstance] createUnloginedRequest:URLString WithParam:param withMethod:method success:success failure:failure showHUD:showView];
    
}

- (void)createUnloginedRequest:(NSString *)URLString WithParam:(NSDictionary *)param withMethod:(HTTPRequestMethod)method success:(void(^)(id result))success failure:(void(^)(NSError *erro))failure showHUD:(UIView *)showView
{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    /**
     *  请求的时候给一个转圈的状态
     */
    if (showView) {
        [MBProgressHUD showProgress:showView];
    }
    
    NSString *dataUTF8 = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *URL = [NSString stringWithFormat:@"%@%@",URL_BASE,dataUTF8];
    
    NSMutableURLRequest *request = [_HTTPManager.requestSerializer requestWithMethod:[self getStringForRequestType:method] URLString:[[NSURL URLWithString:URL relativeToURL:_HTTPManager.baseURL] absoluteString] parameters:param error:nil];
    
    NSURLSessionDataTask *dataTask = [_HTTPManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            
            if (showView) {
                [MBProgressHUD hideHUDForView:showView];
            }
            
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            if (error.code == -1009) {
                [MBProgressHUD showError:@"网络已断开" toView:window];
            }else if (error.code == -1005){
                [MBProgressHUD showError:@"网络连接已中断" toView:window];
            }else if(error.code == -1001){
                [MBProgressHUD showError:@"请求超时" toView:window];
            }else if (error.code == -1003){
                [MBProgressHUD showError:@"未能找到使用指定主机名的服务器" toView:window];
            }else{
                [MBProgressHUD showError:[NSString stringWithFormat:@"code:%ld %@",error.code,error.localizedDescription] toView:window];
            }
            
            if (failure != nil)
            {
                failure(error);
            }
            
        } else {
            
            if (success != nil)
            {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
                if (showView) {
                    [MBProgressHUD hideHUDForView:showView];
                }
                
                id result = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                
                success(result);
            }
        }
    }];
    
    [dataTask resume];
}

+ (void)createRequest:(NSString *)URLString
            WithParam:(NSDictionary*)param
          withExParam:(NSDictionary*)Exparam
           withMethod:(HTTPRequestMethod)method
              success:(void (^)(id result))success
   uploadFileProgress:(void(^)(NSProgress *uploadProgress))uploadFileProgress
              failure:(void (^)(NSError* erro))failure

{
   
        [[JBestNetworking sharedInstance] createUnloginedRequest:URLString WithParam:param withExParam:Exparam withMethod:method success:success failure:failure uploadFileProgress:uploadFileProgress];
    
}


- (void)createUnloginedRequest:(NSString *)URLString WithParam:(NSDictionary *)param withExParam:(NSDictionary*)Exparam withMethod:(HTTPRequestMethod)method success:(void(^)(id result))success failure:(void(^)(NSError *erro))failure uploadFileProgress:(void(^)(NSProgress *uploadProgress))uploadFileProgress
{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    NSString *dataUTF8 = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *URL = [NSString stringWithFormat:@"%@%@",URL_BASE,dataUTF8];
    
  
    NSMutableURLRequest *request = [_HTTPManager.requestSerializer multipartFormRequestWithMethod:[self getStringForRequestType:method] URLString:URL parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //图片上传
        if (Exparam) {
            for (NSString *key in [Exparam allKeys]) {
                [formData appendPartWithFileData:[Exparam objectForKey:key] name:key fileName:[NSString stringWithFormat:@"%@.png",key] mimeType:@"image/jpeg"];
            }
        }
        
    } error:nil];
    
    NSURLSessionDataTask *dataTask = [_HTTPManager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        if (uploadProgress) { //上传进度
            uploadFileProgress (uploadProgress);
        }
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            
            if (error.code == -1009) {
                [MBProgressHUD showError:@"网络已断开" toView:window];
            }else if (error.code == -1005){
                [MBProgressHUD showError:@"网络连接已中断" toView:window];
            }else if(error.code == -1001){
                [MBProgressHUD showError:@"请求超时" toView:window];
            }else if (error.code == -1003){
                [MBProgressHUD showError:@"未能找到使用指定主机名的服务器" toView:window];
            }else{
                [MBProgressHUD showError:[NSString stringWithFormat:@"code:%ld %@",error.code,error.localizedDescription] toView:window];
            }
            
            if (failure != nil)
            {
                failure(error);
            }
            
        } else {
            
            if (success != nil)
            {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
                id result = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                
                success(result);
            }
        }
        
    }];
    
    [dataTask resume];
}

+ (void)createDownloadFileWithURLString:(NSString *)URLString
                   downloadFileProgress:(void(^)(NSProgress *downloadProgress))downloadFileProgress
                          setupFilePath:(NSURL*(^)(NSURLResponse *response))setupFilePath
              downloadCompletionHandler:(void (^)(NSURL *filePath, NSError *error))downloadCompletionHandler
{
    if (URLString) {
        [[JBestNetworking sharedInstance]createUnloginedDownloadFileWithURLString:URLString downloadFileProgress:downloadFileProgress setupFilePath:setupFilePath downloadCompletionHandler:downloadCompletionHandler];
    }
}

- (void)createUnloginedDownloadFileWithURLString:(NSString *)URLString
                            downloadFileProgress:(void(^)(NSProgress *downloadProgress))downloadFileProgress
                                   setupFilePath:(NSURL*(^)(NSURLResponse *response))setupFilePath
                       downloadCompletionHandler:(void (^)(NSURL *filePath, NSError *error))downloadCompletionHandler
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:1 timeoutInterval:15];
    
    NSURLSessionDownloadTask *dataTask = [_HTTPManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        /**
         *  下载进度
         */
        downloadFileProgress(downloadProgress);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        /**
         *  设置保存目录
         */
        
        return setupFilePath(response);
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        /**
         *  下载完成
         */
        downloadCompletionHandler(filePath,error);
        
    }];
    
    [dataTask resume];
}

#pragma mark - GET Request type as string

-(NSString *)getStringForRequestType:(HTTPRequestMethod)type {
    
    NSString *requestTypeString;
    
    switch (type) {
        case POST:
            requestTypeString = @"POST";
            break;
            
        case GET:
            requestTypeString = @"GET";
            break;
            
        case PUT:
            requestTypeString = @"PUT";
            break;
            
        case DELETE:
            requestTypeString = @"DELETE";
            break;
            
        default:
            requestTypeString = @"POST";
            break;
    }
    
    return requestTypeString;
}

-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


@end
