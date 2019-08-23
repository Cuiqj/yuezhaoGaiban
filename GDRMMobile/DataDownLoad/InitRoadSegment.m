//
//  InitRoadSegment.m
//  GDRMMobile
//
//  Created by Sniper X on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitRoadSegment.h"
#import "TBXML.h"
//#import "RoadSegment.h"

@implementation InitRoadSegment

- (void)downloadRoadSegment:(NSString *)orgID{
    WebServiceInit;
    //[service downloadDataSet:@"select * from RoadSegment"orgid:orgID];
     [service downloadDataSet:[@"select * from RoadSegment where org_id = " stringByAppendingString:orgID]];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"RoadSegment" andInXMLString:webString];
}

@end
