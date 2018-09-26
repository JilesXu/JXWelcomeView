//
//  JXAFNetworking.m
//  JXWelcomeView
//
//  Created by 徐沈俊杰 on 2018/9/26.
//  Copyright © 2018年 JX. All rights reserved.
//

#import "JXNetworkingModel.h"
#import "AFNetworking.h"

@interface JXNetworkingModel()

@property (nonatomic, strong) AFHTTPSessionManager *jsonReqSession;

@end

@implementation JXNetworkingModel

static JXNetworkingModel *instance = nil;

+ (JXNetworkingModel *)shareInstance{
    static dispatch_once_t onceToken;
    if (instance == nil) {
        dispatch_once(&onceToken, ^{
            instance = [[JXNetworkingModel alloc] init];
        });
    }
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _jsonReqSession = [AFHTTPSessionManager manager];
    }
    
    return self;
}

- (void)GETWithURL:(NSString *)url
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure {
    
    [_jsonReqSession GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)POSTWithURL:(NSString *)url
         parameters:(id)parameters
               type:(PostType)postType
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure {
    
    if (postType == PostTypeRawPayload) {
        _jsonReqSession.requestSerializer = [AFJSONRequestSerializer serializer];
        _jsonReqSession.responseSerializer = [AFJSONResponseSerializer serializer];
        
    } else if (postType == PostTypeDataForm) {
        _jsonReqSession.requestSerializer = [AFHTTPRequestSerializer serializer];
        _jsonReqSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    _jsonReqSession.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain",@"image/gif",nil];
    [_jsonReqSession POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)downloadTaskWithURL:(NSString *)url
          completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        completionHandler(response, filePath, error);
        
    }];
    
    [downloadTask resume];
}

@end
