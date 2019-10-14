/*******************************************************************************
 # File        : XKFriendTalkContentView.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/17
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendTalkContentView.h"
#import "XKFriendTalkImgView.h"
#import "XKFriendCircleShareContentView.h"
//#import "XKShareItemJumper.h"

typedef NS_ENUM(NSInteger,XKFriendTalkContentDisplayType) {
    XKFriendTalkContentDisplayTextType ,// 纯文本
    XKFriendTalkContentDisplayImgType ,// 文本+图片
    XKFriendTalkContentDisplayShareType,// 分享类型
};

@interface XKFriendTalkContentView ()
/**宽度*/
@property(nonatomic, assign) CGFloat initWidth;
/**说说内容*/
@property(nonatomic, strong) UILabel *talkLabel;
/**展开收起按钮*/
@property(nonatomic, strong) UIButton *foldBtn;
/**图片父视图*/
@property(nonatomic, strong) XKFriendTalkImgView *imgView;
/**分享视图*/
@property(nonatomic, strong) XKFriendCircleShareContentView *shareView;

@property(nonatomic, assign) XKFriendTalkContentDisplayType displayType;
@end

@implementation XKFriendTalkContentView

#pragma mark - 初始化
- (instancetype)initWithWidth:(CGFloat)width showType:(NSString *)displayType {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.initWidth = width;
        if ([displayType isEqualToString:normalTextCellId]) {
            self.displayType = XKFriendTalkContentDisplayTextType;
        } else if ([displayType isEqualToString:imgTextCellId]) {
            self.displayType = XKFriendTalkContentDisplayImgType;
        } else if ([displayType isEqualToString:shareTextCellId]) {
            self.displayType = XKFriendTalkContentDisplayShareType;
        } else  {
            self.displayType = XKFriendTalkContentDisplayTextType;
        }
        self.backgroundColor = [UIColor whiteColor];
        // 初始化默认数据
        [self createDefaultData];
        // 初始化界面
        [self createUI];
        // 布局界面
        [self createConstraints];
    }
    return self;
}
#pragma mark - 初始化默认数据
- (void)createDefaultData {

}
- (void)longPressAction:(UIGestureRecognizer *)sender {
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.content;
    [XKHudView showSuccessMessage:@"复制成功!"];
}
#pragma mark - 初始化界面
- (void)createUI {
    __weak typeof(self) weakSelf = self;
    /**说说*/
    _talkLabel = [[UILabel alloc] init];
    _talkLabel.numberOfLines = 0;
    _talkLabel.userInteractionEnabled = YES;
    UILongPressGestureRecognizer * longP = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [_talkLabel addGestureRecognizer:longP];
    _talkLabel.font = kFontSize6(kFriendTalkContentFont);
    [self addSubview:_talkLabel];
    
    _foldBtn = [[UIButton alloc] init];
    [_foldBtn setTitleColor:HEX_RGB(0x222222) forState:UIControlStateNormal];
    _foldBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    NSAttributedString *att = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
        confer.text(@"展开 ").textColor(HEX_RGB(0x222222)).font(XKNormalFont(12));
        confer.appendImage(IMG_NAME(@"xk_btn_mall_ticket_down")).bounds(CGRectMake(0, -1, 12, 12));
    }];
    NSAttributedString *att1 = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
        confer.text(@"收起 ").textColor(HEX_RGB(0x222222)).font(XKNormalFont(12));;
        confer.appendImage(IMG_NAME(@"xk_btn_mall_ticket_top")).bounds(CGRectMake(0, -1, 12, 12));
    }];
    [_foldBtn setAttributedTitle:att forState:UIControlStateNormal];
    
    [_foldBtn setAttributedTitle:att1 forState:UIControlStateSelected];
    _foldBtn.titleLabel.font = XKNormalFont(12);
    [_foldBtn addTarget:self action:@selector(foldClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_foldBtn];
    _foldBtn.clipsToBounds = YES;
    
    if (self.displayType == XKFriendTalkContentDisplayTextType) {
        //
    } else if (self.displayType == XKFriendTalkContentDisplayImgType) {
        _imgView = [[XKFriendTalkImgView alloc] initWithWidth:self.initWidth];
        [self addSubview:_imgView];
        [_imgView setRefreshBlock:^(NSIndexPath *indexPath) {
            EXECUTE_BLOCK(weakSelf.refreshBlock,indexPath);
        }];
    } else if (self.displayType == XKFriendTalkContentDisplayShareType) {
        _shareView = [XKFriendCircleShareContentView new];
        [_shareView bk_whenTapped:^{
            [weakSelf shareClick];
        }];
        [self addSubview:_shareView];
    }
}

#pragma mark - 布局界面
- (void)createConstraints {
    /**说说父视图*/
    [_talkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(0);
    }];
    [_foldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.talkLabel);
        make.top.equalTo(self.talkLabel.mas_bottom);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(40);
    }];
    if (self.displayType == XKFriendTalkContentDisplayTextType) {
        [_foldBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
        }];
    } else if (self.displayType == XKFriendTalkContentDisplayImgType) {
        /**自定义内容view*/
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.foldBtn.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self);
        }];
    } else if (self.displayType == XKFriendTalkContentDisplayShareType) {
        /**自定义内容view*/
        [_shareView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.foldBtn.mas_bottom).offset(6);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@45);
            make.bottom.equalTo(self);
        }];
    }
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setModel:(FriendTalkModel *)model {
    _model = model;
    self.talkLabel.attributedText = model.contentAtt;
    if (self.contentNeedFold == YES) { // 需要显示折叠状态的情况
        [_talkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(model.contentHeight);
        }];
        if (model.contentNeedFold && self.contentNeedFold == YES) {
            [self.foldBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@18);
                make.top.equalTo(self.talkLabel.mas_bottom).offset(8);
            }];
            _foldBtn.selected = model.contentFoldStatus;
        } else {
            [self.foldBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
                make.top.equalTo(self.talkLabel.mas_bottom).offset(0);
            }];
        }
    } else { // 直接显示全部的情况
        model.contentFoldStatus = YES;
        [_talkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(model.contentHeight);
        }];
        [self.foldBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
            make.top.equalTo(self.talkLabel.mas_bottom).offset(0);
        }];
    }
    if (self.displayType == XKFriendTalkContentDisplayTextType) {
        [_foldBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
        }];
    } else if (self.displayType == XKFriendTalkContentDisplayImgType) {
        self.imgView.model = model;
    } else if (self.displayType == XKFriendTalkContentDisplayShareType) {
//        [self.shareView.imageView sd_setImageWithURL:kURL(model.shareContent.showPic) placeholderImage:kDefaultPlaceHolderImg];
//        self.shareView.contentLabel.text = model.shareContent.describe;
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    self.imgView.indexPath = indexPath;
}

- (void)foldClick {
    self.model.contentFoldStatus = !self.model.contentFoldStatus;
    self.refreshBlock(self.indexPath);
}

#pragma mark - 分享点击

- (void)shareClick {
//    NSDictionary *extrasDic = self.model.shareContent.getExtrasDic;
//    [XKFriendTalkContentView shareContentClickWithShareType:self.model.shareContent.shareType extrasDic:extrasDic];
}

+ (void)shareContentClickWithShareType:(NSInteger)shareType extrasDic:(NSDictionary *)extrasDic {
//
//    switch (shareType) {
//        case XKFriendCircleShareGoodsType: {
//            NSString *h5Url = extrasDic[@"h5Url"];
//            NSString *shareCode;
//            if (h5Url && h5Url.length) {
//                shareCode = [h5Url getURLParameters][@"securityCode"];
//            }
//            [XKShareItemJumper jumpGoodsWithGoodsId:extrasDic[@"goodsId"] shareCode:shareCode];
//        }
//            break;
//        case XKFriendCircleShareTradingAreaType:
//            [XKShareItemJumper jumpTradingShopWithShopId:extrasDic[@"shopId"]];
//            break;
//        case XKFriendCircleShareTradingGoodsType:
//            [XKShareItemJumper jumpTradingShopGoodsWithShopId:extrasDic[@"shopId"] goodsId:extrasDic[@"goodsId"] goodsTypeId:extrasDic[@"goodsTypeId"]];
//            break;
//        case XKFriendCircleShareWelfareForGoodsType:
//            [XKShareItemJumper jumpWelfareForGoodsWithGoodsId:extrasDic[@"goodsId"] sequenceId:extrasDic[@"sequenceId"]];
//            break;
//        case XKFriendCircleShareWelfareForPlatformType:
//            [XKShareItemJumper jumpWelfareForPlatformWithOrderId:extrasDic[@"orderId"] sequenceId:extrasDic[@"sequenceId"]];
//            break;
//        case XKFriendCircleShareWelfareForShopType:
//            [XKShareItemJumper jumpWelfareForShopWithOrderId:extrasDic[@"orderId"] sequenceId:extrasDic[@"sequenceId"]];
//            break;
//        case XKFriendCircleShareGameType:
//            [XKShareItemJumper jumpGameWithGameId:extrasDic[@"gameId"]];
//            break;
//        case XKFriendCircleSharePersonalPageType:
//            [XKShareItemJumper jumpUserPageWithUserId:extrasDic[@"userId"]];
//            break;
//        case XKFriendCircleShareWinDetailForGoodsType:
//            [XKShareItemJumper jumpWinDetailForGoodsWithGoodsId:extrasDic[@"goodsId"] sequenceId:extrasDic[@"sequenceId"] orderId:extrasDic[@"orderId"]];
//            break;
//        case XKFriendCircleShareWinDetailForPlatformType:
//            [XKShareItemJumper jumpWinDetailForPlatformWithGoodsId:extrasDic[@"goodsId"] sequenceId:extrasDic[@"sequenceId"] orderId:extrasDic[@"orderId"]];
//            break;
//        case XKFriendCircleShareWinDetailForShopType:
//            [XKShareItemJumper jumpWinDetailForShopWithGoodsId:extrasDic[@"goodsId"] sequenceId:extrasDic[@"sequenceId"] orderId:extrasDic[@"orderId"]];
//            break;
//        case XKFriendCircleShareInformationType:
//            [XKShareItemJumper jumpInformationWithUrl:extrasDic[@"url"]];
//            break;
//        case XKFriendCircleShareVideoType:
//            [XKShareItemJumper jumpLittleVideoWithVideoId:extrasDic[@"videoId"]];
//            break;
//        default:
//            break;
//    }
}


@end
