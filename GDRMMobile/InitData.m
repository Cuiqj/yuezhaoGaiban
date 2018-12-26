//
//  InitData.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-10-9.
//
//

#import "InitData.h"

@implementation InitData

- (void)getWebServiceReturnString:(NSString *)webString forWebService:(NSString *)serviceName{
    NSDictionary *userInfo = [self xmlParser:webString];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ParserFinished" object:nil userInfo:userInfo];
}

- (NSDictionary *)autoParserForDataModel:(NSString *)dataModelName andInXMLString:(NSString *)xmlString{
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithObject:dataModelName forKey:@"dataModelName"];
    [userinfo setObject:@"0" forKey:@"success"];
    
    [[AppDelegate App] clearEntityForName:dataModelName];
    NSError *error;
    TBXML *tbxml=[TBXML newTBXMLWithXMLString:xmlString error:&error];
    if (!error) {
        TBXMLElement *root=tbxml.rootXMLElement;
        if (!root) {
            return userinfo;
        }
        TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
        if (!rf) {
            return userinfo;
        }
        TBXMLElement *r1 = [TBXML childElementNamed:@"DownloadDataSetResponse" parentElement:rf];
        if(!r1){
            return userinfo;
        }
        TBXMLElement *r2 = [TBXML childElementNamed:@"DownloadDataSetResult" parentElement:r1];
        if(!r2){
            return userinfo;
        }
        TBXMLElement *r3 = [TBXML childElementNamed:@"diffgr:diffgram" parentElement:r2];
        if(!r3){
            return userinfo;
        }
        TBXMLElement *r4 = [TBXML childElementNamed:@"NewDataSet" parentElement:r3];
        if (!r4) {
            return userinfo;
        }
        TBXMLElement *table=r4->firstChild;
        while (table) {
            @autoreleasepool {
                NSManagedObjectContext *context = [[AppDelegate App] managedObjectContext];
                NSEntityDescription *entity = [NSEntityDescription entityForName:dataModelName inManagedObjectContext:context];
                id obj = [[NSClassFromString(dataModelName) alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
                TBXMLElement *tableChild = table->firstChild;
                while (tableChild) {
                    @autoreleasepool {
                        NSString *elementName = [[TBXML elementName:tableChild] lowercaseString];
                        if ([elementName isEqualToString:@"id"]) {
                            elementName = @"myid";
                        }
                        if ([obj respondsToSelector:NSSelectorFromString(elementName)]) {
                            NSDictionary *attributes = [entity attributesByName];
                            NSAttributeDescription *attriDesc = [attributes objectForKey:elementName];
                            switch (attriDesc.attributeType) {
                                case NSStringAttributeType:
                                    [obj setValue:[TBXML textForElement:tableChild] forKey:elementName];
                                    break;
                                case NSBooleanAttributeType:
                                    [obj setValue:@([TBXML textForElement:tableChild].boolValue) forKey:elementName];
                                    break;
                                case NSFloatAttributeType:
                                    [obj setValue:@([TBXML textForElement:tableChild].floatValue) forKey:elementName];
                                    break;
                                case NSDoubleAttributeType:
                                    [obj setValue:@([TBXML textForElement:tableChild].doubleValue) forKey:elementName];
                                    break;
                                case NSDateAttributeType:{
                                    NSString *dateString = [TBXML textForElement:tableChild];
                                    dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@""];
                                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HHmmss'.'SSSSSSSZ"];
                                    [obj setValue:[dateFormatter dateFromString:dateString] forKey:elementName];
                                }
                                    break;
                                case NSInteger16AttributeType:
                                case NSInteger32AttributeType:
                                case NSInteger64AttributeType:
                                    [obj setValue:@([TBXML textForElement:tableChild].integerValue) forKey:elementName];
                                    break;
                                default:
                                    break;
                            }
                            
                        }
                    }
                    tableChild = tableChild->nextSibling;
                }
                [[AppDelegate App] saveContext];
                table = table->nextSibling;
            }
        }
        [userinfo setObject:@"1" forKey:@"success"];
        return userinfo;
    }
    return userinfo;
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return nil;
};
- (void)requestTimeOut{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DownLoadTimeOut" object:nil userInfo:nil];
}
- (void)requestUnkownError{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DownLoadUnkownError" object:nil userInfo:nil];
}

@end