//
//  FriendCircleJurisdictionViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/30.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "FriendCircleJurisdictionViewController.h"
#import "XKPushMessageTableViewCell.h"
#import "BlackListModel.h"

@interface FriendCircleJurisdictionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSArray        *dataArray;
@property (nonatomic, assign) BOOL            isOpen;

@end

@implementation FriendCircleJurisdictionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"设置朋友圈权限" WithColor:[UIColor blackColor]];
    self.isOpen = NO;
    [self initViews];
    [self loadData];
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
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[XKPushMessageTableViewCell class] forCellReuseIdentifier:@"cell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _tableView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"不让他（她）看我",@"不看他（她)"];
    }
    return _dataArray;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKWeakSelf(ws);
    NSString *title = self.dataArray[indexPath.row];
    XKPushMessageTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text = title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([title isEqualToString:@"不让他（她）看我"]){
        cell.xkSwitch.on = self.isOpen;
        cell.switchChangeBLock = ^(UISwitch *xkSwitch) {
            [ws loadDataDislikeOrCancle:xkSwitch.isOn];
        };
    }
    else if ([title isEqualToString:@"不看他（她)"]){
        cell.xkSwitch.on = self.isOpen ;
        cell.switchChangeBLock = ^(UISwitch *xkSwitch) {
            [ws loadDataDislikeOrCancle:xkSwitch.isOn];
        };
        
    }
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00000001f;
}


- (void)loadData {
    XKWeakSelf(ws);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"getDislikeUser";
    parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postRequestWithURLString:@"project_war_exploded/userServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        [XKHudView hideHUDForView:self.tableView];
        NSArray *modelArray = [NSArray yy_modelArrayWithClass:[BlackListModelData class] json:responseObject[@"data"]];
       
        [modelArray enumerateObjectsUsingBlock:^(BlackListModelData *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self.userId isEqualToString:model.userId]) {
                ws.isOpen = YES;
                *stop = YES;
            }
            else{
                ws.isOpen = NO;
            }
        }];
        if (modelArray.count == 0) {
            ws.isOpen = NO;
        }
        [self.tableView reloadData];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.tableView];
        [XKHudView showErrorMessage:error.message];
    }];
}

- (void)loadDataDislikeOrCancle:(BOOL)dislikeOrCancle {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *dislikeOrCancleStr;
    if (dislikeOrCancle) {
        dislikeOrCancleStr = @"true";
    }else{
        dislikeOrCancleStr = @"false";
    }
    parameters[@"type"] = @"disLikeOne";
    parameters[@"dislikeOrCancle"] = dislikeOrCancleStr;
    parameters[@"disLikeUserId"] = self.userId;
    parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postRequestWithURLString:@"project_war_exploded/userServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        [XKHudView hideHUDForView:self.tableView];
        [self loadData];
        [self.tableView reloadData];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.tableView];
        [XKHudView showErrorMessage:error.message];
    }];
}


@end
