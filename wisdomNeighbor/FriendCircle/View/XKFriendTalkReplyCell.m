/*******************************************************************************
 # File        : XKFriendTalkReplyCell.m
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

#import "XKFriendTalkReplyCell.h"
#import "XKFriendCircleHeader.h"
#import "YYText.h"
//#import "UILabel+xkEmoji.h"
//#import "YYLabel+xkEmoji.h"

#define kTotalWidth (SCREEN_WIDTH - 2 * kFMargin - 2 * 15)
#define kIconImgLeft  13
#define kIconImgSize 13
#define kIconImgRight 10
#define kHeadImgSize 29
#define kContentTop 10
#define kContentBtm 0
#define kContentBigTop 10
#define kContentLeft 4
#define kContentRight 8

#define kContentX (kIconImgLeft + kIconImgSize + kIconImgRight + kHeadImgSize + kContentLeft)

@interface XKFriendTalkReplyCell ()

/**视图*/
@property(nonatomic, strong) UIView *containView;
/**图片*/
@property(nonatomic, strong) UIImageView *iconView;
/**头像view*/
@property(nonatomic, strong) UIImageView *headerImgView;

@property(nonatomic, strong) YYLabel *nameLabel;
@property(nonatomic, strong) YYLabel *contentLabel;
/**分割线*/
@property(nonatomic, strong) UIView *seperateLine;
/**<##>*/
@property(nonatomic, strong) Comments *comment;
@end

@implementation XKFriendTalkReplyCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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

#pragma mark - 初始化界面
- (void)createUI {
    __weak typeof(self) weakSelf = self;
    self.contentView.backgroundColor = HEX_RGB(0xEEEEEE);
    _containView = [[UIView alloc] init];
    _containView.backgroundColor = HEX_RGB(0xFFFFFF);
    _containView.xk_openClip = YES;
    _containView.xk_radius = 6;
    [self.contentView addSubview:_containView];
    _totalView = [[UIView alloc] init];
    _totalView.backgroundColor = HEX_RGB(0xF3F3F3);
    [self.containView addSubview:_totalView];
    _totalView.xk_openClip = YES;
    _totalView.xk_radius = 6;
    /**图片*/
    _iconView = [[UIImageView alloc] init];
    _iconView.hidden = YES;
//    _iconView.image = IMG_NAME(@"ic_btn_msg_circle_Comment");
    [self.totalView addSubview:_iconView];
    /**头像view*/
    _headerImgView = [[UIImageView alloc] init];
    _headerImgView.clipsToBounds = YES;
    _headerImgView.hidden = YES;
    _headerImgView.layer.cornerRadius = 4;
    _headerImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.totalView addSubview:_headerImgView];
    _headerImgView.userInteractionEnabled = YES;
    [_headerImgView bk_whenTapped:^{
        weakSelf.userClickBlock(weakSelf.indexPath, weakSelf.comment,NO);
    }];
    
    _nameLabel = [[YYLabel alloc] init];
    _nameLabel.font = XKRegularFont(14);
    _nameLabel.hidden = YES;
    _nameLabel.textColor = HEX_RGB(0x1B61CC);
    [self.totalView addSubview:_nameLabel];
    _nameLabel.userInteractionEnabled = YES;
    [_nameLabel bk_whenTapped:^{
        weakSelf.userClickBlock(weakSelf.indexPath, weakSelf.comment,NO);
    }];
    
    _contentLabel = [[YYLabel alloc] init];
    _contentLabel.textColor = HEX_RGB(0x555555);
    _contentLabel.numberOfLines = 0;
    _contentLabel.userInteractionEnabled = YES;
    UILongPressGestureRecognizer * longP = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [_contentLabel addGestureRecognizer:longP];
    _contentLabel.font = XKRegularFont(12);
    [self.totalView addSubview:_contentLabel];

}

- (void)longPressAction:(UIGestureRecognizer *)sender {
    Comments *comment = self.model.comments[self.indexPath.row - 1];
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = comment.content;
    [XKHudView showSuccessMessage:@"复制成功!"];
}

- (void)setShortCell:(BOOL)shortCell {
    _shortCell = shortCell;
    [_totalView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(10 + 46 + 10);
    }];
    _nameLabel.width = _nameLabel.width - (10 + 46 + 10 - 15);
    _contentLabel.frame = CGRectMake(10, 2,_nameLabel.width, 18);
}

#pragma mark - 布局界面
- (void)createConstraints {
    [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    
    [_totalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containView);
        make.left.equalTo(self.containView.mas_left).offset(15);
        make.right.equalTo(self.containView.mas_right).offset(-15);
        make.bottom.equalTo(self.containView.mas_bottom).priority(200);
        make.height.mas_equalTo(kContentTop + kHeadImgSize + kContentBtm);
    }];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalView.mas_left).offset(kIconImgLeft);
        make.size.mas_equalTo(CGSizeMake(kIconImgSize, kIconImgSize));
        make.centerY.equalTo(self.headerImgView);
    }];
    
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalView.mas_top).offset(kContentTop);
        make.left.equalTo(self.iconView.mas_right).offset(kIconImgRight);
        make.size.mas_equalTo(CGSizeMake(kHeadImgSize, kHeadImgSize));
    }];
    _nameLabel.frame = CGRectMake(10, kContentTop - 1, kTotalWidth - kContentRight, 16);
    _contentLabel.frame = CGRectMake(10, 2,_nameLabel.width, 18);
    
    _seperateLine = [[UIView alloc] init];
    _seperateLine.backgroundColor = HEX_RGB(0xF0F0F0);
    [self.totalView addSubview:_seperateLine];
    [_seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.totalView);
        make.height.equalTo(@1);
    }];
}

- (void)hideSperate:(BOOL)hide {
    self.seperateLine.hidden = hide;
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setModel:(FriendTalkModel *)model {
    _model = model;
    Comments *comment = model.comments[self.indexPath.row - 1];
    _comment = comment;
    [_headerImgView sd_setImageWithURL:kURL(comment.comments.icon) placeholderImage:kDefaultHeadImg];
    NSString *name = comment.comments.nickname;
    _nameLabel.text = name;
    _nameLabel.width = [name getWidthStrWithFontSize:_nameLabel.font.pointSize height:17] + 10;
    if (comment.contentMStr == nil) {
        NSAttributedString *contentMStr = [self getCommentAStrWithModel:comment indexPath:self.indexPath];
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(_contentLabel.width, CGFLOAT_MAX) text:contentMStr];
        CGFloat commentHeight = layout.textBoundingSize.height;
        comment.contentMStr = contentMStr;
        comment.contentHeight = commentHeight;
    }

    _contentLabel.height = comment.contentHeight;
    _contentLabel.attributedText = comment.contentMStr;
    [_totalView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.contentLabel.bottom + kContentBtm);
    }];
    
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    if (indexPath.row == 1) {
        _iconView.hidden = NO;
    } else {
        _iconView.hidden = YES;
    }
}

- (NSAttributedString *)getCommentAStrWithModel:(Comments *)comment indexPath:(NSIndexPath *)indexPath {
    UIFont *font = XKRegularFont(12);
    self.contentLabel.font = font;
    __weak typeof(self) weakSelf = self;;
    NSString *name = comment.comments.nickname;
    NSString *name2 = comment.beComments.nickname;
    NSString *word = comment.content;
    
    NSString *userId = self.model.sendUser.userbelonghouse.ID;
    NSString *beUserId = comment.beComments.userbelonghouse.ID;
    NSMutableAttributedString *text;
    if ([userId isEqualToString:beUserId]) {
       text  = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
            if (name) {
                confer.text(name).font(font).textColor(HEX_RGB(0x1B61CC));
                confer.text(@":").font(font).textColor(HEX_RGB(0x555555));
            }
        }].mutableCopy;
        [text appendAttributedString:[[NSMutableAttributedString alloc]initWithString:word]];
        [text yy_setTextHighlightRange:NSMakeRange(0, name.length) color:nil backgroundColor:[UIColor lightGrayColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            weakSelf.userClickBlock(indexPath, comment,NO);
        }];
    }else{
        text = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
            if (name) {
                confer.text(name).font(font).textColor(HEX_RGB(0x1B61CC));
                confer.text(@"回复").font(font).textColor(HEX_RGB(0x555555));
                confer.text(name2).font(font).textColor(HEX_RGB(0x1B61CC));
                confer.text(@": ").font(font).textColor(HEX_RGB(0x555555));
            }
        }].mutableCopy;
        [text appendAttributedString:[[NSMutableAttributedString alloc]initWithString:word]];
        [text yy_setTextHighlightRange:NSMakeRange(0, name.length) color:nil backgroundColor:[UIColor lightGrayColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            weakSelf.userClickBlock(indexPath, comment,NO);
        }];
        
        [text yy_setTextHighlightRange:NSMakeRange(name.length + 2, name2.length) color:nil backgroundColor:[UIColor lightGrayColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            weakSelf.userClickBlock(indexPath, comment,YES);
        }];
    }
    return text;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_totalView setNeedsLayout];
    [_totalView layoutIfNeeded];
}

@end
