//
//  PersonalDataViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/21.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "MinePersonalTableViewCell.h"
#import "PersonalDataPicTableViewCell.h"
#import "FriendCircleListViewController.h"
#import "FriendCircleJurisdictionViewController.h"
#import "XKChangeNicknameViewController.h"

@interface PersonalDataViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UILabel *otherNickNameLabel;
@property (nonatomic, strong)UIImageView    *headerImageView;
/**朋友圈的图片*/
@property(nonatomic, strong) NSArray *imageArray;
@end

@implementation PersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"" WithColor:[UIColor blackColor]];
    [self hideNavigationSeperateLine];
    [self initViews];
    [self loadData];
    if (self.vcType == personalVcTypeOther) {
        [self setNavRightButton];
    }
}

- (void)initViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NavigationAndStatue_Height));
        make.left.bottom.right.equalTo(self.view);
    }];
}
- (void)setNavRightButton {
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"更多" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    [button addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setRightView:button withframe:CGRectMake(0, 0, XKViewSize(45), 20)];
}

#pragma mark – action
- (void)moreAction:(UIButton *)sender {
    XKWeakSelf(ws);
    XKBottomAlertSheetView *sheet = [[XKBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:@[@"设置备注名称",@"设为星标好友",@"设置朋友圈权限",@"举报",@"取消"] firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle){
        switch (index) {
            case 0:{
                XKChangeNicknameViewController *vc = [XKChangeNicknameViewController new];
                vc.useType = 1;
                vc.limitNum = 20;
                vc.title = @"设置备注名称";
                vc.block = ^(NSString *text) {
                    // FIXME: lilin
                    [XKHudView showTipMessage:@"功能正在完善中"];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:{
                [XKHudView showTipMessage:@"功能正在完善中"];
            }
                break;
            case 2:{
                FriendCircleJurisdictionViewController *vc = [FriendCircleJurisdictionViewController new];
                vc.userId = self.userId;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:{
                [ws report];
            }
                break;
            default:
                break;
        }
    }];
    [sheet show];
}

- (void)showLoading {
    [XKHudView showLoadingTo:self.tableView animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [XKHudView showSuccessMessage:@"举报成功！"];
        [XKHudView hideHUDForView:self.tableView];
    });
}

- (void)report {
    XKWeakSelf(ws);
    XKBottomAlertSheetView *sheet = [[XKBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:@[@"含有裸露、色情和亵渎内容",@"含有政治敏感内容",@"低俗、广告内容",@"其他",@"取消"] firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle){
        switch (index) {
            case 0:{
                [ws showLoading];
            }
                break;
            case 1:{
                [ws showLoading];

            }
                break;
            case 2:{
                [ws showLoading];
                
            }
                break;
            case 3:{
                [ws showLoading];
            }
                break;
            default:
                break;
        }
    }];
    [sheet show];
}

- (void)loadData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"getOnesFriendsCircle";
    parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;
    parameters[@"lastId"] = @"0";
    parameters[@"userId"] = self.userId;
    [HTTPClient postRequestWithURLString:@"project_war_exploded/friendsCircleServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        NSArray *array = [NSArray yy_modelArrayWithClass:[FriendTalkModel class] json:responseObject[@"data"]];
        self.modelArray = array;
        __block FriendTalkModel *newModel;
        [array enumerateObjectsUsingBlock:^(FriendTalkModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (model.images) {
                newModel = model;
                *stop = YES;
            }
        }];
      NSMutableArray *otherArray = [NSMutableArray array];
      NSArray *pictureContents = [newModel.images componentsSeparatedByString:@"|"];
        if (pictureContents.count <= 3) {
            self.imageArray = pictureContents;
        }else{
            [pictureContents enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == 3) {
                    *stop = YES;
                }
                [otherArray addObject:obj];
            }];
            self.imageArray = otherArray;
        }
        [self.tableView reloadData];
    } failure:^(XKHttpErrror *error) {
        [XKHudView showErrorMessage:error.message];
    }];
}

#pragma mark – Getters and Setters
- (NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSArray array];
    }
    return _imageArray;
}


- (NSArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSArray array];
    }
    return _modelArray;
}

- (UIView *)creatHeaderView {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 106)];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:self.titleLabel];
    [headerView addSubview:self.contentLabel];
    [headerView addSubview:self.otherNickNameLabel];
    [headerView addSubview:self.headerImageView];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(7);
        make.width.height.mas_equalTo(64);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(20);
        make.top.equalTo(self.headerImageView.mas_top);
        make.height.mas_equalTo(22);
        make.right.mas_equalTo(-20);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-20);
    }];
    
    [self.otherNickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(20);
        make.bottom.equalTo(self.headerImageView.mas_bottom);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-20);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = XKSeparatorLineColor;
    [headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(headerView);
        make.left.mas_equalTo(16);
        make.height.equalTo(@1);
    }];
    
    self.titleLabel.text = self.name;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.headerIcon] placeholderImage:kDefaultHeadImg];
    self.otherNickNameLabel.text = self.otherName;
    return headerView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        if (_vcType == personalVcTypeOther) {
            _dataArray = @[@[@"设置备注名称"],@[@"朋友圈"],@[@"私聊"]];
        }else{
            _dataArray = @[@[@"朋友圈"]];
        }
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xeeeeee);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.tableHeaderView = [self creatHeaderView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[MinePersonalTableViewCell class] forCellReuseIdentifier:@"cell1"];
        [_tableView registerClass:[MinePersonalTableViewCell class] forCellReuseIdentifier:@"cell2"];
        [_tableView registerClass:[PersonalDataPicTableViewCell class] forCellReuseIdentifier:@"cell"];

        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _tableView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = HEX_RGB(0x000000);
        _titleLabel.font = XKRegularFont(22);
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.textColor = HEX_RGB(0x969696);
        if ([[LoginModel currentUser].currentUserType isEqualToString:@"1"]) {
            _contentLabel.text = @"信息：业主";
        }else if ([[LoginModel currentUser].currentUserType isEqualToString:@"2"]){
            _contentLabel.text = @"信息：畅享卡";
        }else if ([[LoginModel currentUser].currentUserType isEqualToString:@"6"]){
            _contentLabel.text = @"信息：便捷卡";
        }
        _contentLabel.font = XKRegularFont(14);
    }
    return _contentLabel;
}

- (UILabel *)otherNickNameLabel {
    if (!_otherNickNameLabel) {
        _otherNickNameLabel = [UILabel new];
        _otherNickNameLabel.textColor = HEX_RGB(0x969696);
        _otherNickNameLabel.text = @"备注名称：昵昵";
        _otherNickNameLabel.font = XKRegularFont(12);
    }
    return _otherNickNameLabel;
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [UIImageView new];
        _headerImageView.image = [UIImage imageNamed:@"xk_ic_defult_head"];
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.layer.cornerRadius = 5;
    }
    return _headerImageView;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataArray[indexPath.section][indexPath.row];
    if ([title isEqualToString:@"设置备注名称"]) {
        MinePersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.titleLabel.text = title;
        return cell;
    }else if ([title isEqualToString:@"私聊"]) {
        MinePersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        [cell.titleLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.appendImage([UIImage imageNamed:@"ic_btn_msg_circle_Comment"]);
            confer.text(@"  ");
            confer.text(title).textColor(HEX_RGB(0x576A94)).font(XKRegularFont(17));
        }];
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.myContentView);
            make.height.equalTo(@(20));
        }];
        cell.nextImageView.hidden = YES;
        return cell;
    }
    else{
        PersonalDataPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.titleLabel.text = title;
        cell.imageArray = self.imageArray;
        return cell;
    }
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_vcType == personalVcTypeOther) {
        if (indexPath.section == 1) {
            return 79;
        }else{
            return 55;
        }
        
    }else{
        if (indexPath.section == 0) {
            return 79;
        }else{
            return 55;
        }
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataArray[indexPath.section][indexPath.row];
    FriendTalkModel *model;
    if (self.modelArray.count > 0) {
       model = self.modelArray.firstObject;
    }
    if (_vcType == personalVcTypeOther) {
        if (indexPath.section == 1) {
            FriendCircleListViewController *vc = [FriendCircleListViewController new];
            vc.userId = self.userId;
            vc.name = self.name;
            vc.headerIcon = self.headerIcon;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else{
        if (indexPath.section == 0) {
            FriendCircleListViewController *vc = [FriendCircleListViewController new];
            vc.userId = self.userId;
            vc.name = self.name;
            vc.headerIcon = self.headerIcon;
            [self.navigationController pushViewController:vc animated:YES];
    }
    }
    if ([title isEqualToString:@"设置备注名称"]) {
        XKChangeNicknameViewController *vc = [XKChangeNicknameViewController new];
        vc.useType = 1;
        vc.limitNum = 20;
        vc.title = @"设置备注名称";
        vc.block = ^(NSString *text) {
            // FIXME: lilin
            [XKHudView showTipMessage:@"功能正在完善中"];

        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"私聊"]){
        IMConversationViewController *conversationVC = [[IMConversationViewController alloc]init];
        conversationVC.conversationType = ConversationType_PRIVATE;
        conversationVC.targetId = model.sendUser.userId;;
        conversationVC.title = model.sendUser.nickname;
        conversationVC.portraitUrl = model.sendUser.icon;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_vcType == personalVcTypeOther) {
        if (section == 1 || section == 2 ) {
            return 10;
        }else{
            return CGFLOAT_MIN;
        }
        
    }else{
        if (section == 0 ) {
            return 10;
        }else{
            return CGFLOAT_MIN;
        }
        
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView =  [[UIView alloc]init];
    sectionHeaderView.backgroundColor = HEX_RGB(0xeeeeee);
    return sectionHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

@end
