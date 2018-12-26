//
//  CaseCountPrintViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 13-1-4.
//
//

#import "CaseCountPrintViewController.h"
#import "CaseInfo.h"
#import "Citizen.h"
#import "CaseDeformation.h"
#import "CaseProveInfo.h"
#import "NSNumber+NumberConvert.h"
#import "CaseCount.h"
#import "AppDelegate.h"

static NSString * xmlName = @"CaseCountTable";

@interface CaseCountPrintViewController ()
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) CaseCount *caseCount;
@end

@implementation CaseCountPrintViewController
@synthesize caseID = _caseID;
@synthesize data = _data;
@synthesize caseCount = _caseCount;

-(void)viewDidLoad{
    [super setCaseID:self.caseID];
    
    NSString * strtemp = [[AppDelegate App] serverAddress];
    
    if ([strtemp isEqualToString:@"http://219.131.172.163:81/irmsdatagy/"]) {
        xmlName = @"GYCaseCountTable";
    }
    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_SMALL_WIDTH, VIEW_SMALL_HEIGHT);
    self.view.frame = viewFrame;
    if (![self.caseID isEmpty]) {
        [self pageLoadInfo];
    }
    [super viewDidLoad];
}

- (void)pageLoadInfo{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    //CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
    Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年M月d日HH时mm分"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    self.labelCaseAddress.text = caseInfo.service_position;
    self.labelHappenTime.text = [dateFormatter stringFromDate:caseInfo.happen_date];
    if (citizen) {
        self.labelParty.text = [NSString stringWithFormat:@"%@ %@", (citizen.org_name ? citizen.org_name : @""), citizen.party];
        self.labelAutoNumber.text = citizen.automobile_number;
        self.labelAutoPattern.text = citizen.automobile_pattern;
        self.labelTele.text = citizen.tel_number;
    }
    self.data = [[CaseDeformation deformationsForCase:self.caseID forCitizen:citizen.automobile_number] mutableCopy];
    [self.tableCaseCountDetail reloadData];
    double summary=[[self.data valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
    self.labelPayReal.text = [NSString stringWithFormat:@"%.2f",summary];
    self.textBigNumber.text = [[NSNumber numberWithDouble:summary] numberConvertToChineseCapitalNumberString];
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseCount" inManagedObjectContext:context];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id ==%@",self.caseID];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray *caseCounts =[context executeFetchRequest:fetchRequest error:nil];
    if (caseCounts && [caseCounts count] > 0) {
        self.caseCount = caseCounts[0];
        self.textRemark.text = self.caseCount.casedeformation_remark;
    }else {
        self.caseCount = [[CaseCount alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        self.caseCount.caseinfo_id = self.caseID;
    }
    if ([self.textRemark.text isEmpty]) {
        self.textRemark.text = @"无";
        
    }
}

- (void)pageSaveInfo{
    Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
    citizen.org_full_name = self.labelParty.text;
    
    self.caseCount.citizen_name = self.labelParty.text;
    self.caseCount.sum = [NSNumber numberWithDouble:[[NSString stringWithString:self.labelPayReal.text] doubleValue]];
    self.caseCount.chinese_sum = [[NSNumber numberWithDouble:[self.caseCount.sum doubleValue]] numberConvertToChineseCapitalNumberString];
    self.caseCount.case_count_list = [NSArray arrayWithArray:self.data];
    self.caseCount.casedeformation_remark = self.textRemark.text;
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    caseInfo.casedeformation_remark = self.caseCount.casedeformation_remark;
    [[AppDelegate App] saveContext];
}

//根据记录，完整默认值信息
- (void)generateDefaultInfo:(CaseDeformation  *)caseCount{}

- (NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:xmlName];
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
        [self drawDateTable:xmlName withDataModel:caseInfo];
        [self drawDateTable:xmlName withDataModel:citizen];
        [self drawDateTable:xmlName withDataModel:self.caseCount];
        [self renderRemark];
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}
-(void)renderRemark{
    NSDictionary *remark = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSDictionary dictionaryWithObjectsAndKeys:self.textRemark.text,@"value",@(NSStringAttributeType),@"valueType",nil],
                             @"remark",nil],
                            @"Default",nil];
    [self drawDataTable:xmlName withDataInfo:remark];
}
- (NSURL *)toFormedPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
        [self drawDateTable:xmlName withDataModel:caseInfo];
        [self drawDateTable:xmlName withDataModel:citizen];
        [self drawDateTable:xmlName withDataModel:self.caseCount];
        [self renderRemark];
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:formatFilePath];
    } else {
        return nil;
    }
}


- (void)viewDidUnload {
    [self setLabelHappenTime:nil];
    [self setLabelCaseAddress:nil];
    [self setLabelParty:nil];
    [self setLabelTele:nil];
    [self setLabelAutoPattern:nil];
    [self setLabelAutoNumber:nil];
    [self setTableCaseCountDetail:nil];
    [self setTextBigNumber:nil];
    [self setLabelPayReal:nil];
    [self setTextRemark:nil];
    [super viewDidUnload];
}

-(void)reloadDataArray{
    [self.tableCaseCountDetail reloadData];
    double summary=[[self.data valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
    self.labelPayReal.text = [NSString stringWithFormat:@"%.2f",summary];
    NSNumber *sumNum = @(summary);
    NSString *numString = [sumNum numberConvertToChineseCapitalNumberString];
    self.textBigNumber.text = numString;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CaseCountDetailCell";
    CaseCountDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CaseDeformation *caseDeformation = [self.data objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.labelAssetName.text = caseDeformation.roadasset_name;
    //cell.labelAssetSize.text = caseDeformation.rasset_size;
    
    if ([caseDeformation.unit rangeOfString:@"米"].location != NSNotFound) {
        cell.labelQunatity.text=[NSString stringWithFormat:@"%.2f",caseDeformation.quantity.doubleValue];
    } else {
        cell.labelQunatity.text=[NSString stringWithFormat:@"%d",caseDeformation.quantity.integerValue];
    }
    cell.labelAssetUnit.text = caseDeformation.unit;
    cell.labelPrice.text = [NSString stringWithFormat:@"%.2f元",caseDeformation.price.floatValue];
    cell.labelTotalPrice.text = [NSString stringWithFormat:@"%.2f元",caseDeformation.total_price.floatValue];
    cell.labelRemark.text = caseDeformation.remark;
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
 
//删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CaseCountDetail *caseCountDetail = [self.data objectAtIndex:indexPath.row];
        [[[AppDelegate App] managedObjectContext] deleteObject:caseCountDetail];
        [self.data removeObjectAtIndex:indexPath.row];
        [[AppDelegate App] saveContext];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        double summary=[[self.data valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
        self.labelPayReal.text = [NSString stringWithFormat:@"%.2f",summary];
        NSNumber *sumNum = @(summary);
        NSString *numString = [sumNum numberConvertToChineseCapitalNumberString];
        self.textBigNumber.text = numString;
    }
     */
}
     

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"toCaseCountDetailEditor" sender:[self.data objectAtIndex:indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toCaseCountDetailEditor"]) {
        CaseCountDetailEditorViewController *ccdeVC = [segue destinationViewController];
        ccdeVC.caseID = self.caseID;
        ccdeVC.countDetail = sender;
        ccdeVC.delegate = self;
    }
}

- (void)generateDefaultAndLoad{
    //[self generateDefaultInfo:self.caseCount];
    [self pageLoadInfo];
}

- (void)deleteCurrentDoc{
}
@end
