//
//  ZCBaseModel.m
//  PrivateAccountBook
//
//  Created by 唐周成 on 15/11/22.
//  Copyright © 2015年 JiaPin. All rights reserved.
//

#import "ZCBaseModel.h"
#import "NSMutableArray+ZCBaseModel.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface ZCBaseModelClassProperty()
@end

@implementation ZCBaseModelClassProperty
@synthesize name = _name;
@synthesize type = _type;
@synthesize structName = _structName;
@synthesize protocol = _protocol;

@end


@implementation ZCBaseModel
{
    NSDictionary * _zcBaaseModelPropertyMapDic;
    NSDictionary * _modelDict;
}

- (instancetype)initWithDictionary: (NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        [self setModelWithDictionary:dictionary];
    }
    return self;
}

- (instancetype)initWithJsonData: (NSData *)jsonData
{
    self = [super init];
    if (self) {
        NSDictionary * json = [self dictionaryWithJsonData:jsonData];
        if (json == nil) {
            NSLog(@"json parse failed \r\n");
            return nil;
        }
        [self setModelWithDictionary:json];
    }
    return self;
}

- (instancetype)initWithJsonString: (NSString *)jsonString
{
    self = [super init];
    if (self) {
        NSDictionary *json = [self dictionaryWithJsonData:jsonString];
        if (json == nil) {
            NSLog(@"json parse failed \r\n");
            return nil;
        }
        [self setModelWithDictionary:json];
    }
    return self;
}

+ (instancetype)modelWithDictionary: (NSDictionary *)dictionary
{
    return [[self alloc] initWithDictionary:dictionary];
}

+ (instancetype)modelWithJsonData:(NSData *)jsonData
{
    return [[self alloc] initWithJsonData:jsonData];
}

+ (instancetype)modelWithJsonString:(NSString *)jsonString
{
    return [[self alloc] initWithJsonString:jsonString];
}

- (NSDictionary *)dictionaryWithJsonData:(id)jsonData
{
    NSError *error;
    if ([jsonData isKindOfClass:[NSData class]]) {
        return [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    }else if ([jsonData isKindOfClass:[NSString class]]){
        return [NSJSONSerialization JSONObjectWithData:[jsonData dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    }else{
        return nil;
    }
}

- (void)setModelWithDictionary: (NSDictionary *) data
{
    if ([self propertyMapDic] == nil) {
        [self assginToPropertyWithDictionary:data];
    } else {
        [self assginToPropertyWithNoMapDictionary:data];
    }
}

-(void) assginToPropertyWithDictionary: (NSDictionary *) data{
    
    if (data == nil) {
        return;
    }
    
    _modelDict = data;
    
    NSArray * allPropertys = [self allPropertys];
    ///赋值给实体类的属性
    for (NSInteger i = 0; i < allPropertys.count; i ++) {
        ZCBaseModelClassProperty * modelProperty = allPropertys[i];
        if (![data objectForKey:modelProperty.name]) {
            continue;
        }
        ///通过getSetterSelWithAttibuteName 方法来获取实体类的set方法
        SEL setSel = [self creatSetterWithPropertyName:modelProperty.name];
        
        if ([self respondsToSelector:setSel]) {
            Method setMethod = class_getInstanceMethod([self class], setSel);
            char ArgumentType[256];
            method_getArgumentType(setMethod, 2, ArgumentType, sizeof(ArgumentType));
            id ArgumentValue = data[modelProperty.name];
            if( !strcmp(ArgumentType, @encode(void))){
                ArgumentValue =  nil;
            }
            //如果返回值为对象，那么为变量赋值
            else if( !strcmp(ArgumentType, @encode(id)) ){
                ArgumentValue = data[modelProperty.name];
                if ([ArgumentValue isKindOfClass:[NSDictionary class]]) {
                    if (modelProperty.type && [modelProperty.type isSubclassOfClass:[ZCBaseModel class]]) {
                        ArgumentValue = [[modelProperty.type alloc] initWithDictionary:ArgumentValue];
                    }
                }else if ([ArgumentValue isKindOfClass:[NSArray class]]){
                    if (modelProperty.protocol && NSClassFromString(modelProperty.protocol)) {
                        NSMutableArray * modelArray = [[NSMutableArray alloc] initWithCapacity:0];
                        ArgumentValue = [modelArray modelArrayWithDataArray:ArgumentValue modelProperty:modelProperty];
                    }
                }
            }
            //如果返回值为BOOL等类型
            else if ([ArgumentValue isKindOfClass:[NSString class]] || [ArgumentValue isKindOfClass:[NSNumber class]]){
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                NSNumber * numberArgumentValue;
                if ([ArgumentValue isKindOfClass:[NSString class]]) {
                    numberArgumentValue = [numberFormatter numberFromString:ArgumentValue];
                }else{
                    numberArgumentValue = ArgumentValue;
                }
                if( !strcmp(ArgumentType, @encode(bool)) ) {
                    ((void (*)(id, SEL, bool))(void *) objc_msgSend)(self, setSel, numberArgumentValue.boolValue);
                }else if(!strcmp(ArgumentType, @encode(int8_t)) ){
                    ((void (*)(id, SEL, int8_t))(void *) objc_msgSend)(self, setSel, (int8_t)numberArgumentValue.charValue);
                }
                else if(!strcmp(ArgumentType, @encode(uint8_t)) ){
                    ((void (*)(id, SEL, uint8_t))(void *) objc_msgSend)(self, setSel, (uint8_t)numberArgumentValue.unsignedCharValue);
                }
                else if(!strcmp(ArgumentType, @encode(int16_t)) ){
                    ((void (*)(id, SEL, int16_t))(void *) objc_msgSend)(self, setSel,(int16_t)numberArgumentValue.shortValue);
                }
                else if(!strcmp(ArgumentType, @encode(uint16_t)) ){
                    ((void (*)(id, SEL, uint16_t))(void *) objc_msgSend)(self, setSel, (uint16_t)numberArgumentValue.unsignedShortValue);
                }
                else if(!strcmp(ArgumentType, @encode(int32_t)) ){
                    ((void (*)(id, SEL, int32_t))(void *) objc_msgSend)(self, setSel,  (int32_t)numberArgumentValue.intValue);
                }
                else if(!strcmp(ArgumentType, @encode(uint32_t)) ){
                    ((void (*)(id, SEL, uint32_t))(void *) objc_msgSend)(self, setSel,  (uint32_t)numberArgumentValue.unsignedIntValue);
                }
                else if(!strcmp(ArgumentType, @encode(int64_t)) ){
                    ((void (*)(id, SEL, int64_t))(void *) objc_msgSend)(self, setSel, (int64_t)numberArgumentValue.stringValue.longLongValue);
                }
                else if(!strcmp(ArgumentType, @encode(uint64_t)) ){
                    ((void (*)(id, SEL, uint64_t))(void *) objc_msgSend)(self, setSel, (uint64_t)numberArgumentValue.unsignedLongLongValue);
                }
                else if(!strcmp(ArgumentType, @encode(float)) ){
                    ((void (*)(id, SEL, float))(void *) objc_msgSend)(self, setSel, numberArgumentValue.floatValue);
                }
                else if(!strcmp(ArgumentType, @encode(double)) ){
                    ((void (*)(id, SEL, double))(void *) objc_msgSend)(self, setSel, numberArgumentValue.doubleValue);
                }else if(!strcmp(ArgumentType, @encode(long double)) ){
                    ((void (*)(id, SEL, long double))(void *) objc_msgSend)(self, setSel, (long double)numberArgumentValue.doubleValue);
                }
                continue;
            }
            
            //           [self performSelectorOnMainThread:setSel
            //                                   withObject:returnValue
            //                                waitUntilDone:[NSThread isMainThread]];
            ((void (*)(id, SEL, id))(void *) objc_msgSend)(self, setSel, ArgumentValue);
        }
        
    }
    
}

-(void) assginToPropertyWithNoMapDictionary: (NSDictionary *) data{
    ///获取字典和Model属性的映射关系
    NSDictionary *propertyMapDic = [self propertyMapDic];
    ///转化成key和property一样的字典，然后调用assginToPropertyWithDictionary方法
    NSArray *dicKey = [data allKeys];
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:dicKey.count];
    for (NSInteger i = 0; i < dicKey.count; i ++) {
        NSString *key = dicKey[i];
        if (propertyMapDic[key] && data[key] ) {
            [tempDic setObject:data[key] forKey:propertyMapDic[key]];
        }else{
            [tempDic setObject:data[key] forKey:key];
        }
    }
    [self assginToPropertyWithDictionary:tempDic];
}

#pragma mark -- 通过字符串来创建该字符串的Setter方法，并返回
- (SEL) creatSetterWithPropertyName: (NSString *) propertyName{
    
    //首字母大写
    if (propertyName.length > 0) {
        NSString * firstChar = [propertyName substringWithRange:NSMakeRange(0, 1)];
        firstChar = firstChar.uppercaseString;
        NSMutableString * mutablePropertyName = [NSMutableString stringWithString:propertyName];
        [mutablePropertyName replaceCharactersInRange:NSMakeRange(0, 1) withString:firstChar];
        propertyName = mutablePropertyName;
    }
    //拼接上set关键字
    propertyName = [NSString stringWithFormat:@"set%@:", propertyName];
    
    //返回set方法
    return NSSelectorFromString(propertyName);
}

#pragma mark -- 通过字符串来创建该字符串的Setter方法，并返回
- (SEL) creatGetterWithPropertyName: (NSString *) propertyName{
    //返回get方法: oc中的get方法就是属性的本身
    return NSSelectorFromString(propertyName);
}

#pragma mark - 获取当前model所有属性名称
- (NSArray *) allPropertys{
    ///存储所有的属性名称
    NSMutableArray *allNames = [[NSMutableArray alloc] init];
    
    if ([class_getSuperclass([self class]) isSubclassOfClass:[ZCBaseModel class]]) {
        //递归添加父类属性
        Class clazz = class_getSuperclass([self class]);
        id superModel = [[clazz alloc] init];
        if([superModel allPropertys].count > 0)
            [allNames addObjectsFromArray:[superModel allPropertys]];
        
        ///存储属性的个数
        unsigned int propertyCount = 0;
        ///通过运行时获取当前类的属性
        objc_property_t * propertys = class_copyPropertyList([self class], &propertyCount);
        [allNames addObjectsFromArray:[self getPropertysArrayWithPropertys:propertys propertyCount:propertyCount]];
        /*
         unsigned int protocolsCount = 0;
         Protocol * __unsafe_unretained*protocols = objc_copyProtocolList(&protocolsCount);
         
         for (NSInteger i = 0; i < protocolsCount; i++) {
         unsigned int protocolsPropertyCount = 0;
         objc_property_t * protocolsPropertys = protocol_copyPropertyList(protocols[i], &protocolsPropertyCount);
         [allNames addObjectsFromArray:[self getPropertysArrayWithPropertys:protocolsPropertys propertyCount:protocolsPropertyCount]];
         }
         */
    }

    return allNames;
}

- (NSArray *)getPropertysArrayWithPropertys:(objc_property_t *)propertys propertyCount:(unsigned int)propertyCount
{
    NSMutableArray *allNames = [[NSMutableArray alloc] init];
    NSScanner* scanner = nil;
    NSString* propertyType = nil;
    
    //把属性放到数组中
    for (NSInteger i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        ZCBaseModelClassProperty * modelProperty = [[ZCBaseModelClassProperty alloc] init];
        
        objc_property_t property = propertys[i];
        const char * propertyName = property_getName(property);
        modelProperty.name = [NSString stringWithUTF8String:propertyName];
        if (_modelDict && ![_modelDict objectForKey:modelProperty.name]) {
            continue;
        }
        
        const char *attrs = property_getAttributes(property);
        NSString* propertyAttributes = @(attrs);
        NSArray* attributeItems = [propertyAttributes componentsSeparatedByString:@","];
        
        //ignore read-only properties
        if ([attributeItems containsObject:@"R"]) {
            continue; //to next property
        }
        
        scanner = [NSScanner scannerWithString: propertyAttributes];
        
        //ZCLog(@"attr: %@", [NSString stringWithCString:attrs encoding:NSUTF8StringEncoding]);
        [scanner scanUpToString:@"T" intoString: nil];
        [scanner scanString:@"T" intoString:nil];
        
        //check if the property is an instance of a class
        if ([scanner scanString:@"@\"" intoString: &propertyType]) {
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"]
                                    intoString:&propertyType];
            //ZCLog(@"type: %@", propertyClassName);
            modelProperty.type = NSClassFromString(propertyType);
            
            while ([scanner scanString:@"<" intoString:NULL]) {
                NSString* protocolName = nil;
                [scanner scanUpToString:@">" intoString: &protocolName];
                if (propertyName) {
                    modelProperty.protocol = protocolName;
                }
                [scanner scanString:@">" intoString:NULL];
            }
        }
        [allNames addObject:modelProperty];
    }
    ///释放
    free(propertys);
    return allNames;
}

#pragma mark - propertyMapDic
- (NSDictionary *)propertyMapDic
{
    if (_zcBaaseModelPropertyMapDic) {
        return _zcBaaseModelPropertyMapDic;
    }
    return nil;
}

- (void)setPropertyMapDic:(NSDictionary *)propertyMapDic
{
    _zcBaaseModelPropertyMapDic = propertyMapDic;
}

#pragma mark - dictionaryWithModel
- (NSDictionary *)dictionaryWithModel
{
    //获取实体类的属性名
    NSArray *array = [self allPropertys];
    NSMutableDictionary * modelDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < array.count; i ++) {
        ZCBaseModelClassProperty * modelProperty = array[i];
        //获取get方法
        SEL getSel = [self creatGetterWithPropertyName:modelProperty.name];
        if ([self respondsToSelector:getSel]) {
            
            Method getMethod = class_getInstanceMethod([self class], getSel);
            char returnType[256];
            method_getReturnType(getMethod, returnType, sizeof(returnType));
            
            id returnValue;
            //如果没有返回值，也就是消息声明为void，那么returnValue=nil
            if( !strcmp(returnType, @encode(void)) ){
                returnValue =  nil;
            }
            //如果返回值为对象，那么为变量赋值
            else if( !strcmp(returnType, @encode(id)) ){
                returnValue = ((id (*)(id, SEL))(void *) objc_msgSend)(self, getSel);
                if ([[returnValue class] isSubclassOfClass:[ZCBaseModel class]]) {
                    returnValue = [(ZCBaseModel *)returnValue dictionaryWithModel];
                }else if ([[returnValue class] isSubclassOfClass:[NSMutableArray class]] && [(NSMutableArray *)returnValue modelProperty]){
                    returnValue = [(NSMutableArray *)returnValue dataArrayWithModelArray:returnValue];
                }
            }
            else{
                if( !strcmp(returnType, @encode(bool)) ) {
                    returnValue = @(((bool (*)(id, SEL))(void *) objc_msgSend)(self, getSel));
                }
                else if(!strcmp(returnType, @encode(int8_t)) ){
                    returnValue = @(((int8_t (*)(id, SEL))(void *) objc_msgSend)(self, getSel));
                }
                else if(!strcmp(returnType, @encode(uint8_t)) ){
                    returnValue = @(((uint8_t (*)(id, SEL))(void *) objc_msgSend)(self, getSel));
                }
                else if(!strcmp(returnType, @encode(int16_t)) ){
                    returnValue = @(((int16_t (*)(id, SEL))(void *) objc_msgSend)(self, getSel));
                }
                else if(!strcmp(returnType, @encode(uint16_t)) ){
                    returnValue = @(((uint16_t (*)(id, SEL))(void *) objc_msgSend)(self, getSel));
                }
                else if(!strcmp(returnType, @encode(int32_t)) ){
                    returnValue = @(((int32_t (*)(id, SEL))(void *) objc_msgSend)(self, getSel));
                }
                else if(!strcmp(returnType, @encode(uint32_t)) ){
                    returnValue = @(((uint32_t (*)(id, SEL))(void *) objc_msgSend)(self, getSel));
                }
                else if(!strcmp(returnType, @encode(int64_t)) ){
                    returnValue = @(((int64_t (*)(id, SEL))(void *) objc_msgSend)(self, getSel));
                }
                else if(!strcmp(returnType, @encode(uint64_t)) ){
                    returnValue = @(((uint64_t (*)(id, SEL))(void *) objc_msgSend)(self, getSel));
                }
                else if(!strcmp(returnType, @encode(float)) ){
                    returnValue = @(((float (*)(id, SEL))(void *) objc_msgSend)(self, getSel));
                }
                else if(!strcmp(returnType, @encode(double)) ){
                    returnValue = @(((double (*)(id, SEL))(void *) objc_msgSend)(self, getSel));
                }else if(!strcmp(returnType, @encode(long double)) ){
                    double num = ((long double (*)(id, SEL))(void *) objc_msgSend)(self, getSel);
                    returnValue = @(num);
                }
            }
            //设置key&value
            if (returnValue) {
                [modelDict setObject:returnValue forKey:modelProperty.name];
            }
            /*
            else{
                [modelDict setObject:@"" forKey:modelProperty.name];
            }
            */
        }
    }
    return modelDict;
}

#pragma mark - jsonDataMethod
- (NSData *)jsonDataWithModel
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self dictionaryWithModel] options:NSJSONWritingPrettyPrinted error:&error];
    return jsonData;
}

- (NSString *)jsonStringWithModel
{
    NSString *jsonString =[[NSString alloc] initWithData:[self jsonDataWithModel] encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end
