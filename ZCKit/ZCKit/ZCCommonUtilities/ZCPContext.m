//
//  ZCPContext.m
//  ZCKit
//
//  Created by zhoucheng on 2016/10/13.
//  Copyright © 2016年 zhoucheng. All rights reserved.
//

#import "ZCPContext.h"
#import "IZCServiceContainer.h"
#import "IZCService.h"
#import <objc/runtime.h>
#import "NSObject+ZCValue.h"
#import "NSURL+ZCParam.h"
#import <Security/Security.h>
#import "IZCUIViewController.h"

@interface ZCServiceContainer : NSObject<IZCServiceContainer>{
    NSMutableSet * _taskTypes;
    Class _instanceClass;
}

-(id) initWithInstanceClass:(Class) instanceClass;

@end

@implementation ZCServiceContainer

@synthesize instance = _instance;
@synthesize config = _config;
@synthesize inherit = _inherit;

-(id) initWithInstanceClass:(Class) instanceClass{
    if((self = [super init])){
        _instanceClass = instanceClass;
    }
    return self;
}

-(BOOL) hasTaskType:(Protocol *) taskType{
    if(_inherit){
        for(NSValue * v in _taskTypes){
            Protocol * protocol = (Protocol *)[v pointerValue];
            if(protocol == taskType || (_inherit && protocol_conformsToProtocol(taskType,protocol))){
                return YES;
            }
        }
    }
    else{
        NSValue * v = [NSValue valueWithPointer:(__bridge const void * _Nullable)(taskType)];
        return [_taskTypes containsObject:v];
    }
    return NO;
}

-(void) addTaskType:(Protocol *) taskType{
    if(_taskTypes == nil){
        _taskTypes = [[NSMutableSet alloc] initWithCapacity:4];
    }
    [_taskTypes addObject:[NSValue valueWithPointer:(__bridge const void * _Nullable)(taskType)]];
}

-(id) instance{
    if(_instance == nil){
        _instance = [[_instanceClass alloc] init];
        [_instance setConfig:_config];
    }
    return _instance;
}

@end

@interface ZCPContext()
{
    NSMutableArray * _serviceContainers;
    NSMutableDictionary * _focusValues;
    NSMutableArray * _viewControllers;
    NSMutableArray * _waitCallbackObjects;
    NSBundle * _bundle;
}

@end

@implementation ZCPContext

@synthesize heapViewControllers = _heapViewControllers;

#pragma mark - init method
static ZCPContext * sharedInstance;

+ (ZCPContext *)sharedInstance
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

//alloc会触发，防止通过alloc创建一个不同的实例
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    
    return sharedInstance;
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    return self;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone
{
    return self;
}

#if ! __has_feature(objc_arc)
- (oneway void)release
{
    
}

- (instancetype)autorelease
{
    return self;
}

- (NSUInteger)retainCount
{
    return MAXFLOAT;
}
#else
#endif
- (void)dealloc
{
    
}

#pragma mark - context method
- (NSMutableArray *)heapViewControllers
{
    if (!_heapViewControllers) {
        _heapViewControllers = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _heapViewControllers;
}

- (void)loadConfig:(id)config bundle:(NSBundle *)bundle
{
    _config = config;
    _bundle = bundle;
    
    if(_bundle == nil){
        _bundle = [NSBundle mainBundle];
    }
    
    NSArray * items = [config valueForKey:@"services"];
    
    if([items isKindOfClass:[NSArray class]]){
        
        for(id cfg in items){
            NSString * className = [cfg valueForKey:@"class"];
            if(className){
                Class clazz = NSClassFromString(className);
                if(clazz){
                    if([clazz conformsToProtocol:@protocol(IZCService)]){
                        
                        if([[cfg valueForKey:@"disabled"] boolValue]){
                            continue;
                        }
                        
                        id container = [self addService:clazz];
                        [container setConfig:cfg];
                        [container setInherit:[[cfg valueForKey:@"inherit"] boolValue]];
                        NSArray * taskTypes = [cfg valueForKey:@"taskTypes"];
                        if([taskTypes isKindOfClass:[NSArray class]]){
                            for(NSString * taskType in taskTypes){
                                Protocol * p  = NSProtocolFromString(taskType);
                                if(p){
                                    [container addTaskType:p];
                                }
                                else{
                                    NSLog(@"Not found taskType %@",taskType);
                                }
                            }
                        }
                        if([cfg booleanValueForKey:@"instance"]){
                            [container instance];
                        }
                    }
                    else{
                        NSLog(@"Service Class %@ not implement IVTService",className);
                    }
                }
                else{
                    NSLog(@"Not found Service Class %@",className);
                }
            }
        }
        
    }
    
    
}

-(id<IZCServiceContainer>) addService:(Class) serviceClass{
    ZCServiceContainer * container = [[ZCServiceContainer alloc] initWithInstanceClass:serviceClass];
    if(_serviceContainers == nil){
        _serviceContainers = [[NSMutableArray alloc] initWithCapacity:4];
    }
    [_serviceContainers addObject:container];
    return container;
}

-(id) getViewControllerForURL:(NSURL *) url
{
    NSString * urlScheme = [url scheme];
    if ([url scheme]) {
        url = [ZCPContext removeSchemeWithURL:url];
    }
    NSString * alias = [url firstPathComponent];
    id viewController = nil;
    id cfg = [[_config valueForKey:@"ui"] valueForKey:alias];
    if(cfg){
        
        BOOL cached = [[cfg valueForKey:@"cached"] boolValue];
        if(cached){
            for(id viewController in _viewControllers){
                if([[viewController alias] isEqualToString:alias] && [viewController isDisplaced]){
                    [viewController setUrl:url];
                    return viewController;
                }
            }
        }
        
        id platform = cfg;
        
        
        id viewController = nil;
        
        NSString * className = [platform valueForKey:@"class"];
        
        if(className){
            Class clazz = NSClassFromString(className);
            if([clazz conformsToProtocol:@protocol(IZCUIViewController)]){
                
                NSString * view = [platform valueForKey:@"view"];
                
                if([clazz isSubclassOfClass:[UIViewController class]] && view){
                    NSBundle * bundle = nil;
                    if ([cfg objectForKey:@"bundle"]) {
                        bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[cfg objectForKey:@"bundle"] ofType:@"bundle"]];
                    }else{
                        bundle = [self resourceBundle];
                    }
                    viewController = [[clazz alloc] initWithNibName:view bundle:bundle];
                }
                else{
                    viewController = [[clazz alloc] init];
                }
            }
        }
        
        if(viewController){
            
            [viewController setAlias:alias];
            [viewController setScheme:[cfg valueForKey:@"scheme"]];
            if (![viewController scheme]) {
                [viewController setScheme:urlScheme];
            }
            [viewController setUrl:url];
            [viewController setConfig:cfg];
            
            if(cached){
                if(_viewControllers == nil){
                    _viewControllers = [[NSMutableArray alloc] initWithCapacity:4];
                }
                [_viewControllers addObject:viewController];
            }
            if ([urlScheme isEqualToString:@"root"] || [urlScheme isEqualToString:@"push"] || [urlScheme isEqualToString:@"present"]) {
                [self.heapViewControllers addObject:viewController];
            }
        }
        
        return viewController;
    }
    
    return viewController;
}

- (id)getObjectForURL:(NSURL *)url object:(id)object
{
    //逻辑有待优化，优先加载已存在内存中url对应class中的method，不存在则初始化再调用classMethod
    id resultObject = nil;
    id viewController = [self heapViewControllerContainsObjectWithURL:[ZCPContext removeActionWithURL:[ZCPContext removeSchemeWithURL:url]]];
    if (!viewController) {
        viewController = [self getViewControllerForURL:[ZCPContext removeActionWithURL:url]];
        if ([viewController isKindOfClass:[UIViewController class]]) {
            [viewController view];
        }
    }
    if (viewController) {
        NSURL * b_url = [ZCPContext removeSchemeWithURL:url];
        SEL sel = NSSelectorFromString([b_url lastPathComponent]);
        if ([viewController respondsToSelector:sel]) {
            resultObject = [viewController performSelector:sel withObject:object];
        }
    }
    return resultObject;
}

- (void)sendObjectURL:(NSURL *)url object:(id)object callback:(ZCViewConrollerCallback)callback
{
    //逻辑有待优化，优先加载已存在内存中url对应class中的method，不存在则初始化再调用classMethod
    id resultObject = nil;
    id viewController =  [self heapViewControllerContainsObjectWithURL:[ZCPContext removeActionWithURL:[ZCPContext removeSchemeWithURL:url]]];
    if (!viewController) {
        viewController = [self getViewControllerForURL:[ZCPContext removeActionWithURL:url]];
        if (viewController &&[viewController isKindOfClass:[UIViewController class]]) {
            [viewController view];
        }
    }
    if (viewController) {
        [viewController setViewControllerURLResultsCallback:callback];
        if (!_waitCallbackObjects) {
            _waitCallbackObjects = [[NSMutableArray alloc] initWithCapacity:0];
        }
        [_waitCallbackObjects addObject:viewController];
        NSURL * b_url = [ZCPContext removeSchemeWithURL:url];
        SEL sel = NSSelectorFromString([b_url lastPathComponent]);
        if ([viewController respondsToSelector:sel]) {
            [viewController performSelector:sel withObject:object];
        }
    }
}

- (void)finishSendObjectURLWithTarget:(id)target
{
    if ([_waitCallbackObjects containsObject:target]) {
        [_waitCallbackObjects removeObject:target];
    }
}

-(NSBundle *) resourceBundle{
    return _bundle;
}

#pragma mark - removeHeapViewControllerObjects
- (void)removeHeapViewControllersObject:(id)object
{
    if ([object isKindOfClass:[NSArray class]]) {
        for (id viewController in object) {
            if ([[ZCPContext sharedInstance].heapViewControllers containsObject:viewController]) {
                [[ZCPContext sharedInstance].heapViewControllers removeObject:viewController];
            }
        }
    }else{
        if ([[ZCPContext sharedInstance].heapViewControllers containsObject:object]) {
            [[ZCPContext sharedInstance].heapViewControllers removeObject:object];
        }
    }
}

#pragma mark - heapViewControllsHasThisObject
- (id)heapViewControllerContainsObjectWithURL:(NSURL *)url
{
    for (id object in self.heapViewControllers) {
        if ([[object url].absoluteString isEqualToString:url.absoluteString] ) {
            return object;
        }
    }
    return nil;
}

#pragma mark - Add Method
+ (NSURL *)removeSchemeWithURL:(NSURL *)url
{
    NSString * urlString = [url absoluteString];
    NSString * schemeString = [url scheme];
    url = [NSURL URLWithString:[urlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@://", schemeString] withString:@""]];
    return url;
}

+ (NSURL *)removeActionWithURL:(NSURL *)url
{
    NSString * urlScheme = [url scheme];
    url = [self removeSchemeWithURL:url];
    url = [NSURL URLWithString:[url.absoluteString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@", url.lastPathComponent] withString:@""]];
    if (urlScheme) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", urlScheme, url.absoluteString]];
    }
    return url;
}

@end
