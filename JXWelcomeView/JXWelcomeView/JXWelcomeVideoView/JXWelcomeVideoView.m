//
//  JXWelcomeVideoView.m
//  JXWelcomeView
//
//  Created by 徐沈俊杰 on 2018/9/20.
//  Copyright © 2018年 JX. All rights reserved.
//

#import "JXWelcomeVideoView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "JXUtilities.h"

static int adsSkimpTime = 5;

@interface JXWelcomeVideoView()

@property (nonatomic, strong) NSURL *videoUrl;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) UILabel *counterLabel;

@end

@implementation JXWelcomeVideoView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame andUrl:(NSString *)url {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor redColor];
        if ([JXUtilities isValidString:url]) {
            self.videoUrl = [NSURL fileURLWithPath:url];
            [self addAVPlayerLayerAndSubviews];
        }
    }
    
    return self;
}

#pragma mark - Event Response
- (void)skip:(UIButton *)sender {
    
}

#pragma mark - Method
- (void)addAVPlayerLayerAndSubviews {
    [self.layer addSublayer:self.playerLayer];
    [self addSubview:self.skipButton];
    [self.skipButton addSubview:self.counterLabel];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self.player play];
}

#pragma mark - Setting And Getting
- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] initWithURL:self.videoUrl];
    }
    return _player;
}

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        /**********视频播放时的拉伸方式
        AVLayerVideoGravityResize           非均匀模式。两个维度完全填充至整个视图区域
        AVLayerVideoGravityResizeAspect     等比例填充，直到一个维度到达区域边界
        AVLayerVideoGravityResizeAspectFill 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
        **********/
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _playerLayer.frame = [UIScreen mainScreen].bounds;
    }
    
    return _playerLayer;
}

- (NSURL *)videoUrl {
    if (!_videoUrl) {
        _videoUrl = [[NSURL alloc] init];
    }
    
    return _videoUrl;
}

- (UIButton *)skipButton {
    if (!_skipButton) {
        _skipButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)-75, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), 80, 80)];
        [_skipButton setImage:[UIImage imageNamed:@"welcome_skip_normal"] forState:UIControlStateNormal];
        [_skipButton setImage:[UIImage imageNamed:@"welcome_skip_highlight"] forState:UIControlStateHighlighted];
        [_skipButton addTarget:self action:@selector(skip:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _skipButton;
}

- (UILabel *)counterLabel {
    if (!_counterLabel) {
        _counterLabel = [[UILabel alloc] initWithFrame:self.skipButton.bounds];
        _counterLabel.backgroundColor = [UIColor clearColor];
        _counterLabel.numberOfLines = 2;
        _counterLabel.font = [UIFont boldSystemFontOfSize:13];
        _counterLabel.textColor = [UIColor whiteColor];
        _counterLabel.textAlignment = NSTextAlignmentCenter;
        _counterLabel.text = [NSString stringWithFormat:@"跳过\n%dS",adsSkimpTime];
    }
    
    return _counterLabel;
}

@end
