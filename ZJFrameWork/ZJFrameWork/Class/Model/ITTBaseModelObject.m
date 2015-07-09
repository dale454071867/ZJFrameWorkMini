//
//  ITTBaseModelObject.m
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ITTBaseModelObject.h"
#import <objc/runtime.h>

@interface ITTBaseModelObject()

- (void)setAttributes:(NSDictionary*)dataDic;

@end

@implementation ITTBaseModelObject

-(NSDictionary*)attributeMapDictionary
{
    unsigned int propertyCount = 0;
    NSMutableDictionary *retdic = [NSMutableDictionary dictionary];
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
    for (int i = 0; i<propertyCount; i++) {
        objc_property_t property = propertys[i];
        [retdic setObject:[NSString stringWithFormat:@"%s",property_getName(property)]  forKey:[NSString stringWithFormat:@"%s",property_getName(property)]];
    }
    return retdic;
}
- (NSString *)customDescription
{
    return nil;
}

- (NSData*)getArchivedData
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

- (NSString *)description
{
    NSMutableString *attrsDesc = [NSMutableString stringWithCapacity:100];
    NSDictionary *attrMapDic = [self attributeMapDictionary];
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    while ((attributeName = [keyEnum nextObject])) {
        SEL getSel = NSSelectorFromString(attributeName);
        if ([self respondsToSelector:getSel]) {
            NSMethodSignature *signature = nil;
            signature = [self methodSignatureForSelector:getSel];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:getSel];
            NSObject *__unsafe_unretained valueObj = nil;
            [invocation invoke];
            [invocation getReturnValue:&valueObj];
            if (valueObj) {
                [attrsDesc appendFormat:@" [%@=%@] ",attributeName,valueObj];
                //[valueObj release];
            }else {
                [attrsDesc appendFormat:@" [%@=nil] ",attributeName];
            }
            
        }
    }
    NSString *customDesc = [self customDescription];
    NSString *desc;
    if (customDesc && [customDesc length] > 0 ) {
        desc = [NSString stringWithFormat:@"%@:{%@,%@}",[self class],attrsDesc,customDesc];
    }
    else {
        desc = [NSString stringWithFormat:@"%@:{%@}",[self class],attrsDesc];
    }
    return desc;
}

-(id)initWithDataDic:(NSDictionary*)data
{
    if (self = [super init]) {
//        [self setAttributes:data];
        self =  [self NSDictionaryToObject:data ObjectName:NSStringFromClass([self class])];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id object = [[self class] allocWithZone:zone];
    NSDictionary *attrMapDic = [self attributeMapDictionary];
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    while ((attributeName = [keyEnum nextObject])) {
        SEL getSel = NSSelectorFromString(attributeName);
        SEL sel = [object getSetterSelWithAttibuteName:attributeName];
        if ([self respondsToSelector:sel] &&
            [self respondsToSelector:getSel]) {
            
            NSMethodSignature *signature = nil;
            signature = [self methodSignatureForSelector:getSel];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:getSel];
            NSObject * __unsafe_unretained valueObj = nil;
            [invocation invoke];
            [invocation getReturnValue:&valueObj];
            
            [object performSelectorOnMainThread:sel
                                     withObject:valueObj
                                  waitUntilDone:TRUE];
        }
    }
    return object;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if( self = [super init] ){
        NSDictionary *attrMapDic = [self attributeMapDictionary];
        if (attrMapDic == nil) {
            return self;
        }
        NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
        id attributeName;
        while ((attributeName = [keyEnum nextObject])) {
            SEL sel = [self getSetterSelWithAttibuteName:attributeName];
            if ([self respondsToSelector:sel]) {
                id obj = [decoder decodeObjectForKey:attributeName];
                [self performSelectorOnMainThread:sel withObject:obj waitUntilDone:[NSThread isMainThread]];
            }
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSDictionary *attrMapDic = [self attributeMapDictionary];
    if (attrMapDic == nil) {
        return;
    }
    
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    
    while ((attributeName = [keyEnum nextObject])) {
        
        SEL getSel = NSSelectorFromString(attributeName);
        
        if ([self respondsToSelector:getSel]) {
            
            NSMethodSignature *signature = nil;
            signature = [self methodSignatureForSelector:getSel];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:getSel];
            NSObject * __unsafe_unretained valueObj = nil;
            [invocation invoke];
            [invocation getReturnValue:&valueObj];
            
            if (valueObj) {
                [encoder encodeObject:valueObj forKey:attributeName];
            }
        }
    }
}

#pragma mark - private methods
-(SEL)getSetterSelWithAttibuteName:(NSString*)attributeName
{
    NSString *capital = [[attributeName substringToIndex:1] uppercaseString];
    NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:",capital,[attributeName substringFromIndex:1]];
    return NSSelectorFromString(setterSelStr);
}

///////////////
-(BOOL)CheckPropForObject:(NSString*)propName forObject:(Class) class{
    unsigned int nCount = 0;
    objc_property_t *popertylist = class_copyPropertyList(class,&nCount);
    for (int i = 0; i < nCount; i++) {
        objc_property_t property = popertylist[i];
        NSString *s = [NSString stringWithUTF8String:property_getName(property)];
        if([propName compare:s]==NSOrderedSame)
            return YES;
    }
    return NO;
}
-(id)GetObjectForObjectName:(NSString*)objectName{
    return [[ NSClassFromString(objectName) alloc]init];
}
//将NSDictionary转换成指定的类
-(id)NSDictionaryToObject:(NSDictionary*)dictionary ObjectName:(NSString*)objectName{
    return [self NSDictionaryToObject:dictionary Object:[self GetObjectForObjectName:objectName]];
}
-(id)NSDictionaryToObject:(NSDictionary*)dictionary Object:(ITTBaseModelObject*)object{
    @try{
        NSDictionary *attriDic = [object attributeMapDictionary];
        NSArray *keys= [attriDic allKeys];
//        [dictionary allKeys];
        for (NSString *key in keys) {
            if ([key isEqualToString:@"sid"]) {
                
            }
            id value=[dictionary objectForKey:attriDic[key]];
            if([value isKindOfClass:[NSArray class]]){
                NSArray *arr=value;
                NSMutableArray *array=[[NSMutableArray alloc]init];
                if([object CheckPropForObject:key forObject:[object class]]){
                    [array addObjectsFromArray:arr];
                    [object setValue:array forKey:key];
                }
            }else if([value isKindOfClass:[NSDictionary class]]){
                Class proClass = NSClassFromString([object remove_:[object getPropertNameFrom:object properName:key]]);
                if([object CheckPropForObject:key forObject:[object class]] && !  [proClass isSubclassOfClass:[NSDictionary class]])
                {
                    NSString *s = [object getPropertNameFrom:object properName:key];
                    NSString *objectName = [object remove_:s];
                    [object setValue:[object NSDictionaryToObject:value ObjectName:objectName] forKey:key];
                }else if([object CheckPropForObject:key forObject:[object class]])
                {
                    [object setValue:value forKey:key];
                }
            }else{
                if([object CheckPropForObject:key forObject:[object class]])
                {
                SEL sel = [object getSetterSelWithAttibuteName:key];
//                    [object setValue:value forKey:key];
                    if([self respondsToSelector:sel])
                    {
                    [object performSelectorOnMainThread:sel
                                           withObject:value
                                        waitUntilDone:[NSThread isMainThread]];
                    }
                }
            }
        }
    }@catch (NSException* ex) {
        
        NSLog(@"%@",[ex reason]);
    }
    return object;
}
-(NSString*)getPropertNameFrom:(NSObject*)object properName:(NSString*)proper
{
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([object class], &propertyCount);
    NSString *properName = nil;
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        if ([[NSString stringWithUTF8String:name] isEqualToString:proper]) {
            const char * propertyAttributes = property_getAttributes(property);
            properName = [NSString stringWithUTF8String:propertyAttributes];
            break;
        }
    }
    free(properties);
    
    return properName;
//    NSString *str = nil;
//    u_int count;
//    Ivar *ivars = class_copyIvarList([self class],&count);
//    for (int i = 0; i <count ; i++)
//    {
//        const char* propertyName = ivar_getTypeEncoding(ivars[i]);
//       str = [NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding];
//    }
//    if (ivars) {
//        free(ivars);
//    }
//    return str;
}

-(NSString*)remove_:(NSString*)objectname{
    SubStringHelper *subhelper=[[SubStringHelper alloc]initWithSubString:@"\"" before:NO keepsubstring:NO NSStringCompareOptions:NSCaseInsensitiveSearch];
    SubStringHelper *subhelper2=[[SubStringHelper alloc]initWithSubString:@"\"" before:YES keepsubstring:NO NSStringCompareOptions:NSCaseInsensitiveSearch];
    return [self SubString:objectname withHelps:@[subhelper,subhelper2]];
}
-(NSString*)SubString:(NSString*) string withHelps:(NSArray*) subStringHelpers{
    @try {
        
        for (SubStringHelper* help in subStringHelpers) {
            
            NSRange range=[string rangeOfString:help.substring options:help
                           .CompareOptions];
            if(help.before)
            {
                if(help.keepsubstring){
                    string=[string substringToIndex:range.location+range.length];
                }else{
                    string=[string substringToIndex:range.location];
                }
            }else{
                if(help.keepsubstring){
                    string= [string substringFromIndex:range.location];
                }else{
                    string=[string substringFromIndex:range.location+range.length];
                }
            }
        }
        return string;
        
    }
    @catch (NSException *exception) {
        return string;
    }
    @finally {
        
    }
}
-(NSString*)removeLastS:(NSString*)objectname{
    SubStringHelper *subhelper=[[SubStringHelper alloc]initWithSubString:@"s" before:YES keepsubstring:NO NSStringCompareOptions:NSBackwardsSearch];
    return [self SubString:objectname withHelps:@[subhelper]];
}
///////////////
-(void)setAttributes:(NSDictionary*)dataDic
{
    NSDictionary *attrMapDic = [self attributeMapDictionary];
    if (attrMapDic == nil) {
        return;
    }
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    while ((attributeName = [keyEnum nextObject])) {
        SEL sel = [self getSetterSelWithAttibuteName:attributeName];
        if ([self respondsToSelector:sel]) {
            NSString *dataDicKey = attrMapDic[attributeName];
            NSString *value = nil;
            if ([[dataDic objectForKey:dataDicKey] isKindOfClass:[NSNumber class]]) {
                value = [[dataDic objectForKey:dataDicKey] stringValue];
            }
            else if([[dataDic objectForKey:dataDicKey] isKindOfClass:[NSNull class]]){
                value = nil;
            }
            else{
                value = [dataDic objectForKey:dataDicKey];
            }
            [self performSelectorOnMainThread:sel
                                   withObject:value
                                waitUntilDone:[NSThread isMainThread]];
        }
    }
}

/*!
 * get property names of object
 */
- (NSArray*)propertyNames
{
    NSMutableArray *propertyNames = [[NSMutableArray alloc] init];
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    return propertyNames;
}
/*!
 *	\returns a dictionary Key-Value pair by property and corresponding value.
 */
- (NSDictionary*)propertiesAndValuesDictionary
{
    NSMutableDictionary *propertiesValuesDic = [NSMutableDictionary dictionary];
    NSArray *properties = [self propertyNames];
    for (NSString *property in properties) {
        SEL getSel = NSSelectorFromString(property);
        if ([self respondsToSelector:getSel]) {
            NSMethodSignature *signature = nil;
            signature = [self methodSignatureForSelector:getSel];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:getSel];
            NSObject * __unsafe_unretained valueObj = nil;
            [invocation invoke];
            [invocation getReturnValue:&valueObj];
            //assign to @"" string
            if (!valueObj) {
                valueObj = @"";
            }
            propertiesValuesDic[property] = valueObj;
        }
    }
    return propertiesValuesDic;
}

@end
@implementation SubStringHelper
@synthesize substring,before,keepsubstring,CompareOptions;
-(id)initWithSubString:(NSString*) _substring before:(BOOL)_before keepsubstring:(BOOL)_keepsubstring  NSStringCompareOptions:(NSStringCompareOptions) CompareOption{
    if(self=[super init]){
        self.substring=_substring;
        self.before=_before;
        self.keepsubstring=_keepsubstring;
        self.CompareOptions=CompareOption;
    }
    
    return self;
}
@end
