//
//  VerificationNextViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/11/18.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "VerificationNextViewController.h"
#import "VerificationNextModel.h"
#import "CYLTabBarController.h"
#import "BaseTabBarConfig.h"
#import "LoginViewController.h"

@interface VerificationNextViewController ()
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *addNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addPhoneTextField;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIView *longLine1;
@property (weak, nonatomic) IBOutlet UIView *line3;
@property (weak, nonatomic) IBOutlet UIView *longLine2;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewH;
@property (weak, nonatomic) IBOutlet UIView *contentView;
/**<##>*/
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, strong) NSMutableArray *phoneNumArray;
/***/
@property(nonatomic, assign) NSInteger currentNum;
/**<##>*/
@property(nonatomic, copy) NSString *currentNumPhone;
@end

@implementation VerificationNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    [self setNavTitle:@"添加用户" WithColor:HEX_RGB(0x222222)];
    [self showContentView:NO];
    [self loadPhoneNum];
    self.currentNum = 1;
    self.line1.backgroundColor = XKSeparatorLineColor;
    self.line2.backgroundColor = XKSeparatorLineColor;
    self.line3.backgroundColor = XKSeparatorLineColor;
    self.longLine1.backgroundColor = XKSeparatorLineColor;
    self.longLine2.backgroundColor = XKSeparatorLineColor;

    self.currentNumPhone = @"";
    [self.phoneTextField addTarget:self action:@selector(phoneTextFieldAction:) forControlEvents:UIControlEventEditingChanged];
    self.addButton.layer.masksToBounds = YES;
    self.addButton.layer.cornerRadius = 22;
}

- (void)showContentView:(BOOL)show {
    self.contentView.hidden = !show;
}

-(void)loadPhoneNum {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"chechUserLegal";
    parameters[@"estatesId"] = self.currentId;
    parameters[@"estatesLocation"] = self.currentHouse;

    [HTTPClient postRequestWithURLString:@"project_war_exploded/userServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        VerificationNextModel *model = [VerificationNextModel yy_modelWithJSON:responseObject];
        self.dataArray = model.data;
        for (VerificationNextModelData *modelData in self.dataArray) {
            [self.phoneNumArray addObject:modelData.phone];
        }
        if (self.phoneNumArray.count > 0) {
            self.currentNumPhone = [self getDealPhoneNum:self.phoneNumArray[self.currentNum]];
            self.phoneLabel.text = self.currentNumPhone;
        }
    } failure:^(XKHttpErrror *error) {
        [XKHudView showErrorMessage:error.message];
    }];
}


- (NSArray *)dataArray {
    if (!_dataArray ) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}


- (NSMutableArray *)phoneNumArray {
    if (!_phoneNumArray) {
        _phoneNumArray = [NSMutableArray array];
    }
    return _phoneNumArray;
}
- (IBAction)addAction:(UIButton *)sender {
    [self addUserNet];
}
- (IBAction)changePhoneNumAction:(UIButton *)sender {
    if (self.phoneNumArray.count > 0) {
        self.currentNumPhone = [self getDealPhoneNum:self.phoneNumArray[self.currentNum]];
        self.phoneLabel.text = self.currentNumPhone;
        if (self.currentNum >= self.phoneNumArray.count - 1) {
           self.currentNum = 1;
       }else{
           self.currentNum += 1;
       }
    }
   
}

- (NSString *)getDealPhoneNum:(NSString *)phoneNum {
    if (phoneNum.length > 4) {
        NSString *phone = phoneNum;
        NSRange range = NSMakeRange(0, phone.length - 4);
        return [phone substringWithRange:range];
    }else {
        return @"0000";
    }
}

- (void)phoneTextFieldAction:(UITextField *)sender {
    NSString *phone;
    if (self.phoneNumArray.count > 0){
       phone = self.phoneNumArray[self.currentNum];
    }else{
        phone = @"19940855384";
    }
    NSString *allPhone = [NSString stringWithFormat:@"%@%@",self.currentNumPhone,sender.text];
    if ([allPhone isEqualToString:phone]) {
        [self showContentView:YES];
        self.contentViewH.constant = 140;
        self.titleLabel.text = @"请输入我（被添加入）的信息";
    }else{
        [self showContentView:NO];
        self.contentViewH.constant = 0;
        self.titleLabel.text = @"如无对应电话，请联系物业办公室更换备案手机";
    }
}

- (void)addUserNet {
//    {"userHouse":"20","type":"addUser","userType":"2","userName":"fff", "phone":"123334"}
    if (self.addPhoneTextField.text.length < 11) {
        [XKHudView showTipMessage:@"请正确填写手机号"];
        return;
    }
    if (self.addNameTextField.text.length < 1) {
        [XKHudView showTipMessage:@"请正确填写昵称"];
        return;
    }
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    if (self.dataArray.count > 0) {
        VerificationNextModelData *modelData = self.dataArray[self.currentNum];
        parameters[@"userHouse"] = modelData.userbelonghouse.ID;
    }
    parameters[@"type"] = @"addUser";
    parameters[@"userType"] = @"2";
    parameters[@"userName"] = self.addNameTextField.text;
    parameters[@"phone"] = self.addPhoneTextField.text;

    [HTTPClient postRequestWithURLString:@"project_war_exploded/userServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        [XKHudView showSuccessMessage:@"添加成功"];
        LoginViewController *vc = [[LoginViewController alloc]init];
        vc.phone = self.addPhoneTextField.text;
           //正常登录
        vc.vcType = 1;
        [UIApplication sharedApplication].delegate.window.rootViewController = vc;
    } failure:^(XKHttpErrror *error) {
        [XKHudView showErrorMessage:error.message];
    }];
}
@end
