//
//  InitRoadSegment.m
//  GDRMMobile
//
//  Created by Sniper X on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitRoadSegment.h"
#import "RoadSegment.h"

@implementation InitRoadSegment

- (void)downloadRoadSegment{
    WebServiceInit;
    [service downloadDataSet:@"select * from RoadSegment"];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"RoadSegment" andInXMLString:webString];
}

@end
