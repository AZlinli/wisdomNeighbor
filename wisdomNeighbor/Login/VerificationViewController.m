//
//  VerificationViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/11/18.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "VerificationViewController.h"
#import "VerificationModel.h"
#import "LoginHousingTableViewCell.h"
#import "VerificationNextViewController.h"

@interface VerificationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *dongTextField;
@property (weak, nonatomic) IBOutlet UITextField *danyuanTextField;
@property (weak, nonatomic) IBOutlet UITextField *louTextField;
@property (weak, nonatomic) IBOutlet UITextField *haoTextField;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
/**<##>*/
@property(nonatomic, strong) NSArray *dataArray;
/***/
@property(nonatomic, copy) NSString *currentId;
@property(nonatomic, copy) NSString *currentHouse;

@end

@implementation VerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"身份验证" WithColor:HEX_RGB(0x222222)];
    [self.nameTextField addTarget:self action:@selector(nameTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = HEX_RGB(0xf6f6f6);
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"LoginHousingTableViewCell" bundle:nil]forCellReuseIdentifier:@"cell"];
    self.checkButton.layer.masksToBounds = YES;
    self.checkButton.layer.cornerRadius = 22;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)nameTextFieldChange:(UITextField *)sender {
    NSLog(@"%@", sender.text);
    if (sender.text.length > 0) {
        [self loaddata:sender.text];
    }else{
        self.tableView.hidden = YES;
    }
}

- (void)loaddata:(NSString *)keyWord {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"searchEstates";
    parameters[@"estates"] = keyWord;
    [HTTPClient postRequestWithURLString:@"/project_war_exploded/estatesServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        VerificationModel *model = [VerificationModel yy_modelWithJSON:responseObject];
        self.dataArray = model.data;
        if (self.dataArray.count <= 0) {
            self.tableView.hidden = YES;
        }else{
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }
    } failure:^(XKHttpErrror *error) {
    }];
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[];
    }
    return _dataArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VerificationModelData *model = self.dataArray[indexPath.row];
        LoginHousingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.modelData = model;
        return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VerificationModelData *model = self.dataArray[indexPath.row];
    self.currentId = model.ID;
    self.tableView.hidden = YES;
}
- (IBAction)checkButtonAction:(UIButton *)sender {
    if (self.dongTextField.text.length < 0 || self.danyuanTextField.text.length < 0 || self.louTextField.text.length < 0 || self.haoTextField.text.length < 0) {
        [XKHudView showErrorMessage:@"请把资料填写完整"];
        return;
    }
    self.currentHouse = [NSString stringWithFormat:@"%@-%@-%@-%@",self.dongTextField.text,self.danyuanTextField.text,self.louTextField.text,self.haoTextField.text];
    VerificationNextViewController *vc = [[VerificationNextViewController alloc]initWithNibName:@"VerificationNextViewController" bundle:nil];
    vc.currentId = self.currentId;
    vc.currentHouse = self.currentHouse;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
