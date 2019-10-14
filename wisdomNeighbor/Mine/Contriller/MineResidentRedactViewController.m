//
//  MineResidentRedactViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/14.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "MineResidentRedactViewController.h"
#import "MineResidentRedactTableViewCell.h"
#import "XKChangeNicknameViewController.h"

@interface MineResidentRedactViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView                     *tableView;
@property (nonatomic, strong) NSArray             *dataArray;
@property (nonatomic, strong) NSMutableDictionary        *wDataDict;

@end

@implementation MineResidentRedactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.vcType == MineResidentRedactVCTyoeAdd) {
        [self setNavTitle:@"添加住户" WithColor:HEX_RGB(0x222222)];
    }else if (self.vcType == MineResidentRedactVCTyoeChange){
        [self setNavRightButton];
        [self setNavTitle:@"住户信息" WithColor:HEX_RGB(0x222222)];
    }
    [self initViews];
    [self initData];
}

- (void)initData {
    //    @"姓名",@"性别",@"手机号码"
    if ([self.model.sex isEqualToString:@"1"]) {
        self.wDataDict[@"1"] = @"男";
    }else if ([self.model.sex isEqualToString:@"2"]){
        self.wDataDict[@"1"] = @"女";
    }else {
        self.wDataDict[@"1"] = @"未设置";
    }
    if ([self.model.usertype isEqualToString:@"2"]) {
        self.wDataDict[@"3"] = @"畅享卡";
    }else if ([self.model.usertype isEqualToString:@"6"]){
        self.wDataDict[@"3"] = @"便捷卡";
    }
    self.wDataDict[@"0"] = self.model.nickname;
    self.wDataDict[@"2"] = self.model.phone;

}

- (void)setNavRightButton {
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"修改" forState:UIControlStateNormal];
    [button setTitleColor:HEX_RGB(0x000000) forState:UIControlStateNormal];
    [button setTitleColor:HEX_RGB(0x000000) forState:UIControlStateDisabled];
    button.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    [button addTarget:self action:@selector(rightNavAction:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    [self setRightView:button withframe:CGRectMake(0, 0, button.frame.size.width + 10.0, XKViewSize(25))];
}

- (void)initViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (void)backBtnClick {
    [XKAlertView showCommonAlertViewWithTitle:@"返回不会保存，确认返回？" rightText:@"确定" rightBlock:^{
        [super backBtnClick];
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = YES;
        [_tableView registerClass:[MineResidentRedactTableViewCell class] forCellReuseIdentifier:@"cell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _tableView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"姓名",@"性别",@"手机号码",@"身份类型"];
    }
    return _dataArray;
}

- (NSMutableDictionary *)wDataDict {
    if (!_wDataDict) {
        _wDataDict = @{@"0":@"",@"1":@"",@"2":@"",@"3":@""}.mutableCopy;
    }
    return _wDataDict;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataArray[indexPath.row];
    NSString *key = [NSString stringWithFormat:@"%ld",indexPath.row];
    NSString *content = self.wDataDict[key];
    MineResidentRedactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text = title;
    cell.rightTitleTextField.text = content;
    cell.rightTitleTextField.enabled = NO;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = HEX_RGB(0xf6f6f6);
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]init];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }else{
        return 0.00000001f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00000001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *key = [NSString stringWithFormat:@"%ld",indexPath.row];
    NSString *title = self.dataArray[indexPath.row];
    if ([title isEqualToString:@"姓名"]) {
        [self changeItemWithTitle:@"姓名" Row:key];
    }else if ([title isEqualToString:@"性别"]){
        [self cellForTheSexWithRow:key];
    }else if ([title isEqualToString:@"身份证号码"]){
        [self changeItemWithTitle:@"身份证号码" Row:key];
    }else if ([title isEqualToString:@"手机号码"]){
        [self changeItemWithTitle:@"手机号码" Row:key];
    }else if ([title isEqualToString:@"身份类型"]){
        [self cellForIdentityTypeWithRow:key];
    }else if ([title isEqualToString:@"房间号"]){
        [self changeItemWithTitle:@"房间号" Row:key];
    }else if ([title isEqualToString:@"发帖权限"]){
        [self cellForauthorityWithRow:key];
    }
}
- (void)cellForIdentityTypeWithRow:(NSString *)row {
    XKWeakSelf(ws);
    NSArray *typeArray;
    if ([[LoginModel currentUser].data.users.usertype isEqualToString:@"1"]) {
        typeArray = @[@"畅享卡",@"便捷卡",@"取消"];
    }else{
        typeArray = @[@"便捷卡",@"取消"];
    }
    XKBottomAlertSheetView *sheet = [[XKBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:typeArray firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
        ws.wDataDict[row] = choseTitle;
        [ws.tableView reloadData];
    }];
    [sheet show];
    
}

- (void)cellForauthorityWithRow:(NSString *)row {
    XKWeakSelf(ws);
    XKBottomAlertSheetView *sheet = [[XKBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:@[@"开通",@"不开通",@"取消"] firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
        ws.wDataDict[row] = choseTitle;
        [ws.tableView reloadData];
    }];
    [sheet show];
    
}

- (void)cellForTheSexWithRow:(NSString *)row {
    XKWeakSelf(ws);
    XKBottomAlertSheetView *sheet = [[XKBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:@[@"男",@"女",@"取消"] firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
        NSLog(@"%ld%@", (long)index,choseTitle);
        NSString *str = @"";
        if ([choseTitle isEqualToString:@"男"]) {
            str = @"1";
        }else if (([choseTitle isEqualToString:@"女"])) {
            str = @"2";
        }
        ws.wDataDict[row] = choseTitle;
        [ws.tableView reloadData];
    }];
    [sheet show];
    
}


- (void)changeItemWithTitle:(NSString *)title Row:(NSString *)row{
    XKWeakSelf(ws);
    XKChangeNicknameViewController *vc = [XKChangeNicknameViewController new];
    vc.useType = 1;
    vc.limitNum = 20;
    if (self.wDataDict[row]) {
        vc.nickName = self.wDataDict[row];
    }
    vc.title = title;
    vc.block = ^(NSString *text) {
        ws.wDataDict[row] = text;
        [ws.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)creatFooterView {
    if (self.vcType == MineResidentRedactVCTyoeAdd) {
        return [self creatAddFooterView];
    }else {
        return [self creatChangeFooterView];
;
    }
}

- (UIView *)creatChangeFooterView {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    footerView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    UILabel *textLabel = [UILabel new];
    textLabel.text = @"温馨提示：请谨慎新增住户及开通相关权限，避免造成不必要的损失；发帖权限开通上限为4人。";
    textLabel.textColor = HEX_RGB(0x999999);
    textLabel.font = XKRegularFont(16);
    textLabel.numberOfLines = 0;
    textLabel.backgroundColor = UIColorFromRGB(0xf6f6f6);
    [footerView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-44);
        make.top.equalTo(footerView.mas_top).offset(40);
    }];
    return footerView;
}

- (UIView *)creatAddFooterView {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    footerView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    UIButton *addButton = [UIButton new];
    [addButton setTitle:@"立即添加" forState:0];
    [addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setTitleColor:HEX_RGB(0xffffff) forState:0];
    [addButton setBackgroundColor:HEX_RGB(0x1B82D1)];
    addButton.layer.masksToBounds = YES;
    addButton.layer.cornerRadius = 22;
    [footerView addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.right.mas_equalTo(-26);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(44);
    }];
    
    UILabel *textLabel = [UILabel new];
    textLabel.text = @"温馨提示：请谨慎新增住户及开通相关权限，避免造成不必要的损失；发帖权限开通上限为4人。";
    textLabel.textColor = HEX_RGB(0x999999);
    textLabel.font = XKRegularFont(16);
    textLabel.numberOfLines = 0;
    textLabel.backgroundColor = UIColorFromRGB(0xf6f6f6);
    [footerView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
        make.top.equalTo(addButton.mas_bottom).offset(40);
    }];
    return footerView;
}

//新增事件
- (void)addButtonAction:(UIButton *)sender {
    [self updateDataWithType:self.vcType];
}
//修改事件
- (void)rightNavAction:(UIButton *)sender {
    [self updateDataWithType:self.vcType];
}


- (void)updateDataWithType:(MineResidentRedactVCTyoe)type {
    // FIXME: lilin {"phoneNumber":"18380446466","data":"{\"belonghouse\":\"1\",\"friendsremindnum\":0,\"id\":0,\"nickname\":\"测a试\",\"nowuseestates\":0,\"phone\":\"12213121315\",\"sex\":1,\"status\":0,\"truename\":\"测12试\",\"usertype\":2}","type":"addUser"}
//    {"phoneNumber":"18380446466","data":"{\"belonghouse\":\"1\",\"createtime\":\"2019-09-11 15:48:51\",\"friendsremindnum\":0,\"icon\":\"https://menjin-1251461298.cos.ap-chengdu.myqcloud.com/20190816/15659264796001031071159\",\"id\":35,\"nickname\":\"测试\",\"nowuseestates\":0,\"phone\":\"1221312315\",\"sex\":2,\"status\":1,\"truename\":\"测试\",\"usertype\":2}","type":"updateUser"}
    //    @"姓名",@"性别",@"手机号码",@"身份类型"
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *dataParameters = [NSMutableDictionary dictionary];
    parameters[@"phoneNumber"] = [LoginModel currentUser].data.users.phone;
    parameters[@"data"] = dataParameters;
    dataParameters[@"belonghouse"] = @"1";
    dataParameters[@"friendsremindnum"] = @"0";
    dataParameters[@"id"] = @"0";
    dataParameters[@"nickname"] = self.wDataDict[@"0"];
    dataParameters[@"nowuseestates"] = @"0";
    dataParameters[@"phone"] = self.wDataDict[@"2"];
    dataParameters[@"status"] = @"1";
    dataParameters[@"truename"] = self.wDataDict[@"0"];
    NSString *sexStr;
    NSString *userTypeStr;

    if (self.wDataDict[@"1"]) {
        if ([self.wDataDict[@"1"] isEqualToString:@"男"]) {
            sexStr = @"1";
        }else if ([self.wDataDict[@"1"] isEqualToString:@"女"]){
            sexStr = @"2";
        }
    }
    if (self.wDataDict[@"3"]) {
        if ([self.wDataDict[@"3"] isEqualToString:@"畅享卡"]) {
            userTypeStr = @"2";
        }else if ([self.wDataDict[@"3"] isEqualToString:@"便捷卡"]){
            userTypeStr = @"6";
        }
    }
    dataParameters[@"sex"] = sexStr;
    dataParameters[@"usertype"] = userTypeStr;

    if (type == MineResidentRedactVCTyoeAdd) {
        parameters[@"type"] = @"addUser";
    }else if (type == MineResidentRedactVCTyoeChange){
        parameters[@"type"] = @"updateUser";
        dataParameters[@"createtime"] = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithDate:[NSDate date]];
        dataParameters[@"icon"] = @"";
    }
    
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postRequestWithURLString:@"project_war_exploded/userServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        [XKHudView hideHUDForView:self.tableView];
        if (type == MineResidentRedactVCTyoeAdd) {
            [XKHudView showSuccessMessage:@"添加成功"];
        }else{
            [XKHudView showSuccessMessage:@"修改成功"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.tableView];
        [XKHudView showErrorMessage:error.message];
    }];
}


@end
