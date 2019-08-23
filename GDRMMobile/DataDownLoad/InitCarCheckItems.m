//
//  InitCarCheckItems.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/10.
//
//

#import "InitCarCheckItems.h"
#import "ServiceOrg.h"
@implementation InitCarCheckItems
- (void)downLoadCarCheckItems:(NSString *)orgID {
    WebServiceInit;
    //[service downloadDataSet:@"select * from UserInfo" orgid:orgID];
    [service downloadDataSet:@"select * from CarCheckItems"  ];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"CarCheckItems" andInXMLString:webString];
}
@end
