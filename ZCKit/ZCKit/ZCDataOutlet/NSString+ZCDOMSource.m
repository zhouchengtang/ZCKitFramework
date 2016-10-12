//
//  NSString+VTDOMSource.m
//  vTeam
//
//  Created by tang zhoucheng on 13-8-14.
//  Copyright (c) 2013年 zhoucheng.org. All rights reserved.
//

#import "NSString+ZCDOMSource.h"
#import "ZCDataOutlet.h"

@implementation NSString (ZCDOMSource)

-(NSString *) htmlEncodeString{
    NSString * v = self;
    v = [v stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    v = [v stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp;"];
    v = [v stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    v = [v stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    v = [v stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    v = [v stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    v = [v stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
    v = [v stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    return v;
}

-(NSString *) htmlDecodeString{
    NSString * v = self;
    v = [v stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    v = [v stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    v = [v stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    v = [v stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    v = [v stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    v = [v stringByReplacingOccurrencesOfString:@"\\t" withString:@"\t"];
    v = [v stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    return v;
}

-(NSString *) htmlStringByDOMSource:(id)data{
    return [self htmlStringByDOMSource:data htmlEncoded:YES];
}

-(NSString *) htmlStringByDOMSource:(id) data htmlEncoded:(BOOL) htmlEncoded{
    
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
                            if([v isKindOfClass:[NSString class]]){
                                [ms appendString:htmlEncoded ? [v htmlEncodeString] : v];
                            }
                            else{
                                [ms appendFormat:@"%@",v];
                            }
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

@end
