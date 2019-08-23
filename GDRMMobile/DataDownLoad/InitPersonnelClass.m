//
//  InitPersonnelClass.m
//  YUNWUMobile
//
//  Created by admin on 2018/11/14.
//

#import "InitPersonnelClass.h"

@implementation InitPersonnelClass



- (void)downloadPersonnelClass:(NSString *)orgID{
    WebServiceInit;
    [service downloadDataSet:[NSString stringWithFormat: @"select * from PersonnelClass where org_id=%@ ",orgID]];
}
- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"PersonnelClass" andInXMLString:webString];
}
@end
