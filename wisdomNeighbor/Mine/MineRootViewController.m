//
//  MineRootViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/11.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "MineRootViewController.h"
#import "MineRootViewTableViewCell.h"
#import "MinePersonalViewController.h"
#import "MineResidentManagementViewController.h"
#import "MineSettingViewController.h"
#import "LoginHousingViewController.h"
#import "FriendCircleListViewController.h"
#import "FriendListViewController.h"
#import "BlackListViewController.h"
#import "LoginViewController.h"
#import "AboutAppViewController.h"

@interface MineRootViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSArray        *dataArray;

@end

@implementation MineRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_RGB(0xffffff);
    [self hideNavigation];
    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.tableHeaderView = [self creatTabelViewHeaderView];
}

#pragma mark – Private Methods
- (void)initViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight);
        make.left.bottom.right.equalTo(self.view);
    }];
}


#pragma mark – Getters and Setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [self creatFooterView];
        _tableView.tableHeaderView = [self creatTabelViewHeaderView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = YES;
        [_tableView registerClass:[MineRootViewTableViewCell class] forCellReuseIdentifier:@"cell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _tableView;
}

- (NSArray *)dataArray {
    
    if (!_dataArray) {
        if ([[LoginModel currentUser].currentUserType isEqualToString:@"1"] || [[LoginModel currentUser].currentUserType isEqualToString:@"2"]) {
             _dataArray = @[@[@"个人信息",@"私聊消息",@"住户管理",@"已屏蔽用户"], @[@"切换房子",@"检查更新",@"关于智邻"]];
        }else{
             _dataArray = @[@[@"个人信息",@"私聊消息",@"已屏蔽用户"], @[@"切换房子",@"检查更新",@"关于智邻"]];
        }
       
    }
    return _dataArray;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataArray[indexPath.section][indexPath.row];
    MineRootViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.titleImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mine_set_%ld",indexPath.row + 1]];
    }else{
        cell.titleImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mine_set_%ld",indexPath.row + 6]];
    }
    
    if (indexPath.row == 2) {
//        cell.numLabel.text = @"1";
//        cell.numLabel.hidden = NO;
    }else{
        cell.numLabel.hidden = YES;
    }
    cell.numLabel.hidden = YES;
    cell.titleLabel.text = title;
    
    if ([title isEqualToString:@"检查更新"]) {
        cell.rightTitlelabel.hidden = NO;
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        cell.rightTitlelabel.text = [NSString stringWithFormat:@"当前:%@",app_Version];
    }else{
        cell.rightTitlelabel.hidden = YES;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = HEX_RGB(0xf6f6f6);
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]init];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00000001f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataArray[indexPath.section][indexPath.row];
    if ([title isEqualToString:@"个人信息"]) {
        MinePersonalViewController *vc = [MinePersonalViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"我的发布"]){
        FriendCircleListViewController *vc = [FriendCircleListViewController new];
        vc.userId = [LoginModel currentUser].data.users.userId;
        vc.name = [LoginModel currentUser].data.users.nickname;
        vc.headerIcon = [LoginModel currentUser].data.users.icon;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"星标好友"]){
        FriendListViewController *vc = [FriendListViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"私聊消息"]){
        IMListViewController *vc = [IMListViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"住户管理"]){
        MineResidentManagementViewController *vc = [MineResidentManagementViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"切换房子"]){
        LoginHousingViewController *vc = [LoginHousingViewController new];
        vc.showBack = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"设置中心"]){
        MineSettingViewController *vc = [MineSettingViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"检查更新"]){
        [XKHudView showTipMessage:@"已经是最新版本！"];
    }else if ([title isEqualToString:@"已屏蔽用户"]){
        BlackListViewController *vc = [BlackListViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"关于智邻"]){
        AboutAppViewController *vc = [AboutAppViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)creatFooterView {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    UIButton *loginOutButton = [[UIButton alloc]init];
    [loginOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginOutButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17];
    loginOutButton.layer.masksToBounds = true;
    loginOutButton.enabled = YES;
    loginOutButton.layer.cornerRadius = 10;
    [loginOutButton addTarget:self action:@selector(loginOutAction:) forControlEvents:UIControlEventTouchUpInside];
    loginOutButton.backgroundColor = XKMainTypeColor;
    [footerView addSubview:loginOutButton];
    [loginOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.centerY.equalTo(footerView);
        make.height.mas_equalTo(40);
    }];
    return footerView;
}
- (void)loginOutAction:(UIButton *)sender {
    [XKAlertView showCommonAlertViewWithTitle:@"退出登录" rightText:@"确定" rightBlock:^{
        [XKLoginConfig loginDropOutConfig];
        LoginViewController *vc = [LoginViewController new];
        vc.vcType = loginVCTyoeLogin;
        [UIApplication sharedApplication].delegate.window.rootViewController = vc;
    }];
}

- (UIView *)creatTabelViewHeaderView {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    headerView.backgroundColor = HEX_RGB(0xffffff);
    UIImageView *headerImageview = [UIImageView new];
    [headerImageview sd_setImageWithURL:[NSURL URLWithString:[LoginModel currentUser].data.users.icon] placeholderImage:kDefaultHeadImg];
    [headerView addSubview:headerImageview];
    [headerImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.top.mas_equalTo(50);
        make.width.height.mas_equalTo(60);
    }];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = [LoginModel currentUser].data.users.nickname;
    nameLabel.textColor = HEX_RGB(0x000000);
    nameLabel.font = XKRegularFont(23);
    [headerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImageview.mas_right).offset(16);
        make.top.equalTo(headerImageview.mas_top);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *userLabel = [UILabel new];
    if ([[LoginModel currentUser].currentUserType isEqualToString:@"1"]) {
        userLabel.text = @"信息：业主";
    }else if ([[LoginModel currentUser].currentUserType isEqualToString:@"2"]){
        userLabel.text = @"信息：畅享卡";
    }else if ([[LoginModel currentUser].currentUserType isEqualToString:@"6"]){
        userLabel.text = @"信息：便捷卡";
    }
    userLabel.textColor = HEX_RGB(0x7F7F7F);
    userLabel.font = XKRegularFont(16);
    [headerView addSubview:userLabel];
    
    [userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.top.equalTo(nameLabel.mas_bottom).offset(13);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-20);
    }];
    
    return headerView;
}


@end
