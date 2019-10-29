//
//  NoticeListViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/27.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "NoticeListViewController.h"
#import "NoticeModel.h"
#import "NoticeListTableViewCell.h"

@interface NoticeListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView                     *tableView;
@property (nonatomic, strong) NSArray        *dataArray;
@end

@implementation NoticeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"通知列表" WithColor:HEX_RGB(0x222222)];
    [self initViews];
    [self loadNewNotice];
}
- (void)initViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (void)loadNewNotice {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"getNotice";
    parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;
    parameters[@"lastId"] = @"0";
    [HTTPClient postRequestWithURLString:@"project_war_exploded/noticeServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        self.dataArray = [NSArray yy_modelArrayWithClass:[NoticeModelData class] json:responseObject[@"data"]];
        [self.tableView reloadData];
    } failure:^(XKHttpErrror *error) {
    }];
}

#pragma mark – Getters and Setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        [_tableView registerClass:[NoticeListTableViewCell class] forCellReuseIdentifier:@"cell"];
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
    NoticeModelData *model = self.dataArray[indexPath.row];
    NoticeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

@end
