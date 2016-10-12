

#import <Foundation/Foundation.h>

#define CONTENT_TYPE_TEXT_PLAN @"text/plain"
#define CONTENT_TYPE_APPLICATION_JSON @"application/json"
#define CONTENT_TYPE_TEXT_JAVASCRIPT @"text/javascript"

#define APPOS @"appOs"
#define APPVERSION @"appVersion"

/*!
 @typedef 网络请求类型
 @brief  定义的一个枚举，区分网络请求方式.
 @discussion
 @field HttpRequestGET     GET请求
 @field HttpRequestPOST    POST请求
 @field HttpRequestHEAD    HAED请求
 @field HttpRequestPUT     PUT请求
 @field HttpRequestDELETE  DELETE请求
 @field HttpRequestOPTIONS OPTIONS请求
 */

typedef NS_ENUM(NSInteger, HttpRequestType) {
  
    HttpRequestGET,
    HttpRequestPOST,
    HttpRequestHEAD,
    HttpRequestPUT,
    HttpRequestDELETE,
    HttpRequestOPTIONS
};

@interface ZCBaseRequest : NSObject

/*! @brief 是否为调式 debug 为YES 时会输出请求内容 .*/
@property (assign, nonatomic, getter = isDebug) BOOL debug;

/*! @brief http 请求方式 GET、POST、HEAD、PUT、DELETE、OPTIONS .*/
@property (assign, nonatomic) HttpRequestType requestType;

/*! @brief ContentType属性指定响应的 HTTP内容类型 .*/
@property (retain, nonatomic) NSString *contentType;

/*! @brief 请求参数 .*/
@property (retain, nonatomic) NSMutableDictionary *params;

/*! @brief 请求地址 .*/
@property (retain, nonatomic) NSString *urlString;

/*! @brief 是否支持分页，默认情况下是不分页 .*/
@property (unsafe_unretained, nonatomic, getter = isPaging) BOOL paging;

/*! @brief 支持分页情况下当前页 .*/
@property (unsafe_unretained, nonatomic) NSInteger pageNo;

/*! @brief 支持分页情况下 分页大小 默认为20 .*/
@property (unsafe_unretained, nonatomic) NSInteger pageSize;

/*! @brief 平台签名 .*/
@property (retain, nonatomic) NSString *appOs;
@property (retain, nonatomic) NSString *appVersion;

/*! @brief GET请求，默认无需分页
 *
 * @param urlString 请求地址
 * @return 网络请求载体
 */

-(id)initUrlWithString:(NSString *)urlString;

/*! @brief GET请求，判断是否需要分页
 *
 * @attention 判断需要分页，那么可设置分页大小，当前默认20
 * @param urlString 请求地址
 * @param paging 是否支持分页
 * @return 网络请求载体
 */

-(id)initUrlWithString:(NSString *)urlString paging:(BOOL) paging;

/*! @brief 区分网络请求方式，默认无需分页
 *
 * @param urlString 请求地址
 * @param requestType 请求方式
 * @return 网络请求载体
 */

-(id)initUrlWithString:(NSString *)urlString requestType:(HttpRequestType) requestType;

/*! @brief 区分网络请求方式，判断是否需要分页
 *
 * @attention 判断需要分页，那么可设置分页大小，当前默认20
 * @param urlString 请求地址
 * @param paging 是否支持分页
 * @param requestType 请求方式
 * @return 网络请求载体
 */

-(id)initUrlWithString:(NSString *)urlString paging:(BOOL)paging requestType:(HttpRequestType) requestType;

@end
