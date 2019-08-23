//
//  InitSystype.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-10.
//
//

#import "InitSystype.h"

@implementation InitSystype
- (void)downloadSysType:(NSString *)orgID{
    WebServiceInit;
    //[service downloadDataSet:@"select * from SysType" orgid:orgID];
    [service downloadDataSet:[@"select * from SysType where org_id = " stringByAppendingString:orgID]];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"Systype" andInXMLString:webString];
}
 
@end
