//
//  DataUpLoad.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import "DataUpLoad.h"
#import "AGAlertViewWithProgressbar.h"
#import "TBXML.h"
#import "UploadRecord.h"
#import "CasePhoto.h"

//所需上传的表名称
//modify by lxm 2013.05.13
static NSString *dataNameArray[UPLOADCOUNT]={@"Project",@"Task",@"AtonementNotice",@"CaseDeformation",@"CaseInfo",@"CaseInquire",@"CaseProveInfo",@"CaseServiceFiles",@"CaseServiceReceipt",@"Citizen",@"RoadWayClosed",@"Inspection",@"InspectionCheck",@"InspectionOutCheck",@"InspectionPath",@"InspectionRecord",@"ParkingNode",@"CaseMap",@"ConstructionChangeBack",@"TrafficRecord",@"InspectionConstruction",@"CasePhoto"};

//static NSString *dataNameArray[UPLOADCOUNT]={@"CaseMap"};

@interface DataUpLoad()
@property (nonatomic,assign) NSInteger currentWorkIndex;
@property (nonatomic,retain) AGAlertViewWithProgressbar *progressView;
@property (nonatomic,retain) UploadRecord* uploadedRecord;
- (void)uploadDataAtIndex:(NSInteger)index;
- (void)uploadFinished;
@end

@implementation DataUpLoad
@synthesize currentWorkIndex = _currentWorkIndex;
@synthesize progressView = _progressView;
@synthesize uploadedRecord = _uploadedRecord;

- (void)uploadData{
    self.progressView=[[AGAlertViewWithProgressbar alloc] initWithTitle:@"上传业务数据" message:@"正在上传，请稍候……" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    MAINDISPATCH(^(void){
        [self.progressView show];
    });
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self uploadDataAtIndex:self.currentWorkIndex];
}

- (id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadFinished) name:UPLOADFINISH object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadFinishedWithObject:) name:UPLOADFINISHWITHOBJECT object:nil];
        self.currentWorkIndex = 0;
        _uploadedRecord = [[UploadRecord alloc] init];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setProgressView:nil];
}


- (void)uploadDataAtIndex:(NSInteger)index{
    NSString *currentDataName = dataNameArray[index];

    NSArray *dataArray = [NSClassFromString(currentDataName) uploadArrayOfObject];
    if (dataArray.count > 0) {
        if ([currentDataName isEqualToString:@"CasePhoto"]) {
            NSString *dataXML = @"";
            NSInteger dataArrayCount = [dataArray count];
            for (NSInteger i = 0;i < dataArrayCount;i++) {
                id obj = [dataArray objectAtIndex:i];
                CasePhoto *photo = (CasePhoto *)obj;
                if(photo.proveinfo_id == nil || [photo.proveinfo_id isEmpty]) continue;
                dataXML = @"";
                dataXML = [dataXML stringByAppendingString:[obj dataXMLStringForCasePhoto]];
                [_uploadedRecord addUploadedRecord:currentDataName WitdData:obj];
                WebServiceHandler *service=[[WebServiceHandler alloc] init];
                service.delegate=self;
                [service uploadPhotot:dataXML updatedObject:photo];
            }
        }else{
            NSString *dataTypeString = [NSClassFromString(currentDataName) complexTypeString];
            NSString *dataXML = @"";
            for (id obj in dataArray) {
                dataXML = [dataXML stringByAppendingString:[obj dataXMLString]];
                [_uploadedRecord addUploadedRecord:currentDataName WitdData:obj];
            }
            if (![dataXML isEmpty]) {
                NSString *uploadXML = [[NSString alloc] initWithFormat:@"%@\n"
                                       "<diffgr:diffgram xmlns:msdata=\"urn:schemas-microsoft-com:xml-msdata\" xmlns:diffgr=\"urn:schemas-microsoft-com:xml-diffgram-v1\">\n"
                                       "   <NewDataSet xmlns=\"\">\n"
                                       "       %@\n"
                                       "   </NewDataSet>\n"
                                       "</diffgr:diffgram>",dataTypeString,dataXML];
                
                WebServiceHandler *service=[[WebServiceHandler alloc] init];
                service.delegate=self;
                NSLog(@"%@\n%@", currentDataName, uploadXML);
                [service uploadDataSet:uploadXML];
            }
        }
    } else {
        self.currentWorkIndex += 1;
        [self.progressView setProgress:(int)(((float)(self.currentWorkIndex)/(float)UPLOADCOUNT)*100.0)];
        if (self.currentWorkIndex < UPLOADCOUNT) {
            [self uploadDataAtIndex:self.currentWorkIndex];
        } else {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.progressView hide];
                UIAlertView *finishAlert = [[UIAlertView alloc] initWithTitle:@"消息" message:@"上传完毕" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [finishAlert show];
            });
        }
    }
}

- (void)uploadFinished{
    NSString *upLoadedDataName = dataNameArray[self.currentWorkIndex];
    NSArray *upLoadedDataArray = [NSClassFromString(upLoadedDataName) uploadArrayOfObject];
    for (id obj in upLoadedDataArray) {
        [obj setValue:@(YES) forKey:@"isuploaded"];
    }
    self.currentWorkIndex += 1;
    
    [self.progressView setProgress:(int)(((float)(self.currentWorkIndex)/(float)UPLOADCOUNT)*100.0)];
    if (self.currentWorkIndex < UPLOADCOUNT) {
        [self uploadDataAtIndex:self.currentWorkIndex];
    } else {
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.progressView hide];
            UIAlertView *finishAlert = [[UIAlertView alloc] initWithTitle:@"消息" message:@"上传完毕" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [finishAlert show];
        });
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }
    [_uploadedRecord didWriteDB];
}
- (void)uploadFinishedWithObject:(NSNotification *)notification{
    NSString *upLoadedDataName = dataNameArray[self.currentWorkIndex];
    NSArray *upLoadedDataArray = [NSClassFromString(upLoadedDataName) uploadArrayOfObject];
    NSInteger upLoadedCount = 0;
    NSInteger arrayCount = [upLoadedDataArray count];
    for (NSInteger i = 0; i < arrayCount; i++) {
        if([notification.userInfo objectForKey:@"updatedObject"]== [upLoadedDataArray objectAtIndex:i]){
            [[upLoadedDataArray objectAtIndex:i] setValue:@(YES) forKey:@"isuploaded"];
        }
        NSNumber* isuploaded = (NSNumber*)[[upLoadedDataArray objectAtIndex:i] valueForKey:@"isuploaded"];
        if([isuploaded intValue] == 1){
            upLoadedCount++;
        }
        
        
    }
    if (upLoadedCount >= arrayCount) {
        self.currentWorkIndex += 1;
        [self.progressView setProgress:(int)(((float)(self.currentWorkIndex)/(float)UPLOADCOUNT)*100.0)];
        if (self.currentWorkIndex < UPLOADCOUNT) {
            [self uploadDataAtIndex:self.currentWorkIndex];
        } else {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.progressView hide];
                UIAlertView *finishAlert = [[UIAlertView alloc] initWithTitle:@"消息" message:@"上传完毕" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [finishAlert show];
            });
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        }
        [_uploadedRecord didWriteDB];
    }
    

}
- (void)getWebServiceReturnString:(NSString *)webString forWebService:(NSString *)serviceName{
    BOOL success = NO;
    TBXML *xml = [TBXML newTBXMLWithXMLString:webString error:nil];
    TBXMLElement *root = [xml rootXMLElement];
    TBXMLElement *r1 = root->firstChild;
    TBXMLElement *r2 = r1->firstChild;
    TBXMLElement *r3 = r2->firstChild;
    if (r3) {
        NSString *outString = [TBXML textForElement:r3];
        if (outString.boolValue) {
            success = YES;
        }
    }
    if (success) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UPLOADFINISH object:nil];
    } else {
        NSString *upLoadedDataName = dataNameArray[self.currentWorkIndex];
        NSString *message = [[NSString alloc] initWithFormat:@"上传%@出现错误",upLoadedDataName];
        NSLog(@"ERROR!:%@\n%@",upLoadedDataName, webString);
        [self.progressView setMessage:message];
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.progressView hide];
        });
    }
}
- (void)getWebServiceReturnString:(NSString *)webString forWebService:(NSString *)serviceName updatedObject:(id)updatedObject{
    BOOL success = NO;
    TBXML *xml = [TBXML newTBXMLWithXMLString:webString error:nil];
    TBXMLElement *root = [xml rootXMLElement];
    TBXMLElement *r1 = root->firstChild;
    TBXMLElement *r2 = r1->firstChild;
    TBXMLElement *r3 = r2->firstChild;
    if (r3) {
        NSString *outString = [TBXML textForElement:r3];
        if (outString.boolValue) {
            success = YES;
        }
    }
    if (success) {
        NSDictionary *userInfo = @{@"updatedObject":updatedObject};
        [[NSNotificationCenter defaultCenter] postNotificationName:UPLOADFINISHWITHOBJECT object:nil userInfo:userInfo];
    } else {
        NSString *upLoadedDataName = dataNameArray[self.currentWorkIndex];
        NSString *message = [[NSString alloc] initWithFormat:@"上传%@出现错误",upLoadedDataName];
        NSLog(@"ERROR!:%@\n%@",upLoadedDataName, webString);
        [self.progressView setMessage:message];
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.progressView hide];
        });
    }
}
- (void)requestTimeOut{
    if (self.progressView.isVisible) {
        [self.progressView setMessage:@"网络连接超时，请检查网络连接是否正常。"];
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.progressView hide];
        });
    }
}

- (void)requestUnkownError{
    if (self.progressView.isVisible) {
        [self.progressView setMessage:@"网络连接错误，请检查网络连接或服务器地址设置。"];
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.progressView hide];
        });
    }
}
@end
