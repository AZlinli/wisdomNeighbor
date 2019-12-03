//
//  FriendCircleListViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/22.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "FriendCircleListViewController.h"
#import "FriendCircleListImageTableViewCell.h"
#import "FriendCircleListShareTableViewCell.h"
#import "FriendTalkModel.h"
#import "MessageListViewController.h"
#import "FriendCircleDetailViewController.h"

@interface FriendCircleListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *sectionArray;
@property(nonatomic, strong) XKEmptyPlaceView *emptyView;

@property(nonatomic, copy) NSString *lastId;

@property(nonatomic, assign) RefreshDataStatus refreshStatus;

/**<##>*/
@property(nonatomic, strong) UIImageView *tableHeaderBgView;
/**是否是当前用户*/
@property(nonatomic, assign) BOOL isMine;
@end

@implementation FriendCircleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lastId = @"0";
    [self judgeCurrentUser];
    [self setNavTitle:@"" WithColor:[UIColor blackColor]];
    [self hideNavigationSeperateLine];
    self.navigationView.backgroundColor = HEX_RGBA(0x4A90FA, 0);
    [self initViews];
    [self requestDataRefresh:YES NeedTip:NO];
}
- (void)judgeCurrentUser {
    if ([[LoginModel currentUser].currentHouseId isEqualToString:self.userId]) {
        self.isMine = YES;
    }else{
        self.isMine = NO;
    }
}

- (void)initViews {
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf requestDataRefresh:YES NeedTip:NO];
//        weakSelf.tableView.tableHeaderView = [self creatHeaderView];
//    }];
    MJRefreshBackNormalFooter *mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestDataRefresh:NO NeedTip:NO];
    }];
    _tableView.mj_footer.hidden = YES;
    _tableView.mj_footer = mj_footer;
    [mj_footer setTitle:@"已经到底了！" forState:MJRefreshStateNoMoreData];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view);
    }];
    XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
    config.verticalOffset = 100;
    config.viewAllowTap = NO;
    config.spaceHeight = 10;
    _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:config];
}
- (void)requestDataRefresh:(BOOL)refresh NeedTip:(BOOL)needTip {
    if (needTip) {
        [XKHudView showLoadingTo:self.tableView animated:YES];
    }
    __weak typeof(self) weakSelf = self;
    [self loadDataRefresh:refresh complete:^(id error, id data) {
        [XKHudView hideHUDForView:self.tableView animated:YES];
        [self resetMJHeaderFooter:self.refreshStatus tableView:self.tableView dataArray:self.dataArray];
        self.tableView.tableHeaderView = [self creatHeaderView];
        [self.tableView reloadData];
        if (error) {
            if (self.dataArray.count == 0) {
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
            if (self.dataArray.count == 0) {
                self.emptyView.config.viewAllowTap = NO;
                [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"还没有任何动态哦" tapClick:nil];
            } else {
                [self.emptyView hide];
            }
        }
    }];
}

- (void)loadDataRefresh:(BOOL)isRefresh complete:(void (^)(id error,id data))complete  {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (isRefresh) {
        self.lastId = @"0";
    }
    parameters[@"type"] = @"getOnesFriendsCircle";
    parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;
    parameters[@"lastId"] = self.lastId;
    parameters[@"userId"] = self.userId;
    [HTTPClient postRequestWithURLString:@"project_war_exploded/friendsCircleServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        NSArray *array = [NSArray yy_modelArrayWithClass:[FriendTalkModel class] json:responseObject[@"data"]];
        FriendTalkModel *model1 = array.lastObject;
        self.lastId = model1.ID;
        if (isRefresh) {
            [self.dataArray removeAllObjects];
        }
        NSString *currentLastId = @"0";
        
        FriendTalkModel *model2 = self.dataArray.lastObject;
        if (model2) {
            currentLastId = model2.ID;
        }
        
        if (currentLastId < self.lastId) {
            self.refreshStatus = Refresh_HasDataAndHasMoreData;
        } else {
            self.refreshStatus = Refresh_NoDataOrHasNoMoreData;
            
        }
        [self.dataArray addObjectsFromArray:array];
        EXECUTE_BLOCK(complete,nil,array);
    } failure:^(XKHttpErrror *error) {
        self.refreshStatus = Refresh_NoNet;
        EXECUTE_BLOCK(complete,error,nil);
        [XKHudView showErrorMessage:error.message];
    }];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        if (self.isMine) {
            FriendTalkModel *model = [FriendTalkModel new];
            _dataArray = @[model].mutableCopy;

        }else{
            _dataArray = [NSMutableArray array];
        }
    }
    return _dataArray;
}

- (NSArray *)sectionArray {
    if (!_sectionArray) {
        if (self.isMine) {
            _sectionArray = @[@"",@"2019年"];
            
        }else{
            _sectionArray = @[@"2019年"];
        }
    }
    return _sectionArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xeeeeee);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [self creatHeaderView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FriendCircleListImageTableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerClass:[FriendCircleListShareTableViewCell class] forCellReuseIdentifier:@"cell2"];

        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _tableView;
}
- (UIView *)creatHeaderView {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
    headerView.backgroundColor = HEX_RGB(0xffffff);
    UIImageView *bgImageView = [[UIImageView alloc]init];
    bgImageView.userInteractionEnabled = YES;
    [GlobleCommonTool configTimeHourWith:bgImageView];
    bgImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180);
    [headerView addSubview:bgImageView];

     UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"   " forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"xk_btn_Mine_setting_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:backButton];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(50);
        make.size.mas_equalTo(CGSizeMake(9, 16));
    }];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setTitle:@"   " forState:UIControlStateNormal];
    [moreButton setImage:[UIImage imageNamed:@"ic_btn_msg_circle_Comment"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [moreButton bk_whenTapped:^{
        MessageListViewController *vc = [MessageListViewController new];
           [self.navigationController pushViewController:vc animated:YES];
    }];
    [bgImageView addSubview:moreButton];
       
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.mas_equalTo(-17);
           make.top.mas_equalTo(50);
           make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    UIImageView *headerImageView = [UIImageView new];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:self.headerIcon] placeholderImage:[UIImage imageNamed:@"xk_ic_defult_head"]];
    headerImageView.layer.masksToBounds = YES;
    headerImageView.layer.cornerRadius = 5;
    headerImageView.userInteractionEnabled = YES;
    [headerView addSubview:headerImageView];
    [headerImageView bk_whenTapped:^{
//        [GlobleCommonTool jumpCircleListWithUserId:self.userId name:self.name headerIcon:self.headerIcon];
    }];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.height.mas_equalTo(60);
        make.top.mas_equalTo(131);
    }];
    
    UILabel *titlelabel = [UILabel new];
    titlelabel.text = self.name;
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
    self.tableHeaderBgView = bgImageView;
    
    return headerView;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTalkModel *model = self.dataArray[indexPath.section];
    if (self.isMine) {
        if (indexPath.section == 0) {
            FriendCircleListImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.isMinePpecial = 1;
            cell.model = model;
            return cell;
        }else{
            NSArray * imageArray = [model.images componentsSeparatedByString:@"|"];
            if (imageArray.count <= 0) {
                FriendCircleListShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
                cell.model = model;
                return cell;
            }else{
                FriendCircleListImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                cell.isMinePpecial = 0;
                cell.model = model;
                return cell;
            }
        }
    }else{
        NSArray * imageArray = [model.images componentsSeparatedByString:@"|"];
        if (imageArray.count <= 0) {
            FriendCircleListShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
            cell.model = model;
            return cell;
        }else{
            FriendCircleListImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.model = model;
            cell.isMinePpecial = 0;
            return cell;
        }
    }
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    FriendTalkModel *model = self.dataArray[section];
//    return model.comments.count;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 98;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isMine) {
        if (indexPath.section == 0) {
            
        }else{
            FriendTalkModel *model = self.dataArray[indexPath.section];
            FriendCircleDetailViewController *vc = [FriendCircleDetailViewController new];
            vc.circleId = model.ID;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        FriendTalkModel *model = self.dataArray[indexPath.section];
        FriendCircleDetailViewController *vc = [FriendCircleDetailViewController new];
        vc.circleId = model.ID;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
    if (self.isMine) {
        if (section == 0) {
            return 10;
        }else if (section == 1){
            return 30;
        }
    }else{
        if (section == 0) {
            return 30;
        }
    }

    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView =  [[UIView alloc]init];
    sectionHeaderView.backgroundColor = HEX_RGB(0xffffff);
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = self.sectionArray[section];
    titleLabel.font = XKMediumFont(29);
    titleLabel.textColor = HEX_RGB(0x000000);
    [sectionHeaderView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.bottom.equalTo(sectionHeaderView);
        make.right.mas_equalTo(-12);
    }];
    return sectionHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = 0;
    if (scrollView.mj_offsetY > 0) {//向上移动
        y = 0;
    } else {//向下移动
        y = scrollView.mj_offsetY;
    }
    self.tableHeaderBgView.y = y;
    self.tableHeaderBgView.height = 180  - y;
}

- (void)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
