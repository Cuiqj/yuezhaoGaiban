//
//  InitUser.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitProvince.h"
#import "TBXML.h"

#import "Provinces.h"

@implementation InitProvince

- (void)downloadProvince:(NSString *)orgID{
    WebServiceInit;
    [service downloadDataSet:@"select * from Provinces"];
    //[service downloadDataSet:[@"select * from Provinces where org_id = " stringByAppendingString:orgID]];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"Provinces" andInXMLString:webString];
}


@end
