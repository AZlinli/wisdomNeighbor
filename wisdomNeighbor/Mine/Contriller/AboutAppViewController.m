//
//  AboutAppViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/10/11.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "AboutAppViewController.h"
#import "MinePersonalTableViewCell.h"
#import "XKJumpWebViewController.h"

@interface AboutAppViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSArray        *dataArray;
/**电话号码*/
@property(nonatomic, copy) NSString *phoneNum;


@end

@implementation AboutAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"关于智邻" WithColor:[UIColor blackColor]];
    [self initViews];
    self.phoneNum = @"13880097700";
}

#pragma mark – Private Methods
- (void)initViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NavigationAndStatue_Height));
        make.left.bottom.right.equalTo(self.view);
    }];
    
    UILabel *protocolLabel = [UILabel new];
    protocolLabel.textAlignment = NSTextAlignmentCenter;
    protocolLabel.text = @"用户服务协议";
    protocolLabel.textColor = XKMainTypeColor;
    protocolLabel.userInteractionEnabled = YES;
    [protocolLabel bk_whenTapped:^{
        NSString *h5String = @"http://139.155.41.184:8090/system/loginProvision";
        XKJumpWebViewController *vc = [[XKJumpWebViewController alloc] init];
        vc.url = h5String;
        vc.title = @"智邻用户协议";
        [self presentViewController:vc animated:YES completion:nil];
    }];
    [self.view addSubview:protocolLabel];
    [protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-40);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark – Getters and Setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xffffff);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
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
        _dataArray = @[@"联系我们"];
    }
    return _dataArray;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataArray[indexPath.row];
    MinePersonalTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if ([title isEqualToString:@"联系我们"]) {
        cell.nextImageView.hidden = YES;
        UIView *line = [UIView new];
        line.backgroundColor = XKSeparatorLineColor;
        [cell.myContentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.left.right.top.equalTo(cell.myContentView);
        }];
        [cell.titleLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text([NSString stringWithFormat:@"%@-",title]).textColor(HEX_RGB(0x000000)).font(XKRegularFont(15));
        confer.text(self.phoneNum).textColor(XKMainTypeColor).font(XKRegularFont(15));
        }];
    }
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataArray[indexPath.row];
    if ([title isEqualToString:@"联系我们"]) {
        [self contactMe];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
    headerView.backgroundColor = HEX_RGB(0xffffff);
    UIImageView *headerImageView = [[UIImageView alloc]init];
    headerImageView.image = [UIImage imageNamed:[self getAppIconName]];
    [headerView addSubview:headerImageView];
    headerImageView.clipsToBounds = YES;
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.mas_equalTo(50);
        make.height.equalTo(@(80));
        make.width.equalTo(@(80));
    }];
    UILabel *label = [[UILabel alloc]init];
    [label rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(@"智邻").font(XKMediumFont(16)).textColor(HEX_RGB(0x000000));
        confer.text(@"\n");
        confer.text([NSString stringWithFormat:@"v%@",XKAppVersion]).font(XKMediumFont(16)).textColor(HEX_RGB(0x000000));
    }];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.equalTo(headerImageView.mas_bottom).offset(30);
        make.width.equalTo(@100);
    }];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]init];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 240;
    }else {
        return 0.00000001f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00000001f;
}


//获取appIconName
-(NSString*)getAppIconName{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    NSLog(@"GetAppIconName,icon:%@",icon);
    return icon;
}

- (void)contactMe {
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.phoneNum];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
}

@end
