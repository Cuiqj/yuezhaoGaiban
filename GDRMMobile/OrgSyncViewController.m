//
//  OrgSyncViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-15.
//
//

#import "OrgSyncViewController.h"
#import "AGAlertViewWithProgressbar.h"
#import "OrgInfo.h"
#import "HomePageController.h"


@interface OrgSyncViewController ()
@property (nonatomic,retain) NSArray *data;
- (void)downLoadFinished;
- (void)getOrgList;
@end
NSString  *my_org_id;
@implementation OrgSyncViewController
@synthesize textServerAddress = _textServerAddress;
@synthesize dataDownLoader    = _dataDownLoader;
@synthesize data              = _data;
@synthesize tableOrgList      = _tableOrgList;


- (void)awakeFromNib{
    [super awakeFromNib];
    self.preferredContentSize = CGSizeMake(540.0, 620.0);
}
- (DataDownLoad *)dataDownLoader{
    _dataDownLoader = nil;
    if (_dataDownLoader == nil) {
        _dataDownLoader = [[DataDownLoad alloc] init];
    }
    return _dataDownLoader;
}

- (void)viewDidLoad
{
//    self.versionName.text = VERSION_NAME;
//    self.versionTime.text = VERSION_TIME;
    self.textServerAddress.text = [[AppDelegate App] serverAddress];
    NSMutableArray * mutablearray =[NSMutableArray arrayWithArray:[OrgInfo allOrgInfo]] ;
    NSInteger count = [mutablearray count];
    NSMutableArray * tmp = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger i = 0;i < count; i++) {
        OrgInfo * org = mutablearray[i];
        if([org.orgname containsString:@"广肇"]){
            [tmp addObject:org];
        }
    }
    self.data = [NSArray arrayWithArray:tmp];
//    self.data = [OrgInfo allOrgInfo];
    //若本机无机构信息，则从服务器获取
    if (self.data.count == 0) {
        [self getOrgList];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.dataDownLoader = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DOWNLOADFINISHNOTI object:nil];
    if([self.delegate isKindOfClass:[HomePageController class]]){
        [self.delegate pushLoginView];
    }
}

- (void)viewDidUnload
{
    [self setTextServerAddress:nil];
    [self setDataDownLoader:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self setVersionName:nil];
//    [self setVersionTime:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


- (IBAction)setCurrentOrg:(UIBarButtonItem *)sender {
     NSIndexPath *indexPath=[self.tableOrgList indexPathForSelectedRow];
    if (indexPath) {
        NSString *orgID = [[self.data objectAtIndex:indexPath.row] valueForKey:@"myid"];
        [[NSUserDefaults standardUserDefaults] setValue:orgID forKey:ORGKEY] ;
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = [paths objectAtIndex:0];
        NSString *plistFileName = @"Settings.plist";
        NSString *plistPath = [libraryDirectory stringByAppendingPathComponent:plistFileName];
        NSDictionary *serverSettingsDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: self.textServerAddress.text, [AppDelegate App].fileAddress, nil]
                                                                       forKeys:[NSArray arrayWithObjects: @"server address", @"file address", nil]];
        NSPropertyListFormat format;
        NSString *errorDesc = nil;
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSMutableDictionary *plistDict = [[NSPropertyListSerialization
                                           propertyListFromData:plistXML
                                           mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                           format:&format
                                           errorDescription:&errorDesc] mutableCopy];
        [plistDict setObject:serverSettingsDict forKey:@"Server Settings"];
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                       format:NSPropertyListXMLFormat_v1_0
                                                             errorDescription:&error];
        
        if ([[NSFileManager defaultManager] isWritableFileAtPath:plistPath]) {
            if(plistData) {
                [plistData writeToFile:plistPath atomically:YES];
            }
        }
        [AppDelegate App].serverAddress=self.textServerAddress.text;
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:orgID forKey:ORGKEY] ;
        [defaults synchronize];
        [self.dataDownLoader startDownLoad:orgID];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinished) name:DOWNLOADFINISHNOTI object:nil];
    }else{
        void(^ShowAlert)(void)=^(void){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"请先选择所属机构，再开始同步基础数据。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        };
        MAINDISPATCH(ShowAlert);
    }
}
- (IBAction)showServerAddress:(UIBarButtonItem *)sender {
    if (self.tableOrgList.frame.origin.y<100) {
        sender.title=@"确定地址";
        [UIView transitionWithView:self.tableOrgList
                          duration:0.5
                           options:UIViewAnimationCurveEaseInOut
                        animations:^{
                            self.tableOrgList.frame = CGRectMake(0, 226, 540, 374);
                        }
                        completion:nil];
        
    } else {
        sender.title=@"设置服务器地址";
        [UIView transitionWithView:self.tableOrgList duration:0.5 options:UIViewAnimationCurveEaseInOut  animations:^{
            self.tableOrgList.frame = CGRectMake(0, 44, 540, 556);
        }completion:^(BOOL finished){
            if (![self.textServerAddress.text isEqualToString:[[AppDelegate App] serverAddress]]) {
                NSString *error;
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
                NSString *libraryDirectory       = [paths objectAtIndex:0];
                NSString *plistFileName          = @"Settings.plist";
                NSString *plistPath              = [libraryDirectory stringByAppendingPathComponent:plistFileName];
                NSDictionary *serverSettingsDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: self.textServerAddress.text, [AppDelegate App].fileAddress, nil] forKeys:[NSArray arrayWithObjects: @"server address", @"file address", nil]];
                NSPropertyListFormat format;
                NSString *errorDesc            = nil;
                NSData *plistXML               = [[NSFileManager defaultManager] contentsAtPath:plistPath];
                NSMutableDictionary *plistDict = [[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves  format:&format errorDescription:&errorDesc] mutableCopy];
                [plistDict setObject:serverSettingsDict forKey:@"Server Settings"];
                NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
                                
                if ([[NSFileManager defaultManager] isWritableFileAtPath:plistPath]) {
                    if(plistData) {
                        [plistData writeToFile:plistPath atomically:YES];
                    }
                }
                [AppDelegate App].serverAddress = self.textServerAddress.text;
            }
            [self getOrgList];
                            
        }];
    }
}

- (void)downLoadFinished{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell                            = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=[[self.data objectAtIndex:indexPath.row] valueForKey:@"orgname"];
    //    cell.detailTextLabel.text=[[self.data objectAtIndex:indexPath.row] valueForKey:@"orgshortname"];
    return cell;
}

- (void)getOrgList {
    NSOperationQueue *myqueue=[[NSOperationQueue alloc] init];
    [myqueue setMaxConcurrentOperationCount:1];
    NSBlockOperation *clearTable=[NSBlockOperation blockOperationWithBlock:^{
        [self setData:nil];
        [self.tableOrgList reloadData];
        [[AppDelegate App] clearEntityForName:@"OrgInfo"];
    }];
    [myqueue addOperation:clearTable];
    if ([WebServiceHandler isServerReachable]) {
        NSBlockOperation * getOrgInfo=[NSBlockOperation blockOperationWithBlock:^{
            WebServiceHandler *web = [[WebServiceHandler alloc] init];
            web.delegate           = self;
            [web getOrgInfo];
        }];
        [getOrgInfo addDependency:clearTable];
        [myqueue addOperation:getOrgInfo];
    }
}
- (void)getWebServiceReturnString:(NSString *)webString forWebService:(NSString *)serviceName{
    void(^OrgInfoParser)(void)=(^(void){
        NSError *error;
        TBXML *tbxml=[TBXML newTBXMLWithXMLString:webString error:&error];
        TBXMLElement *root = tbxml.rootXMLElement;
        TBXMLElement *Envelope=[TBXML childElementNamed:@"soap:Envelope" parentElement:root];
        TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
        TBXMLElement *DownloadDataSetResponse=[TBXML childElementNamed:@"DownloadDataSetResponse" parentElement:rf];
        TBXMLElement *DownloadDataSetResult=[TBXML childElementNamed:@"DownloadDataSetResult" parentElement:DownloadDataSetResponse];
        TBXMLElement *diffgram=[TBXML childElementNamed:@"diffgr:diffgram" parentElement:DownloadDataSetResult];
        TBXMLElement *NewDataSet=[TBXML childElementNamed:@"NewDataSet" parentElement:diffgram];
        TBXMLElement *author=[TBXML childElementNamed:@"Table" parentElement:NewDataSet];
        while (author) {
            @autoreleasepool {
                TBXMLElement *orgid=[TBXML childElementNamed:@"id" parentElement:author];
                if (orgid!=nil){
                    NSString *orgid_string=[TBXML textForElement:orgid];
                    TBXMLElement *belongtoOrgCode=[TBXML childElementNamed:@"code" parentElement:author];
                    NSString *belongtoOrgCode_string=[TBXML textForElement:belongtoOrgCode];
                    TBXMLElement *orgName=[TBXML childElementNamed:@"name" parentElement:author];
                    NSString *orgName_string=[TBXML textForElement:orgName];
                    TBXMLElement *orgShortName=[TBXML childElementNamed:@"short_name" parentElement:author];
                    NSString *orgShortName_string=[TBXML textForElement:orgShortName];
                    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
                    NSEntityDescription *entity=[NSEntityDescription entityForName:@"OrgInfo" inManagedObjectContext:context];
                    OrgInfo *newOrgInfo=[[OrgInfo alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
                    newOrgInfo.myid           = orgid_string;
                    newOrgInfo.belongtoorg_id = belongtoOrgCode_string;
                    newOrgInfo.orgname        = orgName_string;
                    newOrgInfo.orgshortname   = orgShortName_string;
                    [[AppDelegate App] saveContext];
                }
            }
            author = author->nextSibling;
        }
    });
    NSBlockOperation *parser=[NSBlockOperation blockOperationWithBlock:OrgInfoParser];
    NSOperationQueue *myqueue=[[NSOperationQueue alloc] init];
    [myqueue setMaxConcurrentOperationCount:1];
    [myqueue addOperation:parser];
    NSBlockOperation *reloadData=[NSBlockOperation blockOperationWithBlock:^{
        NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"OrgInfo" inManagedObjectContext:context];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"orgname CONTAINS %@",@"广肇"];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:predicate];
        self.data=[context executeFetchRequest:fetchRequest error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableOrgList reloadData];
        });
    }];
    [reloadData addDependency:parser];
    [myqueue addOperation:reloadData];
}
@end
