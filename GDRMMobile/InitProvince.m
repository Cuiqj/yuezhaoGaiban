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

- (void)downloadProvince{
    WebServiceInit;
    [service downloadDataSet:@"select * from Provinces"];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"Provinces" andInXMLString:webString];
}


@end
