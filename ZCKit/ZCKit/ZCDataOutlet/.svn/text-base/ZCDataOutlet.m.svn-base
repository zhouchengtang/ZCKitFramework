//
//  ZCDataOutlet.m
//  vTeam
//
//  Created by tang zhoucheng on 13-4-25.
//  Copyright (c) 2013年 zhoucheng.org. All rights reserved.
//

#import "ZCDataOutlet.h"

#import "NSString+ZCDOMSource.h"

@implementation NSObject(ZCDataOutlet)

-(id) dataForKey:(NSString *) key{
    if([self isKindOfClass:[NSString class]]){
        return nil;
    }
    if([self isKindOfClass:[NSNumber class]]){
        return nil;
    }
    if([self isKindOfClass:[NSNull class]]){
        return nil;
    }
    if([self isKindOfClass:[NSData class]]){
        return nil;
    }
    if([self isKindOfClass:[NSDate class]]){
        return nil;
    }
    if([self isKindOfClass:[NSArray class]]){
        if([key hasPrefix:@"@last"]){
            return [(NSArray *)self lastObject];
        }
        else if([key hasPrefix:@"@joinString"]){
            return [(NSArray *)self componentsJoinedByString:@","];
        }
        else if([key hasPrefix:@"@count"]){
            return [NSNumber numberWithUnsignedInteger:[(NSArray *) self count]];
        }
        else if([key hasPrefix:@"@"]){
            NSInteger index = [[key substringFromIndex:1] intValue];
            if(index >=0 && index < [(NSArray *)self count]){
                return [(NSArray *)self objectAtIndex:index];
            }
        }
        return nil;
    }
#ifdef DEBUG
    return [self valueForKey:key];
#else
    @try {
        return [self valueForKey:key];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
        return nil;
    }
#endif
}

-(id) dataForKeyPath:(NSString *) keyPath{
    NSRange r = [keyPath rangeOfString:@"."];
    if(r.location == NSNotFound){
        return [self dataForKey:keyPath];
    }
    id v = [self dataForKey:[keyPath substringToIndex:r.location]];
    return [v dataForKeyPath:[keyPath substringFromIndex:r.location + r.length]];
}

@end

@implementation NSString (VTDataOutlet)

-(NSString *) stringByDataOutlet:(id) data{
    NSMutableString * ms = [NSMutableString stringWithCapacity:30];
    NSMutableString * keyPath = [NSMutableString stringWithCapacity:30];
    
    unichar uc;
    unichar ucnext;
    
    NSUInteger length = [self length];
    int s = 0;
    
    for(int i=0;i<length;i++){
        
        uc = [self characterAtIndex:i];
        if (i<length-1) {
            ucnext = [self characterAtIndex:i+1];
        }
        else
        {
            ucnext = '\0';
        }
        
        switch (s) {
            case 0:
            {
                if(uc == '~'&&ucnext== '['){
                    NSRange r = {0,[keyPath length]};
                    [keyPath deleteCharactersInRange:r];
                    s =1;
                    i++;
                }
                else{
                    [ms appendFormat:@"%C",uc];
                }
            }
                break;
            case 1:
            {
                if(uc == ']'&&ucnext== '~'){
                    
                    if([keyPath hasPrefix:@"$"]){
                        id v = [data dataForKeyPath:[keyPath substringFromIndex:1]];
                        if(v){
                            if([v isKindOfClass:[NSString class]]){
                                [ms appendString:v];
                            }
                            else{
                                [ms appendFormat:@"%@",v];
                            }
                        }
                    }
                    else{
                        id v = [data dataForKeyPath:keyPath];
                        if(v){
                            [ms appendFormat:@"%@",v];
                        }
                        
                    }
                    s = 0;
                    i++;
                }
                else{
                    [keyPath appendFormat:@"%C",uc];
                }
            }
                break;
            default:
                break;
        }
        
    }
    
    return ms;
}

-(NSString *) stringByDataOutlet:(id) data stringValue: (ZCDataOutletStringValue)value{
    NSMutableString * ms = [NSMutableString stringWithCapacity:30];
    NSMutableString * keyPath = [NSMutableString stringWithCapacity:30];
    
    unichar uc;
    
    NSUInteger length = [self length];
    int s = 0;
    
    for(int i=0;i<length;i++){
        
        uc = [self characterAtIndex:i];
        
        switch (s) {
            case 0:
            {
                if(uc == '{'){
                    NSRange r = {0,[keyPath length]};
                    [keyPath deleteCharactersInRange:r];
                    s =1;
                }
                else{
                    [ms appendString:[NSString stringWithCharacters:&uc length:1]];
                }
            }
                break;
            case 1:
            {
                if(uc == '}'){
                    id v = [data dataForKeyPath:keyPath];
                    if(v){
                        [ms appendString:value(data,keyPath)];
                    }
                    s = 0;
                }
                else{
                    [keyPath appendString:[NSString stringWithCharacters:&uc length:1]];
                }
            }
                break;
            default:
                break;
        }
        
    }
    
    return ms;
}

-(NSString *) stringByDataOutletURLEncode:(id) data{
    
    NSMutableString * ms = [NSMutableString stringWithCapacity:30];
    NSMutableString * keyPath = [NSMutableString stringWithCapacity:30];
    
    unichar uc;
    
    NSUInteger length = [self length];
    int s = 0;
    
    for(int i=0;i<length;i++){
        
        uc = [self characterAtIndex:i];
        
        switch (s) {
            case 0:
            {
                if(uc == '{'){
                    NSRange r = {0,[keyPath length]};
                    [keyPath deleteCharactersInRange:r];
                    s =1;
                }
                else{
                    [ms appendString:[NSString stringWithCharacters:&uc length:1]];
                }
            }
                break;
            case 1:
            {
                if(uc == '}'){
                    id v = [data dataForKeyPath:keyPath];
                    if(v){
                        if([v isKindOfClass:[NSString class]]){
                            [ms appendString:[v stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                        }
                        else{
                            [ms appendFormat:@"%@",v];
                        }
                    }
                    s = 0;
                }
                else{
                    [keyPath appendString:[NSString stringWithCharacters:&uc length:1]];
                }
            }
                break;
            default:
                break;
        }
        
    }
    
    return ms;
}

@end

@implementation ZCDataOutlet

@synthesize keyPath = _keyPath;
@synthesize stringKeyPath = _stringKeyPath;
@synthesize stringFormat = _stringFormat;
@synthesize booleanKeyPath = _booleanKeyPath;
@synthesize enabledKeyPath = _enabledKeyPath;
@synthesize disabledKeyPath = _disabledKeyPath;
@synthesize value = _value;
@synthesize status = _status;
@synthesize valueKeyPath = _valueKeyPath;
@synthesize views = _views;

-(BOOL) booleanValue:(id) value{
    if(value){
        if([value isKindOfClass:[NSString class]]){
            if([value isEqualToString:@"false"] || [value isEqualToString:@""] || [value isEqualToString:@"0"]){
                return NO;
            }
            else{
                return YES;
            }
        }
        else if([value respondsToSelector:@selector(boolValue)] && ![value boolValue]){
            return NO;
        }
        else{
            return YES;
        }
    }
    return NO;
}

-(void) applyDataOutlet:(id)data{
    
    if(_enabledKeyPath){
        if(![self booleanValue:[data dataForKeyPath:_enabledKeyPath]]){
            return;
        }
    }
    
    if(_disabledKeyPath){
        if([self booleanValue:[data dataForKeyPath:_disabledKeyPath]]){
            return;
        }
    }
    
    id value = _value;
    if(_stringKeyPath){
        value = [data dataForKeyPath:_stringKeyPath];
        if(value && ![value isKindOfClass:[NSString class]]){
            value = [NSString stringWithFormat:@"%@",value];
        }
    }
    else if(_booleanKeyPath){
        value = [data dataForKeyPath:_booleanKeyPath];
        value = [NSNumber numberWithBool:[self booleanValue:value]];
    }
    else if(_stringFormat){
        NSString* newString = [self changeHtmlSymolWith:_stringFormat];
        
        value = [newString stringByDataOutlet:data];
    }
    else if(_valueKeyPath){
        value = [data dataForKeyPath:_valueKeyPath];
    }
    else if(_stringHtmlFormat){
        NSString* newString = [self changeHtmlSymolWith:_stringHtmlFormat];
        value = [newString htmlStringByDOMSource:data];
        
    }
    
    if([value isKindOfClass:[NSNull class]]){
        value = nil;
    }
    
#ifdef DEBUG
    for(id view in _views){
        [view setValue:value forKeyPath:self.keyPath];
    }
#else
    for(id view in _views){
        @try {
            [view setValue:value forKeyPath:self.keyPath];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
    }
#endif
    
}

-(NSString*)changeHtmlSymolWith:(NSString*)string
{
    NSString* ret = string;
    NSRange range1 = [string rangeOfString:@"{"];
    NSRange range2 = [string rangeOfString:@"}"];
    if (range1.location!=NSNotFound&&range1.location!=NSNotFound&&range1.location<range2.location) {
        ret = [string stringByReplacingOccurrencesOfString:@"{" withString:@"~["];
        ret = [ret stringByReplacingOccurrencesOfString:@"}" withString:@"]~"];
    }
    
    return ret;
}

-(id) view{
    return [_views lastObject];
}

-(void) setView:(id)view{
    [self setViews:view ? [NSArray arrayWithObject:view] : nil];
}

@end
