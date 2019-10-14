//
//  ServerSettingController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataSyncController.h"
#import "LCNetworking.h"


@interface  DataSyncController()
@property (retain, nonatomic) DataDownLoad *dataDownLoader;
@property (retain, nonatomic) DataUpLoad *dataUploader;
- (void)upLoadFinished;
- (void)downLoadFinished;
@end

@implementation DataSyncController
@synthesize uibuttonInit = _uibuttonInit;
@synthesize uibuttonReset = _uibuttonReset;
@synthesize uibuttonUpload = _uibuttonUpload;
@synthesize dataDownLoader = _dataDownLoader;
@synthesize dataUploader = _dataUploader;

- (DataUpLoad *)dataUploader{
    _dataUploader = nil;
    if (_dataUploader == nil) {
        _dataUploader = [[DataUpLoad alloc] init];
    }
    return _dataUploader;
}


- (DataDownLoad *)dataDownLoader{
    _dataDownLoader = nil;
    if (_dataDownLoader == nil) {
        _dataDownLoader = [[DataDownLoad alloc] init];
    }
    return _dataDownLoader;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [self setDataDownLoader:nil];
    [self setDataUploader:nil];
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{

	self.versionName.text = VERSION_NAME;
	self.versionTime.text = VERSION_TIME;
    NSString *imagePath=[[NSBundle mainBundle] pathForResource:@"小按钮" ofType:@"png"];
    UIImage *btnImage=[[UIImage imageWithContentsOfFile:imagePath] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.uibuttonInit setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.uibuttonReset setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.uibuttonUpload setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.uibuttonUpdateVersion setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.uibuttonResetForm setBackgroundImage:btnImage forState:UIControlStateNormal];
    imagePath=[[NSBundle mainBundle] pathForResource:@"服务器参数设置 -bg" ofType:@"png"];
    self.view.layer.contents=(id)[[UIImage imageWithContentsOfFile:imagePath] CGImage];

    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"设置服务器参数(请不要随意修改)"]];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(8, 7)];
    [_setServerBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
    
    [super viewDidLoad];
}


- (void)viewDidUnload
{

    [self setUibuttonInit:nil];
    [self setUibuttonReset:nil];
	[self setUibuttonUpload:nil];
    [self setDataDownLoader:nil];
    [self setDataUploader:nil];
    [self setSetServerBtn:nil];
    [self setVersionName:nil];
    [self setVersionTime:nil];
    [self setUibuttonResetForm:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


- (IBAction)btnInitData:(id)sender {
    NSString * orgID = [[NSUserDefaults standardUserDefaults]objectForKey:ORGKEY];
    [self.dataDownLoader startDownLoad:orgID];
}

- (IBAction)btnUpLoadData:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString *inspectionID=[[NSUserDefaults standardUserDefaults] valueForKey:INSPECTIONKEY];
    if (![inspectionID isEmpty] && inspectionID!=nil) {
        void(^ShowAlert)(void)=^(void){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"当前还有未完成的巡查，请先交班再上传业务数据。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        };
        MAINDISPATCH(ShowAlert);
    } else {
        if ([WebServiceHandler isServerReachable]) {
            [self.dataUploader uploadData];
        }
    }
}


- (void)downLoadFinished{
    self.dataDownLoader = nil;
}

- (void)upLoadFinished{
    self.dataUploader = nil;
}

- (IBAction)btnUser:(id)sender {
    //初始化使用机内文书格式设置
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *plistFileName = @"Settings.plist";
    NSString *plistPath = [libraryDirectory stringByAppendingPathComponent:plistFileName];
    NSPropertyListFormat format;
    NSString *errorDesc;
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *settings = (NSDictionary *)[NSPropertyListSerialization
                                              propertyListFromData:plistXML
                                              mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                              format:&format
                                              errorDescription:&errorDesc];
    NSDictionary *tables = [settings objectForKey:@"FileToTableMapping"];
    NSArray *fileArray = [tables allValues];
    for (NSString * docXMLSettingFileName in fileArray) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = [paths objectAtIndex:0];
        NSString *docXMLSettingFilesPath = [[NSBundle mainBundle] pathForResource:docXMLSettingFileName ofType:@"xml"];
        NSString *temp=[docXMLSettingFileName stringByAppendingString:@".xml"];
        NSString *destPath=[libraryDirectory stringByAppendingPathComponent:temp];
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:destPath error:&error];
        [[NSFileManager defaultManager] copyItemAtPath:docXMLSettingFilesPath toPath:destPath error:&error];
    }
}

- (IBAction)UpdateVersion:(id)sender {
    [self hasUpdateVersion];
}
- (void)hasUpdateVersion{
    __weak typeof(self)weakself = self;
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *currentBulidVersion = infoDic[@"CFBundleVersion"];
    //蒲公英的apikey，appkey
    NSDictionary *paramDic = @{@"_api_key":@"d98734ffcbcb99a86ff217e63c46ecfe",@"appKey":@"b5993ef24112dc7cd48ce084a4cc289e"};
    [self loadUpdateWithDic:paramDic success:^(id response) {
        NSLog(@"更新信息");
        if ([currentBulidVersion integerValue] < [response[@"data"][@"buildVersionNo"]integerValue]) {
            //如果当前手机安装app的版本号不是蒲公英上最新打包的版本号，则提示更新
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"版本更新" message:@"检测到新版本,是否更新?\n更新之前请上传数据，以防数据丢失！"  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [ac addAction:cancelAction];
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //                NSURL *url = [NSURL URLWithString:response[@"data"][@"buildShortcutUrl"]];
                //                [[UIApplication sharedApplication] openURL:url];
                //                data =     {
                //                    buildBuildVersion = 2;
                //                    buildHaveNewVersion = 1;
                //                    buildShortcutUrl = "https://www.pgyer.com/HbOA";
                //                    buildUpdateDescription = "\U6700\U65b0\U7248\U672c\U6d4b\U8bd5";
                //                    buildVersion = 2018092901;
                //                    buildVersionNo = 2018092901;
                //                    downloadURL = "itms-services://?action=download-manifest&url=https://www.pgyer.com/app/plist/e649cd191f07632c94c628774b91f0d5/update/s.plist";
                //                };
                NSURL *url = [NSURL URLWithString:response[@"data"][@"downloadURL"]];
                [[UIApplication sharedApplication] openURL:url];
            }];
            [ac addAction:doneAction];
            [weakself presentViewController:ac animated:YES completion:nil];
        }
        else if ([currentBulidVersion integerValue] >=[response[@"data"][@"buildVersionNo"]integerValue]){
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"版本更新" message:@"检测到已是z最新版本"  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [ac addAction:cancelAction];
            [weakself presentViewController:ac animated:YES completion:nil];
        }
    }];
}
- (void)loadUpdateWithDic:(NSDictionary *)dic success:(void(^)(id response))success {
    [LCNetworking PostWithURL:@"https://www.pgyer.com/apiv2/app/check" Params:dic success:^(NSDictionary *responseObject) {
        NSLog(@"POST_success____%@", responseObject);
        success(responseObject);
    } failure:^(NSString *error) {
        NSLog(@"POST_failure____%@", error);
    }];
}
@end
