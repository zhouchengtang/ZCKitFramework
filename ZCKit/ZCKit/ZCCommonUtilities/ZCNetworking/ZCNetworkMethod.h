
#import <Foundation/Foundation.h>
#import "ZC_AFNetworking.h"
#import "ZCBaseResponse.h"
#import "ZCBaseRequest.h"

/*!
 @typedef 网络资源上传类型
 @brief  定义的一个枚举，区分上传媒体资源类型.
 @discussion
 @field FILE_IMAGE    图片
 @field FILE_VOICE    音频
 @field FILE_VIDEO    视频
 */
typedef NS_ENUM(NSInteger, FILE_TYPE){
   
    FILE_IMAGE  = 0,
    FILE_VOICE = 1,
    FILE_VIDEO = 2
};

@interface ZCNetworkMethod : NSObject

/*! @brief 网络请求方法单例. */
+ (ZCNetworkMethod *)sharedSingleton;

/*! @brief AF网络管理. */
@property (nonatomic, retain) ZC_AFHTTPSessionManager *manager;

/*! @brief 请求网络数据
 *
 * @param request 网络请求载体
 * @param success 请求成功时回调
 * @param failure 请求失败时回调
 * @param finally 成功或失败时都会调用 注意网络请求完成时的设置
 * @return
 */

-(NSURLSessionDataTask*)invokeService:(ZCBaseRequest*)request success:(void(^)(ZCBaseResponse *response))success failure:(void(^)(NSError*error,NSString *errorMessage))failure finally:(void(^)())finally;

/*! @brief 上传媒体资源
 *
 * @param params    请求参数
 * @param fileType  媒体资源类型
 * @param filePath  资源路径
 * @param result    请求结果
 * @return
 */

//-(void)upLoadFiletWithParams:(NSDictionary *)params fileType:(FILE_TYPE )fileType filePath:(NSString *)filePath  success:(void (^)(SQBaseResponse *))result;

@end
