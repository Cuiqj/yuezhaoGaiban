//
//  InitRoadasset_checkitem.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/13.
//
//

#import "InitRoadasset_checkitem.h"

@implementation InitRoadasset_checkitem
-(void)downLoadRoadasset_checkitem:(NSString *)orgID;{
    WebServiceInit;
    //[service downloadDataSet:@"select * from UserInfo" orgid:orgID];
    [service downloadDataSet:[NSString stringWithFormat: @"select * from Roadasset_checkitem where org_id=%@ ",orgID  ]];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"Roadasset_checkitem" andInXMLString:webString];
}
@end
