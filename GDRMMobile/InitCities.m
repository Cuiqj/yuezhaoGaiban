//
//  InitCities.m
//  GDRMMobile
//
//  Created by Sniper X on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitCities.h"
#import "TBXML.h"

@implementation InitCities

- (void)downloadCityCode{
    WebServiceInit;
    [service downloadDataSet:@"select * from CityCode"];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"CityCode" andInXMLString:webString];
}
@end
