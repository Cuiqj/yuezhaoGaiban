//
//  InitInquireAnswerSentence.m
//  GDRMMobile
//
//  Created by Sniper X on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitInquireAnswerSentence.h"
#import "TBXML.h"

#import "InquireAnswerSentence.h"

@implementation InitInquireAnswerSentence
- (void)downloadInquireAnswerSentence:(NSString *)orgID{
    WebServiceInit;
    [service downloadDataSet:@"select * from InquireAnswerSentence"];
    //[service downloadDataSet:[@"select * from RoadAssetPrice where organization_id = " stringByAppendingString:orgID]];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"InquireAnswerSentence" andInXMLString:webString];
}
@end
