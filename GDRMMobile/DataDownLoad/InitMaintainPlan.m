//
//  InitMaintianPlan.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/1/12.
//
//
#import "InitMaintainPlan.h"
//#import "UserInfo.h"
#import "TBXML.h"
@implementation InitMaintainPlan

- (void)downMaintainPlan:(NSString *)orgID{
    WebServiceInit;
    NSString * str = [NSString stringWithFormat:@"select * from MaintainPlan where org_id = %@ and is_finish = 0",orgID];
    [service downloadDataSet:str];
    //[service downloadDataSet:[@"select * from MaintianPlan where org_id = " stringByAppendingString:orgID]];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"MaintainPlan" andInXMLString:webString];
}

@end
