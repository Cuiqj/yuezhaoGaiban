//
//  InitSystype.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-10.
//
//

#import "InitSystype.h"

@implementation InitSystype
- (void)downloadSysType{
    WebServiceInit;
    [service downloadDataSet:@"select * from SysType"];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"Systype" andInXMLString:webString];
}
 
@end
