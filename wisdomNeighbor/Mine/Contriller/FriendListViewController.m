//
//  FriendListViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/30.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "FriendListViewController.h"
#import "FriendListTableViewCell.h"

@interface FriendListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView                     *tableView;
@property (nonatomic, strong) NSArray        *dataArray;


@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"星标好友" WithColor:HEX_RGB(0x222222)];
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
        _tableView.scrollEnabled = YES;
        [_tableView registerClass:[FriendListTableViewCell class] forCellReuseIdentifier:@"cell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _tableView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@[@"哈哈",@"嘻嘻"],@[@"呵呵"],@[@"呼呼"]];
    }
    return _dataArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataArray[indexPath.section][indexPath.row];
    FriendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.nameLabel.text = title;
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
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UIView *contentView = [[UIView alloc]init];
    [headerView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerView);
    }];
    contentView.backgroundColor = HEX_RGB(0xffffff);
    UIView *labelView = [[UIView alloc]init];
    [contentView addSubview:labelView];
    labelView.backgroundColor = HEX_RGB(0xFFFFFF);
    [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(contentView);
        make.height.equalTo(@(20 * ScreenScale));
    }];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    titleLabel.text = @"A";
    titleLabel.textColor = HEX_RGB(0x222222);
    titleLabel.backgroundColor = HEX_RGB(0xffffff);
    [labelView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(19 * ScreenScale));
        make.bottom.right.equalTo(labelView);
        make.height.equalTo(@(20 * ScreenScale));
    }];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]init];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00000001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

//设置右侧索引的标题
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return @[@"A",@"B"];
}
@end
