//
//  FriendCircleSearchViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/10/8.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "FriendCircleSearchViewController.h"
#import "FriendsCircleListViewModel.h"

@interface FriendCircleSearchViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITableView                     *tableView;
@property(nonatomic, strong) FriendsCircleListViewModel *viewModel;
/**搜索的关键字*/
@property(nonatomic, copy) NSString *keyWord;
@end

@implementation FriendCircleSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"搜索" WithColor:HEX_RGB(0x000000)];
    [self createUI];
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
        make.top.equalTo(self.navigationView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    _tableView.delegate = self.viewModel;
    _tableView.dataSource = self.viewModel;
    _tableView.tableHeaderView = [self creatHeaderView];
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


- (UIView *)creatHeaderView {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headerView.backgroundColor = HEX_RGB(0xf6f6f6);
    UIButton *searchButton = [[UIButton alloc]init];
    [searchButton setTitle:@"搜索" forState:0];
    [searchButton setTitleColor:HEX_RGB(0x222222) forState:0];
    [searchButton setBackgroundColor:HEX_RGB(0xffffff)];
    searchButton.layer.masksToBounds = YES;
    searchButton.layer.cornerRadius = 5;
    [searchButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    searchButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [searchButton.titleLabel setFont:XKRegularFont(14)];
    [headerView addSubview:searchButton];
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.right.equalTo(searchButton.mas_left).offset(-10);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    UITextField *searchTextField = [UITextField new];
    [textFieldContentView addSubview:searchTextField];
    searchTextField.placeholder = @"搜索朋友圈";
    searchTextField.delegate = self;
    searchTextField.returnKeyType = UIReturnKeySearch;
    [searchTextField addTarget:self action:@selector(changeWord:) forControlEvents:UIControlEventEditingChanged];
    searchTextField.font = XKRegularFont(14);
    searchTextField.textColor = HEX_RGB(0x999999);
    searchTextField.backgroundColor = HEX_RGB(0xffffff);
    [searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.equalTo(searchButton.mas_left).offset(-10);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    return headerView;
}

- (FriendsCircleListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[FriendsCircleListViewModel alloc] init];
    }
    return _viewModel;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self loadDataWithCircleKeyWord:textField.text NeedTip:YES];
}

- (void)changeWord:(UITextField *)sender {
    self.keyWord = sender.text;
}

- (void)searchAction:(UIButton *)sender {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];//取消第一响应者
    return YES;
}

- (void)loadDataWithCircleKeyWord:(NSString *)keyWord NeedTip:(BOOL)needTip{
    if (needTip) {
        [XKHudView showLoadingTo:self.tableView animated:YES];
    }
    [self.viewModel requestDetailWithFriendsKeyWord:keyWord complete:^(id  _Nonnull error, id  _Nonnull data) {
        [XKHudView hideHUDForView:self.tableView animated:YES];
        [self.tableView reloadData];
    }];
}
@end
