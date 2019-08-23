//
//  InitServiceCheckItems.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/5/3.
//
//

#import "InitServiceCheckItems.h"
//#import "ServiceCheckItems.h"
@implementation InitServiceCheckItems

- (void)downLoadServiceCheckItems:(NSString *)orgID {
    WebServiceInit;
    //[service downloadDataSet:@"select * from UserInfo" orgid:orgID];
    [service downloadDataSet:@"select * from ServiceCheckItems "  ];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"ServiceCheckItems" andInXMLString:webString];
}

@end
