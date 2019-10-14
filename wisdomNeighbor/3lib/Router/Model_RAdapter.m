/*******************************************************************************
 # File        : ModelDynamic.m
 # Project     : Pods
 # Author      : Jamesholy
 # Created     : 2019/5/9
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "Model_RAdapter.h"
#import "YYModel.h"

@implementation Model_RAdapter

+ (void)jumpRemoteWithParams:(NSDictionary *)params Parent:(UIViewController *)vc {
    // runtime 动态
    NSString *targetVCStr = params[kRouterTargetClass];
    if (targetVCStr) {
        UIViewController *targetVC = nil;
        if (params[kRouterStoryboard]) {
            // 支持 Storyboard 获取控制器实例
            UIStoryboard *story = [UIStoryboard storyboardWithName:params[kRouterStoryboard] bundle:[NSBundle mainBundle]];
            NSString *identifier = params[kRouterIdentifier];
            targetVC = [story instantiateViewControllerWithIdentifier:identifier];
        }
        if (!targetVC) {
            // 尝试 xib 初始化
            if (params[kRouterXibName]) {
                targetVC = [[NSClassFromString(targetVCStr) alloc] initWithNibName:params[kRouterXibName] bundle:[NSBundle mainBundle]];
            }
        }
        if (!targetVC) {
            // 代码 创建控制器
            id obj = [NSClassFromString(targetVCStr) new];
            if (obj && [obj isKindOfClass:[UIViewController class]]) {
                targetVC = (UIViewController *)obj;
            }
        }
        if (!targetVC) {
            // 不存在oc下代码方式创建的vc, 再次考虑寻找swift下的vc，由于工程内，无swift文件，所以这里暂时未实现。
            return;
        }
        NSDictionary * propertyClassMap;
        NSArray *propertyNameArray = [XKRouter propertyListByClass:NSClassFromString(targetVCStr) propertyClassMap:&propertyClassMap];
        @try {
            for (NSString *property in propertyNameArray) {
                NSString *key = [[property componentsSeparatedByString:@"-"] firstObject];
                NSString *type = [[property componentsSeparatedByString:@"-"] lastObject];
                if (params[key]) {
                    // 32位操作系统，iphone5 没有该 [__NSCFString charValue]
                    if ([type isEqualToString:kRouterBoolType]) {
                        NSInteger boolEle = 0;
                        // 兼容 true 和 false
                        if ([params[key] isEqualToString:kRouterBoolTrue]) {
                            boolEle = 1;
                        }else if ([params[key] isEqualToString:kRouterBoolFalse]) {
                            boolEle = 0;
                        }else {
                            boolEle = [params[key] integerValue];
                        }
                        [targetVC setValue:@(boolEle) forKey:key];
                    }else{
                        id proproValue = params[key];
                        if ([proproValue isKindOfClass:[NSDictionary class]]) {
                            NSString *className = propertyClassMap[key];
                            Class propertyClass = NSClassFromString(className);
                            if (propertyClass) {
                                [targetVC setValue:[propertyClass yy_modelWithJSON:proproValue] forKey:key];
                            } else {
                                [targetVC setValue:proproValue forKey:key];
                            }
                        } else {
                          [targetVC setValue:params[key] forKey:key];
                        }
                    }
                }
            }
            [vc.navigationController pushViewController:targetVC animated:YES];
            
        } @catch (NSException *exception) {
            NSLog(@"处理远程url，动态跳转异常。-- %@",exception);
        } @finally {
            return;
        }
    }
}
@end
