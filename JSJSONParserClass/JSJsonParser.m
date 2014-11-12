//
//  JSJsonParser.m
//  DemoWebService
//
//  Created by jignesh agola on 30/10/14.
//  Copyright (c) 2014 jignesh agola. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN

#import "JSJsonParser.h"
#import <objc/runtime.h>


@implementation JSJsonParser
-(id)parseJson:(id)jsonObject andClassName:(Class )className{
    
    
    id baseObject = [self makeObjectOfClass:className];
    
    NSArray *propertyArray = [self getPropertyNamesForClass:className];
    
    for (NSString *propertyName in propertyArray ) {
        
        Class propertyClassType = [self getClassFromProertyName:propertyName forObject:className];
        
        if ((propertyClassType == [NSString class] || propertyClassType == [NSNumber class]) && [jsonObject isKindOfClass:[NSDictionary class]]) {
            
            id value;
            @try {
                value = [jsonObject objectForKey:propertyName];
            }
            @catch (NSException *exception) {
                NSLog(@"Name missmatch");
            }
            
            [self setPropertyWithPropertyName:propertyName value:value andForClass:baseObject];
        }
        else if ((propertyClassType == [NSArray class]) || (propertyClassType == [NSMutableArray class])) {
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [self setPropertyWithPropertyName:propertyName value:array andForClass:baseObject];
            NSArray *jsonArray = [jsonObject objectForKey:propertyName];
            for (NSDictionary *dict in jsonArray) {
                id object = [self parseJson:dict andClassName:NSClassFromString(propertyName)];
                [array addObject:object];
            }
            
        }
        else
        {
            id dataObj = [jsonObject objectForKey:propertyName];
            id tempBaseObject = baseObject;
            id childObj = [self parseJson:dataObj andClassName:propertyClassType];
            [self setPropertyWithPropertyName:propertyName value:childObj andForClass:tempBaseObject];
        }
    }
    return baseObject;
}

-(id)getArrayparseJson:(id)jsonObject andClassName:(Class )className{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in jsonObject) {
         id object =    [self parseJson:dict andClassName:className];
        [array addObject:object];
    }
    return array;
}

-(Class )getClassFromProertyName:(NSString *)propertyName forObject:(Class)className{
    
    // Get Class of property to be populated.
    Class propertyClass = nil;
    objc_property_t property = class_getProperty(className, [propertyName UTF8String]);
    NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@","];
    if (splitPropertyAttributes.count > 0)
    {
        
        NSString *encodeType = splitPropertyAttributes[0];
        NSArray *splitEncodeType = [encodeType componentsSeparatedByString:@"\""];
        NSString *className = splitEncodeType[1];
        propertyClass = NSClassFromString(className);
    }
    return propertyClass;
}

-(NSMutableArray *)getPropertyNamesForClass:(Class )className{
    
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList(className, &propertyCount);
        
    NSMutableArray * propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        NSString *nameString = [NSString stringWithUTF8String:name];
        [propertyNames addObject:nameString];
        
    }
    free(properties);

    return propertyNames;
}
- (id)makeObjectOfClass:(Class)classType{
    return [[classType alloc] init];
}
-(void)setPropertyWithPropertyName:(NSString *)propertyName value:(id)value andForClass:(id)classObject {
    [classObject setValue:value forKey:propertyName];
}
@end
