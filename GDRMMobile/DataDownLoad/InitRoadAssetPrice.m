//
//  InitRoadAssetPrice.m
//  GDRMMobile
//
//  Created by Sniper X on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitRoadAssetPrice.h"

@implementation InitRoadAssetPrice

- (void)downloadRoadAssetPrice:(NSString *)orgID{
    WebServiceInit;
    [service downloadDataSet:@"select * from RoadAssetPrice"];
    //[service downloadDataSet:[@"select * from RoadAssetPrice where organization_id = " stringByAppendingString:orgID]];

}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"RoadAssetPrice" andInXMLString:webString];
}
@end
