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

-(void) didReceiveMemoryWarning{
    [_instance didReceiveMemoryWarning];
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

@synthesize registerObjects = _registerObjects;

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
- (NSMutableArray *)registerObjects
{
    if (!_registerObjects) {
        _registerObjects = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _registerObjects;
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
                        NSLog(@"Service Class %@ not implement IZCService",className);
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
    NSString * alias = [[ZCPContext removeSchemeWithURL:url] firstPathComponent];
    id viewController = nil;
    id cfg = [[_config valueForKey:@"ui"] valueForKey:alias];
    if(cfg){
        
        BOOL cached = [[cfg valueForKey:@"cached"] boolValue];
        if(cached){
            for(id viewController in _viewControllers){
                if([[viewController alias] isEqualToString:alias] && [viewController isDisplaced]){
                    [viewController setUrl:[ZCPContext removeActionWithURL:url]];
                    return viewController;
                }
            }
        }
        
        id viewController = [self getObjectWithCfg:cfg url:url];
        
        if (viewController && [viewController conformsToProtocol:@protocol(IZCUIViewController) ]) {
            if(cached){
                if(_viewControllers == nil){
                    _viewControllers = [[NSMutableArray alloc] initWithCapacity:4];
                }
                [_viewControllers addObject:viewController];
            }
        }
        return viewController;
    }
    
    return viewController;
}

- (id)getObjectWithCfg:(id)cfg url:(NSURL *)url
{
    id platform = cfg;
    
    id object = nil;
    
    NSString * className = [platform valueForKey:@"class"];
    
    if(className){
        Class clazz = NSClassFromString(className);
        if([clazz conformsToProtocol:@protocol(IZCRegisterObject)]){
            
            NSString * view = [platform valueForKey:@"view"];
            
            if([clazz isSubclassOfClass:[UIViewController class]] && view){
                NSBundle * bundle = nil;
                if ([cfg objectForKey:@"bundle"]) {
                    bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[cfg objectForKey:@"bundle"] ofType:@"bundle"]];
                }else{
                    bundle = [self resourceBundle];
                }
                object = [[clazz alloc] initWithNibName:view bundle:bundle];
            }
            else{
                object = [[clazz alloc] init];
            }
        }
    }

    if(object){
        
        [object setAlias:[[ZCPContext removeActionWithURL:url] firstPathComponent]];
        [object setScheme:[cfg valueForKey:@"scheme"]];
        if (![object scheme]) {
            [object setScheme:[url scheme]];
        }
        [object setUrl:[ZCPContext removeSchemeWithURL:url]];
        [object setConfig:cfg];
        
        if ([[url scheme] isEqualToString:@"root"] || [[url scheme] isEqualToString:@"push"] || [[url scheme] isEqualToString:@"present"]) {
            [self.registerObjects addObject:object];
        }
    }
    return object;
}

- (BOOL)registerObjectForURL:(NSURL *)url
{
#warning 需要优化如何删除重复注册问题
    NSString * urlScheme = [url scheme];
    NSString * alias = [[ZCPContext removeSchemeWithURL:url] firstPathComponent];
    id cfg = [[_config valueForKey:@"register"] valueForKey:alias];
    if (cfg) {
        id object = [self getObjectWithCfg:cfg url:url];
        if (object) {
            [self.registerObjects addObject:object];
            return YES;
        }
    }
    return NO;
}

- (BOOL)resignObjectForURL:(NSURL *)url
{
    id registerObject = nil;
    for (id object in self.registerObjects) {
        if ([[object url].absoluteString isEqualToString:[ZCPContext removeSchemeWithURL:url].absoluteString]) {
            registerObject = object;
            break;
        }
    }
    if (registerObject) {
        [self.registerObjects removeObject:registerObject];
        return YES;
    }
    return NO;
}

- (id)getValueForRegisterObjectURL:(NSURL *)url object:(id)object
{
#warning 需要考虑在未注册情况下是否自动初始化问题
    id resultObject = nil;
    id viewController = [self registerObjectsContainsObjectWithURL:[ZCPContext removeActionWithURL:[ZCPContext removeSchemeWithURL:url]]];
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

- (void)sendRegisterObjectURL:(NSURL *)url object:(id)object callback:(ZCViewConrollerCallback)callback
{
#warning 需要考虑在未注册情况下是否自动初始化问题
    id resultObject = nil;
    id viewController =  [self registerObjectsContainsObjectWithURL:[ZCPContext removeActionWithURL:[ZCPContext removeSchemeWithURL:url]]];
    if (!viewController) {
        viewController = [self getViewControllerForURL:[ZCPContext removeActionWithURL:url]];
        if (viewController &&[viewController isKindOfClass:[UIViewController class]]) {
            [viewController view];
        }
    }
    if (viewController) {
        [viewController setObjectURLResultsCallback:callback];
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

#pragma mark - removeRegisterObject
- (void)removeRegisterObject:(id)object
{
    if ([object isKindOfClass:[NSArray class]]) {
        for (id viewController in object) {
            if ([[ZCPContext sharedInstance].registerObjects containsObject:viewController]) {
                [[ZCPContext sharedInstance].registerObjects removeObject:viewController];
            }
        }
    }else{
        if ([[ZCPContext sharedInstance].registerObjects containsObject:object]) {
            [[ZCPContext sharedInstance].registerObjects removeObject:object];
        }
    }
}

#pragma mark - heapViewControllsHasThisObject
- (id)registerObjectsContainsObjectWithURL:(NSURL *)url
{
    for (id object in self.registerObjects) {
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

#pragma mark - serviceHelpMethod
-(BOOL) handle:(Protocol *)taskType task:(id<IZCTask>)task priority:(NSInteger)priority{
    for(id container in _serviceContainers){
        if([container hasTaskType:taskType]){
            id s = [container instance];
            if([s handle:taskType task:task priority:priority]){
                return YES;
            }
        }
    }
    return NO;
}

-(BOOL) cancelHandle:(Protocol *)taskType task:(id<IZCTask>)task{
    for(id container in _serviceContainers){
        if([container hasTaskType:taskType]){
            id s = [container instance];
            if([s cancelHandle:taskType task:task]){
                return YES;
            }
        }
    }
    return NO;
}

-(BOOL) cancelHandleForSource:(id) source{
    for(id container in _serviceContainers){
        id s = [container instance];
        if([s cancelHandleForSource:source]){
            return YES;
        }
    }
    return NO;
}

@end
