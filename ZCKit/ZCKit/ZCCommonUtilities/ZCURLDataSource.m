//
//  ZCURLDataSource.m
//  AKBiOSProject
//
//  Created by zhoucheng on 16/4/21.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import "ZCURLDataSource.h"
#import "ZCURLCacheObject.h"
#include <objc/runtime.h>
#import "ZCBaseRequest.h"
#import "ZCNetworkMethod.h"

@interface ZCURLDataSource()

@property(nonatomic, strong)NSDictionary * config;

@end

@implementation ZCURLDataSource

-(NSDictionary *)config
{
    if (!_config) {
        _config = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"]];
    }
    return _config;
}

-(id) init{
    if((self = [super init])){
        _dataChanged = YES;
        self.pageIndex = 1;
        self.pageSize = 20;
    }
    return self;
}

-(id) queryValues{
    if(_queryValues == nil){
        _queryValues = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    return _queryValues;
}

-(BOOL) isEmpty{
    return [_dataObjects count] == 0;
}

-(void) refreshData{
    [self reloadData];
}

-(void) reloadData{
    
    if(self.pageIndex !=1){
        self.pageIndex = 1;
        self.dataChanged = YES;
    }
    _loading = YES;
    if([self.delegate respondsToSelector:@selector(ZCDataSourceWillLoading:)]){
        [self.delegate ZCDataSourceWillLoading:self];
    }
    [self sendURLRequest];
}

-(void) loadMoreData{
    self.pageIndex ++;
    self.loading = YES;
    if([self.delegate respondsToSelector:@selector(ZCDataSourceWillLoading:)]){
        [self.delegate ZCDataSourceWillLoading:self];
    }
    [self sendURLRequest];
}

-(NSInteger) count{
    return [self.dataObjects count];
}

-(NSMutableArray *) dataObjects{
    if(_dataObjects == nil){
        _dataObjects = [[NSMutableArray alloc] init];
    }
    return _dataObjects;
}

-(id) dataObjectAtIndex:(NSInteger) index{
    if(index>=0 && index < [self.dataObjects count]){
        return [self.dataObjects objectAtIndex:index];
    }
    return nil;
}


-(id) dataObject{
    if([self.dataObjects count ]>0){
        return [self.dataObjects objectAtIndex:0];
    }
    return nil;
}

-(void) loadResultsData:(id) resultsData{
    
    NSUInteger c = [self count];
    
    NSArray * items = _dataKey ? [resultsData dataForKeyPath:_dataKey] : resultsData;
    
    if([items isKindOfClass:[NSArray class]]){
        [[self dataObjects] addObjectsFromArray:items];
    }
    else if([items isKindOfClass:[NSDictionary class]]){
        [[self dataObjects] addObject:items];
    }
    self.hasMoreData = [self count] != c;
}

- (void)sendURLRequest
{
    if (!self.skipCached && self.pageIndex == 1) {
        [self loadResultsDataFromCache];
    }
    
    NSString * url = [self url];
    
    if(url == nil){
        url = [[self.config dictionaryForKey:@"url"] stringValueForKey:[self urlKey]];
    }
    NSInteger offset = ( [self pageIndex] - 1) * [self pageSize];
    
    url = [url stringByReplacingOccurrencesOfString:@"{offset}" withString:[NSString stringWithFormat:@"%d",(int)offset]];
    
    url = [url stringByReplacingOccurrencesOfString:@"{pageIndex}" withString:[NSString stringWithFormat:@"%@",@([self pageIndex])]];
    
    url = [url stringByReplacingOccurrencesOfString:@"{pageSize}" withString:[NSString stringWithFormat:@"%@",@([self pageSize])]];
    
    url = [url stringByDataOutlet:self stringValue:^NSString *(id data, NSString *keyPath) {
        id v = [data dataForKeyPath:keyPath];
        if([v isKindOfClass:[NSString class]]){
            return [v stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        else if(v){
            return [NSString stringWithFormat:@"%@",v];
        }
        return @"";
    }];
    
    NSLog(@"url=%@", url);
    NSLog(@"queryValues=%@", self.queryValues);
    
    HttpRequestType httpRequestType = HttpRequestGET;
    if (self.reqeustType == HttpRequestPOST) {
        httpRequestType = HttpRequestPOST;
    }
    
    if (httpRequestType == HttpRequestPOST) {
        for (id key in [self.queryValues allKeys]) {
            if ([[self.queryValues objectForKey:key] isKindOfClass:[NSString class]]) {
                NSString * object = [self.queryValues objectForKey:key];
                [self.queryValues setObject:[object urlEncode] forKey:key];
            }
        }
    }
    
    ZCBaseRequest* request = [[ZCBaseRequest alloc]initUrlWithString:url requestType:httpRequestType];
    [request setParams:self.queryValues];
    __weak ZCURLDataSource * weakSelf = self;
    [[ZCNetworkMethod sharedSingleton]invokeService:request success:^(ZCBaseResponse* response){
        NSLog(@"%@", response.responseObject);
            [weakSelf doLoaded:response];
    }failure:^(NSError* error, NSString *errorMessage){
        if ([weakSelf.delegate respondsToSelector:@selector(ZCDataSource:didFitalError:)]) {
            [weakSelf.delegate ZCDataSource:self didFitalError:error];
        }
    }finally:^{}];
    
}

- (void)doLoaded:(ZCBaseResponse *)response
{
    if (!self.skipCached) {
        [self saveResultsDataToCache:response.responseObject];
    }
    if (self.pageIndex == 1) {
        [[self dataObjects] removeAllObjects];
    }
    [self loadResultsData:response.responseObject];
    
    if ([self.delegate respondsToSelector:@selector(ZCDataSourceDidLoadResultsData:)]) {
        [self.delegate ZCDataSourceDidLoadResultsData:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(ZCDataSourceDidLoaded:)]) {
        [self.delegate ZCDataSourceDidLoaded:self];
    }
}

- (void)saveResultsDataToCache:(id)result
{
    NSString * responseUUID = [[ZCURLDataSource encodeObject:result] zcMD5String];
    
    if ([[ZCFileDataCache sharedInstance] objectForKey:[self urlCacheKey]]) {
        ZCURLCacheObject * dataObject = [[ZCURLCacheObject alloc] initWithDictionary:[[ZCFileDataCache sharedInstance] objectForKey:[self urlCacheKey]]];
        self.dataChanged = ![dataObject.responseUUID isEqualToString:responseUUID];
        if (self.dataChanged) {
            dataObject.responseUUID = responseUUID;
            dataObject.dataObject = result;
            dataObject.timestamp = time(NULL);
            [[ZCFileDataCache sharedInstance] setObject:[dataObject dictionaryWithModel] forKey:[self urlCacheKey]];
        }
    }else{
        ZCURLCacheObject * dataObject = [[ZCURLCacheObject alloc] init];
        dataObject.responseUUID = responseUUID;
        dataObject.dataObject = result;
        dataObject.timestamp = time(NULL);
        [[ZCFileDataCache sharedInstance] setObject:[dataObject dictionaryWithModel] forKey:[self urlCacheKey]];
    }
}

- (void)loadResultsDataFromCache
{
    if ([[ZCFileDataCache sharedInstance] objectForKey:[self urlCacheKey]]) {
        ZCURLCacheObject * dataObject = [[ZCURLCacheObject alloc] initWithDictionary:[[ZCFileDataCache sharedInstance] objectForKey:[self urlCacheKey]]];
        id data = dataObject.dataObject;
        NSDate * timestamp = [NSDate dateWithTimeIntervalSince1970:dataObject.timestamp];

        if (data) {
            if (self.dataChanged) {
                [[self dataObjects] removeAllObjects];
                [self loadResultsData:data];
            }
            if ([self.delegate respondsToSelector:@selector(ZCDataSourceDidLoadResultsData:)]) {
                [self.delegate ZCDataSourceDidLoadResultsData:self];
            }
            if ([self.delegate respondsToSelector:@selector(ZCDataSourceDidLoadedFromCache:timestamp:)]) {
                [self.delegate ZCDataSourceDidLoadedFromCache:self timestamp:timestamp];
            }
        }
    }
}

- (NSString *)urlCacheKey
{
    NSString * url = [self url];
    
    if(url == nil){
        url = [[self.config dictionaryForKey:@"url"] stringValueForKey:[self urlKey]];;
    }
    NSInteger offset = ( [self pageIndex] - 1) * [self pageSize];
    
    url = [url stringByReplacingOccurrencesOfString:@"{offset}" withString:[NSString stringWithFormat:@"%d",(int)offset]];
    
    url = [url stringByReplacingOccurrencesOfString:@"{pageIndex}" withString:[NSString stringWithFormat:@"%@",@([self pageIndex])]];
    
    url = [url stringByReplacingOccurrencesOfString:@"{pageSize}" withString:[NSString stringWithFormat:@"%@",@([self pageSize])]];
    
    url = [url stringByDataOutlet:self stringValue:^NSString *(id data, NSString *keyPath) {
        id v = [data dataForKeyPath:keyPath];
        if([v isKindOfClass:[NSString class]]){
            return [v stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        else if(v){
            return [NSString stringWithFormat:@"%@",v];
        }
        return @"";
    }];
    
    url = [[NSURL URLWithString:url queryValues:[self queryValues]] absoluteString];
    
    return [url zcMD5String];
}

+(NSString *) encodeObject:(id) data{
    NSMutableString * ret = [NSMutableString stringWithCapacity:100];
    if([data isKindOfClass:[NSNumber class]]){
        [ret appendFormat:@"%@",data];
    }
    else if([data isKindOfClass:[NSString class]]){
        [ret appendString:@"\""];
        NSRange range = {0,1};
        NSString * charStr = nil;
        for(;range.location < [data length];range.location ++){
            charStr = [data substringWithRange:range];
            if([charStr isEqualToString:@"\""]){
                [ret appendString:@"\\\""];
            }
            else if([charStr isEqualToString:@"\n"]){
                [ret appendString:@"\\n"];
            }
            else if([charStr isEqualToString:@"\r"]){
                [ret appendString:@"\\r"];
            }
            else if([charStr isEqualToString:@"\t"]){
                [ret appendString:@"\\t"];
            }
            else if([charStr isEqualToString:@"\\"]){
                [ret appendString:@"\\\\"];
            }
            else{
                [ret appendString:charStr];
            }
        }
        [ret appendString:@"\""];
    }
    else if([data isKindOfClass:[NSDictionary class]]){
        [ret appendString:@"{"];
        
        NSEnumerator * keyEnum = [data keyEnumerator];
        NSString * key;
        BOOL first = YES;
        while((key = [keyEnum nextObject])){
            
            id value = [data valueForKey:key];
            
            if(value == nil || [value isKindOfClass:[NSNull class]]){
                continue;
            }
            
            if(first){
                first = NO;
            }
            else{
                [ret appendString:@","];
            }
            [ret appendFormat:@"\"%@\":",key];
            [ret appendString:[ZCURLDataSource encodeObject:value]];
        }
        
        [ret appendString:@"}"];
    }
    else if([data isKindOfClass:[NSArray class]]){
        [ret appendString:@"["];
        BOOL first =YES;
        for(id item in data){
            if(first){
                first = NO;
            }
            else{
                [ret appendString:@","];
            }
            [ret appendString:[ZCURLDataSource encodeObject:item]];
        }
        [ret appendString:@"]"];
    }
    else if([data isKindOfClass:[NSNull class]]){
        [ret appendString:@"null"];
    }
    else if(data){
        [ret appendString:@"{"];
        BOOL first = YES;
        {
            Class clazz = [data class];
            objc_property_t * prop;
            unsigned int c;
            while(clazz && clazz != [NSObject class]){
                
                prop = class_copyPropertyList(clazz, &c);
                
                for(int i=0;i<c;i++){
                    NSString * key = [NSString stringWithCString:property_getName(prop[i]) encoding:NSUTF8StringEncoding];
                    id value = nil;
                    
                    @try {
                        value = [data valueForKey:key];
                    }
                    @catch (NSException *exception) {
                        value = nil;
                    }
                    
                    if(value == nil || [value isKindOfClass:[NSNull class]]){
                        continue;
                    }
                    
                    if(first){
                        first = NO;
                    }
                    else{
                        [ret appendString:@","];
                    }
                    [ret appendFormat:@"\"%@\":",key];
                    [ret appendString:[ZCURLDataSource encodeObject:value]];
                    
                }
                
                free(prop);
                
                clazz = class_getSuperclass(clazz);
            }
        }
        [ret appendString:@"}"];
    }
    else{
        [ret appendString:@"null"];
    }
    
    return ret;
}


@end
