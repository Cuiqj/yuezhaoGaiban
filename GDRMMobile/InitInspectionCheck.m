//
//  InitInspectionCheck.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-23.
//
//

#import "InitInspectionCheck.h"

@implementation InitCheckType

- (void)downLoadCheckType{
    WebServiceInit;
    [service downloadDataSet:@"select * from CheckType"];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"CheckType" andInXMLString:webString];
}
@end


#pragma mark -

@implementation InitCheckReason

- (void)downLoadCheckReason{
    WebServiceInit;
    [service downloadDataSet:@"select * from Reason"];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"CheckReason" andInXMLString:webString];

}
@end


#pragma mark -

@implementation InitCheckHandle

- (void)downLoadCheckHandle{
    WebServiceInit;
    [service downloadDataSet:@"select * from Handle"];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"CheckHandle" andInXMLString:webString];
}

@end


#pragma mark -

@implementation InitCheckStatus

- (void)downLoadCheckStatus{
    WebServiceInit;
    [service downloadDataSet:@"select * from Status"];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"CheckStatus" andInXMLString:webString];
}
@end

@implementation InitCheckItems

- (void)downloadCheckItems{
    WebServiceInit;
    [service downloadDataSet:@"select * from CheckItems"];
}
- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"CheckItems" andInXMLString:webString];
}
@end

@implementation InitCheckItemDetails

- (void)downloadCheckItemDetails{
    WebServiceInit;
    [service downloadDataSet:@"select * from CheckItemDetails"];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"CheckItemDetails" andInXMLString:webString];
}

@end
