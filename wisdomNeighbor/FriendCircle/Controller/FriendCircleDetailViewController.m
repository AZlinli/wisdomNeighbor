//
//  FriendCircleDetailViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/30.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "FriendCircleDetailViewController.h"
#import "FriendsCircleListViewModel.h"

@interface FriendCircleDetailViewController ()
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong) FriendsCircleListViewModel *viewModel;

@end

@implementation FriendCircleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"朋友圈详情" WithColor:HEX_RGB(0x000000)];
    [self createUI];
    [self loadDataWithCircleId:self.circleId NeedTip:YES];
}

#pragma mark - 初始化界面
- (void)createUI {
    self.view.backgroundColor = HEX_RGB(0xEEEEEE);
    self.view.clipsToBounds = YES;
    [self createTableView];
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.clipsToBounds = NO;
    _tableView.backgroundColor = HEX_RGB(0xEEEEEE);
    [self.view addSubview:_tableView];
    [self.view bringSubviewToFront:self.navigationView];
    //处理留白
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom).offset(-kStatusBarHeight);
        make.bottom.equalTo(self.view);
    }];
    
    _tableView.delegate = self.viewModel;
    _tableView.dataSource = self.viewModel;
    
    _tableView.estimatedRowHeight = 100;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak typeof(self) weakSelf = self;
    [self.viewModel registerCellForTableView:self.tableView];
    [self.viewModel configVCToolBar:self];
    [self.viewModel setRefreshTableView:^{
        [weakSelf.tableView reloadData];
    }];
}


- (void)loadDataWithCircleId:(NSString *)circleId NeedTip:(BOOL)needTip{
    if (needTip) {
        [XKHudView showLoadingTo:self.tableView animated:YES];
    }
    [self.viewModel requestDetailWithFriendsCircleId:circleId complete:^(id  _Nonnull error, id  _Nonnull data) {
        [XKHudView hideHUDForView:self.tableView animated:YES];
        [self.tableView reloadData];
    }];
}

- (FriendsCircleListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[FriendsCircleListViewModel alloc] init];
    }
    return _viewModel;
}

@end
