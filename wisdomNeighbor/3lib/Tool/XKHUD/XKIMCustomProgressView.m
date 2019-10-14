//
//  XKIMCustomProgressView.m
//  XKSquare
//
//  Created by xudehuai on 2019/3/8.
//  Copyright © 2019 xk. All rights reserved.
//

#import "XKIMCustomProgressView.h"

@interface XKIMCustomProgressView ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *textLab;


@end

@implementation XKIMCustomProgressView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        self.layer.cornerRadius = 6.0;
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.imgView = [[UIImageView alloc] init];
        [self addSubview:self.imgView];
        
        self.textLab = [[UILabel alloc] init];
        [self addSubview:self.textLab];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(14.0);
            make.centerY.mas_equalTo(self);
            make.width.height.mas_equalTo(14.0);
        }];
        
        [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imgView.mas_right).mas_offset(5.0);
            make.centerY.mas_equalTo(self.imgView);
            make.trailing.mas_equalTo(-14.0);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(95.0, 26.0);
}

+ (instancetype)hudWithImg:(UIImage *)img text:(NSString *)text textFont:(UIFont *)textFont textColor:(UIColor *)textColor {
    XKIMCustomProgressView *view = [[XKIMCustomProgressView alloc] init];
    view.imgView.image = img;
    view.textLab.text = text;
    view.textLab.font = textFont;
    view.textLab.textColor = textColor;
    
    return view;
}

- (void)startLoading {
     [self rotateView:self.imgView];
}

- (void)stopLoading {
    [self.imgView.layer removeAllAnimations];//停止动画
}

- (void)rotateView:(UIImageView *)view{
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    rotationAnimation.duration = 1;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.removedOnCompletion = NO;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

///监听应用退到后台
- (void)didEnterBackground {
    //记录暂停时间
    CFTimeInterval pauseTime =   [self.imgView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    //设置动画速度为0
    self.imgView.layer.speed = 0;
    //设置动画的偏移时间
    self.imgView.layer.timeOffset = pauseTime;
}

///恢复旋转
- (void)didBecomeActive {
    //暂停的时间
    CFTimeInterval pauseTime = self.imgView.layer.timeOffset;
    //设置动画速度为1
    self.imgView.layer.speed = 1;
    //重置偏移时间
    self.imgView.layer.timeOffset = 0;
    //重置开始时间
    self.imgView.layer.beginTime = 0;
    //计算开始时间
    CFTimeInterval timeSincePause = [self.imgView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
    //设置开始时间
    self.imgView.layer.beginTime = timeSincePause;
}


@end
