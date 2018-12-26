//
//  DataDownLoad.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-22.
//
//

#import <Foundation/Foundation.h>

#import "InitUser.h"
#import "InitIconModel.h"
#import "InitProvince.h"
#import "InitCities.h"
#import "InitRoadSegment.h"
#import "InitRoadAssetPrice.h"
#import "InitInquireAskSentence.h"
#import "InitInquireAnswerSentence.h"
#import "InitSystype.h"
#import "InitInspectionCheck.h"
#import "InitLaws.h"
#import "InitFileCode.h"

#define DOWNLOADCOUNT 22
#define DOWNLOADFINISHNOTI @"DownLoadWorkFinished"

#define WAITFORPARSER   self.stillParsing = 2;\
                        while (self.stillParsing == 2) {\
                            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];\
                        }\
                        if(self.stillParsing == 0){\
                            return;\
                        }\

@interface DataDownLoad : NSObject

@property (nonatomic, retain) NSString *currentOrgID;

- (id)init;
- (void)startDownLoad;
- (void)downLoadTimeOut;
- (void)downLoadUnkownError;

@end
