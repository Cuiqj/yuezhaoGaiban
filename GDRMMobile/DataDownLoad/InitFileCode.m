//
//  InitFileCode.m
//  GDRMMobile
//
//  Created by 高 峰 on 13-7-8.
//
//

#import "InitFileCode.h"
#import "TBXML.h"

@implementation InitFileCode

-(void)downLoadFileCode:(NSString *)orgID{
    WebServiceInit;
    [service downloadDataSet:[@"select * from FileCode where org_id = " stringByAppendingString:orgID]];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"FileCode" andInXMLString:webString];
}

@end
