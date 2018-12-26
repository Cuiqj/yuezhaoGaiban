//
//  InitData.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-10-9.
//
//

#define WebServiceInit WebServiceHandler *service=[[WebServiceHandler alloc] init];\
                        service.delegate=self


#import <Foundation/Foundation.h>
#import "WebServiceHandler.h"
#import "TBXML.h"

@interface InitData : NSObject<WebServiceReturnString>
- (NSDictionary *)xmlParser:(NSString *)webString;
- (NSDictionary *)autoParserForDataModel:(NSString *)dataModelName andInXMLString:(NSString *)xmlString;
- (void)requestTimeOut;
- (void)requestUnkownError;
@end
