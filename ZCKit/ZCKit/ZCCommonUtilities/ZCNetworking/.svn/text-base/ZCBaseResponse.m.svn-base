

#import "ZCBaseResponse.h"

@implementation ZCBaseResponse

#pragma mark - 网络请求载体初始化
- (id)init{
    
    self = [super init];
    if (self) {
        
        self.errorCode = -1;
    }
    return self;
}

#pragma mark - 解析公共数据
-(void)parseDataWithDictionary:(NSDictionary *)dictionary{
    
    self.responseObject = dictionary;
    
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    /*具体获取对应的参数看自己的服务端配置*/
    
    NSString *codeString = [dictionary objectForKey:@"errcode"];
  
    self.errorCode = [codeString integerValue];
    
    self.errorMessage = [dictionary objectForKey:@"msg"];
    
}
@end
