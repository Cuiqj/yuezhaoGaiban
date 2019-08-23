//
//  InitServiceOrg.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/5/3.
//
//

#import "InitServiceOrg.h"
//#import "ServiceOrg.h"
@implementation InitServiceOrg

- (void)downLoadServiceOrg:(NSString *)orgID {
    WebServiceInit;
    //[service downloadDataSet:@"select * from UserInfo" orgid:orgID];
    [service downloadDataSet:@"select *from ServiceOrg "  ];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"ServiceOrg" andInXMLString:webString];
}

@end
