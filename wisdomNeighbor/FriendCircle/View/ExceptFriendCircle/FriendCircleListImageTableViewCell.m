//
//  FriendCircleListImageTableViewCell.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/22.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "FriendCircleListImageTableViewCell.h"
#import "FriendCirclePublishController.h"

@interface FriendCircleListImageTableViewCell()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *numLabel;
@property (nonatomic, strong)UIImageView *listImageView;


@end

@implementation FriendCircleListImageTableViewCell

- (void)setModel:(FriendTalkModel *)model {
    _model = model;
    if (self.isMinePpecial) {
        [self.timeLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(@"今天").font(XKMediumFont(23)).textColor(HEX_RGB(0x000000));
        }];
        self.listImageView.image = [UIImage imageNamed:@"xk_btn_friendsCirclePermissions_add"];
        self.listImageView.userInteractionEnabled = YES;
        [self.listImageView bk_whenTapped:^{
            FriendCirclePublishController *vc = [FriendCirclePublishController new];
            [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
        }];
        self.titleLabel.text = @"";
        self.addessLabel.text = model.locationaddress;
        self.numLabel.hidden = YES;
    }else{
        self.listImageView.userInteractionEnabled = NO;
        self.titleLabel.text = model.content;
        self.addessLabel.text = model.locationaddress;
        NSString *day = [self getCurrentDayTimeString:model.createtime];
        NSString *month = [self getCurrentMonthTimeString:model.createtime];
        NSString *monthStr = [NSString stringWithFormat:@"%@月",month];
        [self.timeLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(day).font(XKMediumFont(23)).textColor(HEX_RGB(0x000000));
            confer.text(monthStr).font(XKRegularFont(12)).textColor(HEX_RGB(0x000000));
        }];
        NSArray * imageArray = [model.images componentsSeparatedByString:@"|"];
        NSMutableArray *picArray = [NSMutableArray array];
        [imageArray enumerateObjectsUsingBlock:^(NSString *urlStr, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([urlStr containsString:@".mp4"]) {
            }else{
                [picArray addObject:urlStr];
            }
        }];
        
        if (model.images) {
            if (picArray.count >= 1) {
                [self.listImageView sd_setImageWithURL:picArray[0] placeholderImage:kDefaultPlaceHolderImg];
            };
            if (picArray.count > 0) {
                self.numLabel.text = [NSString stringWithFormat:@"%lu张",(unsigned long)picArray.count];
                self.numLabel.hidden = NO;
            }else{
                self.numLabel.hidden = YES;
            }
            return;
            if (picArray.count == 1) {
                [self.listImageView sd_setImageWithURL:picArray[0] placeholderImage:kDefaultPlaceHolderImg];
            }else if (picArray.count == 2){
                [self downLoadImageWithPicArray:picArray block:^(NSArray *picArray) {
                    //合并
                    UIGraphicsBeginImageContextWithOptions(CGSizeMake(450, 450), NO, 0.0);
                    for (int i = 0; i < picArray.count; i ++) {
                        UIImage *image = picArray[i];
                        [image drawInRect:CGRectMake(i * 225, 0, 225, 450)];
                    }
                    //给ImageView赋值
                    self.listImageView.image = UIGraphicsGetImageFromCurrentImageContext();
                    //关闭上下文
                    UIGraphicsEndImageContext();
                }];
            }else if (picArray.count == 3){
                [self downLoadImageWithPicArray:picArray block:^(NSArray *picArray) {
                    //合并
                    UIGraphicsBeginImageContextWithOptions(CGSizeMake(450, 450), NO, 0.0);
                    for (int i = 0; i < picArray.count; i ++) {
                        UIImage *image = picArray[i];
                        if (i == 0) {
                            [image drawInRect:CGRectMake(0, 0, 225, 450)];
                        }else{
                            [image drawInRect:CGRectMake(225, 225*(i -1), 225, 225)];
                        }
                    }
                    //给ImageView赋值
                    self.listImageView.image = UIGraphicsGetImageFromCurrentImageContext();
                    //关闭上下文
                    UIGraphicsEndImageContext();
                }];
            }else if (picArray.count >= 4){
                [self downLoadImageWithPicArray:picArray block:^(NSArray *picArray) {
                    //合并
                    UIGraphicsBeginImageContextWithOptions(CGSizeMake(450, 450), NO, 0.0);
                    for (int i = 0; i < 4; i ++) {
                        UIImage *image = picArray[i];
                        if (i == 0) {
                            [image drawInRect:CGRectMake(0, 0, 225, 225)];
                            
                        }else if ( i== 1){
                            [image drawInRect:CGRectMake(225, 0, 225, 225)];
                        }else if ( i== 2){
                            [image drawInRect:CGRectMake(0, 225, 225, 225)];
                        }else if ( i== 3){
                            [image drawInRect:CGRectMake(225, 225, 225, 225)];
                        }
                    }
                    //给ImageView赋值
                    self.listImageView.image = UIGraphicsGetImageFromCurrentImageContext();
                    //关闭上下文
                    UIGraphicsEndImageContext();
                }];
            }
        }
    }
}

- (void)initViews {
    [super initViews];
    [self.myContentView addSubview:self.titleLabel];
    [self.myContentView addSubview:self.numLabel];
    [self.myContentView addSubview:self.listImageView];
    [self.listImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.myContentView);
        make.width.mas_equalTo(70);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.listImageView.mas_right).offset(10);
        make.top.equalTo(self.listImageView.mas_top);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-15);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.listImageView.mas_right).offset(10);
        make.bottom.equalTo(self.listImageView.mas_bottom);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-15);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = XKRegularFont(14);
        _titleLabel.textColor = HEX_RGB(0x010101);
    }
    return _titleLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [UILabel new];
        _numLabel.font = XKRegularFont(14);
        _numLabel.textColor = HEX_RGB(0x606772);
    }
    return _numLabel;
}

- (UIImageView *)listImageView {
    if (!_listImageView) {
        _listImageView = [UIImageView new];
    }
    return _listImageView;
}


-(void)downLoadImageWithPicArray:(NSArray *)picArray block:(void(^)(NSArray * picArray))downLoadSuccess{
    
    __weak typeof(self) weakSelf = self;
    // 创建分组
    dispatch_group_t  group = dispatch_group_create();
    // 创建队列
    dispatch_queue_t  queue = dispatch_queue_create("downLoadImage", DISPATCH_QUEUE_CONCURRENT);
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0;i < picArray.count; i++) {
        __block UIImage *image = nil;
        dispatch_group_enter(group);
        // 请求依次执行  与 dispatch_group_leave 配对使用
        dispatch_group_async(group, queue, ^{
            //处理耗时的操作
            image = [weakSelf imageWithUrl:picArray[i]];
            if (image) {
                [array addObject:image];
            }
            dispatch_group_leave(group);
        });
    }
    // 分组中任务完成后通知该block执行
    dispatch_group_notify(group, queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 通知主线程刷新UI
            downLoadSuccess(array.copy);
        });
    });
}

- (UIImage *) imageWithUrl :(NSString *) urlStr{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:data];
}


@end
