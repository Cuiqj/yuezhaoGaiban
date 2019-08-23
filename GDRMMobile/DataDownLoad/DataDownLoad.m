//
//  DataDownLoad.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-22.
//
//

#import "DataDownLoad.h"
#import "AGAlertViewWithProgressbar.h"
//#import "AlertViewWithProgressbar.h"
#import "OrgInfo.h"
#import "InitCarCheckItems.h"
#import "InitRoadasset_checkitem.h"
//#import "OMGToast.h"

@interface DataDownLoad()
@property (nonatomic,retain) AGAlertViewWithProgressbar *progressView;
//@property (nonatomic,retain) AGAlertViewWithProgressbar.h *progressView;
@property (nonatomic,assign) NSInteger                parserCount;
@property (nonatomic,assign) NSInteger                currentParserCount;
/**
 *1下载成功
 *0下载失败
 *2正在等待前一个下载结束
 */
@property (nonatomic,assign) NSInteger stillParsing;

- (void)parserFinished:(NSNotification *)noti;
@end

@implementation DataDownLoad
@synthesize progressView       = _progressView;
@synthesize parserCount        = _parserCount;
@synthesize currentParserCount = _currentParserCount;
@synthesize stillParsing       = _stillParsing;

- (id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parserFinished:) name:@"ParserFinished" object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setProgressView:nil];
}

- (void)startDownLoad:(NSString *)orgID{
    if ([WebServiceHandler isServerReachable]) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        //self.progressView=[[AGAlertViewWithProgressbar alloc] initWithTitle:@"同步基础数据" message:@"正在下载，请稍候……" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        self.progressView=[[AGAlertViewWithProgressbar alloc] initWithTitle:@"同步基础数据" message:@"正在下载，请稍候……" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        MAINDISPATCH(^(void){
            [self.progressView show];
        });
        self.parserCount        = DOWNLOADCOUNT;
        self.currentParserCount = self.parserCount;
        @autoreleasepool {
            InitUser *initUser = [[InitUser alloc] init];
            [initUser downLoadUserInfo:orgID];
            WAITFORPARSER
            InitIconModel *initIcon = [[InitIconModel alloc] init];
            [initIcon downLoadIconModels:orgID];
            WAITFORPARSER
            InitProvince *initProvice = [[InitProvince alloc] init];
            [initProvice downloadProvince:orgID];
            WAITFORPARSER
            InitCities *initCities = [[InitCities alloc] init];
            [initCities downloadCityCode:orgID];
            WAITFORPARSER
            InitRoadSegment *initRoad = [[InitRoadSegment alloc] init];
            [initRoad downloadRoadSegment:orgID];
            
            WAITFORPARSER
            InitRoadAssetPrice *initRoadAssetPrice = [[InitRoadAssetPrice alloc] init];
            [initRoadAssetPrice downloadRoadAssetPrice:orgID];
            WAITFORPARSER
            InitInquireAnswerSentence *iias = [[InitInquireAnswerSentence alloc] init];
            [iias downloadInquireAnswerSentence:orgID];
            WAITFORPARSER
            InitInquireAskSentence *iiask = [[InitInquireAskSentence alloc] init];
            [iiask downloadInquireAskSentence:orgID];
            WAITFORPARSER
            InitCheckItemDetails *icid = [[InitCheckItemDetails alloc] init];
            [icid downloadCheckItemDetails:orgID];
            WAITFORPARSER
            InitCheckItems *icheckItems = [[InitCheckItems alloc] init];
            [icheckItems downloadCheckItems:orgID];

            WAITFORPARSER
            InitCheckType *iCheckType = [[InitCheckType alloc] init];
            [iCheckType downLoadCheckType:orgID];
//            WAITFORPARSER
//            InitRoadSegmentDirection * initRoadSegmentDirection = [[InitRoadSegmentDirection alloc] init];
//            [initRoadSegmentDirection downloadRoadSegmentDirection:orgID];
            
            WAITFORPARSER
            InitCheckHandle *iCheckHandle = [[InitCheckHandle alloc] init];
            [iCheckHandle downLoadCheckHandle:orgID];
            WAITFORPARSER
            InitCheckReason *iCheckReason = [[InitCheckReason alloc] init];
            [iCheckReason downLoadCheckReason:orgID];
            WAITFORPARSER
            InitCheckStatus *iCheckStatus = [[InitCheckStatus alloc] init];
            [iCheckStatus downLoadCheckStatus:orgID];
            WAITFORPARSER
            
            InitSystype *iSystype = [[InitSystype alloc] init];
            [iSystype downloadSysType:orgID];
            WAITFORPARSER
            InitLaws *iLaws = [[InitLaws alloc] init];
            [iLaws downLoadLaws:orgID];
            WAITFORPARSER
            InitLawItems *iLawItems = [[InitLawItems alloc] init];
            [iLawItems downloadLawItems:orgID];
            WAITFORPARSER
            InitMatchLaw *iMatchLaw = [[InitMatchLaw alloc] init];
            [iMatchLaw downloadMatchLaw:orgID];
            WAITFORPARSER
            InitMatchLawDetails *iMatchLawDetails = [[InitMatchLawDetails alloc] init];
            [iMatchLawDetails downloadMatchLawDetails:orgID];
            
            
            WAITFORPARSER
            InitFileCode *iFileCode = [[InitFileCode alloc] init];
            [iFileCode downLoadFileCode:orgID];
            WAITFORPARSER
            InitLawBreakingAction *iLawBreakingAction = [[InitLawBreakingAction alloc] init];
            [iLawBreakingAction downloadLawBreakingAction:orgID];
            WAITFORPARSER
            InitOrgInfo *iOrgInfo = [[InitOrgInfo alloc] init];
            [iOrgInfo downLoadOrgInfo:orgID];
            
//            WAITFORPARSER
//            InitBridge  *iBridge = [[InitBridge alloc] init];
//            [iBridge downLoadBridge:orgID];
//            WAITFORPARSER
//            InitMaintainPlan  *iMaintianPlan = [[InitMaintainPlan alloc] init];
//            [iMaintianPlan downMaintainPlan:orgID];
//            WAITFORPARSER
//
//            InitSfz *isfz = [[InitSfz alloc] init];
//            [isfz downLoadSfz:orgID];
//            WAITFORPARSER
//            InitZd *izd =[[InitZd alloc]init];
//            [izd downLoadZd:orgID];
//            WAITFORPARSER
//            InitServiceCheckItems *iservicesCheckItems=[[InitServiceCheckItems alloc]init];
//            [iservicesCheckItems downLoadServiceCheckItems:orgID];
//            WAITFORPARSER
//            InitServiceOrg *iservicesOrg=[[InitServiceOrg alloc]init];
//            [iservicesOrg downLoadServiceOrg:orgID];
//            WAITFORPARSER
//            InitCarCheckItems *iCarCheckItems=[[InitCarCheckItems alloc]init];
//            [iCarCheckItems downLoadCarCheckItems:orgID];
//            WAITFORPARSER
//
//            InitPersonnelClass * Personnelclass = [[InitPersonnelClass alloc] init];
//            [Personnelclass downloadPersonnelClass:orgID];
            
//            WAITFORPARSER              丈量沿海数据 表缺失数据
//            InitRoadasset_checkitem *iRoadasset_checkitem=[[InitRoadasset_checkitem alloc]init];
//            [iRoadasset_checkitem downLoadRoadasset_checkitem:orgID];
//            WAITFORPARSER     
//            InitBridgeCheckItem *iInitBridgeCheckItem=[[InitBridgeCheckItem alloc]init];
//            [iInitBridgeCheckItem downLoadBridgeCheckItem:orgID];
            
            
            extern NSString *my_org_id;
            //my_org_id=orgID;
            // OrgInfo *selectedorg = orgInfoForOrgID
            OrgInfo * selectedorg = [OrgInfo orgInfoForOrgID:orgID];
            //        NSArray *upLoadedDataArray = [NSClassFromString(upLoadedDataName) uploadArrayOfObject];
            //        for (id obj in upLoadedDataArray) {
            //            [obj setValue:@(YES) forKey:@"isuploaded"];
            //        }
            [selectedorg setValue:@(YES) forKey:@"isselected"];
        }
    }
}

- (void)parserFinished:(NSNotification *)noti{
//    下载成功一个表
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.progressView isVisible]) {
            self.currentParserCount=self.currentParserCount-1;
            [self.progressView setProgress:(int)(((float)(-self.currentParserCount+self.parserCount)/(float)self.parserCount)*100.0)];
            
            NSDictionary *info=[noti userInfo];
            
            NSString* success=[info objectForKey:@"success"];
            if ([success isEqualToString:@"0"]) {
                self.stillParsing = 0;
                NSString *dataModelName=[info objectForKey:@"dataModelName"];
                [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self.progressView hide];
                    [[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOADFINISHNOTI object:nil];
                    UIAlertView *finishAlert = [[UIAlertView alloc] initWithTitle:@"消息" message:[NSString stringWithFormat:@"%@下载出错,请仔细检查下载地址是否正确或者重新下载",dataModelName] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [finishAlert show];
                });
                return;
            }
            self.stillParsing = 1;
            if (self.currentParserCount==0) {
                [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self.progressView hide];
                    [[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOADFINISHNOTI object:nil];
                    UIAlertView *finishAlert = [[UIAlertView alloc] initWithTitle:@"消息" message:@"下载完毕" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [finishAlert show];
                });
            }
        }
    });
}
- (void)downLoadTimeOut{
    if ([self.progressView isVisible]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.stillParsing = 0;
            [self.progressView hide];
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *finishAlert = [[UIAlertView alloc]initWithTitle:@"消息" message:@"下载超时,请仔细检查网络设置或下载地址是否正确，之后请尝试重新下载" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [finishAlert show];
    });
}
- (void)downLoadUnkownError{
    if ([self.progressView isVisible]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.stillParsing = 0;
            [self.progressView hide];
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *finishAlert = [[UIAlertView alloc]initWithTitle:@"消息" message:@"下载出错，出现无知错误，请稍后重试,请仔细检查网络设置或下载地址是否正确，之后请尝试重新下载" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [finishAlert show];
    });
}
@end
