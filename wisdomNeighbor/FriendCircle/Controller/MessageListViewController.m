//
//  MessageListViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/21.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageListTableViewCell.h"
#import "MessageListModel.h"
#import "FriendCircleListViewController.h"

@interface MessageListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"消息" WithColor:[UIColor blackColor]];
//    [self setNavRightButton];
    [self initViews];
    [self loadData];
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
    [button setTitle:@"清空" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    [button addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setRightView:button withframe:CGRectMake(0, 0, XKViewSize(45), 20)];
}

- (UIView *)footerView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56)];
    UILabel *remindLabel = [UILabel new];
    
    [remindLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(@"查看更多消息...").textColor(HEX_RGB(0x000000)).font(XKRegularFont(14));
    }];
    remindLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:remindLabel];
    [remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.centerX.equalTo(view);
        make.height.mas_equalTo(16);
    }];
    return view;
}
#pragma mark – action

-(void)deleteAction:(UIButton *)sender {
    
}

- (void)loadData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"getMeCommentsList";
    parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;
    parameters[@"lastId"] = @"0";
    [HTTPClient postRequestWithURLString:@"project_war_exploded/commentsServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        NSArray *modelArray = [NSArray yy_modelArrayWithClass:[MessageListModelData class] json:responseObject[@"data"]];
        self.dataArray = modelArray.mutableCopy;
        [self.tableView reloadData];
    } failure:^(XKHttpErrror *error) {
        [XKHudView showErrorMessage:error.message];
    }];
}

#pragma mark – Getters and Setters

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xeeeeee);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [self footerView];
        [_tableView registerClass:[MessageListTableViewCell class] forCellReuseIdentifier:@"cell"];
       
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListModelData *model = self.dataArray[indexPath.row];
    MessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 79;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListModelData *model = self.dataArray[indexPath.row];
    [GlobleCommonTool jumpCircleListWithUserId:model.comments.userId name:model.comments.nickname headerIcon:model.comments.icon];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

@end
