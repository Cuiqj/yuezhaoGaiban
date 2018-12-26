//
//  InitInquireAskSentence.m
//  GDRMMobile
//
//  Created by Sniper X on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitInquireAskSentence.h"


@implementation InitInquireAskSentence
- (void)downloadInquireAskSentence{
    WebServiceInit;
    [service downloadDataSet:@"select * from InquireAskSentence where case_type = '赔补偿'"];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"InquireAskSentence" andInXMLString:webString];
}
 
@end
