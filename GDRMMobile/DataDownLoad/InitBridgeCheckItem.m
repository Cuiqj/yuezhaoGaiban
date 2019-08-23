//
//  InitBridgeCheckItem.m
//  YUNWUMobile
//
//  Created by admin on 2018/7/2.
//

#import "InitBridgeCheckItem.h"

@implementation InitBridgeCheckItem
- (void)downLoadBridgeCheckItem:(NSString *)orgID{
    WebServiceInit;
    //[service downloadDataSet:@"select * from UserInfo" orgid:orgID];
    [service downloadDataSet:[NSString stringWithFormat: @"select * from BridgeCheckItem where org_id=%@ ",orgID]];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"BridgeCheckItem" andInXMLString:webString];
}
@end
