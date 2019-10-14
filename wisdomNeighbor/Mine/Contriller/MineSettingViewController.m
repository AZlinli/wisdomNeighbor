//
//  MineSettingViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/14.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "MineSettingViewController.h"
#import "MinePersonalTableViewCell.h"
#import "LoginViewController.h"

@interface MineSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView                     *tableView;
@property (nonatomic, strong) NSArray        *dataArray;

@end

@implementation MineSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"设置中心" WithColor:HEX_RGB(0x222222)];
    [self initViews];
}
- (void)initViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = YES;
        [_tableView registerClass:[MinePersonalTableViewCell class] forCellReuseIdentifier:@"cell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _tableView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@[@"不让他看我",@"不看他"],@[@"修改密码"],@[@"退出登录"]];
    }
    return _dataArray;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataArray[indexPath.section][indexPath.row];
    MinePersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text = title;

    if ([title isEqualToString:@"退出登录"]) {
        cell.nextImageView.hidden = YES;
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.myContentView);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(100);
        }];;
    }else{
        cell.nextImageView.hidden = NO;
        cell.titleLabel.textAlignment = NSTextAlignmentLeft;
        [cell.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(14));
            make.centerY.equalTo(cell.myContentView);
            make.height.equalTo(@(20 ));
        }];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
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
    if (section == 1 || section == 2) {
        return 20;
    }else{
        return 0.00000001f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00000001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataArray[indexPath.section][indexPath.row];
    if ([title isEqualToString:@"退出登录"]) {
        [XKLoginConfig loginDropOutConfig];
        LoginViewController *vc = [LoginViewController new];
        vc.vcType = loginVCTyoeLogin;
        [UIApplication sharedApplication].delegate.window.rootViewController = vc;
    }
}

@end
