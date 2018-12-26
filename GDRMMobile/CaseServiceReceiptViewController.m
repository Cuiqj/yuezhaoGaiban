//
//  CaseServiceReceiptViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-24.
//
//

#import "CaseServiceReceiptViewController.h"
#import "ServiceFileCell.h"
#import "CaseInfo.h"
#import "Citizen.h"
#import "CaseProveInfo.h"
#import "CaseServiceFiles.h"
#import "OrgInfo.h"
#import "UserInfo.h"

static NSString * const xmlName = @"ServiceReceiptTable";
@interface CaseServiceReceiptViewController ()
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) CaseServiceReceipt *caseServiceReceipt;
@end

@implementation CaseServiceReceiptViewController

- (void)viewDidLoad
{
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_SMALL_WIDTH, VIEW_SMALL_HEIGHT);
    self.view.frame = viewFrame;
    if (![self.caseID isEmpty]) {
        self.caseServiceReceipt = [CaseServiceReceipt caseServiceReceiptForCase:self.caseID];
        if (self.caseServiceReceipt == nil) {
            self.caseServiceReceipt = [CaseServiceReceipt newCaseServiceReceiptForCase:self.caseID];
            [self generateDefaultInfo:self.caseServiceReceipt];
        }
        [self pageLoadInfo];
    }
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)pageLoadInfo{
    //案号
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
    Citizen *citizen = [Citizen citizenForCitizenName:proveInfo.citizen_name nexus:@"当事人" case:self.caseID];
    self.textMark2.text = caseInfo.case_mark2;
    self.textMark3.text = caseInfo.full_case_mark3;
    self.textincepter_name.text = self.caseServiceReceipt.incepter_name;
    self.textreason.text = [NSString stringWithFormat:@"%@%@因交通事故%@", citizen.automobile_number, citizen.automobile_pattern, proveInfo.case_short_desc];
    self.textservice_company.text = self.caseServiceReceipt.service_company;
    self.textservice_address.text = self.caseServiceReceipt.service_position;
    self.textremark.text = self.caseServiceReceipt.remark;
    self.data = [NSMutableArray arrayWithArray:[CaseServiceFiles caseServiceFilesForCaseServiceReceipt:self.caseServiceReceipt.myid]];
//    if ([self.data count] == 0) {
//        CaseServiceFiles *defaultServiceFile1 = [CaseServiceFiles newCaseServiceFilesForID:self.caseID];
//        defaultServiceFile1.service_file = DOC_TEMPLATES_FULLNAME_ARRAY[DEFAULT_SERVICE_FILE1_INDEX];
//        CaseServiceFiles *defaultServiceFile2 = [CaseServiceFiles newCaseServiceFilesForID:self.caseID];
//        defaultServiceFile2.service_file = DOC_TEMPLATES_FULLNAME_ARRAY[DEFAULT_SERVICE_FILE2_INDEX];
//        [[AppDelegate App] saveContext];
//        [self.data addObject:defaultServiceFile1];
//        [self.data addObject:defaultServiceFile2];
//    }
}

- (void)pageSaveInfo{
    CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
    proveInfo.case_long_desc = self.textreason.text;
    self.caseServiceReceipt.incepter_name = self.textincepter_name.text;
    self.caseServiceReceipt.service_company = self.textservice_company.text;
    self.caseServiceReceipt.service_position = self.textservice_address.text;
    self.caseServiceReceipt.remark = self.textremark.text;

	[[AppDelegate App] saveContext];
}


- (IBAction)btnAddNew:(id)sender {
    if ([self.caseID isEmpty]) {
        return;
    }
    ServiceFileEditorViewController *sfeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ServiceFileEditor"];
    sfeVC.delegate = self;
    sfeVC.caseID = self.caseID;
    sfeVC.file = nil;
    sfeVC.modalPresentationStyle = UIModalPresentationFormSheet;
    sfeVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:sfeVC animated:YES];
}

-(void)reloadDataArray{
    self.data = [[CaseServiceFiles caseServiceFilesForCase:self.caseID] mutableCopy];
    [self.tableDetail reloadData];
}

//根据记录，完整默认值信息
- (void)generateDefaultInfo:(CaseServiceReceipt *)caseServiceReceipt{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
    caseServiceReceipt.incepter_name=citizen.party;
    caseServiceReceipt.isuploaded = (@NO);
    caseServiceReceipt.service_position = caseInfo.service_position;
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    caseServiceReceipt.service_company = [[OrgInfo orgInfoForOrgID:[UserInfo userInfoForUserID:currentUserID].organization_id] valueForKey:@"orgname"];
    
    //删掉已有送达文书
    NSArray *oldFilesArray = [CaseServiceFiles caseServiceFilesForCase:caseInfo.myid];
    for (CaseServiceFiles *oldFile in oldFilesArray) {
        [[[AppDelegate App] managedObjectContext] deleteObject:oldFile];
    }
    [CaseServiceFiles addDefaultCaseServiceFilesForCase:self.caseID forCaseServiceReceipt:caseServiceReceipt.myid];
    [[AppDelegate App] saveContext];
    [self reloadDataArray];
}

- (NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:xmlName];
        [self drawDateTable:xmlName withDataModel:self.caseServiceReceipt];
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

- (NSURL *)toFormedPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        //[self drawStaticTable:xmlName];
        [self drawDateTable:xmlName withDataModel:self.caseServiceReceipt];
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:formatFilePath];
    } else {
        return nil;
    }
}

- (void)viewDidUnload {
    [self setTableDetail:nil];
    [super viewDidUnload];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ServiceFileCell";
    ServiceFileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CaseServiceFiles *serviceFile = [self.data objectAtIndex:indexPath.row];
    cell.labelFileName.text = serviceFile.service_file;
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CaseServiceFiles *caseServiceFiles = [self.data objectAtIndex:indexPath.row];
        [[[AppDelegate App] managedObjectContext] deleteObject:caseServiceFiles];
        [self.data removeObjectAtIndex:indexPath.row];
        [[AppDelegate App] saveContext];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"toServiceFileEditor" sender:[self.data objectAtIndex:indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toServiceFileEditor"]) {
        ServiceFileEditorViewController *sfeVC = [segue destinationViewController];
        sfeVC.caseID = self.caseID;
        sfeVC.file = sender;
        sfeVC.delegate = self;
    }
}

- (void)generateDefaultAndLoad{
    [self generateDefaultInfo:self.caseServiceReceipt];
    [self pageLoadInfo];
}

- (void)deleteCurrentDoc{
    if (![self.caseID isEmpty] && self.caseServiceReceipt){
        [[[AppDelegate App] managedObjectContext] deleteObject:self.caseServiceReceipt];
        for (CaseServiceFiles *csf in self.data) {
            [[[AppDelegate App] managedObjectContext] deleteObject:csf];
        }
        [[AppDelegate App] saveContext];
        self.caseServiceReceipt = nil;
        [self.data removeAllObjects];
    }
}
@end
