//
//  WelcomeVC.m
//  JXWelcomeView
//
//  Created by 徐沈俊杰 on 2018/9/20.
//  Copyright © 2018年 JX. All rights reserved.
//

#import "WelcomeVC.h"
#import "JXNetworkingModel.h"

@interface WelcomeVC ()

@end

@implementation WelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[JXNetworkingModel shareInstance] downloadTaskWithURL:@"http://wap.js.10086.cn/jsmccClient_img/ecmcServer/images/pic/1537925681099.mp4" completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSString *urlString = [[filePath absoluteString] substringFromIndex:7];
        NSString *suffix = [urlString componentsSeparatedByString:@"."].lastObject;
        NSString *fileName = [NSString stringWithFormat:@"jiles.%@", suffix];
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *currentPath = [cachesPath stringByAppendingPathComponent:fileName];
        BOOL isSuccess = [fileManager moveItemAtPath:urlString toPath:currentPath error:nil];
        
    }];
}

@end
