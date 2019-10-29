//
//  GlobleCommonTool.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/22.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "GlobleCommonTool.h"
#import "BigPhotoPreviewBaseController.h"
#import "PhotoPreviewModel.h"
#import "FriendCircleListViewController.h"

@implementation GlobleCommonTool
+ (void)showBigImgWithImgsArr:(NSArray *)arr defualtIndex:(NSInteger)index viewController:(UIViewController *)viewController {
    if (!arr.count) {
        return;//容错处理
    }
    if (index >= arr.count) {
        index = 0;//容错处理
    }
    NSMutableArray *models = [NSMutableArray array];
    for (id img in arr) {
        PhotoPreviewModel *model = [[PhotoPreviewModel alloc] init];
        if ([img isKindOfClass:[NSString class]]) {
            model.imageURL = img;
        } else if([img isKindOfClass:[UIImage class]]) {
            model.thumbImage = img;
        }
        [models addObject:model];
    }
    BigPhotoPreviewBaseController *photoPreviewController = [[BigPhotoPreviewBaseController alloc] init];
    photoPreviewController.models = models;
    photoPreviewController.isSupportLongPress = YES;
    photoPreviewController.isShowNav = YES;
    photoPreviewController.isShowTitle = YES;
    photoPreviewController.strNavTitle = @"";
    photoPreviewController.isHiddenDeleteButton = YES;
    photoPreviewController.isShowStatusBar = YES;
    photoPreviewController.currentIndex = index;
    
    [viewController presentViewController:photoPreviewController animated:YES completion:nil];
}


+ (void)getCurrentDate {
    NSLog(@"--------------------%ld", (long)[self getCurrentHour]);
    
    NSInteger currentHour = [GlobleCommonTool getCurrentHour];
    [[NSUserDefaults standardUserDefaults]setInteger:currentHour forKey:@"currentHour"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

+ (NSDateComponents *)getCurrentYearMonthDay:(unsigned int)calendarUnit {
    NSDate *date = [NSDate date];//这个是NSDate类型的日期，所要获取的年月日都放在这里；
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    //这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
    unsigned int unitFlags = calendarUnit;
    //把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    NSDateComponents *d = [cal components:unitFlags fromDate:date];
    return d;
}

+ (NSInteger)getCurrentHour {
    return [[GlobleCommonTool getCurrentYearMonthDay:kCFCalendarUnitHour]hour];
}

+ (void)configTimeHourWith:(UIImageView *)bgImageView {
    NSInteger currentHour = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentHour"];
    NSString *imageName;
    if (6 < currentHour && currentHour < 18) {
        imageName = @"hour_101.jpg";
    }else{
        imageName = @"hour_100.jpg";
    }
//    imageName = [NSString stringWithFormat:@"hour_%ld.jpg",currentHour];
    bgImageView.image = [UIImage imageNamed:imageName];
}

+ (void)jumpCircleListWithUserId:(NSString *)userId name:(NSString *)name headerIcon:(NSString *)headerIcon{
    FriendCircleListViewController *vc = [FriendCircleListViewController new];
    vc.userId = userId;
    vc.name = name;
    vc.headerIcon = headerIcon;
    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

+ (void)jumpPersonalDataWithUserId:(NSString *)userId name:(NSString *)name headerIcon:(NSString *)headerIcon{
    PersonalDataViewController *vc = [PersonalDataViewController new];
    vc.name = name;
    vc.headerIcon = headerIcon;
    vc.userId = userId;
    if ([[LoginModel currentUser].currentHouseId isEqualToString:userId]) {
        vc.vcType = personalVcTypeMine;
    }else{
        vc.vcType = personalVcTypeOther;
    }
    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

+ (void)jumpToPersonalDataOrCircleListWithUserId:(NSString *)userId name:(NSString *)name headerIcon:(NSString *)headerIcon {
    if ([[LoginModel currentUser].currentHouseId isEqualToString:userId]) {
        [GlobleCommonTool jumpCircleListWithUserId:userId name:name headerIcon:headerIcon];
    }else{
        [GlobleCommonTool jumpPersonalDataWithUserId:userId name:name headerIcon:headerIcon];
    }
}
@end
