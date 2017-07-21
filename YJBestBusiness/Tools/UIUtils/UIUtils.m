#import <sys/utsname.h>
#import "UIUtils.h"


@implementation UIUtils

// 获取documents下的文件路径
+ (NSString *)getDocumentsPath:(NSString *)fileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    
    return path;
}

// 获取设备型号
+ (NSString*)getDeviceString {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString rangeOfString:@"iPhone1,1"].location != NSNotFound)    return @"iPhone 2G";
    if ([deviceString rangeOfString:@"iPhone1,2"].location != NSNotFound)    return @"iPhone 3G";
    if ([deviceString rangeOfString:@"iPhone2,1"].location != NSNotFound)    return @"iPhone 3GS";
    if ([deviceString rangeOfString:@"iPhone3"].location != NSNotFound)    return @"iPhone 4";
    if ([deviceString rangeOfString:@"iPhone4"].location != NSNotFound)    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"] || [deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"] || [deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([deviceString rangeOfString:@"iPhone6"].location != NSNotFound)    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s plus";
    
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"]||[deviceString isEqualToString:@"iPad2,2"]||[deviceString isEqualToString:@"iPad2,3"]||[deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"]||[deviceString isEqualToString:@"iPad2,6"]||[deviceString isEqualToString:@"iPad2,7"])      return @"iPad 2 Mini";
    if ([deviceString isEqualToString:@"iPad3,1"]||[deviceString isEqualToString:@"iPad3,2"]||[deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"]||[deviceString isEqualToString:@"iPad3,5"]||[deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad4,1"]||[deviceString isEqualToString:@"iPad4,2"]||[deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,4"]||[deviceString isEqualToString:@"iPad4,5"]||[deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";

    return deviceString;
}

// 获取UUID
+ (NSString *)getUUID {
    
    NSMutableDictionary *readUsernamePassword = (NSMutableDictionary *)[AR_Keychain load:KEY_USERNAME_PASSWORD];
    NSString *userName = [readUsernamePassword objectForKey:KEY_USERNAME];
    NSString *uuid = [readUsernamePassword objectForKey:KEY_PASSWORD];
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (userName == nil || uuid == nil) {
        uuid = [[NSUUID UUID] UUIDString];
        NSMutableDictionary *userNamePasswordKVPairs = [NSMutableDictionary dictionary];
        [userNamePasswordKVPairs setObject:@"jBesteasyLive" forKey:KEY_USERNAME];
        [userNamePasswordKVPairs setObject:uuid forKey:KEY_PASSWORD];
        
        [AR_Keychain save:KEY_USERNAME_PASSWORD data:userNamePasswordKVPairs];
    }
    
    return uuid;
}

// 删除UserDefault全部数据
+ (void)removeObjectInUserDefault {
    
    // 获取UserDefault键值对,存储为NSDictionary
    NSDictionary *userDefaultDictionary = [USER_DEFAULT dictionaryRepresentation];
    NSArray *keyArray = [userDefaultDictionary allKeys];
    
    for (NSString *key in keyArray) {
        [USER_DEFAULT removeObjectForKey:key];
    }
    [USER_DEFAULT synchronize];
}

// 根据StoryBoard名与Indentifer,得到目标控制器
+ (UIViewController *)getControllerInStoryBroad:(NSString *)storyBroad withIdentifier:(NSString *)identifier {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyBroad bundle:[NSBundle mainBundle]];
    UIViewController *nextViewController = [storyboard instantiateViewControllerWithIdentifier:identifier];
    
    return nextViewController;
}
    
// 根据Xib名得到目标视图
+ (UIView *)getViewFromNib:(NSString *)nib {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nib owner:nil options:nil];
    UIView *view = [nibContents firstObject];
    return view;
}


@end
