

#import <Foundation/Foundation.h>

@interface ZCBaseResponse : NSObject

/*! @brief 响应码 0 表示成功，其它为错误 默认值为-1 .*/
@property (assign, nonatomic) NSInteger errorCode;

/*! @brief 响应信息(中文) 当code 为0 时 errorMessage 为"" .*/
@property (retain, nonatomic) NSString *errorMessage;

/*! @brief 原始返回数据 包含所有数据 .*/
@property (retain, nonatomic) id responseObject;

/*! @brief 解析公共数据
 *
 * @param dictionary 公共数据
 * @return 
 */
-(void)parseDataWithDictionary:(NSDictionary*) dictionary;

@end
