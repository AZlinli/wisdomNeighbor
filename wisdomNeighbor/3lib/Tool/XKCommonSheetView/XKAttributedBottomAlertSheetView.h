//
//  XKAttributedBottomAlertSheetView.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/10/15.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKAttributedBottomAlertSheetView : UIView

@property (nonatomic, copy)NSArray *dataSource;
/**
 view
 @param dataSource 从上到下的标题数组  包括最后的取消
 @param choseBlock 选择标题后的回调
 @return view
 */


- (instancetype)initWithBottomSheetViewWithDataSource:(NSArray <NSAttributedString *>*)dataSource choseBlock:(void(^)(NSInteger index, NSAttributedString *choseTitle))choseBlock;


- (void)show;

- (void)dismissSelf;

- (void)updataData;
@end

NS_ASSUME_NONNULL_END
