

#import "ZCNetworkMethod.h"

@implementation ZCNetworkMethod

#pragma mark - 初始化单例
+ (ZCNetworkMethod *)sharedSingleton{
    
    static ZCNetworkMethod *sharedSingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [[ZCNetworkMethod alloc] init];
    });
    return sharedSingleton;
}

#pragma mark - AF网络请求管理初始化
- (id)init{
    
    self = [super init];
    if (self) {
        self.manager = [ZC_AFHTTPSessionManager manager];;
        self.manager.requestSerializer.timeoutInterval = 30;
        self.manager.requestSerializer = [ZC_AFJSONRequestSerializer serializer];
    }
    return self;
}

#pragma mark - 请求网络数据
-(NSURLSessionDataTask*)invokeService:(ZCBaseRequest*)request success:(void(^)(ZCBaseResponse *response))success failure:(void(^)(NSError*error,NSString *errorMessage))failure finally:(void(^)())finally
{
    NSLog(@"%@", request.urlString);
    __block ZCBaseRequest *tmpReq = request;
    NSURLSessionDataTask *operation;
    self.manager.requestSerializer=[ZC_AFJSONRequestSerializer serializer];
    self.manager.responseSerializer = [ZC_AFJSONResponseSerializer serializer];
//    if ([AKUserInfoSingle sharedInstance].user.tk) {
//        [self.manager.requestSerializer setValue:[AKUserInfoSingle sharedInstance].user.tk forHTTPHeaderField:@"tk"];
//        [self.manager.requestSerializer setValue:[AKUserInfoSingle sharedInstance].user.sid forHTTPHeaderField:@"sid"];
//    }
    
    [self.manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil]];
    switch (request.requestType) {
        case HttpRequestGET:
        {
            operation = [self.manager GET:request.urlString parameters:request.params progress:^(NSProgress * _Nonnull downloadProgress) {
                NSLog(@"%lld", downloadProgress.totalUnitCount);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@", responseObject);
                [self invokeSuccess:(NSDictionary *) responseObject operation:operation request:tmpReq success:success finally:finally];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                 [self invokeFailure:operation error:error failure:failure finally:finally];
            }];
            
            break;
        }
        case HttpRequestPOST:
        {
            operation = [self.manager POST:request.urlString parameters:request.params progress:^(NSProgress * _Nonnull downloadProgress) {
                NSLog(@"%lld", downloadProgress.totalUnitCount);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@", responseObject);
                [self invokeSuccess:(NSDictionary *) responseObject operation:operation request:tmpReq success:success finally:finally];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                [self invokeFailure:operation error:error failure:failure finally:finally];
            }];
            
            break;
        }
            
        case HttpRequestPUT:
        {
            operation = [self.manager PUT:request.urlString parameters:request.params  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@", responseObject);
                [self invokeSuccess:(NSDictionary *) responseObject operation:operation request:tmpReq success:success finally:finally];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                [self invokeFailure:operation error:error failure:failure finally:finally];
            }];
            break;
        }
        case HttpRequestHEAD:
        {
            break;
        }
        case HttpRequestDELETE:
        {
            operation = [self.manager DELETE: request.urlString parameters:request.params  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@", responseObject);
                [self invokeSuccess:(NSDictionary *) responseObject operation:operation request:tmpReq success:success finally:finally];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                [self invokeFailure:operation error:error failure:failure finally:finally];
            }];
            
            break;        }
        case HttpRequestOPTIONS:
        {
            break;
        }
            
        default:
            break;
    }
    
    return operation;
}

#pragma mark - 请求成功做数据处理
-(void)invokeSuccess:(NSDictionary *) dictionary operation:(NSURLSessionDataTask *) operation request:(ZCBaseRequest*) request success:(void (^)(ZCBaseResponse *))success finally:(void (^)())finally
{
    NSLog(@"<--URL-->:%@", [[operation.currentRequest URL] absoluteString]);
    
    if (request.isDebug) {
        NSLog(@"<-->JSON-->:%@", dictionary);
    }
    if (success) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /*防止大量数据解析时阻塞主线程*/
            
            ZCBaseResponse *resp = [[ZCBaseResponse alloc] init];
            [resp parseDataWithDictionary:dictionary];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(resp);
                if (finally) {
                    finally();
                }
            });
        });
    }
}

#pragma mark - 请求失败做数据处理
-(void)invokeFailure:(NSURLSessionDataTask *) operation error:(NSError *) error failure:(void (^)(NSError *error,NSString *errorMessage))failure finally:(void (^)())finally
{
    NSLog(@"<--ERROR-->:%@", error);
    
    NSString *errorMessage = nil;
    if (error.code == NSURLErrorNotConnectedToInternet) {
        
        errorMessage = @"您已处于离线状态";
    } else if (error.code == NSURLErrorTimedOut) {
        
        errorMessage = @"连接超时";
    } else if (error.code == kCFURLErrorUnsupportedURL) {
        
        errorMessage = @"连接失败,因为主机无法找到";
    } else if (error.code == kCFURLErrorCancelled) {
        
        errorMessage = @"连接被取消了";
    } else if (error.code == kCFURLErrorNetworkConnectionLost) {
        
        errorMessage = @"连接失败,因为网络连接丢失";
    } else if (error.code == kCFURLErrorCannotConnectToHost) {
        
        errorMessage = @"不能够连接到服务器";
    }
    
    if (failure) {
        failure(error,errorMessage);
    }
    
    if (finally) {
        finally();
    }
    
   
}
/*
#pragma mark - 上传媒体资源
-(void)upLoadFiletWithParams:(NSDictionary *)params fileType:(FILE_TYPE )fileType filePath:(NSString *)filePath  success:(void (^)( SQBaseResponse*))result {
    NSString* urlStr;
    NSString* fileName;
    NSString* mimiType;
    switch (fileType) {
        case FILE_IMAGE:{
            urlStr = @"images";
            mimiType = @"image/png";
            fileName = @"image";
        } break;
        case FILE_VOICE:{
            urlStr = @"CP/AddAudio";
            fileName = [NSString stringWithFormat:@"%@",@"suijishu.mp3"];
            mimiType = @"mp3";
        } break;
        case FILE_VIDEO:{
            urlStr = @"videos";
            fileName = [NSString stringWithFormat:@"%@.mp4",@"suijishu"];
            mimiType = @"video/mp4";
        } break;
        default:
            break;
    }
    
    NSMutableDictionary* mutableDictory = [NSMutableDictionary dictionaryWithDictionary:params];
    NSString* url = @"www.baidu.com";
    [self.manager POST:url parameters:mutableDictory constructingBodyWithBlock: ^(id <AFMultipartFormData> formData){        
        NSData* imageData =  [NSData dataWithContentsOfFile:filePath];
        if (imageData) {
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:mimiType];
        }else{
            SQBaseResponse *response = [[SQBaseResponse alloc] init];
            response.errorCode = -1;
            result(response);
        }
    }success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        SQBaseResponse *response = [[SQBaseResponse alloc] init];
        [response parseDataWithDictionary:(NSDictionary *)responseObject];
        response.errorCode = 0;
        result(response);
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@",error);
        
        SQBaseResponse *response = [[SQBaseResponse alloc] init];
        response.errorCode = error.code;
        result(response);
    }];
}
*/
@end
