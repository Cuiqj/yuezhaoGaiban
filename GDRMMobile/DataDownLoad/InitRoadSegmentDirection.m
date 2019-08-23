//
//  InitRoadSegmentDirection.m
//  YUNWUMobile
//
//  Created by admin on 2019/2/26.
//

#import "InitRoadSegmentDirection.h"

@implementation InitRoadSegmentDirection

- (void)downloadRoadSegmentDirection:(NSString *)orgID{
    WebServiceInit;
    [service downloadDataSet:@"select * from RoadSegmentDirection"];
//    [service downloadDataSet:[@"select * from RoadSegmentDirection where org_id = " stringByAppendingString:orgID]];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"RoadSegmentDirection" andInXMLString:webString];
}

@end
