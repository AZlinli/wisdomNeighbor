//
//  MinePersonalViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/13.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "MinePersonalViewController.h"
#import "MinePersonalTableViewCell.h"
#import "MinePersonalHeaderTableViewCell.h"
#import "XKChangeNicknameViewController.h"

@interface MinePersonalViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView                     *tableView;
@property (nonatomic, strong) NSArray        *dataArray;
@property (nonatomic, strong) XKPhotoPickHelper               *bottomSheetView;
/**nickName*/
@property(nonatomic, copy) NSString *nickName;
@end

@implementation MinePersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"个人信息" WithColor:HEX_RGB(0x222222)];
    self.nickName = [LoginModel currentUser].data.users.nickname;
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
        [_tableView registerClass:[MinePersonalHeaderTableViewCell class] forCellReuseIdentifier:@"headerCell"];

        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _tableView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@[@"头像"],@[@"真实姓名",@"昵称",@"性别",@"手机号码"]];
    }
    return _dataArray;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataArray[indexPath.section][indexPath.row];
    if ([title isEqualToString:@"头像"]) {
        MinePersonalHeaderTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"headerCell" forIndexPath:indexPath];
        [headerCell.headerImageView sd_setImageWithURL:[NSURL URLWithString:[LoginModel currentUser].data.users.icon] placeholderImage:kDefaultHeadImg];
        return headerCell;
    }else{
        MinePersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.titleLabel.text = title;
        cell.nextImageView.hidden = YES;
        [cell.myContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(cell.contentView);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
        cell.myContentView.xk_openClip = YES;
        cell.myContentView.xk_radius = 8;
        if([title isEqualToString:@"真实姓名"]) {
            cell.rightTitlelabel.text = [LoginModel currentUser].data.users.truename;
            cell.myContentView.xk_clipType = XKCornerClipTypeTopBoth;
        } else if ([title isEqualToString:@"昵称"]){
            cell.rightTitlelabel.text =  [LoginModel currentUser].data.users.nickname;
            cell.myContentView.xk_clipType = XKCornerClipTypeNone;
        }
        else if ([title isEqualToString:@"ID编号"]){
            cell.rightTitlelabel.text =  [LoginModel currentUser].data.users.userId;
        }
        else if ([title isEqualToString:@"身份类型"]){
            cell.rightTitlelabel.text =  [LoginModel currentUser].data.users.truename;
        }
        else if ([title isEqualToString:@"性别"]){
            cell.rightTitlelabel.text =  [LoginModel currentUser].data.users.sex;
            cell.myContentView.xk_clipType = XKCornerClipTypeNone;

        }
        else if ([title isEqualToString:@"手机号码"]){
            cell.rightTitlelabel.text =  [LoginModel currentUser].data.users.phone;
            cell.myContentView.xk_clipType = XKCornerClipTypeBottomBoth;
            
        }
        return cell;
    }
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataArray[indexPath.section][indexPath.row];
    if ([title isEqualToString:@"头像"]) {
        return 75;
    }else{
        return 52;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 15;
    }else if (section == 1) {
        return 10;
    }else{
        return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = self.dataArray[indexPath.section][indexPath.row];
    if ([title isEqualToString:@"头像"]) {
        [self.bottomSheetView showView];
    }else if ([title isEqualToString:@"真实姓名"]){
//        [XKHudView showTipMessage:@"该功能还在开发中"];
    }else if ([title isEqualToString:@"昵称"]){
        XKWeakSelf(ws);
        XKChangeNicknameViewController *vc = [XKChangeNicknameViewController new];
        vc.useType = 1;
        vc.limitNum = 20;
        if (self.nickName) {
            vc.nickName = self.nickName;
        }
        vc.title = title;
        vc.block = ^(NSString *text) {
            ws.nickName = text;
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"nickName"] = text;
            parameters[@"type"] = @"updateNickName";
            parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;
            [ws upImageDataWithParameters:parameters];
            [ws.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"ID编号"]){
        [XKHudView showTipMessage:@"该功能还在开发中"];

    }else if ([title isEqualToString:@"身份类型"]){
        [XKHudView showTipMessage:@"该功能还在开发中"];

    }else if ([title isEqualToString:@"性别"]){
//        [XKHudView showTipMessage:@"该功能还在开发中"];

    }else if ([title isEqualToString:@"手机号码"]){
//        [XKHudView showTipMessage:@"该功能还在开发中"];

    }
}

- (XKPhotoPickHelper *)bottomSheetView {
    if(!_bottomSheetView) {
        XKWeakSelf(ws);
        _bottomSheetView = [[XKPhotoPickHelper alloc] init];
        _bottomSheetView.allowCrop = YES;
        _bottomSheetView.maxCount = 1;
        [_bottomSheetView handleVideoChoseWithNeeded:NO];
        _bottomSheetView.choseImageBlcok = ^(NSArray<UIImage *> * _Nullable images) {
            for (UIImage *image in images) {
                [XKHudView showLoadingTo:ws.tableView animated:YES];
                [[QCloudManager shareManager]uploadImage:image withKey:@"headerImage" success:^(NSString * _Nonnull url) {
                    [XKHudView hideHUDForView:ws.tableView animated:YES];
                    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                    parameters[@"icon"] = url;
                    parameters[@"type"] = @"updateIcon";
                    parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;
                    [ws upImageDataWithParameters:parameters];

                } failure:^(NSString * _Nonnull data) {
                    [XKHudView hideHUDForView:ws.tableView animated:YES];
                    [XKHudView showErrorMessage:@"头像上传失败"];
                }];
            }
        };
        
    }
    return _bottomSheetView;
}

- (void)upImageDataWithParameters:(NSDictionary *)parameters {
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postRequestWithURLString:@"project_war_exploded/userServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        if (parameters[@"icon"]) {
            [LoginModel currentUser].data.users.icon = parameters[@"icon"];
            XKUserSynchronize;
        }
        if (parameters[@"nickName"]) {
            [LoginModel currentUser].data.users.nickname = parameters[@"nickName"];
            XKUserSynchronize;
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:FriendPageReloadNotification object:nil];
        [XKHudView hideHUDForView:self.tableView animated:YES];
        [XKHudView showSuccessMessage:@"更新成功"];
        [self.tableView reloadData];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.tableView animated:YES];
        [XKHudView showErrorMessage:error.message to:self.tableView animated:YES];
    }];
}


@end
