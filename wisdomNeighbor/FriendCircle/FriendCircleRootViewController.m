//
//  FriendCircleRootViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/11.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "FriendCircleRootViewController.h"
#import "XKBottomAlertSheetView.h"
#import "XKPhotoPickHelper.h"
#import "FriendsCircleListViewModel.h"
#import "MessageListViewController.h"
#import "FriendCirclePublishController.h"
#import "NoticeModel.h"
#import "NoticeListViewController.h"
#import "FriendCircleSearchViewController.h"
#import "MessageListModel.h"

@interface FriendCircleRootViewController ()
@property(nonatomic, strong)XKPhotoPickHelper *photoPickHelper;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong) XKEmptyPlaceView *emptyView;
@property(nonatomic, strong) FriendsCircleListViewModel *viewModel;
@property(nonatomic, strong) UIImageView *tableHeaderBgView;
/**当前的消息提醒数量*/
@property(nonatomic, copy) NSString *remindNumber;

/**通知的模型*/
@property(nonatomic, strong) NoticeModelData *noticeModelData;

/**当前提示的头像*/
@property(nonatomic, copy) NSString *headerUrl;
@end

@implementation FriendCircleRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.remindNumber = @"0";
    self.navigationView.backgroundColor = HEX_RGBA(0x4A90FA, 0);
    [self createUI];
    [self hideNavigationSeperateLine];
    //如果是便捷卡就不能发布朋友圈
    if ([[LoginModel currentUser].currentUserType isEqualToString:@"6"]) {
        
    }else{
        [self setNavRightButton];
    }
    [self setNavLeftButton];
    [self hiddenBackButton:YES];
    [self loadNewMessage];
    [self loadNewNotice];
    [self requestDataRefresh:YES NeedTip:NO];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(friendPageReloadNotificationAction) name:FriendPageReloadNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
#pragma mark - 初始化界面
- (void)createUI {
    self.view.backgroundColor = HEX_RGB(0xEEEEEE);
    self.view.clipsToBounds = YES;
    [self createTableView];
    XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
    config.verticalOffset = 100;
    config.viewAllowTap = NO;
    config.spaceHeight = 10;
    _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:config];
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = [self creatHeaderView];
    _tableView.backgroundColor = HEX_RGB(0xEEEEEE);
    [self.view addSubview:_tableView];
    [self.view bringSubviewToFront:self.navigationView];
    //处理留白
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.delegate = self.viewModel;
    _tableView.dataSource = self.viewModel;
    
    _tableView.estimatedRowHeight = 100;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _tableView.showsVerticalScrollIndicator = NO;
    
    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestDataRefresh:YES NeedTip:NO];
        [weakSelf loadNewMessage];
        [weakSelf loadNewNotice];
        weakSelf.tableView.tableHeaderView = [self creatHeaderView];
    }];
    MJRefreshBackNormalFooter *mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestDataRefresh:NO NeedTip:NO];
    }];
    _tableView.mj_footer.hidden = YES;
    _tableView.mj_footer = mj_footer;
    [mj_footer setTitle:@"已经到底了！" forState:MJRefreshStateNoMoreData];
    [self.viewModel registerCellForTableView:self.tableView];
    [self.viewModel configVCToolBar:self];
    
    [self.viewModel setRefreshTableView:^{
        [weakSelf.tableView reloadData];
    }];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
    }
}

- (void)loadNewNotice {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"getNewNotice";
    parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;
    [HTTPClient postRequestWithURLString:@"project_war_exploded/noticeServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        NoticeModelData *model =  [NoticeModelData yy_modelWithJSON:responseObject[@"data"]];
        self.noticeModelData = model;
        [self.tableView reloadData];
        self.tableView.tableHeaderView = [self creatHeaderView];
    } failure:^(XKHttpErrror *error) {
    }];
}

- (void)loadNewMessage {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"getNewComments";
    parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;

    [HTTPClient postRequestWithURLString:@"project_war_exploded/friendsCircleServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        self.remindNumber = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"remindNumber"]];
        [self.tableView reloadData];
        self.tableView.tableHeaderView = [self creatHeaderView];
        if (![self.remindNumber isEqualToString:@"0"]) {
            [self loadData];
        }
    } failure:^(XKHttpErrror *error) {
    }];
}

- (void)requestDataRefresh:(BOOL)refresh NeedTip:(BOOL)needTip {
    if (needTip) {
        [XKHudView showLoadingTo:self.tableView animated:YES];
    }
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestRefresh:refresh complete:^(id error, id data) {
        [XKHudView hideHUDForView:self.tableView animated:YES];
        [self resetMJHeaderFooter:self.viewModel.refreshStatus tableView:self.tableView dataArray:self.viewModel.dataArray];
        [self.tableView reloadData];
        if (error) {
            if (self.viewModel.dataArray.count == 0) {
                self.emptyView.config.allowScroll = NO;
                self.emptyView.config.viewAllowTap = YES; // 整个背景是否可点击  否则只有按钮可以点击
                [self.emptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                    [weakSelf requestDataRefresh:YES NeedTip:YES];
                }];
            } else {
                [XKHudView showErrorMessage:error to:self.tableView animated:YES];
            }
        } else {
            self.emptyView.config.allowScroll = YES;
            if (self.viewModel.dataArray.count == 0) {
                self.emptyView.config.viewAllowTap = NO;
                [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"还没有任何动态哦" tapClick:nil];
            } else {
                [self.emptyView hide];
            }
        }
    }];
}

- (void)setNavRightButton {
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"上传" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    [button addTarget:self action:@selector(upAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setRightView:button withframe:CGRectMake(0, 0, XKViewSize(45), 20)];
}

- (void)setNavLeftButton {
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    [button addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftView:button withframe:CGRectMake(0, 0, XKViewSize(45), 20)];
}

- (void)searchAction:(UIButton *)sender {
    FriendCircleSearchViewController *vc = [FriendCircleSearchViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)upAction:(UIButton *)sender {
    FriendCirclePublishController *vc = [FriendCirclePublishController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)creatHeaderView {
    CGFloat headerViewH;
    if ([self isShowMessageCountView]) {
        headerViewH = 309;
    }else{
        headerViewH = 309 - 79;
    }
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerViewH)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIImageView *bgImageView = [[UIImageView alloc]init];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.clipsToBounds = YES;
    [GlobleCommonTool configTimeHourWith:bgImageView];
    bgImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180);
    [headerView addSubview:bgImageView];
    self.tableHeaderBgView = bgImageView;
    UIView *informLabelContentView = [UIView new];
    informLabelContentView.backgroundColor = HEX_RGB(0xffffff);
    [headerView addSubview:informLabelContentView];
    
    [informLabelContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImageView.mas_bottom).offset(20);
        make.height.mas_equalTo(33);
        make.left.right.equalTo(headerView);
    }];
    
    UILabel *informLabel = [UILabel new];
    [informLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(self.noticeModelData.title).textColor(HEX_RGB(0x222222)).font(XKRegularFont(14));
    }];
    informLabel.hidden = ![self isShowNotice];
    [informLabelContentView addSubview:informLabel];
    UITapGestureRecognizer *infoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(infoTap:)];
    [informLabelContentView addGestureRecognizer:infoTap];
    [informLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.centerY.equalTo(informLabelContentView);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-122);
    }];
    UIView *infoLine1 = [UIView new];
   infoLine1.backgroundColor = XKSeparatorLineColor;
   [informLabelContentView addSubview:infoLine1];
   [infoLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.equalTo(informLabelContentView);
       make.height.mas_equalTo(1);
       make.bottom.equalTo(informLabelContentView.mas_top);
   }];
    UIView *infoLine = [UIView new];
    infoLine.backgroundColor = XKSeparatorLineColor;
    [informLabelContentView addSubview:infoLine];
    [infoLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(informLabelContentView);
        make.height.mas_equalTo(1);
    }];
    
    UIImageView *headerImageView = [UIImageView new];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:[LoginModel currentUser].data.users.icon] placeholderImage:[UIImage imageNamed:@"xk_ic_defult_head"]];
    UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTap:)];
    headerImageView.userInteractionEnabled = YES;
    [headerImageView addGestureRecognizer:headerTap];
    headerImageView.layer.masksToBounds = YES;
    headerImageView.layer.cornerRadius = 5;
    [headerView addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.height.mas_equalTo(60);
        make.top.mas_equalTo(131);
    }];
    
    UILabel *titlelabel = [UILabel new];
    titlelabel.text = [LoginModel currentUser].data.users.nickname;
    titlelabel.textColor = HEX_RGB(0xffffff);
    titlelabel.font = XKRegularFont(16);
    titlelabel.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerImageView.mas_left).offset(-12);
        make.centerY.equalTo(headerImageView.mas_centerY);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(20);
    }];
    
    UIView *messageContentView = [UIView new];
    messageContentView.backgroundColor = HEX_RGB(0xffffff);
    [headerView addSubview:messageContentView];
    CGFloat messageContentViewH;
    if ([self isShowMessageCountView]) {
        messageContentViewH = 76;
        messageContentView.hidden = NO;
    }else{
        messageContentViewH = 0;
        messageContentView.hidden = YES;
    }
    [messageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(informLabelContentView.mas_bottom);
        make.height.mas_equalTo(messageContentViewH);
        make.left.right.equalTo(headerView);
    }];
    
    UIView *messageView = [UIView new];
    messageView.layer.masksToBounds = YES;
    messageView.layer.cornerRadius = 5;
    messageView.backgroundColor = HEX_RGB(0x575757);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [messageView addGestureRecognizer:tap];
    [messageContentView addSubview:messageView];
    [messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(messageContentView);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(151);
    }];
    
    UIImageView *messageImageView = [UIImageView new];
    [messageImageView sd_setImageWithURL:[NSURL URLWithString:self.headerUrl] placeholderImage:[UIImage imageNamed:@"xk_ic_defult_head"]];
    messageImageView.layer.masksToBounds = YES;
    messageImageView.layer.cornerRadius = 2;
    [messageView addSubview:messageImageView];
    [messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(5);
        make.width.height.mas_equalTo(30);
    }];
    
    UILabel *messagelabel = [UILabel new];
    messagelabel.text = [NSString stringWithFormat:@"%@条新消息",self.remindNumber];
    messagelabel.textColor = HEX_RGB(0xffffff);
    messagelabel.font = XKRegularFont(18);
    messagelabel.textAlignment = NSTextAlignmentCenter;
    [messageView addSubview:messagelabel];
    [messagelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(messageView);
        make.left.equalTo(messageImageView.mas_right).offset(0);
    }];
    
    return headerView;
}

- (void)tap:(UIGestureRecognizer *)sender {
    MessageListViewController *vc = [MessageListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)headerTap:(UIGestureRecognizer *)sender {
    [GlobleCommonTool jumpCircleListWithUserId:[LoginModel currentUser].currentHouseId name:[LoginModel currentUser].data.users.nickname headerIcon:[LoginModel currentUser].data.users.icon];
}


- (XKPhotoPickHelper *)photoPickHelper {
    if (!_photoPickHelper) {
        _photoPickHelper = [[XKPhotoPickHelper alloc]init];
    }
    return _photoPickHelper;
}
- (FriendsCircleListViewModel *)viewModel {
    XKWeakSelf(ws);
    if (!_viewModel) {
        _viewModel = [[FriendsCircleListViewModel alloc] init];
//        _viewModel.scrollViewScroll = ^(UIScrollView * _Nonnull scrollView) {
//            CGFloat y = 0;
//            if (scrollView.mj_offsetY > 0) {//向上移动
//                y = 0;
//            } else {//向下移动
//                y = scrollView.mj_offsetY;
//            }
//            ws.tableHeaderBgView.y = y;
//            ws.tableHeaderBgView.height = 180  - y;
//        };
    }
    return _viewModel;
}

- (BOOL)isShowMessageCountView {
    if ([self.remindNumber isEqualToString:@"0"]) {
        return NO;
    }else{
        return YES;
    }
}
- (BOOL)isShowNotice {
    if (!self.noticeModelData.title) {
        return NO;
    }else{
        return YES;
    }
}

- (void)infoTap:(UIGestureRecognizer *)sender {
    NoticeListViewController *vc = [NoticeListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"getMeCommentsList";
    parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;
    parameters[@"lastId"] = @"0";
    [HTTPClient postRequestWithURLString:@"project_war_exploded/commentsServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        NSArray *modelArray = [NSArray yy_modelArrayWithClass:[MessageListModelData class] json:responseObject[@"data"]];
        MessageListModelData *model = modelArray.firstObject;
        self.headerUrl = model.comments.icon;
        self.tableView.tableHeaderView = [self creatHeaderView];
    } failure:^(XKHttpErrror *error) {
        [XKHudView showErrorMessage:error.message];
    }];
}

- (void)friendPageReloadNotificationAction {
    [self requestDataRefresh:YES NeedTip:NO];
    [self loadNewMessage];
    [self loadNewNotice];
    self.tableView.tableHeaderView = [self creatHeaderView];
}

@end
