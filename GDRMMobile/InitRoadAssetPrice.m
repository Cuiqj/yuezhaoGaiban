//
//  InitRoadAssetPrice.m
//  GDRMMobile
//
//  Created by Sniper X on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitRoadAssetPrice.h"

@implementation InitRoadAssetPrice

- (void)downloadRoadAssetPrice{
    WebServiceInit;
    [service downloadDataSet:@"select * from RoadAssetPrice"];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"RoadAssetPrice" andInXMLString:webString];
}
@end
