//
//  FriendCirclePublishController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/22.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "FriendCirclePublishController.h"
#import "XKEmojiTextView.h"
#import "XKSectionHeaderArrowView.h"
#import "XKChooseMediaCell.h"
#import "XKMediaPickHelper.h"
#import "XKUploadMediaInfo.h"
#import "XKFriendCirclePublishViewModel.h"
#import "BigPhotoPreviewDeleteController.h"
#import "PhotoPreviewModel.h"
#import "XKMapManager.h"
#import "XKMapLocationDelegate.h"
#import "XKClearVideoDisplayViewController.h"

#define kItemWidth  ((int)((SCREEN_WIDTH + 5 - 20 - 15 * 2 - kItemSpace * 2) / 3))
#define kItemSpace 5

@interface FriendCirclePublishController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UITextViewDelegate,XKMapLocationDelegate>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UIButton *publishBtn;
@property(nonatomic, strong) XKEmojiTextView *textView;
@property(nonatomic, strong) XKSectionHeaderArrowView *settingView;
@property(nonatomic, strong) XKMediaPickHelper *bottomSheetView;
@property(nonatomic, strong) XKFriendCirclePublishViewModel *viewModel;
@property(nonatomic, strong) XKSectionHeaderArrowView *addessView;
/**当前的位置信息*/
@property(nonatomic, copy) NSString *currentAddess;
@end

@implementation FriendCirclePublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewModel = [[XKFriendCirclePublishViewModel alloc] init];
    //地图
    [[[XKMapManager getCurrentMapFactory] getMapLocation] setLocationDelegate:self];
    [[[XKMapManager getCurrentMapFactory] getMapLocation] startBaiduSingleLocationService];
    // 初始化界面
    [self createUI];
}
#pragma mark - 初始化界面
- (void)createUI {
    _publishBtn  = [UIButton new];
    _publishBtn.frame = CGRectMake(0, 0, XKViewSize(57), 32);
    _publishBtn.layer.cornerRadius = 5;
    _publishBtn.layer.masksToBounds = YES;
    [_publishBtn setTitle:@"发表" forState:UIControlStateNormal];
    [_publishBtn setBackgroundColor:HEX_RGB(0x07C05F)];
    [_publishBtn setTitleColor:HEX_RGB(0xffffff) forState:UIControlStateDisabled];
    _publishBtn.titleLabel.font = XKMediumFont(17);
    [_publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_publishBtn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    _publishBtn.enabled = NO;
    [self setRightView:_publishBtn withframe:_publishBtn.frame];
    [self createContent];
}

- (void)createContent {
    UIView *contentView = [[UIView alloc] init];
    self.view.backgroundColor = HEX_RGB(0xffffff);
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    contentView.layer.cornerRadius = 5;
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    // 添加textView
    _textView = [[XKEmojiTextView alloc] init];
    [contentView addSubview:_textView];
    _textView.font = XKRegularFont(14);
    _textView.delegate = self;
    _textView.textColor = HEX_RGB(0x555555);
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).offset(10);
        make.left.equalTo(contentView.mas_left).offset(15);
        make.right.equalTo(contentView.mas_right).offset(-15);
        make.height.equalTo(@120);
    }];
    [_textView becomeFirstResponder];
    
    UIView *lineTopView;
    // 添加照片选择
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kItemWidth, kItemWidth);
    layout.minimumLineSpacing = kItemSpace;
    layout.minimumInteritemSpacing = kItemSpace;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [contentView addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[XKChooseMediaCell class] forCellWithReuseIdentifier:@"cell"];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(15);
        make.left.equalTo(contentView.mas_left).offset(15);
        make.right.equalTo(contentView.mas_right).offset(-10);
        make.height.equalTo(@kItemWidth);
    }];
    lineTopView = self.collectionView;
    __weak typeof(self) weakSelf = self;
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEX_RGB(0xF1F1F1);
    [contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(lineTopView.mas_bottom).offset(105);
        make.height.equalTo(@1);
    }];
    
    _settingView = [XKSectionHeaderArrowView new];
    [_settingView.titleLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.appendImage(IMG_NAME(@"sendFriend_Type")).bounds(CGRectMake(0, -3, 16, 16));
        ;
        confer.text(@"     发布类型");
    }];
    [_settingView.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.settingView.mas_centerY).offset(-4);
    }];
    [_settingView.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.settingView).offset(1.5);
    }];
    [contentView addSubview:_settingView];
    [_settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(3);
        make.left.right.equalTo(contentView);
        make.height.equalTo(@50);
    }];
    
    _addessView = [XKSectionHeaderArrowView new];
    [_addessView.titleLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.appendImage(IMG_NAME(@"sendFriend_addess")).bounds(CGRectMake(0, -3, 16, 20));
        ;
        confer.text(@"     所在位置");
    }];
    [_addessView.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addessView.mas_centerY).offset(-4);
    }];
    [_addessView.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addessView).offset(1.5);
    }];
    [contentView addSubview:_addessView];
    [_addessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settingView.mas_bottom);
        make.left.right.equalTo(contentView);
        make.height.equalTo(@50);
        make.bottom.equalTo(contentView.mas_bottom);
    }];
    XKWeakSelf(ws);
    [_addessView bk_whenTapped:^{
        XKBottomAlertSheetView *sheet = [[XKBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:@[@"不显示地址",@"获取当前地址",@"取消"] firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle){
            switch (index) {
                case 0:{
                }
                    break;
                case 1:{
                    self.viewModel.currentAddess = self.currentAddess;
                    ws.addessView.detailLabel.text = self.currentAddess;
                }
                    break;
                default:
                    break;
            }
        }];
        [sheet show];
    }];
//    216 123 140   222 222 183 78 138 188  106 106 106
//    约（饭局、牌局、游戏、旅游或者看书学习….）
//    卖（厨艺、宝贝、车位、房子也行）
//    送（首饰啊、项链啊、月光宝盒啥的）
//    其他（帮个忙、搭把手、吐吐槽、晒晒宠….）
    [_settingView bk_whenTapped:^{
        NSAttributedString *str1 = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
            confer.text(@"约").textColor(HEX_RGB(0xfc656f)).font(XKRegularFont(14));
            confer.text(@"（饭局、牌局、游戏、旅游或者看书学习….）").textColor(RGB(106, 106, 106)).font(XKRegularFont(14));
        }];
        NSAttributedString *str2 = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
            confer.text(@"卖").textColor(HEX_RGB(0xffd39b)).font(XKRegularFont(14));
            confer.text(@"（厨艺、宝贝、车位、房子也行）").textColor(RGB(106, 106, 106)).font(XKRegularFont(14));

        }];
        NSAttributedString *str3 = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
            confer.text(@"送").textColor(HEX_RGB(0x1b82d1
)).font(XKRegularFont(14));
            confer.text(@"（首饰啊、项链啊、月光宝盒啥的）").textColor(RGB(106, 106, 106)).font(XKRegularFont(14));

        }];
        NSAttributedString *str4 = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
            confer.text(@"其他").textColor(RGB(216, 123, 140)).font(XKRegularFont(14));
            confer.text(@"（帮个忙、搭把手、吐吐槽、晒晒宠….）").textColor(RGB(106, 106, 106)).font(XKRegularFont(14));

        }];
        NSAttributedString *str5 = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
            confer.text(@"取消").textColor(RGB(106, 106, 106)).font(XKRegularFont(14));
        }];
        XKAttributedBottomAlertSheetView *sheet = [[XKAttributedBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:@[str1,str2,str3,str4,str5]choseBlock:^(NSInteger index, NSAttributedString *choseTitle){
            ws.settingView.detailLabel.attributedText = choseTitle;

            switch (index) {
                case 0:{
                    self.viewModel.tag = @"约";
                }
                    break;
                case 1:{
                    self.viewModel.tag = @"卖";
                }
                    break;
                case 2:{
                    self.viewModel.tag = @"送";
                }
                    break;
                case 3:{
                    self.viewModel.tag = @"其他";
                }
                    break;
                    
                default:
                    break;
            }
        }];
        [sheet show];
    }];
}
#pragma mark - textView代理
- (void)textViewDidChange:(UITextView *)textView {
    self.viewModel.contentStr = textView.text;
    [self resetPublishBtnStatus];
}

#pragma mark - collectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.mediaInfoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKChooseMediaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    XKUploadMediaInfo *mediaInfo = self.viewModel.mediaInfoArr[indexPath.row];
    if(mediaInfo.isAdd) {
        cell.iconImgView.image = [UIImage imageNamed:@"xk_btn_friendsCirclePermissions_add"];
        cell.deleteBtn.alpha = 0;
    } else {
        cell.deleteBtn.alpha = 1;
        cell.iconImgView.image = mediaInfo.image;
    }
    XKWeakSelf(ws);
    cell.indexPath = indexPath;
    cell.deleteClick = ^(UIButton *sender,NSIndexPath *indexPath) {
        [ws.viewModel.mediaInfoArr removeObjectAtIndex:indexPath.row];
        [ws.viewModel resetMedioArr];
        [ws resetMedioHeight];
        [ws reloadData];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    [KEY_WINDOW endEditing:YES];
    XKUploadMediaInfo *mediaInfo = self.viewModel.mediaInfoArr[indexPath.row];
    if(mediaInfo.isAdd) {
        [self.bottomSheetView showView];
    } else {
        // 如果是视频 就播放
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"isVideo = YES"];
        NSArray *videos = [self.viewModel.mediaInfoArr filteredArrayUsingPredicate:pre];
        if (videos.count == 0) { // 没有视频
            NSMutableArray *models = [NSMutableArray array];
            for (XKUploadMediaInfo *imgModel in self.viewModel.mediaInfoArr) {
                if (!imgModel.isAdd && !imgModel.isVideo) {
                    PhotoPreviewModel *model = [[PhotoPreviewModel alloc] init];
                    model.thumbImage = imgModel.image;
                    [models addObject:model];
                }
            }
            __weak typeof(self) weakSelf = self;
            // 如果是图片就预览
            BigPhotoPreviewDeleteController *photoPreviewController = [[BigPhotoPreviewDeleteController alloc] init];
            photoPreviewController.models = models;
            photoPreviewController.currentIndex = indexPath.row;
            [photoPreviewController setDeleteComplete:^(NSInteger index) {
                [weakSelf.viewModel.mediaInfoArr removeObjectAtIndex:indexPath.row];
                [weakSelf.viewModel resetMedioArr];
                [weakSelf resetMedioHeight];
                [weakSelf reloadData];
            }];
            [self presentViewController:photoPreviewController animated:YES completion:nil];
        } else {
            XKUploadMediaInfo *media = self.viewModel.mediaInfoArr.firstObject;
            XKClearVideoDisplayViewController *vc = [XKClearVideoDisplayViewController new];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"viewController"] = [self getCurrentUIVC];
            params[@"localFilePath"] = [media.videolocalURL absoluteString];
            [vc Action_displayVideoWithParams:params.copy];
        }
    }
}

- (XKMediaPickHelper *)bottomSheetView {
    if(!_bottomSheetView) {
        XKWeakSelf(ws);
        _bottomSheetView = [[XKMediaPickHelper alloc] init];
        _bottomSheetView.videoMaxSecond = 15;
        _bottomSheetView.choseImageBlcok = ^(NSArray<UIImage *> * _Nullable images) {
            for (UIImage *image in images) {
                XKUploadMediaInfo *info = [XKUploadMediaInfo new];
                info.isVideo = NO;
                info.image = image;
                [ws.viewModel.mediaInfoArr insertObject:info atIndex:ws.viewModel.mediaInfoArr.count - 1];
            }
            [ws.viewModel resetMedioArr];
            [ws resetMedioHeight];
            [ws reloadData];
        };
        
        _bottomSheetView.choseVideoPathBlcok = ^(NSURL *videoURL, UIImage *coverImg) {
            XKUploadMediaInfo *info = [XKUploadMediaInfo new];
            info.isVideo = YES;
            info.image = coverImg;
            info.videolocalURL = videoURL;
            [ws.viewModel.mediaInfoArr addObject:info];
            [ws.viewModel resetMedioArr];
            [ws resetMedioHeight];
            [ws reloadData];
        };
    }
    _bottomSheetView.maxCount = 9 - self.viewModel.mediaInfoArr.count + 1;
    if ([self canSelectVideo]) {
        _bottomSheetView.canSelectVideo = YES;
    } else {
        _bottomSheetView.canSelectVideo = NO;
    }
    return _bottomSheetView;
}

#pragma mark - 重设高度
- (void)resetMedioHeight {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger lines = ceil(self.viewModel.mediaInfoArr.count / 3.0);
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kItemWidth * lines + kItemSpace * (lines - 1));
        }];
    });
}

- (void)reloadData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self resetPublishBtnStatus];
        [self.collectionView reloadData];
    });
}

#pragma mark - 设置按钮禁用状态
- (void)resetPublishBtnStatus {
    if ([self checkData]) {
        _publishBtn.enabled = YES;
    } else {
        _publishBtn.enabled = NO;
    }
}

#pragma mark - 检测数据
- (BOOL)checkData {
    if (![self.viewModel.contentStr isExist] && [self.viewModel getMediaArray].count == 0) {
        [XKHudView showTipMessage:@"发布内容不能为空哦"];
        return NO;
    }
    return YES;
}
// 能否选视频
- (BOOL)canSelectVideo {
    return [self.viewModel getMediaArray].count == 0 ? YES : NO;
}

#pragma mark - 发表事件
- (void)publish {
    [self.view endEditing:YES];
    if (![self checkData]) {
        [XKHudView showTipMessage:@"发布内容不能为空哦"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [XKHudView showLoadingTo:self.view animated:YES];
    self.publishBtn.userInteractionEnabled = NO;
    [self.viewModel requestPublishComplete:^(NSString *error, id data) {
        [XKHudView hideHUDForView:weakSelf.view animated:YES];
        if (error) {
            self.publishBtn.userInteractionEnabled = YES;
            [XKHudView showErrorMessage:error to:weakSelf.view animated:YES];;
        } else {
            [XKHudView showSuccessMessage:@"你的动态已经提交成功，24小时内审核通过后别人才能查看" to:self.view time:2 animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                               ^{
                                   EXECUTE_BLOCK(self.publishSuccess);
                               });
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter]postNotificationName:FriendPageReloadNotification object:nil];
            }];
        }
    }];
}

- (void)userLocationCountry:(NSString *)country state:(NSString *)state city:(NSString *)city subLocality:(NSString *)subLocality name:(NSString *)name {
    self.currentAddess = [NSString stringWithFormat:@"%@%@%@",city,subLocality,name];
    NSLog(@"%@", city);
}
@end
