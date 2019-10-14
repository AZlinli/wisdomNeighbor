/*******************************************************************************
 # File        : XKInfoProvider.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2019/2/28
 # Corporation :  水木科技
 # Description :

 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/


#import "XKInfoProvider.h"

@implementation XKInfoProvider

+ (XKInfoProvider *)shareProvider {
    static XKInfoProvider *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[XKInfoProvider alloc] init];
    });
    return _instance;
}

+ (void)providerConfig:(void (^)(XKInfoProvider *))providerConfig {
    providerConfig([XKInfoProvider shareProvider]);
}




@end
