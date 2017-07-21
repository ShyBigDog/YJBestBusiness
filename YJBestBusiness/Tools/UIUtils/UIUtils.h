//
//  UIUtils.h
//  WXTime
//
//  Created by wei.chen on 12-7-22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "TimeTools.h"
#import "NSStringTools.h"

#import "GTCommontHeader.h" //以标准iphone5屏幕缩放的宽高
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "UIViewExt.h"
#import "UIColor+CreateMethods.h"

#import "AR_Keychain.h" //UUID
#import "UIUtils.h"

#import "AppConfig.h"


@interface UIUtils : NSObject

// 获取documents下的文件路径
+ (NSString *)getDocumentsPath:(NSString *)fileName;

// 获取设备型号
+ (NSString *)getDeviceString;
// 获取UUID
+ (NSString *)getUUID;
// 删除UserDefault全部对象
+ (void)removeObjectInUserDefault;

// 根据StoryBoard名与Indentifer,得到目标控制器
+ (UIViewController *)getControllerInStorybroad:(NSString *)sb withIdentifier:(NSString *)identifier;
// 根据Xib名得到目标视图
+ (UIView *)getViewFromNib:(NSString *)nib;

@end
