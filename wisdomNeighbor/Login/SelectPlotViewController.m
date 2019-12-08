//
//  SelectPlotViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/12/7.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "SelectPlotViewController.h"
#import "XKMapManager.h"
#import "XKMapLocationDelegate.h"
#import "LoginHousingTableViewCell.h"
#import "LoginHousingModel.h"

@interface SelectPlotViewController ()<UITableViewDelegate,UITableViewDataSource,XKMapLocationDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITableView                     *tableView;
@property (nonatomic, strong) NSArray        *dataArray;
@property (nonatomic, strong) NSMutableArray  *currentDataArray;
/**搜索*/
@property(nonatomic, copy) NSString *keyWord;

@end

@implementation SelectPlotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.keyWord = @"";
    //地图
    [[[XKMapManager getCurrentMapFactory] getMapLocation] setLocationDelegate:self];
    [[[XKMapManager getCurrentMapFactory] getMapLocation] startBaiduSingleLocationService];
    [self setNavTitle:@"选择小区" WithColor:HEX_RGB(0x222222)];
    // FIXME: lilin
    [self loadDataWithlatitude:1.0 longtitude:2.0];
    [self initViews];
}
- (void)initViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (void)loadDataWithlatitude:(double)latitude longtitude:(double)longtitude {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"getEstatesVisitor";
    parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;
    // FIXME: lilin
    parameters[@"latitude"] = @"1";
    parameters[@"longtitude"] = @"1";
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postRequestWithURLString:@"project_war_exploded/estatesServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        [XKHudView hideHUDForView:self.tableView];
        self.dataArray = [NSArray yy_modelArrayWithClass:[LoginHousingModelData class] json:responseObject[@"data"]];
        self.currentDataArray = self.dataArray.mutableCopy;
        [self.tableView reloadData];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.tableView];
        [XKHudView showErrorMessage:error.message];
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
        _tableView.tableHeaderView = [self creatHeaderView];
        _tableView.scrollEnabled = YES;
        [_tableView registerNib:[UINib nibWithNibName:@"LoginHousingTableViewCell" bundle:nil]forCellReuseIdentifier:@"cell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _tableView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[];
    }
    return _dataArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LoginHousingModelData *model = self.dataArray[indexPath.row];
    LoginHousingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.leftLayout.constant = 0;
    cell.rightLayout.constant = 0;
    cell.lineView.backgroundColor = XKSeparatorLineColor;
    cell.housingModelData = model;
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
    LoginHousingModelData *model = self.dataArray[indexPath.row];
    if (self.selectBlock) {
        self.selectBlock(model.name,model.ID);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)creatHeaderView {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headerView.backgroundColor = HEX_RGB(0xf6f6f6);
    UIButton *seacheButton = [[UIButton alloc]init];
    [seacheButton setTitle:@"搜索" forState:0];
    [seacheButton setTitleColor:HEX_RGB(0x222222) forState:0];
    [seacheButton setBackgroundColor:HEX_RGB(0xffffff)];
    seacheButton.layer.masksToBounds = YES;
    seacheButton.layer.cornerRadius = 5;
    seacheButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [seacheButton.titleLabel setFont:XKRegularFont(14)];
    [seacheButton addTarget:self action:@selector(seacheButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:seacheButton];
    [seacheButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.right.equalTo(seacheButton.mas_left).offset(-10);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    UITextField *seacheTextField = [UITextField new];
    [textFieldContentView addSubview:seacheTextField];
    seacheTextField.delegate = self;
    seacheTextField.placeholder = @"搜索我的小区";
    seacheTextField.font = XKRegularFont(14);
    seacheTextField.textColor = HEX_RGB(0x999999);
    seacheTextField.backgroundColor = HEX_RGB(0xffffff);
    [seacheTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.equalTo(seacheButton.mas_left).offset(-10);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    return headerView;
}

- (NSMutableArray *)currentDataArray {
    if (!_currentDataArray) {
        _currentDataArray = [NSMutableArray array];
    }
    return _currentDataArray;
}

- (void)userLocationLaititude:(double)laititude longtitude:(double)longtitude {
    [self loadDataWithlatitude:laititude longtitude:longtitude];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.keyWord = textField.text;
    [self searchAction:textField.text];
}


- (void)seacheButtonAction:(UIButton *)sender {
    [self searchAction:self.keyWord];
}

- (void)searchAction:(NSString *)keyWord {
    NSMutableArray *array = [NSMutableArray array];
       if (self.currentDataArray.count > 0) {
           for (LoginHousingModelData *model in self.currentDataArray) {
               if ([model.name isEqualToString:keyWord]) {
                   [array addObject:model];
               }
           }
           self.dataArray = array.copy;
           [self.tableView reloadData];
       }
       
}
@end
