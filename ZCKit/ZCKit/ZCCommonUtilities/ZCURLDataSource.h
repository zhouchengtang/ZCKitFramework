//
//  ZCURLDataSource.h
//  AKBiOSProject
//
//  Created by zhoucheng on 16/4/21.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _ZCURLDataSourceRequestType
{
    ZCURLDataSourceRequestType_GET = 10,
    ZCURLDataSourceRequestType_POST
}ZCURLDataSourceRequestType;

@interface ZCURLDataSource : NSObject

@property(nonatomic,retain) NSString * url;
@property(nonatomic,retain) NSString * urlKey;
@property(nonatomic,retain) id queryValues;

@property(nonatomic,assign,getter = isLoading) BOOL loading;
@property(nonatomic,assign,getter = isLoaded) BOOL loaded;
@property(nonatomic,readonly,getter = isEmpty) BOOL empty;
@property(nonatomic,retain) NSString * dataKey;
@property(nonatomic,retain) NSMutableArray * dataObjects;

@property(nonatomic,assign) NSInteger pageIndex;
@property(nonatomic,assign) NSInteger pageSize;
@property(nonatomic,assign) BOOL hasMoreData;
@property(nonatomic,assign,getter = isSkipCached) BOOL skipCached;
@property(nonatomic,assign,getter = isDataChanged) BOOL dataChanged;

@property(nonatomic, assign)ZCURLDataSourceRequestType reqeustType;
@property(nonatomic, strong)NSString * requestTypeStr;

@property(nonatomic,weak)IBOutlet id delegate;

-(void) refreshData;

-(void) reloadData;

-(void) loadMoreData;

-(NSInteger) count;

-(id) dataObjectAtIndex:(NSInteger) index;

-(void) loadResultsData:(id) resultsData;

-(id) dataObject;

@end

@protocol ZCURLDataSourceDelegate

@optional

-(void) ZCDataSourceWillLoading:(ZCURLDataSource *) dataSource;

-(void) ZCDataSourceDidLoadedFromCache:(ZCURLDataSource *) dataSource timestamp:(NSDate *) timestamp;

-(void) ZCDataSourceDidLoaded:(ZCURLDataSource *) dataSource;

-(void) ZCDataSourceDidLoadResultsData:(ZCURLDataSource *) dataSource;

-(void) ZCDataSource:(ZCURLDataSource *) dataSource didFitalError:(NSError *) error;

-(void) ZCDataSourceDidContentChanged:(ZCURLDataSource *) dataSource;

@end
