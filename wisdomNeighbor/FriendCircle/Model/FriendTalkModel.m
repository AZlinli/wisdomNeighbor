//
//  FriendTalkModel.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/20.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "FriendTalkModel.h"
#import "XKFriendsTalkCommonRLCell.h"

@interface FriendTalkModel() {
    CGFloat _contentFullHeight; // 完整高度
    CGFloat _contentHeight; // 显示高度
    CGFloat _favorheight; // 点赞高度
    NSAttributedString *_contentAtt;
    NSAttributedString *_favorAtt;
}
/**内容是否需要折叠*/
@property(nonatomic, assign) BOOL contentNeedFold;
@end
@implementation FriendTalkModel
- (void)setContent:(NSString *)content {
    [super setContent:content];
    if (content.length == 0) {
        return;
    }
    
    BOOL isNeedFold = NO;
    CGFloat fullHeight = 0;
    NSAttributedString *contentAtt = nil;
    _contentHeight = [[self getCalculateClass] getContentHeight:self contentAtt:&contentAtt isNeedFold:&isNeedFold totalHeight:&fullHeight];
    _contentNeedFold = isNeedFold;
    _contentFullHeight = fullHeight;
    _contentAtt = contentAtt;
    _contentNeedFold = isNeedFold;
}

- (Class<XKFriendTalkHeightCalculatePrococol>)getCalculateClass {
    return [XKFriendsTalkCommonRLCell class];
}

- (NSArray *)pics {
    if (!_pics) {
        NSMutableArray *arr = @[].mutableCopy;
        NSArray *pictureContents = [self.images componentsSeparatedByString:@"|"];
        if (pictureContents.count > 0) {
            for (NSString *url in pictureContents) {
                if (url) {
                    [arr addObject:url];
                } 
            };
            _pics = arr.copy;
        }
    }
    return _pics;
}

- (void)setLikes:(NSArray<Likes *> *)likes{
    [super setLikes:likes];
    if (likes.count == 0) {
        return;
    }
    NSAttributedString *att;
    _favorheight = [XKFriendsTalkCommonRLCell getFavorHeight:self favorAttStr:&att];
    _favorAtt = att;
}

- (NSAttributedString *)contentAtt {
    return _contentAtt;
}

- (NSAttributedString *)favorAtt {
    return _favorAtt;
}

- (XKFriendTalkMsgType)msgType {
    NSArray *pictureContents = [self.images componentsSeparatedByString:@"|"];
    if (pictureContents.count > 0) {
        return XKFriendTalkMsgImgType;
    }else{
        return XKFriendTalkMsgNormalTextType;
    }
}

- (CGFloat)contentHeight {
    if (self.contentNeedFold) {
        if (self.contentFoldStatus) {
            return _contentFullHeight;
        } else {
            return _contentHeight;
        }
    } else {
        return _contentHeight;
    }
}

- (CGFloat)favorHeight {
    if (self.likes.count == 0) {
        return 0;
    }
    return _favorheight;
}

@end
