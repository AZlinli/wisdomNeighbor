//
//  BlackListViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/10/11.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "BlackListViewController.h"
#import "MinePersonalTableViewCell.h"
#import "BlackListModel.h"

@interface BlackListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView                     *tableView;
@property (nonatomic, strong) NSArray        *dataArray;
@property(nonatomic, strong) XKEmptyPlaceView *emptyView;


@end

@implementation BlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"已屏蔽用户" WithColor:HEX_RGB(0x222222)];
    [self initViews];
    [self loadData];
}

- (void)initViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
    config.verticalOffset = -100;
    config.viewAllowTap = NO;
    config.spaceHeight = 10;
    _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:config];
}

- (void)loadData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    XKWeakSelf(ws);
    parameters[@"type"] = @"getDislikeUser";
    parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postRequestWithURLString:@"project_war_exploded/userServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        [XKHudView hideHUDForView:self.tableView];
        self.dataArray = [NSArray yy_modelArrayWithClass:[BlackListModelData class] json:responseObject[@"data"]];
        self.emptyView.config.allowScroll = YES;
        if (self.dataArray.count == 0) {
            self.emptyView.config.viewAllowTap = NO;
            [self.emptyView showWithImgName:@"" title:nil des:@"还没有任何屏蔽哦" tapClick:nil];
        } else {
            [self.emptyView hide];
        }
        [self.tableView reloadData];
    } failure:^(XKHttpErrror *error) {
        if (self.dataArray.count == 0) {
            self.emptyView.config.allowScroll = NO;
            self.emptyView.config.viewAllowTap = YES; // 整个背景是否可点击  否则只有按钮可以点击
            [self.emptyView showWithImgName:@"" title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                [ws loadData];
            }];
        } else {
            [XKHudView showErrorMessage:error.message to:self.tableView animated:YES];
        }
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
        _dataArray = @[];
    }
    return _dataArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BlackListModelData *model = self.dataArray[indexPath.row];
    MinePersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text = model.nickname;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BlackListModelData *model = self.dataArray[indexPath.row];
    [GlobleCommonTool jumpPersonalDataWithUserId:model.userId name:model.nickname headerIcon:model.icon];
}

@end
