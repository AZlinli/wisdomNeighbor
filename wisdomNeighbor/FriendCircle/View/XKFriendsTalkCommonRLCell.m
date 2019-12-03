/*******************************************************************************
 # File        : XKFriendsTalkBaseCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/8/24
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendsTalkCommonRLCell.h"
#import <BlocksKit+UIKit.h>
#import <RZColorful.h>
#import "YYText.h"
#import "XKFriendMenuView.h"
#import "XKFriendCicleToolView.h"
#import "XKFriendTalkContentView.h"

static CGFloat xkFriendTalkContentMaxHeight = 0;
#define kFoldBtnHeight 30

#define kCommentFontSize 14
#define kCommentLineSpace 4

#define kCommentTop 5
#define kCommentleft (10+46+10)
#define kCommentRight 10
#define kCommentBottom 5

#define kBtmContentWidth (SCREEN_WIDTH - kFMargin * 2 - kCommentleft - 15 * 2  - kCommentRight)

@interface XKFriendsTalkCommonRLCell () {
    UIView *_seperateLine;
}

/**头像*/
@property(nonatomic, strong) UIImageView *headerImageView;
/**名字*/
@property(nonatomic, strong) UILabel *nameLabel;
/**说说内容视图*/
@property(nonatomic, strong) XKFriendTalkContentView *talkContentView;
/**工具条*/
@property(nonatomic, strong) XKFriendCicleToolView *toolView;
/**底部点赞评论父视图*/
@property(nonatomic, strong) UIView *bottomView;
/**点赞*/
@property(nonatomic, strong) YYLabel *favorLabel;
/**地址*/
@property(nonatomic, strong) UILabel *addessLabel;
/**标签1*/
@property(nonatomic, strong) UILabel *tagLabel1;
/**标签2*/
@property(nonatomic, strong) UILabel *tagLabel2;
/**弹出点赞View*/
@property (nonatomic, strong) QBPopupMenu *popupMenu;

@end

@implementation XKFriendsTalkCommonRLCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 初始化默认数据
        [self superCreateDefaultData];
        // 初始化界面
        [self superCreateUI];
        // 布局界面
        [self superCreateConstraints];
    }
    return self;
}

#pragma mark - 初始化默认数据
- (void)superCreateDefaultData {

}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化界面
- (void)superCreateUI {
    __weak typeof(self) weakSelf = self;
    self.contentView.backgroundColor = HEX_RGB(0xeeeeee);
    _totoalView = [[UIView alloc] init];
    [self.contentView addSubview:_totoalView];
    _totoalView.xk_openClip = YES;
    _totoalView.xk_radius = 8;
    _totoalView.backgroundColor = [UIColor whiteColor];
    /**头像*/
    _headerImageView = [[UIImageView alloc] init];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageView.userInteractionEnabled = YES;
    _headerImageView.xk_radius = 8;
    _headerImageView.xk_openClip = YES;
    _headerImageView.xk_clipType = XKCornerClipTypeAllCorners;
    [_headerImageView bk_whenTapped:^{
        [GlobleCommonTool jumpToPersonalDataOrCircleListWithUserId:self.model.sendUser.userbelonghouse.ID name:self.model.sendUser.nickname headerIcon:self.model.sendUser.icon];
    }];
    [self.totoalView addSubview:_headerImageView];
    /**名字*/
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = kFontSize6(14);
    _nameLabel.userInteractionEnabled = YES;
    _nameLabel.textColor = HEX_RGB(0x1B82D1);
    [_nameLabel bk_whenTapped:^{
        [GlobleCommonTool jumpToPersonalDataOrCircleListWithUserId:self.model.sendUser.userbelonghouse.ID name:self.model.sendUser.nickname headerIcon:self.model.sendUser.icon];
    }];
    [self.contentView addSubview:_nameLabel];
    
    /**标签1*/
    _tagLabel1 = [[UILabel alloc] init];
    _tagLabel1.font = kFontSize6(12);
    _tagLabel1.textAlignment = NSTextAlignmentCenter;
    _tagLabel1.textColor = HEX_RGB(0xffffff);
    _tagLabel1.backgroundColor = HEX_RGB(0xFC656F);
    _tagLabel1.xk_clipType = XKCornerClipTypeAllCorners;
    _tagLabel1.xk_openClip = YES;
    _tagLabel1.xk_radius = 4;
    [self.contentView addSubview:_tagLabel1];
    
    /**标签2*/
    _tagLabel2 = [[UILabel alloc] init];
    _tagLabel2.font = kFontSize6(12);
    _tagLabel2.hidden = YES;
    _tagLabel2.textAlignment = NSTextAlignmentCenter;
    _tagLabel2.backgroundColor = HEX_RGB(0x1B82D1);
    _tagLabel2.textColor = HEX_RGB(0xffffff);
    _tagLabel2.xk_clipType = XKCornerClipTypeAllCorners;
    _tagLabel2.xk_openClip = YES;
    _tagLabel2.xk_radius = 4;
    [self.contentView addSubview:_tagLabel2];
    
    /**地址*/
    _addessLabel = [[UILabel alloc] init];
    _addessLabel.font = kFontSize6(10);
    _addessLabel.textColor = HEX_RGB(0x1B61CC);
    [self.contentView addSubview:_addessLabel];
    /**内容父视图*/
    _talkContentView = [[XKFriendTalkContentView alloc] initWithWidth:(SCREEN_WIDTH - 10 * 2 - 10 - 46 - 10 - 10) showType:self.reuseIdentifier];
    [_talkContentView setRefreshBlock:^(NSIndexPath *indexPath) {
        weakSelf.refreshBlock(indexPath);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_talkContentView addGestureRecognizer:tap];
    _talkContentView.clipsToBounds = YES;
    [self.totoalView addSubview:_talkContentView];
    /**操作视图*/
    _toolView = [[XKFriendCicleToolView alloc] init];
    [_toolView.commentButton addTarget:self action:@selector(popClick:) forControlEvents:UIControlEventTouchUpInside];
    [_toolView.favorButton addTarget:self action:@selector(favorClick) forControlEvents:UIControlEventTouchUpInside];
    [_toolView.giftButton addTarget:self action:@selector(giftClick) forControlEvents:UIControlEventTouchUpInside];
    [_toolView.deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [self.totoalView addSubview:_toolView];
    /**底部点赞评论父视图*/
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = HEX_RGB(0xF3F3F3);
    _bottomView.clipsToBounds = YES;
    [self.totoalView addSubview:_bottomView];
    
    _favorLabel = [[YYLabel alloc] init];
    _favorLabel.userInteractionEnabled = YES;
    _favorLabel.numberOfLines = 1;
    _favorLabel.textColor = HEX_RGB(0x1B61CC);
    _favorLabel.font = [UIFont systemFontOfSize:kCommentFontSize];

    [self.bottomView addSubview:_favorLabel];
    
    
    QBPopupMenuItem *item1 = [QBPopupMenuItem itemWithTitle:@"赞" image:[UIImage imageNamed:@"ic_btn_msg_circle_noLike"] target:self action:@selector(favorClick)];
    QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithTitle:@"评论" image:[UIImage imageNamed:@"ic_btn_msg_circle_Comment"] target:self action:@selector(replyClick)];
    NSArray *items = @[item1, item2];
    QBPopupMenu *popupMenu = [[QBPopupMenu alloc] initWithItems:items];
    popupMenu.highlightedColor = [[UIColor colorWithRed:0 green:0.478 blue:1.0 alpha:1.0] colorWithAlphaComponent:0.8];
    popupMenu.arrowSize = 0;
    popupMenu.height = 25;
    popupMenu.margin = 5;
    popupMenu.arrowDirection =  QBPopupMenuArrowDirectionRight;
    self.popupMenu = popupMenu;
}

#pragma mark - 布局界面
- (void)superCreateConstraints {
    CGFloat margin = kFMargin;
    CGFloat headerSize = kFHeaderSize;
    [_totoalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    /**头像*/
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totoalView.mas_top).offset(margin * 2);
        make.left.equalTo(self.totoalView.mas_left).offset(margin);
        make.size.mas_equalTo(CGSizeMake(headerSize, headerSize));
    }];
    /**名字*/
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView.mas_top);
        make.left.equalTo(self.headerImageView.mas_right).offset(margin);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(kViewSize(20));
    }];
    
    /**标签1*/
    [_tagLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(5);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(kViewSize(16));
        make.centerY.equalTo(self.nameLabel);
    }];
    
    /**标签2*/
    [_tagLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.tagLabel1.mas_right).offset(5);
        make.width.mas_equalTo(kViewSize(16));
        make.height.mas_equalTo(kViewSize(16));
    }];
    
    /**说说父视图*/
    [_talkContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(6);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.totoalView.mas_right).offset(-10);
    }];
    /**地址*/
    [_addessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.talkContentView.mas_left);
        make.right.equalTo(self.totoalView.mas_right).offset(-5);
        make.top.equalTo(self.talkContentView.mas_bottom).offset(8);
    }];
    
    /**工具条*/
    [_toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.talkContentView.mas_left);
        make.right.equalTo(self.totoalView.mas_right).offset(-5);
        make.top.equalTo(self.addessLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(30);
    }];

    /**底部点赞评论父视图*/
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totoalView.mas_left).offset(kCommentleft);
        make.right.equalTo(self.totoalView.mas_right).offset(-15);
        make.top.equalTo(self.toolView.mas_bottom).offset(10);
        make.height.equalTo(@100);
        make.bottom.equalTo(self.totoalView.mas_bottom).priority(300);
    }];
    _bottomView.xk_openClip = YES;
    _bottomView.xk_radius = 6;
    // 底部分割线
    _seperateLine = [UIView new];
    _seperateLine.backgroundColor = HEX_RGB(0xF0F0F0);
    [self.totoalView addSubview:_seperateLine];
    [_seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.totoalView);
        make.height.equalTo(@1);
    }];
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setModel:(FriendTalkModel *)model {
    _model = model;
    self.nameLabel.text = model.sendUser.nickname;
    self.addessLabel.text = model.locationaddress?:@"";
    self.talkContentView.contentNeedFold = self.contentExistFold;
    self.talkContentView.model = model;
    self.toolView.infoLabel.text = [XKTimeSeparateHelper customTimeStyleWithTimeString:self.model.createtime];
    
    [_headerImageView sd_setImageWithURL:kURL(model.sendUser.icon) placeholderImage:kDefaultHeadImg];
    CGFloat nameLabelW = [self getWidthWithText:model.sendUser.nickname height:kViewSize(20) font:15];
    NSString *tagLabel1Str ;
    if ([model.sendUser.usertype isEqualToString:@"1"]) {
        tagLabel1Str = @"房主";
    }else{
        tagLabel1Str = @"";
    }
    CGFloat tagLabel1W = [self getWidthWithText:tagLabel1Str height:kViewSize(20) font:14];
    CGFloat tagLabel2W = [self getWidthWithText:model.tag height:kViewSize(16) font:14];

    if (model.tag.length > 0) {
        self.tagLabel2.hidden = NO;
    }else{
        self.tagLabel2.hidden = YES;
    }
    self.tagLabel2.text = model.tag;
    self.tagLabel1.text = tagLabel1Str;

    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(nameLabelW);
    }];
    
    [self.tagLabel1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(tagLabel1W);
    }];
    [self.tagLabel2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(tagLabel2W);
    }];
    _toolView.commentButton.hidden =  NO;
    _toolView.favorButton.hidden =  YES;
    _toolView.giftButton.hidden = YES;
    
    
    if ([model.sendUser.userbelonghouse.userid isEqualToString:[LoginModel currentUser].data.users.userId]) {
        self.toolView.deleteBtn.hidden = NO;
    } else {
        self.toolView.deleteBtn.hidden = YES;
    }
    
    BOOL hasFavor = model.likes.count != 0;
    BOOL hasComent = model.comments.count != 0;
    if (hasFavor) {
        self.favorLabel.attributedText = model.favorAtt;
        if (self.mode == 1) {
            self.favorLabel.numberOfLines = 1;
            self.favorLabel.frame = CGRectMake(13,8, kBtmContentWidth, 22);
        } else {
            self.favorLabel.numberOfLines = 0;
            self.favorLabel.frame = CGRectMake(13,8, kBtmContentWidth, model.favorHeight + 6);
        }
        
    } else {
        self.favorLabel.height = 0;
    }
    // 这里处理尾部显示细节
    _seperateLine.hidden = NO;
    if (hasFavor) { // 有点赞
        if (hasComent) { // 有评论
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.favorLabel.bottom + 6);
                make.bottom.equalTo(self.totoalView.mas_bottom).priority(300);
            }];
            self.bottomView.xk_clipType = XKCornerClipTypeTopBoth;
        } else { // 无评论
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.favorLabel.bottom + 6);
                make.bottom.equalTo(self.totoalView.mas_bottom).offset(-10).priority(300);
            }];
            self.bottomView.xk_clipType = XKCornerClipTypeAllCorners;
        }
    } else { // 无点赞
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
            make.bottom.equalTo(self.totoalView.mas_bottom).priority(300);
        }];
        if (!hasComent) {
            //            _seperateLine.hidden = NO;
        }
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    self.talkContentView.indexPath = indexPath;
}

#pragma mark - 弹出菜单
- (void)popClick:(UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    CGFloat x = button.origin.x;
    CGFloat y = button.origin.y;
    CGFloat width = button.bounds.size.width;
    CGFloat height = button.bounds.size.height;
    CGRect targetRect = CGRectMake(x, y, width, height);
    [self.popupMenu showInView:self.toolView targetRect:targetRect animated:YES];
}
#pragma mark - 点击内容区域，让弹出的点赞View消失

- (void)tap {
    [self.popupMenu dismissAnimated:YES];
}


#pragma mark - 回复点击
- (void)replyClick {
    EXECUTE_BLOCK(self.commentClickBlock,self.indexPath,nil,self.model.sendUser.userbelonghouse.ID);
}

#pragma mark - 点赞点击
- (void)favorClick {
    EXECUTE_BLOCK(self.favorClickBlock,self.indexPath);
}

#pragma mark - 点赞点击
- (void)giftClick {
    EXECUTE_BLOCK(self.giftClickBlock,self.indexPath);
}

#pragma mark - 删除点击
- (void)deleteClick {
    EXECUTE_BLOCK(self.deleteClickBlock,self.indexPath);
}


#pragma mark - 重新布局
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.totoalView setNeedsLayout];
    [self.totoalView layoutIfNeeded];
    [self.bottomView setNeedsLayout];
    [self.bottomView layoutIfNeeded];
}

#pragma mark - 高度计算相关
/**得到正常说说高度  以及是否可折叠 以及折叠展开后的高度 */
+ (CGFloat)getContentHeight:(FriendTalkModel *)model contentAtt:(NSAttributedString **)contentAtt isNeedFold:(BOOL *)needFold totalHeight:(CGFloat *)totalHeight {
    CGFloat lineSpace = 3;
    UIFont *font = kFontSize6(kFriendTalkContentFont);
    NSMutableAttributedString *content = [UILabel getEmojiAttriStr:model.content].mutableCopy;
    content.yy_font = font;
    content.yy_lineSpacing = lineSpace;
    [content addAttributes:@{NSForegroundColorAttributeName:HEX_RGB(0x777777)} range:NSMakeRange(0, content.length)];
    CGFloat fullHeight = ceil([content sizeWithConditionWidth:SCREEN_WIDTH - 5 *kFMargin - kFHeaderSize].height);
//    if (fullHeight < font.pointSize*2) { // 认为是一行 清除表情单行时显示bug
//        content = model.content.mutableCopy;
//        content.yy_font = font;
//        [content addAttributes:@{NSForegroundColorAttributeName:HEX_RGB(0x777777)} range:NSMakeRange(0, content.length)];
//    }
    * contentAtt = content;
    * totalHeight = fullHeight;
    if (xkFriendTalkContentMaxHeight == 0) {
        xkFriendTalkContentMaxHeight = ceil([self calculateFoldHeightLineSpace:lineSpace font:font]);
    }
    if (fullHeight > xkFriendTalkContentMaxHeight) {
        *needFold = YES;
        *totalHeight = fullHeight;
        return xkFriendTalkContentMaxHeight;
    } else {
        return ceil(fullHeight);
    }
}

+ (CGFloat)calculateFoldHeightLineSpace:(CGFloat)space font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 30, 10000);
    NSString *max7Str = @"我\n我\n我\n我\n我\n我\n我";
    NSAttributedString *content = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
        confer.paragraphStyle.lineSpacing(space);
        confer.text(max7Str).font(font);
    }];
    label.numberOfLines = 0;
    label.attributedText = content;
    [label sizeToFit];
    return ceil(label.height);
}

#pragma mark - 点赞view的高度
+ (CGFloat)getFavorHeight:(FriendTalkModel *)model favorAttStr:(NSAttributedString **)favorAttStr {
    NSAttributedString *text = [self getFavorAStrWithModel:model];
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(kBtmContentWidth, CGFLOAT_MAX) text:text];
    CGFloat favorHeight = layout.textBoundingSize.height;
    *favorAttStr = text;
    return favorHeight < 16 ? 16 : favorHeight;
}

+ (NSAttributedString *)getFavorAStrWithModel:(FriendTalkModel *)model {
    UIFont *font = [UIFont systemFontOfSize:kCommentFontSize];
    NSMutableAttributedString *contentMstr = [[NSMutableAttributedString alloc]
                                              init];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"ic_btn_msg_circle_noLike"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(0, 0, 13, 13);
    NSMutableAttributedString *attachImageStr = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    
    [contentMstr appendAttributedString:attachImageStr];
    NSMutableAttributedString *space = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
        confer.text(@"  ");
    }].mutableCopy;
    [contentMstr appendAttributedString:space];
    for (int i = 0; i < model.likes.count; i ++) {
        Likes *likesUser = model.likes[i];
        NSString *name = likesUser.nickname;
        NSMutableAttributedString *text = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
            confer.paragraphStyle.lineSpacing(kCommentLineSpace);
            confer.text(name).font(font).textColor(HEX_RGB(0x1B61CC));
            if (model.likes.count > 1 && i != model.likes.count - 1) {
                confer.text(@"、 ").textColor([UIColor blackColor]);
            }
        }].mutableCopy;
        [text yy_setTextHighlightRange:NSMakeRange(0, name.length) color:nil backgroundColor:[UIColor lightGrayColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [GlobleCommonTool jumpToPersonalDataOrCircleListWithUserId:likesUser.userbelonghouse.ID name:name headerIcon:likesUser.icon];
        }];
        [contentMstr appendAttributedString:text];
    }
    return contentMstr;
}


//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:kFontSize6(font)}
                                     context:nil];
    return rect.size.width;
}
@end
