//
//  InitUser.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitUser.h"
#import "UserInfo.h"

@implementation InitUser

- (void)downLoadUserInfo{
    WebServiceInit;
    [service downloadDataSet:@"select * from UserInfo"];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"UserInfo" andInXMLString:webString];
}

@end

@implementation InitOrgInfo

- (void)downLoadOrgInfo{
    WebServiceInit;
    [service downloadDataSet:@"select * from OrgInfo"];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"OrgInfo" andInXMLString:webString];
}
@end
