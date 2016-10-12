

#import "ZCBaseRequest.h"

@implementation ZCBaseRequest

#pragma mark - 网络请求载体初始化
- (id)init{
    
    self = [super init];
    if (self) {
        self.params = [[NSMutableDictionary alloc] init];
        self.pageNo = 1;
        self.pageSize = 15;
        self.paging = NO;
        self.requestType = HttpRequestGET;
        
    }
    return self;
}

#pragma mark - GET请求，默认无需分页
-(id)initUrlWithString:(NSString *)urlString{
    
    return [self initUrlWithString:urlString paging:NO requestType:HttpRequestGET];
}

#pragma mark - GET请求，判断是否需要分页
-(id)initUrlWithString:(NSString *)urlString paging:(BOOL) paging{
    
    return [self initUrlWithString:urlString paging:paging requestType:HttpRequestGET];
}

#pragma mark - 区分网络请求方式，默认无需分页
-(id)initUrlWithString:(NSString *)urlString requestType:(HttpRequestType) requestType{
    
    return [self initUrlWithString:urlString paging:NO requestType:requestType];
}

#pragma mark - 区分网络请求方式，判断是否需要分页
-(id)initUrlWithString:(NSString *)urlString paging:(BOOL)paging requestType:(HttpRequestType) requestType{
    
    self = [super init];
    if (self) {
        self.params = [[NSMutableDictionary alloc] init];
        self.pageNo = 1;
        self.pageSize = 20;
        self.paging = paging;
        self.urlString = urlString;
        self.requestType = requestType;
    }
    
    return self;
}

#pragma mark - Paging的set方法
-(void)setPaging:(BOOL)paging{
    
    _paging = paging;
    if (self.paging) {
        [self.params setValue:[NSString stringWithFormat:@"%ld", (long)_pageNo] forKey:@"pageNo"];
        [self.params setValue:[NSString stringWithFormat:@"%ld", (long)_pageSize] forKey:@"pageSize"];
    } else {
        [self.params removeObjectForKey:@"pageNo"];
        [self.params removeObjectForKey:@"pageSize"];
    }
}

#pragma mark - PageNo的set方法
-(void)setPageNo:(NSInteger)pageNo{
    
    _pageNo = pageNo;
    if (self.paging) {
        [self.params setValue:[NSString stringWithFormat:@"%ld", (long)_pageNo] forKey:@"pageNo"];
    }
}

#pragma mark - PageSize的set方法
-(void)setPageSize:(NSInteger)pageSize{
    
    _pageSize = pageSize;
    if (self.paging) {
        [self.params setValue:[NSString stringWithFormat:@"%ld", (long)_pageSize] forKey:@"pageSize"];
    }
}

@end
