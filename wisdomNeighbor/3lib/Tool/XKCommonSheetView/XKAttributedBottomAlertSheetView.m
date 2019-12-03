//
//  XKAttributedBottomAlertSheetView.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/10/15.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "XKAttributedBottomAlertSheetView.h"
#import "XKBottomAlertSheetCell.h"
@interface XKAttributedBottomAlertSheetView () <UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *coverView;
@property (nonatomic, strong)UIColor *titleColor;
@property (nonatomic, copy)void(^choseBlock)(NSInteger index, NSAttributedString *choseTitle);
@end

@implementation XKAttributedBottomAlertSheetView
- (instancetype)initWithBottomSheetViewWithDataSource:(NSArray *)dataSource choseBlock:(void(^)(NSInteger index, NSAttributedString *choseTitle))choseBlock {
    self = [[XKAttributedBottomAlertSheetView alloc] init];
    if(self) {
        self.dataSource = dataSource;
        self.choseBlock = choseBlock;
        self.tableView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, dataSource.count * 50 + 5 + kBottomSafeHeight);
        self.coverView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.tableView.height);
    }
    
    return self;
}
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化默认数据
        [self createDefaultData];
        // 初始化UI
        [self createUI];
    }
    return self;
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    
}

- (void)updataData {
    [self.tableView reloadData];
    self.tableView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.dataSource.count * 50 + 5 + kBottomSafeHeight);
    self.coverView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.tableView.height);
}

#pragma mark - 初始化UI
- (void)createUI {
    self.frame = [UIScreen mainScreen].bounds;
    UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    dismissTap.delegate = self;
    [self addGestureRecognizer:dismissTap];
    [self addSubview:self.tableView];
    //[self addSubview:self.coverView];
}

#pragma mark - 显示
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.tableView reloadData];
    self.backgroundColor = RGBA(0, 0, 0, 0.0);
    XKWeakSelf(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.backgroundColor = RGBA(0, 0, 0, 0.5);
        weakSelf.tableView.bottom = weakSelf.height;
    }];
}

#pragma mark - 消失
- (void)dismissSelf {
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0);
        self.tableView.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma 手势代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

#pragma tableview代理
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? _dataSource.count - 1 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKBottomAlertSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKBottomAlertSheetCell" forIndexPath:indexPath];
    if(indexPath.section == 0) {
        NSAttributedString *text = _dataSource[indexPath.row];
        cell.nameLabel.attributedText = text;
    } else {
        cell.nameLabel.attributedText = _dataSource.lastObject;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(self.choseBlock) {
        if(indexPath.section == 0) {
            NSAttributedString *titleAt = _dataSource[indexPath.row];
            self.choseBlock(indexPath.row, titleAt);
            [self dismissSelf];
        } else {
            [self dismissSelf];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 5 : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    
    UIView *footTopView = [[UIView alloc] init];
    footTopView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    return section == 0 ? footTopView : footView;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[XKBottomAlertSheetCell class] forCellReuseIdentifier:@"XKBottomAlertSheetCell"];
    }
    return _tableView;
    
}

- (UIView *)coverView {
    if(!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor clearColor];
    }
    return _coverView;
}
@end
