//
//  InitShoufz.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/3/10.
//
//

#import "InitShoufz.h"
//#import "Sfz.h"
//#import "Zd.h"
@implementation InitSfz

- (void)downLoadSfz:(NSString *)orgID{
    WebServiceInit;
    //[service downloadDataSet:@"select * from UserInfo" orgid:orgID];
    [service downloadDataSet:[@"select sfz.* from sfz,roadsegment where sfz.roadsegment_id =roadsegment.id and roadsegment.organization_id= " stringByAppendingString:orgID]];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"Sfz" andInXMLString:webString];
}

@end

@implementation InitZd

- (void)downLoadZd:(NSString *)orgID{
    WebServiceInit;
    //[service downloadDataSet:@"select * from OrgInfo" orgid:orgID];
     [service downloadDataSet:@"select * from Zd  "];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"Zd" andInXMLString:webString];
}
@end
