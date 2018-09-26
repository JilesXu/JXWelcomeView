//
//  JXAFNetworking.h
//  JXWelcomeView
//
//  Created by 徐沈俊杰 on 2018/9/26.
//  Copyright © 2018年 JX. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, PostType) {
    PostTypeRawPayload = 1 << 0,
    PostTypeDataForm = 1 << 1,
};

@interface JXNetworkingModel : NSObject

+ (instancetype)shareInstance;

- (void)POSTWithURL:(NSString *)url
         parameters:(id)parameters
               type:(PostType)postType
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;

- (void)GETWithURL:(NSString *)url
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

- (void)downloadTaskWithURL:(NSString *)url
          completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

@end
