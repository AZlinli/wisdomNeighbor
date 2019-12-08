//
//  RegistPlotViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/12/5.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "RegistPlotViewController.h"
#import "RegistPlotTableViewCell.h"
#import "SelectPlotViewController.h"

@interface RegistPlotViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView                     *tableView;
@property (nonatomic, strong) NSArray        *dataArray;
/**装有修改数据的字典*/
@property(nonatomic, strong) NSMutableDictionary *dict;
/**estates*/
@property(nonatomic, copy) NSString *estates;
@end

@implementation RegistPlotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"申请加入小区" WithColor:HEX_RGB(0x222222)];
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
        _tableView.tableFooterView = [self creatFooterView];
        _tableView.scrollEnabled = YES;
        [_tableView registerClass:[RegistPlotTableViewCell class] forCellReuseIdentifier:@"cell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _tableView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"选择小区",@"几栋几单元几号",@"手机号码",@"姓名",@"邀请人（选填）",];
    }
    return _dataArray;
}

- (NSMutableDictionary *)dict {
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataArray[indexPath.row];
    RegistPlotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(150);
    }];
    cell.titleLabel.text = title;
    cell.rightTitlelabel.delegate = self;
    cell.rightTitlelabel.text = self.dict[title];
    cell.rightTitlelabel.tag = indexPath.row + 10000;
    if ([title isEqualToString:@"选择小区"]) {
        cell.rightTitlelabel.enabled = NO;
        cell.nextImageView.hidden = NO;
    }else{
        cell.rightTitlelabel.enabled = YES;
        cell.nextImageView.hidden = YES;
    }
    if ([title isEqualToString:@"几栋几单元几号"]) {
        cell.rightTitlelabel.placeholder = @"如：一栋一单元301";
    }
    if ([title isEqualToString:@"手机号码"]) {
           cell.rightTitlelabel.placeholder = @"手机号码";
        cell.rightTitlelabel.keyboardType = UIKeyboardTypePhonePad;
       }
    cell.numLabel.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    headerView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.dataArray[indexPath.row];
    if ([title isEqualToString:@"选择小区"]){
        SelectPlotViewController *vc = [SelectPlotViewController new];
        XKWeakSelf(ws);
        vc.selectBlock = ^(NSString * _Nonnull name,NSString * _Nonnull ID) {
            ws.dict[title] = name;
            ws.estates = ID;
            [ws.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)creatFooterView {
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    footer.backgroundColor = UIColorFromRGB(0xf6f6f6);
    UIButton *nextButton = [UIButton new];
    [nextButton setTitle:@"提交申请" forState:0];
    [nextButton setTitleColor:[UIColor whiteColor] forState:0];
    nextButton.backgroundColor = XKMainTypeColor;
    nextButton.layer.masksToBounds = YES;
    nextButton.layer.cornerRadius = 22;
    [nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(20);
    }];
    return footer;
}

- (void)nextButtonAction:(UIButton *)sender {
    if (!self.estates || !self.dict[@"几栋几单元几号"] || !self.dict[@"手机号码"] || !self.dict[@"姓名"]) {
        [XKHudView showErrorMessage:@"请填写完整信息！"];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *par = [NSMutableDictionary dictionary];
    parameters[@"requestAudit"] = par;
    parameters[@"type"] = @"submitEnterEstatesRequest";
    par[@"estates"] = self.estates;
    par[@"estateslocation"] = self.dict[@"几栋几单元几号"];
    if (self.dict[@"邀请人（选填）"]) {
        par[@"inviteNum"] = self.dict[@"邀请人（选填）"];
    }
    par[@"phone"] = self.dict[@"手机号码"];
    par[@"truename"] = self.dict[@"姓名"];
    
    [HTTPClient postRequestWithURLString:@"project_war_exploded/requestauditServlet" timeoutInterval:30 parameters:parameters success:^(id responseObject) {
        [XKHudView showSuccessMessage:@"申请提交成功，请等待审核!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    } failure:^(XKHttpErrror *error) {
        [XKHudView showErrorMessage:error.message];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 10001) {
        self.dict[self.dataArray[1]] = textField.text;
    }else if (textField.tag == 10002){
        self.dict[self.dataArray[2]] = textField.text;

    }else if (textField.tag == 10003){
        self.dict[self.dataArray[3]] = textField.text;

    }else if (textField.tag == 10004){
        self.dict[self.dataArray[4]] = textField.text;

    }
}
@end
