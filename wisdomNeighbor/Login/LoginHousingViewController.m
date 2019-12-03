//
//  LoginHousingViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/15.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "LoginHousingViewController.h"
#import "MinePersonalTableViewCell.h"
#import "CYLTabBarController.h"
#import "BaseTabBarConfig.h"
#import "LoginHousingModel.h"
#import "XKMapManager.h"
#import "XKMapLocationDelegate.h"
#import "LoginHousingTableViewCell.h"

@interface LoginHousingViewController ()<UITableViewDelegate,UITableViewDataSource,XKMapLocationDelegate>
@property (nonatomic, strong) UITableView                     *tableView;
@property (nonatomic, strong) NSArray        *dataArray;

@end

@implementation LoginHousingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //地图
//    [[[XKMapManager getCurrentMapFactory] getMapLocation] setLocationDelegate:self];
//    [[[XKMapManager getCurrentMapFactory] getMapLocation] startBaiduSingleLocationService];
    [self setNavTitle:@"选择房子" WithColor:HEX_RGB(0x222222)];
    // FIXME: lilin
//    [self loadDataWithlatitude:1.0 longtitude:2.0];
    self.dataArray = [LoginModel currentUser].data.houses;
    [self hiddenBackButton:!self.showBack];
    [self initViews];
}
- (void)initViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (void)loadDataWithlatitude:(double)latitude longtitude:(double)longtitude {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"getEstatesVisitor";
    parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;
    // FIXME: lilin
    parameters[@"latitude"] = @"1";
    parameters[@"longtitude"] = @"1";
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postRequestWithURLString:@"project_war_exploded/estatesServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        [XKHudView hideHUDForView:self.tableView];
        self.dataArray = [NSArray yy_modelArrayWithClass:[LoginHousingModelData class] json:responseObject[@"data"]];
        [self.tableView reloadData];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.tableView];
        [XKHudView showErrorMessage:error.message];
    }];
}

#pragma mark – Getters and Setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.tableHeaderView = [self creatHeaderView];
        _tableView.scrollEnabled = YES;
        [_tableView registerNib:[UINib nibWithNibName:@"LoginHousingTableViewCell" bundle:nil]forCellReuseIdentifier:@"cell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _tableView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[];
    }
    return _dataArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LoginModelHouses *model = self.dataArray[indexPath.row];
        LoginHousingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    [cell.myContentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(15);
//        make.right.mas_equalTo(-15);
//    }];
//    cell.myContentView.xk_radius = 8;
//    cell.myContentView.xk_openClip = YES;
//    if (indexPath.row == 0) {
//        cell.myContentView.xk_clipType = XKCornerClipTypeTopBoth;
//    }else if (indexPath.row == self.dataArray.count -1){
//        cell.myContentView.xk_clipType = XKCornerClipTypeBottomBoth;
//    }else{
//        cell.myContentView.xk_clipType = XKCornerClipTypeNone;
//    }
    cell.model = model;
        return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    headerView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LoginModelHouses *model = self.dataArray[indexPath.row];
    [LoginModel currentUser].currentHouseId = model.userbelonghouse.ID;
    [LoginModel currentUser].currentHouseName = model.estates.name;
    [LoginModel currentUser].currentUserType = model.userbelonghouse.usertype;
    [LoginModel currentUser].currentInestateslocation = model.inestateslocation;

    XKUserSynchronize;
    BaseTabBarConfig *tabBarControllerConfig = [[BaseTabBarConfig alloc] init];
    CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
    //正常登录
    [UIApplication sharedApplication].delegate.window.rootViewController = tabBarController;
}

- (UIView *)creatHeaderView {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headerView.backgroundColor = HEX_RGB(0xf6f6f6);
    UIButton *seacheButton = [[UIButton alloc]init];
    [seacheButton setTitle:@"搜索" forState:0];
    [seacheButton setTitleColor:HEX_RGB(0x222222) forState:0];
    [seacheButton setBackgroundColor:HEX_RGB(0xffffff)];
    seacheButton.layer.masksToBounds = YES;
    seacheButton.layer.cornerRadius = 5;
    seacheButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [seacheButton.titleLabel setFont:XKRegularFont(14)];
    [headerView addSubview:seacheButton];
    [seacheButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    UIView *textFieldContentView = [UIView new];
    textFieldContentView.backgroundColor = [UIColor whiteColor];
    textFieldContentView.layer.masksToBounds = YES;
    textFieldContentView.layer.cornerRadius = 5;
    [headerView addSubview:textFieldContentView];
    [textFieldContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.equalTo(seacheButton.mas_left).offset(-10);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    UITextField *seacheTextField = [UITextField new];
    [textFieldContentView addSubview:seacheTextField];
    seacheTextField.placeholder = @"搜索我的小区";
    seacheTextField.font = XKRegularFont(14);
    seacheTextField.textColor = HEX_RGB(0x999999);
    seacheTextField.backgroundColor = HEX_RGB(0xffffff);
    [seacheTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.equalTo(seacheButton.mas_left).offset(-10);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    return headerView;
}

- (void)userLocationLaititude:(double)laititude longtitude:(double)longtitude {
    [self loadDataWithlatitude:laititude longtitude:longtitude];
}
@end
