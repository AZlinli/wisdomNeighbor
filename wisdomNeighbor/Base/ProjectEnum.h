//
//  IKCommon.h
//  Erp4iOS
//
//  Created by rztime on 2017/11/17.
//  Copyrig
//

#ifndef IKCommon_h
#define IKCommon_h
static NSString *const XKToolsBottomSheetViewDismissNotification = @"XKToolsBottomSheetViewDismissNotification";


static NSString *const FriendPageReloadNotification = @"FriendPageReloadNotification";


typedef NS_ENUM(NSInteger, RefreshDataStatus) {
	Refresh_HasDataAndHasMoreData = 1, // 当前有数据 && 还有更多数据 --> 设置
	Refresh_NoDataOrHasNoMoreData = 2, //  当前无数据 || 当前有数据但是没有更多数据 --> 设置
	Refresh_NoNet 				= 3 // 网络失败 -->设置
};

typedef NS_ENUM(NSInteger, MineResidentRedactVCTyoe) {
    MineResidentRedactVCTyoeAdd = 1, // 添加住户
    MineResidentRedactVCTyoeChange = 2, //  编辑住户
};

typedef NS_ENUM(NSInteger, loginVCTyoe) {
    loginVCTyoeLogin = 1, // 登录
    loginVCTyoeTourist = 2, //  游客登录
};

typedef NS_ENUM(NSInteger, PersonalVcType) {
    personalVcTypeMine = 1, // 自己的个人资料
    personalVcTypeOther = 2, //  别人的
};
//************ 无数据占位图 ***************//
// 通用无数据占位
#define kEmptyPlaceImgName @"xk_ic_default_noData"
// 地址为空
#define kEmptyPlaceForAddressImgName @"xk_ic_recipient_empty"
// 发票为空
#define kEmptyPlaceForReceiptImgName @"发票为空_empty"
// 粉丝关注为空
#define kEmptyPlaceForFansFocusImgName @"粉丝关注为空_empty"
// 购物车空空如也
#define kEmptyPlaceForBuyCarImgName @"购物车空空如也_empty"
// 获赞为空
#define kEmptyPlaceForFavorImgName @"获赞为空_empty"
// 收藏为空
#define kEmptyPlaceForCollectImgName @"收藏_empty"
// 搜索为空
#define kEmptyPlaceForSearchImgName @"搜索为空_empty"
// 订单为空
#define kEmptyPlaceForOrderImgName @"暂无订单_empty"
// 暂无消息
#define kEmptyPlaceForMsgImgName @"暂无消息_empty"
// 暂无优惠券
#define kEmptyPlaceForDiscountTicketImgName @"xk_ic_coupon_package_empty"


//*************错误占位**************//
// 服务器错误占位图 1.
#define kNetErrorPlaceImgName @"xk_ic_default_netError"


/**默认占位头像*/
#define kDefaultHeadImgName @"xk_ic_defult_head"
#define kDefaultHeadImg   [UIImage imageNamed:kDefaultHeadImgName]
/**默认正方占位图*/
#define kDefaultPlaceHolderImgName @"xk_ic_defult_zf_Img"
#define kDefaultPlaceHolderImg   [UIImage imageNamed:kDefaultPlaceHolderImgName]
/**默认矩形占位图*/
#define kDefaultPlaceHolderRectImgName @"xk_ic_defult_cf_Img"
#define kDefaultPlaceHolderRectImg   [UIImage imageNamed:kDefaultPlaceHolderImgName]


#define kBannerDefaultPlaceHolderRectImgName @"xk_icon_banner_backDefault"
#define kBannerDefaultPlaceHolderRectImg     [UIImage imageNamed:kBannerDefaultPlaceHolderRectImgName]

#define kQCloudSecretID @"AKIDQmxHUaKWF9vFSWtBmBOwMadVBf1CfyY1"
#define kQCloudSecretKey @"SjpjS3Vn7GDyXu53rX3NXWKyQhmhT5Vj"
#define kQCloudAppID @"1251461298"
#define kQCloudRegion @"ap-chengdu"
#define kQCloudBucket @"menjin-1251461298"
#define kIMKey        @"82hegw5u8x7fx"

#define BaiduMapAppKey @"rg4A0uE6Cq4904GuCGsxpvTTGurLVNgR"    //百度地图appkey

#endif
