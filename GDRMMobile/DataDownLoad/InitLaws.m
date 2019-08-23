//
//  InitLaws.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import "InitLaws.h"

@implementation InitLaws
- (void)downLoadLaws:(NSString *)orgID{
    WebServiceInit;
    [service downloadDataSet:@"select * from Laws" orgid:orgID];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"Laws" andInXMLString:webString];
}
@end

@implementation InitLawBreakingAction

- (void)downloadLawBreakingAction:(NSString *)orgID{
    WebServiceInit;
    [service downloadDataSet:@"select * from LawbreakingAction" orgid:orgID];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"LawbreakingAction" andInXMLString:webString];
}
@end

@implementation InitLawItems

- (void)downloadLawItems:(NSString *)orgID{
    WebServiceInit;
    [service downloadDataSet:@"select * from LawItems" orgid:orgID];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"LawItems" andInXMLString:webString];
}
@end

@implementation InitMatchLaw

- (void)downloadMatchLaw:(NSString *)orgID{
    WebServiceInit;
    [service downloadDataSet:@"select * from MatchLaw" orgid:orgID];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"MatchLaw" andInXMLString:webString];
}
@end

@implementation InitMatchLawDetails

- (void)downloadMatchLawDetails:(NSString *)orgID{
    WebServiceInit;
    [service downloadDataSet:@"select * from MatchLawDetails" orgid:orgID];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"MatchLawDetails" andInXMLString:webString];
}
@end