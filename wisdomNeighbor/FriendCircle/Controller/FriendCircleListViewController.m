//
//  FriendCircleListViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/22.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "FriendCircleListViewController.h"
#import "FriendCircleListImageTableViewCell.h"
#import "FriendCircleListShareTableViewCell.h"
#import "FriendTalkModel.h"
#import "FriendCircleDetailViewController.h"

@interface FriendCircleListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSArray *dataArray;
/**<##>*/
@property(nonatomic, strong) UIImageView *tableHeaderBgView;
@end

@implementation FriendCircleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"" WithColor:[UIColor blackColor]];
    [self hideNavigationSeperateLine];
    self.navigationView.backgroundColor = HEX_RGBA(0x4A90FA, 0);
    [self initViews];
    [self loadData];
}
- (void)initViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view);
    }];
}
- (void)loadData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"getOnesFriendsCircle";
    parameters[@"phoneNumber"] = [LoginModel currentUser].data.users.phone;
    parameters[@"lastId"] = @"0";
    parameters[@"estates"] = @"1";
    parameters[@"userId"] = self.userId;
    [HTTPClient postRequestWithURLString:@"project_war_exploded/friendsCircleServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        NSArray *array = [NSArray yy_modelArrayWithClass:[FriendTalkModel class] json:responseObject[@"data"]];
        self.dataArray = array;
        self.tableView.tableHeaderView = [self creatHeaderView];
        [self.tableView reloadData];
    } failure:^(XKHttpErrror *error) {
        [XKHudView showErrorMessage:error.message];
    }];
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xeeeeee);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [self creatHeaderView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FriendCircleListImageTableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerClass:[FriendCircleListShareTableViewCell class] forCellReuseIdentifier:@"cell2"];

        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _tableView;
}
- (UIView *)creatHeaderView {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
    headerView.backgroundColor = HEX_RGB(0xffffff);
    UIImageView *bgImageView = [[UIImageView alloc]init];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.image = [UIImage imageNamed:@"xk_view_bg"];
    bgImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180);
    [headerView addSubview:bgImageView];

     UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"   " forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"xk_btn_Mine_setting_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:backButton];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(50);
        make.size.mas_equalTo(CGSizeMake(9, 16));
    }];
    
    UIImageView *headerImageView = [UIImageView new];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:self.headerIcon] placeholderImage:[UIImage imageNamed:@"xk_ic_defult_head"]];
    headerImageView.layer.masksToBounds = YES;
    headerImageView.layer.cornerRadius = 5;
    [headerView addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.height.mas_equalTo(60);
        make.top.mas_equalTo(131);
    }];
    
    UILabel *titlelabel = [UILabel new];
    titlelabel.text = self.name;
    titlelabel.textColor = HEX_RGB(0xffffff);
    titlelabel.font = XKRegularFont(16);
    titlelabel.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerImageView.mas_left).offset(-12);
        make.centerY.equalTo(headerImageView.mas_centerY);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(20);
    }];
    self.tableHeaderBgView = bgImageView;
    
    return headerView;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTalkModel *model = self.dataArray[indexPath.section];

    NSArray * imageArray = [model.images componentsSeparatedByString:@"|"];
    if (imageArray.count <= 0) {
        FriendCircleListShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }else{
        FriendCircleListImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    FriendTalkModel *model = self.dataArray[section];
//    return model.comments.count;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 98;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTalkModel *model = self.dataArray[indexPath.section];
    FriendCircleDetailViewController *vc = [FriendCircleDetailViewController new];
    vc.circleId = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 30;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView =  [[UIView alloc]init];
    sectionHeaderView.backgroundColor = HEX_RGB(0xffffff);
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"2019年";
    titleLabel.font = XKMediumFont(29);
    titleLabel.textColor = HEX_RGB(0x000000);
    [sectionHeaderView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.bottom.equalTo(sectionHeaderView);
        make.right.mas_equalTo(-12);
    }];
    return sectionHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = 0;
    if (scrollView.mj_offsetY > 0) {//向上移动
        y = 0;
    } else {//向下移动
        y = scrollView.mj_offsetY;
    }
    self.tableHeaderBgView.y = y;
    self.tableHeaderBgView.height = 180  - y;
}

- (void)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
