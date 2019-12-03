//
//  MineResidentManagementViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/13.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "MineResidentManagementViewController.h"
#import "MineResidentRedactRootTableViewCell.h"
#import "MineResidentRedactViewController.h"
#import "MineResidentRedactModel.h"

@interface MineResidentManagementViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView                     *tableView;
@property (nonatomic, strong) NSMutableArray        *dataArray;

@end

@implementation MineResidentManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"住户管理" WithColor:HEX_RGB(0x222222)];
    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadUserList];
}
- (void)initViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}



- (void)loadUserList {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"getUsersByme";
    parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;
    [self.dataArray removeAllObjects];
    [HTTPClient postRequestWithURLString:@"project_war_exploded/userServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        MineResidentRedactModel *model = [MineResidentRedactModel yy_modelWithJSON:responseObject];
        NSArray *modelArray = model.data;
        NSMutableArray *array1 = [NSMutableArray array];
        NSMutableArray *array2 = [NSMutableArray array];
        NSMutableArray *array3 = [NSMutableArray array];
        MineResidentRedactModelData *mineModel = [MineResidentRedactModelData new];
        mineModel.nickname = [LoginModel currentUser].data.users.nickname;
        mineModel.usertype = [LoginModel currentUser].currentUserType;
        [array1 addObject:mineModel];
        
        for (MineResidentRedactModelData *mmodel in modelArray) {
            if ([mmodel.usertype isEqualToString:@"1"]) {
                [array1 addObject:mmodel];
            }else if ([mmodel.usertype isEqualToString:@"2"]){
                [array2 addObject:mmodel];
            }else if ([mmodel.usertype isEqualToString:@"6"]){
                [array3 addObject:mmodel];
            }
        }
        NSArray *arrays = @[array1,array2,array3];
        [self.dataArray addObjectsFromArray:arrays];
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
        _tableView.tableFooterView = [self creatFooterView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = YES;
        [_tableView registerNib:[UINib nibWithNibName:@"MineResidentRedactRootTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineResidentRedactModelData *model = self.dataArray[indexPath.section][indexPath.row];
     MineResidentRedactRootTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == 0 && indexPath.section == 0) {
        [cell isShowNextImage:NO];
    }else{
        [cell isShowNextImage:YES];
    }
    cell.model = model;
    
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
    if (section == 0) {
        return CGFLOAT_MIN;
    }
     return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00000001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MineResidentRedactModelData *model = self.dataArray[indexPath.section][indexPath.row];
    if (indexPath.row == 0 && indexPath.section == 0) {
        
    }else{
        MineResidentRedactViewController *vc = [MineResidentRedactViewController new];
        vc.vcType = MineResidentRedactVCTyoeChange;
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (UIView *)creatFooterView {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    footerView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    UIButton *addButton = [UIButton new];
    [addButton setImage:[UIImage imageNamed:@"mine_set_10"] forState:0];
    [addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setTitle:@"添加住户" forState:0];
    [addButton setTitleColor:HEX_RGB(0xffffff) forState:0];
    [addButton setBackgroundColor:HEX_RGB(0x1B82D1)];
    addButton.layer.masksToBounds = YES;
    addButton.layer.cornerRadius = 22;
    [footerView addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.right.mas_equalTo(-26);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(44);
    }];
  
    return footerView;
}

- (void)addButtonAction:(UIButton *)sender {
    MineResidentRedactViewController *vc = [MineResidentRedactViewController new];
    vc.vcType = MineResidentRedactVCTyoeAdd;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    XKWeakSelf(ws);
    MineResidentRedactModelData *model = self.dataArray[indexPath.section][indexPath.row];

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteUserWithId:model.userbelonghouse.ID complete:^ (BOOL success){
            [ws.dataArray removeObject:model];
            NSMutableArray *sectionArray = self.dataArray[indexPath.section];
            [sectionArray removeObjectAtIndex:indexPath.row];
            if (sectionArray.count == 0) {
                // 要根据情况直接删除section或者仅仅删除row
                [ws.dataArray removeObjectAtIndex:indexPath.section];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                });
                
            }
           
        }];
    }
    
}

// 修改编辑按钮文字

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
    
}

- (void)deleteUserWithId:(NSString *)userId complete:(void(^)(BOOL success))complete{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"deleteUser";
    parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;
    parameters[@"userBelongHouseId"] =  userId;
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postRequestWithURLString:@"project_war_exploded/userServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        [XKHudView hideHUDForView:self.tableView];
        [XKHudView showSuccessMessage:@"删除成功"];
        complete(YES);
    } failure:^(XKHttpErrror *error) {
        complete(NO);
        [XKHudView hideHUDForView:self.tableView];
        [XKHudView showErrorMessage:error.message];
    }];
}
@end
