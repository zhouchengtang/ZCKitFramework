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
    NSBundle * _bundle;
}

@end

@implementation ZCPContext
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

-(id) getViewController:(NSURL *) url
{
    if ([url scheme]) {
        NSString * urlString = [url absoluteString];
        NSString * schemeString = [url scheme];
        url = [NSURL URLWithString:[urlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@://", schemeString] withString:@""]];
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
                    viewController = [[clazz alloc] initWithNibName:view bundle:[self resourceBundle]];
                }
                else{
                    viewController = [[clazz alloc] init];
                }
            }
        }
        
        if(viewController){
            
            [viewController setAlias:alias];
            [viewController setScheme:[cfg valueForKey:@"scheme"]];
            [viewController setUrl:url];
            [viewController setConfig:cfg];
            
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

-(NSBundle *) resourceBundle{
    return _bundle;
}

@end
